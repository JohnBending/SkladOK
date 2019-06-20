package com.ken.wms.common.service.Impl;

import com.ken.wms.dao.RepositoryAdminMapper;
import com.ken.wms.domain.RepositoryAdmin;
import com.ken.wms.domain.UserInfoDTO;
import com.ken.wms.exception.RepositoryAdminManageServiceException;
import com.ken.wms.exception.UserInfoServiceException;
import com.ken.wms.security.service.Interface.UserInfoService;
import com.ken.wms.util.aop.UserOperation;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ken.wms.common.service.Interface.RepositoryAdminManageService;
import com.ken.wms.common.util.ExcelUtil;
import org.apache.ibatis.exceptions.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.*;


@Service
public class RepositoryAdminManageServiceImpl implements RepositoryAdminManageService {

    @Autowired
    private RepositoryAdminMapper repositoryAdminMapper;
    @Autowired
    private ExcelUtil excelUtil;
    @Autowired
    private UserInfoService userInfoService;


    @Override
    public Map<String, Object> selectByID(Integer repositoryAdminID) throws RepositoryAdminManageServiceException {

        Map<String, Object> resultSet = new HashMap<>();
        List<RepositoryAdmin> repositoryAdmins = new ArrayList<>();
        long total = 0;


        RepositoryAdmin repositoryAdmin;
        try {
            repositoryAdmin = repositoryAdminMapper.selectByID(repositoryAdminID);
        } catch (PersistenceException e) {
            throw new RepositoryAdminManageServiceException(e);
        }

        if (repositoryAdmin != null) {
            repositoryAdmins.add(repositoryAdmin);
            total = 1;
        }

        resultSet.put("data", repositoryAdmins);
        resultSet.put("total", total);
        return resultSet;
    }


    @Override
    public Map<String, Object> selectByName(int offset, int limit, String name) {

        Map<String, Object> resultSet = new HashMap<>();
        List<RepositoryAdmin> repositoryAdmins;
        long total = 0;
        boolean isPagination = true;

        // validate
        if (offset < 0 || limit < 0)
            isPagination = false;

        // query
        if (isPagination) {
            PageHelper.offsetPage(offset, limit);
            repositoryAdmins = repositoryAdminMapper.selectByName(name);
            if (repositoryAdmins != null) {
                PageInfo<RepositoryAdmin> pageInfo = new PageInfo<>(repositoryAdmins);
                total = pageInfo.getTotal();
            } else
                repositoryAdmins = new ArrayList<>();
        } else {
            repositoryAdmins = repositoryAdminMapper.selectByName(name);
            if (repositoryAdmins != null)
                total = repositoryAdmins.size();
            else
                repositoryAdmins = new ArrayList<>();
        }

        resultSet.put("data", repositoryAdmins);
        resultSet.put("total", total);
        return resultSet;
    }


    @Override
    public Map<String, Object> selectByName(String name) {
        return selectByName(-1, -1, name);
    }


    @Override
    public Map<String, Object> selectAll(int offset, int limit) throws RepositoryAdminManageServiceException {

        Map<String, Object> resultSet = new HashMap<>();
        List<RepositoryAdmin> repositoryAdmins;
        long total = 0;
        boolean isPagination = true;

        // validate
        if (offset < 0 || limit < 0)
            isPagination = false;

        // query
        try {
            if (isPagination) {
                PageHelper.offsetPage(offset, limit);
                repositoryAdmins = repositoryAdminMapper.selectAll();
                if (repositoryAdmins != null) {
                    PageInfo<RepositoryAdmin> pageInfo = new PageInfo<>(repositoryAdmins);
                    total = pageInfo.getTotal();
                } else
                    repositoryAdmins = new ArrayList<>();
            } else {
                repositoryAdmins = repositoryAdminMapper.selectAll();
                if (repositoryAdmins != null)
                    total = repositoryAdmins.size();
                else
                    repositoryAdmins = new ArrayList<>();
            }
        } catch (PersistenceException e) {
            throw new RepositoryAdminManageServiceException(e);
        }

        resultSet.put("data", repositoryAdmins);
        resultSet.put("total", total);
        return resultSet;
    }


    @Override
    public Map<String, Object> selectAll() throws RepositoryAdminManageServiceException {
        return selectAll(-1, -1);
    }


    @UserOperation(value = "Добавить информацию администратора склада")
    @Override
    public boolean addRepositoryAdmin(RepositoryAdmin repositoryAdmin) throws RepositoryAdminManageServiceException {

        if (repositoryAdmin != null) {
            if (repositoryAdminCheck(repositoryAdmin)) {
                try {
                    repositoryAdminMapper.insert(repositoryAdmin);

                    Integer userID = repositoryAdmin.getId();
                    if (userID == null)
                        return false;

                    UserInfoDTO userInfo = new UserInfoDTO();
                    userInfo.setUserID(userID);
                    userInfo.setUserName(repositoryAdmin.getName());
                    userInfo.setPassword(repositoryAdmin.getId().toString());
                    userInfo.setRole(new ArrayList<>(Collections.singletonList("commonsAdmin")));

                    return userInfoService.insertUserInfo(userInfo);

                } catch (PersistenceException | UserInfoServiceException e) {
                    throw new RepositoryAdminManageServiceException(e, "Fail to persist repository admin info");
                }
            }
        }
        return false;
    }


    @UserOperation(value = "Изменить информацию администратора склада")
    @Override
    public boolean updateRepositoryAdmin(RepositoryAdmin repositoryAdmin) throws RepositoryAdminManageServiceException {

        if (repositoryAdmin != null) {
            try {
                if (!repositoryAdminCheck(repositoryAdmin))
                    return false;

                if (repositoryAdmin.getRepositoryBelongID() != null) {
                    RepositoryAdmin rAdminFromDB = repositoryAdminMapper.selectByRepositoryID(repositoryAdmin.getRepositoryBelongID());
                    if (rAdminFromDB != null && !Objects.equals(rAdminFromDB.getId(), repositoryAdmin.getId()))
                        return false;
                }

                repositoryAdminMapper.update(repositoryAdmin);

                return true;
            } catch (PersistenceException e) {
                throw new RepositoryAdminManageServiceException(e);
            }
        } else
            return false;

    }


    @UserOperation(value = "Удалить информацию администратора склада")
    @Override
    public boolean deleteRepositoryAdmin(Integer repositoryAdminID) throws RepositoryAdminManageServiceException {

        try {
            RepositoryAdmin repositoryAdmin = repositoryAdminMapper.selectByID(repositoryAdminID);
            if (repositoryAdmin != null && repositoryAdmin.getRepositoryBelongID() == null) {

                repositoryAdminMapper.deleteByID(repositoryAdminID);

                userInfoService.deleteUserInfo(repositoryAdminID);

                return true;
            } else
                return false;
        } catch (PersistenceException | UserInfoServiceException e) {
            throw new RepositoryAdminManageServiceException(e);
        }
    }


    @UserOperation(value = "Назначить администратора склада")
    @Override
    public boolean assignRepository(Integer repositoryAdminID, Integer repositoryID) throws RepositoryAdminManageServiceException {

        try {
            RepositoryAdmin repositoryAdmin = repositoryAdminMapper.selectByID(repositoryAdminID);
            if (repositoryAdmin != null) {
                repositoryAdmin.setRepositoryBelongID(repositoryID);
                return updateRepositoryAdmin(repositoryAdmin);
            } else
                return false;
        } catch (PersistenceException e) {
            throw new RepositoryAdminManageServiceException(e);
        }
    }


    @UserOperation(value = "Импорт информации администратора склада")
    @Override
    public Map<String, Object> importRepositoryAdmin(MultipartFile file) throws RepositoryAdminManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        long total = 0;
        long available = 0;

        List<Object> repositoryAdmins = excelUtil.excelReader(RepositoryAdmin.class, file);

        if (repositoryAdmins != null) {
            total = repositoryAdmins.size();

            RepositoryAdmin repositoryAdmin;
            List<RepositoryAdmin> availableList = new ArrayList<>();
            for (Object object : repositoryAdmins) {
                repositoryAdmin = (RepositoryAdmin) object;
                if (repositoryAdminCheck(repositoryAdmin))
                    availableList.add(repositoryAdmin);
            }

            try {
                available = availableList.size();
                if (available > 0)
                    repositoryAdminMapper.insertBatch(availableList);
            } catch (PersistenceException e) {
                throw new RepositoryAdminManageServiceException(e);
            }
        }

        resultSet.put("total", total);
        resultSet.put("available", available);
        return resultSet;
    }


    @UserOperation(value = "Экспорт информации администратора склада")
    @Override
    public File exportRepositoryAdmin(List<RepositoryAdmin> repositoryAdmins) {
        File file = null;

        if (repositoryAdmins != null) {
            file = excelUtil.excelWriter(RepositoryAdmin.class, repositoryAdmins);
        }

        return file;
    }


    private boolean repositoryAdminCheck(RepositoryAdmin repositoryAdmin) {

        return repositoryAdmin.getName() != null && repositoryAdmin.getSex() != null && repositoryAdmin.getTel() != null
                && repositoryAdmin.getBirth() != null && repositoryAdmin.getBirth() != null;
    }


    @Override
    public Map<String, Object> selectByRepositoryID(Integer repositoryID) throws RepositoryAdminManageServiceException {
        Map<String, Object> resultSet = new HashMap<>();
        List<RepositoryAdmin> repositoryAdmins = new ArrayList<>();
        long total = 0;

        RepositoryAdmin repositoryAdmin;
        try {
            repositoryAdmin = repositoryAdminMapper.selectByRepositoryID(repositoryID);
        } catch (PersistenceException e) {
            throw new RepositoryAdminManageServiceException(e);
        }

        if (repositoryAdmin != null) {
            repositoryAdmins.add(repositoryAdmin);
            total = 1;
        }

        resultSet.put("data", repositoryAdmins);
        resultSet.put("total", total);
        return resultSet;
    }
}
