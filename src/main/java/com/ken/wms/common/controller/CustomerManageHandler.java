package com.ken.wms.common.controller;

import com.ken.wms.common.service.Interface.CustomerManageService;
import com.ken.wms.common.util.Response;
import com.ken.wms.common.util.ResponseUtil;
import com.ken.wms.domain.Customer;
import com.ken.wms.domain.Supplier;
import com.ken.wms.exception.CustomerManageServiceException;
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


@RequestMapping(value = "/**/customerManage")
@Controller
public class CustomerManageHandler {

    @Autowired
    private CustomerManageService customerManageService;
    @Autowired
    private ResponseUtil responseUtil;

    private static final String SEARCH_BY_ID = "searchByID";
    private static final String SEARCH_BY_NAME = "searchByName";
    private static final String SEARCH_ALL = "searchAll";


    private Map<String, Object> query(String searchType, String keyWord, int offset, int limit) throws CustomerManageServiceException {
        Map<String, Object> queryResult = null;

        switch (searchType) {
            case SEARCH_BY_ID:
                if (StringUtils.isNumeric(keyWord))
                    queryResult = customerManageService.selectById(Integer.valueOf(keyWord));
                break;
            case SEARCH_BY_NAME:
                queryResult = customerManageService.selectByName(offset, limit, keyWord);
                break;
            case SEARCH_ALL:
                queryResult = customerManageService.selectAll(offset, limit);
                break;
            default:
                // do other thing
                break;
        }
        return queryResult;
    }


    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getCustomerList", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getCustomerList(@RequestParam("searchType") String searchType,
                                        @RequestParam("offset") int offset,
                                        @RequestParam("limit") int limit,
                                        @RequestParam("keyWord") String keyWord) throws CustomerManageServiceException {

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
        responseContent.setResponseResult(Response.RESPONSE_RESULT_SUCCESS);
        return responseContent.generateResponse();
    }


    @RequestMapping(value = "addCustomer", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> addCustomer(@RequestBody Customer customer) throws CustomerManageServiceException {

        Response responseContent = responseUtil.newResponseInstance();


        String result = customerManageService.addCustomer(customer) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }


    @RequestMapping(value = "getCustomerInfo", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getCustomerInfo(@RequestParam("customerID") String customerID) throws CustomerManageServiceException {

        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;


        Customer customer = null;
        Map<String, Object> queryResult = query(SEARCH_BY_ID, customerID, -1, -1);
        if (queryResult != null) {
            customer = (Customer) queryResult.get("data");
            if (customer != null) {
                result = Response.RESPONSE_RESULT_SUCCESS;
            }
        }


        responseContent.setResponseResult(result);
        responseContent.setResponseData(customer);

        return responseContent.generateResponse();
    }


    @RequestMapping(value = "updateCustomer", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> updateCustomer(@RequestBody Customer customer) throws CustomerManageServiceException {

        Response responseContent = responseUtil.newResponseInstance();


        String result = customerManageService.updateCustomer(customer) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }


    @RequestMapping(value = "deleteCustomer", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> deleteCustomer(@RequestParam("customerID") String customerIDStr) throws CustomerManageServiceException {

        Response responseContent = responseUtil.newResponseInstance();


        if (StringUtils.isNumeric(customerIDStr)) {

            Integer customerID = Integer.valueOf(customerIDStr);


            String result = customerManageService.deleteCustomer(customerID) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;
            responseContent.setResponseResult(result);
        } else
            responseContent.setResponseResult(Response.RESPONSE_RESULT_ERROR);

        return responseContent.generateResponse();
    }


    @RequestMapping(value = "importCustomer", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> importCustomer(@RequestParam("file") MultipartFile file) throws CustomerManageServiceException {

        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_SUCCESS;


        int total = 0;
        int available = 0;
        if (file == null)
            result = Response.RESPONSE_RESULT_ERROR;
        Map<String, Object> importInfo = customerManageService.importCustomer(file);
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
    @RequestMapping(value = "exportCustomer", method = RequestMethod.GET)
    public void exportCustomer(@RequestParam("searchType") String searchType, @RequestParam("keyWord") String keyWord,
                               HttpServletResponse response) throws CustomerManageServiceException, IOException {

        String fileName = "customerInfo.xlsx";

        List<Customer> customers = null;
        Map<String, Object> queryResult = query(searchType, keyWord, -1, -1);

        if (queryResult != null) {
            customers = (List<Customer>) queryResult.get("data");
        }


        File file = customerManageService.exportCustomer(customers);


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
