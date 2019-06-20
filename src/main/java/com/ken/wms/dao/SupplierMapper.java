package com.ken.wms.dao;

import com.ken.wms.domain.Supplier;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface SupplierMapper {


	List<Supplier> selectAll();

	Supplier selectById(Integer id);

	Supplier selectBuName(String supplierName);

	List<Supplier> selectApproximateByName(String supplierName);

	void insert(Supplier supplier);

	void insertBatch(List<Supplier> suppliers);

	void update(Supplier supplier);

	void deleteById(Integer id);

	void deleteByName(String supplierName);
	
}
