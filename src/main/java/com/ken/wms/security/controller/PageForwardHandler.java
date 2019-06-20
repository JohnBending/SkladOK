package com.ken.wms.security.controller;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/")
@Controller
public class PageForwardHandler {

    @RequestMapping("login")
    public String loginPageForward() {
        Subject currentSubject = SecurityUtils.getSubject();
        if (!currentSubject.isAuthenticated())
            return "login";
        else
            return "mainPage";
    }

    @RequestMapping("mainPage")
    public String showLoginView() {
        Subject currentSubject = SecurityUtils.getSubject();
        if (!currentSubject.isAuthenticated())
            return "login";
        else
        return "mainPage";
    }
}
