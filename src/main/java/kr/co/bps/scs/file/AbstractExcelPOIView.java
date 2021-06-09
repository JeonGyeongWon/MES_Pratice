package kr.co.bps.scs.file;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.servlet.view.AbstractView;

/**
 * Xls, Xlsx 엑셀파일 다운로드를 위한 POI VIEW
 * 
 * @author ymha
 * @since 2018. 01. 16.
 * @version 1.0
 * @see
 * 
 *      <pre>
 * 
 * << 개정이력(Modification Information) >>
 *   
 *   수정일         수정자               수정내용
 *  ------------    -----------------    ---------------------------
 *   2018. 01. 16. : ymha             : 신규 적용.
 * 
 * </pre>
 */
public abstract class AbstractExcelPOIView extends AbstractView {

	/** 
	 * The content type for an Excel response
	 * 
	 * Excel 2003 :  CONTENT_TYPE_XLS
	 * Excel 2007 : CONTENT_TYPE_XLSX
	 */
	private static final String CONTENT_TYPE_XLSX = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
	private static final String CONTENT_TYPE_XLS = "application/vnd.ms-excel";

	/**
	 * Default Constructor
	 */
	public AbstractExcelPOIView() {
	}

	@Override
	protected boolean generatesDownloadContent() {
		return true;
	}

	/**
	 * Renders the Excel view, given the specified model.
	 */
	@Override
	protected final void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		Workbook workbook = createWorkbook();

		if (workbook instanceof XSSFWorkbook || workbook instanceof SXSSFWorkbook) {
			setContentType(CONTENT_TYPE_XLSX);
		} else {
			setContentType(CONTENT_TYPE_XLS);
		}

		buildExcelDocument(model, workbook, request, response);

		// Set the content type.
		response.setContentType(getContentType());

		// 시트 데이터 갱신 및 버퍼 초기화
		ServletOutputStream out = response.getOutputStream();
		out.flush();
		workbook.write(out);
		out.flush();
		if (workbook instanceof SXSSFWorkbook) {
			((SXSSFWorkbook) workbook).dispose();
		}
	}

	/**
	 * 엑셀 시트 생성 추상화
	 * HSSFWorkbook, XSSFWorkbook, SXSSFWorkbook 지원
	 */
	protected abstract Workbook createWorkbook();

	/**
	 * 엑셀 다운로드 추상화
	 * 
	 * @param model
	 * @param workbook
	 * @param request
	 * @param response
	 */
	protected abstract void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception;

	/**
	 * 셀 데이터를 가져온다.
	 * 
	 * @param sheet
	 * @param row
	 * @param col
	 * @return Cell
	 */
	protected Cell getCell(Sheet sheet, int row, int col) {
		Row sheetRow = sheet.getRow(row);
		if (sheetRow == null) {
			sheetRow = sheet.createRow(row);
		}
		Cell cell = sheetRow.getCell((short) col);
		if (cell == null) {
			cell = sheetRow.createCell((short) col);
		}
		return cell;
	}

	/**
	 * 셀 데이터를 가공한다.
	 * 
	 * @param cell
	 * @param text
	 */
	protected void setText(Cell cell, String text) {
		cell.setCellType(Cell.CELL_TYPE_STRING);
		cell.setCellValue(text);
	}

}