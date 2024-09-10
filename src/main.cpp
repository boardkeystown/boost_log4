#include "logger/loggers.hpp"

int main() {
    BOOST_LOG_SEV(loggers::my_logger::get(),loggers::custom_log_level::normal) << "test";

    BOOST_LOG_SEV(loggers::my_logger2::get(),loggers::custom_log_level::normal) << "only in log2";


    loggers::set_logger2_level(loggers::custom_log_level::off);
    BOOST_LOG_SEV(loggers::my_logger::get(),loggers::custom_log_level::normal) << "we see this in log 1";
    BOOST_LOG_SEV(loggers::my_logger2::get(),loggers::custom_log_level::normal) << "we do not this this in log 2";

    return 0;
}


