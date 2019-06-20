package com.ken.wms.common.service.Interface;


import com.ken.wms.domain.Storage;
import com.ken.wms.exception.StorageManageServiceException;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;


public interface StorageManageService {


    Map<String, Object> selectAll(Integer repositoryID) throws StorageManageServiceException;

    Map<String, Object> selectAll(Integer repositoryID, int offset, int limit) throws StorageManageServiceException;

    Map<String, Object> selectByGoodsID(Integer goodsID, Integer repositoryID) throws StorageManageServiceException;

    Map<String, Object> selectByGoodsID(Integer goodsID, Integer repositoryID, int offset, int limit) throws StorageManageServiceException;

    Map<String, Object> selectByGoodsName(String goodsName, Integer repositoryID) throws StorageManageServiceException;

    Map<String, Object> selectByGoodsName(String goodsName, Integer repositoryID, int offset, int limit) throws StorageManageServiceException;

    Map<String, Object> selectByGoodsType(String goodsType, Integer Repository) throws StorageManageServiceException;

    Map<String, Object> selectByGoodsType(String goodsType, Integer repositoryID, int offset, int limit) throws StorageManageServiceException;

    boolean addNewStorage(Integer goodsID, Integer repositoryID, long number) throws StorageManageServiceException;

    boolean updateStorage(Integer goodsID, Integer repositoryID, long number) throws StorageManageServiceException;

    boolean storageIncrease(Integer goodsID, Integer repositoryID, long number) throws StorageManageServiceException;

    boolean storageDecrease(Integer goodsID, Integer repositoryID, long number) throws StorageManageServiceException;

    boolean deleteStorage(Integer goodsID, Integer repositoryID) throws StorageManageServiceException;

    Map<String, Object> importStorage(MultipartFile file) throws StorageManageServiceException;

    File exportStorage(List<Storage> storages);
}
