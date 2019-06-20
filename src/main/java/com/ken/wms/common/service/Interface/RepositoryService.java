package com.ken.wms.common.service.Interface;


import com.ken.wms.domain.Repository;
import com.ken.wms.exception.RepositoryManageServiceException;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;


public interface RepositoryService {


    Map<String, Object> selectById(Integer repositoryId) throws RepositoryManageServiceException;

    Map<String, Object> selectByAddress(int offset, int limit, String address) throws RepositoryManageServiceException;

    Map<String, Object> selectByAddress(String address) throws RepositoryManageServiceException;

    Map<String, Object> selectAll(int offset, int limit) throws RepositoryManageServiceException;

    Map<String, Object> selectAll() throws RepositoryManageServiceException;

    Map<String, Object> selectUnassign() throws RepositoryManageServiceException;

    boolean addRepository(Repository repository) throws RepositoryManageServiceException;

    boolean updateRepository(Repository repository) throws RepositoryManageServiceException;

    boolean deleteRepository(Integer repositoryId) throws RepositoryManageServiceException;

    Map<String, Object> importRepository(MultipartFile file) throws RepositoryManageServiceException;

    File exportRepository(List<Repository> repositories);
}
