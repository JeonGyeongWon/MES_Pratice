package kr.co.bps.scs.prod.outorder;

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
 * @ClassName : ProdOutOrderExcelController.java
 * @Description : ProdOutOrder Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 09.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 외주발주
 * 
 */
@Controller
public class ProdOutOrderExcelController extends BaseController {

	@Autowired
	private ProdOutOrderService prodOutOrderService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 외주발주 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/outorder/ExcelDownload.do")
	public ModelAndView prodOutOrderExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("prodOutOrderExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("OUTORDER")) {
			// 외주발주 엑셀 다운로드
			List<?> resultList = prodOutOrderService.selectProdOutOrderDetailExcelList(params);

			headers += "순번;";
			headers += "발주번호;";
			headers += "발주순번;";
			headers += "발주일;";
			headers += "공급사;";
			headers += "발주상태;";
			headers += "품번;";
			headers += "품명;";
			headers += "기종;";
			headers += "타입;";
			
			headers += "단위;";
			headers += "작업지시번호;";
			headers += "공정;";
			headers += "발주수량;";
			headers += "기입고수량;";
			headers += "단가;";
			headers += "공급가액;";
			headers += "부가세;";
			headers += "합계;";
			headers += "납기일;";
			
			headers += "비고;";
			System.out.println("prodOutOrderExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "OUTPONO;";
			columns += "OUTPOSEQ;";
			columns += "OUTPODATE;";
			columns += "CUSTOMERNAME;";
			columns += "OUTPOSTATUSNAME;";
			columns += "ORDERNAME;";
			columns += "ITEMNAME;";
			columns += "MODELNAME;";
			columns += "ITEMSTANDARDDETAIL;";
			
			columns += "UOMNAME;";
			columns += "WORKORDERID;";
			columns += "ROUTINGNAME;";
			columns += "ORDERQTY;";
			columns += "TRANSQTY;";
			columns += "UNITPRICE;";
			columns += "SUPPLYPRICE;";
			columns += "ADDITIONALTAX;";
			columns += "TOTAL;";
			columns += "DUEDATE;";
			
			columns += "REMARKS;";
			System.out.println("prodOutOrderExcelDownload 1-2. >>>>>>>>>> " + columns);

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
			
			types += "S;";
			System.out.println("prodOutOrderExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("prodOutOrderExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		}

		mav.addAllObjects(resultObject);

		return mav;
	}
	
	
	/**
	 * 외주발주 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/outorder/OutOrderInOutList/ExcelDown.do")
	public ModelAndView prodInOutListExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("prodInOutListExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		String headers = "";
		String columns = "";
		String types = "";

		List<?> resultList = prodOutOrderService.selectOutOrderInOutListExcelData(params);

		headers += "순번;";
		headers += "반출일자;";
		headers += "품번;";
		headers += "품명;";
		headers += "기종;";
		headers += "타입;";
		headers += "유형;";
		headers += "반출수량;";
		headers += "반입일자;";
		headers += "반입수량;";
		System.out.println("prodInOutListExcelDownload 1-1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "OUTDATE;";
		columns += "ORDERNAME;";
		columns += "ITEMNAME;";
		columns += "MODELNAME;";
		columns += "ITEMSTANDARDDETAIL;";
		columns += "OUTTYPENAME;";
		columns += "OUTQTY;";
		columns += "INDATE;";
		columns += "INQTY;";
		System.out.println("prodInOutListExcelDownload 1-2. >>>>>>>>>> " + columns);

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
		System.out.println("prodInOutListExcelDownload 1-3. >>>>>>>>>> " + types);

		String title = "반입반출현황";
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("prodInOutListExcelDownload temp2. >>>>>>>>>> " + temp2);

		resultObject.put("title", temp2);
		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}

}