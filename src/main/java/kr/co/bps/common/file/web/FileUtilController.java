package kr.co.bps.common.file.web;
import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.math.BigDecimal;
import java.net.URLEncoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.bps.common.file.service.FileService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import oracle.sql.BLOB;

@Controller
public class FileUtilController{
	
	@Resource(name = "FileService")
    private FileService FileService;
		
	@RequestMapping(value = "/common/FileDown.do")
	public String downLoadDbFile(BigDecimal fileId, String entityName, HttpServletRequest request, HttpServletResponse response)
		throws Exception{
		
        BLOB blob = null;        
        InputStream instream = null;
        OutputStream outstream = null;
        try{
        	System.out.println("adf : " + fileId);
        	System.out.println("entityName : " + entityName);
   
        	Map<String, Object> mm = new HashMap<String, Object>();
        	mm.put("fileId", fileId);
        	mm.put("entityName", entityName);
        	
        	Map map = (HashMap)FileService.getInfo(mm, "fileDAO.fileDownload");
        	
        	blob = (BLOB)map.get("file_data");

            String filename = (String)map.get("file_name");
             
	        instream = blob.getBinaryStream();
	        
	        response.setHeader("Content-Type", "aapplication/x-msdownload");
	        response.setHeader("Content-Disposition", "attachment;filename="+URLEncoder.encode(filename, "UTF-8")+";");
	        
	        response.setHeader("Content-Length", String.valueOf(blob.length()));
	        response.setHeader("Content-Transfer-Encoding", "binary;");
	        response.setHeader("Pragma", "no-cache;");
	        response.setHeader("Expires", "-1;");
	        
	        
	        
	        outstream = response.getOutputStream();
	        int size = blob.getBufferSize();
	        byte[] buffer = new byte[size];
	        int length = -1;
	        while((length = instream.read(buffer)) != -1){
	        	outstream.write(buffer,0,length);
	        }
	        outstream.flush();
        }catch(Exception e){
        	throw e;
        	
        }finally{
	        try {
	        	if( outstream != null ) outstream.close();
	        	if( instream != null ) instream.close();
			} catch (Exception e) {
				//e.printStackTrace();
			}
        }
		return "";
	}
	
	 @RequestMapping("/common/popFileList.do")
	    public String popFileList(
	    		@RequestParam("entityName") String entityName,
	    		@RequestParam("fileId") String fileId,
	            Model model) throws Exception {
	    	try{
	    		System.out.println("entityName : " + entityName);
	    		System.out.println("fileId : " + fileId);
	    		Map<String,Object> map = new HashMap<String,Object>();
	    		map.put("entityName", entityName);
	    		map.put("fileId", fileId);
	    		model.addAttribute("resultList", FileService.getList(map, "fileDAO.fileList"));
	    		
	    		model.addAttribute("entityName", entityName);
	    	}catch(Exception e){
	    		e.printStackTrace();
	    		throw e;
	    	}
	        return "/common/fileListPop";
	    }
	 
}