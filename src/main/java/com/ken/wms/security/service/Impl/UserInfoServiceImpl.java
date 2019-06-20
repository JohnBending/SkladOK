package com.ken.wms.security.service.Impl;

import com.ken.wms.dao.RolesMapper;
import com.ken.wms.domain.RoleDO;
import com.ken.wms.domain.UserInfoDO;
import com.ken.wms.domain.UserInfoDTO;
import com.ken.wms.security.service.Interface.UserInfoService;
import com.ken.wms.security.util.EncryptingModel;
import com.ken.wms.dao.UserInfoMapper;
import com.ken.wms.dao.UserPermissionMapper;
import com.ken.wms.exception.UserInfoServiceException;
import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class UserInfoServiceImpl implements UserInfoService {

    @Autowired
    private UserInfoMapper userInfoMapper;
    @Autowired
    private UserPermissionMapper userPermissionMapper;
    @Autowired
    private EncryptingModel encryptingModel;
    @Autowired
    private RolesMapper rolesMapper;
    @Autowired
    UserInfoService userInfoService;


    @Override
    public UserInfoDTO getUserInfo(Integer userID) throws UserInfoServiceException {
        if (userID == null)
            return null;

        try {
            UserInfoDO userInfoDO = userInfoMapper.selectByUserID(userID);
            List<RoleDO> roles = userPermissionMapper.selectUserRole(userID);

            return assembleUserInfo(userInfoDO, roles);
        } catch (PersistenceException e) {
            throw new UserInfoServiceException(e);
        }
    }

    @Override
    public UserInfoDTO getUserInfo(String userName) throws UserInfoServiceException {
        if (userName == null)
            return null;

        try {
            UserInfoDO userInfoDO = userInfoMapper.selectByName(userName);
            if (userInfoDO != null) {
                List<RoleDO> roles = userPermissionMapper.selectUserRole(userInfoDO.getUserID());
                return assembleUserInfo(userInfoDO, roles);
            } else
                return null;
        } catch (PersistenceException e) {
            throw new UserInfoServiceException(e);
        }
    }

    @Override
    public List<UserInfoDTO> getAllUserInfo() throws UserInfoServiceException {
        List<UserInfoDTO> userInfoDTOS = null;

        try {
            List<UserInfoDO> userInfoDOS = userInfoMapper.selectAll();
            if (userInfoDOS != null) {
                List<RoleDO> roles;
                UserInfoDTO userInfoDTO;
                userInfoDTOS = new ArrayList<>(userInfoDOS.size());
                for (UserInfoDO userInfoDO : userInfoDOS) {
                    roles = userPermissionMapper.selectUserRole(userInfoDO.getUserID());
                    userInfoDTO = assembleUserInfo(userInfoDO, roles);
                    userInfoDTOS.add(userInfoDTO);
                }
            }

            return userInfoDTOS;
        } catch (PersistenceException e) {
            throw new UserInfoServiceException(e);
        }
    }

    @Override
    public void updateUserInfo(UserInfoDTO userInfoDTO) throws UserInfoServiceException {
        if (userInfoDTO != null) {
            try {
                Integer userID = userInfoDTO.getUserID();
                String userName = userInfoDTO.getUserName();
                String password = userInfoDTO.getPassword();
                if (userID != null && userName != null && password != null) {
                    UserInfoDO userInfoDO = new UserInfoDO();
                    userInfoDO.setUserID(userID);
                    userInfoDO.setUserName(userName);
                    userInfoDO.setPassword(password);
                    userInfoMapper.update(userInfoDO);
                }

            } catch (PersistenceException e) {
                throw new UserInfoServiceException(e);
            }
        }

    }

    @Override
    public void deleteUserInfo(Integer userID) throws UserInfoServiceException {
        if (userID == null)
            return;

        try {
            userPermissionMapper.deleteByUserID(userID);

            userInfoMapper.deleteById(userID);
        } catch (PersistenceException e) {
            throw new UserInfoServiceException(e);
        }

    }

    @Override
    public boolean insertUserInfo(UserInfoDTO userInfoDTO) throws UserInfoServiceException {
        if (userInfoDTO == null)
            return false;

        Integer userID = userInfoDTO.getUserID();
        String userName = userInfoDTO.getUserName();
        String password = userInfoDTO.getPassword();
        if (userName == null || password == null)
            return false;

        try {
            String tempStr = encryptingModel.MD5(password);
            String encryptPassword = encryptingModel.MD5(tempStr + userID.toString());

            UserInfoDO userInfoDO = new UserInfoDO();
            userInfoDO.setUserID(userID);
            userInfoDO.setUserName(userName);
            userInfoDO.setPassword(encryptPassword);

            userInfoMapper.insert(userInfoDO);

            List<String> roles = userInfoDTO.getRole();
            Integer roleID;

            for (String role : roles) {
                roleID = rolesMapper.getRoleID(role);
                if (roleID != null)
                    userPermissionMapper.insert(userID, roleID);
                else
                    throw new UserInfoServiceException("The role of userInfo unavailable");
            }

            return true;

        } catch (NoSuchAlgorithmException | PersistenceException e) {
            throw new UserInfoServiceException(e);
        }
    }

    private UserInfoDTO assembleUserInfo(UserInfoDO userInfoDO, List<RoleDO> roles) {
        UserInfoDTO userInfoDTO = null;
        if (userInfoDO != null && roles != null) {
            userInfoDTO = new UserInfoDTO();
            userInfoDTO.setUserID(userInfoDO.getUserID());
            userInfoDTO.setUserName(userInfoDO.getUserName());
            userInfoDTO.setPassword(userInfoDO.getPassword());

            for (RoleDO role : roles) {
                userInfoDTO.getRole().add(role.getRoleName());
            }
        }
        return userInfoDTO;
    }

    @Override
    public Set<String> getUserRoles(Integer userID) throws UserInfoServiceException {
        UserInfoDTO userInfo = getUserInfo(userID);

        if (userInfo != null) {
            return new HashSet<>(userInfo.getRole());
        } else {
            return new HashSet<>();
        }
    }

}
