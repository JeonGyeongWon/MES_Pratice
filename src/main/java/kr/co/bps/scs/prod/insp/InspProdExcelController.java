package kr.co.bps.scs.prod.insp;

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
 * @ClassName : InspProdExcelController.java
 * @Description : InspProd Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 06.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 부적합품 등록
 * 
 */
@Controller
public class InspProdExcelController extends BaseController {

	@Autowired
	private InspProdService inspProdService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 부적합품 등록 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/insp/ExcelDownload.do")
	public ModelAndView prodInspExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("prodInspExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("NONCONFIRM")) {
			// 부적합품 등록 엑셀 다운로드
			try {
				String orgid = StringUtil.nullConvert(params.get("ORGID"));
				if (orgid.isEmpty()) {
					//					count++;
				}

				String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
				if (companyid.isEmpty()) {
					//					count++;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = inspProdService.selectInspProdExcelList(params);

			headers += "순번;";
			headers += "일자;";
			headers += "품명;";
			headers += "기종;";
			headers += "타입;";
			headers += "공정명;";
			headers += "작업자;";
			headers += "발견자;"; //널값
			headers += "소재;";
			headers += "셋팅;";
			headers += "찍힘;";
			
			headers += "구높이;";
			headers += "두께;";
			headers += "치수;";
			headers += "등심도;";
			headers += "위치도;";
			headers += "평면도;";
			headers += "평행도;";
			headers += "기타;";
			headers += "불량구분&수량(소재);"; //널값
			headers += "불량구분&수량(가공);"; //널값
			
			headers += "불량구분&수량(기타);"; //널값
			headers += "조치내역(수리);";
			headers += "조치내역(폐기);";
			headers += "조치내역(수리대기);";
			headers += "조치내역(특채);";
			headers += "확인자;";
			headers += "비고;"; //널값
			System.out.println("prodOrderExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "CREATIONDATE;";
			columns += "ITEMNAME;";
			columns += "MODELNAME;";
			columns += "ITEMSTANDARDDETAIL;";
			columns += "ROUTINGNAME;";
			columns += "WORKEMPLOYEENAME;";
			columns += " ;";
			columns += "NCRA;";
			columns += "NCRB;";
			columns += "NCRC;";
			
			columns += "NCRD;";
			columns += "NCRE;";
			columns += "NCRF;";
			columns += "NCRG;";
			columns += "NCRH;";
			columns += "NCRI;";
			columns += "NCRJ;";
			columns += "NCRK;";
			columns += " ;";
			columns += " ;";
			
			columns += " ;";
			columns += "NCRRESULTA;";
			columns += "NCRRESULTC;";
			columns += "NCRRESULTD;";
			columns += "NCRRESULTB;";
			columns += " ;";
			columns += " ;";
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

			String ncrto = StringUtil.nullConvert(params.get("NCRTO"));
			String temp, temp1, temp2;
			temp = ncrto.substring(2, 4);
			temp2 = ncrto.substring(5, 7);
			
			resultObject.put("title", temp+"년" + temp2 + "월" + "불량유형현황");
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		}

		mav.addAllObjects(resultObject);

		return mav;
	}
}