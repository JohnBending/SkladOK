package com.ken.wms.common.service.Interface;

import com.ken.wms.exception.SystemLogServiceException;

import java.util.Map;


public interface SystemLogService {

    String ACCESS_TYPE_LOGIN = "login";
    String ACCESS_TYPE_LOGOUT = "logout";

    void insertAccessRecord(Integer userID, String userName, String accessIP, String accessType) throws SystemLogServiceException;

    Map<String, Object> selectAccessRecord(Integer userID, String accessType, String startDateStr, String endDateStr) throws SystemLogServiceException;

    Map<String, Object> selectAccessRecord(Integer userID, String accessType, String startDateStr, String endDateStr, int offset, int limit) throws SystemLogServiceException;

    void insertUserOperationRecord(Integer userID, String userName, String operationName, String operationResult) throws SystemLogServiceException;

    Map<String, Object> selectUserOperationRecord(Integer userID, String startDateStr, String endDateStr) throws SystemLogServiceException;

    Map<String, Object> selectUserOperationRecord(Integer userID, String startDateStr, String endDateStr, int offset, int limit) throws SystemLogServiceException;
}
