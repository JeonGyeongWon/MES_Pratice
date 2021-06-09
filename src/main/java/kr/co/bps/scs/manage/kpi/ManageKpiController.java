package kr.co.bps.scs.manage.kpi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.master.workcenter.WorkCenterMaService;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.StringUtil;

/**
 * @ClassName : PurchaseOrderController.java
 * @Description : PurchaseOrder Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jshwang
 * @since 2017. 01.
 * @version 1.0
 * @see 생산품목 관리
 * 
 */
@Controller
public class ManageKpiController extends BaseController {

	@Autowired
	private ManageKpiService ManageKpiService;
	
	@Autowired
	private WorkCenterMaService workCenterMaService;
	
	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;
	
	/**
	 * 시간당 생산량  // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/manage/kpi/ManageKpi2.do")
	public String managekpiManageKpi2ListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		
		LoginVO loVo = super.getLoginVO();
		System.out.println(" managekpiManageKpi2ListPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();

		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy
			List dummyList = dao.selectListByIbatis("purchase.order.dummy.month.select", requestMap);
//			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
//			System.out.println("showPurchaseOrderRegistPage Dummy. >>>>>>>>>>" + dummy);
//			
//			if (dummy.size() > 0) {
//				// 더미 사용
//				requestMap.put("dateFrom", dummy.get("DATEFROM"));
//				requestMap.put("dateTo", dummy.get("DATETO"));
//				
//			}
			java.util.Calendar cal = java.util.Calendar.getInstance();
			int dateyear = cal.get(cal.YEAR); // 해당 년도 구하기
			
			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
			requestMap.put("dateFrom",datefrom);
			requestMap.put("dateYear",dateyear);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);
			
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);

			labelBox.put("findByOrgId", searchService.OrgLovList(params));
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));


			// 공정
			requestMap.put("RoutingCode", "");
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "ROUTING_GROUP");
			labelBox.put("findByRoutingCode", searchService.SmallCodeLovList(params));
			
			// 설비
			requestMap.put("WorkCode", "");
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			labelBox.put("findByWorkCode", searchService.WorkCenterLovList(params));

			
			
			model.addAttribute("labelBox", labelBox);
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("pageTitle", "시간당 생산량");
		model.addAttribute("searchVO", requestMap);
		return "/manage/kpi/ManageKpi2/ManageKpi2";
	}
	
	/**
	 * 해당 월 시간당 생산량 현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi2List1.do")
	@ResponseBody
	public Object selectManageKpi2List1Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi2List1Grid Start. >>>>>>>>>> ");
		System.out.println("selectManageKpi2List1Grid params >>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));

			if (txrdatefrom.isEmpty()) {
				count++;
			}

//			String workcnetercode = StringUtil.nullConvert(params.get("WORKCNETERCODE"));
//
//			if (workcnetercode.isEmpty()) {
//				count++;
//			}
			
//			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
//
//			if (gubun.isEmpty()) {
//				count++;
//			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi2Area1List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi2Area1Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi2List1Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}

	/**
	 * 월별 시간당 생산량 조건으로 차트를 출력한다
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi2List2.do")
	@ResponseBody
	public Object selectManageKpi2List2Grid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectManageKpi2List1Grid Start. >>>>>>>>>> ");
		System.out.println("selectManageKpi2List1Grid params >>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
		try {
//			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));
//
//			if (txrdatefrom.isEmpty()) {
//				count++;
//			}

//			String premonthto = StringUtil.nullConvert(params.get("PREMONTHTO"));
//
//			if (premonthto.isEmpty()) {
//				count++;
//			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi2Area2List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi2Area2Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi2List1Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	

	/**
	 * 일별/설비별 시간당 생산량 조건으로 차트를 출력한다
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi2List3.do")
	@ResponseBody
	public Object selectManageKpi2List3Grid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectManageKpi2List1Grid Start. >>>>>>>>>> ");
		System.out.println("selectManageKpi2List1Grid params >>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
		try {
//			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));
//
//			if (txrdatefrom.isEmpty()) {
//				count++;
//			}

//			String premonthto = StringUtil.nullConvert(params.get("PREMONTHTO"));
//
//			if (premonthto.isEmpty()) {
//				count++;
//			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi2Area3List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi2Area3Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi2List1Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	

	/**
	 * 공정불량율 감소 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/manage/kpi/ManageKpi3.do")
	public String managekpiManageKpi3ListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		
		LoginVO loVo = super.getLoginVO();
		System.out.println(" managekpiManageKpi3ListPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();

		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy

			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");

			requestMap.put("dateFrom",datefrom);
			
			String dateyear = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy");

			requestMap.put("dateYear",dateyear);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);
			
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);

			labelBox.put("findByOrgId", searchService.OrgLovList(params));
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			
			
			// 설비
			requestMap.put("WorkCode", "");
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			labelBox.put("findByWorkCode", searchService.WorkCenterLovList(params));
			
			// 공정그룹
			requestMap.put("RoutingGroup", "");
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "ROUTING_GROUP");
			params.put("GUBUN", "ORDER BY");

			labelBox.put("findByRoutingGroup", searchService.SmallCodeLovList(params));
			
			// 불량그룹
			requestMap.put("FaultGroup", "01");
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "FAULT_GROUP");
			params.put("GUBUN", "ORDER BY");

			labelBox.put("findByFaultGroup", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("pageTitle", "공정불량율 감소");
		model.addAttribute("searchVO", requestMap);
		return "/manage/kpi/ManageKpi3/ManageKpi3";
	}
	
	/**
	 * 검사불량율 막대차트 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi3List1.do")
	@ResponseBody
	public Object selectManageKpi3List1Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi3List1Grid Start. >>>>>>>>>> ");
		System.out.println("selectManageKpi3List1Grid params >>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String dateyear = StringUtil.nullConvert(params.get("DATEYEAR"));
			if (dateyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi3Area1List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi3Area1Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi3List1Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}

	/**
	 * 월별 시간당 꺾은선 차트 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi3List2.do")
	@ResponseBody
	public Object selectManageKpi3List2Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi3List2Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String datefrom = StringUtil.nullConvert(params.get("DATEFROM"));
			if (datefrom.isEmpty()) {
				count++;
			}

//			String premonthto = StringUtil.nullConvert(params.get("PREMONTHTO"));
//			if (premonthto.isEmpty()) {
//				count++;
//			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi3Area2List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi3Area2Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi3List2Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 월별 시간당  // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi3List3.do")
	@ResponseBody
	public Object selectManageKpi3List3Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi3List3Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String datefrom = StringUtil.nullConvert(params.get("DATEFROM"));
			if (datefrom.isEmpty()) {
				count++;
			}			
//			LoginVO login = getLoginVO();
//			params.put("REGISTID", login.getId());
//			params.put("RETURNSTATUS", "");
//			params.put("MSGDATA", "");
//			System.out.println("공정불량율 업데이트 insert 및 호출 Start. >>>>>>>> " + params);
//			dao.list("kpi3.updatepkg.call.Procedure", params);
//			System.out.println("공정불량율 테이블 insert 및 PROCEDURE 호출 End.  >>>>>>>> " + params);
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi3Area3List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi3Area3Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi3List3Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 납기단축감소 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/manage/kpi/ManageKpi4.do")
	public String managekpiManageKpi4ListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		
		LoginVO loVo = super.getLoginVO();
		System.out.println(" managekpiManageKpi4ListPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();

		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy
			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
			requestMap.put("dateFrom",datefrom);
			
			String dateyear = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy");
			requestMap.put("dateYear",dateyear);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);
			
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);

			labelBox.put("findByOrgId", searchService.OrgLovList(params));
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			
			
			// 설비
			requestMap.put("WorkCode", "");
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			labelBox.put("findByWorkCode", searchService.WorkCenterLovList(params));

			model.addAttribute("labelBox", labelBox);

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("pageTitle", "납기단축감소");
		model.addAttribute("searchVO", requestMap);
		return "/manage/kpi/ManageKpi4/ManageKpi4";
	}
	
	/**
	 * 납기단축감소 막대차트 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi4List1.do")
	@ResponseBody
	public Object selectManageKpi4List1Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi4List1Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String dateyear = StringUtil.nullConvert(params.get("DATEYEAR"));
			if (dateyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi4Area1List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi4Area1Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi4List1Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}

	/**
	 * 납기단축감소 꺾은선 차트 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi4List2.do")
	@ResponseBody
	public Object selectManageKpi4List2Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi4List2Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));
			if (txrdatefrom.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi4Area2List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi4Area2Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi4List2Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 납기단축감소  // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi4List3.do")
	@ResponseBody
	public Object selectManageKpi4List3Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi4List3Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));
			if (txrdatefrom.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi4Area3List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi4Area3Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi4List3Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 제조리드타임 단축 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/manage/kpi/ManageKpi5.do")
	public String managekpiManageKpi5ListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		
		LoginVO loVo = super.getLoginVO();
		System.out.println(" managekpiManageKpi5ListPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();

		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy

			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");

			requestMap.put("dateFrom",datefrom);
			
			String dateyear = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy");

			requestMap.put("dateYear",dateyear);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);
			
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);

			labelBox.put("findByOrgId", searchService.OrgLovList(params));
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			
			
			// 설비
			requestMap.put("WorkCode", "");
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			labelBox.put("findByWorkCode", searchService.WorkCenterLovList(params));

			model.addAttribute("labelBox", labelBox);

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("pageTitle", "제조리드타임 단축");
		model.addAttribute("searchVO", requestMap);
		return "/manage/kpi/ManageKpi5/ManageKpi5";
	}
	
	/**
	 * 제조리드타임 단축 막대차트 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi5List1.do")
	@ResponseBody
	public Object selectManageKpi5List1Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi5List1Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String dateyear = StringUtil.nullConvert(params.get("DATEYEAR"));
			if (dateyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi5Area1List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi5Area1Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi5List1Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}

	/**
	 * 제조리드타임 단축 꺾은선 차트 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi5List2.do")
	@ResponseBody
	public Object selectManageKpi5List2Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi5List2Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));
			if (txrdatefrom.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi5Area2List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi5Area2Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi5List2Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 제조리드타임 단축 리스트  // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi5List3.do")
	@ResponseBody
	public Object selectManageKpi5List3Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi5List3Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));
			if (txrdatefrom.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi5Area3List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi5Area3Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi5List3Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 재공재고감소  // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/manage/kpi/ManageKpi7.do")
	public String managekpiManageKpi7ListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		
		LoginVO loVo = super.getLoginVO();
		System.out.println(" managekpiManageKpi7ListPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();

		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy

			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");

			requestMap.put("dateFrom",datefrom);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);
			
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);

			labelBox.put("findByOrgId", searchService.OrgLovList(params));
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			
			
			// 설비
			requestMap.put("WorkCode", "");
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			labelBox.put("findByWorkCode", searchService.WorkCenterLovList(params));

			model.addAttribute("labelBox", labelBox);

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("pageTitle", "재공재고감소");
		model.addAttribute("searchVO", requestMap);
		return "/manage/kpi/ManageKpi7/ManageKpi7";
	}
	
	/**
	 * 재공재고감소 꺾은선 차트 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi7List1.do")
	@ResponseBody
	public Object selectManageKpi7List1Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi7List1Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));
			if (txrdatefrom.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi7Area1List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi7Area1Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi7List1Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 재공재고감소  // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi7List2.do")
	@ResponseBody
	public Object selectManageKpi7List2Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi7List2Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("TXRDATEFROM"));
			if (txrdatefrom.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi7Area2List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi7Area2Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi7List2Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 재고비용  // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/manage/kpi/ManageKpi8.do")
	public String managekpiManageKpi8ListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		
		LoginVO loVo = super.getLoginVO();
		System.out.println(" managekpiManageKpi8ListPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();

		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy
			java.util.Calendar cal = java.util.Calendar.getInstance();
			int dateyear = cal.get(cal.YEAR); // 해당 년도 구하기

			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");

			requestMap.put("dateYear",dateyear);
			requestMap.put("dateFrom",datefrom);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);
			
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);

			labelBox.put("findByOrgId", searchService.OrgLovList(params));
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			
			
			// 설비
			requestMap.put("WorkCode", "");
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			labelBox.put("findByWorkCode", searchService.WorkCenterLovList(params));

			model.addAttribute("labelBox", labelBox);

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("pageTitle", "재고비용");
		model.addAttribute("searchVO", requestMap);
		return "/manage/kpi/ManageKpi8/ManageKpi8";
	}
	
	/**
	 * 재고비용 꺾은선 차트 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi8List1.do")
	@ResponseBody
	public Object selectManageKpi8List1Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi8List1Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("DATEYEAR"));
			if (txrdatefrom.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi8Area1List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi8Area1Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi8List1Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
	/**
	 * 재고비용  // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/manage/kpi/ManageKpi8List2.do")
	@ResponseBody
	public Object selectManageKpi8List2Grid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectManageKpi8List2Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String txrdatefrom = StringUtil.nullConvert(params.get("DATEYEAR"));
			if (txrdatefrom.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setData(ManageKpiService.selectManigeKpi8Area2List(params));
			extGrid.setTotcnt(ManageKpiService.selectManigeKpi8Area2Count(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectManageKpi8List2Grid End. >>>>>>>>>> "+ extGrid);
		return extGrid;
	}
	
}