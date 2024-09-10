# Disable all implicit rules
.SUFFIXES:

# Compiler and Linker
CXX :=g++
# Compiler and linker flags
# CXXFLAGS := -std=c++17 -Wall -Wextra -Werror -Og -g -pipe -Wall -fPIC -MMD -MP
# CXXFLAGS := -std=c++17 -Wall -Wextra -O0 -g -pipe -fPIC -MMD -MP
#CXXFLAGS := -std=c++17 -Wall -Wextra -Og -g -pipe -fPIC -MMD -MP -fuse-ld=gold
#CXXFLAGS := -std=c++17 -Wall -Wextra -Werror -Og -g -pipe -fPIC -MMD -MP
# for dr meme check build
#CXXFLAGS := -std=c++17 -Wall -Wextra -Werror -O0 -g -pipe -fPIC -MMD -MP -static-libgcc -static-libstdc++ -ggdb -fno-omit-frame-pointer -gdwarf-2

# ok this will enable safe functions even not in debug mode, sick ! 
#CXXFLAGS := -std=c++17 -DSOL_SAFE_FUNCTION_CALLS -Wall -Wextra -Werror -Og -g -pipe -fPIC -MMD -MP

#CXXFLAGS := -std=c++17 -Wall -Wextra -Werror -Og -g -pipe -fPIC -MMD -MP

REL ?= rel
ifeq ($(REL),rel)
CXXFLAGS := -std=c++17 -Wall -Og -g -pipe -fPIC -MMD -MP -fno-strict-aliasing
else ifeq ($(REL),gdb)
CXXFLAGS := -std=c++17 -Wall -Wextra -Werror -O0 -g -pipe -fPIC -MMD -MP 
else ifeq ($(REL),drmem)
CXXFLAGS := -std=c++17 -Wall -Wextra -Werror -O0 -ggdb \
            -fno-omit-frame-pointer -gdwarf-4 -pipe -fPIC \
            -MMD -MP -static-libgcc -static-libstdc++
endif

CXXLDFLAGS := #

# artifacts structure and sources
PROJECT_DIR :=$(CURDIR)
MAIN_DIR    :=$(PROJECT_DIR)/src
OBJECTS_DIR :=$(PROJECT_DIR)/objects
BIN_DIR     :=$(PROJECT_DIR)/bin

# targets
MAIN_TARGET_BASENAME :=main
MAIN_TARGET :=$(BIN_DIR)/$(MAIN_TARGET_BASENAME).exe

# make folder if not created
define WIN_MKDIR
$(shell powershell -Command "if (-not (Test-Path $(1))) { New-Item $(1) -Type Directory }")
endef
_MK_DIRS := $(call WIN_MKDIR, $(OBJECTS_DIR)) \
            $(call WIN_MKDIR, $(BIN_DIR))

define FIND_DIRS
$(shell powershell -Command "(Get-ChildItem -Path $(1) -Recurse -Directory | ForEach-Object { $$_.FullName }) -join ':' -replace '\\','/'")
endef

VPATH :=$(PROJECT_DIR):\
        $(MAIN_DIR):\
        $(call FIND_DIRS, $(MAIN_DIR)):\
        $(OBJECTS_DIR)\

BOOST_INC     :=D:/Cpp/boost_1_83_0_install/include/boost-1_83
BOOST_FLAGS   :=-I$(BOOST_INC)
BOOST_LIB     :=D:/Cpp/boost_1_83_0_install/lib
# list them as -static
BOOST_LDFLAGS := -Wl,-rpath,$(BOOST_LIB) -L$(BOOST_LIB)


BOOST_LIBS    :=-lboost_log_setup-mgw13-mt-x64-1_83 \
                -lboost_log-mgw13-mt-x64-1_83 \
                -lboost_thread-mgw13-mt-x64-1_83 \
                -lboost_filesystem-mgw13-mt-x64-1_83 \
                -lboost_system-mgw13-mt-x64-1_83

MSYS2_INC :=C:/msys64/mingw64/include
MSYS2_FLAGS :=-I$(MSYS2_INC)

CXXFLAGS   +=-I$(MAIN_DIR) \
              $(MSYS2_FLAGS) \
              $(BOOST_FLAGS)

CXXLDFLAGS +=$(BOOST_LDFLAGS) $(BOOST_LIBS) \
             -lm -lpthread
# Bdynamic tells them to go back


# cpp src
define RWILDCARD
$(foreach d,$(wildcard $(1:=/*)),$(call RWILDCARD,$(d),$(2))$(filter $(subst *,%,$(2)),$(d)))
endef

SOURCES_CPP      := $(call RWILDCARD,$(MAIN_DIR),*.cpp)
OBJECTS_CPP      := $(addprefix $(OBJECTS_DIR)/,$(notdir $(SOURCES_CPP:.cpp=.o)))

MAIN_CPP         := $(filter-out %table.cpp %hoot.cpp,$(SOURCES_CPP))
MAIN_CPP_OBJECTS := $(addprefix $(OBJECTS_DIR)/,$(notdir $(MAIN_CPP:.cpp=.o)))

.PHONY: default info clean

default: $(MAIN_TARGET)

$(MAIN_TARGET): $(MAIN_CPP_OBJECTS)
	$(CXX) -o $@ $^ $(CXXLDFLAGS)

$(OBJECTS_DIR)/%.o:%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

info:
	@echo "[ $(VPATH) ]"
	@echo ------------
	@echo $(CXX)

define RM_RFV # yes I know this is cursed but no "$> rm -prv" on windows
    @powershell -Command "\
    $$file=\"$(1)\";\
    if (-not (Test-Path -Path $$file)) {\
        Write-Host \"does not not exits: $$file\" -ForegroundColor Yellow;\
    } else {\
        Get-ChildItem -Path $$file| ForEach-Object {\
            if (Test-Path -Path $$_.FullName) {\
                Write-Host \"Removing: $$_\" -Foreground Red;\
                Remove-Item -Path $$_.FullName -Force;\
            } else {\
                Write-Host \"does not not exits: $$_\" -Foreground Yellow;\
            }\
        }\
    }\
"
endef

clean:
	$(call RM_RFV,$(OBJECTS_DIR)/*)
	$(call RM_RFV,$(MAIN_TARGET))

DEPENDENCIES :=$(wildcard $(OBJECTS_DIR)/*.d)
-include $(DEPENDENCIES)
