package com.ken.wms.common.util;

import org.springframework.stereotype.Component;

@Component
public class ResponseUtil {

    public Response newResponseInstance(){
        Response response = new Response();

        return response;
    }

}
