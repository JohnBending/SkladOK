package com.ken.wms.dao;


import com.ken.wms.domain.Goods;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GoodsMapper {

	List<Goods> selectAll();
	
	Goods selectById(Integer id);
	
	Goods selectByName(String goodsName);
	
	List<Goods> selectApproximateByName(String goodsName);
	
	void insert(Goods goods);
	
	void insertBatch(List<Goods> goods);
	
	void update(Goods goods);
	
	void deleteById(Integer id);
	
	void deleteByName(String goodsName);
}
