package com.ken.wms.security.service.Impl;


import com.ken.wms.domain.UserInfoDTO;
import com.ken.wms.security.service.Interface.AccountService;
import com.ken.wms.security.service.Interface.UserInfoService;
import com.ken.wms.security.util.EncryptingModel;
import com.ken.wms.exception.UserAccountServiceException;
import com.ken.wms.exception.UserInfoServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.NoSuchAlgorithmException;
import java.util.Map;

@Service
public class AccountServiceImpl implements AccountService {

    @Autowired
    private UserInfoService userInfoService;
    @Autowired
    private EncryptingModel encryptingModel;


    private static final String OLD_PASSWORD = "oldPassword";
    private static final String NEW_PASSWORD = "newPassword";
    private static final String REPEAT_PASSWORD = "rePassword";

    @Override
    public void passwordModify(Integer userID, Map<String, Object> passwordInfo) throws UserAccountServiceException {

        if (passwordInfo == null)
            throw new UserAccountServiceException(UserAccountServiceException.PASSWORD_ERROR);

        String rePassword = (String) passwordInfo.get(REPEAT_PASSWORD);
        String newPassword = (String) passwordInfo.get(NEW_PASSWORD);
        String oldPassword = (String) passwordInfo.get(OLD_PASSWORD);
        if (rePassword == null || newPassword == null || oldPassword == null)
            throw new UserAccountServiceException(UserAccountServiceException.PASSWORD_ERROR);

        try {

            UserInfoDTO user = userInfoService.getUserInfo(userID);
            if (user == null) {
                throw new UserAccountServiceException(UserAccountServiceException.PASSWORD_ERROR);
            }

            if (!newPassword.equals(rePassword)) {
                throw new UserAccountServiceException(UserAccountServiceException.PASSWORD_UNMATCH);
            }

            String password;
            password = encryptingModel.MD5(oldPassword + userID);
            if (!password.equals(user.getPassword()))
                throw new UserAccountServiceException(UserAccountServiceException.PASSWORD_ERROR);

            password = encryptingModel.MD5(newPassword + userID);

            user.setPassword(password);
            userInfoService.updateUserInfo(user);
        } catch (NoSuchAlgorithmException | NullPointerException | UserInfoServiceException e) {
            throw new UserAccountServiceException(UserAccountServiceException.PASSWORD_ERROR);
        }

    }

}
