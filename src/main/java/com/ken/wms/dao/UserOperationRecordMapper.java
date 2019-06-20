package com.ken.wms.dao;

import com.ken.wms.domain.UserOperationRecordDO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface UserOperationRecordMapper {

    List<UserOperationRecordDO> selectUserOperationRecord(@Param("userID") Integer userID,
                                                          @Param("startDate") Date startDate,
                                                          @Param("endDate") Date endDate);

    void insertUserOperationRecord(UserOperationRecordDO userOperationRecordDO);
}
