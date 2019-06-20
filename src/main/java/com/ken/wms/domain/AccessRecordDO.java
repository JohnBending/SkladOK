package com.ken.wms.domain;

import java.util.Date;


public class AccessRecordDO {

    private Integer id;

    private Integer userID;

    private String userName;

    private String accessType;

    private Date accessTime;

    private String accessIP;

    public Integer getId() {
        return id;
    }

    public Integer getUserID() {
        return userID;
    }

    public String getUserName() {
        return userName;
    }

    public String getAccessIP() {
        return accessIP;
    }

    public String getAccessType() {
        return accessType;
    }

    public Date getAccessTime() {
        return accessTime;
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

    public void setAccessType(String accessType) {
        this.accessType = accessType;
    }

    public void setAccessTime(Date accessTime) {
        this.accessTime = accessTime;
    }

    public void setAccessIP(String accessIP) {
        this.accessIP = accessIP;
    }

    @Override
    public String toString() {
        return "AccessRecordDO{" +
                "id=" + id +
                ", userID=" + userID +
                ", userName='" + userName + '\'' +
                ", accessType='" + accessType + '\'' +
                ", accessTime=" + accessTime +
                ", accessIP='" + accessIP + '\'' +
                '}';
    }
}
