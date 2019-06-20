package com.ken.wms.common.service.Impl;


import com.ken.wms.exception.StockRecordManageServiceException;
import com.ken.wms.exception.StorageManageServiceException;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ken.wms.common.service.Interface.StockRecordManageService;
import com.ken.wms.common.service.Interface.StorageManageService;
import com.ken.wms.dao.*;
import com.ken.wms.domain.*;
import com.ken.wms.util.aop.UserOperation;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class StockRecordManageServiceImpl implements StockRecordManageService {

    @Autowired
    private SupplierMapper supplierMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private GoodsMapper goodsMapper;
    @Autowired
    private RepositoryMapper repositoryMapper;
    @Autowired
    private StorageManageService storageManageService;
    @Autowired
    private StockInMapper stockinMapper;
    @Autowired
    private StockOutMapper stockOutMapper;


    @UserOperation(value = "Хранение товаров")
    @Override
    public boolean stockInOperation(Integer supplierID, Integer goodsID, Integer repositoryID, long number, String personInCharge) throws StockRecordManageServiceException {

        if (!(supplierValidate(supplierID) && goodsValidate(goodsID) && repositoryValidate(repositoryID)))
            return false;

        if (personInCharge == null)
            return false;

        if (number < 0)
            return false;

        try {
            boolean isSuccess;
            isSuccess = storageManageService.storageIncrease(goodsID, repositoryID, number);

            if (isSuccess) {
                StockInDO stockInDO = new StockInDO();
                stockInDO.setGoodID(goodsID);
                stockInDO.setSupplierID(supplierID);
                stockInDO.setNumber(number);
                stockInDO.setPersonInCharge(personInCharge);
                stockInDO.setTime(new Date());
                stockInDO.setRepositoryID(repositoryID);
                stockinMapper.insert(stockInDO);
            }

            return isSuccess;
        } catch (PersistenceException | StorageManageServiceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    @UserOperation(value = "Товары со склада")
    @Override
    public boolean stockOutOperation(Integer customerID, Integer goodsID, Integer repositoryID, long number, String personInCharge) throws StockRecordManageServiceException {

        if (!(customerValidate(customerID) && goodsValidate(goodsID) && repositoryValidate(repositoryID)))
            return false;

        if (number < 0)
            return false;

        try {
            boolean isSuccess;
            isSuccess = storageManageService.storageDecrease(goodsID, repositoryID, number);

            if (isSuccess) {
                StockOutDO stockOutDO = new StockOutDO();
                stockOutDO.setCustomerID(customerID);
                stockOutDO.setGoodID(goodsID);
                stockOutDO.setNumber(number);
                stockOutDO.setPersonInCharge(personInCharge);
                stockOutDO.setRepositoryID(repositoryID);
                stockOutDO.setTime(new Date());
                stockOutMapper.insert(stockOutDO);
            }

            return isSuccess;
        } catch (PersistenceException | StorageManageServiceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    @Override
    public Map<String, Object> selectStockRecord(Integer repositoryID, String startDateStr, String endDateStr, String searchType) throws StockRecordManageServiceException {
        return selectStockRecord(repositoryID, startDateStr, endDateStr, searchType, -1, -1);
    }

    @SuppressWarnings("unchecked")
    @Override
    public Map<String, Object> selectStockRecord(Integer repositoryID, String startDateStr, String endDateStr, String searchType, int offset, int limit) throws StockRecordManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        long total = 0;

        if (repositoryID == null || searchType == null)
            throw new StockRecordManageServiceException("exception");

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = null;
        Date endDate = null;
        Date newEndDate = null;
        try {
            if (StringUtils.isNotEmpty(startDateStr))
                startDate = dateFormat.parse(startDateStr);
            if (StringUtils.isNotEmpty(endDateStr))
            {
                endDate = dateFormat.parse(endDateStr);
                newEndDate = new Date(endDate.getTime()+(24*60*60*1000)-1);
            }
        } catch (ParseException e) {
            throw new StockRecordManageServiceException(e);
        }

        List<StockRecordDTO> stockRecordDTOS = new ArrayList<>();
        Map<String, Object> stockInTemp;
        Map<String, Object> stockOutTemp;
        List<StockInDO> stockInRecordDOS = null;
        List<StockOutDO> stockOutRecordDOS = null;
        switch (searchType) {
            case "all": {
                if (offset < 0 || limit < 0) {
                    stockInTemp = selectStockInRecord(repositoryID, startDate, endDate, offset, limit);
                    stockOutTemp = selectStockOutRecord(repositoryID, startDate, endDate, offset, limit);
                    stockInRecordDOS = (List<StockInDO>) stockInTemp.get("data");
                    stockOutRecordDOS = (List<StockOutDO>) stockOutTemp.get("data");
                } else {
                    int stockInRecordOffset = offset / 2;
                    int stockOutRecordOffset = stockInRecordOffset * 2 < offset ? stockInRecordOffset + 1 : stockInRecordOffset;
                    int stockInRecordLimit = limit / 2;
                    int stockOutRecordLimit = stockInRecordLimit * 2 < limit ? stockInRecordLimit + 1 : stockInRecordLimit;

                    stockInTemp = selectStockInRecord(repositoryID, startDate, newEndDate, stockInRecordOffset, limit);
                    stockOutTemp = selectStockOutRecord(repositoryID, startDate, newEndDate, stockOutRecordOffset, limit);

                    stockInRecordDOS = (List<StockInDO>) stockInTemp.get("data");
                    stockOutRecordDOS = (List<StockOutDO>) stockOutTemp.get("data");

                    int stockInRecordDosSize = stockInRecordDOS.size();
                    int stockOutRecordDoSize = stockOutRecordDOS.size();
                    if (stockInRecordDosSize >= stockInRecordLimit && stockOutRecordDoSize >= stockOutRecordLimit) {
                        stockInRecordDOS = stockInRecordDOS.subList(0, stockInRecordLimit);
                        stockOutRecordDOS = stockOutRecordDOS.subList(0, stockOutRecordLimit);
                    } else if (stockInRecordDosSize < stockInRecordLimit && stockOutRecordDoSize > stockOutRecordLimit) {
                        int appendSize = (stockOutRecordDoSize - stockOutRecordLimit) > (stockInRecordLimit - stockInRecordDosSize) ?
                                (stockInRecordLimit - stockInRecordDosSize) : (stockOutRecordDoSize - stockOutRecordLimit);
                        stockOutRecordDOS = stockOutRecordDOS.subList(0, stockInRecordLimit + appendSize - 1);
                    } else if (stockOutRecordDoSize < stockOutRecordLimit && stockInRecordDosSize > stockInRecordLimit) {
                        int appendSize = (stockInRecordDosSize - stockInRecordLimit) > (stockOutRecordLimit - stockOutRecordDoSize) ?
                                (stockOutRecordLimit - stockOutRecordDoSize) : (stockInRecordDosSize - stockInRecordLimit);
                        stockInRecordDOS = stockInRecordDOS.subList(0, stockInRecordLimit + appendSize);
                    }
                }
                long stockInRecordDOSTotal = (long) stockInTemp.get("total");
                long stockOutRecordDOSTotal = (long) stockOutTemp.get("total");
                total = stockInRecordDOSTotal + stockOutRecordDOSTotal;
                break;
            }
            case "stockInOnly": {
                stockInTemp = selectStockInRecord(repositoryID, startDate, newEndDate, offset, limit);
                total = (long) stockInTemp.get("total");
                stockInRecordDOS = (List<StockInDO>) stockInTemp.get("data");
                break;
            }
            case "stockOutOnly": {
                stockOutTemp = selectStockOutRecord(repositoryID, startDate, newEndDate, offset, limit);
                total = (long) stockOutTemp.get("total");
                stockOutRecordDOS = (List<StockOutDO>) stockOutTemp.get("data");
                break;
            }
            case "none": {
                break;
            }
        }

        if (stockInRecordDOS != null)
            stockInRecordDOS.forEach(stockInDO -> stockRecordDTOS.add(stockInRecordConvertToStockRecordDTO(stockInDO)));
        if (stockOutRecordDOS != null)
            stockOutRecordDOS.forEach(stockOutDO -> stockRecordDTOS.add(stockOutDoConvertToStockRecordDTO(stockOutDO)));

        resultSet.put("data", stockRecordDTOS);
        resultSet.put("total", total);
        return resultSet;
    }

    private Map<String, Object> selectStockInRecord(Integer repositoryID, Date startDate, Date endDate, int offset, int limit) throws StockRecordManageServiceException {
        Map<String, Object> result = new HashMap<>();
        List<StockInDO> stockInRecords;
        long stockInTotal = 0;
        boolean isPagination = true;

        if (offset < 0 || limit < 0)
            isPagination = false;

        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                stockInRecords = stockinMapper.selectByRepositoryIDAndDate(repositoryID, startDate, endDate);
                if (stockInRecords != null)
                    stockInTotal = new PageInfo<>(stockInRecords).getTotal();
                else
                    stockInRecords = new ArrayList<>(10);
            } else {
                stockInRecords = stockinMapper.selectByRepositoryIDAndDate(repositoryID, startDate, endDate);
                if (stockInRecords != null)
                    stockInTotal = stockInRecords.size();
                else
                    stockInRecords = new ArrayList<>(10);
            }
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }

        result.put("data", stockInRecords);
        result.put("total", stockInTotal);
        return result;
    }

    private Map<String, Object> selectStockOutRecord(Integer repositoryID, Date startDate, Date endDate, int offset, int limit) throws StockRecordManageServiceException {
        Map<String, Object> result = new HashMap<>();
        List<StockOutDO> stockOutRecords;
        long stockOutRecordTotal = 0;
        boolean isPagination = true;

        if (offset < 0 || limit < 0)
            isPagination = false;

        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                stockOutRecords = stockOutMapper.selectByRepositoryIDAndDate(repositoryID, startDate, endDate);
                if (stockOutRecords != null)
                    stockOutRecordTotal = new PageInfo<>(stockOutRecords).getTotal();
                else
                    stockOutRecords = new ArrayList<>(10);
            } else {
                stockOutRecords = stockOutMapper.selectByRepositoryIDAndDate(repositoryID, startDate, endDate);
                if (stockOutRecords != null)
                    stockOutRecordTotal = stockOutRecords.size();
                else
                    stockOutRecords = new ArrayList<>(10);
            }
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }

        result.put("data", stockOutRecords);
        result.put("total", stockOutRecordTotal);
        return result;
    }

    private DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd-hh-mm");

    private StockRecordDTO stockInRecordConvertToStockRecordDTO(StockInDO stockInDO) {
        StockRecordDTO stockRecordDTO = new StockRecordDTO();
        stockRecordDTO.setRecordID(stockInDO.getId());
        stockRecordDTO.setSupplierOrCustomerName(stockInDO.getSupplierName());
        stockRecordDTO.setGoodsName(stockInDO.getGoodName());
        stockRecordDTO.setNumber(stockInDO.getNumber());
        stockRecordDTO.setTime(dateFormat.format(stockInDO.getTime()));
        stockRecordDTO.setRepositoryID(stockInDO.getRepositoryID());
        stockRecordDTO.setPersonInCharge(stockInDO.getPersonInCharge());
        stockRecordDTO.setType("Хранение");
        return stockRecordDTO;
    }

    private StockRecordDTO stockOutDoConvertToStockRecordDTO(StockOutDO stockOutDO) {
        StockRecordDTO stockRecordDTO = new StockRecordDTO();
        stockRecordDTO.setRecordID(stockOutDO.getId());
        stockRecordDTO.setSupplierOrCustomerName(stockOutDO.getCustomerName());
        stockRecordDTO.setGoodsName(stockOutDO.getCustomerName());
        stockRecordDTO.setNumber(stockOutDO.getNumber());
        stockRecordDTO.setTime(dateFormat.format(stockOutDO.getTime()));
        stockRecordDTO.setRepositoryID(stockOutDO.getRepositoryID());
        stockRecordDTO.setPersonInCharge(stockOutDO.getPersonInCharge());
        stockRecordDTO.setType("Из склада");
        return stockRecordDTO;
    }



    private boolean goodsValidate(Integer goodsID) throws StockRecordManageServiceException {
        try {
            Goods goods = goodsMapper.selectById(goodsID);
            return goods != null;
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }


    private boolean repositoryValidate(Integer repositoryID) throws StockRecordManageServiceException {
        try {
            Repository repository = repositoryMapper.selectByID(repositoryID);
            return repository != null;
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }


    private boolean supplierValidate(Integer supplierID) throws StockRecordManageServiceException {
        try {
            Supplier supplier = supplierMapper.selectById(supplierID);
            return supplier != null;
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

    private boolean customerValidate(Integer cumtomerID) throws StockRecordManageServiceException {
        try {
            Customer customer = customerMapper.selectById(cumtomerID);
            return customer != null;
        } catch (PersistenceException e) {
            throw new StockRecordManageServiceException(e);
        }
    }

}
