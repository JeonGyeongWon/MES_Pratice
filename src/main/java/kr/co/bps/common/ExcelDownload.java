package kr.co.bps.common;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.apache.poi.hssf.model.Workbook;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import egovframework.rte.psl.dataaccess.util.EgovMap;




public class ExcelDownload extends AbstractExcelView {
	

	/**
	 * Return the content type of the view, if predetermined.
	 * <p>Can be used to check the content type upfront,
	 * before the actual rendering process.
	 * @return the content type String (optionally including a character set),
	 * or <code>null</code> if not predetermined.
	 */
	
	/***
	 * EXCEL 다운로드
	 * @param map : ( 
	 * 		title
	 *  	header(0 ~ 999, 구분자 ';')
	 *  	type(S,N구분자 ';')
	 *  	data(HashMap return)
	 */
	@Override	
	protected void buildExcelDocument(Map map, HSSFWorkbook wb,
		HttpServletRequest req, HttpServletResponse resp) throws Exception {
		HSSFCell cell = null;
 
		HSSFSheet sheet = wb.createSheet("Sheet1");
		
		sheet.setDefaultColumnWidth(15);
		sheet.setDisplayGridlines(true);
		
		HSSFFont font = wb.createFont(); //폰트 객체 생성
		 
		font.setFontHeightInPoints((short)10); //폰트 크기
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD); 
		
		
		HSSFCellStyle headerStyle = wb.createCellStyle();
		headerStyle.setBorderBottom((short)2);
		headerStyle.setBorderTop((short)2);
		headerStyle.setBorderLeft((short)2);
		headerStyle.setBorderRight((short)2);
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setFont(font);
		
		HSSFCellStyle cellStyle = wb.createCellStyle();
		cellStyle.setBorderBottom((short)1);
		cellStyle.setBorderLeft((short)1);
		cellStyle.setBorderRight((short)1);
		
		try{
 
		// put text in first cell
		cell = getCell(sheet, 0, 0);
		
		
		setText(cell, map.get("title").toString());
		// set header information
		
		String[] headers = map.get("header").toString().split(";");
		String[] dataType = map.get("type").toString().split(";");
		for (int i=0 ; i<headers.length ; i++){
			setText(getCell(sheet, 2, i), headers[i], headerStyle);
		}
		
		//Map<String, Object> map= (Map<String, Object>) model.get("categoryMap");
		List<Object> categories = map.get("data") == null? null:(List<Object>) map.get("data") ;
 
		boolean isVO = false;
		
		cell.setCellStyle(cellStyle);
		Map mm = null;
		
		if(categories != null ){
			
			for (int i = 0; i < categories.size(); i++) {
				mm = (java.util.HashMap)categories.get(i);
				for (int j=0 ; j < headers.length ; j++){			
					cell = getCell(sheet, 3 + i, j);
					if( dataType == null || dataType[j].equals("S")){
						setText(cell, mm.get(j+"")==null ? "":mm.get(j+"").toString(), cellStyle);
					}else{
						setNumber(cell, mm.get(j+"")==null ? 0: Double.parseDouble(mm.get(j+"").toString()), cellStyle);
					}
						
					//cell = getCell(sheet, 3 + i, 1);
					//setText(cell, category.get("name"));
					
				}
			}
		}
		resp.setHeader("Content-Disposition", "attachment;filename="+URLEncoder.encode(map.get("title")+".xls", "UTF-8")+";");
		}catch(Exception e){
			e.printStackTrace();
		}

	}
	
	protected void setText(HSSFCell cell, String text, HSSFCellStyle cellStyle ) {
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		cell.setCellStyle(cellStyle);
		cell.setCellValue(text);
	}
	
	protected void setNumber(HSSFCell cell, double text, HSSFCellStyle cellStyle ) {
		cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
		cell.setCellStyle(cellStyle);
		cell.setCellValue(text);
	}
	
	
	
}