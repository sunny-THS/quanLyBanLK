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
public class LinhKien {
    private String maLK, maLoai, tenLK, nsx, dvt;
    private int tgBaoHanh, slTonKho;
    private Date ngSx;
    
    public LinhKien() {
    }

    public LinhKien(String maLK, String maLoai, String tenLK, String nsx, int tgBaoHanh, int slTonKho) {
        this.maLK = maLK;
        this.maLoai = maLoai;
        this.tenLK = tenLK;
        this.nsx = nsx;
        this.tgBaoHanh = tgBaoHanh;
        this.slTonKho = slTonKho;
    }

    /**
     * @return the maLK
     */
    public String getMaLK() {
        return maLK;
    }

    /**
     * @param maLK the maLK to set
     */
    public void setMaLK(String maLK) {
        this.maLK = maLK;
    }

    /**
     * @return the maLoai
     */
    public String getMaLoai() {
        return maLoai;
    }

    /**
     * @param maLoai the maLoai to set
     */
    public void setMaLoai(String maLoai) {
        this.maLoai = maLoai;
    }

    /**
     * @return the tenLK
     */
    public String getTenLK() {
        return tenLK;
    }

    /**
     * @param tenLK the tenLK to set
     */
    public void setTenLK(String tenLK) {
        this.tenLK = tenLK;
    }

    /**
     * @return the nsx
     */
    public String getNsx() {
        return nsx;
    }

    /**
     * @param nsx the nsx to set
     */
    public void setNsx(String nsx) {
        this.nsx = nsx;
    }

    /**
     * @return the tgBaoHanh
     */
    public int getTgBaoHanh() {
        return tgBaoHanh;
    }

    /**
     * @param tgBaoHanh the tgBaoHanh to set
     */
    public void setTgBaoHanh(int tgBaoHanh) {
        this.tgBaoHanh = tgBaoHanh;
    }

    /**
     * @return the slTonKho
     */
    public int getSlTonKho() {
        return slTonKho;
    }

    /**
     * @param slTonKho the slTonKho to set
     */
    public void setSlTonKho(int slTonKho) {
        this.slTonKho = slTonKho;
    }

    /**
     * @return the dvt
     */
    public String getDvt() {
        return dvt;
    }

    /**
     * @param dvt the dvt to set
     */
    public void setDvt(String dvt) {
        this.dvt = dvt;
    }

    /**
     * @return the ngSx
     */
    public Date getNgSx() {
        return ngSx;
    }

    /**
     * @param ngSx the ngSx to set
     */
    public void setNgSx(Date ngSx) {
        this.ngSx = ngSx;
    }
    
}
