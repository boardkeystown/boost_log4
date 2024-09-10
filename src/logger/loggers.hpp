#pragma once
#define BOOST_ALL_DYN_LINK
#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wattributes"
#include <boost/log/sinks.hpp>
#pragma GCC diagnostic pop
#include <boost/log/sinks/text_file_backend.hpp>
#include <boost/log/sources/global_logger_storage.hpp>
#include <boost/log/sources/severity_channel_logger.hpp>
#include <boost/log/sources/severity_feature.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/support/date_time.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/log/utility/setup/file.hpp>


#include "custom_log_level.hpp"

namespace loggers {

typedef boost::log::sinks::synchronous_sink<boost::log::sinks::text_file_backend>
    File_Sink_T;

extern boost::shared_ptr<File_Sink_T> my_logger_sink;
BOOST_LOG_GLOBAL_LOGGER(my_logger, boost::log::sources::severity_channel_logger_mt<custom_log_level>);

extern boost::shared_ptr<File_Sink_T> my_logger2_sink;
BOOST_LOG_GLOBAL_LOGGER(my_logger2, boost::log::sources::severity_channel_logger_mt<custom_log_level>);
void set_logger2_level(custom_log_level level);


}
