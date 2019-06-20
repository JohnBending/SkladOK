package com.ken.wms.security.controller;

import com.ken.wms.security.service.Interface.AccountService;
import com.ken.wms.security.util.CheckCodeGenerator;
import com.ken.wms.common.service.Interface.SystemLogService;
import com.ken.wms.common.util.Response;
import com.ken.wms.common.util.ResponseUtil;
import com.ken.wms.exception.SystemLogServiceException;
import com.ken.wms.exception.UserAccountServiceException;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Map;


@Controller
@RequestMapping("/account")
public class AccountHandler {

    private static Logger log = Logger.getLogger("application");

    @Autowired
    private ResponseUtil responseUtil;
    @Autowired
    private CheckCodeGenerator checkCodeGenerator;
    @Autowired
    private AccountService accountService;
    @Autowired
    private SystemLogService systemLogService;

    private static final String USER_ID = "id";
    private static final String USER_NAME = "userName";
    private static final String USER_PASSWORD = "password";


    @SuppressWarnings("unchecked")
    @RequestMapping(value = "login", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> login(@RequestBody Map<String, Object> user) {

        Response response = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;
        String errorMsg = "";


        Subject currentUser = SecurityUtils.getSubject();

        if (currentUser != null && !currentUser.isAuthenticated()) {
            String id = (String) user.get(USER_ID);
            String password = (String) user.get(USER_PASSWORD);
            UsernamePasswordToken token = new UsernamePasswordToken(id, password);

            try {
                currentUser.login(token);

                Session session = currentUser.getSession();
                session.setAttribute("isAuthenticate", "true");
                Integer userID_integer = (Integer) session.getAttribute("userID");
                String userName = (String) session.getAttribute("userName");
                String accessIP = session.getHost();
                systemLogService.insertAccessRecord(userID_integer, userName, accessIP, SystemLogService.ACCESS_TYPE_LOGIN);

                result = Response.RESPONSE_RESULT_SUCCESS;
            } catch (UnknownAccountException e) {
                errorMsg = "unknownAccount";
            } catch (IncorrectCredentialsException e) {
                errorMsg = "incorrectCredentials";
            } catch (AuthenticationException e) {
                errorMsg = "authenticationError";
            } catch (SystemLogServiceException e) {
                errorMsg = "ServerError";
            }
        } else {
            errorMsg = "already login";
        }

        response.setResponseResult(result);
        response.setResponseMsg(errorMsg);
        return response.generateResponse();
    }

    @RequestMapping(value = "logout", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> logout() {
        Response response = responseUtil.newResponseInstance();

        Subject currentSubject = SecurityUtils.getSubject();
        if (currentSubject != null && currentSubject.isAuthenticated()) {
            currentSubject.logout();
            response.setResponseResult(Response.RESPONSE_RESULT_SUCCESS);
        } else {
            response.setResponseResult(Response.RESPONSE_RESULT_ERROR);
            response.setResponseMsg("did not login");
        }

        return response.generateResponse();
    }

    @RequestMapping(value = "passwordModify", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> passwordModify(@RequestBody Map<String, Object> passwordInfo,
                                       HttpServletRequest request) {
        Response responseContent = responseUtil.newResponseInstance();

        String errorMsg = null;
        String result = Response.RESPONSE_RESULT_ERROR;

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");

        try {
            accountService.passwordModify(userID, passwordInfo);

            result = Response.RESPONSE_RESULT_SUCCESS;
        } catch (UserAccountServiceException e) {
            errorMsg = e.getExceptionDesc();
        }
        responseContent.setResponseResult(result);
        responseContent.setResponseMsg(errorMsg);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "checkCode/{time}", method = RequestMethod.GET)
    public void getCheckCode(@PathVariable("time") String time, HttpServletResponse response, HttpServletRequest request) {

        BufferedImage checkCodeImage = null;
        String checkCodeString = null;

        Map<String, Object> checkCode = checkCodeGenerator.generlateCheckCode();

        if (checkCode != null) {
            checkCodeString = (String) checkCode.get("checkCodeString");
            checkCodeImage = (BufferedImage) checkCode.get("checkCodeImage");
        }

        if (checkCodeString != null && checkCodeImage != null) {
            try (ServletOutputStream outputStream = response.getOutputStream()) {
                HttpSession session = request.getSession();
                session.setAttribute("checkCode", checkCodeString);

                ImageIO.write(checkCodeImage, "png", outputStream);

                response.setHeader("Pragma", "no-cache");
                response.setHeader("Cache-Control", "no-cache");
                response.setDateHeader("Expires", 0);
                response.setContentType("image/png");
            } catch (IOException e) {
                log.error("fail to get the ServletOutputStream");
            }
        }
    }
}
