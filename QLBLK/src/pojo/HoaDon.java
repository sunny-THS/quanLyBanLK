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
public class HoaDon {
    private String maHD;
    private Date ngayHD;
    private int maKH, maNV;
    private double triGia; // thành tiền

    public HoaDon() {
    }

    public HoaDon(String maHD, Date ngayHD, int maKH, int maNV, double triGia) {
        this.maHD = maHD;
        this.ngayHD = ngayHD;
        this.maKH = maKH;
        this.maNV = maNV;
        this.triGia = triGia;
    }

    /**
     * @return the maHD
     */
    public String getMaHD() {
        return maHD;
    }

    /**
     * @param maHD the maHD to set
     */
    public void setMaHD(String maHD) {
        this.maHD = maHD;
    }

    /**
     * @return the ngayHD
     */
    public Date getNgayHD() {
        return ngayHD;
    }

    /**
     * @param ngayHD the ngayHD to set
     */
    public void setNgayHD(Date ngayHD) {
        this.ngayHD = ngayHD;
    }

    /**
     * @return the maKH
     */
    public int getMaKH() {
        return maKH;
    }

    /**
     * @param maKH the maKH to set
     */
    public void setMaKH(int maKH) {
        this.maKH = maKH;
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
     * @return the triGia
     */
    public double getTriGia() {
        return triGia;
    }
}
