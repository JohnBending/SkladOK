package com.ken.wms.domain;

import java.util.ArrayList;
import java.util.List;

public class UserInfoDTO {

    private Integer userID;

    private String userName;

    private String password;

    private List<String> role = new ArrayList<>();

    public String getUserName() {
        return userName;
    }

    public List<String> getRole() {
        return role;
    }

    public Integer getUserID() {
        return userID;
    }

    public String getPassword() {
        return password;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setRole(List<String> role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "UserInfoDTO{" +
                "userID=" + userID +
                ", userName='" + userName + '\'' +
                ", password='" + password + '\'' +
                ", role=" + role +
                '}';
    }
}
