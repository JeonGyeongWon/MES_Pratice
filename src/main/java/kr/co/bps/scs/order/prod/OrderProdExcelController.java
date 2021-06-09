package kr.co.bps.scs.order.prod;

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
 * @ClassName : OrderProdExcelController.java
 * @Description : OrderProd Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsHwang
 * @since 2018. 02.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 제품수불현황
 * 
 */
@Controller
public class OrderProdExcelController extends BaseController {

	@Autowired
	private OrderProdService orderProdService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 제품수불현황 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/prod/ExcelDownload.do")
	public ModelAndView orderProdExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("orderProdExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadView");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("INVENTORY")) {
			// 제품재고조회 엑셀 다운로드
			try {
				String trxdate = StringUtil.nullConvert(params.get("TRXDATE"));
				if (trxdate.isEmpty()) {
					//					count++;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = orderProdService.selectProdInventoryList(params);

			headers += "순번;";
			
			headers += "품명;";
			headers += "기종;";
			headers += "타입;";
			headers += "품번;";
//			headers += "재질;";
			headers += "이월수량;";
			//			headers += "이월(금액);";

			headers += "입고수량;";
			//			headers += "입고(금액);";
			headers += "출고수량;";
			//			headers += "출고(금액);";
			headers += "재고수량;";
			//headers += "재고(금액);";

			System.out.println("orderProdExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			
			columns += "ITEMNAME;";
			columns += "MODELNAME;";
			columns += "ITEMSTANDARDDETAIL;";
			columns += "ORDERNAME;";
//			columns += "MATERIALTYPE;";
			columns += "BACKQTY;";
			//			columns += "PREINVENTORYPRICE;";

			columns += "INQTY;";
			//			columns += "TRANSPRICE;";
			columns += "OUTQTY;";
			//			columns += "RELEASEPRICE;";
			columns += "INVQTY;";
			//columns += "PRESENTINVENTORYPRICE;";
			System.out.println("orderProdExcelDownload 1-2. >>>>>>>>>> " + columns);

			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
//			types += "S;";
			types += "S;";
			//			types += "S;";

			types += "S;";
			//			types += "S;";
			types += "S;";
			//			types += "S;";
			types += "S;";
			//types += "S;";
			System.out.println("orderProdExcelDownload 1-3. >>>>>>>>>> " + types);

			resultObject.put("title", "제품수불현황");
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		}

		mav.addAllObjects(resultObject);

		return mav;
	}

}