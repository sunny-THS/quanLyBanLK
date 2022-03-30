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
public class NhanVien {
    private int maNV;
    private String tenNV, gender;
    private Date ngSinh; 
    private double doanhThu;

    public NhanVien() {
    }

    public NhanVien(int maNV, String tenNV, String gender, Date ngSinh, double doanhThu) {
        this.maNV = maNV;
        this.tenNV = tenNV;
        this.gender = gender;
        this.ngSinh = ngSinh;
        this.doanhThu = doanhThu;
    }

    /**
     * @return the maNV
     */
    public int getMaNV() {
        return maNV;
    }

    /**
     * @param maNV the maNV to set
     */
    public void setMaNV(int maNV) {
        this.maNV = maNV;
    }

    /**
     * @return the tenNV
     */
    public String getTenNV() {
        return tenNV;
    }

    /**
     * @param tenNV the tenNV to set
     */
    public void setTenNV(String tenNV) {
        this.tenNV = tenNV;
    }

    /**
     * @return the gender
     */
    public String getGender() {
        return gender;
    }

    /**
     * @param gender the gender to set
     */
    public void setGender(String gender) {
        this.gender = gender;
    }

    /**
     * @return the ngSinh
     */
    public Date getNgSinh() {
        return ngSinh;
    }

    /**
     * @param ngSinh the ngSinh to set
     */
    public void setNgSinh(Date ngSinh) {
        this.ngSinh = ngSinh;
    }

    /**
     * @return the doanhThu
     */
    public double getDoanhThu() {
        return doanhThu;
    }

    /**
     * @param doanhThu the doanhThu to set
     */
    public void setDoanhThu(double doanhThu) {
        this.doanhThu = doanhThu;
    }
    
}
