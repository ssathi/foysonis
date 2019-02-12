package com.foysonis.util

import org.slf4j.Logger
import org.slf4j.LoggerFactory

class FoysonisLogger {

    static Logger log = LoggerFactory.getLogger(FoysonisLogger.class)

    private static Boolean isLogEnabled;

    private FoysonisLogger(Boolean isLog) {
        isLogEnabled = isLog
    }

    public static FoysonisLogger getLogger(Class<?> clazz) {
        log = LoggerFactory.getLogger(clazz);
        getInstance(isLogEnabled);
    }

    public static FoysonisLogger getInstance(Boolean isLog) {
        new FoysonisLogger(isLog)
    }

    static info(String message) {
        if (log.infoEnabled && isLogEnabled) {
            log.info(message)
        }
    }

    static error(String message) {
        if (log.errorEnabled && isLogEnabled) {
            log.error(message)
        }
    }


}
