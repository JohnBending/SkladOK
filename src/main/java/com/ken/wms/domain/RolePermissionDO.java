package com.ken.wms.domain;


public class RolePermissionDO {

    private String name;

    private String url;

    private String role;

    public void setName(String name) {
        this.name = name;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getName() {
        return name;
    }

    public String getUrl() {
        return url;
    }

    public String getRole() {
        return role;
    }

    @Override
    public String toString() {
        return "RolePermissionDO{" +
                "name='" + name + '\'' +
                ", url='" + url + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}
