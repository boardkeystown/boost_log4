#include "loggers.hpp"
#include <boost/log/utility/setup/file.hpp>


namespace loggers {

boost::shared_ptr<File_Sink_T> my_logger_sink;

BOOST_LOG_GLOBAL_LOGGER_INIT(my_logger, boost::log::sources::severity_channel_logger_mt<custom_log_level>) {
    boost::log::sources::severity_channel_logger_mt<custom_log_level> logger(
        boost::log::keywords::channel = "my_logger"
    );
    my_logger_sink = boost::log::add_file_log(
        boost::log::keywords::file_name = "my_logger.log"
    );
    my_logger_sink->set_formatter(
        boost::log::expressions::stream
            << boost::log::expressions::attr< custom_log_level >("Severity")
            << " - "
            << boost::log::expressions::smessage
    );
    my_logger_sink->set_filter(
        boost::log::expressions::attr<std::string>("Channel") == "my_logger" &&
        boost::log::expressions::attr<custom_log_level>("Severity") <= custom_log_level::normal
    );
    boost::log::core::get()->add_sink(my_logger_sink);
    return logger;
}

boost::shared_ptr<File_Sink_T> my_logger2_sink;

BOOST_LOG_GLOBAL_LOGGER_INIT(my_logger2, boost::log::sources::severity_channel_logger_mt<custom_log_level>) {
    boost::log::sources::severity_channel_logger_mt<custom_log_level> logger(
        boost::log::keywords::channel = "my_logger2"
    );
    my_logger2_sink = boost::log::add_file_log(
        boost::log::keywords::file_name = "my_logger2.log"
    );
    my_logger2_sink->set_formatter(
        boost::log::expressions::stream
            << boost::log::expressions::attr< custom_log_level >("Severity")
            << " - "
            << boost::log::expressions::smessage
    );
    my_logger2_sink->set_filter(
        boost::log::expressions::attr<std::string>("Channel") == "my_logger2" &&
        boost::log::expressions::attr<custom_log_level>("Severity") <= custom_log_level::normal
    );
    boost::log::core::get()->add_sink(my_logger2_sink);
    return logger;
}
void set_logger2_level(custom_log_level level) {
    if (level == custom_log_level::off) {
        my_logger2_sink->set_filter(
            boost::log::expressions::attr<std::string>("Channel") == "my_logger2" &&
            boost::log::expressions::attr<custom_log_level>("Severity") == level
        );
    } else {
        my_logger2_sink->set_filter(
            boost::log::expressions::attr<std::string>("Channel") == "my_logger2" &&
            boost::log::expressions::attr<custom_log_level>("Severity") <= level
        );
    }
}

}
