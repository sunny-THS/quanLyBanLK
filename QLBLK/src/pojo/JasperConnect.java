/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pojo;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.util.Map;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.xml.JRXmlLoader;
import net.sf.jasperreports.view.JasperViewer;

/**
 *
 * @author Admin
 */
public class JasperConnect {
    public JasperConnect() {}

    private String report = "src\\report\\";
    
    public static String getPathRootToReport() {
        Path path = Paths.get("", new String[0]);
        return path.toAbsolutePath().toString()+"\\src\\report\\";
    }

    public void genarateReport(String file, Map<String, Object> map, Connection con) {
        try {
            JasperDesign jd = JRXmlLoader.load(report + file);
            
            JasperReport jasperReport = JasperCompileManager.compileReport(jd);
            
            JasperPrint jasperprint = JasperFillManager.fillReport(jasperReport, map, con);
            
            JasperViewer.viewReport(jasperprint, false);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
