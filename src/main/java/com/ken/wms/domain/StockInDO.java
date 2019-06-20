package com.ken.wms.domain;


import java.util.Date;

public class StockInDO {

    private Integer id;

    private Integer supplierID;

    private String supplierName;

    private Integer goodID;

    private String goodName;

    private Integer repositoryID;

    private long number;

    private Date time;

    private String personInCharge;

    public Integer getRepositoryID() {
        return repositoryID;
    }

    public void setRepositoryID(Integer repositoryID) {
        this.repositoryID = repositoryID;
    }

    public Integer getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(Integer supplierID) {
        this.supplierID = supplierID;
    }

    public Integer getGoodID() {
        return goodID;
    }

    public void setGoodID(Integer goodID) {
        this.goodID = goodID;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getGoodName() {
        return goodName;
    }

    public void setGoodName(String goodName) {
        this.goodName = goodName;
    }

    public long getNumber() {
        return number;
    }

    public void setNumber(long number) {
        this.number = number;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getPersonInCharge() {
        return personInCharge;
    }

    public void setPersonInCharge(String personInCharge) {
        this.personInCharge = personInCharge;
    }

    @Override
    public String toString() {
        return "StockInDO [id=" + id + ", supplierID=" + supplierID + ", supplierName=" + supplierName + ", goodID="
                + goodID + ", goodName=" + goodName + ", repositoryID=" + repositoryID + ", number=" + number
                + ", time=" + time + ", personInCharge=" + personInCharge + "]";
    }

}
