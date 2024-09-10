#include "custom_log_level.hpp"

namespace loggers {

std::ostream &operator<< (std::ostream& strm, custom_log_level level) {
    static const char* strings[] = {
        "off",
        "normal",
        "notification",
        "warning",
        "error",
        "critical"
    };
    strm << "[" << strings[static_cast<int>(level)] << "]";
    return strm;
}

}