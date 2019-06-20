package com.ken.wms.security.service;

import com.ken.wms.dao.RolePermissionMapper;
import com.ken.wms.domain.RolePermissionDO;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.LinkedHashMap;
import java.util.List;


public class FilterChainDefinitionMapBuilder {
    @Autowired
    private RolePermissionMapper rolePermissionMapper;
    private StringBuilder builder = new StringBuilder();


    public LinkedHashMap<String, String> builderFilterChainDefinitionMap(){
        LinkedHashMap<String, String> permissionMap = new LinkedHashMap<>();

        permissionMap.put("/css/**", "anon");
        permissionMap.put("/js/**", "anon");
        permissionMap.put("/fonts/**", "anon");
        permissionMap.put("/media/**", "anon");
        permissionMap.put("/pagecomponent/**", "anon");
        permissionMap.put("/login", "anon");
        permissionMap.put("/account/login", "anon");
        permissionMap.put("/account/checkCode/**", "anon");


        LinkedHashMap<String, String> permissions = getPermissionDataFromDB();
        if (permissions != null){
            permissionMap.putAll(permissions);
        }


        permissionMap.put("/", "authc");

//        permissionMap.forEach((s, s2) -> {System.out.println(s + ":" + s2);});

        return permissionMap;
    }


    private LinkedHashMap<String, String> getPermissionDataFromDB(){
        LinkedHashMap<String, String> permissionData = null;

        List<RolePermissionDO> rolePermissionDOS = rolePermissionMapper.selectAll();
        if (rolePermissionDOS != null){
            permissionData = new LinkedHashMap<>(rolePermissionDOS.size());
            String url;
            String role;
            String permission;
            for (RolePermissionDO rolePermissionDO : rolePermissionDOS){
                url = rolePermissionDO.getUrl();
                role = rolePermissionDO.getRole();


                if (permissionData.containsKey(url)){
                    builder.delete(0, builder.length());
                    builder.append(permissionData.get(url));
                    builder.insert(builder.length() - 1, ",");
                    builder.insert(builder.length() - 1, role);
                }else{
                    builder.delete(0, builder.length());
                    builder.append("authc,roles[").append(role).append("]");
                }
                permission = builder.toString();
//                System.out.println(url + ":" + permission);
                permissionData.put(url, permission);
            }
        }

        return permissionData;
    }


//    private String permissionStringBuilder(String role){
//        builder.delete(0, builder.length());
//        return builder.append("authc,roles[").append(role).append("]").toString();
//    }
}
