package kr.co.bps.scs.prod.manage;

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
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : ProdManageController.java
 * @Description : ProdManage Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 08.
 * @modify 2018. 02.
 * @version 1.0
 * @see 등록 - 공구불출관리
 *         조회 - 생산 실적현황
 *               - 생산현황 및 CAPA
 *               - 월별 생산실적현황 (작업자)
 * 
 */
@Controller
public class ProdManageController extends BaseController {

	@Autowired
	private ProdManageService prodManageService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 공구불출관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdToolChangeManage.do")
	public String showProdToolChangeManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "공구불출관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdToolChangeManagePage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdToolChangeManagePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdToolChangeManagePage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdToolChangeManagePage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdToolChangeManagePage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdToolChangeManagePage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdToolChangeManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdToolChangeManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showProdToolChangeManagePage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdToolChangeManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdToolChangeManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showProdToolChangeManagePage groupid. >>>>>>>>>>" + groupid);
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

			System.out.println("7. showProdToolChangeManagePage params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdToolChangeManagePage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdToolChangeManage";
	}

	/**
	 * 공구불출관리 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdToolChangeManage.do")
	@ResponseBody
	public Object selectProdToolChangeManageGrid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdToolChangeManageGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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

			// 2. 공정
//			String routingid = StringUtil.nullConvert(params.get("ROUTINGID"));
//			if (routingid.isEmpty()) {
//				count++;
//			}

			// 3. 공구명
//			String toolname = StringUtil.nullConvert(params.get("ITEMCODE"));
//			if (toolname.isEmpty()) {
//				count++;
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodManageService.selectToolChangeList(params));
			extGrid.setTotcnt(prodManageService.selectToolChangeCount(params));
		}

		System.out.println("selectProdToolChangeManageGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 생산 실적현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdWorkTotalList.do")
	public String showProdWorkTotalListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "생산 실적현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdWorkTotalListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdWorkTotalListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdWorkTotalListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdWorkTotalListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdWorkTotalListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdWorkTotalListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdWorkTotalListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdWorkTotalListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showProdWorkTotalListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdWorkTotalListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdWorkTotalListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showProdWorkTotalListPage groupid. >>>>>>>>>>" + groupid);
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

			System.out.println("7. showProdWorkTotalListPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdWorkTotalListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdWorkTotalList";
	}

	/**
	 * 생산 실적현황 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdWorkTotalList.do")
	@ResponseBody
	public Object selectProdWorkTotalListGrid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdWorkTotalListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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

			// 2. 품번 / 품명
			//			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			//			if (itemcode.isEmpty()) {
			//				count++;
			//			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodManageService.selectWorkTotalList(params));
			extGrid.setTotcnt(prodManageService.selectWorkTotalCount(params));
		}

		System.out.println("selectProdWorkTotalListGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 생산계획 등록관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdPlanRegistManage.do")
	public String showProdPlanRegistManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "생산계획 등록관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.manage.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdPlanRegistManagePage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showProdPlanRegistManagePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdPlanRegistManagePage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdPlanRegistManagePage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showShipPlanRegistPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showShipPlanRegistPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdPlanRegistManagePage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 showProdPlanRegistManagePage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 showProdPlanRegistManagePage groupid. >>>>>>>>>>" + groupid);
				// org
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
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);//임의의값
					params.put("COMPANYID", 999);//임의의값
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				// company
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 상태
			requestMap.put("SHIPGUBUN", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "OM");
			params.put("MIDDLECD", "SHIP_GUBUN");

			labelBox.put("findByShipGubun", searchService.SmallCodeLovList(params));

			// 상태
			requestMap.put("WORKORDERYN", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "WORK_ORDER_YN");

			labelBox.put("findByWorkOrderYn", searchService.SmallCodeLovList(params));
			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdPlanRegistManage";
	}

	/**
	 * 생산계획 등록관리 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdPlanRegistManage.do")
	@ResponseBody
	public Object selectProdPlanRegistManageListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdPlanRegistManageListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectProdPlanRegistManageCount(params));
			extGrid.setData(prodManageService.selectProdPlanRegistManageList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdPlanRegistManageListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 생산계획 등록관리 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/manage/ProdPlanRegistManage.do")
	@ResponseBody
	public Object updateProdPlanRegistManage(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateProdPlanRegistManage Start. >>>>>>>>>> " + params);
		Object result = null;
		try {
			result = prodManageService.updateProdPlanRegistManage(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	

	/**
	 * 생산현황 및 CAPA // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdCapaList.do")
	public String showProdCapaListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "생산현황 및 CAPA");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdCapaListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdCapaListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdCapaListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdCapaListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdCapaListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdCapaListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdCapaListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdCapaListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showProdCapaListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdCapaListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdCapaListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showProdCapaListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 공정그룹
			params.put("ORGID", result_org );
			params.put("COMPANYID", result_comp );
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "ROUTING_GROUP");
			//params.put("GUBUN", "STATUS");
			List<?> routingList = dao.selectListByIbatis("search.smallcode.group.lov.select", params);
			
			if ( routingList.size() > 0 ) {
				HashMap<String, Object> routingMap = (HashMap<String, Object>) routingList.get(0);

				String value = StringUtil.nullConvert(routingMap.get("VALUE"));
				String label = StringUtil.nullConvert(routingMap.get("LABEL"));
				
				requestMap.put("ROUTINGGROUP", value);
				requestMap.put("ROUTINGGROUPNAME", label);
			}

			requestMap.put("GROUPCODE", "A");
			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showProdCapaListPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdCapaListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdCapaList";
	}

	/**
	 * 생산현황 및 CAPA // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdCapaList.do")
	@ResponseBody
	public Object selectProdCapaListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdCapaListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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
			extGrid.setTotcnt(prodManageService.selectProdCapaCount(params));
			extGrid.setData(prodManageService.selectProdCapaList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdCapaListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 월별 생산실적현황 (작업자) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/MonthlyWorkerList.do")
	public String showMonthlyWorkerListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "월별 생산실적현황(작업자)");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMonthlyWorkerListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showMonthlyWorkerListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showMonthlyWorkerListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showMonthlyWorkerListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showMonthlyWorkerListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showMonthlyWorkerListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showMonthlyWorkerListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showMonthlyWorkerListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showMonthlyWorkerListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showMonthlyWorkerListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showMonthlyWorkerListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showMonthlyWorkerListPage groupid. >>>>>>>>>>" + groupid);
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

			System.out.println("7. showMonthlyWorkerListPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showMonthlyWorkerListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/MonthlyWorkerList";
	}

	/**
	 * 월별 생산실적현황 (작업자) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/MonthlyWorkerList.do")
	@ResponseBody
	public Object selectMonthlyWorkerListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMonthlyWorkerListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(prodManageService.selectProdMonthlyWorkerCount(params));
			extGrid.setData(prodManageService.selectProdMonthlyWorkerList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMonthlyWorkerListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 월별 생산실적현황 (장비별) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/MonthlyEquipList.do")
	public String showMonthlyEquipListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "월별 생산실적현황(장비별)");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMonthlyEquipListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEYEAR", dummy.get("DATEYEAR"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showMonthlyEquipListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showMonthlyEquipListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showMonthlyEquipListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showMonthlyEquipListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showMonthlyEquipListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showMonthlyEquipListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showMonthlyEquipListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showMonthlyEquipListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showMonthlyEquipListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showMonthlyEquipListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showMonthlyEquipListPage groupid. >>>>>>>>>>" + groupid);
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

			System.out.println("7. showMonthlyEquipListPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showMonthlyEquipListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/MonthlyEquipList";
	}

	/**
	 * 월별 생산실적현황 (장비별) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/MonthlyEquipList.do")
	@ResponseBody
	public Object selectMonthlyEquipListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMonthlyEquipListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(prodManageService.selectProdMonthlyEquipCount(params));
			extGrid.setData(prodManageService.selectProdMonthlyEquipList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMonthlyEquipListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 설비 실적현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/EquipResultList.do")
	public String showEquipResultListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "설비 실적현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEquipResultListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showEquipResultListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEquipResultListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEquipResultListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showEquipResultListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showEquipResultListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showEquipResultListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showEquipResultListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showEquipResultListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showEquipResultListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showEquipResultListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showEquipResultListPage groupid. >>>>>>>>>>" + groupid);
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

			System.out.println("7. showEquipResultListPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showEquipResultListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/EquipResultList";
	}

	/**
	 * 설비 실적현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/EquipResultList.do")
	@ResponseBody
	public Object selectEquipResultListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectEquipResultListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(prodManageService.selectProdEquipResultCount(params));
			extGrid.setData(prodManageService.selectProdEquipResultList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectEquipResultListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 월별 공구불출 현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/MonthlyDischargeList.do")
	public String showMonthlyDischargeListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "월별 공구불출 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMonthlyDischargeListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
				requestMap.put("DATEMONTH", dummy.get("DATEMONTH"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showMonthlyDischargeListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showMonthlyDischargeListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showMonthlyDischargeListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showMonthlyDischargeListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showMonthlyDischargeListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showMonthlyDischargeListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showMonthlyDischargeListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showMonthlyDischargeListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showMonthlyDischargeListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showMonthlyDischargeListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showMonthlyDischargeListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 공정그룹
			requestMap.put("ROUTINGGROUP", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "ROUTING_GROUP");

			labelBox.put("findByRoutingRroup", searchService.SmallCodeLovList(params));
			
			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showMonthlyDischargeListPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showMonthlyDischargeListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/MonthlyDischargeList";
	}

	/**
	 * 월별 공구불출 현황 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/MonthlyDischargeList.do")
	@ResponseBody
	public Object selectMonthlyDischargeListGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectMonthlyDischargeListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 1. 년월
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			
			if ( searchmonth.isEmpty() ) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if ( count > 0 ) {
			extGrid.setData( null );
			extGrid.setTotcnt( 0 );
		} else {
			extGrid.setData(prodManageService.selectMonthlyDischargeList(params));
			extGrid.setTotcnt(prodManageService.selectMonthlyDischargeCount(params));
		}

		System.out.println("selectMonthlyDischargeListGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 작업지시 현황조회 (설비별) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/DailyEquipList.do")
	public String showDailyEquipListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "작업지시 현황조회 (설비별)");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showDailyEquipListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showDailyEquipListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showDailyEquipListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showDailyEquipListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showDailyEquipListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showDailyEquipListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showDailyEquipListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showDailyEquipListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showDailyEquipListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showDailyEquipListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showDailyEquipListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showDailyEquipListPage groupid. >>>>>>>>>>" + groupid);
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

			System.out.println("7. showDailyEquipListPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showDailyEquipListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/DailyEquipList";
	}

	/**
	 * 작업지시 현황조회 (설비별) // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/DailyEquipList.do")
	@ResponseBody
	public Object selectDailyEquipListGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectDailyEquipListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 1. 일자
			String searchDate = StringUtil.nullConvert(params.get("SEARCHDATE"));
			if ( searchDate.isEmpty() ) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if ( count > 0 ) {
			extGrid.setData( null );
			extGrid.setTotcnt( 0 );
		} else {
			extGrid.setData(prodManageService.selectDailyEquipList(params));
			extGrid.setTotcnt(prodManageService.selectDailyEquipCount(params));
		}

		System.out.println("selectDailyEquipListGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공정진행현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdStatusList.do")
	public String showProdStatusListPage(HttpSession session, ModelMap model,
			@RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "공정진행현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.insp.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdStatusListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("PREDATEFROM"));
				requestMap.put("dateTo", dummy.get("PREDATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
				requestMap.put("dateMonth", dummy.get("DATEMONTH"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("show groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("show orgid. >>>>>>>>>>" + orgid);
			System.out.println("show companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
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
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdStatusList";
	}

	
	/**
	 * 공정진행현황 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdStatusList.do")
	@ResponseBody
	public Object selectProdStatusListGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectProdStatusListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}
			
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if ( count > 0 ) {
			extGrid.setData( null );
			extGrid.setTotcnt( 0 );
		} else {
			extGrid.setData(prodManageService.selectProdStatusList(params));
			extGrid.setTotcnt(prodManageService.selectProdStatusCount(params));
		}

		System.out.println("selectProdStatusListGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공정진행현황 집계 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdStatusTotalList.do")
	@ResponseBody
	public Object selectProdStatusTotalListGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectProdStatusTotalListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}
			
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if ( count > 0 ) {
			extGrid.setData( null );
			extGrid.setTotcnt( 0 );
		} else {
			extGrid.setData(prodManageService.selectProdStatusTotalList(params));
			extGrid.setTotcnt(prodManageService.selectProdStatusTotalCount(params));
		}

		System.out.println("selectProdStatusTotalListGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 기종별 생산 실적현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdWorkTotalDetail.do")
	public String showProdWorkTotalDetailPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "기종별 생산 실적현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdWorkTotalDetailPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdWorkTotalDetailPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdWorkTotalDetailPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);
			
			String orgid = StringUtil.nullConvert(requestMap.get("orgid"));
			if ( orgid.isEmpty() ) {
				orgid = StringUtil.nullConvert(userData.get("ORGID"));
				System.out.println("showProdWorkTotalDetailPage orgid. >>>>>>>>>>" + orgid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showProdWorkTotalDetailPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showProdWorkTotalDetailPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); // 임의의 값
					}
				} else {
					System.out.println("3 showProdWorkTotalDetailPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", orgid);
				}
			} else {
				params.put("ORGID", orgid);
			}

			labelBox.put("findByOrgId", searchService.OrgLovList(params));
			
			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			
			String companyid = StringUtil.nullConvert(requestMap.get("companyid"));
			if ( companyid.isEmpty() ) {
				companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showProdWorkTotalDetailPage companyid. >>>>>>>>>>" + companyid);

				if (companyid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("4 showProdWorkTotalDetailPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showProdWorkTotalDetailPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999); // 임의의 값
						params.put("COMPANYID", 999); // 임의의 값
					}
				} else {
					System.out.println("6 showProdWorkTotalDetailPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
			} else {
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showProdWorkTotalDetailPage params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdWorkTotalDetailPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdWorkTotalDetail";
	}

	/**
	 * 기종별 생산실적현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdWorkTotalDetail.do")
	@ResponseBody
	public Object selectProdWorkTotalDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdWorkTotalDetailGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			// 1. 일자
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

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(prodManageService.selectWorkTotalDetailCount(params));
			extGrid.setData(prodManageService.selectWorkTotalDetailList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdWorkTotalDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 생산현황 (타입별) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdModelDetailList.do")
	public String showProdModelDetailListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "생산현황 (타입별)");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdModelDetailListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("TODAY", dummy.get("DATEMONTH"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("show groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("show orgid. >>>>>>>>>>" + orgid);
			System.out.println("show companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
				// org
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
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);//임의의값
					params.put("COMPANYID", 999);//임의의값
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				// company
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

			System.out.println("7. showProdModelDetailListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showProdModelDetailListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdModelDetailList";
	}

	/**
	 * 생산현황 (타입별) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdModelDetailList.do")
	@ResponseBody
	public Object selectProdModelDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdModelDetailListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
				count++;
			}
			String itemname = StringUtil.nullConvert(params.get("ITEMNAME"));
			if (itemname.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectProdModelDetailCount(params));
			extGrid.setData(prodManageService.selectProdModelDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdModelDetailListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 생산현황 (종합) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdModelList.do")
	public String showProdModelListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "생산현황 (종합)");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdModelListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("TODAY", dummy.get("DATEMONTH"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("show groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("show orgid. >>>>>>>>>>" + orgid);
			System.out.println("show companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
				// org
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
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);//임의의값
					params.put("COMPANYID", 999);//임의의값
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				// company
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

			System.out.println("7. showProdModelListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showProdModelListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdModelList";
	}

	/**
	 * 생산현황 (종합) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdModelList.do")
	@ResponseBody
	public Object selectProdModelListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdModelListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
				count++;
			}
			String itemname = StringUtil.nullConvert(params.get("ITEMNAME"));
			if (itemname.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectProdModelCount(params));
			extGrid.setData(prodManageService.selectProdModelList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdModelListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 생산현황 (월별) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdModelYearList.do")
	public String showProdModelYearListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "생산현황 (월별)");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdModelListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("TODAY", dummy.get("DATEYEAR"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("show groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("show orgid. >>>>>>>>>>" + orgid);
			System.out.println("show companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
				// org
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
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);//임의의값
					params.put("COMPANYID", 999);//임의의값
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				// company
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

			System.out.println("7. showProdModelYearListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showProdModelYearListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdModelYearList";
	}

	/**
	 * 생산현황 (종합) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdModelYearList.do")
	@ResponseBody
	public Object selectProdModelYearListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdModelYearListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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
			String itemname = StringUtil.nullConvert(params.get("ITEMNAME"));
			if (itemname.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectProdModelYearCount(params));
			extGrid.setData(prodManageService.selectProdModelYearList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdModelYearListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 일별기종별생산실적 ( 년간종합 / 월별종합 / 타입별 / 그래프 ) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/DailyModelResultList.do")
	public String showDailyModelResultListPage(@RequestParam int num, HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		String subtitle = "";
		switch(num) {
		case 1:
			subtitle = "년간종합";
			break;
		case 2:
			subtitle = "월별종합";
			break;
		case 3:
			subtitle = "타입별";
			break;
		case 4:
			subtitle = "그래프";
			break;
			default:
				break;
		}
		model.addAttribute("pageTitle", "일별기종별생산실적 (" + subtitle + ")");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			requestMap.put("tabindex", num);
			
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showDailyModelResultListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("SEARCHYEAR", dummy.get("DATEYEAR"));
				requestMap.put("SEARCHMONTH", dummy.get("DATEMONTH"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("show groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("show orgid. >>>>>>>>>>" + orgid);
			System.out.println("show companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
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

			System.out.println("7. showDailyModelResultListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showDailyModelResultListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/DailyModelResultList";
	}

	/**
	 * 일별기종별생산실적 ( 월별종합 ) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/DailyModelMonthlyList.do")
	@ResponseBody
	public Object selectDailyModelMonthlyListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectDailyModelMonthlyListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
				count++;
			}
			
			String searchlabel = StringUtil.nullConvert(params.get("LABEL"));
			if (searchlabel.isEmpty()) {
				count++;
			}
			
			String routinggroup = StringUtil.nullConvert(params.get("ROUTINGGROUP"));
			if (routinggroup.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectDailyModelMonthlyCount(params));
			extGrid.setData(prodManageService.selectDailyModelMonthlyList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectDailyModelMonthlyListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 일별기종별생산실적 ( 타입별 ) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/DailyDetailMonthlyList.do")
	@ResponseBody
	public Object selectDailyItemDetailMonthlyListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectDailyItemDetailMonthlyListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
				count++;
			}
			
			String searchlabel = StringUtil.nullConvert(params.get("LABEL"));
			if (searchlabel.isEmpty()) {
				count++;
			}
			
			String routinggroup = StringUtil.nullConvert(params.get("ROUTINGGROUP"));
			if (routinggroup.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectDailyItemDetailMonthlyCount(params));
			extGrid.setData(prodManageService.selectDailyItemDetailMonthlyList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectDailyItemDetailMonthlyListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 일별기종별생산실적 ( 그래프 ) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/DailyGraphMonthlyList.do")
	@ResponseBody
	public Object selectDailyGraphMonthlyList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectDailyGraphMonthlyList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
				count++;
			}
			
			String searchlabel = StringUtil.nullConvert(params.get("LABEL"));
			if (searchlabel.isEmpty()) {
				count++;
			}
			
			String routinggroup = StringUtil.nullConvert(params.get("ROUTINGGROUP"));
			if (routinggroup.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectDailyGraphMonthlyCount(params));
			extGrid.setData(prodManageService.selectDailyGraphMonthlyList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectDailyGraphMonthlyList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 일별기종별생산실적 ( 년간종합 ) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/YearModelMonthlyList.do")
	@ResponseBody
	public Object selectYearModelMonthlyListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectYearModelMonthlyListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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
			
			String searchlabel = StringUtil.nullConvert(params.get("LABEL"));
			if (searchlabel.isEmpty()) {
				count++;
			}
			
			String routinggroup = StringUtil.nullConvert(params.get("ROUTINGGROUP"));
			if (routinggroup.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectYearModelMonthlyCount(params));
			extGrid.setData(prodManageService.selectYearModelMonthlyList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectYearModelMonthlyListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 일별기종별생산실적 ( 3개년 그래프 ) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/DailyGraphYearList.do")
	@ResponseBody
	public Object selectDailyGraphYearList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectDailyGraphYearList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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
			
			String searchlabel = StringUtil.nullConvert(params.get("LABEL"));
			if (searchlabel.isEmpty()) {
				count++;
			}
			
			String routinggroup = StringUtil.nullConvert(params.get("ROUTINGGROUP"));
			if (routinggroup.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectDailyGraphYearCount(params));
			extGrid.setData(prodManageService.selectDailyGraphYearList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectDailyGraphYearList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 일별기종별생산실적 ( 금년도 비율 그래프 ) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/DailyGraphModelList.do")
	@ResponseBody
	public Object selectDailyGraphModelList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectDailyGraphModelList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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
			
			String searchlabel = StringUtil.nullConvert(params.get("LABEL"));
			if (searchlabel.isEmpty()) {
				count++;
			}
			
			String routinggroup = StringUtil.nullConvert(params.get("ROUTINGGROUP"));
			if (routinggroup.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectDailyGraphModelCount(params));
			extGrid.setData(prodManageService.selectDailyGraphModelList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectDailyGraphModelList End. >>>>>>>>>> ");
		return extGrid;
	}


	/**
	 * 공정진행현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ProdStatusList2.do")
	public String showProdStatusList2Page(HttpSession session, ModelMap model,
			@RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "공정진행현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.insp.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdStatusListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("PREDATEFROM"));
				requestMap.put("dateTo", dummy.get("PREDATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
				requestMap.put("dateMonth", dummy.get("DATEMONTH"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("show groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("show orgid. >>>>>>>>>>" + orgid);
			System.out.println("show companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			
			requestMap.put("SHIPPINGITEMGROUP", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "OM");
			params.put("MIDDLECD", "SHIPPING_ITEM_GROUP");
			params.put("ATTRIBUTE2", "Y");
			params.put("GUBUN", "SHIPPING_ITEM_GROUP");
			labelBox.put("findByShippingItemGroup", searchService.SmallCodeLovList(params));
			

			requestMap.put("MODELGROUP", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "MODEL");
			labelBox.put("findByModelGroup", searchService.ModelGroupList(params));
			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ProdStatusList2";
	}
	

	/**
	 * 공정진행현황 공정 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdStatusList2Header.do")
	@ResponseBody
	public Object selectProdStatusList2Header(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdStatusList2Header Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectProdStatusList2HeaderCount(params));
			extGrid.setData(prodManageService.selectProdStatusList2HeaderList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdStatusList2Header End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 공정진행현황 공정 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ProdStatusList2.do")
	@ResponseBody
	public Object selectProdStatusList2(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdStatusList2 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectProdStatusList2Count(params));
			extGrid.setData(prodManageService.selectProdStatusList2(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdStatusList2 End. >>>>>>>>>> ");
		return extGrid;
	}
	
	
	/**
	 * 공구입고관리 조회.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ToolWarehousingManage.do")
	public String showToolWarehousingManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "공구 입고 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.manage.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showToolWarehousingManagePage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("POSTDATETO"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showToolWarehousingManagePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showToolWarehousingManagePage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showToolWarehousingManagePage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showToolWarehousingManagePage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showToolWarehousingManagePage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showToolWarehousingManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showToolWarehousingManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showToolWarehousingManagePage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showToolWarehousingManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showToolWarehousingManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 showToolWarehousingManagePage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 로그인 사용자명
			if (!groupid.equals("ROLE_ADMIN")) {
				params.put("ROLEUSER", loVo.getId());
				List<?> userList2 = dao.list("search.login.name.lov.select", params);
				Map<String, Object> userData2 = (Map<String, Object>) userList2.get(0);
				String employeenumber = StringUtil.nullConvert(userData.get("VALUE"));
				String krname = StringUtil.nullConvert(userData.get("LABEL"));

				requestMap.put("EMPLOYEENUMBER", employeenumber);
				requestMap.put("KRNAME", krname);
			}

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ToolWarehousingManage";
	}

	/**
	 * 공구입고관리 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ToolWarehousingManage.do")
	@ResponseBody
	public Object selectToolWarehousingManageGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectToolWarehousingManageGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			String pofrom = StringUtil.nullConvert(params.get("TRANSFROM"));
			if (pofrom.isEmpty()) {
				count++;
			}

			String poto = StringUtil.nullConvert(params.get("TRANSTO"));
			if (poto.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectToolWarehousingManageMasterCount(params));
			extGrid.setData(prodManageService.selectToolWarehousingManageMasterList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolWarehousingManageGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 공구입고관리 상세 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/ToolWarehousingManageDetail.do")
	@ResponseBody
	public Object selectToolWarehousingManageDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectToolWarehousingManageDetailGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			String pono = StringUtil.nullConvert(params.get("TRANSNO"));
			if (pono.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectToolWarehousingManageDetailCount(params));
			extGrid.setData(prodManageService.selectToolWarehousingManageDetailList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolWarehousingManageDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 공구입고관리 상세 화면 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/ToolWarehousingRegist.do")
	public String showDistMatReceiveRegistD(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "공구입고 상세정보");

		System.out.println("showDistMatReceiveRegistD Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보
			System.out.println(" loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println(" params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println(" groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 데이터 조회 처리
			System.out.println(" RequestMap. >>>>>>>>>>" + requestMap);
			String no = StringUtil.nullConvert(requestMap.get("no"));

			// 번호 없을 경우
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println(" orgid. >>>>>>>>>>" + orgid);
			System.out.println(" companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3  groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6  groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			if (no.isEmpty()) {

			} else {
				// 번호 받았을 경우
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("6 showDistMatReceiveRegistD org. >>>>>>>>>>" + org);
				System.out.println("6 showDistMatReceiveRegistD company. >>>>>>>>>>" + company);
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				requestMap.put("TRANSNO", no); // 수정
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			}

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/ToolWarehousingRegist";
	}

	/**
	 * 공구입고관리 상세 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/manage/ToolWarehousingMasterList.do")
	@ResponseBody
	public Object insertToolWarehousingMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertToolWarehousingMasterList Params. >>>>>>>>>> " + params);

		return prodManageService.insertToolWarehousingMasterList(params);
	}

	/**
	 * 공구입고관리 상세 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/manage/ToolWarehousingDetailList.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertToolWarehousingDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertToolWarehousingDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodManageService.insertToolWarehousingDetailList(params));
		return mav;
	}

	/**
	 * 공구입고관리 상세 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/manage/ToolWarehousingMasterList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateToolWarehousingMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateToolWarehousingMasterList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = prodManageService.updateToolWarehousingMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 공구입고관리 상세 등록 수정 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/manage/ToolWarehousingDetailList.do", method = RequestMethod.POST)
	public ModelAndView updateToolWarehousingDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateToolWarehousingDetailList Start. >>>>>>>>>> " + params);
		mav.addObject("result", prodManageService.updateToolWarehousingDetailList(params));
		return mav;
	}

	/**
	 * 공구입고관리 상세 마스터데이터 삭제 // 마스터
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/manage/ToolWarehousingMasterList.do")
	@ResponseBody
	public Object deleteToolWarehousingMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteToolWarehousingMasterList Params. >>>>>>>>>> " + params);

		return prodManageService.deleteToolWarehousingMasterList(params);
	}

	/**
	 * 공구입고관리 상세 등록 수정화면 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/manage/ToolWarehousingDetailList.do")
	@ResponseBody
	public Object deleteToolWarehousingDetailList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteToolWarehousingDetailList Start. >>>>>>>>>> " + params);

		return prodManageService.deleteToolWarehousingDetailList(params);
	}

	/**
	 * 공구입고관리 화면에서 입고대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/ToolWarehousingRegistPop1.do")
	@ResponseBody
	public Object ToolWarehousingRegistPop1(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("MatReceiveRegistPop1 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(prodManageService.ToolWarehousingRegistPop1TotCnt(params));
			extGrid.setData(prodManageService.ToolWarehousingRegistPop1List(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("MatReceiveRegistPop1 End. >>>>>>>>>>");
		return extGrid;
	}
	
	

	/**
	 * 래핑 I/F 실적 현황 조회.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/manage/WrappingIFPerform.do")
	public String showWrappingIFPerformPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "래핑 I/F 실적 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.manage.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showWrappingIFPerformPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("POSTDATEFROM"));
				requestMap.put("dateTo", dummy.get("POSTDATETO"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showWrappingIFPerformPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showWrappingIFPerformPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showWrappingIFPerformPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showWrappingIFPerformPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showWrappingIFPerformPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showWrappingIFPerformPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showWrappingIFPerformPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showWrappingIFPerformPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showWrappingIFPerformPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showWrappingIFPerformPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 showWrappingIFPerformPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 로그인 사용자명
			if (!groupid.equals("ROLE_ADMIN")) {
				params.put("ROLEUSER", loVo.getId());
				List<?> userList2 = dao.list("search.login.name.lov.select", params);
				Map<String, Object> userData2 = (Map<String, Object>) userList2.get(0);
				String employeenumber = StringUtil.nullConvert(userData.get("VALUE"));
				String krname = StringUtil.nullConvert(userData.get("LABEL"));

				requestMap.put("EMPLOYEENUMBER", employeenumber);
				requestMap.put("KRNAME", krname);
			}

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/manage/WrappingIFPerform";
	}

	/**
	 * 래핑I/F 실적현황 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/WrappingIFPerformList.do")
	@ResponseBody
	public Object selectWrappingIFPerformListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWrappingIFPerformListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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
			
			String searchto= StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectWrappingIFPerformListCount(params));
			extGrid.setData(prodManageService.selectWrappingIFPerformMasterList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWrappingIFPerformListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 래핑I/F 실적현황 제품별 집계 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/WrappingIFPerformCount.do")
	@ResponseBody
	public Object selectWrappingIFPerformCountGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWrappingIFPerformCountGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String searchdate = StringUtil.nullConvert(params.get("SEARCHDATE"));
			if (searchdate.isEmpty()) {
				count++;
			}
			
			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
			if (workcentercode.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectWrappingIFPerformCountCount(params));
			extGrid.setData(prodManageService.selectWrappingIFPerformCountList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWrappingIFPerformCountGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 래핑I/F 실적현황 상세 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/manage/WrappingIFPerformDetail.do")
	@ResponseBody
	public Object selectWrappingIFPerformDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWrappingIFPerformDetailGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
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
			
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}
			
			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
			if (workcentercode.isEmpty()) {
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
			extGrid.setTotcnt(prodManageService.selectWrappingIFPerformDetailCount(params));
			extGrid.setData(prodManageService.selectWrappingIFPerformDetailList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWrappingIFPerformDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}
}