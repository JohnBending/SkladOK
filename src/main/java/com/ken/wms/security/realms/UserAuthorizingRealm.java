package com.ken.wms.security.realms;

import com.ken.wms.domain.RepositoryAdmin;
import com.ken.wms.domain.UserInfoDTO;
import com.ken.wms.security.service.Interface.UserInfoService;
import com.ken.wms.security.util.EncryptingModel;
import com.ken.wms.common.service.Interface.RepositoryAdminManageService;
import com.ken.wms.common.service.Interface.SystemLogService;
import com.ken.wms.exception.RepositoryAdminManageServiceException;
import com.ken.wms.exception.UserInfoServiceException;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;

import java.security.NoSuchAlgorithmException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class UserAuthorizingRealm extends AuthorizingRealm {

    @Autowired
    private UserInfoService userInfoService;
    @Autowired
    private EncryptingModel encryptingModel;
    @Autowired
    private RepositoryAdminManageService repositoryAdminManageService;
    @Autowired
    private SystemLogService systemLogService;

    @SuppressWarnings("unchecked")
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        Set<String> roles = new HashSet<>();

        Object principal = principalCollection.getPrimaryPrincipal();
        if (principal instanceof String) {
            String userID = (String) principal;
            if (StringUtils.isNumeric(userID)) {
                try {
                    UserInfoDTO userInfo = userInfoService.getUserInfo(Integer.valueOf(userID));
                    if (userInfo != null) {
                        roles.addAll(userInfo.getRole());
                    }
                } catch (UserInfoServiceException e) {
                    // do logger
                }
            }
        }

        return new SimpleAuthorizationInfo(roles);
    }

    @SuppressWarnings("unchecked")
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws
            AuthenticationException {

        String realmName = getName();
        String credentials = "";

        try {
            UsernamePasswordToken usernamePasswordToken = (UsernamePasswordToken) authenticationToken;
            String principal = usernamePasswordToken.getUsername();

            if (!StringUtils.isNumeric(principal))
                throw new AuthenticationException();
            Integer userID = Integer.valueOf(principal);
            UserInfoDTO userInfoDTO = userInfoService.getUserInfo(userID);

            if (userInfoDTO != null) {
                Subject currentSubject = SecurityUtils.getSubject();
                Session session = currentSubject.getSession();

                session.setAttribute("userID", userID);
                session.setAttribute("userName", userInfoDTO.getUserName());
                List<RepositoryAdmin> repositoryAdmin = (List<RepositoryAdmin>) repositoryAdminManageService.selectByID(userInfoDTO.getUserID()).get("data");
                session.setAttribute("repositoryBelong", (repositoryAdmin.isEmpty()) ? "none" : repositoryAdmin.get(0).getRepositoryBelongID());

                String checkCode = (String) session.getAttribute("checkCode");
                String password = userInfoDTO.getPassword();
                if (checkCode != null && password != null) {
                    checkCode = checkCode.toUpperCase();
                    credentials = encryptingModel.MD5(password + checkCode);
                }
            }
            return new SimpleAuthenticationInfo(principal, credentials, realmName);

        } catch (UserInfoServiceException | RepositoryAdminManageServiceException | NoSuchAlgorithmException e) {
            throw new AuthenticationException();
        }
    }
}
