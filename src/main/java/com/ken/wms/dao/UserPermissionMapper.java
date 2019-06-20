package com.ken.wms.dao;

import com.ken.wms.domain.RoleDO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserPermissionMapper {

	void insert(@Param("userID") Integer userID, @Param("roleID") Integer roleID);

	void deleteByUserID(Integer userID);

    List<RoleDO> selectUserRole(Integer userID);
}
