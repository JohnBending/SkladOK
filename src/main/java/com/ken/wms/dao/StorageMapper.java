package com.ken.wms.dao;

import com.ken.wms.domain.Storage;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;


import java.util.List;


@Repository
public interface StorageMapper {

	List<Storage> selectAllAndRepositoryID(@Param("repositoryID") Integer repositoryID);

	List<Storage> selectByGoodsIDAndRepositoryID(@Param("goodsID") Integer goodsID,
												 @Param("repositoryID") Integer repositoryID);

	List<Storage> selectByGoodsNameAndRepositoryID(@Param("goodsName") String goodsName,
												   @Param("repositoryID") Integer repositoryID);

	List<Storage> selectByGoodsTypeAndRepositoryID(@Param("goodsType") String goodsType,
												   @Param("repositoryID") Integer repositoryID);

	void update(Storage storage);

	void insert(Storage storage);

	void insertBatch(List<Storage> storages);

	void deleteByGoodsID(Integer goodsID);

	void deleteByRepositoryID(Integer repositoryID);

	void deleteByRepositoryIDAndGoodsID(@Param("goodsID") Integer goodsID, @Param("repositoryID") Integer repositoryID);
}
