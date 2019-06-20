package com.ken.wms.common.service.Impl;

import com.ken.wms.dao.GoodsMapper;
import com.ken.wms.dao.RepositoryMapper;
import com.ken.wms.dao.StorageMapper;
import com.ken.wms.domain.Goods;
import com.ken.wms.domain.Repository;
import com.ken.wms.domain.Storage;
import com.ken.wms.exception.StorageManageServiceException;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ken.wms.common.service.Interface.StorageManageService;
import com.ken.wms.common.util.ExcelUtil;
import com.ken.wms.util.aop.UserOperation;
import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class StorageManageServiceImpl implements StorageManageService {

    @Autowired
    private StorageMapper storageMapper;
    @Autowired
    private GoodsMapper goodsMapper;
    @Autowired
    private RepositoryMapper repositoryMapper;
    @Autowired
    private ExcelUtil excelUtil;


    @Override
    public Map<String, Object> selectAll(Integer repository) throws StorageManageServiceException {
        return selectAll(repository, -1, -1);
    }


    @Override
    public Map<String, Object> selectAll(Integer repositoryID, int offset, int limit) throws StorageManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Storage> storageList;
        long total = 0;
        boolean isPagination = true;

        if (offset < 0 || limit < 0)
            isPagination = false;

        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                storageList = storageMapper.selectAllAndRepositoryID(repositoryID);
                if (storageList != null) {
                    PageInfo<Storage> pageInfo = new PageInfo<>(storageList);
                    total = pageInfo.getTotal();
                } else
                    storageList = new ArrayList<>();
            } else {
                storageList = storageMapper.selectAllAndRepositoryID(repositoryID);
                if (storageList != null)
                    total = storageList.size();
                else
                    storageList = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new StorageManageServiceException(e);
        }

        resultSet.put("data", storageList);
        resultSet.put("total", total);
        return resultSet;
    }

    @Override
    public Map<String, Object> selectByGoodsID(Integer goodsID, Integer repository) throws StorageManageServiceException {
        return selectByGoodsID(goodsID, repository, -1, -1);
    }

    @Override
    public Map<String, Object> selectByGoodsID(Integer goodsID, Integer repositoryID, int offset, int limit) throws StorageManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Storage> storageList;
        long total = 0;
        boolean isPagination = true;

        if (offset < 0 || limit < 0)
            isPagination = false;

        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                storageList = storageMapper.selectByGoodsIDAndRepositoryID(goodsID, repositoryID);
                if (storageList != null) {
                    PageInfo<Storage> pageInfo = new PageInfo<>(storageList);
                    total = pageInfo.getTotal();
                } else
                    storageList = new ArrayList<>();
            } else {
                storageList = storageMapper.selectByGoodsIDAndRepositoryID(goodsID, repositoryID);
                if (storageList != null)
                    total = storageList.size();
                else
                    storageList = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new StorageManageServiceException(e);
        }

        resultSet.put("data", storageList);
        resultSet.put("total", total);
        return resultSet;
    }

    @Override
    public Map<String, Object> selectByGoodsName(String goodsName, Integer repository) throws StorageManageServiceException {
        return selectByGoodsName(goodsName, repository, -1, -1);
    }

    @Override
    public Map<String, Object> selectByGoodsName(String goodsName, Integer repositoryID, int offset, int limit) throws StorageManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Storage> storageList;
        long total = 0;
        boolean isPagination = true;

        if (offset < 0 || limit < 0)
            isPagination = false;

        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                storageList = storageMapper.selectByGoodsNameAndRepositoryID(goodsName, repositoryID);
                if (storageList != null) {
                    PageInfo<Storage> pageInfo = new PageInfo<>(storageList);
                    total = pageInfo.getTotal();
                } else
                    storageList = new ArrayList<>();
            } else {
                storageList = storageMapper.selectByGoodsNameAndRepositoryID(goodsName, repositoryID);
                if (storageList != null)
                    total = storageList.size();
                else
                    storageList = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new StorageManageServiceException(e);
        }

        resultSet.put("data", storageList);
        resultSet.put("total", total);
        return resultSet;
    }

    @Override
    public Map<String, Object> selectByGoodsType(String goodsType, Integer repositoryID) throws StorageManageServiceException {
        return selectByGoodsType(goodsType, repositoryID, -1, -1);
    }

    @Override
    public Map<String, Object> selectByGoodsType(String goodsType, Integer repositoryID, int offset, int limit) throws StorageManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Storage> storageList;
        long total = 0;
        boolean isPaginatin = true;

        if (offset < 0 || limit < 0)
            isPaginatin = false;

        try {
            if (isPaginatin) {
                PageHelper.offsetPage(offset, limit);
                storageList = storageMapper.selectByGoodsTypeAndRepositoryID(goodsType, repositoryID);
                if (storageList != null) {
                    PageInfo<Storage> pageInfo = new PageInfo<>(storageList);
                    total = pageInfo.getTotal();
                } else
                    storageList = new ArrayList<>();
            } else {
                storageList = storageMapper.selectByGoodsTypeAndRepositoryID(goodsType, repositoryID);
                if (storageList != null)
                    total = storageList.size();
                else
                    storageList = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new StorageManageServiceException(e);
        }

        resultSet.put("data", storageList);
        resultSet.put("total", total);
        return resultSet;
    }

    @UserOperation(value = "Добавить учетную запись")
    @Override
    public boolean addNewStorage(Integer goodsID, Integer repositoryID, long number) throws StorageManageServiceException {
        try {
            boolean isAvailable = true;

            // validate
            Goods goods = goodsMapper.selectById(goodsID);
            Repository repository = repositoryMapper.selectByID(repositoryID);
            if (goods == null)
                isAvailable = false;
            if (repository == null)
                isAvailable = false;
            if (number < 0)
                isAvailable = false;
            List<Storage> storageList = storageMapper.selectByGoodsIDAndRepositoryID(goodsID, repositoryID);
            if (!(storageList != null && storageList.isEmpty()))
                isAvailable = false;

            if (isAvailable) {
                // insert
                Storage storage = new Storage();
                storage.setGoodsID(goodsID);
                storage.setRepositoryID(repositoryID);
                storage.setNumber(number);
                storageMapper.insert(storage);
            }

            return isAvailable;
        } catch (PersistenceException e) {
            throw new StorageManageServiceException(e);
        }
    }


    @UserOperation(value = "Изменить учетную запись")
    @Override
    public boolean updateStorage(Integer goodsID, Integer repositoryID, long number) throws StorageManageServiceException {
        try {
            boolean isUpdate = false;

            List<Storage> storageList = storageMapper.selectByGoodsIDAndRepositoryID(goodsID, repositoryID);
            if (storageList != null && !storageList.isEmpty()) {
                if (number >= 0) {
                    Storage storage = storageList.get(0);
                    storage.setNumber(number);
                    storageMapper.update(storage);
                    isUpdate = true;
                }
            }

            return isUpdate;
        } catch (PersistenceException e) {
            throw new StorageManageServiceException(e);
        }
    }

    @UserOperation(value = "Удалить учетную запись")
    @Override
    public boolean deleteStorage(Integer goodsID, Integer repositoryID) throws StorageManageServiceException {
        try {
            boolean isDelete = false;

            // validate
            List<Storage> storageList = storageMapper.selectByGoodsIDAndRepositoryID(goodsID, repositoryID);
            if (storageList != null && !storageList.isEmpty()) {
                // delete
                storageMapper.deleteByRepositoryIDAndGoodsID(goodsID, repositoryID);
                isDelete = true;
            }

            return isDelete;
        } catch (PersistenceException e) {
            throw new StorageManageServiceException(e);
        }
    }

    @UserOperation(value = "Импорт учетных записей")
    @Override
    public Map<String, Object> importStorage(MultipartFile file) throws StorageManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        int total = 0;
        int available = 0;

        List<Object> storageList = excelUtil.excelReader(Storage.class, file);
        if (storageList != null) {
            total = storageList.size();

            try {
                Storage storage;
                boolean isAvailable;
                List<Storage> availableList = new ArrayList<>();
                Goods goods;
                Repository repository;
                for (Object object : storageList) {
                    isAvailable = true;
                    storage = (Storage) object;

                    // validate
                    goods = goodsMapper.selectById(storage.getGoodsID());
                    repository = repositoryMapper.selectByID(storage.getRepositoryID());
                    if (goods == null)
                        isAvailable = false;
                    if (repository == null)
                        isAvailable = false;
                    if (storage.getNumber() < 0)
                        isAvailable = false;
                    List<Storage> temp = storageMapper.selectByGoodsIDAndRepositoryID(storage.getGoodsID(), storage.getRepositoryID());
                    if (!(temp != null && temp.isEmpty()))
                        isAvailable = false;

                    if (isAvailable) {
                        availableList.add(storage);
                    }
                }
                available = availableList.size();
                System.out.println(available);
                if (available > 0)
                    storageMapper.insertBatch(availableList);
            } catch (PersistenceException e) {
                throw new StorageManageServiceException(e);
            }
        }

        resultSet.put("total", total);
        resultSet.put("available", available);
        return resultSet;
    }

    @UserOperation(value = "Экспорт учетных записей")
    @Override
    public File exportStorage(List<Storage> storageList) {
        if (storageList == null)
            return null;
        return excelUtil.excelWriter(Storage.class, storageList);
    }

    @Override
    public boolean storageIncrease(Integer goodsID, Integer repositoryID, long number) throws StorageManageServiceException {

        if (number < 0)
            return false;

        synchronized (this) {
            Storage storage = getStorage(goodsID, repositoryID);
            if (storage != null) {
                long newStorage = storage.getNumber() + number;
                updateStorage(goodsID, repositoryID, newStorage);
            } else {
                addNewStorage(goodsID, repositoryID, number);
            }
        }
        return true;
    }

    @Override
    public boolean storageDecrease(Integer goodsID, Integer repositoryID, long number) throws StorageManageServiceException {

        synchronized (this) {
            Storage storage = getStorage(goodsID, repositoryID);
            if (null != storage) {
                if (number < 0 || storage.getNumber() < number)
                    return false;

                long newStorage = storage.getNumber() - number;
                updateStorage(goodsID, repositoryID, newStorage);
                return true;
            } else
                return false;
        }
    }

    private Storage getStorage(Integer goodsID, Integer repositoryID) {
        Storage storage = null;
        List<Storage> storageList = storageMapper.selectByGoodsIDAndRepositoryID(goodsID, repositoryID);
        if (!storageList.isEmpty())
            storage = storageList.get(0);
        return storage;
    }
}
