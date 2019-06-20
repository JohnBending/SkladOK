package com.ken.wms.common.util;

import org.apache.commons.collections.map.HashedMap;

import java.util.Map;


public class Response {

    public static final String RESPONSE_RESULT_SUCCESS = "success";
    public static final String RESPONSE_RESULT_ERROR = "error";

    private static final String RESPONSE_RESULT = "result";
    private static final String RESPONSE_MSG = "msg";
    private static final String RESPONSE_DATA = "data";
    private static final String RESPONSE_TOTAL = "total";

    private Map<String,Object> responseContent;

    // Constructor
    Response() {
        this.responseContent = new HashedMap(10);
    }

    public void setResponseResult(String result){
        this.responseContent.put(Response.RESPONSE_RESULT,result);
    }

    public void setResponseMsg(String msg){
        this.responseContent.put(Response.RESPONSE_MSG,msg);
    }

    public void setResponseData(Object data){
        this.responseContent.put(Response.RESPONSE_DATA,data);
    }

    public void setResponseTotal(long total){
        this.responseContent.put(Response.RESPONSE_TOTAL,total);
    }

    public void setCustomerInfo(String key, Object value){
        this.responseContent.put(key,value);
    }

    public Map<String, Object> generateResponse(){
        return this.responseContent;
    }
}
