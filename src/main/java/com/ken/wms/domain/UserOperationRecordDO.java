package com.ken.wms.domain;

import java.util.Date;


public class UserOperationRecordDO {


    private Integer id;

    private Integer userID;

    private String userName;

    private String operationName;

    private Date operationTime;

    private String operationResult;

    public void setId(Integer id) {
        this.id = id;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setOperationName(String operationName) {
        this.operationName = operationName;
    }

    public void setOperationTime(Date operationTime) {
        this.operationTime = operationTime;
    }

    public void setOperationResult(String operationResult) {
        this.operationResult = operationResult;
    }

    public Integer getId() {
        return id;
    }

    public Integer getUserID() {
        return userID;
    }

    public String getUserName() {
        return userName;
    }

    public String getOperationName() {
        return operationName;
    }

    public Date getOperationTime() {
        return operationTime;
    }

    public String getOperationResult() {
        return operationResult;
    }

    @Override
    public String toString() {
        return "UserOperationRecordDO{" +
                "id=" + id +
                ", userID=" + userID +
                ", userName='" + userName + '\'' +
                ", operationName='" + operationName + '\'' +
                ", operationTime=" + operationTime +
                ", operationResult='" + operationResult + '\'' +
                '}';
    }
}
