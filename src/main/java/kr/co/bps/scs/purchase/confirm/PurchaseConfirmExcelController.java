package kr.co.bps.scs.purchase.confirm;

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
 * @ClassName : PurchaseConfirmExcelController.java
 * @Description : PurchaseConfirm Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsHwang
 * @since 2018. 05.
 * @version 1.0
 * @see 매입확정
 * 
 */
@Controller
public class PurchaseConfirmExcelController extends BaseController {

	@Autowired
	private PurchaseConfirmService purchaseConfirmService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 매입확정 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/purchase/confirm/ExcelDownload.do")
	public ModelAndView confirmPurchaseExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("confirmPurchaseExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		try {
			String pofrom = StringUtil.nullConvert(params.get("REQFROM"));

			if (pofrom.isEmpty()) {
				count++;
			}

			String poto = StringUtil.nullConvert(params.get("REQTO"));

			if (poto.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<?> resultList = purchaseConfirmService.selectPurchaseConfirmList(params);

		String headers = "";
		String columns = "";
		String types = "";

		headers += "순번;";
		headers += "확정여부;";
		headers += "확정일자;";
		headers += "확정수량;";
		headers += "입하일;";
		headers += "품명;";
		headers += "입하수량;";
		headers += "단가;";
		headers += "공급가액;";
		headers += "부가세;";
		headers += "합계;";
		headers += "공급사;";
		headers += "기확정수량;";
		headers += "입하번호;";
		headers += "입하순번;";
		headers += "단위;";
		headers += "발주번호;";
		headers += "발주순번;";
		headers += "발주수량;";
		headers += "업체LOT번호;";
		headers += "보관위치;";
		headers += "검사일;";
		headers += "검사수량;";
		headers += "입고잔량;";
		headers += "비고;";

		System.out.println("confirmPurchaseExcelDownload 1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "CONFIRMYNNAME;";
		columns += "CONFIRMDATE;";
		columns += "CONFIRMQTY;";
		columns += "TRANSDATE;";
		columns += "ITEMNAME;";
		columns += "TRANSQTY;";
		columns += "UNITPRICE;";
		columns += "SUPPLYPRICE;";
		columns += "ADDITIONALTAX;";
		columns += "TOTAL;";
		columns += "CUSTOMERNAME;";
		columns += "TOTALCONFIRMQTY;";
		columns += "TRANSNO;";
		columns += "TRANSSEQ;";
		columns += "UOMNAME;";
		columns += "PONO;";
		columns += "POSEQ;";
		columns += "POQTY;";
		columns += "CUSTOMERLOT;";
		columns += "WAREHOUSINGNAME;";
		columns += "INSPDATE;";
		columns += "INSPQTY;";
		columns += "DUEQTY;";
		columns += "REMARKS;";
		System.out.println("confirmPurchaseExcelDownload 2. >>>>>>>>>> " + columns);

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
		System.out.println("confirmPurchaseExcelDownload 7. >>>>>>>>>> " + types);

		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("TransDetailStatusExcelDownload temp2. >>>>>>>>>> " + temp2);
		resultObject.put("title", temp );

		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
}