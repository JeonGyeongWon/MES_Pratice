package kr.co.bps.scs.cost.std;

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
 * @ClassName : CostStdExcelController.java
 * @Description : CostStd Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 02.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 거래처별 매출집계
 * 
 */
@Controller
public class CostStdExcelController extends BaseController {

	@Autowired
	private CostStdService costStdService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 매입현황 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/cost/std/CostStdPoListExcelDownload.do")
	public ModelAndView CostStdPoListExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("CostStdPoListExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		String headers = "";
		String columns = "";
		String types = "";
		
			// 엑셀 다운로드
		List<?> resultList = costStdService.selectCostStdPoList(params);

		headers += "순번;";
		headers += "사업자번호;";
		headers += "거래처명;";
		headers += "거래처분류;";
		headers += "수량(전일입고누계);";
		headers += "금액(전일입고누계);";
		headers += "수량(당일입고실적);";
		headers += "금액(당일입고실적);";
		headers += "수량(당월입고누계);";
		headers += "공급가액(당월입고누계);";
		headers += "부가세(당월입고누계);";
		headers += "합계금액(당월입고누계);";
		System.out.println("costStdExcelDownload 1-1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "LICENSENO;";
		columns += "CUSTOMERNAME;";
		columns += "CUSTOMERTYPENAME;";
		columns += "PREQTY;";
		columns += "PRETOTAL;";
		columns += "POSTQTY;";
		columns += "POSTTOTAL;";
		columns += "POSTMONTHQTY;";
		columns += "POSTMONTHSUPPLY;";
		columns += "POSTMONTHADDTAX;";
		columns += "POSTMONTHTOTAL;";
		System.out.println("costStdExcelDownload 1-2. >>>>>>>>>> " + columns);

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
		System.out.println("costStdExcelDownload 1-3. >>>>>>>>>> " + types);

		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("costStdExcelDownload temp2. >>>>>>>>>> " + temp2);

		resultObject.put("title", temp2);
		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);
		
		
		mav.addAllObjects(resultObject);

		return mav;
	}
	
	/**
	 * 거래처별 매출집계 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/cost/std/ExcelDownload.do")
	public ModelAndView costStdExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("costStdExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("SALESTOTAL")) {
			// 엑셀 다운로드
			List<?> resultList = costStdService.selectSalesTotalList(params);

			headers += "NO;";
			headers += "거래처;";
			headers += "1월;";
			headers += "2월;";
			headers += "3월;";
			headers += "4월;";
			headers += "5월;";
			headers += "6월;";
			headers += "7월;";
			headers += "8월;";

			headers += "9월;";
			headers += "10월;";
			headers += "11월;";
			headers += "12월;";
			headers += "합계액;";
			System.out.println("costStdExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "CUSTOMERNAME;";
			columns += "MONTH01;";
			columns += "MONTH02;";
			columns += "MONTH03;";
			columns += "MONTH04;";
			columns += "MONTH05;";
			columns += "MONTH06;";
			columns += "MONTH07;";
			columns += "MONTH08;";

			columns += "MONTH09;";
			columns += "MONTH10;";
			columns += "MONTH11;";
			columns += "MONTH12;";
			columns += "TOTALMONTH;";
			System.out.println("costStdExcelDownload 1-2. >>>>>>>>>> " + columns);

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
			System.out.println("costStdExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("costStdExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
			
			//매입현황 회계 I/F
		} else if(gubun.equals("POIF")){
			List<?> resultList = costStdService.selectCostStdPoIFList(params);

			headers += "순번;";
			headers += "증빙구분;";
			headers += "회사코드;";
			headers += "거래일자;";
			headers += "거래순번;";
			headers += "분개라인순번;";
			headers += "회계단위;";
			headers += "차대구분;";
			headers += "계정코드;";
			headers += "거래처사업자번호;";
			
			headers += "금액;";
			headers += "적요;";
			headers += "사용부서코드;";
			headers += "공급가액;";
			headers += "세무구분;";
			headers += "사유구분;";
			headers += "신고기준일;";
			headers += "전자세금계산서여부;";
			headers += "관리번호;";
			headers += "환율;";
			
			headers += "환종;";
			headers += "외화금액;";
			
			System.out.println("costStdExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "ATTRCD;";
			columns += "COCD;";
			columns += "INDT;";
			columns += "INSQ;";
			columns += "LNSQ;";
			columns += "DIVCD;";
			columns += "DRCRFG;";
			columns += "ACCTCD;";
			columns += "REGNB;";
			
			columns += "ACCTAM;";
			columns += "RMKDC;";
			columns += "CTDEPT;";
			columns += "CTAM;";
			columns += "CTDEAL;";
			columns += "NONSUBTY;";
			columns += "FRDT;";
			columns += "JEONJAYN;";
			columns += "CTNB;";
			columns += "CTQT;";
			
			columns += "DUMMY1;";
			columns += "DUMMY2;";
			System.out.println("costStdExcelDownload 1-2. >>>>>>>>>> " + columns);

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
			
			System.out.println("costStdExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("costStdExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
			
			//매출현황 회계 I/F
		} else if(gubun.equals("SALESIF")){
			List<?> resultList = costStdService.selectCostStdSalesIFList(params);

			headers += "순번;";
			headers += "증빙구분;";
			headers += "회사코드;";
			headers += "거래일자;";
			headers += "거래순번;";
			headers += "분개라인순번;";
			headers += "회계단위;";
			headers += "차대구분;";
			headers += "계정코드;";
			headers += "거래처사업자번호;";
			
			headers += "금액;";
			headers += "적요;";
			headers += "사용부서코드;";
			headers += "공급가액;";
			headers += "세무구분;";
			headers += "사유구분;";
			headers += "신고기준일;";
			headers += "전자세금계산서여부;";
			headers += "관리번호;";
			headers += "환율;";

			headers += "환종;";
			headers += "외화금액;";
			
			System.out.println("costStdExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "ATTRCD;";
			columns += "COCD;";
			columns += "INDT;";
			columns += "INSQ;";
			columns += "LNSQ;";
			columns += "DIVCD;";
			columns += "DRCRFG;";
			columns += "ACCTCD;";
			columns += "REGNB;";
			
			columns += "ACCTAM;";
			columns += "RMKDC;";
			columns += "CTDEPT;";
			columns += "CTAM;";
			columns += "CTDEAL;";
			columns += "NONSUBTY;";
			columns += "FRDT;";
			columns += "JEONJAYN;";
			columns += "CTNB;";
			columns += "CTQT;";
			
			columns += "DUMMY1;";
			columns += "DUMMY2;";
			System.out.println("costStdExcelDownload 1-2. >>>>>>>>>> " + columns);

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
			System.out.println("costStdExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("costStdExcelDownload temp2. >>>>>>>>>> " + temp2);

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
	 * 거래처별 매입집계 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/cost/std/Pototal/ExcelDownload.do")
	public ModelAndView costStdPototalExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("costStdPototalExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("POTOTAL")) {
			// 엑셀 다운로드
			List<?> resultList = costStdService.selectCostStdPoTotalList(params);

			headers += "NO;";
			headers += "거래처;";
			headers += "사업자번호;";
			headers += "1월;";
			headers += "2월;";
			headers += "3월;";
			headers += "4월;";
			headers += "5월;";
			headers += "6월;";
			headers += "7월;";
			headers += "8월;";
			headers += "9월;";
			headers += "10월;";
			headers += "11월;";
			headers += "12월;";
			headers += "합계액;";
			System.out.println("costStdExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "CUSTOMERNAME;";
			columns += "LICENSENO;";
			columns += "MONTH01;";
			columns += "MONTH02;";
			columns += "MONTH03;";
			columns += "MONTH04;";
			columns += "MONTH05;";
			columns += "MONTH06;";
			columns += "MONTH07;";
			columns += "MONTH08;";
			columns += "MONTH09;";
			columns += "MONTH10;";
			columns += "MONTH11;";
			columns += "MONTH12;";
			columns += "TOTALMONTH;";
			System.out.println("costStdExcelDownload 1-2. >>>>>>>>>> " + columns);

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
			System.out.println("costStdExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("costStdExcelDownload temp2. >>>>>>>>>> " + temp2);

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