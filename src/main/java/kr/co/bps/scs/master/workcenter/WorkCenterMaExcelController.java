package kr.co.bps.scs.master.workcenter;

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
 * @ClassName : WorkCenterMaExcelController.java
 * @Description : WorkCenterMa Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 12.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 설비 관리
 * 
 */
@Controller
public class WorkCenterMaExcelController extends BaseController {

	@Autowired
	private WorkCenterMaService workCenterMaService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 설비 관리 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/workcenter/ExcelDownload.do")
	public ModelAndView workcenterExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("workcenterExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("WORKCENTER")) {
			// 설비 관리 엑셀 다운로드
			List<?> resultList = workCenterMaService.selectWorkCenterList(params);

			headers += "순번;";
			headers += "설비코드;";
			headers += "설비이름;";
			headers += "모델 및 규격;";
			headers += "제조사;";
			headers += "제조번호;";
			headers += "제조일자;";
			headers += "구입일자;";
			headers += "구입금액;";
			headers += "부서명;";
			
			headers += "작업반;";
			headers += "해당공정;";
			headers += "장비구분;";
			headers += "출력순번;";
			headers += "우선순위제외여부;";
			headers += "등급측정일;";
			headers += "관리등급;";
			headers += "유효시작일;";
			headers += "유효종료일;";
			System.out.println("workcenterExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "WORKCENTERCODE;";
			columns += "WORKCENTERNAME;";
			columns += "MODELSTANDARD;";
			columns += "MAKE;";
			columns += "MAKENO;";
			columns += "MAKEDATE;";
			columns += "BUYDATE;";
			columns += "BUYAMOUNT;";
			columns += "DEPTNAME;";

			columns += "WORKDEPTNAME;";
			columns += "ROUTINGNAME;";
			columns += "EQSETUPNAME;";
			columns += "SEQ;";
			columns += "EXCEPTYN;";
			columns += "GRADECHECKDATE;";
			columns += "MANAGEGRADE;";
			columns += "EFFECTIVESTARTDATE;";
			columns += "EFFECTIVEENDDATE;";
			System.out.println("workcenterExcelDownload 1-2. >>>>>>>>>> " + columns);

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
			System.out.println("workcenterExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("workcenterExcelDownload temp2. >>>>>>>>>> " + temp2);

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