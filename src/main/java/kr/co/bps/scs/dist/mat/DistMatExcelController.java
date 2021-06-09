package kr.co.bps.scs.dist.mat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import kr.co.bps.scs.base.controller.BaseController;

/**
 * @ClassName : DistMatExcelController.java
 * @Description : DistMat Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 08.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가)
 * 
 */
@Controller
public class DistMatExcelController extends BaseController {

	@Autowired
	private DistMatService distMatService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;
	
	/**
	 * 발주대비 입고현황조회 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/mat/MatOrderReceiveList/ExcelDownload.do")
	public ModelAndView distmatMatOrderReceiveListExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("distmatMatOrderReceiveListExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		List<?> resultList = distMatService.MatOrderReceiveList(params);

		String headers = "";
		String columns = "";
		String types = "";

		headers += "순번;";
		headers += "발주번호;";
		headers += "발주순번;";
		headers += "공급사;";
		headers += "품번;";
		headers += "품명;";
		headers += "발주수량;";
		headers += "입고수량;";
		headers += "발주일;";
		headers += "납기일;";
		headers += "공급가액;";
		headers += "부가세;";
		headers += "입고금액;";

		System.out.println("distmatMatOrderReceiveListExcelDownload 1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "PONO;";
		columns += "POSEQ;";
		columns += "CUSTOMERNAME;";
		columns += "ORDERNAME;";
		columns += "ITEMNAME;";
		columns += "ORDERQTY;";
		columns += "TRANSQTY;";
		columns += "PODATE;";
		columns += "DUEDATE;";
		columns += "SUPPLYPRICE;";
		columns += "ADDITIONALTAX;";
		columns += "TOTAL;";
		
		System.out.println("distmatMatOrderReceiveListExcelDownload 2. >>>>>>>>>> " + columns);

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
		System.out.println("distmatMatOrderReceiveListExcelDownload 7. >>>>>>>>>> " + types);

		resultObject.put("title", "발주대비입고현황조회");
		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
}