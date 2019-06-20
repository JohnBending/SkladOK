package com.ken.wms.common.controller;

import com.ken.wms.common.service.Interface.StockRecordManageService;
import com.ken.wms.common.service.Interface.StorageManageService;
import com.ken.wms.common.util.Response;
import com.ken.wms.common.util.ResponseUtil;
import com.ken.wms.domain.Storage;
import com.ken.wms.exception.StorageManageServiceException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value = "/**/storageManage")
public class StorageManageHandler {

    @Autowired
    private StorageManageService storageManageService;
    @Autowired
    private StockRecordManageService stockRecordManageService;
    @Autowired
    private ResponseUtil responseUtil;

    private static final String SEARCH_BY_GOODS_ID = "searchByGoodsID";
    private static final String SEARCH_BY_GOODS_NAME = "searchByGoodsName";
    private static final String SEARCH_BY_GOODS_TYPE = "searchByGoodsType";
    private static final String SEARCH_ALL = "searchAll";

    private Map<String, Object> query(String searchType, String keyword, String repositoryBelong, int offset,
                                      int limit) throws StorageManageServiceException {
        Map<String, Object> queryResult = null;

        switch (searchType) {
            case SEARCH_ALL:
                if (StringUtils.isNumeric(repositoryBelong)) {
                    Integer repositoryID = Integer.valueOf(repositoryBelong);
                    queryResult = storageManageService.selectAll(repositoryID, offset, limit);
                } else {
                    queryResult = storageManageService.selectAll(null, offset, limit);
                }
                break;
            case SEARCH_BY_GOODS_ID:
                if (StringUtils.isNumeric(keyword)) {
                    Integer goodsID = Integer.valueOf(keyword);
                    if (StringUtils.isNumeric(repositoryBelong)) {
                        Integer repositoryID = Integer.valueOf(repositoryBelong);
                        queryResult = storageManageService.selectByGoodsID(goodsID, repositoryID, offset, limit);
                    } else
                        queryResult = storageManageService.selectByGoodsID(goodsID, null, offset, limit);
                }
                break;
            case SEARCH_BY_GOODS_TYPE:
                if (StringUtils.isNumeric(repositoryBelong)) {
                    Integer repositoryID = Integer.valueOf(repositoryBelong);
                    queryResult = storageManageService.selectByGoodsType(keyword, repositoryID, offset, limit);
                } else
                    queryResult = storageManageService.selectByGoodsType(keyword, null, offset, limit);
                break;
            case SEARCH_BY_GOODS_NAME:
                if (StringUtils.isNumeric(repositoryBelong)) {
                    Integer repositoryID = Integer.valueOf(repositoryBelong);
                    queryResult = storageManageService.selectByGoodsName(keyword, repositoryID, offset, limit);
                } else
                    queryResult = storageManageService.selectByGoodsName(keyword, null, offset, limit);
                break;
            default:
                // do other thing
                break;
        }

        return queryResult;
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getStorageListWithRepository", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getStorageListWithRepoID(@RequestParam("keyword") String keyword,
                                                 @RequestParam("searchType") String searchType, @RequestParam("repositoryBelong") String repositoryBelong,
                                                 @RequestParam("offset") int offset, @RequestParam("limit") int limit) throws StorageManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        List<Storage> rows;
        long total = 0;

        Map<String, Object> queryResult = query(searchType, keyword, repositoryBelong, offset, limit);
        if (queryResult != null) {
            rows = (List<Storage>) queryResult.get("data");
            total = (long) queryResult.get("total");
        } else
            rows = new ArrayList<>();

        responseContent.setCustomerInfo("rows", rows);
        responseContent.setResponseTotal(total);
        return responseContent.generateResponse();
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getStorageList", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getStorageList(@RequestParam("keyword") String keyword,
                                       @RequestParam("searchType") String searchType, @RequestParam("offset") int offset,
                                       @RequestParam("limit") int limit, HttpServletRequest request) throws StorageManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        List<Storage> rows = null;
        long total = 0;

        HttpSession session = request.getSession();
        Integer repositoryID = (Integer) session.getAttribute("repositoryBelong");
        if (repositoryID != null) {
            Map<String, Object> queryResult = query(searchType, keyword, repositoryID.toString(), offset, limit);
            if (queryResult != null) {
                rows = (List<Storage>) queryResult.get("data");
                total = (long) queryResult.get("total");
            }
        }

        if (rows == null)
            rows = new ArrayList<>();

        responseContent.setCustomerInfo("rows", rows);
        responseContent.setResponseTotal(total);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "addStorageRecord", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> addStorageRecord(@RequestBody Map<String, Object> params) throws StorageManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String isSuccess = Response.RESPONSE_RESULT_ERROR;
        boolean isAvailable = true;

        String goodsID = (String) params.get("goodsID");
        String repositoryID = (String) params.get("repositoryID");
        String number = (String) params.get("number");

        if (StringUtils.isBlank(goodsID) || !StringUtils.isNumeric(goodsID))
            isAvailable = false;
        if (StringUtils.isBlank(repositoryID) || !StringUtils.isNumeric(repositoryID))
            isAvailable = false;
        if (StringUtils.isBlank(number) || !StringUtils.isNumeric(number))
            isAvailable = false;

        if (isAvailable) {
            isSuccess = storageManageService.addNewStorage(Integer.valueOf(goodsID), Integer.valueOf(repositoryID),
                    Integer.valueOf(number)) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;
        }

        responseContent.setResponseResult(isSuccess);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "updateStorageRecord", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> updateStorageRecord(@RequestBody Map<String, Object> params) throws StorageManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        boolean isAvailable = true;
        String result = Response.RESPONSE_RESULT_ERROR;

        String goodsID = (String) params.get("goodsID");
        String repositoryID = (String) params.get("repositoryID");
        String number = (String) params.get("number");

        if (StringUtils.isBlank(goodsID) || !StringUtils.isNumeric(goodsID))
            isAvailable = false;
        if (StringUtils.isBlank(repositoryID) || !StringUtils.isNumeric(repositoryID))
            isAvailable = false;
        if (StringUtils.isBlank(number) || !StringUtils.isNumeric(number))
            isAvailable = false;

        if (isAvailable) {
            result = storageManageService.updateStorage(Integer.valueOf(goodsID), Integer.valueOf(repositoryID),
                    Integer.valueOf(number)) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;
        }

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "deleteStorageRecord", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> deleteStorageRecord(@RequestParam("goodsID") String goodsID,
                                            @RequestParam("repositoryID") String repositoryID) throws StorageManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = Response.RESPONSE_RESULT_ERROR;
        boolean isAvailable = true;

        if (StringUtils.isBlank(goodsID) || !StringUtils.isNumeric(goodsID))
            isAvailable = false;
        if (StringUtils.isBlank(repositoryID) || !StringUtils.isNumeric(repositoryID))
            isAvailable = false;

        if (isAvailable) {
            result = storageManageService.deleteStorage(Integer.valueOf(goodsID), Integer.valueOf(repositoryID))
                    ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;
        }

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "importStorageRecord", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> importStorageRecord(@RequestParam("file") MultipartFile file) throws StorageManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;

        int total = 0;
        int available = 0;

        if (file != null) {
            Map<String, Object> importInfo = storageManageService.importStorage(file);
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
    @RequestMapping(value = "exportStorageRecord", method = RequestMethod.GET)
    public void exportStorageRecord(@RequestParam("searchType") String searchType,
                                    @RequestParam("keyword") String keyword,
                                    @RequestParam(value = "repositoryBelong", required = false) String repositoryBelong,
                                    HttpServletRequest request, HttpServletResponse response) throws StorageManageServiceException, IOException {
        String fileName = "storageRecord.xlsx";

        HttpSession session = request.getSession();
        Integer sessionRepositoryBelong = (Integer) session.getAttribute("repositoryBelong");
        if (sessionRepositoryBelong != null && !sessionRepositoryBelong.equals("none"))
            repositoryBelong = sessionRepositoryBelong.toString();

        List<Storage> storageList = null;
        Map<String, Object> queryResult = query(searchType, keyword, repositoryBelong, -1, -1);
        if (queryResult != null)
            storageList = (List<Storage>) queryResult.get("data");

        File file = storageManageService.exportStorage(storageList);
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
