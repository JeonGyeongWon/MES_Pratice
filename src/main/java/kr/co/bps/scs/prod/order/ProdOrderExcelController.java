package kr.co.bps.scs.prod.order;

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
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : ProdOrderExcelController.java
 * @Description : ProdOrder Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 09.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 기간별 이력관리
 * 
 */
@Controller
public class ProdOrderExcelController extends BaseController {

	@Autowired
	private ProdOrderService prodOrderService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 기간별 이력관리 / 작업일보 관리 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/order/ExcelDownload.do")
	public ModelAndView prodOrderExcelDownload(@RequestParam HashMap<String, Object> params,
			@RequestParam Map requestMap) throws Exception {

		System.out.println("prodOrderExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if ( gubun.equals("WORKHISTORY") ) {
			// 기간별 이력관리 엑셀 다운로드

			List<?> resultList = prodOrderService.selectWorkHistoryList(params);

			headers += "순번;";
			headers += "검사구분;";
			headers += "검사일자;";
			headers += "검사시작시간;";
			headers += "검사종료시간;";
			headers += "품번;";
			headers += "품명;";
			headers += "도번;";
			headers += "설비;";
			headers += "공정명;";
//			headers += "작업자;";
			headers += "판정;";
			headers += "검사자;";
			headers += "검사항목;";
			headers += "검사내용;";
			headers += "검사주기;";
			headers += "기준;";
			headers += "하한;";
			headers += "상한;";
			headers += "X1;";
			headers += "X2;";
			headers += "X3;";
			headers += "X4;";
			headers += "X5;";
			headers += "X6;";
			headers += "X7;";
			headers += "X8;";
			headers += "X9;";
			headers += "X10;";
			headers += "X11;";
			headers += "X12;";
			headers += "X13;";
			headers += "X14;";
			headers += "X15;";
			headers += "X16;";
			headers += "X17;";
			headers += "X18;";
			headers += "X19;";
			headers += "X20;";
			headers += "X21;";
			headers += "X22;";
			headers += "X23;";
			headers += "X24;";
			headers += "X25;";
			headers += "X26;";
			headers += "X27;";
			headers += "X28;";
			headers += "X29;";
			headers += "X30;";
			headers += "X31;";
			headers += "X32;";
			headers += "X33;";
			headers += "X34;";
			headers += "X35;";
			headers += "X36;";
			headers += "X37;";
			headers += "X38;";
			headers += "X39;";
			headers += "X40;";
			headers += "X41;";
			headers += "X42;";
			headers += "X43;";
			headers += "X44;";
			headers += "X45;";
			headers += "X46;";
			headers += "X47;";
			headers += "X48;";
			headers += "X49;";
			headers += "X50;";	
			headers += "결과;";
			
			System.out.println("prodOrderExcelDownload 1-1. >>>>>>>>>> " + headers);
			
			columns += "RN;";
			columns += "CHECKBIGNAME;";
			columns += "CHECKDATE;";
			columns += "CHECKSTARTTIME;";
			columns += "CHECKTIME;";
			columns += "ORDERNAME;";
			columns += "ITEMNAME;";
			columns += "DRAWINGNO;";
			columns += "EQUIPMENTNAME;";
			columns += "ROUTINGNAME;";
//			columns += "EMPLOYEENAME;";
			columns += "TOTALRESULT;";
			columns += "KRNAME;";
			columns += "CHECKSMALLNAME;";
			columns += "CHECKSTANDARD;";
			columns += "CHECKCYCLENAME;";
			columns += "STANDARDVALUE;";
			columns += "MINVALUE;";
			columns += "MAXVALUE;";
			columns += "CHECK1;";
			columns += "CHECK2;";
			columns += "CHECK3;";
			columns += "CHECK4;";
			columns += "CHECK5;";
			columns += "CHECK6;";
			columns += "CHECK7;";
			columns += "CHECK8;";
			columns += "CHECK9;";
			columns += "CHECK10;";;
			columns += "CHECK11;";
			columns += "CHECK12;";
			columns += "CHECK13;";
			columns += "CHECK14;";
			columns += "CHECK15;";
			columns += "CHECK16;";
			columns += "CHECK17;";
			columns += "CHECK18;";
			columns += "CHECK19;";
			columns += "CHECK20;";;
			columns += "CHECK21;";
			columns += "CHECK22;";
			columns += "CHECK23;";
			columns += "CHECK24;";
			columns += "CHECK25;";
			columns += "CHECK26;";
			columns += "CHECK27;";
			columns += "CHECK28;";
			columns += "CHECK29;";
			columns += "CHECK30;";;
			columns += "CHECK31;";
			columns += "CHECK32;";
			columns += "CHECK33;";
			columns += "CHECK34;";
			columns += "CHECK35;";
			columns += "CHECK36;";
			columns += "CHECK37;";
			columns += "CHECK38;";
			columns += "CHECK39;";
			columns += "CHECK40;";;
			columns += "CHECK41;";
			columns += "CHECK42;";
			columns += "CHECK43;";
			columns += "CHECK44;";
			columns += "CHECK45;";
			columns += "CHECK46;";
			columns += "CHECK47;";
			columns += "CHECK48;";
			columns += "CHECK49;";
			columns += "CHECK50;";
			columns += "CHECKRESULT;";
			System.out.println("prodOrderExcelDownload 1-2. >>>>>>>>>> " + columns);

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
//			types += "S;";
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
			System.out.println("prodOrderExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("prodOrderExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		}

		mav.addAllObjects(resultObject);

		return mav;
	}
}