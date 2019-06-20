package com.ken.wms.exception;


public class RepositoryManageServiceException extends BusinessException {

    RepositoryManageServiceException(){
        super();
    }

    public RepositoryManageServiceException(Exception e){
        super(e);
    }

    RepositoryManageServiceException(Exception e, String exceptionDesc){
        super(e, exceptionDesc);
    }

}
