package com.ken.wms.common.controller;

import com.ken.wms.common.service.Interface.GoodsManageService;
import com.ken.wms.common.util.Response;
import com.ken.wms.common.util.ResponseUtil;
import com.ken.wms.domain.Goods;
import com.ken.wms.domain.Supplier;
import com.ken.wms.exception.GoodsManageServiceException;
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

@RequestMapping(value = "/**/goodsManage")
@Controller
public class GoodsManageHandler {

    @Autowired
    private GoodsManageService goodsManageService;
    @Autowired
    private ResponseUtil responseUtil;

    private static final String SEARCH_BY_ID = "searchByID";
    private static final String SEARCH_BY_NAME = "searchByName";
    private static final String SEARCH_ALL = "searchAll";

    private Map<String, Object> query(String searchType, String keyWord, int offset, int limit) throws GoodsManageServiceException {
        Map<String, Object> queryResult = null;

        switch (searchType) {
            case SEARCH_BY_ID:
                if (StringUtils.isNumeric(keyWord))
                    queryResult = goodsManageService.selectById(Integer.valueOf(keyWord));
                break;
            case SEARCH_BY_NAME:
                queryResult = goodsManageService.selectByName(keyWord);
                break;
            case SEARCH_ALL:
                queryResult = goodsManageService.selectAll(offset, limit);
                break;
            default:
                // do other thing
                break;
        }

        return queryResult;
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getGoodsList", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getGoodsList(@RequestParam("searchType") String searchType,
                                     @RequestParam("offset") int offset, @RequestParam("limit") int limit,
                                     @RequestParam("keyWord") String keyWord) throws GoodsManageServiceException {
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

    @RequestMapping(value = "addGoods", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> addGoods(@RequestBody Goods goods) throws GoodsManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = goodsManageService.addGoods(goods) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);

        return responseContent.generateResponse();
    }

    @RequestMapping(value = "getGoodsInfo", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> getGoodsInfo(@RequestParam("goodsID") Integer goodsID) throws GoodsManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;

        Goods goods = null;
        Map<String, Object> queryResult = goodsManageService.selectById(goodsID);
        if (queryResult != null) {
            goods = (Goods) queryResult.get("data");
            if (goods != null) {
                result = Response.RESPONSE_RESULT_SUCCESS;
            }
        }

        responseContent.setResponseResult(result);
        responseContent.setResponseData(goods);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "updateGoods", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> updateGoods(@RequestBody Goods goods) throws GoodsManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = goodsManageService.updateGoods(goods) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "deleteGoods", method = RequestMethod.GET)
    public
    @ResponseBody
    Map<String, Object> deleteGoods(@RequestParam("goodsID") Integer goodsID) throws GoodsManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();

        String result = goodsManageService.deleteGoods(goodsID) ? Response.RESPONSE_RESULT_SUCCESS : Response.RESPONSE_RESULT_ERROR;

        responseContent.setResponseResult(result);
        return responseContent.generateResponse();
    }

    @RequestMapping(value = "importGoods", method = RequestMethod.POST)
    public
    @ResponseBody
    Map<String, Object> importGoods(@RequestParam("file") MultipartFile file) throws GoodsManageServiceException {
        Response responseContent = responseUtil.newResponseInstance();
        String result = Response.RESPONSE_RESULT_ERROR;

        int total = 0;
        int available = 0;
        if (file != null) {
            Map<String, Object> importInfo = goodsManageService.importGoods(file);
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
    @RequestMapping(value = "exportGoods", method = RequestMethod.GET)
    public void exportGoods(@RequestParam("searchType") String searchType, @RequestParam("keyWord") String keyWord,
                            HttpServletResponse response) throws GoodsManageServiceException, IOException {

        String fileName = "goodsInfo.xlsx";

        List<Goods> goodsList = null;
        Map<String, Object> queryResult = query(searchType, keyWord, -1, -1);

        if (queryResult != null) {
            goodsList = (List<Goods>) queryResult.get("data");
        }

        File file = goodsManageService.exportGoods(goodsList);

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
