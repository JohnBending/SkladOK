package com.ken.wms.security.service.Interface;

import com.ken.wms.domain.UserInfoDTO;
import com.ken.wms.exception.UserInfoServiceException;

import java.util.List;
import java.util.Set;

public interface UserInfoService {

    UserInfoDTO getUserInfo(Integer userID) throws UserInfoServiceException;

    UserInfoDTO getUserInfo(String userName) throws UserInfoServiceException;

    List<UserInfoDTO> getAllUserInfo() throws UserInfoServiceException;

    void updateUserInfo(UserInfoDTO userInfoDTO) throws UserInfoServiceException;

    void deleteUserInfo(Integer userID) throws UserInfoServiceException;

    boolean insertUserInfo(UserInfoDTO userInfoDTO) throws UserInfoServiceException;

    Set<String> getUserRoles(Integer userID) throws UserInfoServiceException;
}
