package com.ken.wms.common.service.Interface;


import com.ken.wms.domain.Supplier;
import com.ken.wms.exception.SupplierManageServiceException;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;


public interface SupplierManageService {


    Map<String, Object> selectById(Integer supplierId) throws SupplierManageServiceException;

    Map<String, Object> selectByName(int offset, int limit, String supplierName) throws SupplierManageServiceException;

    Map<String, Object> selectByName(String supplierName) throws SupplierManageServiceException;

    Map<String, Object> selectAll(int offset, int limit) throws SupplierManageServiceException;

    Map<String, Object> selectAll() throws SupplierManageServiceException;

    boolean addSupplier(Supplier supplier) throws SupplierManageServiceException;

    boolean updateSupplier(Supplier supplier) throws SupplierManageServiceException;

    boolean deleteSupplier(Integer supplierId);

    Map<String, Object> importSupplier(MultipartFile file);

    File exportSupplier(List<Supplier> suppliers);
}
