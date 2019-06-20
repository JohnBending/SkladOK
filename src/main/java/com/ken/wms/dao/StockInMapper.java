package com.ken.wms.dao;

import com.ken.wms.domain.StockInDO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;


@Repository
public interface StockInMapper {


    List<StockInDO> selectAll();

    List<StockInDO> selectBySupplierId(Integer supplierID);

    List<StockInDO> selectByGoodID(Integer goodID);

    List<StockInDO> selectByRepositoryID(Integer repositoryID);

    List<StockInDO> selectByRepositoryIDAndDate(@Param("repositoryID") Integer repositoryID,
                                                @Param("startDate") Date startDate,
                                                @Param("endDate") Date endDate);

    StockInDO selectByID(Integer id);

    void insert(StockInDO stockInDO);

    void update(StockInDO stockInDO);

    void deleteByID(Integer id);
}
