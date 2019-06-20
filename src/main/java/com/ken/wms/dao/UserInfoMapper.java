package com.ken.wms.dao;

import com.ken.wms.domain.UserInfoDO;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface UserInfoMapper {


    UserInfoDO selectByUserID(Integer userID);

    UserInfoDO selectByName(String userName);

    List<UserInfoDO> selectAll();

    void update(UserInfoDO user);

    void deleteById(Integer id);

    void insert(UserInfoDO user);

}
