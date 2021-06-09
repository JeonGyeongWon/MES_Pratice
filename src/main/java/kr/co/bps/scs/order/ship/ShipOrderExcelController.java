package kr.co.bps.scs.order.ship;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.file.ExcelFileService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : ShipOrderExcelController.java
 * @Description : ShipOrder Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 01.
 * @version 1.0
 * @see 출력물 (엑셀 업로드 기능 추가) - 1. 출하등록관리
 * 
 */
@Controller
public class ShipOrderExcelController extends BaseController {

	@Autowired
	private ShipOrderService shipOrderService;

	@Autowired
	private ExcelFileService excelFileService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 출하등록 업로드 // 엑셀데이터 가져오기
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ExcelUpload.do")
	public String OrderShipExcelUpload(final MultipartHttpServletRequest multiRequest) throws Exception {

		System.out.println("OrderShipExcelUpload Start. >>>>>>>>>> " + multiRequest);
		FlashMap fm = RequestContextUtils.getOutputFlashMap(request);

		final Map<String, MultipartFile> filesmap = multiRequest.getFileMap();
		List<Object> sheet = new ArrayList<Object>();
		if (!filesmap.isEmpty()) {
			sheet = excelFileService.getExcelData(filesmap, 0, 0, 11);
			if (!sheet.isEmpty()) {
				fm.putAll(shipOrderService.uploadShipRegistList(sheet, "excelupload"));
			}
		}
		fm.put("isExcelUploaded", true);

		return "redirect:/order/ship/ShipRegistManageList.do";
	}

	/**
	 * 출하현황 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ExcelDownload.do")
	public ModelAndView orderShipExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("orderShipExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		try {
			String datefrom = StringUtil.nullConvert(params.get("DATEFROM"));

			if (datefrom.isEmpty()) {
				count++;
			}

			String dateto = StringUtil.nullConvert(params.get("DATETO"));

			if (dateto.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<?> resultList = shipOrderService.selectShipStatusList(params);

		String headers = "";
		String columns = "";
		String types = "";

		headers += "순번;";
		headers += "출하번호;";
		headers += "출하순번;";
		headers += "출하일자;";
		headers += "검사여부;";
		headers += "매출구분;";
		headers += "거래처;";
		
		
		headers += "품명;";
		headers += "기종;";
		headers += "타입;";
		headers += "품번;";
		
		headers += "단위;";
		headers += "출하수량;";
		headers += "공급가;";
		headers += "부가세;";
		headers += "합계;";
		headers += "용차구분;";
		headers += "세액구분;";
		headers += "수주번호;";
		headers += "수주내역순번;";
		headers += "변경수주번호;";
		headers += "변경수주순번;";
		headers += "변경소재LOT;";
		headers += "거래명세서생성여부;";
		headers += "비고;";

		System.out.println("orderShipExcelDownload 1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "SHIPNO;";
		columns += "SHIPSEQ;";
		columns += "SHIPDATE;";
		columns += "SHIPMENTINSPECTIONYN;";
		columns += "SHIPGUBUNNAME;";
		columns += "CUSTOMERNAME;";
		
		
		columns += "ITEMNAME;";
		columns += "CARTYPENAME;";
		columns += "ITEMSTANDARDDETAIL;";
		columns += "ORDERNAME;";
		
		columns += "UOMNAME;";
		columns += "SHIPQTY;";
		columns += "SUPPLYPRICE;";
		columns += "ADDITIONALTAX;";
		columns += "TOTAL;";
		columns += "DELIVERYVANNAME;";
		columns += "TAXDIVNAME;";
		columns += "SONO;";
		columns += "SOSEQ;";
		columns += "SONOPOST;";
		columns += "SOSEQPOST;";
		columns += "LOTNOPOST;";
		columns += "TRADEYNNAME;";
		columns += "REMARKS;";
		System.out.println("orderShipExcelDownload 2. >>>>>>>>>> " + columns);

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
		System.out.println("orderShipExcelDownload 7. >>>>>>>>>> " + types);

		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("orderShipExcelDownload temp2. >>>>>>>>>> " + temp2);
		resultObject.put("title", temp );

		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
}