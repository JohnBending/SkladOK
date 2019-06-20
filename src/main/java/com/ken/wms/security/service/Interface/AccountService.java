package com.ken.wms.security.service.Interface;

import com.ken.wms.exception.UserAccountServiceException;

import java.util.Map;

public interface AccountService {
	public void passwordModify(Integer userID, Map<String, Object> passwordInfo) throws UserAccountServiceException;
}
