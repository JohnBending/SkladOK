package com.ken.wms.dao;

import com.ken.wms.domain.RepositoryAdmin;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface RepositoryAdminMapper {

	RepositoryAdmin selectByID(Integer id);

	List<RepositoryAdmin> selectByName(String name);

	List<RepositoryAdmin> selectAll();

	RepositoryAdmin selectByRepositoryID(Integer repositoryID);

	void insert(RepositoryAdmin repositoryAdmin);

	void insertBatch(List<RepositoryAdmin> repositoryAdmins);

	void update(RepositoryAdmin repositoryAdmin);

	void deleteByID(Integer id);
}
