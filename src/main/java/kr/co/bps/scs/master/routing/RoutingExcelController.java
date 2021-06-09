package kr.co.bps.scs.master.routing;

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
 * @ClassName : RoutingExcelController.java
 * @Description : Routing Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 12.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. ROUTING 등록
 * 
 */
@Controller
public class RoutingExcelController extends BaseController {

	@Autowired
	private RoutingService routingService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * ROUTING 등록 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/routing/ExcelDownload.do")
	public ModelAndView routingExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("routingExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("ROUTING")) {
			// ROUTING 등록 엑셀 다운로드
	     	try {
	     		String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
	     		if ( itemcode.isEmpty() ) {
	     			count++;
	     		}
	     	} catch ( Exception e ) {
	     		e.printStackTrace();
	     	}

			List<?> resultList = routingService.RoutingRegisterList(params);
			String ordername = StringUtil.nullConvert(params.get("ORDERNAME"));

			if ( ordername.isEmpty() ) {
				headers += "순번;";
				headers += "품번;";
				headers += "품명;";
			}
			headers += "순서;";
			headers += "공정순번;";
			headers += "공정명;";
			headers += "로딩시간;";
			headers += "CT(초);";
			headers += "CAVITY;";
			headers += "시간당생산량;";
			headers += "가공비(원);";
			headers += "외주구분;";
			headers += "유효시작일자;";
			headers += "유효종료일자;";
			System.out.println("routingExcelDownload 1-1. >>>>>>>>>> " + headers);

			if ( ordername.isEmpty() ) {
				columns += "RN;";
				columns += "ORDERNAME;";
				columns += "ITEMNAME;";
			}
			columns += "SORTORDER;";
			columns += "ROUTINGOP;";
			columns += "ROUTINGNAME;";
			columns += "SETUPTIME;";
			columns += "CYCLETIME;";
			columns += "CAVITY;";
			columns += "PRODTIME;";
			columns += "CONVERSIONCOST;";
			columns += "OUTSIDEORDERGUBUN;";
			columns += "EFFECTIVESTARTDATE;";
			columns += "EFFECTIVEENDDATE;";
			System.out.println("routingExcelDownload 1-2. >>>>>>>>>> " + columns);

			if ( ordername.isEmpty() ) {
				types += "S;";
				types += "S;";
				types += "S;";
			}
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
			System.out.println("routingExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("routingExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2 + ((ordername.isEmpty()) ? "" : "_" + ordername));
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		}

		mav.addAllObjects(resultObject);

		return mav;
	}
}