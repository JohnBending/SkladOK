package com.ken.wms.common.service.Interface;


import com.ken.wms.domain.RepositoryAdmin;
import com.ken.wms.exception.RepositoryAdminManageServiceException;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;


public interface RepositoryAdminManageService {


    Map<String, Object> selectByID(Integer repositoryAdminID) throws RepositoryAdminManageServiceException;

    Map<String, Object> selectByRepositoryID(Integer repositoryID) throws RepositoryAdminManageServiceException;

    Map<String, Object> selectByName(int offset, int limit, String name);

    Map<String, Object> selectByName(String name);

    Map<String, Object> selectAll(int offset, int limit) throws RepositoryAdminManageServiceException;

    Map<String, Object> selectAll() throws RepositoryAdminManageServiceException;

    boolean addRepositoryAdmin(RepositoryAdmin repositoryAdmin) throws RepositoryAdminManageServiceException;

    boolean updateRepositoryAdmin(RepositoryAdmin repositoryAdmin) throws RepositoryAdminManageServiceException;

    boolean deleteRepositoryAdmin(Integer repositoryAdminID) throws RepositoryAdminManageServiceException;

    boolean assignRepository(Integer repositoryAdminID, Integer repositoryID) throws RepositoryAdminManageServiceException;

    Map<String, Object> importRepositoryAdmin(MultipartFile file) throws RepositoryAdminManageServiceException;

    File exportRepositoryAdmin(List<RepositoryAdmin> repositoryAdmins);
}
