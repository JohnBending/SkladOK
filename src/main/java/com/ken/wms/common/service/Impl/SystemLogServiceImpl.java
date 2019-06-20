package com.ken.wms.common.service.Impl;

import com.ken.wms.dao.AccessRecordMapper;
import com.ken.wms.dao.UserOperationRecordMapper;
import com.ken.wms.domain.AccessRecordDO;
import com.ken.wms.domain.AccessRecordDTO;
import com.ken.wms.domain.UserOperationRecordDO;
import com.ken.wms.domain.UserOperationRecordDTO;
import com.ken.wms.exception.SystemLogServiceException;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ken.wms.common.service.Interface.SystemLogService;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Service
public class SystemLogServiceImpl implements SystemLogService {

    @Autowired
    private AccessRecordMapper accessRecordMapper;
    @Autowired
    private UserOperationRecordMapper userOperationRecordMapper;


    @Override
    public void insertAccessRecord(Integer userID, String userName, String accessIP, String accessType) throws SystemLogServiceException {

        AccessRecordDO accessRecordDO = new AccessRecordDO();
        accessRecordDO.setUserID(userID);
        accessRecordDO.setUserName(userName);
        accessRecordDO.setAccessTime(new Date());
        accessRecordDO.setAccessIP(accessIP);
        accessRecordDO.setAccessType(accessType);


        try {
            accessRecordMapper.insertAccessRecord(accessRecordDO);
        } catch (PersistenceException e) {
            throw new SystemLogServiceException(e, "Fail to persist AccessRecordDO Object");
        }
    }


    @Override
    public Map<String, Object> selectAccessRecord(Integer userID, String accessType, String startDateStr, String endDateStr) throws SystemLogServiceException {
        return selectAccessRecord(userID, accessType, startDateStr, endDateStr, -1, -1);
    }


    @Override
    public Map<String, Object> selectAccessRecord(Integer userID, String accessType, String startDateStr, String endDateStr, int offset, int limit) throws SystemLogServiceException {

        Map<String, Object> resultSet = new HashMap<>();
        List<AccessRecordDTO> accessRecordDTOS = new ArrayList<>();
        long total = 0;
        boolean isPagination = true;


        if (offset < 0 || limit < 0)
            isPagination = false;


        Date startDate = null;
        Date endDate = null;
        Date newEndDate = null;
        try {
            if (StringUtils.isNotEmpty(startDateStr))
                startDate = dateFormatSimple.parse(startDateStr);
            if (StringUtils.isNotEmpty(endDateStr))
            {
                endDate = dateFormatSimple.parse(endDateStr);
                newEndDate = new Date(endDate.getTime()+(24*60*60*1000)-1);
            }
        } catch (ParseException e) {
            throw new SystemLogServiceException(e, "Fail to convert string to Date Object");
        }


        switch (accessType) {
            case "loginOnly":
                accessType = SystemLogService.ACCESS_TYPE_LOGIN;
                break;
            case "logoutOnly":
                accessType = SystemLogService.ACCESS_TYPE_LOGOUT;
                break;
            default:
                accessType = "all";
                break;
        }


        List<AccessRecordDO> accessRecordDOS;
        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                accessRecordDOS = accessRecordMapper.selectAccessRecords(userID, accessType, startDate, newEndDate);
                if (accessRecordDOS != null) {
                    accessRecordDOS.forEach(accessRecordDO -> accessRecordDTOS.add(convertAccessRecordDOToAccessRecordDTO(accessRecordDO)));
                    total = new PageInfo<>(accessRecordDOS).getTotal();
                }
            } else {
                accessRecordDOS = accessRecordMapper.selectAccessRecords(userID, accessType, startDate, endDate);
                if (accessRecordDOS != null) {
                    accessRecordDOS.forEach(accessRecordDO -> accessRecordDTOS.add(convertAccessRecordDOToAccessRecordDTO(accessRecordDO)));
                    total = accessRecordDOS.size();
                }
            }
        } catch (PersistenceException e) {
            throw new SystemLogServiceException(e);
        }

        resultSet.put("data", accessRecordDTOS);
        resultSet.put("total", total);
        return resultSet;
    }


    @Override
    public void insertUserOperationRecord(Integer userID, String userName, String operationName, String operationResult) throws SystemLogServiceException {
        UserOperationRecordDO userOperationRecordDO = new UserOperationRecordDO();
        userOperationRecordDO.setUserID(userID);
        userOperationRecordDO.setUserName(userName);
        userOperationRecordDO.setOperationName(operationName);
        userOperationRecordDO.setOperationResult(operationResult);
        userOperationRecordDO.setOperationTime(new Date());


        try {
            userOperationRecordMapper.insertUserOperationRecord(userOperationRecordDO);
        } catch (PersistenceException e) {
            throw new SystemLogServiceException(e, "Fail to persist usrOperationRecordDo Object");
        }
    }


    @Override
    public Map<String, Object> selectUserOperationRecord(Integer userID, String startDateStr, String endDateStr) throws SystemLogServiceException {
        return selectUserOperationRecord(userID, startDateStr, endDateStr, -1, -1);
    }


    @Override
    public Map<String, Object> selectUserOperationRecord(Integer userID, String startDateStr, String endDateStr, int offset, int limit) throws SystemLogServiceException {

        Map<String, Object> resultSet = new HashMap<>();
        List<UserOperationRecordDTO> userOperationRecordDTOS = new ArrayList<>();
        long total = 0;
        boolean isPaginarion = true;


        if (offset < 0 && limit < 0)
            isPaginarion = false;

        // Date
        Date startDate = null;
        Date endDate = null;
        Date newEndDate = null;
        try {
            if (StringUtils.isNotEmpty(startDateStr))
                startDate = dateFormatSimple.parse(startDateStr);
            if (StringUtils.isNotEmpty(endDateStr))
            {
                endDate = dateFormatSimple.parse(endDateStr);
                newEndDate = new Date(endDate.getTime()+(24*60*60*1000)-1);
            }
        } catch (ParseException e) {
            throw new SystemLogServiceException(e, "Fail to convert String format date to Date Object");
        }


        List<UserOperationRecordDO> userOperationRecordDOS;
        try {
            if (isPaginarion) {
                PageHelper.offsetPage(offset, limit);
                userOperationRecordDOS = userOperationRecordMapper.selectUserOperationRecord(userID, startDate, newEndDate);
                if (userOperationRecordDOS != null) {
                    userOperationRecordDOS.forEach(userOperationRecordDO -> userOperationRecordDTOS.add(convertUserOperationRecordDOToUserOperationRecordDTO(userOperationRecordDO)));
                    total = new PageInfo<>(userOperationRecordDOS).getTotal();
                }
            } else {
                userOperationRecordDOS = userOperationRecordMapper.selectUserOperationRecord(userID, startDate, endDate);
                if (userOperationRecordDOS != null)
                    userOperationRecordDOS.forEach(userOperationRecordDO -> userOperationRecordDTOS.add(convertUserOperationRecordDOToUserOperationRecordDTO(userOperationRecordDO)));
            }
        } catch (PersistenceException e) {
            throw new SystemLogServiceException(e);
        }

        resultSet.put("data", userOperationRecordDTOS);
        resultSet.put("total", total);
        return resultSet;
    }


    private DateFormat dateFormatDetail = new SimpleDateFormat("yyyy-MM-dd hh:mm");

    private DateFormat dateFormatSimple = new SimpleDateFormat("yyyy-MM-dd");


    private AccessRecordDTO convertAccessRecordDOToAccessRecordDTO(AccessRecordDO accessRecordDO) {
        AccessRecordDTO accessRecordDTO = new AccessRecordDTO();
        accessRecordDTO.setId(accessRecordDO.getId());
        accessRecordDTO.setUserID(accessRecordDO.getUserID());
        accessRecordDTO.setUserName(accessRecordDO.getUserName());
        accessRecordDTO.setAccessIP(accessRecordDO.getAccessIP());
        accessRecordDTO.setAccessType(accessRecordDO.getAccessType().equals(SystemLogService.ACCESS_TYPE_LOGIN) ? "Вход" : "Выход");
        accessRecordDTO.setAccessTime(dateFormatDetail.format(accessRecordDO.getAccessTime()));
        return accessRecordDTO;
    }


    private UserOperationRecordDTO convertUserOperationRecordDOToUserOperationRecordDTO(UserOperationRecordDO userOperationRecordDO) {
        UserOperationRecordDTO userOperationRecordDTO = new UserOperationRecordDTO();
        userOperationRecordDTO.setId(userOperationRecordDO.getId());
        userOperationRecordDTO.setUserID(userOperationRecordDO.getUserID());
        userOperationRecordDTO.setUserName(userOperationRecordDO.getUserName());
        userOperationRecordDTO.setOperationName(userOperationRecordDO.getOperationName());
        userOperationRecordDTO.setOperationResult(userOperationRecordDO.getOperationResult());
        userOperationRecordDTO.setOperationTime(dateFormatDetail.format(userOperationRecordDO.getOperationTime()));
        return userOperationRecordDTO;
    }
}
