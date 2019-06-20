package com.ken.wms.util.aop;

import org.aspectj.lang.JoinPoint;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



public class ServiceLogging {

    private static Logger exceptionLogger = LoggerFactory.getLogger("ExceptionLogging");
    private static Logger methodInvokeLogger = LoggerFactory.getLogger("MethodInvokeLogging");


    public void loggingServiceException(Throwable throwable) {
        if (exceptionLogger.isErrorEnabled()) {
            StringBuilder builder = new StringBuilder();
            builder.append("cause:").append(throwable.getMessage());
            builder.append("\n\tstackTrack:\n");
            for (StackTraceElement stack : throwable.getStackTrace()) {
                builder.append("\t\t");
                builder.append(stack.toString());
                builder.append("\n");
            }
            exceptionLogger.error(builder.toString());
        }
    }


    public void loggingMethodInvoked(JoinPoint joinPoint) {
        if (methodInvokeLogger.isDebugEnabled()) {
            String methodName = joinPoint.getSignature().getName();
            Object[] args = joinPoint.getArgs();
            StringBuilder builder = new StringBuilder();
            builder.append("Invoked Method:").append(methodName);
            builder.append("\targs：");
            for (Object arg : args) {
                builder.append(arg.toString());
            }
            methodInvokeLogger.debug(builder.toString());
        }
    }

}
