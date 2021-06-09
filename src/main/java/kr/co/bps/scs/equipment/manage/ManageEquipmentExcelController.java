package kr.co.bps.scs.equipment.manage;

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
 * @ClassName : ManageEquipmentExcelController.java
 * @Description : ManageEquipment Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2020. 12.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 설비 관리
 * 
 */
@Controller
public class ManageEquipmentExcelController extends BaseController {

	@Autowired
	private ManageEquipmentService ManageEquipmentService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 설비 관리 > 수리 내역 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/equipment/manage/ExcelDownload.do")
	public ModelAndView EquipmentManageExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("EquipmentManageExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("REPAIR")) {
			// 설비수리 이력등록 엑셀 다운로드
			List<?> resultList = ManageEquipmentService.selectEquipmentRepairList(params);

			headers += "순번;";
			headers += "설비명;";
			headers += "등록일자;";
			headers += "현상분류;";
			headers += "현상;";
			headers += "원인;";
			headers += "조치내용;";
			headers += "수리부품;";
			headers += "수리업체;";
			headers += "부품비;";
			
			headers += "수리비;";
			headers += "합계;";
			headers += "조치결과;";
			headers += "사후관리;";
			headers += "완료일;";
			headers += "비고;";
			System.out.println("EquipmentBaseExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "WORKCENTERNAME;";
			columns += "REPAIRDATE;";
			columns += "REASONGUBUNNAME;";
			columns += "REASONNAME;";
			columns += "DETAILREASON;";
			columns += "ACTIONCONTEXTNAME;";
			columns += "ITEMSTANDARD;";
			columns += "REPAIRCENTERNAME;";
			columns += "MATCOST;";

			columns += "REPAIRCOST;";
			columns += "TOTAL;";
			columns += "ACTIONRESULT;";
			columns += "FOLLOWUP;";
			columns += "ENDDATE;";
			columns += "REMARKS;";
			System.out.println("EquipmentBaseExcelDownload 1-2. >>>>>>>>>> " + columns);

			types += "N;";
			types += "S;";
			types += "D;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "N;";

			types += "N;";
			types += "N;";
			types += "S;";
			types += "S;";
			types += "D;";
			types += "S;";
			System.out.println("EquipmentManageExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("EquipmentManageExcelDownload temp2. >>>>>>>>>> " + temp2);

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