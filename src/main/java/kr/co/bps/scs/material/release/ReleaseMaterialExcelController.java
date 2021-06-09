package kr.co.bps.scs.material.release;

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
 * @ClassName : ReleaseMaterialExcelController.java
 * @Description : ReleaseMaterial Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 08.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 자재수불조회 2. 공구수불조회
 * 
 */
@Controller
public class ReleaseMaterialExcelController extends BaseController {

	@Autowired
	private ReleaseMaterialService releasematerialService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 자재수불조회 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/material/release/ExcelDownload.do")
	public ModelAndView releaseMaterialExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("releaseMaterialExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("INVENTORY")) {
			// 자재수불조회 엑셀 다운로드
			try {
				String yyyymm = StringUtil.nullConvert(params.get("YYYYMM"));
				if (yyyymm.isEmpty()) {
					//					count++;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = releasematerialService.selectInventoryReceiptList(params);

			headers += "순번;";
			headers += "유형;";
			headers += "품명;";
			headers += "품번;";
			headers += "규격;";
			headers += "재질;";
			headers += "공급사;";
			headers += "적정재고수량;";
			headers += "이월(수량);";
			//			headers += "이월(금액);";
			headers += "입고(수량);";

			//			headers += "입고(금액);";
			headers += "출고(수량);";
			//			headers += "출고(금액);";
			headers += "재고(수량);";
			//			headers += "재고(금액);";

			System.out.println("releaseMaterialExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "ITEMTYPENAME;";
			columns += "ITEMNAME;";
			columns += "ORDERNAME;";
			columns += "ITEMSTANDARD;";
			columns += "MATERIALTYPE;";
			columns += "CUSTOMERNAME;";
			columns += "INVSAFEQTY;";
			columns += "PREINVENTORYQTY;";
			//			columns += "PREINVENTORYPRICE;";
			columns += "TRANSQTY;";

			//			columns += "TRANSPRICE;";
			columns += "RELEASEQTY;";
			//			columns += "RELEASEPRICE;";
			columns += "PRESENTINVENTORYQTY;";
			//			columns += "PRESENTINVENTORYPRICE;";
			System.out.println("releaseMaterialExcelDownload 1-2. >>>>>>>>>> " + columns);

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

			//			types += "S;";
			types += "S;";
			//			types += "S;";
			types += "S;";
			//			types += "S;";
			System.out.println("releaseMaterialExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("releaseMaterialExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		} else if (gubun.equals("SUBCONINVENTORY")) {
			// 자재수불조회 도급/사급 엑셀 다운로드
			try {
				String yyyymm = StringUtil.nullConvert(params.get("YYYYMM"));
				if (yyyymm.isEmpty()) {
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = releasematerialService.selectSubConInventoryReceiptList(params);

			headers += "순번;";
			headers += "구분;";
			headers += "품명;";
			headers += "품번;";
			headers += "규격;";
			headers += "재질;";
			headers += "공급사;";
			//			headers += "적정재고수량;";
			headers += "이월(수량);";
			//			headers += "이월(금액);";
			headers += "입고(수량);";

			//			headers += "입고(금액);";
			headers += "출고(수량);";
			//			headers += "출고(금액);";
			headers += "재고(수량);";
			//			headers += "재고(금액);";

			System.out.println("releaseMaterialExcelDownload 2-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "PRODSMALLNAME;";
			columns += "ITEMNAME;";
			columns += "ORDERNAME;";
			columns += "ITEMSTANDARD;";
			columns += "MATERIALTYPE;";
			columns += "CUSTOMERNAME;";
			//			columns += "INVSAFEQTY;";
			columns += "PREINVENTORYQTY;";
			//			columns += "PREINVENTORYPRICE;";
			columns += "TRANSQTY;";

			//			columns += "TRANSPRICE;";
			columns += "RELEASEQTY;";
			//			columns += "RELEASEPRICE;";
			columns += "PRESENTINVENTORYQTY;";
			//			columns += "PRESENTINVENTORYPRICE;";
			System.out.println("releaseMaterialExcelDownload 2-2. >>>>>>>>>> " + columns);

			types += "S;";
			types += "S;";
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
			//			types += "S;";
			System.out.println("releaseMaterialExcelDownload 2-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2, temp3;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "_");
			temp2 = temp1.replaceAll("\\)", "");
			temp3 = temp1.replaceAll("\\/", "_");
			System.out.println("releaseMaterialExcelDownload temp3. >>>>>>>>>> " + temp3);

			resultObject.put("title", temp3);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		} else if (gubun.equals("TOOLINVENTORY")) {
			// 자재수불조회 엑셀 다운로드
			try {
				String yyyymm = StringUtil.nullConvert(params.get("YYYYMM"));
				if (yyyymm.isEmpty()) {
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = releasematerialService.selectToolInventoryReceiptList(params);

			headers += "순번;";
			headers += "유형;";
			headers += "품명;";
			headers += "규격;";
			headers += "공급사;";
			headers += "적정재고;";
			headers += "이월(수량);";
			//				headers += "이월(금액);";
			headers += "입고(수량);";
			//				headers += "입고(금액);";

			headers += "출고(수량);";
			//				headers += "출고(금액);";
			headers += "재고(수량);";
			//				headers += "재고(금액);";

			System.out.println("releaseMaterialExcelDownload 3-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "ITEMTYPENAME;";
			columns += "ITEMNAME;";
			columns += "ITEMSTANDARD;";
			columns += "CUSTOMERNAME;";
			columns += "SAFETYINVENTORY;";
			columns += "PREINVENTORYQTY;";
			//				columns += "PREINVENTORYPRICE;";
			columns += "TRANSQTY;";
			//				columns += "TRANSPRICE;";

			columns += "RELEASEQTY;";
			//				columns += "RELEASEPRICE;";
			columns += "PRESENTINVENTORYQTY;";
			//				columns += "PRESENTINVENTORYPRICE;";
			System.out.println("releaseMaterialExcelDownload 3-2. >>>>>>>>>> " + columns);

			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			//				types += "S;";
			types += "S;";
			//				types += "S;";

			types += "S;";
			//				types += "S;";
			types += "S;";
			//				types += "S;";
			System.out.println("releaseMaterialExcelDownload 3-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("releaseMaterialExcelDownload temp2. >>>>>>>>>> " + temp2);

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