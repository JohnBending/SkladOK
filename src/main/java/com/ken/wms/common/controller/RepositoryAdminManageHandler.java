package com.ken.wms.common.controller;

import com.ken.wms.common.service.Interface.RepositoryAdminManageService;
import com.ken.wms.common.util.Response;
import com.ken.wms.common.util.ResponseUtil;
import com.ken.wms.domain.RepositoryAdmin;
import com.ken.wms.exception.RepositoryAdminManageServiceException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value = "/**/repositoryAdminManage")
public class RepositoryAdminManageHandler {

    @Autowired
    private RepositoryAdminManageService repositoryAdminManageService;
    @Autowired
    private ResponseUtil responseUtil;

    private static final String SEARCH_BY_ID = "searchByID";
    private static final String SEARCH_BY_NAME = "searchByName";
    private static final String SEARCH_BY_REPOSITORY_ID = "searchByRepositoryID";
    private static final String SEARCH_ALL = "searchAll";

    private Map<String, Object> query(String keyWord, String searchType, int offset, int limit) throws RepositoryAdminManageServiceException {
        Map<String, Object> queryResult = null;

        // query
        switch (searchType) {
            case SEARCH_ALL:
                queryResult = repositoryAdminManageService.selectAll(offset, limit);
                break;
            case SEARCH_BY_ID:
                if (StringUtils.isNumeric(keyWord))
                    queryResult = repositoryAdminManageService.selectByID(Integer.valueOf(keyWord));
                break;
            case SEARCH_BY_NAME:
                queryResult = repositoryAdminManageService.selectByName(offset, limit, keyWord);
                break;
            case SEARCH_BY_REPOSITORY_ID:
                if (StringUtils.isNumeric(keyWord))
                    queryResult = repositoryAdminManageService.selectByRepositoryID(Integer.valueOf(keyWord));
                break;
            default:
                // do other things
                break;
        }

        return queryResult;
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getRepositoryAdminList", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getRepositoryAdmin(@RequestParam("searchType") String searchType,
                                           @RequestParam("keyWord") String keyWord, @RequestParam("offset") int offset,
                                           @RequestParam("limit") int limit) throws RepositoryAdminManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        List<RepositoryAdmin> rows = null;
        long total = 0;

        Map<String, Object> queryResult = query(keyWord, searchType, offset, limit);

        if (queryResult != null) {
            rows = (List<RepositoryAdmin>) queryResult.get("data");
            total = (long) queryResult.get("total");
        }

        responseContent.setCustomerInfo("rows", rows);
        responseContent.setResponseTotal(total);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "addRepositoryAdmin", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> addRepositoryAdmin(@RequestBody RepositoryAdmin repositoryAdmin) throws RepositoryAdminManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = repositoryAdminManageService.addRepositoryAdmin(repositoryAdmin)
                ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "getRepositoryAdminInfo", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getRepositoryAdminInfo(Integer repositoryAdminID) throws RepositoryAdminManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;

        RepositoryAdmin repositoryAdmin = null;
        Map<String, Object> queryResult = repositoryAdminManageService.selectByID(repositoryAdminID);
        if (queryResult != null) {
            if ((repositoryAdmin = (RepositoryAdmin) queryResult.get("data")) != null)
                result = Response.RESPONSE_RESULT_SUCCESS;
        }

        responseContent.setResponseResult(result);
        responseContent.setResponseData(repositoryAdmin);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "updateRepositoryAdmin", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> updateRepositoryAdmin(@RequestBody RepositoryAdmin repositoryAdmin) throws RepositoryAdminManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = repositoryAdminManageService.updateRepositoryAdmin(repositoryAdmin)
                ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "deleteRepositoryAdmin", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> deleteRepositoryAdmin(Integer repositoryAdminID) throws RepositoryAdminManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = repositoryAdminManageService.deleteRepositoryAdmin(repositoryAdminID)
                ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "importRepositoryAdmin", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> importRepositoryAdmin(MultipartFile file) throws RepositoryAdminManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;

        long total = 0;
        long available = 0;
        if (file != null) {
            Map<String, Object> importInfo = repositoryAdminManageService.importRepositoryAdmin(file);
            if (importInfo != null) {
                total = (long) importInfo.get("total");
                available = (long) importInfo.get("available");
                result = Response.RESPONSE_RESULT_SUCCESS;
            }
        }

        responseContent.setResponseResult(result);
        responseContent.setResponseTotal(total);
        responseContent.setCustomerInfo("available", available);
        return responseContent.generateResponse();
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "exportRepositoryAdmin", method = RequestMethod.GET)
    public void exportRepositoryAdmin(@RequestParam("searchType") String searchType,
                                      @RequestParam("keyWord") String keyWord, HttpServletResponse response) throws RepositoryAdminManageServiceException, IOException {

        String fileName = "repositoryAdminInfo.xlsx";

        List<RepositoryAdmin> repositoryAdmins;
        Map<String, Object> queryResult = query(keyWord, searchType, -1, -1);

        if (queryResult != null)
            repositoryAdmins = (List<RepositoryAdmin>) queryResult.get("data");
        else
            repositoryAdmins = new ArrayList<>();

        File file = repositoryAdminManageService.exportRepositoryAdmin(repositoryAdmins);

        if (file != null) {
            response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
            FileInputStream inputStream = new FileInputStream(file);
            OutputStream outputStream = response.getOutputStream();
            byte[] buffer = new byte[8192];

            int len;
            while ((len = inputStream.read(buffer, 0, buffer.length)) > 0) {
                outputStream.write(buffer, 0, len);
                outputStream.flush();
            }

            inputStream.close();
            outputStream.close();
        }
    }
}
