package com.ken.wms.dao;

import com.ken.wms.domain.Customer;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CustomerMapper {

	List<Customer> selectAll();
	
	Customer selectById(Integer id);
	
	Customer selectByName(String customerName);
	
	List<Customer> selectApproximateByName(String customerName);
	
	void insert(Customer customer);
	
	void insertBatch(List<Customer> customers);
	
	void update(Customer customer);
	
	void deleteById(Integer id);
	
	void deleteByName(String customerName);
}
