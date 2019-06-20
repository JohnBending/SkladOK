package com.ken.wms.common.service.Impl;

import com.ken.wms.common.service.Interface.RepositoryService;

import com.ken.wms.exception.RepositoryManageServiceException;
import com.ken.wms.util.aop.UserOperation;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ken.wms.common.util.ExcelUtil;
import com.ken.wms.dao.*;
import com.ken.wms.domain.*;

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
public class RepositoryManageServiceImpl implements RepositoryService {

    @Autowired
    private RepositoryMapper repositoryMapper;
    @Autowired
    private ExcelUtil excelUtil;
    @Autowired
    private StockInMapper stockInMapper;
    @Autowired
    private StockOutMapper stockOutMapper;
    @Autowired
    private StorageMapper storageMapper;
    @Autowired
    private RepositoryAdminMapper repositoryAdminMapper;


    @Override
    public Map<String, Object> selectById(Integer repositoryId) throws RepositoryManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Repository> repositories = new ArrayList<>();
        long total = 0;

        Repository repository;
        try {
            repository = repositoryMapper.selectByID(repositoryId);
        } catch (PersistenceException e) {
            throw new RepositoryManageServiceException(e);
        }

        if (repository != null) {
            repositories.add(repository);
            total = 1;
        }

        resultSet.put("data", repositories);
        resultSet.put("total", total);
        return resultSet;
    }


    @Override
    public Map<String, Object> selectByAddress(int offset, int limit, String address) throws RepositoryManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Repository> repositories;
        long total = 0;
        boolean isPagination = true;

        // validate
        if (offset < 0 || limit < 0)
            isPagination = false;

        // query
        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                repositories = repositoryMapper.selectByAddress(address);
                if (repositories != null) {
                    PageInfo<Repository> pageInfo = new PageInfo<>(repositories);
                    total = pageInfo.getTotal();
                } else
                    repositories = new ArrayList<>();
            } else {
                repositories = repositoryMapper.selectByAddress(address);
                if (repositories != null)
                    total = repositories.size();
                else
                    repositories = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new RepositoryManageServiceException(e);
        }

        resultSet.put("data", repositories);
        resultSet.put("total", total);
        return resultSet;
    }

    @Override
    public Map<String, Object> selectByAddress(String address) throws RepositoryManageServiceException {
        return selectByAddress(-1, -1, address);
    }

    @Override
    public Map<String, Object> selectAll(int offset, int limit) throws RepositoryManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Repository> repositories;
        long total = 0;
        boolean isPagination = true;

        if (offset < 0 || limit < 0)
            isPagination = false;

        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                repositories = repositoryMapper.selectAll();
                if (repositories != null) {
                    PageInfo<Repository> pageInfo = new PageInfo<>(repositories);
                    total = pageInfo.getTotal();
                } else
                    repositories = new ArrayList<>();
            } else {
                repositories = repositoryMapper.selectAll();
                if (repositories != null)
                    total = repositories.size();
                else
                    repositories = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new RepositoryManageServiceException(e);
        }

        resultSet.put("data", repositories);
        resultSet.put("total", total);
        return resultSet;
    }

    @Override
    public Map<String, Object> selectAll() throws RepositoryManageServiceException {
        return selectAll(-1, -1);
    }

    private boolean repositoryCheck(Repository repository) {
        return repository.getAddress() != null && repository.getStatus() != null && repository.getArea() != null;
    }

    @UserOperation(value = "Добавить информацию о складе")
    @Override
    public boolean addRepository(Repository repository) throws RepositoryManageServiceException {

        if (repository != null) {
            try {
                if (repositoryCheck(repository))
                    repositoryMapper.insert(repository);
                if (repository.getId() != null) {
                    return true;
                }
            } catch (PersistenceException e) {
                throw new RepositoryManageServiceException(e);
            }
        }
        return false;
    }

    @UserOperation(value = "Изменить информацию о складе")
    @Override
    public boolean updateRepository(Repository repository) throws RepositoryManageServiceException {

        if (repository != null) {
            try {
                if (repositoryCheck(repository)) {
                    if (repository.getId() != null) {
                        repositoryMapper.update(repository);
                        return true;
                    }
                }
            } catch (PersistenceException e) {
                throw new RepositoryManageServiceException(e);
            }
        }
        return false;
    }


    @UserOperation(value = "Удалить информацию о складе")
    @Override
    public boolean deleteRepository(Integer repositoryId) throws RepositoryManageServiceException {

        try {
            List<StockOutDO> stockOutDOList = stockOutMapper.selectByRepositoryID(repositoryId);
            if (stockOutDOList != null && !stockOutDOList.isEmpty())
                return false;

            List<StockInDO> stockInDOList = stockInMapper.selectByRepositoryID(repositoryId);
            if (stockInDOList != null && !stockInDOList.isEmpty())
                return false;

            List<Storage> storageRecords = storageMapper.selectAllAndRepositoryID(repositoryId);
            if (storageRecords != null && !storageRecords.isEmpty())
                return false;

            RepositoryAdmin repositoryAdmin = repositoryAdminMapper.selectByRepositoryID(repositoryId);
            if (repositoryAdmin != null)
                return false;

            repositoryMapper.deleteByID(repositoryId);

            return true;
        } catch (PersistenceException e) {
            throw new RepositoryManageServiceException(e);
        }
    }


    @UserOperation(value = "Импорт складской информации")
    @Override
    public Map<String, Object> importRepository(MultipartFile file) throws RepositoryManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        int total = 0;
        int available = 0;

        List<Object> repositories = excelUtil.excelReader(Repository.class, file);

        if (repositories != null) {
            total = repositories.size();

            Repository repository;
            List<Repository> availableList = new ArrayList<>();
            for (Object object : repositories) {
                repository = (Repository) object;
                if (repository.getAddress() != null && repository.getStatus() != null && repository.getArea() != null)
                    availableList.add(repository);
            }

            try {
                available = availableList.size();
                if (available > 0)
                    repositoryMapper.insertbatch(availableList);
            } catch (PersistenceException e) {
                throw new RepositoryManageServiceException(e);
            }
        }

        resultSet.put("total", total);
        resultSet.put("available", available);
        return resultSet;
    }


    @UserOperation(value = "Экспорт складской информации")
    @Override
    public File exportRepository(List<Repository> repositories) {
        if (repositories == null)
            return null;

        return excelUtil.excelWriter(Repository.class, repositories);
    }

    @Override
    public Map<String, Object> selectUnassign() throws RepositoryManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<Repository> repositories;
        long total = 0;

        try {
            repositories = repositoryMapper.selectUnassign();
        } catch (PersistenceException e) {
            throw new RepositoryManageServiceException(e);
        }
        if (repositories != null)
            total = repositories.size();
        else
            repositories = new ArrayList<>();

        resultSet.put("data", repositories);
        resultSet.put("total", total);
        return resultSet;
    }

}
