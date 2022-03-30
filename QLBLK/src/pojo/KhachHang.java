/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pojo;

/**
 *
 * @author Admin
 */
public class KhachHang {
    private int maKH;
    private String tenKH, dChi, sdt;

    public KhachHang() {
    }

    public KhachHang(int maKH, String tenKH, String dChi, String sdt) {
        this.maKH = maKH;
        this.tenKH = tenKH;
        this.dChi = dChi;
        this.sdt = sdt;
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
     * @return the tenKH
     */
    public String getTenKH() {
        return tenKH;
    }

    /**
     * @param tenKH the tenKH to set
     */
    public void setTenKH(String tenKH) {
        this.tenKH = tenKH;
    }

    /**
     * @return the dChi
     */
    public String getdChi() {
        return dChi;
    }

    /**
     * @param dChi the dChi to set
     */
    public void setdChi(String dChi) {
        this.dChi = dChi;
    }

    /**
     * @return the sdt
     */
    public String getSdt() {
        return sdt;
    }

    /**
     * @param sdt the sdt to set
     */
    public void setSdt(String sdt) {
        this.sdt = sdt;
    }
      
}
