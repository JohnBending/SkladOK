package com.ken.wms.common.controller;

import com.ken.wms.common.service.Interface.SystemLogService;
import com.ken.wms.common.util.Response;
import com.ken.wms.common.util.ResponseUtil;
import com.ken.wms.domain.AccessRecordDO;
import com.ken.wms.domain.UserOperationRecordDTO;
import com.ken.wms.exception.SystemLogServiceException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value = "/systemLog")
public class SystemLogHandler {

    @Autowired
    private SystemLogService systemLogService;
    @Autowired
    private ResponseUtil responseUtil;


    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getAccessRecords", method = RequestMethod.GET)
    public @ResponseBody
    Map<String, Object> getAccessRecords(@RequestParam("userID") String userIDStr,
                                         @RequestParam("accessType") String accessType,
                                         @RequestParam("startDate") String startDateStr,
                                         @RequestParam("endDate") String endDateStr,
                                         @RequestParam("offset") int offset,
                                         @RequestParam("limit") int limit) throws SystemLogServiceException {
        Response response = responseUtil.newResponseInstance();
        List<AccessRecordDO> rows = null;
        long total = 0;

        String regex = "([0-9]{4})-([0-9]{2})-([0-9]{2})";
        boolean startDateFormatCheck = (StringUtils.isEmpty(startDateStr) || startDateStr.matches(regex));
        boolean endDateFormatCheck = (StringUtils.isEmpty(endDateStr) || endDateStr.matches(regex));
        boolean userIDCheck = (StringUtils.isEmpty(userIDStr) || StringUtils.isNumeric(userIDStr));

        if (startDateFormatCheck && endDateFormatCheck && userIDCheck) {
            Integer userID = -1;
            if (StringUtils.isNumeric(userIDStr))
                userID = Integer.valueOf(userIDStr);
            Map<String, Object> queryResult = systemLogService.selectAccessRecord(userID, accessType, startDateStr, endDateStr, offset, limit);
            if (queryResult != null) {
                rows = (List<AccessRecordDO>) queryResult.get("data");
                total = (long) queryResult.get("total");
            }
        } else
            response.setResponseMsg("Request Argument Error");

        if (rows == null)
            rows = new ArrayList<>(0);

        response.setCustomerInfo("rows", rows);
        response.setResponseTotal(total);
        return response.generateResponse();
    }


    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getUserOperationRecords")
    public @ResponseBody
    Map<String, Object> selectUserOperationRecords(@RequestParam("userID") String userIDStr,
                                                   @RequestParam("startDate") String startDateStr,
                                                   @RequestParam("endDate") String endDateStr,
                                                   @RequestParam("offset") int offset,
                                                   @RequestParam("limit") int limit) throws SystemLogServiceException {
        Response response = responseUtil.newResponseInstance();
        List<UserOperationRecordDTO> rows = null;
        long total = 0;

        String regex = "([0-9]{4})-([0-9]{2})-([0-9]{2})";
        boolean startDateFormatCheck = (StringUtils.isEmpty(startDateStr) || startDateStr.matches(regex));
        boolean endDateFormatCheck = (StringUtils.isEmpty(endDateStr) || endDateStr.matches(regex));
        boolean userIDCheck = (StringUtils.isEmpty(userIDStr) || StringUtils.isNumeric(userIDStr));

        if (startDateFormatCheck && endDateFormatCheck && userIDCheck) {
            Integer userID = -1;
            if (StringUtils.isNumeric(userIDStr))
                userID = Integer.valueOf(userIDStr);
            Map<String, Object> queryResult = systemLogService.selectUserOperationRecord(userID, startDateStr, endDateStr, offset, limit);
            if (queryResult != null) {
                rows = (List<UserOperationRecordDTO>) queryResult.get("data");
                total = (long) queryResult.get("total");
            }
        } else
            response.setResponseMsg("Request argument error");

        if (rows == null)
            rows = new ArrayList<>(0);

        response.setCustomerInfo("rows", rows);
        response.setResponseTotal(total);
        return response.generateResponse();
    }
}
