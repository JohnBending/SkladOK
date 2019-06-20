package com.ken.wms.dao;

import com.ken.wms.domain.Repository;

import java.util.List;


@org.springframework.stereotype.Repository
public interface RepositoryMapper {


	List<Repository> selectAll();

	List<Repository> selectUnassign();

	Repository selectByID(Integer repositoryID);

	List<Repository> selectByAddress(String address);

	void insert(Repository repository);

	void insertbatch(List<Repository> repositories);

	void update(Repository repository);

	void deleteByID(Integer repositoryID);
}
