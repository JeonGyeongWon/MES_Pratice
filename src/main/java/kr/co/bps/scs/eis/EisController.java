package kr.co.bps.scs.eis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : EisController.java
 * @Description : Eis Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2020. 12.
 * @version 1.0
 * @see 경영자정보 - 매출 및 매입현황 종합요약
 * 
 */
@Controller
public class EisController extends BaseController {

	@Autowired
	private EisService EisService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 공구변경 현황관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/EisSynthesisSummary.do")
	public String showEisSynthesisSummaryPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "매출 및 매입현황 종합요약");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEisSynthesisSummaryPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisSynthesisSummaryPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisSynthesisSummaryPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisSynthesisSummaryPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisSynthesisSummaryPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisSynthesisSummaryPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisSynthesisSummaryPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisSynthesisSummaryPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisSynthesisSummaryPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisSynthesisSummaryPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisSynthesisSummaryPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisSynthesisSummaryPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisSynthesisSummaryPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisSynthesisSummaryPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/EisSynthesisSummary";
	}

	/**
	 * 공구변경 현황관리 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisSynthesisSummary.do")
	@ResponseBody
	public Object selectEisSynthesisSummaryGrid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisSynthesisSummaryGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectSynthesisSummaryList(params));
			extGrid.setTotcnt(EisService.selectSynthesisSummaryCount(params));
		}

		System.out.println("selectEisSynthesisSummaryGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공구변경 현황관리 > 매출 // 차트 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisSynthesisSummaryChart1.do")
	@ResponseBody
	public Object selectEisSynthesisSummaryChart1(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisSynthesisSummaryChart1 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectSynthesisSummaryChart1List(params));
			extGrid.setTotcnt(EisService.selectSynthesisSummaryChart1Count(params));
		}

		System.out.println("selectEisSynthesisSummaryChart1 End. >>>>>>>>>>");
		return extGrid;
	}


	/**
	 * 공구변경 현황관리 > 매입 // 차트 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisSynthesisSummaryChart2.do")
	@ResponseBody
	public Object selectEisSynthesisSummaryChart2(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisSynthesisSummaryChart2 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectSynthesisSummaryChart2List(params));
			extGrid.setTotcnt(EisService.selectSynthesisSummaryChart2Count(params));
		}

		System.out.println("selectEisSynthesisSummaryChart2 End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공구변경 현황관리 > 매입 비율 // 차트 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisSynthesisSummaryChart3.do")
	@ResponseBody
	public Object selectEisSynthesisSummaryChart3(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisSynthesisSummaryChart3 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectSynthesisSummaryChart3List(params));
			extGrid.setTotcnt(EisService.selectSynthesisSummaryChart3Count(params));
		}

		System.out.println("selectEisSynthesisSummaryChart3 End. >>>>>>>>>>");
		return extGrid;
	}
	
	
	/**
	 * 21.01.26 품목군별 매입집계 현황관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/EisItemPurSummary.do")
	public String showEisItemPurSummary(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "품목군 별 매입집계 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEisItemPurSummaryPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisItemPurSummaryPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisItemPurSummaryPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisItemPurSummaryPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisItemPurSummaryPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisItemPurSummaryPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisItemPurSummaryPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisItemPurSummaryPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisItemPurSummaryPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisItemPurSummaryPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisItemPurSummaryPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisItemPurSummaryPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisItemPurSummaryPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisItemPurSummaryPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/EisItemPurSummary";
	}

	/**
	 * 21.01.26 품목군 별 매입집계 현황관리 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisItemPurSummary.do")
	@ResponseBody
	public Object selectEisItemPurSummaryGrid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisItemPurSummaryGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisItemPurSummaryList(params));
			extGrid.setTotcnt(EisService.selectEisItemPurSummaryCount(params));
		}

		System.out.println("selectEisItemPurSummaryGrid End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 품목군 별 매입집계 현황 // 차트 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisItemPurSummaryChart.do")
	@ResponseBody
	public Object selectEisItemPurSummaryChart(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisItemPurSummaryChart Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}
			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisItemPurSummaryChartList(params));
			extGrid.setTotcnt(EisService.selectEisItemPurSummaryChartCount(params));
		}

		System.out.println("selectEisItemPurSummaryChart End. >>>>>>>>>>");
		return extGrid;
	}

	
	/**
	 * 21.01.26 품목별 매출 실적현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/EisItemSalesResultList.do")
	public String showEisItemSalesResultList(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "품목별 매출 실적현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEisItemSalesResultList Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisItemPurSummaryPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisItemSalesResultList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisItemSalesResultList orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisItemSalesResultList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisItemSalesResultList params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisItemSalesResultList requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/EisItemSalesResultList";
	}

	/**
	 * 21.01.26 품목군 별 매입집계 현황관리 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisItemSalesResultList.do")
	@ResponseBody
	public Object selectEisItemSalesResultList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisItemSalesResultList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisItemSalesResultList(params));
			extGrid.setTotcnt(EisService.selectEisItemSalesResultListCount(params));
		}

		System.out.println("selectEisItemSalesResultList End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 공구변경 현황관리 > 매입 비율 // 차트 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisItemSalesResultChart.do")
	@ResponseBody
	public Object selectEisItemSalesResultChart(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisItemSalesResultChart Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisItemSalesResultChartList(params));
			extGrid.setTotcnt(EisService.selectEisItemSalesResultChartCount(params));
		}

		System.out.println("selectEisItemSalesResultChart End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 21.02.22 품목/기종별 매출수량 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/EisItemModelSalesQty.do")
	public String showEisItemModelSalesQty(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "품목/기종별 매출수량(당해년도)");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEisItemSalesResultList Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisItemPurSummaryPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisItemSalesResultList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisItemSalesResultList orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisItemSalesResultList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisItemSalesResultList params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisItemSalesResultList requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/EisItemModelSalesQty";
	}
	
	/**
	 * 21.02.23 품목/기종별 매출수량 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisItemModelSalesList.do")
	@ResponseBody
	public Object selectEisItemModelSalesListList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisItemModelSalesListList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisItemModelSalesList(params));
			extGrid.setTotcnt(EisService.selectEisItemModelSalesCount(params));
		}

		System.out.println("selectEisItemModelSalesListList End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 21.02.23 품목/기종별 매출수량 // 차트를 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/EisItemModelSalesChart.do")
	@ResponseBody
	public Object selectEisItemModelSalesChart(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisItemModelSalesChart Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisItemModelSalesChartList(params));
			extGrid.setTotcnt(EisService.selectEisItemModelSalesChartCount(params));
		}

		System.out.println("selectEisItemModelSalesChart End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 21.02.24 품목/기종별 매출금액 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/EisItemModelSalesAmount.do")
	public String showEisItemModelSalesAmount(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "품목/기종별 매출금액(당해년도)");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEisItemSalesResultList Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisItemPurSummaryPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisItemSalesResultList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisItemSalesResultList orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisItemSalesResultList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisItemSalesResultList params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisItemSalesResultList requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/EisItemModelSalesAmount";
	}
	
	/**
	 * 21.02.25 업체별 매출 실적현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/EisCustSalesResultList.do")
	public String showEisCustSalesResultList(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "업체별 매출 실적현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEisCustSalesResultList Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisCustSalesResultList loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisCustSalesResultList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisCustSalesResultList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisCustSalesResultList orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisCustSalesResultList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisCustSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisCustSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisCustSalesResultListt groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisCustSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisCustSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisCustSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisCustSalesResultList params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisCustSalesResultList requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/EisCustSalesResultList";
	}
	
	/**
	 * 21.02.25 업체별 매출 실적현황 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/CustSalesResultList.do")
	@ResponseBody
	public Object selectEisCustSalesResultList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisCustSalesResultList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.EisCustSalesResultList(params));
			extGrid.setTotcnt(EisService.EisCustSalesResultListCount(params));
		}

		System.out.println("selectEisCustSalesResultList End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 21.02.25 월별/년도별 매출 실적(수량/금액) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/EisMonthlyYearSalesResult.do")
	public String showEisMonthlyYearSalesResult(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "월별/년도별 매출 실적");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEisItemSalesResultList Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisItemPurSummaryPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisItemSalesResultList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisItemSalesResultList orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisItemSalesResultList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisItemSalesResultList groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisItemSalesResultList params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisItemSalesResultList requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/EisMonthlyYearSalesResult";
	}
	
	/**
	 * 21.02.25 월별/년도별 매출 실적 // grid1을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/selectEisMonthlyYearSalesResult.do")
	@ResponseBody
	public Object selectEisMonthlyYearSalesResult(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectselectEisMonthlyYearSalesResult Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisMonthlyYearSalesResultList(params));
			extGrid.setTotcnt(EisService.selectEisMonthlyYearSalesResultCount(params));
		}

		System.out.println("selectEisMonthlyYearSalesResult End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 21.02.26 월별/년도별 매출 실적 // grid2을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/selectEisMonthlyYearSalesResult2.do")
	@ResponseBody
	public Object selectEisMonthlyYearSalesResult2(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectselectEisMonthlyYearSalesResult2 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisMonthlyYearSalesResultList2(params));
			extGrid.setTotcnt(EisService.selectEisMonthlyYearSalesResultCount2(params));
		}

		System.out.println("selectEisMonthlyYearSalesResult2 End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 21.02.26 월별/년도별 매출 실적 // chart1을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/selectEisMonthlyYearSalesResultChart.do")
	@ResponseBody
	public Object selectEisMonthlyYearSalesResultChart(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectselectEisMonthlyYearSalesResultChart Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisMonthlyYearSalesResultChartList(params));
			extGrid.setTotcnt(EisService.selectEisMonthlyYearSalesResultChartCount(params));
		}

		System.out.println("selectEisMonthlyYearSalesResultChart End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 21.02.26 월별/년도별 매출 실적 // chart2을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/selectEisMonthlyYearSalesResultChart2.do")
	@ResponseBody
	public Object selectEisMonthlyYearSalesResultChart2(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectselectEisMonthlyYearSalesResultChart2 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisMonthlyYearSalesResultChart2List(params));
			extGrid.setTotcnt(EisService.selectEisMonthlyYearSalesResultChart2Count(params));
		}

		System.out.println("selectEisMonthlyYearSalesResultChart2 End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 모바일 > 경영자정보 (메인) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/mobile/EisMain.do")
	public String showEisMobileMainPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "경영자정보 (모바일)");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEisMobileMainPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisMobileMainPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisMobileMainPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisMobileMainPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisMobileMainPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisMobileMainPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisMobileMainPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisMobileMainPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisMobileMainPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisMobileMainPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisMobileMainPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisMobileMainPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisMobileMainPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisMobileMainPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/mobile/EisMain";
	}

	/**
	 * 모바일 > 경영자정보 (상세) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/eis/mobile/EisDetail.do")
	public String showEisMobileDetailPage(@RequestParam int num, HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			String subtitle = "";
			switch (num) {
			case 1:
				subtitle = "매출";
				break;
			case 2:
				subtitle = "매입";
				break;
			case 3:
				subtitle = "생산";
				break;
			case 4:
				subtitle = "품질";
				break;
			default:
				break;
			}
			model.addAttribute("pageTitle", "경영자정보 (" + subtitle + ")");

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEisMobileDetailPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEisMobileDetailPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEisMobileDetailPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEisMobileDetailPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEisMobileDetailPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEisMobileDetailPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEisMobileDetailPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEisMobileDetailPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showEisMobileDetailPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEisMobileDetailPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEisMobileDetailPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showEisMobileDetailPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showEisMobileDetailPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/eis/mobile/EisDetail";
	}

	/**
	 * 경영자정보 (모바일) // 년도별 매출실적을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/mobile/tab1/searchYearChart.do")
	@ResponseBody
	public Object selectEisMobileTab1YearChart(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisMobileTab1YearChart Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisMobileTab1YearList(params));
			extGrid.setTotcnt(EisService.selectEisMobileTab1YearCount(params));
		}

		System.out.println("selectEisMobileTab1YearChart End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 경영자정보 (모바일) // 월별 매출실적을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/mobile/tab1/searchMonthlyChart.do")
	@ResponseBody
	public Object selectEisMobileTab1MonthlyChart(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisMobileTab1MonthlyChart Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisMobileTab1MonthlyList(params));
			extGrid.setTotcnt(EisService.selectEisMobileTab1MonthlyCount(params));
		}

		System.out.println("selectEisMobileTab1MonthlyChart End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 경영자정보 (모바일) // 월별 생산실적을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/mobile/tab3/searchMonthlyChart.do")
	@ResponseBody
	public Object selectEisMobileTab3MonthlyChart(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisMobileTab3MonthlyChart Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisMobileTab3MonthlyList(params));
			extGrid.setTotcnt(EisService.selectEisMobileTab3MonthlyCount(params));
		}

		System.out.println("selectEisMobileTab3MonthlyChart End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 경영자정보 (모바일) // 월별 생산실적을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/eis/mobile/tab3/searchMonthlyList.do")
	@ResponseBody
	public Object selectEisMobileTab3MonthlyList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectEisMobileTab3MonthlyList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(EisService.selectEisMobileTab3MonthlyGridList(params));
			extGrid.setTotcnt(EisService.selectEisMobileTab3MonthlyGridCount(params));
		}

		System.out.println("selectEisMobileTab3MonthlyList End. >>>>>>>>>>");
		return extGrid;
	}

}