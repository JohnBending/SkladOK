package com.ken.wms.dao;

import com.ken.wms.domain.StockOutDO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;


@Repository
public interface StockOutMapper {

    List<StockOutDO> selectAll();

    List<StockOutDO> selectByCustomerId(Integer customerId);

    List<StockOutDO> selectByGoodId(Integer goodId);

    List<StockOutDO> selectByRepositoryID(Integer repositoryID);

    List<StockOutDO> selectByRepositoryIDAndDate(@Param("repositoryID") Integer repositoryID,
                                                 @Param("startDate") Date startDate,
                                                 @Param("endDate") Date endDate);


    StockOutDO selectById(Integer id);

    void insert(StockOutDO stockOutDO);

    void update(StockOutDO stockOutDO);

    void deleteById(Integer id);
}
