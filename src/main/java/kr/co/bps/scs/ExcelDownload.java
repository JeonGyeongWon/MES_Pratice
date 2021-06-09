package kr.co.bps.scs;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import kr.co.bps.scs.file.AbstractExcelPOIView;
import kr.co.bps.scs.util.StringUtil;

/**
 * ModelAndView 를 통한 엑셀 뷰 생성 파라미터 세팅을 통해서 칼럼명과 칼럼 형식을 지정하고 DB에서 조회할때 칼럼 명을 숫자로
 * 순서대로 조회한 결과를 순서대로 맵핑함.
 * 
 * @author ymha
 * @since 2015. 12. 29.
 * @version 1.0
 * @see
 * 
 *      <pre>
 * 
 * << 개정이력(Modification Information) >>
 *   
 *   수정일         수정자               수정내용
 *  ------------    -----------------    ---------------------------
 *   2015. 12. 29. : ymha             : 신규 개발.
 * 
 * </pre>
 */
public class ExcelDownload extends AbstractExcelPOIView {

	/***
	 * EXCEL 다운로드
	 * 
	 * @param map
	 * @param wb
	 * @param req
	 * @param resp
	 */
	@Override
	protected void buildExcelDocument(Map<String, Object> map, Workbook wb, HttpServletRequest req, HttpServletResponse resp) throws Exception {

		try {
			createExcelDocument(map, wb);
			resp.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(map.get("title") + ".xls", "UTF-8") + ";");

			// 엑셀파일명 한글깨짐 조치
			resp.setHeader("Content-Type", "application/octet-stream");
			resp.setHeader("Content-Transfer-Encoding", "binary;");
			resp.setHeader("Pragma", "no-cache;");
			resp.setHeader("Expires", "-1;");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings({ "unchecked", "deprecation"})
	public void createExcelDocument(Map<String, Object> map, Workbook wb) {
		Cell cell = null;

		Sheet sheet = wb.createSheet(StringUtil.nullConvert(map.get("title")));

		sheet.setDefaultColumnWidth(15);
		sheet.setDisplayGridlines(true);

		// 1. 폰트 설정
		Font font = wb.createFont();

		font.setFontHeightInPoints((short) 10);
		font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		font.setFontName("맑은 고딕");

		// 2. 헤더 설정
		CellStyle headerStyle = wb.createCellStyle();
		headerStyle.setBorderBottom((short) 2);
		headerStyle.setBorderTop((short) 2);
		headerStyle.setBorderLeft((short) 2);
		headerStyle.setBorderRight((short) 2);
		headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		headerStyle.setFont(font);

		CellStyle cellStyle = wb.createCellStyle();
		cellStyle.setBorderBottom((short) 1);
		cellStyle.setBorderLeft((short) 1);
		cellStyle.setBorderRight((short) 1);

		// 첫번째 셀 - 제목
		cell = getCell(sheet, 0, 0);
		setText(cell, map.get("title").toString());

		
		String[] headers = map.get("header").toString().split(";");
		String[] columns = map.get("columns").toString().split(";");
		String[] dataType = map.get("type").toString().split(";");

		for (int i = 0; i < headers.length; i++) {
			setText(getCell(sheet, 2, i), headers[i], headerStyle);
		}

		List<HashMap> categories = map.get("data") == null ? null : (List<HashMap>) map.get("data");

		cell.setCellStyle(cellStyle);
		
		Map mm = null;
		if (categories != null) {

			for (int i = 0; i < categories.size(); i++) {
				if (categories.get(i).getClass() != HashMap.class) {
					try {
						mm = BeanUtils.describe(categories.get(i));
					} catch (IllegalAccessException e) {
						// TODO 예외 발생
						e.printStackTrace();
					} catch (InvocationTargetException e) {
						// TODO 예외 발생
						e.printStackTrace();
					} catch (NoSuchMethodException e) {
						// TODO 예외 발생
						e.printStackTrace();
					}
				} else {
					mm = categories.get(i);
				}

				for (int j = 0; j < headers.length; j++) {
					cell = getCell(sheet, 3 + i, j);
					if (dataType == null || dataType[j].equals("S")) {
						setText(cell, mm.get(columns[j]) == null ? "" : mm.get(columns[j]).toString(), cellStyle);
					} else if (dataType[j].equals("D")) {
						setDate(cell, mm.get(columns[j]) == null ? "" : mm.get(columns[j]).toString(), cellStyle, wb);
					} else if (dataType[j].equals("N")) {
						setNumber(cell, mm.get(columns[j]) == null ? "" : mm.get(columns[j]).toString(), cellStyle, wb);
					} else {
						System.out.println(mm.get(columns[j]).toString());
						setText(cell, mm.get(columns[j]).toString(), cellStyle);
					}
				}
			}
		}
	}

	protected void setText(Cell cell, String text, CellStyle cellStyle) {
		cell.setCellStyle(cellStyle);
		cell.setCellValue(text);
	}

	protected void setNumber(Cell cell, String text, CellStyle cellStyle, Workbook wb) {
		Map<String, CellStyle> multicell = createMultipleCellStyle(wb, text, "N");
		cell.setCellStyle(multicell.get("input_right"));

		if (!text.isEmpty() || !text.equals("")) {
			double value = Double.parseDouble(text);
			cell.setCellValue(value);
		} else {

			cell.setCellValue((String) null);
		}
	}

	protected void setDate(Cell cell, String text, CellStyle cellStyle, Workbook wb) {
		Map<String, CellStyle> multicell = createMultipleCellStyle(wb, text, "D");
		cell.setCellStyle(multicell.get("input_center"));

		int leng = text.length();
		String date_format = "";
		if (leng == 4) {
			// 년도
			date_format = "yyyy";
		} else if (leng == 7) {
			// 년-월
			date_format = "yyyy-MM";
		} else if (leng == 10) {
			// 년-월-일
			date_format = "yyyy-MM-dd";
		} else if (leng == 13) {
			// 년-월-일 시간
			date_format = "yyyy-MM-dd h";
		} else if (leng == 16) {
			// 년-월-일 시간:분
			date_format = "yyyy-MM-dd h:mm";
		} else if (leng == 19) {
			// 년-월-일 시간:분:초
			date_format = "yyyy-MM-dd h:mm:ss";
		} else {
			// 그 외
			date_format = "yyyy-MM-dd";
		}
		if (!text.isEmpty() || !text.equals("")) {
			SimpleDateFormat formatter = new SimpleDateFormat(date_format);
			Date date = null;
			try {
				date = formatter.parse(text);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			cell.setCellValue(date);
		} else {

			cell.setCellValue((String) null);
		}
	}

	@SuppressWarnings("static-access")
	protected Map<String, CellStyle> createMultipleCellStyle(Workbook wb, String text, String flag) {
		Map<String, CellStyle> cellStyles = new HashMap<String, CellStyle>();
		DataFormat dataFormat = wb.createDataFormat();
		
		CellStyle cellStyle;

		// 1. 폰트 설정
		Font font = wb.createFont();

		font.setFontHeightInPoints((short) 11);
		font.setFontName("맑은 고딕");

		// 문자
		cellStyle = wb.createCellStyle();
		cellStyle.setBorderBottom((short) 1);
		cellStyle.setBorderLeft((short) 1);
		cellStyle.setBorderRight((short) 1);
		cellStyle.setFont(font);
		cellStyles.put("input_left", cellStyle);

		// 날짜
		cellStyle = wb.createCellStyle();
		cellStyle.setAlignment(cellStyle.ALIGN_CENTER);       

		String date_format = "";
		if ( flag == "D" ) {
			int leng = text.length();
			if (leng == 4) {
				// 년도
				date_format = "yyyy";
			} else if (leng == 7) {
				// 년-월
				date_format = "yyyy-MM";
			} else if (leng == 10) {
				// 년-월-일
				date_format = "yyyy-MM-dd";
			} else if (leng == 13) {
				// 년-월-일 시간
				date_format = "yyyy-MM-dd h";
			} else if (leng == 16) {
				// 년-월-일 시간:분
				date_format = "yyyy-MM-dd h:mm";
			} else if (leng == 19) {
				// 년-월-일 시간:분:초
				date_format = "yyyy-MM-dd h:mm:ss";
			} else {
				// 그 외
				date_format = "yyyy-MM-dd";
			}
		} else {
			date_format = "yyyy-MM-dd";
		}
		cellStyle.setDataFormat(dataFormat.getFormat(date_format));
		cellStyle.setBorderBottom((short) 1);
		cellStyle.setBorderLeft((short) 1);
		cellStyle.setBorderRight((short) 1);
		cellStyle.setFont(font);
		cellStyles.put("input_center", cellStyle);
		
		// 숫자
		cellStyle = wb.createCellStyle();
		cellStyle.setAlignment(cellStyle.ALIGN_RIGHT);
		
		String number_format = "";
		if (flag == "N") {
			if (text == null || text.trim().length() == 0) {
				number_format = "#,##0;[빨강]-#,##0";
			} else {
				BigDecimal value = new BigDecimal(text);
				BigDecimal val_sub = value.subtract(new BigDecimal(value.longValue()));
				if (val_sub.doubleValue() == 0.0d) {
					// 정수
					number_format = "#,##0;[빨강]-#,##0";
				} else {
					// 실수
					number_format = "#,##0.0##;[빨강]-#,##0.0##";
				}
			}
		} else {
			number_format = "#,##0;[빨강]-#,##0";
		}
		cellStyle.setDataFormat(dataFormat.getFormat(number_format));
		cellStyle.setBorderBottom((short) 1);
		cellStyle.setBorderLeft((short) 1);
		cellStyle.setBorderRight((short) 1);
		cellStyle.setFont(font);
		cellStyles.put("input_right", cellStyle);
		
		return cellStyles;
	}
	
	@Override
	protected Workbook createWorkbook() {
		// TODO 시트 객체 생성
		return new HSSFWorkbook();
	}
}