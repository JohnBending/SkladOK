package com.ken.wms.common.service.Interface;


import com.ken.wms.domain.Goods;
import com.ken.wms.exception.GoodsManageServiceException;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;


public interface GoodsManageService {


    Map<String, Object> selectById(Integer goodsId) throws GoodsManageServiceException;

    Map<String, Object> selectByName(int offset, int limit, String goodsName) throws GoodsManageServiceException;

    Map<String, Object> selectByName(String goodsName) throws GoodsManageServiceException;

    Map<String, Object> selectAll(int offset, int limit) throws GoodsManageServiceException;

    Map<String, Object> selectAll() throws GoodsManageServiceException;

    boolean addGoods(Goods goods) throws GoodsManageServiceException;

    boolean updateGoods(Goods goods) throws GoodsManageServiceException;

    boolean deleteGoods(Integer goodsId) throws GoodsManageServiceException;

    Map<String, Object> importGoods(MultipartFile file) throws GoodsManageServiceException;

    File exportGoods(List<Goods> goods);
}
