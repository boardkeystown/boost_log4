#pragma once
#include <ostream>
namespace loggers {
    enum class custom_log_level {
        off,
        normal,
        notification,
        warning,
        error,
        critical
    };
    std::ostream &operator<< (std::ostream& strm, custom_log_level level);
}