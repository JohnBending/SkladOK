package com.ken.wms.dao;

import com.ken.wms.domain.AccessRecordDO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;


@Repository
public interface AccessRecordMapper {

    void insertAccessRecord(AccessRecordDO accessRecordDO);

    List<AccessRecordDO> selectAccessRecords(@Param("userID") Integer userID,
                                             @Param("accessType") String accessType,
                                             @Param("startDate") Date startDate,
                                             @Param("endDate") Date endDate);
}
