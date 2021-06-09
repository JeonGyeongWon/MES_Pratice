package kr.co.bps.scs.master.item;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : ItemExcelController.java
 * @Description : Item Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsHwang
 * @since 2018. 05.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 품목관리(제품)
 * 											       - 2. 품목관리(자재)
 * 											       - 3. 품목관리(공구)
 * 
 * 
 */
@Controller
public class ItemExcelController extends BaseController {

	@Autowired
	private ItemService ItemService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 품목관리(제품) // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/item/prod/ExcelDownload.do")
	public ModelAndView ItemPordExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("ItemPordExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		List<?> resultList = ItemService.selectItemExcelList(params);

		String headers = "";
		String columns = "";
		String types = "";

		headers += "순번;";
		headers += "대분류명;";
		headers += "중분류명;";
		headers += "소분류명;";
		headers += "품번;";
		headers += "품명;";
		headers += "기종;";
		headers += "타입;";
		headers += "정렬우선순위;";
		headers += "재질;";
		
		headers += "단위;";
		headers += "유형;";
		headers += "매출그룹;";
		headers += "거래처;";
		headers += "제품중량;";
		headers += "도번Rev;";
		headers += "도번일자;";
		headers += "도번;";
		headers += "관리번호;";
		headers += "생산구분;";
		
//		headers += "출하검사여부;";
		headers += "단가;";
		System.out.println("ItemPordExcelDownload 1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "BIGNAME;";
		columns += "MIDDLENAME;";
		columns += "SMALLNAME;";
		columns += "ORDERNAME;";
		columns += "ITEMNAME;";
		columns += "MODELNAME;";
		columns += "ITEMSTANDARDDETAIL;";
		columns += "SORTORDER;";
		columns += "MATERIALTYPE;";
		
		columns += "UOMNAME;";
		columns += "ITEMTYPENAME;";
		columns += "LABELTEXT;";
		columns += "CUSTOMERNAME;";
		columns += "WEIGHT;";
		columns += "DRAWINGREV;";
		columns += "DRAWINGDATE;";
		columns += "DRAWINGNO;";
		columns += "MANAGEMENTNUMBER;";
		columns += "MAKETYPENAME;";
		
//		columns += "SHIPMENTINSPECTIONYN;";
		columns += "UNITPRICEA;";
		System.out.println("ItemPordExcelDownload 2. >>>>>>>>>> " + columns);

		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";

//		types += "S;";
		types += "S;";
		System.out.println("ItemPordExcelDownload 7. >>>>>>>>>> " + types);

		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("ItemPordExcelDownload temp2. >>>>>>>>>> " + temp2);
		resultObject.put("title", temp );

		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
	
	/**
	 * 품목관리(자재) // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/item/mat/ExcelDownload.do")
	public ModelAndView ItemMatExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {


		System.out.println("ItemMatExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		List<?> resultList = ItemService.selectItemExcelList(params);

		String headers = "";
		String columns = "";
		String types = "";

		headers += "순번;";
		headers += "대분류명;";
		headers += "중분류명;";
		headers += "소분류명;";
		headers += "품명;";
		headers += "품번;";
		headers += "규격;";
		headers += "재질;";
		headers += "단위;";
		headers += "유형;";
		
		headers += "소재유형;";
		headers += "사급구분;";
		headers += "거래처;";
		headers += "수입검사유무;";
		headers += "수입검사유무(SCM용);";
		headers += "LOT관리유무;";
		headers += "재고관리유무;";
		headers += "적정재고수량;";
		headers += "단가;";
		System.out.println("ItemMatExcelDownload 1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "BIGNAME;";
		columns += "MIDDLENAME;";
		columns += "SMALLNAME;";
		columns += "ITEMNAME;";
		columns += "ORDERNAME;";
		columns += "ITEMSTANDARD;";
		columns += "MATERIALTYPE;";
		columns += "UOMNAME;";
		columns += "ITEMTYPENAME;";
		
		columns += "ITEMCLASSNAME;";
		columns += "SUBITEMNAME;";
		columns += "CUSTOMERNAME;";
		columns += "ORDERINSPECTIONYN;";
		columns += "SCMINSPECTIONYN;";
		columns += "LOTYN;";
		columns += "INVENTORYMANAGEYN;";
		columns += "INVSAFEQTY;";
		columns += "UNITPRICEA;";
		System.out.println("ItemMatExcelDownload 2. >>>>>>>>>> " + columns);

		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		System.out.println("ItemMatExcelDownload 7. >>>>>>>>>> " + types);

		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("ItemMatExcelDownload temp2. >>>>>>>>>> " + temp2);
		resultObject.put("title", temp );

		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
	
	/**
	 * 품목관리(공구) // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/item/tool/ExcelDownload.do")
	public ModelAndView ItemToolExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {


		System.out.println("ItemToolExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		List<?> resultList = ItemService.selectItemExcelList(params);

		String headers = "";
		String columns = "";
		String types = "";

		headers += "순번;";
		headers += "대분류명;";
		headers += "중분류명;";
		headers += "소분류명;";
		headers += "품명;";
		headers += "규격;";
		headers += "단위;";
		headers += "유형;";
		headers += "거래처;";
		headers += "수입검사유무;";
		
		headers += "재고관리유무;";
		headers += "적정재고;";
		headers += "단가;";
		System.out.println("ItemToolExcelDownload 1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "BIGNAME;";
		columns += "MIDDLENAME;";
		columns += "SMALLNAME;";
		columns += "ITEMNAME;";
		columns += "ITEMSTANDARD;";
		columns += "UOMNAME;";
		columns += "ITEMTYPENAME;";
		columns += "CUSTOMERNAME;";
		columns += "ORDERINSPECTIONYN;";
		
		columns += "INVENTORYMANAGEYN;";
		columns += "SAFETYINVENTORY;";
		columns += "UNITPRICEA;";
		System.out.println("ItemToolExcelDownload 2. >>>>>>>>>> " + columns);

		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		
		types += "S;";
		types += "S;";
		types += "S;";
		System.out.println("ItemToolExcelDownload 7. >>>>>>>>>> " + types);

		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("ItemToolExcelDownload temp2. >>>>>>>>>> " + temp2);
		resultObject.put("title", temp );

		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
}