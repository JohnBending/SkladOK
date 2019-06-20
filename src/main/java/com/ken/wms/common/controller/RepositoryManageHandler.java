package com.ken.wms.common.controller;

import com.ken.wms.common.service.Interface.RepositoryService;
import com.ken.wms.common.util.Response;
import com.ken.wms.common.util.ResponseUtil;
import com.ken.wms.domain.Repository;
import com.ken.wms.exception.RepositoryManageServiceException;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value = "/**/repositoryManage")
public class RepositoryManageHandler {

    @Autowired
    private RepositoryService repositoryService;
    @Autowired
    private ResponseUtil responseUtil;

    private static final String SEARCH_BY_ID = "searchByID";
    private static final String SEARCH_BY_ADDRESS = "searchByAddress";
    private static final String SEARCH_ALL = "searchAll";


    private Map<String, Object> query(String searchType, String keyword, int offset, int limit) throws RepositoryManageServiceException {
        Map<String, Object> queryResult = null;

        switch (searchType) {
            case SEARCH_BY_ID:
                if (StringUtils.isNumeric(keyword)) {
                    queryResult = repositoryService.selectById(Integer.valueOf(keyword));
                }
                break;
            case SEARCH_BY_ADDRESS:
                queryResult = repositoryService.selectByAddress(offset, limit, keyword);
                break;
            case SEARCH_ALL:
                queryResult = repositoryService.selectAll(offset, limit);
                break;
            default:

                break;
        }

        return queryResult;
    }


    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getRepositoryList", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getRepositoryList(@RequestParam("searchType") String searchType,
                                          @RequestParam("offset") int offset, @RequestParam("limit") int limit,
                                          @RequestParam("keyWord") String keyWord) throws RepositoryManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        List<Repository> rows = null;
        long total = 0;

        Map<String, Object> queryResult = query(searchType, keyWord, offset, limit);

        if (queryResult != null) {
            rows = (List<Repository>) queryResult.get("data");
            total = (long) queryResult.get("total");
        }

        responseContent.setCustomerInfo("rows", rows);
        responseContent.setResponseTotal(total);
        return responseContent.generateResponse();
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getUnassignRepository", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getUnassignRepository() throws RepositoryManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Repository> data;
        long total = 0;

        Map<String, Object> queryResult = repositoryService.selectUnassign();
        if (queryResult != null) {
            data = (List<Repository>) queryResult.get("data");
            total = (long) queryResult.get("total");
        } else
            data = new ArrayList<>();

        resultSet.put("data", data);
        resultSet.put("total", total);
        return resultSet;
    }

    @RequestMapping(value = "addRepository", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> addRepository(@RequestBody Repository repository) throws RepositoryManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = repositoryService.addRepository(repository) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "getRepositoryInfo", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getRepositoryInfo(@RequestParam("repositoryID") Integer repositoryID) throws RepositoryManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;

        Repository repository = null;
        Map<String, Object> queryResult = repositoryService.selectById(repositoryID);
        if (queryResult != null) {
            repository = (Repository) queryResult.get("data");
            if (repository != null)
                result = Response.RESPONSE_RESULT_SUCCESS;
        }

        responseContent.setResponseResult(result);
        responseContent.setResponseData(repository);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "updateRepository", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> updateRepository(@RequestBody Repository repository) throws RepositoryManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = repositoryService.updateRepository(repository) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }


    @RequestMapping(value = "deleteRepository", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> deleteRepository(@RequestParam("repositoryID") Integer repositoryID) throws RepositoryManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = repositoryService.deleteRepository(repositoryID) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "importRepository", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> importRepository(MultipartFile file) throws RepositoryManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;

        int total = 0;
        int available = 0;
        if (file != null) {
            Map<String, Object> importInfo = repositoryService.importRepository(file);
            if (importInfo != null) {
                total = (int) importInfo.get("total");
                available = (int) importInfo.get("available");
                result = Response.RESPONSE_RESULT_SUCCESS;
            }
        }

        responseContent.setResponseResult(result);
        responseContent.setResponseTotal(total);
        responseContent.setCustomerInfo("available", available);
        return responseContent.generateResponse();
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "exportRepository", method = RequestMethod.GET)
    public void exportRepository(@RequestParam("searchType") String searchType, @RequestParam("keyWord") String keyWord,
                                 HttpServletResponse response) throws RepositoryManageServiceException, IOException {

        String fileName = "repositoryInfo.xlsx";

        List<Repository> repositories;

        Map<String, Object> queryResult = query(searchType, keyWord, -1, -1);

        if (queryResult != null)
            repositories = (List<Repository>) queryResult.get("data");
        else
            repositories = new ArrayList<>();

        File file = repositoryService.exportRepository(repositories);

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
