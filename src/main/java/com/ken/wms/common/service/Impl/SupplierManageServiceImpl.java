package com.ken.wms.common.service.Impl;

import com.ken.wms.dao.StockInMapper;
import com.ken.wms.dao.SupplierMapper;
import com.ken.wms.domain.StockInDO;
import com.ken.wms.domain.Supplier;
import com.ken.wms.exception.SupplierManageServiceException;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ken.wms.common.service.Interface.SupplierManageService;
import com.ken.wms.common.util.ExcelUtil;
import com.ken.wms.util.aop.UserOperation;
import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SupplierManageServiceImpl implements SupplierManageService {

    @Autowired
    private SupplierMapper supplierMapper;
    @Autowired
    private StockInMapper stockInMapper;
    @Autowired
    private ExcelUtil excelUtil;

    @Override
    public Map<String, Object> selectById(Integer supplierId) throws SupplierManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Supplier> suppliers = new ArrayList<>();
        long total = 0;

        Supplier supplier;
        try {
            supplier = supplierMapper.selectById(supplierId);
        } catch (PersistenceException e) {
            throw new SupplierManageServiceException(e);
        }
        if (supplier != null) {
            suppliers.add(supplier);
            total = 1;
        }

        resultSet.put("data", suppliers);
        resultSet.put("total", total);
        return resultSet;
    }

    @Override
    public Map<String, Object> selectByName(int offset, int limit, String supplierName) throws SupplierManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Supplier> suppliers;
        long total = 0;
        boolean isPagination = true;

        if (offset < 0 || limit < 0)
            isPagination = false;

        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                suppliers = supplierMapper.selectApproximateByName(supplierName);
                if (suppliers != null) {
                    PageInfo<Supplier> pageInfo = new PageInfo<>(suppliers);
                    total = pageInfo.getTotal();
                } else
                    suppliers = new ArrayList<>();
            } else {
                suppliers = supplierMapper.selectApproximateByName(supplierName);
                if (suppliers != null)
                    total = suppliers.size();
                else
                    suppliers = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new SupplierManageServiceException(e);
        }

        resultSet.put("data", suppliers);
        resultSet.put("total", total);
        return resultSet;
    }

    @Override
    public Map<String, Object> selectByName(String supplierName) throws SupplierManageServiceException {
        return selectByName(-1, -1, supplierName);
    }

    @Override
    public Map<String, Object> selectAll(int offset, int limit) throws SupplierManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Supplier> suppliers;
        long total = 0;
        boolean isPagination = true;

        // validate
        if (offset < 0 || limit < 0)
            isPagination = false;

        // query
        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                suppliers = supplierMapper.selectAll();
                if (suppliers != null) {
                    PageInfo<Supplier> pageInfo = new PageInfo<>(suppliers);
                    total = pageInfo.getTotal();
                } else
                    suppliers = new ArrayList<>();
            } else {
                suppliers = supplierMapper.selectAll();
                if (suppliers != null)
                    total = suppliers.size();
                else
                    suppliers = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new SupplierManageServiceException(e);
        }

        resultSet.put("data", suppliers);
        resultSet.put("total", total);
        return resultSet;
    }

    @Override
    public Map<String, Object> selectAll() throws SupplierManageServiceException {
        return selectAll(-1, -1);
    }

    private boolean supplierCheck(Supplier supplier) {
        return supplier.getName() != null && supplier.getPersonInCharge() != null
                && supplier.getTel() != null && supplier.getEmail() != null && supplier.getAddress() != null;
    }

    @UserOperation(value = "Добавить информацию о поставщике")
    @Override
    public boolean addSupplier(Supplier supplier) throws SupplierManageServiceException {

        if (supplier != null) {
            try {
                if (supplierCheck(supplier)) {
                    if (null == supplierMapper.selectBuName(supplier.getName())) {
                        supplierMapper.insert(supplier);
                        if (supplier.getId() != null) {
                            return true;
                        }
                    }
                }
            } catch (PersistenceException e) {
                throw new SupplierManageServiceException(e);
            }
        }
        return false;
    }

    @UserOperation(value = "Изменить информацию о поставщике")
    @Override
    public boolean updateSupplier(Supplier supplier) throws SupplierManageServiceException {

        if (supplier != null) {
            try {
                if (supplierCheck(supplier)) {
                    if (supplier.getId() != null) {
                        Supplier supplierFromDB = supplierMapper.selectBuName(supplier.getName());
                        if (supplierFromDB == null || supplier.getId().equals(supplierFromDB.getId())) {
                            supplierMapper.update(supplier);
                            return true;
                        }
                    }
                }
            } catch (PersistenceException e) {
                throw new SupplierManageServiceException(e);
            }
        }
        return false;
    }

    @UserOperation(value = "Удалить информацию о поставщике")
    @Override
    public boolean deleteSupplier(Integer supplierId) {

        List<StockInDO> records = stockInMapper.selectBySupplierId(supplierId);
        if (records == null || records.size() > 0)
            return false;

        supplierMapper.deleteById(supplierId);
        return true;
    }

    @UserOperation(value = "Импорт информации о поставщике")
    @Override
    public Map<String, Object> importSupplier(MultipartFile file) {
        Map<String, Object> result = new HashMap<>();
        int total = 0;
        int available = 0;

        List<Object> suppliers = excelUtil.excelReader(Supplier.class, file);
        if (suppliers != null) {
            total = suppliers.size();

            Supplier supplier;
            List<Supplier> availableList = new ArrayList<>();
            for (Object object : suppliers) {
                supplier = (Supplier) object;
                if (supplierCheck(supplier)) {
                    if (null == supplierMapper.selectBuName(supplier.getName()))
                        availableList.add(supplier);
                }
            }

            available = availableList.size();
            if (available > 0) {
                supplierMapper.insertBatch(availableList);
            }
        }

        result.put("total", total);
        result.put("available", available);
        return result;
    }

    @UserOperation(value = "Экспорт информации о поставщике")
    @Override
    public File exportSupplier(List<Supplier> suppliers) {
        if (suppliers == null)
            return null;

        return excelUtil.excelWriter(Supplier.class, suppliers);
    }
}
