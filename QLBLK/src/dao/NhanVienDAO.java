/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dataprovider.SQLServerProvider;
import java.sql.ResultSet;
import java.util.ArrayList;
import pojo.NhanVien;

/**
 *
 * @author Admin
 */
public class NhanVienDAO {
    public static ArrayList<NhanVien> showLstNV(String tenNV) {
        ArrayList<NhanVien> lst = new ArrayList<NhanVien>();
        try {
            SQLServerProvider provider = new SQLServerProvider();
            String sql = "select ttnv.*, doanhthu from TimTTNhanVien(N'"+ tenNV +"') ttnv join GetDoanhThu_NV_YEAR(YEAR(GETDATE())) dt\n" +
                            "on ttnv.tenNV = dt.tenNV";
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while (rs.next()) {
                lst.add(new NhanVien(
                        rs.getInt("ID"),
                        rs.getString("TenNV"),
                        rs.getString("GioiTinh"),
                        rs.getDate("NgaySinh"),
                        rs.getDouble("doanhthu")
                ));
            }
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lst;
    }
    public static ArrayList<NhanVien> showLstNV_gender(String gender) {
        ArrayList<NhanVien> lst = new ArrayList<NhanVien>();
        try {
            SQLServerProvider provider = new SQLServerProvider();
            String sql = "select ttnv.*, doanhthu from TimTTNhanVien_Gender(N'"+ gender +"') ttnv join GetDoanhThu_NV_YEAR(YEAR(GETDATE())) dt\n" +
                            "on ttnv.tenNV = dt.tenNV";
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while (rs.next()) {
                lst.add(new NhanVien(
                        rs.getInt("ID"),
                        rs.getString("TenNV"),
                        rs.getString("GioiTinh"),
                        rs.getDate("NgaySinh"),
                        rs.getDouble("doanhthu")
                ));
            }
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lst;
    }
}
