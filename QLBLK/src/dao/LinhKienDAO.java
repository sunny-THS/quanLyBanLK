/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dataprovider.SQLServerProvider;
import java.sql.*;
import java.util.ArrayList;
import pojo.LinhKien;

/**
 *
 * @author Admin
 */
public class LinhKienDAO {
    public static boolean udLK (LinhKien lk) {
        boolean kq = false;
        try {
            SQLServerProvider provider = new SQLServerProvider();
            provider.open();
            String sql = "{? = call updateTT(?, ?, ?, ?, ?)}";
            CallableStatement callableStatement = provider.getConn().prepareCall(sql);
            callableStatement.registerOutParameter(1, Types.INTEGER);
            callableStatement.setString(2, lk.getMaLK());
            callableStatement.setString(3, lk.getTenLK());
            callableStatement.setInt(4, lk.getTgBaoHanh());
            callableStatement.setString(5, lk.getNsx());
            callableStatement.setInt(6, lk.getSlTonKho());
            callableStatement.execute();
            int n = callableStatement.getInt(1);
            if(n==1) kq=true;
            provider.close();
        } catch (Exception e) {
        }
        return kq;
    }
    public static boolean delLK (String tenLK) {
        boolean kq = false;
        try {
            SQLServerProvider provider = new SQLServerProvider();
            String sql = "Delete from LinhKien where tenLK=N'"+tenLK+"'";
            provider.open();
            int rs = provider.executeUpdate(sql);
            if (rs>0) kq = true;
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
            kq = false;
        }
        return kq;
    }
    public static ArrayList lstTenLoai() {
        ArrayList lst = new ArrayList();
        try {
            String sql = "select * from loaiLK";
            SQLServerProvider provider = new SQLServerProvider();
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while (rs.next()) {
                lst.add(rs.getString("tenLoai"));
            }
            provider.close();
        } catch (Exception e) {
        }
        return lst;
    }
    public static ArrayList lstNSX() {
        ArrayList lst = new ArrayList();
        try {
            String sql = "select distinct nsx from linhkien";
            SQLServerProvider provider = new SQLServerProvider();
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while (rs.next()) {
                lst.add(rs.getString("nsx"));
            }
            provider.close();
        } catch (Exception e) {
        }
        return lst;
    }
    public static boolean addLK(String tenLK, String tenLoai, Date ngSX, int tgbh, String nsx, String dvt, int sl) {
        boolean kq = true;
        try {
            SQLServerProvider provider = new SQLServerProvider();
            String sql = "{? = call addLK(?, ?, ?, ?, ?, ?, ?)}";
            provider.open();
            CallableStatement callableStatement = provider.getConn().prepareCall(sql);
            callableStatement.registerOutParameter(1, Types.INTEGER);
            callableStatement.setString(2, tenLK);
            callableStatement.setString(3, tenLoai);
            callableStatement.setDate(4, ngSX);
            callableStatement.setInt(5, tgbh);
            callableStatement.setString(6, nsx);
            callableStatement.setString(7, dvt);
            callableStatement.setInt(8, sl);
            callableStatement.execute();
            int rs = callableStatement.getInt(1);
            if (rs != 1) kq  = false;
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
            kq = false;
        }
        return kq;
    }
    public static ArrayList<LinhKien> showListLK() {
        ArrayList<LinhKien> lk = new ArrayList<LinhKien>();
        try {
            SQLServerProvider provider = new SQLServerProvider();
            String sql = "select * from ShowTTLK()";
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while (rs.next()) {
                lk.add(new LinhKien(
                        rs.getString("MALK"), 
                        rs.getString("MALOAI"), 
                        rs.getNString("TENLK"), 
                        rs.getNString("NSX"),
                        rs.getInt("TGBH"), 
                        rs.getInt("SOLUONGTONKHO")
                    )
                );
            }
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lk;
    }
    public static ArrayList<LinhKien> showListLK(String tenLK) {
        ArrayList<LinhKien> lk = new ArrayList<LinhKien>();
        try {
            SQLServerProvider provider = new SQLServerProvider();
            String sql = "select * from TimTTLK_Ten(N'"+ tenLK +"')";
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while (rs.next()) {
                lk.add(new LinhKien(
                        rs.getString("MA"), 
                        "", 
                        rs.getNString("TENLK"), 
                        rs.getNString("NSX"),
                        rs.getInt("TGBH"), 
                        rs.getInt("soluong")
                    )
                );
            }
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lk;
    }
    public static ArrayList<LinhKien> showListLK_LLK(String tenLLK) {
        ArrayList<LinhKien> lk = new ArrayList<LinhKien>();
        try {
            SQLServerProvider provider = new SQLServerProvider();
            String sql = "select * from TimTTLK_LOAI(N'"+ tenLLK +"')";
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while (rs.next()) {
                lk.add(new LinhKien(
                        rs.getString("MA"), 
                        "", 
                        rs.getNString("TENLK"), 
                        rs.getNString("NSX"),
                        rs.getInt("TGBH"), 
                        rs.getInt("soLuong")
                    )
                );
            }
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lk;
    }
    public static ArrayList<LinhKien> showListLK_NSX(String nsx) {
        ArrayList<LinhKien> lk = new ArrayList<LinhKien>();
        try {
            SQLServerProvider provider = new SQLServerProvider();
            String sql = "select * from TimTTLK_NSX(N'"+ nsx +"')";
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while (rs.next()) {
                lk.add(new LinhKien(
                        rs.getString("MA"), 
                        "", 
                        rs.getNString("TENLK"), 
                        rs.getNString("NSX"),
                        rs.getInt("TGBH"), 
                        rs.getInt("soLuong")
                    )
                );
            }
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lk;
    }
}
