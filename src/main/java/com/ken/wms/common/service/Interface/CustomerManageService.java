package com.ken.wms.common.service.Interface;


import com.ken.wms.domain.Customer;
import com.ken.wms.exception.CustomerManageServiceException;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;

public interface CustomerManageService {

    Map<String, Object> selectById(Integer customerId) throws CustomerManageServiceException;

    Map<String, Object> selectByName(int offset, int limit, String customerName) throws CustomerManageServiceException;

    Map<String, Object> selectByName(String customerName) throws CustomerManageServiceException;

    Map<String, Object> selectAll(int offset, int limit) throws CustomerManageServiceException;

    Map<String, Object> selectAll() throws CustomerManageServiceException;

    boolean addCustomer(Customer customer) throws CustomerManageServiceException;

    boolean updateCustomer(Customer customer) throws CustomerManageServiceException;

    boolean deleteCustomer(Integer customerId) throws CustomerManageServiceException;

    Map<String, Object> importCustomer(MultipartFile file) throws CustomerManageServiceException;

    File exportCustomer(List<Customer> customers);
}
