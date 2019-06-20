package com.ken.wms.exception;


public class CustomerManageServiceException extends BusinessException{

    public CustomerManageServiceException(){
        super();
    }

    public CustomerManageServiceException(Exception e, String exception){
        super(e, exception);
    }

    public CustomerManageServiceException(Exception e){
        super(e);
    }
}
