package kr.co.bps.scs.order.trans;

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
 * @ClassName : TransDetailExcelController.java
 * @Description : TransDetail Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsHwang
 * @since 2017. 10.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 거래명세서관리
 * 
 */
@Controller
public class TransDetailExcelController extends BaseController {

	@Autowired
	private TransDetailService TransDetailService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 거래명세서 발행현황 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/trans/TransDetailStatusExcelDownload.do")
	public ModelAndView TransDetailStatusExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {
		System.out.println("TransDetailStatusExcelDownload params >>>>>>>>> " + params);

		ModelAndView mav = new ModelAndView("excelDownloadXlsx");

		Map resultObject = new HashMap();
		int count = 0;
		String headers = "";
		String columns = "";
		String types = "";

		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<?> resultList = TransDetailService.selectTransDetailStatusList(params);

		headers += "순번;";
//		headers += "거래명세서순번;";
		headers += "마감일자;";
		headers += "발행일자;";
		headers += "거래처;";
		headers += "담당자;";
		
		
		headers += "품명;";
		headers += "기종;";
		headers += "타입;";
		headers += "품번;";
	
		
//		headers += "재질;";
		headers += "단위;";
		headers += "출하수량;";
		headers += "명세서수량;";
//		headers += "단위중량;";
//		headers += "중량;";
		headers += "단가;";
		headers += "공급가액;";
		headers += "부가세;";
		headers += "합계;";
		
		headers += "비고;";
		headers += "출하번호;";
		headers += "거래명세서번호;";
//		headers += "출하순번;";
		System.out.println("TransDetailStatusExcelDownload 1-1. >>>>>>>>>> " + headers);

		columns += "RN;";
//		columns += "TRADESEQ;";
		columns += "ENDDATE;";
		columns += "TRADEDATE;";
		columns += "CUSTOMERNAME;";
		columns += "KRNAME;";

		
		columns += "ITEMNAME;";
		columns += "CARTYPENAME;";
		columns += "ITEMSTANDARDDETAIL;";
		columns += "ORDERNAME;";
		

//		columns += "MATERIALTYPE;";
		columns += "UOMNAME;";
		columns += "SHIPQTY;";
		columns += "TRANSACTIONQTY;";
//		columns += "WEIGHT;";
//		columns += "SUMWEIGHT;";
		columns += "UNITPRICE;";
		columns += "SUPPLYPRICE;";
		columns += "ADDITIONALTAX;";
		columns += "TOTAL;";
		
		columns += "REMARKS;";
		columns += "TRADENO;";
		columns += "SHIPNO;";
//		columns += "SHIPSEQ;";
		System.out.println("TransDetailStatusExcelDownload 1-2. >>>>>>>>>> " + columns);

		types += "S;";
//		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
//		types += "S;";

//		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
//		types += "S;";
//		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		
		types += "S;";
		types += "S;";
		types += "S;";
//		types += "S;";
		System.out.println("TransDetailStatusExcelDownload 1-3. >>>>>>>>>> " + types);

		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("TransDetailStatusExcelDownload temp2. >>>>>>>>>> " + temp2);

		resultObject.put("title", temp2);
		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
}
