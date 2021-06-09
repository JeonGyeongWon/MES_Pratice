package kr.co.bps.scs.prod.manage;

import java.text.SimpleDateFormat;
import java.util.Date;
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
 * @ClassName : ProdManageExcelController.java
 * @Description : ProdManage Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 08.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 생산 실적현황 - 2. 생산현황 및 CAPA - 3. 월별
 *      생산실적현황(작업자/장비별) - 4. 설비 실적현황
 * 
 */
@Controller
public class ProdManageExcelController extends BaseController {

	@Autowired
	private ProdManageService prodManageService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 생산실적현황 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ExcelDownload.do")
	public ModelAndView prodManageExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("prodManageExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("WORKTOTAL")) {
			try {
				// 1. 일자
				String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
				if (searchfrom.isEmpty()) {
					count++;
				}

				String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
				if (searchto.isEmpty()) {
					count++;
				}

//				// 2. 품번 / 품명
//				String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
//				if (itemcode.isEmpty()) {
//					count++;
//				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = prodManageService.selectWorkTotalList(params);

			headers += "순번;";
			headers += "공정그룹;";
			headers += "공정명;";
			headers += "설비명;";
			headers += "품번;";
			headers += "품명;";
			headers += "기종;";
			headers += "시작시간;";
			headers += "종료시간;";
			headers += "작업자;";
			
			headers += "목표수량;";
			headers += "실적수량;";
			headers += "달성율(%);";
			System.out.println("prodManageExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "ROUTINGGROUPNAME;";
			columns += "ROUTINGNAME;";
			columns += "EQUIPMENTNAME;";
			columns += "ORDERNAME;";
			columns += "ITEMNAME;";
			columns += "MODELNAME;";
			columns += "STARTTIME;";
			columns += "ENDTIME;";
			columns += "KRNAME;";
			
			columns += "WORKORDERQTY;";
			columns += "PRODQTY;";
			columns += "RATEQTY;";
			System.out.println("prodManageExcelDownload 1-2. >>>>>>>>>> " + columns);

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
			System.out.println("prodManageExcelDownload 1-7. >>>>>>>>>> " + types);

			resultObject.put("title", "생산_실적현황");
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		} else if (gubun.equals("PRODCAPA")) {
			String[] value_split = null;
			String[] label_split = null;
			String now_month = null, next_month = null;
			try {
				String orgid = StringUtil.nullConvert(params.get("ORGID"));
				if (orgid.isEmpty()) {
					count++;
				}

				String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
				if (companyid.isEmpty()) {
					count++;
				}

				String searchdate = StringUtil.nullConvert(params.get("SEARCHDATE"));
				if (searchdate.isEmpty()) {
					count++;
				}

				String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
				if (groupcode.isEmpty()) {
					count++;
				}

				now_month = searchdate.split("-")[2];

				Date date1, date2;
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

				date1 = df.parse(searchdate);
				date2 = df.parse(searchdate);
				date2.setMonth(date1.getMonth() + 1);
				now_month = String.format("%02d", date1.getMonth() + 1);
				System.out.println("prodManageExcelDownload now_month >>>>>>>>>>>> " + now_month);
				next_month = String.format("%02d", date2.getMonth() + 1);
				System.out.println("prodManageExcelDownload next_month >>>>>>>>>>>> " + next_month);

				// 공정그룹
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
				params.put("BIGCD", "MFG");
				params.put("MIDDLECD", "ROUTING_GROUP");
				List<?> routingList = dao.selectListByIbatis("search.smallcode.group.lov.select", params);

				if (routingList.size() > 0) {
					HashMap<String, Object> routingMap = (HashMap<String, Object>) routingList.get(0);

					String value = StringUtil.nullConvert(routingMap.get("VALUE"));
					String label = StringUtil.nullConvert(routingMap.get("LABEL"));

					value_split = value.split(",");
					label_split = label.split(",");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = prodManageService.selectProdCapaList(params);

			headers += "순번;";
			headers += "품번;";
			headers += "도번;";
			headers += "품명;";
//			headers += "기종;";
//			headers += "재질;";
			headers += "거래처;";
			headers += "소재;";

			System.out.println("prodManageExcelDownload 2-0. >>>>>>>>>> " + label_split.length);
			for (int i = 0; i < label_split.length; i++) {
				headers += label_split[i] + ";";
//				System.out.println("prodManageExcelDownload 2-0-" + i + ". >>>>>>>>>> " + label_split[i]);
			}

			headers += "완제품;";
			headers += "수주잔량;";
			headers += "과부족수량;";

			headers += now_month + "월 수주계획;";
			headers += next_month + "월 수주계획;";
			headers += "출하수량;";
			headers += "출하잔량;";
			headers += "익월 과부족수량;";
			System.out.println("prodManageExcelDownload 2-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "ORDERNAME;";
			columns += "DRAWINGNO;";
			columns += "ITEMNAME;";
//			columns += "MODELNAME;";
//			columns += "MATERIALTYPE;";
			columns += "CUSTOMERNAME;";
			columns += "MATCOUNT;";

			System.out.println("prodManageExcelDownload 2-1-2. >>>>>>>>>> " + value_split.length);
			for (int i = 0; i < value_split.length; i++) {
				columns += "GROUP" + value_split[i] + ";";
//				System.out.println("prodManageExcelDownload 2-0-" + i + ". >>>>>>>>>> " + label_split[i]);
			}

			columns += "FINISHITEM;";
			columns += "SOREMAINQTY;";
			columns += "MORELESSQTY1;";

			columns += "PLANQTY;";
			columns += "PLANNEXTQTY;";
			columns += "SHIPQTY;";
			columns += "MORELESSQTY2;";
			columns += "NEXTREQUIREQTY;";
			System.out.println("prodManageExcelDownload 2-2. >>>>>>>>>> " + columns);

			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
//			types += "S;";
//			types += "S;";
			types += "S;";
			types += "S;";

			for (int i = 0; i < value_split.length; i++) {
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
			System.out.println("prodManageExcelDownload 2-7. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("prodManageExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2 + "_" + now_month + "월");
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		} else if (gubun.equals("MONTHLYWORKER")) {
			try {
				String orgid = StringUtil.nullConvert(params.get("ORGID"));
				if (orgid.isEmpty()) {
					count++;
				}

				String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
				if (companyid.isEmpty()) {
					count++;
				}

				String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
				if (searchyear.isEmpty()) {
					count++;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = prodManageService.selectProdMonthlyWorkerList(params);

			headers += "순번;";
			headers += "작업자;";
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
			headers += "합계;";
			System.out.println("prodManageExcelDownload 3-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "KRNAME;";
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
			System.out.println("prodManageExcelDownload 3-2. >>>>>>>>>> " + columns);

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
			System.out.println("prodManageExcelDownload 3-7. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "_");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("prodManageExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		} else if (gubun.equals("MONTHLYEQUIP")) {
			try {
				String orgid = StringUtil.nullConvert(params.get("ORGID"));
				if (orgid.isEmpty()) {
					count++;
				}

				String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
				if (companyid.isEmpty()) {
					count++;
				}

				String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
				if (searchyear.isEmpty()) {
					count++;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = prodManageService.selectProdMonthlyEquipList(params);

			headers += "순번;";
			headers += "작업반;";
			headers += "설비명;";
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
			headers += "합계;";
			System.out.println("prodManageExcelDownload 4-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "WORKDEPTNAME;";
			columns += "WORKCENTERNAME;";
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
			System.out.println("prodManageExcelDownload 4-2. >>>>>>>>>> " + columns);

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
			System.out.println("prodManageExcelDownload 4-7. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "_");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("prodManageExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		} else if (gubun.equals("EQUIPRESULT")) {
			try {
				String orgid = StringUtil.nullConvert(params.get("ORGID"));
				if (orgid.isEmpty()) {
					count++;
				}

				String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
				if (companyid.isEmpty()) {
					count++;
				}

				String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
				if (searchfrom.isEmpty()) {
					count++;
				}

				String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
				if (searchto.isEmpty()) {
					count++;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = prodManageService.selectProdEquipResultList(params);

			headers += "순번;";
			headers += "일자;";
			headers += "설비명;";
			headers += "생산수량;";
			headers += "최종 작업시간;";
			headers += "설비 I/F 수량;";
			System.out.println("prodManageExcelDownload 5-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "STARTDATE;";
			columns += "WORKCENTERNAME;";
			columns += "PRODUCEDQTY;";
			columns += "FINALPROCTIME;";
			columns += "INTERFACERESULT;";
			System.out.println("prodManageExcelDownload 5-2. >>>>>>>>>> " + columns);

			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			System.out.println("prodManageExcelDownload 5-7. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "_");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("prodManageExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		} else if ( gubun.equals("MONTHLYDISCHARGE") ) {
			// 월별 공구불출 현황 엑셀 다운로드
			try {
				// 1. 년월
				String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
				
				if ( searchmonth.isEmpty() ) {
					count++;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			List<?> resultList = prodManageService.selectMonthlyDischargeList(params);

			headers += "순번;";
			headers += "공정그룹;";
			headers += "공구명;";
			headers += "사양;";
			headers += "불출수량;";
			headers += "단가;";
			headers += "금액;";
			headers += "비고;";

			System.out.println("prodManageExcelDownload 7. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "ROUTINGGROUPNAME;";
			columns += "ITEMNAME;";
			columns += "ITEMSTANDARD;";
			columns += "RELEASEQTY;";
			columns += "SALESPRICE;";
			columns += "SALESAMOUNT;";
			columns += "REMARKS;";
			System.out.println("prodManageExcelDownload 8. >>>>>>>>>> " + columns);

			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			System.out.println("prodManageExcelDownload 9. >>>>>>>>>> " + types);

			resultObject.put("title", "월별_공구불출_현황");
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		}

		mav.addAllObjects(resultObject);

		return mav;
	}
}