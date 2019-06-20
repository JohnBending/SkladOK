package com.ken.wms.util.aop;

import java.lang.annotation.*;


@Inherited
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface UserOperation {
    String value();
}
