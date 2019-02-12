import ch.qos.logback.classic.Level
import ch.qos.logback.classic.filter.ThresholdFilter
import grails.util.BuildSettings
import grails.util.Environment

scan("10 seconds")

// See http://logback.qos.ch/manual/groovy.html for details on configuration
appender('STDOUT', ConsoleAppender) {
    encoder(PatternLayoutEncoder) {
        pattern = "%date %level %logger{10} - %msg%n"
    }
}

def targetDir = BuildSettings.TARGET_DIR

appender("FULL_STACKTRACE", RollingFileAppender) {

    file = "${targetDir}/logs/stacktrace.log"
    append = true
    encoder(PatternLayoutEncoder) {
        pattern = "%date %level %logger{10} - %msg%n"
    }
    rollingPolicy(TimeBasedRollingPolicy) {
        fileNamePattern = "${targetDir}/logs/stacktrace-%d{yyyy-MM-dd}.log"
        maxHistory = 30
    }
}

appender("ERROR_LOG", RollingFileAppender) {

    file = "${targetDir}/logs/foysonis-error.log"
    append = true
    encoder(PatternLayoutEncoder) {
        pattern = "%date %level %logger{10} - %msg%n"
    }
    filter(ThresholdFilter) {
        level = WARN
    }
    rollingPolicy(TimeBasedRollingPolicy) {
        fileNamePattern = "${targetDir}/logs/foysonis-error-%d{yyyy-MM-dd}.log"
        maxHistory = 30
    }
}

appender("INFO_LOG", RollingFileAppender) {

    file = "${targetDir}/logs/foysonis-info.log"
    append = true
    encoder(PatternLayoutEncoder) {
        pattern = "%date %level %logger{10} - %msg%n"
    }
    filter(ThresholdFilter) {
        level = INFO
    }
    rollingPolicy(TimeBasedRollingPolicy) {
        fileNamePattern = "${targetDir}/logs/foysonis-info-%d{yyyy-MM-dd}.log"
        maxHistory = 30
    }
}

appender("SQL_LOG", RollingFileAppender) {
    file = "${targetDir}/logs/foysonis-sql.log"
    append = true
    encoder(PatternLayoutEncoder) {
        pattern = "%date %level %logger{10} - %msg%n"
    }
    rollingPolicy(TimeBasedRollingPolicy) {
        fileNamePattern = "${targetDir}/logs/foysonis-sql-%d{yyyy-MM-dd}.log"
        maxHistory = 30
    }
}

root(ERROR, ["STDOUT", "ERROR_LOG", "FULL_STACKTRACE"])

//logger("grails.app", INFO, ['INFO_LOG', 'ERROR_LOG'], false)

logger("com.foysonis", INFO, ['INFO_LOG', 'ERROR_LOG'], false)

//logger("org.hibernate.SQL", DEBUG, ['SQL_LOG'], false)
