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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import kr.co.bps.scs.file.AbstractExcelPOIView;
import kr.co.bps.scs.util.StringUtil;

/**
 * ModelAndView 를 통한 엑셀 뷰 생성 파라미터 세팅을 통해서 칼럼명과 칼럼 형식을 지정하고 DB에서 조회할때 칼럼 명을 숫자로
 * 순서대로 조회한 결과를 순서대로 맵핑함.
 * 
 * @author ymha
 * @since 2018. 01. 15.
 * @version 1.0
 * @see
 * 
 *      <pre>
 * 
 * << 개정이력(Modification Information) >>
 *   
 *   수정일         수정자               수정내용
 *  ------------    -----------------    ---------------------------
 *   2018. 01. 15. : ymha             : 신규 적용.
 * 
 * </pre>
 */
public class ExcelDownloadXlsx extends AbstractExcelPOIView {

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
			resp.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(map.get("title") + ".xlsx", "UTF-8") + ";");

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
		
		String multiyn = StringUtil.nullConvert(map.get("multiyn"));

		String sheetName1 = StringUtil.nullConvert(map.get("sheet1"));
		
		Sheet sheet = null;

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
		


		// 데이터 분리화
		String[] headers = map.get("header").toString().split(";");
		String[] columns = map.get("columns").toString().split(";");
		String[] dataType = map.get("type").toString().split(";");

		// 가공되지 않은 데이터
		List<HashMap> categories = map.get("data") == null ? null : (List<HashMap>) map.get("data");

		Map mm = null;
		
		// 0. 시트생성
		if (!multiyn.isEmpty()) {
			String sheetName2 = StringUtil.nullConvert(map.get("sheet2"));
			String sheetName3 = StringUtil.nullConvert(map.get("sheet3"));
			String sheetName4 = StringUtil.nullConvert(map.get("sheet4"));
			String sheetName5 = StringUtil.nullConvert(map.get("sheet5"));
			String sheetName6 = StringUtil.nullConvert(map.get("sheet6"));
			String sheetName7 = StringUtil.nullConvert(map.get("sheet7"));
			String sheetName8 = StringUtil.nullConvert(map.get("sheet8"));
			String sheetName9 = StringUtil.nullConvert(map.get("sheet9"));
			String sheetName10 = StringUtil.nullConvert(map.get("sheet10"));

			Cell cell2 = null;
			Cell cell3 = null;
			Cell cell4 = null;
			Cell cell5 = null;
			Cell cell6 = null;
			Cell cell7 = null;
			Cell cell8 = null;
			Cell cell9 = null;
			Cell cell10 = null;

			Sheet sheet2 = null;
			Sheet sheet3 = null;
			Sheet sheet4 = null;
			Sheet sheet5 = null;
			Sheet sheet6 = null;
			Sheet sheet7 = null;
			Sheet sheet8 = null;
			Sheet sheet9 = null;
			Sheet sheet10 = null;
			
			if (!sheetName1.isEmpty()) {
				sheet = wb.createSheet(sheetName1);
				
				sheet.setDefaultColumnWidth(15);
				sheet.setDisplayGridlines(false);
			}
			if (!sheetName2.isEmpty()) {
				sheet2 = wb.createSheet(sheetName2);

				sheet2.setDefaultColumnWidth(15);
				sheet2.setDisplayGridlines(false);
			}
			if (!sheetName3.isEmpty()) {
				sheet3 = wb.createSheet(sheetName3);

				sheet3.setDefaultColumnWidth(15);
				sheet3.setDisplayGridlines(false);
			}
			if (!sheetName4.isEmpty()) {
				sheet4 = wb.createSheet(sheetName4);

				sheet4.setDefaultColumnWidth(15);
				sheet4.setDisplayGridlines(false);
			}
			if (!sheetName5.isEmpty()) {
				sheet5 = wb.createSheet(sheetName5);

				sheet5.setDefaultColumnWidth(15);
				sheet5.setDisplayGridlines(false);
			}
			if (!sheetName6.isEmpty()) {
				sheet6 = wb.createSheet(sheetName6);

				sheet6.setDefaultColumnWidth(15);
				sheet6.setDisplayGridlines(false);
			}
			if (!sheetName7.isEmpty()) {
				sheet7 = wb.createSheet(sheetName7);

				sheet7.setDefaultColumnWidth(15);
				sheet7.setDisplayGridlines(false);
			}
			if (!sheetName8.isEmpty()) {
				sheet8 = wb.createSheet(sheetName8);

				sheet8.setDefaultColumnWidth(15);
				sheet8.setDisplayGridlines(false);
			}
			if (!sheetName9.isEmpty()) {
				sheet9 = wb.createSheet(sheetName9);

				sheet9.setDefaultColumnWidth(15);
				sheet9.setDisplayGridlines(false);
			}
			if (!sheetName10.isEmpty()) {
				sheet10 = wb.createSheet(sheetName10);

				sheet10.setDefaultColumnWidth(15);
				sheet10.setDisplayGridlines(false);
			}
			
			// 제목란은 첫번째 셀에 추가
			if (!sheetName1.isEmpty()) {
				cell = getCell(sheet, 0, 0);
				setText(cell, sheetName1);
			}
			if (!sheetName2.isEmpty()) {
				cell2 = getCell(sheet2, 0, 0);
				setText(cell2, sheetName2);
			}
			if (!sheetName3.isEmpty()) {
				cell3 = getCell(sheet3, 0, 0);
				setText(cell3, sheetName3);
			}
			if (!sheetName4.isEmpty()) {
				cell4 = getCell(sheet4, 0, 0);
				setText(cell4, sheetName4);
			}
			if (!sheetName5.isEmpty()) {
				cell5 = getCell(sheet5, 0, 0);
				setText(cell5, sheetName5);
			}
			if (!sheetName6.isEmpty()) {
				cell6 = getCell(sheet6, 0, 0);
				setText(cell6, sheetName6);
			}
			if (!sheetName7.isEmpty()) {
				cell7 = getCell(sheet7, 0, 0);
				setText(cell7, sheetName7);
			}
			if (!sheetName8.isEmpty()) {
				cell8 = getCell(sheet8, 0, 0);
				setText(cell8, sheetName8);
			}
			if (!sheetName9.isEmpty()) {
				cell9 = getCell(sheet9, 0, 0);
				setText(cell9, sheetName9);
			}
			if (!sheetName10.isEmpty()) {
				cell10 = getCell(sheet10, 0, 0);
				setText(cell10, sheetName10);
			}
			
			String[] headers2 = null;
			String[] columns2 = null;
			String[] dataType2 = null;
			String[] headers3 = null;
			String[] columns3 = null;
			String[] dataType3 = null;
			String[] headers4 = null;
			String[] columns4 = null;
			String[] dataType4 = null;
			String[] headers5 = null;
			String[] columns5 = null;
			String[] dataType5 = null;
			String[] headers6 = null;
			String[] columns6 = null;
			String[] dataType6 = null;
			String[] headers7 = null;
			String[] columns7 = null;
			String[] dataType7 = null;
			String[] headers8 = null;
			String[] columns8 = null;
			String[] dataType8 = null;
			String[] headers9 = null;
			String[] columns9 = null;
			String[] dataType9 = null;
			String[] headers10 = null;
			String[] columns10 = null;
			String[] dataType10 = null;

			if (!sheetName1.isEmpty()) {
				headers = map.get("header").toString().split(";");
				columns = map.get("columns").toString().split(";");
				dataType = map.get("type").toString().split(";");

				for (int i = 0; i < headers.length; i++) {
					setText(getCell(sheet, 2, i), headers[i], headerStyle);
				}
			}
			if (!sheetName2.isEmpty()) {
				headers2 = map.get("header2").toString().split(";");
				columns2 = map.get("columns2").toString().split(";");
				dataType2 = map.get("type2").toString().split(";");

				for (int i = 0; i < headers2.length; i++) {
					setText(getCell(sheet2, 2, i), headers2[i], headerStyle);
				}
			}
			if (!sheetName3.isEmpty()) {
				headers3 = map.get("header3").toString().split(";");
				columns3 = map.get("columns3").toString().split(";");
				dataType3 = map.get("type3").toString().split(";");

				for (int i = 0; i < headers3.length; i++) {
					setText(getCell(sheet3, 2, i), headers3[i], headerStyle);
				}
			}
			if (!sheetName4.isEmpty()) {
				headers4 = map.get("header4").toString().split(";");
				columns4 = map.get("columns4").toString().split(";");
				dataType4 = map.get("type4").toString().split(";");

				for (int i = 0; i < headers4.length; i++) {
					setText(getCell(sheet4, 2, i), headers4[i], headerStyle);
				}
			}
			if (!sheetName5.isEmpty()) {
				headers5 = map.get("header5").toString().split(";");
				columns5 = map.get("columns5").toString().split(";");
				dataType5 = map.get("type5").toString().split(";");

				for (int i = 0; i < headers5.length; i++) {
					setText(getCell(sheet5, 2, i), headers5[i], headerStyle);
				}
			}
			if (!sheetName6.isEmpty()) {
				headers6 = map.get("header6").toString().split(";");
				columns6 = map.get("columns6").toString().split(";");
				dataType6 = map.get("type6").toString().split(";");

				for (int i = 0; i < headers6.length; i++) {
					setText(getCell(sheet6, 2, i), headers6[i], headerStyle);
				}
			}
			if (!sheetName7.isEmpty()) {
				headers7 = map.get("header7").toString().split(";");
				columns7 = map.get("columns7").toString().split(";");
				dataType7 = map.get("type7").toString().split(";");

				for (int i = 0; i < headers7.length; i++) {
					setText(getCell(sheet7, 2, i), headers7[i], headerStyle);
				}
			}
			if (!sheetName8.isEmpty()) {
				headers8 = map.get("header8").toString().split(";");
				columns8 = map.get("columns8").toString().split(";");
				dataType8 = map.get("type8").toString().split(";");

				for (int i = 0; i < headers8.length; i++) {
					setText(getCell(sheet8, 2, i), headers8[i], headerStyle);
				}
			}
			if (!sheetName9.isEmpty()) {
				headers9 = map.get("header9").toString().split(";");
				columns9 = map.get("columns9").toString().split(";");
				dataType9 = map.get("type9").toString().split(";");

				for (int i = 0; i < headers9.length; i++) {
					setText(getCell(sheet9, 2, i), headers9[i], headerStyle);
				}
			}
			if (!sheetName10.isEmpty()) {
				headers10 = map.get("header10").toString().split(";");
				columns10 = map.get("columns10").toString().split(";");
				dataType10 = map.get("type10").toString().split(";");

				for (int i = 0; i < headers10.length; i++) {
					setText(getCell(sheet10, 2, i), headers10[i], headerStyle);
				}
			}

			List<HashMap> categories2 = map.get("data2") == null ? null : (List<HashMap>) map.get("data2");
			List<HashMap> categories3 = map.get("data3") == null ? null : (List<HashMap>) map.get("data3");
			List<HashMap> categories4 = map.get("data4") == null ? null : (List<HashMap>) map.get("data4");
			List<HashMap> categories5 = map.get("data5") == null ? null : (List<HashMap>) map.get("data5");
			List<HashMap> categories6 = map.get("data6") == null ? null : (List<HashMap>) map.get("data6");
			List<HashMap> categories7 = map.get("data7") == null ? null : (List<HashMap>) map.get("data7");
			List<HashMap> categories8 = map.get("data8") == null ? null : (List<HashMap>) map.get("data8");
			List<HashMap> categories9 = map.get("data9") == null ? null : (List<HashMap>) map.get("data9");
			List<HashMap> categories10 = map.get("data10") == null ? null : (List<HashMap>) map.get("data10");

			// 셀 설정내역 시트별 적용
			// 한놈은 검정 한놈은 흰색...이런 각기 스타일로 해주고싶은데 그러기엔 시간이 부족하다...니트로박사
			if (!sheetName1.isEmpty()) {
				cell.setCellStyle(cellStyle);
			}
			if (!sheetName2.isEmpty()) {
				cell2.setCellStyle(cellStyle);
			}
			if (!sheetName3.isEmpty()) {
				cell3.setCellStyle(cellStyle);
			}
			if (!sheetName4.isEmpty()) {
				cell4.setCellStyle(cellStyle);
			}
			if (!sheetName5.isEmpty()) {
				cell5.setCellStyle(cellStyle);
			}
			if (!sheetName6.isEmpty()) {
				cell6.setCellStyle(cellStyle);
			}
			if (!sheetName7.isEmpty()) {
				cell7.setCellStyle(cellStyle);
			}
			if (!sheetName8.isEmpty()) {
				cell8.setCellStyle(cellStyle);
			}
			if (!sheetName9.isEmpty()) {
				cell9.setCellStyle(cellStyle);
			}
			if (!sheetName10.isEmpty()) {
				cell10.setCellStyle(cellStyle);
			}

			Map mm2 = null;
			Map mm3 = null;
			Map mm4 = null;
			Map mm5 = null;
			Map mm6 = null;
			Map mm7 = null;
			Map mm8 = null;
			Map mm9 = null;
			Map mm10 = null;

			
			// 1번 시트
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
//							System.out.println(mm.get(columns[j]).toString());
							setText(cell, mm.get(columns[j]).toString(), cellStyle);
						}
					}
//					sheet.autoSizeColumn(i);
//					sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 1000);
				}
				
//				int size = categories.size() - 1;
//				sheet.autoSizeColumn(size);
//				sheet.setColumnWidth(size, (sheet.getColumnWidth(size)) + 1000);
			}
			
			// 2번 시트
			if (categories2 != null) {

				for (int i = 0; i < categories2.size(); i++) {
					if (categories2.get(i).getClass() != HashMap.class) {
						try {
							mm2 = BeanUtils.describe(categories2.get(i));
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
						mm2 = categories2.get(i);
					}

					for (int j = 0; j < headers2.length; j++) {
						cell2 = getCell(sheet2, 3 + i, j);
						if (dataType2 == null || dataType2[j].equals("S")) {
							setText(cell2, mm2.get(columns2[j]) == null ? "" : mm2.get(columns2[j]).toString(), cellStyle);
						} else if (dataType2[j].equals("D")) {
							setDate(cell2, mm2.get(columns2[j]) == null ? "" : mm2.get(columns2[j]).toString(), cellStyle, wb);
						} else if (dataType2[j].equals("N")) {
							setNumber(cell2, mm2.get(columns2[j]) == null ? "" : mm2.get(columns2[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm2.get(columns2[j]).toString());
							setText(cell2, mm2.get(columns2[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories2.size() - 1;
//				sheet2.autoSizeColumn(size);
//				sheet2.setColumnWidth(size, (sheet2.getColumnWidth(size)) + 1000);
			}
			
			// 3번 시트
			if (categories3 != null) {

				for (int i = 0; i < categories3.size(); i++) {
					if (categories3.get(i).getClass() != HashMap.class) {
						try {
							mm3 = BeanUtils.describe(categories3.get(i));
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
						mm3 = categories3.get(i);
					}

					for (int j = 0; j < headers3.length; j++) {
						cell3 = getCell(sheet3, 3 + i, j);
						if (dataType3 == null || dataType3[j].equals("S")) {
							setText(cell3, mm3.get(columns3[j]) == null ? "" : mm3.get(columns3[j]).toString(), cellStyle);
						} else if (dataType3[j].equals("D")) {
							setDate(cell3, mm3.get(columns3[j]) == null ? "" : mm3.get(columns3[j]).toString(), cellStyle, wb);
						} else if (dataType3[j].equals("N")) {
							setNumber(cell3, mm3.get(columns3[j]) == null ? "" : mm3.get(columns3[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm3.get(columns3[j]).toString());
							setText(cell3, mm3.get(columns3[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories3.size() - 1;
//				sheet3.autoSizeColumn(size);
//				sheet3.setColumnWidth(size, (sheet3.getColumnWidth(size)) + 1000);
			}
			
			// 4번 시트
			if (categories4 != null) {

				for (int i = 0; i < categories4.size(); i++) {
					if (categories4.get(i).getClass() != HashMap.class) {
						try {
							mm4 = BeanUtils.describe(categories4.get(i));
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
						mm4 = categories4.get(i);
					}

					for (int j = 0; j < headers4.length; j++) {
						cell4 = getCell(sheet4, 3 + i, j);
						if (dataType4 == null || dataType4[j].equals("S")) {
							setText(cell4, mm4.get(columns4[j]) == null ? "" : mm4.get(columns4[j]).toString(), cellStyle);
						} else if (dataType4[j].equals("D")) {
							setDate(cell4, mm4.get(columns4[j]) == null ? "" : mm4.get(columns4[j]).toString(), cellStyle, wb);
						} else if (dataType4[j].equals("N")) {
							setNumber(cell4, mm4.get(columns4[j]) == null ? "" : mm4.get(columns4[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm4.get(columns4[j]).toString());
							setText(cell4, mm4.get(columns4[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories4.size() - 1;
//				sheet4.autoSizeColumn(size);
//				sheet4.setColumnWidth(size, (sheet4.getColumnWidth(size)) + 1000);
			}
			
			// 5번 시트
			if (categories5 != null) {

				for (int i = 0; i < categories5.size(); i++) {
					if (categories5.get(i).getClass() != HashMap.class) {
						try {
							mm5 = BeanUtils.describe(categories5.get(i));
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
						mm5 = categories5.get(i);
					}

					for (int j = 0; j < headers5.length; j++) {
						cell5 = getCell(sheet5, 3 + i, j);
						if (dataType5 == null || dataType5[j].equals("S")) {
							setText(cell5, mm5.get(columns5[j]) == null ? "" : mm5.get(columns5[j]).toString(), cellStyle);
						} else if (dataType5[j].equals("D")) {
							setDate(cell5, mm5.get(columns5[j]) == null ? "" : mm5.get(columns5[j]).toString(), cellStyle, wb);
						} else if (dataType5[j].equals("N")) {
							setNumber(cell5, mm5.get(columns5[j]) == null ? "" : mm5.get(columns5[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm5.get(columns5[j]).toString());
							setText(cell5, mm5.get(columns5[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories5.size() - 1;
//				sheet5.autoSizeColumn(size);
//				sheet5.setColumnWidth(size, (sheet5.getColumnWidth(size)) + 1000);
			}
			
			// 6번 시트
			if (categories6 != null) {

				for (int i = 0; i < categories6.size(); i++) {
					if (categories6.get(i).getClass() != HashMap.class) {
						try {
							mm6 = BeanUtils.describe(categories6.get(i));
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
						mm6 = categories6.get(i);
					}

					for (int j = 0; j < headers6.length; j++) {
						cell6 = getCell(sheet6, 3 + i, j);
						if (dataType6 == null || dataType6[j].equals("S")) {
							setText(cell6, mm6.get(columns6[j]) == null ? "" : mm6.get(columns6[j]).toString(), cellStyle);
						} else if (dataType6[j].equals("D")) {
							setDate(cell6, mm6.get(columns6[j]) == null ? "" : mm6.get(columns6[j]).toString(), cellStyle, wb);
						} else if (dataType6[j].equals("N")) {
							setNumber(cell6, mm6.get(columns6[j]) == null ? "" : mm6.get(columns6[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm6.get(columns6[j]).toString());
							setText(cell6, mm6.get(columns6[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories6.size() - 1;
//				sheet6.autoSizeColumn(size);
//				sheet6.setColumnWidth(size, (sheet6.getColumnWidth(size)) + 1000);
			}
			
			// 7번 시트
			if (categories7 != null) {

				for (int i = 0; i < categories7.size(); i++) {
					if (categories7.get(i).getClass() != HashMap.class) {
						try {
							mm7 = BeanUtils.describe(categories7.get(i));
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
						mm7 = categories7.get(i);
					}

					for (int j = 0; j < headers7.length; j++) {
						cell7 = getCell(sheet7, 3 + i, j);
						if (dataType7 == null || dataType7[j].equals("S")) {
							setText(cell7, mm7.get(columns7[j]) == null ? "" : mm7.get(columns7[j]).toString(), cellStyle);
						} else if (dataType7[j].equals("D")) {
							setDate(cell7, mm7.get(columns7[j]) == null ? "" : mm7.get(columns7[j]).toString(), cellStyle, wb);
						} else if (dataType7[j].equals("N")) {
							setNumber(cell7, mm7.get(columns7[j]) == null ? "" : mm7.get(columns7[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm7.get(columns7[j]).toString());
							setText(cell7, mm7.get(columns7[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories7.size() - 1;
//				sheet7.autoSizeColumn(size);
//				sheet7.setColumnWidth(size, (sheet7.getColumnWidth(size)) + 1000);
			}
			
			// 8번 시트
			if (categories8 != null) {

				for (int i = 0; i < categories8.size(); i++) {
					if (categories8.get(i).getClass() != HashMap.class) {
						try {
							mm8 = BeanUtils.describe(categories8.get(i));
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
						mm8 = categories8.get(i);
					}

					for (int j = 0; j < headers8.length; j++) {
						cell8 = getCell(sheet8, 3 + i, j);
						if (dataType8 == null || dataType8[j].equals("S")) {
							setText(cell8, mm8.get(columns8[j]) == null ? "" : mm8.get(columns8[j]).toString(), cellStyle);
						} else if (dataType8[j].equals("D")) {
							setDate(cell8, mm8.get(columns8[j]) == null ? "" : mm8.get(columns8[j]).toString(), cellStyle, wb);
						} else if (dataType8[j].equals("N")) {
							setNumber(cell8, mm8.get(columns8[j]) == null ? "" : mm8.get(columns8[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm8.get(columns8[j]).toString());
							setText(cell8, mm8.get(columns8[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories8.size() - 1;
//				sheet8.autoSizeColumn(size);
//				sheet8.setColumnWidth(size, (sheet8.getColumnWidth(size)) + 1000);
			}
			
			// 9번 시트
			if (categories9 != null) {

				for (int i = 0; i < categories9.size(); i++) {
					if (categories9.get(i).getClass() != HashMap.class) {
						try {
							mm9 = BeanUtils.describe(categories9.get(i));
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
						mm9 = categories9.get(i);
					}

					for (int j = 0; j < headers9.length; j++) {
						cell9 = getCell(sheet9, 3 + i, j);
						if (dataType9 == null || dataType9[j].equals("S")) {
							setText(cell9, mm9.get(columns9[j]) == null ? "" : mm9.get(columns9[j]).toString(), cellStyle);
						} else if (dataType9[j].equals("D")) {
							setDate(cell9, mm9.get(columns9[j]) == null ? "" : mm9.get(columns9[j]).toString(), cellStyle, wb);
						} else if (dataType9[j].equals("N")) {
							setNumber(cell9, mm9.get(columns9[j]) == null ? "" : mm9.get(columns9[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm9.get(columns9[j]).toString());
							setText(cell9, mm9.get(columns9[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories9.size() - 1;
//				sheet9.autoSizeColumn(size);
//				sheet9.setColumnWidth(size, (sheet9.getColumnWidth(size)) + 1000);
			}
			
			// 10번 시트
			if (categories10 != null) {

				for (int i = 0; i < categories10.size(); i++) {
					if (categories10.get(i).getClass() != HashMap.class) {
						try {
							mm10 = BeanUtils.describe(categories10.get(i));
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
						mm10 = categories10.get(i);
					}

					for (int j = 0; j < headers10.length; j++) {
						cell10 = getCell(sheet10, 3 + i, j);
						if (dataType10 == null || dataType10[j].equals("S")) {
							setText(cell10, mm10.get(columns10[j]) == null ? "" : mm10.get(columns10[j]).toString(), cellStyle);
						} else if (dataType10[j].equals("D")) {
							setDate(cell10, mm10.get(columns10[j]) == null ? "" : mm10.get(columns10[j]).toString(), cellStyle, wb);
						} else if (dataType10[j].equals("N")) {
							setNumber(cell10, mm10.get(columns10[j]) == null ? "" : mm10.get(columns10[j]).toString(), cellStyle, wb);
						} else {
//							System.out.println(mm10.get(columns10[j]).toString());
							setText(cell10, mm10.get(columns10[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories10.size() - 1;
//				sheet10.autoSizeColumn(size);
//				sheet10.setColumnWidth(size, (sheet10.getColumnWidth(size)) + 1000);
			}
		} else {
			String title_name = StringUtil.nullConvert(map.get("title"));
			sheet = wb.createSheet(title_name);

			sheet.setDefaultColumnWidth(15);
			sheet.setDisplayGridlines(false);
			

			// 제목란은 첫번째 셀에 추가
			cell = getCell(sheet, 0, 0);
			setText(cell, title_name);
			

			for (int i = 0; i < headers.length; i++) {
				setText(getCell(sheet, 2, i), headers[i], headerStyle);
			}

			cell.setCellStyle(cellStyle);

			// 1번 시트
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
//							System.out.println(mm.get(columns[j]).toString());
							setText(cell, mm.get(columns[j]).toString(), cellStyle);
						}
					}
				}
//				int size = categories.size() - 1;
//				sheet.autoSizeColumn(size);
//				sheet.setColumnWidth(size, (sheet.getColumnWidth(size)) + 1000);
			}
			
		}
	}

	protected void setText(Cell cell, String text, CellStyle cellStyle) {
//		System.out.println("setText >>>>>>>>>> " + text);
//		cell.setCellType(Cell.CELL_TYPE_STRING);
		cell.setCellStyle(cellStyle);
		cell.setCellValue(text);
	}

	protected void setNumber(Cell cell, String text, CellStyle cellStyle, Workbook wb) {
		// System.out.println("setNumber >>>>>>>>>> " + text);

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
		// font.setBoldweight(Font.BOLDWEIGHT_BOLD);
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
		if (flag == "D") {
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
				number_format = "#,##0";
			} else {
				BigDecimal value = new BigDecimal(text);
				BigDecimal val_sub = value.subtract(new BigDecimal(value.longValue()));
				if (val_sub.doubleValue() == 0.0d) {
					// 정수
					number_format = "#,##0";
				} else {
					// 실수
					number_format = "#,##0.0##";
				}
			}
		} else {
			number_format = "#,##0";
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
		return new XSSFWorkbook();
	}

}