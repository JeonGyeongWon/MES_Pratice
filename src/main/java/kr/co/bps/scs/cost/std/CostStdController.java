package kr.co.bps.scs.cost.std;

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
 * @ClassName : CostStdController.java
 * @Description : CostStd Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jshwang, ymha
 * @since 2017. 03.
 * @modify 2018. 02.
 * @version 1.0
 * @see 원가 관리 - 거래처별 매출집계 화면 추가
 * 
 */
@Controller
public class CostStdController extends BaseController {

	@Autowired
	private CostStdService CostStdService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 2017.03.27 매출현황 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/std/CostStdSalesList.do")
	public String CostStdSalesListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "매출 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("cost.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("CostStdSalesListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			// 로그인 사용자의 org company 정보 
			System.out.println("CostStdSalesList loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("CostStdSalesList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("CostStdSalesList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("CostStdSalesList orgid. >>>>>>>>>>" + orgid);
			System.out.println("CostStdSalesList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 CostStdSalesList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					model.addAttribute("ORGID", "1");
				} else {
					System.out.println("2 CostStdSalesList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 CostStdSalesList groupid. >>>>>>>>>>" + groupid);
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

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/cost/std/CostStdSalesList";
	}

	/**
	 * 2017.03.27 매출 현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cost/std/CostStdSalesList.do")
	@ResponseBody
	public Object selectCostStdSalesListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectCostStdSalesListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
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
			extGrid.setData(CostStdService.selectCostStdSalesList(params));
			extGrid.setTotcnt(CostStdService.selectCostStdSalesListCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCostStdSalesListGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}

	/**
	 * 2017.03.27 매출 현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cost/std/CostStdSalesLine.do")
	@ResponseBody
	public Object selectCostStdSalesLineGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectCostStdSalesLineGrid Start. >>>>>>>>>> " + params);
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
			
			String customercode = StringUtil.nullConvert(params.get("CUSTOMERCODE"));
			if (customercode.isEmpty()) {
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
			extGrid.setData(CostStdService.selectCostStdSalesLine(params));
			extGrid.setTotcnt(CostStdService.selectCostStdSalesLineCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCostStdSalesListGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}
	
	/**
	 * 2017.03.28 매출 현황 상세 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cost/std/CostStdSalesDetailList.do")
	@ResponseBody
	public Object selectCostStdSalesDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectCostStdSalesDetailListGrid Start. >>>>>>>>>> " + params);
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

			String customercode = StringUtil.nullConvert(params.get("CUSTOMERCODE"));
			if (customercode.isEmpty()) {
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
			extGrid.setData(CostStdService.selectCostStdSalesListDetail(params));
			extGrid.setTotcnt(CostStdService.selectCostStdSalesListDetailCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCostStdSalesDetailListGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}

	/**
	 * 2017.03.29 매입현황 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/std/CostStdPoList.do")
	public String CostStdPoListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "매입 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("dateFrom", datefrom);
			requestMap.put("dateTo", dateto);

			HashMap<String, Object> params = new HashMap<String, Object>();
			// 로그인 사용자의 org company 정보 
			System.out.println("CostStdSalesList loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("CostStdSalesList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("CostStdSalesList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("CostStdSalesList orgid. >>>>>>>>>>" + orgid);
			System.out.println("CostStdSalesList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 CostStdSalesList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					model.addAttribute("ORGID", "1");
				} else {
					System.out.println("2 CostStdSalesList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 CostStdSalesList groupid. >>>>>>>>>>" + groupid);
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

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);
		return "/cost/std/CostStdPoList";
	}

	/**
	 * 매입 현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cost/std/CostStdPoList.do")
	@ResponseBody
	public Object selectCostStdPoListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectCostStdPoListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String premonthfrom = StringUtil.nullConvert(params.get("TRXDATEFROM"));
			if (premonthfrom.isEmpty()) {
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
			extGrid.setData(CostStdService.selectCostStdPoList(params));
			extGrid.setTotcnt(CostStdService.selectCostStdPoListCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCostStdPoListGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}

	/**
	 * 매입 현황 상세 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cost/std/CostStdPoListDetail.do")
	@ResponseBody
	public Object selectCostStdPoListDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectCostStdPoListDetailGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String premonthfrom = StringUtil.nullConvert(params.get("TRXDATEFROM"));
			if (premonthfrom.isEmpty()) {
				count++;
			}
						
			String customercode = StringUtil.nullConvert(params.get("CUSTOMERCODE"));
			if (!customercode.isEmpty() & !customercode.isEmpty()) {
				System.out.println("customercode >>>>>>>>> " + customercode);
			} else {
				String gubun = StringUtil.nullConvert(params.get("GUBUN"));
				if (!gubun.isEmpty()) {
					// 대,중분류 코드 가져오는 부분
					String firstcustomercode = StringUtil.nullConvert(CostStdService.selectCostStdPoFirstList(params));
	
					params.put("CUSTOMERCODE", firstcustomercode);
				}else{
					count++;
					System.out.println("count >>>>>>>>> " + count);
				}
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
			extGrid.setData(CostStdService.selectCostStdPoListDetail(params));
			extGrid.setTotcnt(CostStdService.selectCostStdPoListDetailCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCostStdPoListDetailGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}

	/**
	 * 거래처별 매출집계 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/std/CostStdSalesTotal.do")
	public String CostStdSalesTotalPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "거래처별 매출집계");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 년도 가져오기
			String searchyear = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 1, "yyyy");
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
			System.out.println("CostStdSalesTotalPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("CostStdSalesTotalPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 CostStdSalesTotalPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					model.addAttribute("ORGID", "1");
				} else {
					System.out.println("2 CostStdSalesTotalPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 CostStdSalesTotalPage groupid. >>>>>>>>>>" + groupid);
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

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. CostStdSalesTotalPage params >>>>>>>>>>>> " + params);
			System.out.println("8. CostStdSalesTotalPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/cost/std/CostStdSalesTotal";
	}

	/**
	 * 월별 누계 생산실적 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cost/std/CostStdSalesTotal.do")
	@ResponseBody
	public Object selectCostStdSalesTotal(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectCostStdSalesTotal Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(CostStdService.selectSalesTotalCount(params));
			extGrid.setData(CostStdService.selectSalesTotalList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCostStdSalesTotal End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 거래처별 매입집계 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/std/CostStdPoTotal.do")
	public String CostStdPoTotalPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "거래처별 매입집계");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 년도 가져오기
			String searchyear = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 1, "yyyy");
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
			System.out.println("CostStdPoTotalPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("CostStdPoTotalPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 CostStdPoTotalPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					model.addAttribute("ORGID", "1");
				} else {
					System.out.println("2 CostStdPoTotalPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 CostStdPoTotalPage groupid. >>>>>>>>>>" + groupid);
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

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. CostStdPoTotalPage params >>>>>>>>>>>> " + params);
			System.out.println("8. CostStdPoTotalPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/cost/std/CostStdPoTotal";
	}
	
	/**
	 * 거래처별 매입집계 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cost/std/CostStdPoTotal.do")
	@ResponseBody
	public Object selectCostStdPoTotal(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectCostStdPoTotal Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(CostStdService.selectCostStdPoTotalTotCnt(params));
			extGrid.setData(CostStdService.selectCostStdPoTotalList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCostStdPoTotal End. >>>>>>>>>>");
		return extGrid;
	}
}