package com.ken.wms.common.controller;

import com.ken.wms.common.service.Interface.SupplierManageService;
import com.ken.wms.common.util.Response;
import com.ken.wms.common.util.ResponseUtil;
import com.ken.wms.domain.Supplier;
import com.ken.wms.exception.SupplierManageServiceException;
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
import java.util.List;
import java.util.Map;


@RequestMapping(value = "/**/supplierManage")
@Controller
public class SupplierManageHandler {

    @Autowired
    private SupplierManageService supplierManageService;
    @Autowired
    private ResponseUtil responseUtil;

    private static final String SEARCH_BY_ID = "searchByID";
    private static final String SEARCH_BY_NAME = "searchByName";
    private static final String SEARCH_ALL = "searchAll";

    private Map<String, Object> query(String searchType, String keyWord, int offset, int limit) throws SupplierManageServiceException {
        Map<String, Object> queryResult = null;

        switch (searchType) {
            case SEARCH_BY_ID:
                if (StringUtils.isNumeric(keyWord)) {
                    queryResult = supplierManageService.selectById(Integer.valueOf(keyWord));
                }
                break;
            case SEARCH_BY_NAME:
                queryResult = supplierManageService.selectByName(offset, limit, keyWord);
                break;
            case SEARCH_ALL:
                queryResult = supplierManageService.selectAll(offset, limit);
                break;
            default:
                break;
        }

        return queryResult;
    }

    @RequestMapping(value = "getSupplierList", method = RequestMethod.GET)
    @SuppressWarnings("unchecked")
    public
    @ResponseBody
    Map<String, Object> getSupplierList(@RequestParam("searchType") String searchType,
                                        @RequestParam("offset") int offset, @RequestParam("limit") int limit,
                                        @RequestParam("keyWord") String keyWord) throws SupplierManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        List<Supplier> rows = null;
        long total = 0;

        Map<String, Object> queryResult = query(searchType, keyWord, offset, limit);

        if (queryResult != null) {
            rows = (List<Supplier>) queryResult.get("data");
            total = (long) queryResult.get("total");
        }

        responseContent.setCustomerInfo("rows", rows);
        responseContent.setResponseTotal(total);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "addSupplier", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> addSupplier(@RequestBody Supplier supplier) throws SupplierManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = supplierManageService.addSupplier(supplier) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "getSupplierInfo", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getSupplierInfo(@RequestParam("supplierID") int supplierID) throws SupplierManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;

        Supplier supplier = null;
        Map<String, Object> queryResult = supplierManageService.selectById(supplierID);
        if (queryResult != null) {
            supplier = (Supplier) queryResult.get("data");
            if (supplier != null)
                result = Response.RESPONSE_RESULT_SUCCESS;
        }

        responseContent.setResponseResult(result);
        responseContent.setResponseData(supplier);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "updateSupplier", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> updateSupplier(@RequestBody Supplier supplier) throws SupplierManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = supplierManageService.updateSupplier(supplier) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "deleteSupplier", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> deleteSupplier(@RequestParam("supplierID") Integer supplierID) {
        Response responseContent = responseUtil.newResponseInstance();

        String result = supplierManageService.deleteSupplier(supplierID) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "importSupplier", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> importSupplier(@RequestParam("file") MultipartFile file) {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_SUCCESS;

        int total = 0;
        int available = 0;
        if (file == null)
            result = Response.RESPONSE_RESULT_ERROR;
        Map<String, Object> importInfo = supplierManageService.importSupplier(file);
        if (importInfo != null) {
            total = (int) importInfo.get("total");
            available = (int) importInfo.get("available");
        }

        responseContent.setResponseResult(result);
        responseContent.setResponseTotal(total);
        responseContent.setCustomerInfo("available", available);
        return responseContent.generateResponse();
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "exportSupplier", method = RequestMethod.GET)
    public void exportSupplier(@RequestParam("searchType") String searchType, @RequestParam("keyWord") String keyWord,
                               HttpServletResponse response) throws SupplierManageServiceException, IOException {

        String fileName = "supplierInfo.xlsx";

        List<Supplier> suppliers = null;
        Map<String, Object> queryResult;
        queryResult = query(searchType, keyWord, -1, -1);

        if (queryResult != null) {
            suppliers = (List<Supplier>) queryResult.get("data");
        }

        File file = supplierManageService.exportSupplier(suppliers);

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
