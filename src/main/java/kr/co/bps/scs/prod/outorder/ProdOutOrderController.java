package kr.co.bps.scs.prod.outorder;

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
 * @ClassName : ProdOutOrderController.java
 * @Description : ProdOutOrderController class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jshwang
 * @since 2017. 01.
 * @version 1.0
 * @see 구매발주 관리
 * 
 */
@Controller
public class ProdOutOrderController extends BaseController {

	@Autowired
	private ProdOutOrderService prodoutorderservice;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 외주발주 조회.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/outorder/OutOrderList.do")
	public String showProdOutOrderRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "외주발주 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.outorder.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdOutOrderRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdOutOrderRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdOutOrderRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdOutOrderRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdOutOrderRegistPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdOutOrderRegistPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdOutOrderRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdOutOrderRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showProdOutOrderRegistPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdOutOrderRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdOutOrderRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 showProdOutOrderRegistPage groupid. >>>>>>>>>>" + groupid);
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

		return "/prod/outorder/OutOrderList";
	}

	/**
	 * 외주발주 MASTER 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/outorder/OutOrderList.do")
	@ResponseBody
	public Object selectProdOutOrderListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdOutOrderListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		try {

			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.isEmpty()) {

				String pofrom = StringUtil.nullConvert(params.get("POFROM"));
				if (pofrom.isEmpty()) {
					count++;
				}

				String poto = StringUtil.nullConvert(params.get("POTO"));
				if (poto.isEmpty()) {
					count++;
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
			extGrid.setTotcnt(prodoutorderservice.selectProdOutOrderCount(params));
			extGrid.setData(prodoutorderservice.selectProdOutOrderList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdOutOrderListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주발주 DETAIL 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/outorder/OutOrderListDetail.do")
	@ResponseBody
	public Object selectProdOutOrderDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdOutOrderDetailListGrid Start. >>>>>>>>>> " + params);
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
			
			String outpono = StringUtil.nullConvert(params.get("OUTPONO"));
			if (!outpono.isEmpty()) {
				//count++;
			} else {
				String pofrom = StringUtil.nullConvert(params.get("POFROM"));
				if (pofrom.isEmpty()) {
					count++;
				}

				String poto = StringUtil.nullConvert(params.get("POTO"));
				if (poto.isEmpty()) {
					count++;
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
			extGrid.setTotcnt(prodoutorderservice.selectProdOutOrderDetailCount(params));
			extGrid.setData(prodoutorderservice.selectProdOutOrderDetailList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdOutOrderDetailListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주발주등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/outorder/OutOrderManage.do")
	public String showProdOutOrderManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showProdOutOrderManagePage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			String pono = StringUtil.nullConvert(requestMap.get("no"));
			System.out.println("0 showProdOutOrderManagePage pono. >>>>>>>>>>" + pono);

			if (!pono.isEmpty()) {
				// 발주번호가 있을 경우 상세 조회
				model.addAttribute("pageTitle", "외주발주 상세 / 수정");
				model.addAttribute("gubun", "MODIFY");

				// 발주번호 받았을 경우
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showProdOutOrderManagePage org. >>>>>>>>>>" + org);
				System.out.println("2 showProdOutOrderManagePage company. >>>>>>>>>>" + company);
				requestMap.put("OUTPONO", pono); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));

				model.addAttribute("labelBox", labelBox);

			} else {
				// 발주번호가 없을 경우 등록
				model.addAttribute("pageTitle", "외주발주등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showProdOutOrderManagePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showProdOutOrderManagePage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showProdOutOrderManagePage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				//데이터 조회 처리
				System.out.println("showProdOutOrderManagePage RequestMap. >>>>>>>>>>" + requestMap);
				String po = StringUtil.nullConvert(requestMap.get("OUTPONO"));

				// 요청번호 없을 경우 
				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showProdOutOrderManagePage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showProdOutOrderManagePage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showProdOutOrderManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showProdOutOrderManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
					}
				} else {
					System.out.println("3 showProdOutOrderManagePage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showProdOutOrderManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showProdOutOrderManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
					}
				} else {
					System.out.println("6 showProdOutOrderManagePage groupid. >>>>>>>>>>" + groupid);
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

				System.out.println("9 showProdOutOrderManagePage groupid. >>>>>>>>>>" + groupid);
				// 로그인 사용자명
				if (!groupid.equals("ROLE_ADMIN")) {
					params.put("ROLEUSER", loVo.getId());
					List<?> userList2 = dao.list("search.login.name.lov.select", params);
					Map<String, Object> userData2 = (Map<String, Object>) userList2.get(0);
					String employeenumber = StringUtil.nullConvert(userData2.get("VALUE"));
					String krname = StringUtil.nullConvert(userData2.get("LABEL"));

					requestMap.put("EMPLOYEENUMBER", employeenumber);
					requestMap.put("KRNAME", krname);
				}

				System.out.println("0 showProdOutOrderManagePage pono. >>>>>>>>>>" + pono);

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/outorder/OutOrderRegist";
	}

	/**
	 * 2018.03.20 외주발주관리 화면에서 발주대기LIST(공정작업정보) // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/ProdOutOrderWorkOrderList.do")
	@ResponseBody
	public Object MatReceiveRegistPop1(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("ProdOutTransManagePop.do Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(prodoutorderservice.ProdOutOrderManagePopTotCnt(params));
			extGrid.setData(prodoutorderservice.ProdOutOrderManagePopList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("ProdOutTransManagePop End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2018.03.28 외주발주관리 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/outorder/OutOrderRegist.do")
	@ResponseBody
	public Object insertDistMatReceiveRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertProdOutOrderRegist Params. >>>>>>>>>> " + params);

		return prodoutorderservice.insertProdOutorderRegist(params);
	}

	/**
	 * 2018.03.28 외주발주관리 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/outorder/OutOrderRegistGrid.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertDistMatReceiveRegistDGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertProdOutOrderRegistGrid Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodoutorderservice.insertProdOutorderRegistGrid(params));
		return mav;
	}

	/**
	 * 2018.03.28 외주발주관리 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/outorder/OutOrderRegist.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateProdOutOrderRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateProdOutTransManageH Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = prodoutorderservice.updateProdOutOrderManage(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2018.03.28 외주발주관리 등록 수정 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/outorder/OutOrderRegistGrid.do", method = RequestMethod.POST)
	public ModelAndView updateProdOutOrderRegistGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateProdOutTransManageD Start. >>>>>>>>>> " + params);
		mav.addObject("result", prodoutorderservice.updateProdOutOrderManageGrid(params));
		return mav;
	}

	/**
	 * 2018.03.29 외주발주관리 등록 수정화면 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/outorder/OutOrderRegistGrid.do")
	@ResponseBody
	public Object deleteDistMatReceiveRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteProdOutTransManageD Start. >>>>>>>>>> " + params);

		return prodoutorderservice.deleteProdOutOrderRegistGrid(params);
	}

	/**
	 * 2018.03.29 입하발주정보 마스터데이터 삭제 // 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/outorder/OutOrderRegist.do")
	@ResponseBody
	public Object deleteDistMatReceiveRegistDM(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteProdOutOrderRegist Params. >>>>>>>>>> " + params);

		return prodoutorderservice.deleteProdOutOrderRegist(params);
	}
	
	
	
	/**
	 * 2019.07.02 공정 관리 > 외주 관리 > 반입반출현황
	 * 
	 * 
	 * */
	
	@RequestMapping(value = "/prod/outorder/OutOrderInOutList.do")
	public String showOutOrderInOutPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		
		model.addAttribute("pageTitle", "반입반출현황");
		System.out.println("showOutOrderInOutPage Start >>>>>>>>>>");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("CostStdSalesListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("FIRSTDAY"));
				requestMap.put("dateTo", dummy.get("LASTDATE"));
				requestMap.put("datesys", dummy.get("DATESYS"));
			}
			
			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showOutOrderInOutPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showOutOrderInOutPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showOutOrderInOutPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			System.out.println("showOutOrderInOutPage requestMap. >>>>>>>>>>" + requestMap);

			// 그 외 권한
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showOutOrderInOutPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showOutOrderInOutPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showOutOrderInOutPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
				} else {
					System.out.println("2 showOutOrderInOutPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					params.put("ORGID", 1); //임의의값
				}
			} else {
				System.out.println("3 showOutOrderInOutPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "1");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showOutOrderInOutPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "1");
				} else {
					System.out.println("5 showOutOrderInOutPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "1");
					params.put("ORGID", 1); // 임의의값
					params.put("COMPANYID", 1); // 임의의값
				}
			} else {
				System.out.println("6 showOutOrderInOutPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "1");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			requestMap.put("ORGID", 1);
			requestMap.put("COMPANYID", 1);
			requestMap.put("BIGCD", "CMM");
			requestMap.put("MIDDLECD", "WORK_DEPT");
			requestMap.put("ATTRIBUTE2", loVo.getId());
			List<?> workdeptlist = dao.list("search.smallcode.lov.select", requestMap);
			System.out.println("1. showProcessStartPage size >>>>>>>>>>>> " + workdeptlist.size());
			if (workdeptlist.size() > 0) {
				Map<String, Object> workdeptdata = (Map<String, Object>) workdeptlist.get(0);
				
				requestMap.put("workdept",workdeptdata.get("LABEL"));
			}
			
			model.addAttribute("labelBox", labelBox);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/outorder/OutOrderInOutList";
	}
	
	
	
	/**
	 * 반입반출 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/outorder/OutOrderInOutList.do")
	@ResponseBody
	public Object selectOutOrderInOutList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectOutOrderInOutList Start. >>>>>>>>>> " + params);
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
			System.out.println("selectOutOrderInOutList COUNT. >>>>>>>>>> " + count);
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(prodoutorderservice.selectOutOrderInOutListCount(params));
			extGrid.setData(prodoutorderservice.selectOutOrderInOutListData(params));
		}

		System.out.println("selectOutOrderInOutList End. >>>>>>>>>>");
		return extGrid;
	}
	
	
}