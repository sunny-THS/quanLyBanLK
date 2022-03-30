/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dataprovider;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author Admin
 */
public class SQLServerProvider {

    private Connection conn;
    private ResultSet resSet;
    private Statement statement;

    public void open() {
        String strServer = "MSI-PC";
        String strDatabase = "QLBLK";
        String uid = "sa";
        String pwd = "sa123";
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String connectionURL = "jdbc:sqlserver://" + strServer
                    + ":1433;databaseName=" + strDatabase
                    + ";user = " + uid
                    + ";password = " + pwd;
            conn = DriverManager.getConnection(connectionURL);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void close() {
        try {
            this.getConn().close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ResultSet executeQuery(String sql) {
        resSet = null;
        try {
            statement = getConn().createStatement();
            resSet = statement.executeQuery(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resSet;
    }

    public int executeUpdate(String sql) {
        int n = -1;
        try {
            statement = getConn().createStatement();
            n = statement.executeUpdate(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }

    /**
     * @return the conn
     */
    public Connection getConn() {
        return conn;
    }
}
