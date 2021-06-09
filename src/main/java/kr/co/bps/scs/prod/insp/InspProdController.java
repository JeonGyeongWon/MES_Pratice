package kr.co.bps.scs.prod.insp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.StringUtil;

/**
 * @ClassName : InspProdController.java
 * @Description : InspProd Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha,
 * @since 2017. 08.
 * @version 1.0
 * @see 생산관리 >품질관리 > 부적합품등록
 * 
 */
@Controller
public class InspProdController extends BaseController {

	@Autowired
	private InspProdService inspProdService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 2017.03.08 부적합품 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/insp/ProdInsNonConfirmRegist.do")
	public String showProdInsNonConfirmRegistPage(HttpSession session, ModelMap model,
			@RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "부적합품 등록");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.insp.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdInsNonConfirmRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM2"));
				requestMap.put("dateTo", dummy.get("DATETO"));
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
					// org
					requestMap.put("ORGID", "");
					// params.put("ORGID", orgid );
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의값
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
					// params.put("ORGID", orgid );
					// params.put("COMPANYID", companyid );
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);// 임의의값
					params.put("COMPANYID", 999);// 임의의값
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
			requestMap.put("NCRRESULT", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "QM");
			params.put("MIDDLECD", "NCR_RESULT");
			// params.put("GUBUN", "NCR_RESULT");

			labelBox.put("findByNcrResult", searchService.SmallCodeLovList(params));

			// 상태
			requestMap.put("FAULTTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "FAULT_TYPE");
			// params.put("GUBUN", "FAULT_TYPE");

			labelBox.put("findByFaultType", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/insp/ProdInsNonConfirmRegist";
	}

	/**
	 * 2017.03.08 부적합품등록 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/ProdInsNonConfirmRegist.do")
	@ResponseBody
	public Object selectProdInsNonConfirmRegistGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdInsNonConfirmRegistGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(inspProdService.selectInspProdCount(params));
			extGrid.setData(inspProdService.selectInspProdList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdInsNonConfirmRegistGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 부적합품등록 // Grid 상세 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/ProdInsNonConfirmDetailRegist.do")
	@ResponseBody
	public Object selectProdInsNonConfirmDetailRegistGrid(@RequestParam HashMap<String, Object> params,
			@RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdInsNonConfirmDetailRegistGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String masterclick = StringUtil.nullConvert(params.get("MASTERCLICK"));
			if (!masterclick.isEmpty()) {
				String workorderid = StringUtil.nullConvert(params.get("WORKORDERID"));
				if (workorderid.isEmpty()) {
					count++;
				}
				String workorderseq = StringUtil.nullConvert(params.get("WORKORDERSEQ"));
				if (workorderseq.isEmpty()) {
					count++;
				}
				String employeeseq = StringUtil.nullConvert(params.get("EMPLOYEESEQ"));
				if (employeeseq.isEmpty()) {
					count++;
				}
			} else {
				String firstworkorderid = StringUtil.nullConvert(inspProdService.selectInspProdFirstList1(params));
				if (firstworkorderid != "") {
					params.put("WORKORDERID", firstworkorderid);
				} else {
					count++;
				}
				String firstworkorderseq = StringUtil.nullConvert(inspProdService.selectInspProdFirstList2(params));
				if (firstworkorderid != "") {
					params.put("WORKORDERSEQ", firstworkorderseq);
				} else {
					count++;
				}
				String firstemployeeseq = StringUtil.nullConvert(inspProdService.selectInspProdFirstList3(params));
				if (firstworkorderid != "") {
					params.put("EMPLOYEESEQ", firstemployeeseq);
				} else {
					count++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(inspProdService.selectInspProdDetailCount(params));
			extGrid.setData(inspProdService.selectInspProdDetailList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdInsNonConfirmDetailRegistGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2017.03.08 부적합품 등록 // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/insp/ProdInsNonConfirmRegist.do")
	@ResponseBody
	public Object insertProdInsNonConfirmRegist(@RequestParam HashMap<String, Object> params) throws Exception {

		return inspProdService.insertProdInsNonConfirmRegist(params);
	}

	/**
	 * 2017.03.08 부적합품 등록 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/insp/ProdInsNonConfirmRegist.do")
	@ResponseBody
	public Object updatetProdInsNonConfirmRegist(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetProdInsNonConfirmRegist Start. >>>>>>>>>> " + params);
		Object result = null;
		try {
			result = inspProdService.updateProdInsNonConfirmRegist(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 부적합품 등록 // 재작업지시 데이터 생성
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/call/prod/insp/ReWorkOrderCreate.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object callReWorkOrderCreate(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("callReWorkOrderCreate Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = inspProdService.callReWorkOrderCreate(params);
			System.out.println("callReWorkOrderCreate result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2017.03.08 부적합품 등록 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/insp/ProdInsNonConfirmRegist.do")
	@ResponseBody
	public Object deleteProdInsNonConfirmRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteProdInsNonConfirmRegist >>>>>>>>>> " + params);
		return inspProdService.deleteProdInsNonConfirmRegist(params);
	}

	/**
	 * 2017.03.08 그리드에서의 품목 lov // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/insp/searchItemLov.do")
	@ResponseBody
	public Object searchBomItemLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchItemLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(inspProdService.searchItemLovTotCnt(params));
			extGrid.setData(inspProdService.searchItemLovList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchItemLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2017.03.08 조회조건 lov // 조회 항목 부적합품번호 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/insp/searchNcrNoLov.do")
	@ResponseBody
	public Object searchNcrNoLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchNcrNoLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(inspProdService.searchNcrNoLovTotCnt(params));
			extGrid.setData(inspProdService.searchNcrNoLovList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchNcrNoLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 부적합 집계 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/insp/ProdIncTotalList.do")
	public String showProdIncTotalListPage(HttpSession session, ModelMap model,
			@RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "부적합집계");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.insp.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdIncTotalListPage Dummy. >>>>>>>>>>" + dummy);

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

		return "/prod/insp/ProdIncTotalList";
	}

	/**
	 * 부적합 집계 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/ProdIncTotalList.do")
	@ResponseBody
	public Object selectProdIncTotalListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdIncTotalListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
//			String orgid = StringUtil.nullConvert(params.get("ORGID"));
//			if (orgid.isEmpty()) {
//				count++;
//			}

//			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
//			if (companyid.isEmpty()) {
//				count++;
//			}

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
			extGrid.setTotcnt(inspProdService.selectIncTotalCount(params));
			extGrid.setData(inspProdService.selectIncTotalList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdIncTotalListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 불량수량 Chart // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/ProdIncTotalChart.do")
	@ResponseBody
	public Object selectProdIncTotalChartGrid(@RequestParam HashMap<String, Object> params,
			@RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdIncTotalChartGrid Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
//			String orgid = StringUtil.nullConvert(params.get("ORGID"));
//			if (orgid.isEmpty()) {
//				count++;
//			}
//
//			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
//			if (companyid.isEmpty()) {
//				count++;
//			}

			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
				count++;
			}

			params.put("GUBUN", "TOTAL");
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(inspProdService.selectProdIncTotalChartList(params));
			extGrid.setTotcnt(inspProdService.selectProdIncTotalChartCount(params));
		}

		System.out.println("selectProdIncTotalChartGrid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}

	
	/**
	 * 불량수량 Chart // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/ProdIncDetailChart.do")
	@ResponseBody
	public Object selectProdIncDetailChartGrid(@RequestParam HashMap<String, Object> params,
			@RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdIncDetailChartGrid Start. >>>>>>>>>>");
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
			
			params.put("GUBUN", "TOTAL");
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(inspProdService.selectProdIncDetailChartList(params));
			extGrid.setTotcnt(inspProdService.selectProdIncDetailChartCount(params));
		}

		System.out.println("selectProdIncTotalChartGrid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}
	
	/**
	 * 부적합 상세내역 팝업 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/ProdIncDetailPopupList.do")
	@ResponseBody
	public Object selectProdIncDetailPopupListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdIncDetailPopupListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(inspProdService.selectProdIncDetailPopupCount(params));
			extGrid.setData(inspProdService.selectProdIncDetailPopupList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdIncDetailPopupListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	
	/**
	 * 부적합 상세내역 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/insp/ProdIncDetailList.do")
	public String showProdIncDetailListPage(HttpSession session, ModelMap model,
			@RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "부적합상세내역");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.insp.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdIncDetailListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
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

		return "/prod/insp/ProdIncDetailList";
	}

	/**
	 * 부적합 상세내역 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/ProdIncDetailList.do")
	@ResponseBody
	public Object selectProdIncDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdIncDetailListGrid Start. >>>>>>>>>> " + params);
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

			String serachto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (serachto.isEmpty()) {
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
			extGrid.setTotcnt(inspProdService.selectProdIncDetailCount(params));
			extGrid.setData(inspProdService.selectProdIncDetailList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdIncDetailListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 불량현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/insp/FaultStatusList.do")
	public String showFaultStatusListPage(HttpSession session, ModelMap model,
			@RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "불량현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			String dateyear = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy");

			requestMap.put("dateYear",dateyear);

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

		return "/prod/insp/FaultStatusList";
	}
	
	/**
	 * 불량현황 // KPI 리스트 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/FaultStatusKpiList.do")
	@ResponseBody
	public Object selectFaultStatusKpiList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectFaultStatusKpiList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(inspProdService.selectFaultStatusKpiCount(params));
			extGrid.setData(inspProdService.selectFaultStatusKpiList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectFaultStatusKpiList End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 불량현황 // KPI 리스트 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/insp/FaultStatusList.do")
	@ResponseBody
	public Object selectFaultStatusList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectFaultStatusList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(inspProdService.selectFaultStatusCount(params));
			extGrid.setData(inspProdService.selectFaultStatusList(params));
			// System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectFaultStatusList End. >>>>>>>>>> ");
		return extGrid;
	}
}