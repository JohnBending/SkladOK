package com.ken.wms.domain;

public class AccessRecordDTO {

    private Integer id;

    private Integer userID;

    private String userName;

    private String accessTime;

    private String accessIP;

    private String accessType;

    public Integer getId() {
        return id;
    }

    public Integer getUserID() {
        return userID;
    }

    public String getUserName() {
        return userName;
    }

    public String getAccessTime() {
        return accessTime;
    }

    public String getAccessIP() {
        return accessIP;
    }

    public String getAccessType() {
        return accessType;
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

    public void setAccessTime(String accessTime) {
        this.accessTime = accessTime;
    }

    public void setAccessIP(String accessIP) {
        this.accessIP = accessIP;
    }

    public void setAccessType(String accessType) {
        this.accessType = accessType;
    }

    @Override
    public String toString() {
        return "AccessRecordDTO{" +
                "id=" + id +
                ", userID=" + userID +
                ", userName='" + userName + '\'' +
                ", accessTime='" + accessTime + '\'' +
                ", accessIP='" + accessIP + '\'' +
                ", accessType='" + accessType + '\'' +
                '}';
    }
}
