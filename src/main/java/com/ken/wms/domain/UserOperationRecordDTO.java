package com.ken.wms.domain;


public class UserOperationRecordDTO {

    private Integer id;

    private Integer userID;

    private String userName;

    private String operationName;

    private String operationTime;

    private String operationResult;

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

    public String getOperationTime() {
        return operationTime;
    }

    public String getOperationResult() {
        return operationResult;
    }

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

    public void setOperationTime(String operationTime) {
        this.operationTime = operationTime;
    }

    public void setOperationResult(String operationResult) {
        this.operationResult = operationResult;
    }

    @Override
    public String toString() {
        return "UserOperationRecordDTO{" +
                "id=" + id +
                ", userID=" + userID +
                ", userName='" + userName + '\'' +
                ", operationName='" + operationName + '\'' +
                ", operationTime='" + operationTime + '\'' +
                ", operationResult='" + operationResult + '\'' +
                '}';
    }
}
