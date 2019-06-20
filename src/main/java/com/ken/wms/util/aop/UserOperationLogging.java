package com.ken.wms.util.aop;

import com.ken.wms.exception.SystemLogServiceException;
import com.ken.wms.common.service.Interface.SystemLogService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.aspectj.lang.JoinPoint;
import org.springframework.beans.factory.annotation.Autowired;


public class UserOperationLogging {

    @Autowired
    private SystemLogService systemLogService;


    public void loggingUserOperation(JoinPoint joinPoint, Object returnValue, UserOperation userOperation){

        if (userOperation != null) {
            String userOperationValue = userOperation.value();

            String methodName = joinPoint.getSignature().getName();

            String invokedResult = "-";
            if (!methodName.matches("^import\\w*") && !methodName.matches("^export\\w*")){
                if (returnValue instanceof Boolean) {
                    boolean result = (boolean) returnValue;
                    invokedResult = result ? "успешно" : "ошибка";
                }
            }

            Subject currentSubject = SecurityUtils.getSubject();
            Session session = currentSubject.getSession();
            Integer userID = (Integer) session.getAttribute("userID");
            String userName = (String) session.getAttribute("userName");

            try{
                systemLogService.insertUserOperationRecord(userID, userName, userOperationValue, invokedResult);
            } catch (SystemLogServiceException e) {
                // do log
            }
        }
    }
}
