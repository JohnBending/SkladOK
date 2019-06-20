package com.ken.wms.common.service.Interface;

import com.ken.wms.exception.StockRecordManageServiceException;

import java.util.Map;


public interface StockRecordManageService {

    boolean stockInOperation(Integer supplierID, Integer goodsID, Integer repositoryID, long number, String personInCharge) throws StockRecordManageServiceException;

    boolean stockOutOperation(Integer customerID, Integer goodsID, Integer repositoryID, long number, String personInCharge) throws StockRecordManageServiceException;

    Map<String, Object> selectStockRecord(Integer repositoryID, String startDateStr, String endDateStr, String searchType) throws StockRecordManageServiceException;

    Map<String, Object> selectStockRecord(Integer repositoryID, String startDateStr, String endDateStr, String searchType, int offset, int limit) throws StockRecordManageServiceException;
}
