package kr.co.bps.scs.file;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.util.StringUtil;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.NumberToTextConverter;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.apache.poi.ss.usermodel.Row.MissingCellPolicy;

import com.ibm.icu.text.SimpleDateFormat;

@Service
public class ExcelFileService extends BaseService {

	public List<Object> getExcelData(final Map<String, MultipartFile> files, int sheetNum, int headrow, int firstRow) throws Exception {
		List<Object> result = new ArrayList<Object>();

		if (files != null) {

			Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
			MultipartFile file = null;
			InputStream fis = null;
			while (itr.hasNext()) {
				Entry<String, MultipartFile> entry = itr.next();

				try {
					file = entry.getValue();
					fis = file.getInputStream();

					String filename = StringUtil.nullConvert(file.getOriginalFilename().toLowerCase());
					if (filename.endsWith(".xls")) {
						HSSFWorkbook workbook = new HSSFWorkbook(fis);
						result = getSheetData(workbook.getSheetAt(sheetNum), headrow, firstRow);
					} else if (filename.endsWith(".xlsx")) {
						Workbook workbook = new XSSFWorkbook(fis);
						//						Sheet sheet = workbook.getSheetAt(0);
						//						Row row = sheet.getRow(1); //프로그램 row 가져오기
						//						int progrmSheetRowCnt = row.getPhysicalNumberOfCells(); //프로그램 cell Cnt

						result = getSheetDataXlsx(workbook.getSheetAt(sheetNum), headrow, firstRow);
					}

				} finally {
					try {
						if (fis != null) {
							fis.close();
						}
					} catch (IOException ee) {
						ee.printStackTrace();
					}
				}
			}
		}

		return result;
	}

	/**
	 * xls 엑셀 시트 데이터 가져오기
	 * 
	 * @return List<Object>
	 * @exception Exception
	 */
	private List<Object> getSheetData(HSSFSheet sheet, int headrow, int firstRow) throws Exception {

		List<Object> sheetData = new ArrayList<Object>();
		List<String> header = new ArrayList<String>();

		HSSFRow headerData = sheet.getRow(headrow);
		for (int i = 0; i <= headerData.getLastCellNum(); i++) {
			HSSFCell cell = headerData.getCell(i);
			if (cell == null)
				continue;

			header.add(cell.getStringCellValue());
		}

		for (int i = firstRow; i <= sheet.getLastRowNum(); i++) {

			HSSFRow row = sheet.getRow(i);
			if (isRowEmpty(row)) {
				continue;
			}
//			if (row == null)
//				continue;

			Map<String, Object> rowdata = new HashMap<String, Object>();
			for (int ii = 0; ii <= row.getLastCellNum(); ii++) {
//				HSSFCell cell = row.getCell(ii);
				HSSFCell cell = row.getCell(ii, Row.RETURN_BLANK_AS_NULL);
				if (cell == null)
					continue;

				rowdata.put((String) header.get(ii), getCellValue(cell));
			}
			sheetData.add(rowdata);
		}

		return sheetData;
	}

	/**
	 * xls 엑셀 셀 값 가져오기
	 * 
	 * @return List<Object>
	 * @exception Exception
	 */
	private Object getCellValue(HSSFCell cell) throws Exception {
		int celltype = cell.getCellType();
		Object value = null;

		switch (celltype) {
		case HSSFCell.CELL_TYPE_FORMULA:
			value = cell.getCellFormula();
			break;
		case HSSFCell.CELL_TYPE_NUMERIC:
			if (DateUtil.isCellDateFormatted(cell)) {
				// 날짜 형식
				SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");
				value = "" + dateformat.format(cell.getDateCellValue());
			} else {
				value = "" + String.format("%.0f", new Double(cell.getNumericCellValue()));
			}
			break;
		case HSSFCell.CELL_TYPE_STRING:
			value = "" + cell.getStringCellValue();
			break;
		case HSSFCell.CELL_TYPE_BLANK:
			// value= "" + cell.getBooleanCellValue();
			value = "";
			break;
		case HSSFCell.CELL_TYPE_ERROR:
			value = "" + cell.getErrorCellValue();
			break;
		default:
			value = "";
			break;
		}

//		value = cell.getStringCellValue();
		return value;
	}

	/**
	 * xlsx 엑셀 시트 데이터 가져오기
	 * 
	 * @return List<Object>
	 * @exception Exception
	 */
	private List<Object> getSheetDataXlsx(Sheet sheet, int headrow, int firstRow) throws Exception {

		List<Object> sheetData = new ArrayList<Object>();
		List<String> header = new ArrayList<String>();

		Row headerData = sheet.getRow(headrow);
		for (int i = 0; i < headerData.getLastCellNum(); i++) {
			Cell cell = headerData.getCell(i);
			if (cell == null)
				continue;

			header.add(cell.getStringCellValue());
//			System.out.println("CELL >>>>>>>>>> " + cell.getStringCellValue());

		}

		for (int i = firstRow; i <= sheet.getLastRowNum(); i++) {

			Row row = sheet.getRow(i);
			if (isRowEmpty(row)) {
				continue;
			}
//			if (row == null)
//				continue;

			Map<String, Object> rowdata = new HashMap<String, Object>();
			for (int ii = 0; ii < row.getLastCellNum(); ii++) {
//				Cell cell = row.getCell(ii);
				Cell cell = row.getCell(ii, Row.RETURN_BLANK_AS_NULL);
				if (cell == null)
					continue;

				rowdata.put((String) header.get(ii), getCellValueXlsx(cell));
				System.out.println("번호순번 i. >>>>>>>>>> " + i);
//				System.out.println("getCellValueXlsx(cell) i. >>>>>>>>>> " + getCellValueXlsx(cell));
			}
			sheetData.add(rowdata);
		}

		return sheetData;
	}

	/**
	 * xlsx 엑셀 셀 값 가져오기
	 * 
	 * @return List<Object>
	 * @exception Exception
	 */
	@SuppressWarnings("deprecation")
	private Object getCellValueXlsx(Cell cell) throws Exception {
		int celltype = cell.getCellType();
		Object value = null;

		switch (celltype) {
		case Cell.CELL_TYPE_FORMULA:
			value = cell.getCellFormula();
			break;
		case Cell.CELL_TYPE_NUMERIC:
			if (DateUtil.isCellDateFormatted(cell)) {
				// 날짜 형식
				SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");
				value = "" + dateformat.format(cell.getDateCellValue());
			} else {
				// 소수점 7째 자리에서 반올림
				value = "" + String.format("%.6f", new Double(cell.getNumericCellValue()));
			}
			break;
		case Cell.CELL_TYPE_STRING:
			value = "" + cell.getStringCellValue();
			break;
		case Cell.CELL_TYPE_BLANK:
			// value= "" + cell.getBooleanCellValue();
			value = "";
			break;
		case Cell.CELL_TYPE_ERROR:
			value = "" + cell.getErrorCellValue();
			break;
		default:
			value = "";
			break;
		}
		
//		if(cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
//		    value = NumberToTextConverter.toText(cell.getNumericCellValue());
//		    System.out.println("DataFormatter value. >>>>>>>>>> " + value);
//		} else {
//			value = cell.getStringCellValue();
//			System.out.println("getStringCellValue value. >>>>>>>>>> " + cell.getStringCellValue());
//		}
		return value;
	}

	/**
	 * xls, xlsx 엑셀 빈 Row 확인 
	 * 
	 * @return List<Object>
	 * @exception Exception
	 */
	private static boolean isRowEmpty(Row row) {
		boolean isEmpty = true;
		DataFormatter dataFormatter = new DataFormatter();

		if (row != null) {
			for (Cell cell : row) {
				if (dataFormatter.formatCellValue(cell).trim().length() > 0) {
					isEmpty = false;
					break;
				}
			}
		}

		return isEmpty;
	}
}