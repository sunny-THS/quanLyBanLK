/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pojo;

import java.sql.Date;

/**
 *
 * @author Admin
 */
public class PhieuNhap {
    private String maPN;
    private Date ngayNhap;
    private double triGia;

    public PhieuNhap() {
    }

    public PhieuNhap(String maPN, Date ngayNhap, double triGia) {
        this.maPN = maPN;
        this.ngayNhap = ngayNhap;
        this.triGia = triGia;
    }

    /**
     * @return the maPN
     */
    public String getMaPN() {
        return maPN;
    }

    /**
     * @param maPN the maPN to set
     */
    public void setMaPN(String maPN) {
        this.maPN = maPN;
    }

    /**
     * @return the ngayNhap
     */
    public Date getNgayNhap() {
        return ngayNhap;
    }

    /**
     * @param ngayNhap the ngayNhap to set
     */
    public void setNgayNhap(Date ngayNhap) {
        this.ngayNhap = ngayNhap;
    }

    /**
     * @return the triGia
     */
    public double getTriGia() {
        return triGia;
    }
    
}
