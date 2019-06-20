package com.ken.wms.dao;

import org.springframework.stereotype.Repository;


@Repository
public interface RolesMapper {

    Integer getRoleID(String roleName);

}
