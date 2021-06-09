package kr.co.bps.scs.material.release;

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
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : ReleaseMaterialController.java
 * @Description : ReleaseMaterial Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 07.
 * @version 1.0
 * @see 자재관리 - 자재수불조회 / 공구수불조회
 * 
 */
@Controller
public class ReleaseMaterialController extends BaseController {

	@Autowired
	private ReleaseMaterialService releaseMaterialService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 자재수불조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/material/release/InventoryReceiptList.do")
	public String showInventoryReceiptListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "자재수불조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showInventoryReceiptListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("TODAY", dummy.get("DATEMONTH"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showInventoryReceiptListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showInventoryReceiptListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showInventoryReceiptListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showInventoryReceiptListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 품목유형
			requestMap.put("GROUPCODE", "M");
			requestMap.put("ITEMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");
			params.put("GUBUN", "STATUS");
			params.put("GROUPCD", "M");

			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));
			
			model.addAttribute("labelBox", labelBox);
			System.out.println("7. showInventoryReceiptListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showInventoryReceiptListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/material/release/InventoryReceiptList";
	}
	
	/**
	 * 자재수불조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/material/release/InventoryReceiptList.do")
	@ResponseBody
	public Object selectInventoryReceiptList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectInventoryReceiptList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if ( orgid.isEmpty() ) {
				count++;
			}
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if ( companyid.isEmpty() ) {
				count++;
			}
			String yyyymm = StringUtil.nullConvert(params.get("YYYYMM"));
			if ( yyyymm.isEmpty() ) {
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
			extGrid.setTotcnt(releaseMaterialService.selectInventoryReceiptCount(params));
			extGrid.setData(releaseMaterialService.selectInventoryReceiptList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectInventoryReceiptList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 공구수불조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/material/release/ToolInventoryReceiptList.do")
	public String showToolInventoryReceiptListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "공구수불조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showToolInventoryReceiptListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("TODAY", dummy.get("DATEMONTH"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showToolInventoryReceiptListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showToolInventoryReceiptListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showToolInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showToolInventoryReceiptListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showToolInventoryReceiptListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showToolInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showToolInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showToolInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showToolInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showToolInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showToolInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 품목유형
			requestMap.put("GROUPCODE", "T");
			requestMap.put("ITEMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");
			params.put("GUBUN", "STATUS");
			params.put("GROUPCD", "T");

			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));
			
			model.addAttribute("labelBox", labelBox);
			System.out.println("7. showToolInventoryReceiptListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showToolInventoryReceiptListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/material/release/ToolInventoryReceiptList";
	}

	/**
	 * 공구수불조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/material/release/ToolInventoryReceiptList.do")
	@ResponseBody
	public Object selectToolInventoryReceiptList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectToolInventoryReceiptList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String yyyymm = StringUtil.nullConvert(params.get("YYYYMM"));
			if ( yyyymm.isEmpty() ) {
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
			extGrid.setTotcnt(releaseMaterialService.selectToolInventoryReceiptCount(params));
			extGrid.setData(releaseMaterialService.selectToolInventoryReceiptList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolInventoryReceiptList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 자재입출고현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/material/release/MatStoreRelStatus.do")
	public String MatStoreRelStatusPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "자재입출고현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 년도 가져오기
			String searchyear = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
			requestMap.put("searchYear", searchyear);

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
			System.out.println("MatStoreRelStatusPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("MatStoreRelStatusPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 MatStoreRelStatusPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					model.addAttribute("ORGID", "1");
				} else {
					System.out.println("2 MatStoreRelStatusPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 MatStoreRelStatusPage groupid. >>>>>>>>>>" + groupid);
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
					requestMap.put("COMPANYID", "1");
					model.addAttribute("COMPANYID", "1");
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);//임의의값
					params.put("COMPANYID", 999);//임의의값
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 품목유형
			requestMap.put("GROUPCODE", "M");
			requestMap.put("ITEMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");
			params.put("GUBUN", "STATUS");
			params.put("GROUPCD", "M");			
			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));
			
			model.addAttribute("labelBox", labelBox);

			System.out.println("7. MatStoreRelStatusPage params >>>>>>>>>>>> " + params);
			System.out.println("8. MatStoreRelStatusPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/material/release/MatStoreRelStatus";
	}
	
	/**
	 * 자재입출고현황 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/material/release/MatStoreRelStatus.do")
	@ResponseBody
	public Object selectMatStoreRelStatusTotal(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectMatStoreRelStatusTotal Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchYear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchYear.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(releaseMaterialService.selectMatStoreRelStatusCount(params));
			extGrid.setData(releaseMaterialService.selectMatStoreRelStatusList(params));
			//			System.out.println("releaseMaterialService : " + extGrid.getData());
		}

		System.out.println("selectMatStoreRelStatusTotal End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 자재수불현황 (도급/사급) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/material/release/SubConInventoryReceiptList.do")
	public String showSubConInventoryReceiptListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "자재수불조회(도급/사급)");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showSubConInventoryReceiptListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("TODAY", dummy.get("DATEMONTH"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showSubConInventoryReceiptListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showSubConInventoryReceiptListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showSubConInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showSubConInventoryReceiptListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showSubConInventoryReceiptListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showSubConInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showSubConInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showSubConInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showSubConInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showSubConInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showSubConInventoryReceiptListPage groupid. >>>>>>>>>>" + groupid);
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
			
			System.out.println("7. showSubConInventoryReceiptListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showSubConInventoryReceiptListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/material/release/SubConInventoryReceiptList";
	}
	

	/**
	 * 자재수불조회 (도급/사급) // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/material/release/SubConInventoryReceiptList.do")
	@ResponseBody
	public Object selectSubConInventoryReceiptList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectSubConInventoryReceiptList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String yyyymm = StringUtil.nullConvert(params.get("YYYYMM"));
			if ( yyyymm.isEmpty() ) {
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
			extGrid.setTotcnt(releaseMaterialService.selectSubConInventoryReceiptCount(params));
			extGrid.setData(releaseMaterialService.selectSubConInventoryReceiptList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectSubConInventoryReceiptList End. >>>>>>>>>> ");
		return extGrid;
	}

	
	/**
	 * 소재 입고현황  // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/material/release/MatWarehousingList.do")
	public String showMatWarehousingListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "소재 입고현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMatWarehousingListPage Dummy. >>>>>>>>>>" + dummy);

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

			System.out.println("7. showMatWarehousingListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showMatWarehousingListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/material/release/MatWarehousingList";
	}

	/**
	 * 소재 입고현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/material/release/MatWarehousingList.do")
	@ResponseBody
	public Object selectMatWarehousingListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatWarehousingListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(releaseMaterialService.selectMatWarehousingCount(params));
			extGrid.setData(releaseMaterialService.selectMatWarehousingList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatWarehousingListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
}