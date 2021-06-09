package kr.co.bps.scs.order.manage;

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
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : OrderManageController.java
 * @Description : OrderManage Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 10.
 * @version 1.0
 * @see 수주관리
 */
@Controller
public class OrderManageController extends BaseController {

	@Autowired
	private OrderManageService OrderManageService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 수주등록관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/manage/OrderManageStateList.do")
	public String showOrderManageStateListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		String temp = loVo.getAuthCode();
		String title = "수주";
				
		if(temp.equals("ROLE_SCM_R")){
			title = "주문";
		}
		
		model.addAttribute("pageTitle", title + "관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {

			Map<String, ?> fm = RequestContextUtils.getInputFlashMap(super.request);
			if (fm != null && !fm.isEmpty()) {
				model.addAllAttributes(fm);
			}

			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOrderManageStateListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showOrderManageStateListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showOrderManageStateListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showOrderManageStateListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showOrderManageStateListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showOrderManageStateListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showOrderManageStateListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "1");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 showOrderManageStateListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "1");
					params.put("ORGID", 1); //임의의값
				}
			} else {
				System.out.println("3 showOrderManageStateListPage groupid. >>>>>>>>>>" + groupid);
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
					requestMap.put("COMPANYID", "1");
					params.put("ORGID", 1);//임의의값
					params.put("COMPANYID", 1);//임의의값
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				// company
				requestMap.put("COMPANYID", "1");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 수주상태
			requestMap.put("SOSTATUS", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "OM");
			params.put("MIDDLECD", "SO_STATUS");

			labelBox.put("findBySoStatusGubun", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/manage/OrderManageStateList";
	}

	/**
	 * 수주관리 // Grid Master 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/manage/OrderManageStateListMaster.do")
	@ResponseBody
	public Object selectOrderManageStateListMasterGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOrderManageStateListMasterGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		try {

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
			extGrid.setTotcnt(OrderManageService.selectOrderManageStateListMasterListCount(params));
			extGrid.setData(OrderManageService.selectOrderManageStateListMasterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOrderManageStateListMasterGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 수주관리 // Grid Detail 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/manage/OrderManageStateListDetail.do")
	@ResponseBody
	public Object selectOrderManageStateListDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOrderManageStateListDetailGrid params >>>>>>>>> " + params);
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

			String sono = StringUtil.nullConvert(params.get("SONO"));
			if (sono.isEmpty()) {
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
			extGrid.setTotcnt(OrderManageService.selectOrderManageStateListDetailCount(params));
			extGrid.setData(OrderManageService.selectOrderManageStateListDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOrderManageStateListDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 수주등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/manage/OrderManageRegist.do")
	public String showOrderManageRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		String temp = loVo.getAuthCode();
		String title = "수주";
				
		if(temp.equals("ROLE_SCM_R")){
			title = "주문";
		}
		
		model.addAttribute("pageTitle", title+"등록");
		System.out.println("showOrderManageRegistPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 데이터 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOrderManageRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
			}

			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			String sono = StringUtil.nullConvert(requestMap.get("SONO"));
			if (!sono.isEmpty()) {
				// 수주번호가 있을 경우 상세
				model.addAttribute("pageTitle", title + " 상세 / 수정");

				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showOrderManageRegistPage org. >>>>>>>>>>" + org);
				System.out.println("2 showOrderManageRegistPage company. >>>>>>>>>>" + company);
				requestMap.put("SONO", sono);
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				requestMap.put("gubun", "A");
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));

				// 수주상태
				requestMap.put("SOSTATUS", "");
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SO_STATUS");

				labelBox.put("findBySoStatusGubun", searchService.SmallCodeLovList(params));

				// 세액구분
				requestMap.put("TAXDIV", "");
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "TAX_DIV");

				labelBox.put("findByTaxDivGubun", searchService.SmallCodeLovList(params));

				// 결제조건
				requestMap.put("PAYMENTTERMS", "");
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "PAYMENT_TERMS");

				labelBox.put("findByPaymentTermsGubun", searchService.SmallCodeLovList(params));

				// 수주구분
				requestMap.put("SOTYPE", "A");
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SO_TYPE");

				labelBox.put("findBySoTypeGubun", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);
			} else {
				// 금형코드가 없을 경우 등록
				model.addAttribute("pageTitle", title +"등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showOrderManageRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showOrderManageRegistPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showOrderManageRegistPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showOrderManageRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showOrderManageRegistPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showOrderManageRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "1");
					} else {
						System.out.println("2 showOrderManageRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "1");
						params.put("ORGID", 1);
					}
				} else {
					System.out.println("3 showOrderManageRegistPage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showOrderManageRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "1");
					} else {
						System.out.println("5 showOrderManageRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "1");
						params.put("ORGID", 1);
						params.put("COMPANYID", 1);
					}
				} else {
					System.out.println("6 showOrderManageRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "1");
					params.put("ORGID", 1);
					params.put("COMPANYID", 1);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				// 수주상태
				requestMap.put("SOSTATUS", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SO_STATUS");

				labelBox.put("findBySoStatusGubun", searchService.SmallCodeLovList(params));

				// 세액구분
				requestMap.put("TAXDIV", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "TAX_DIV");

				labelBox.put("findByTaxDivGubun", searchService.SmallCodeLovList(params));

				// 결제조건
				requestMap.put("PAYMENTTERMS", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "PAYMENT_TERMS");

				labelBox.put("findByPaymentTermsGubun", searchService.SmallCodeLovList(params));

				// 수주구분
				requestMap.put("SOTYPE", "A");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SO_TYPE");

				labelBox.put("findBySoTypeGubun", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

				System.out.println("showMoldManagePage requestMap >>>>>>>>>>" + requestMap);
				String userid = loVo.getId();
				if (!groupid.equals("ROLE_ADMIN")) {
					// 로그인 사용자명
					requestMap.put("uniqId", loVo.getId());
					requestMap.put("groupId", groupid);

					params.put("ROLEUSER", loVo.getId());
					List<?> userList2 = dao.list("search.login.name.lov.select", params);
					Map<String, Object> userData2 = (Map<String, Object>) userList2.get(0);
					String employeenumber = StringUtil.nullConvert(userData2.get("VALUE"));
					String krname = StringUtil.nullConvert(userData2.get("LABEL"));

					requestMap.put("employeenumber", employeenumber);
					requestMap.put("krname", krname);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/manage/OrderManageRegist";
	}

	/**
	 * 수주등록 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/manage/OrderManageRegistMaster.do")
	@ResponseBody
	public Object insertOrderManageRegistMaster(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertOrderManageRegistMaster Params. >>>>>>>>>> " + params);

		return OrderManageService.insertOrderManageStateListMasterList(params);
	}

	/**
	 * 수주등록 // 디테일 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/manage/OrderManageRegistDetail.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertOrderManageRegistDetail(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertOrderManageRegistDetail Params. >>>>>>>>>> " + params);

		mav.addObject("result", OrderManageService.insertOrderManageStateListDetailList(params));
		System.out.println("insertOrderManageRegistDetail End. >>>>>>>>>> " + mav);
		return mav;
	}

	/**
	 * 수주등록 // 마스터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/manage/OrderManageRegistMaster.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateOrderManageRegistMaster(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateOrderManageRegistMaster Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = OrderManageService.updateOrderManageStateListMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 수주등록 // 디테일 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/manage/OrderManageRegistDetail.do", method = RequestMethod.POST)
	public ModelAndView updateOrderManageRegistDetail(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateOrderManageRegistDetail Start. >>>>>>>>>> " + params);

		mav.addObject("result", OrderManageService.updateOrderManageStateListDetailList(params));
		return mav;
	}

	/**
	 * 수주등록 // 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/manage/OrderManageRegistMaster.do")
	@ResponseBody
	public Object deleteOrderManageRegistMaster(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteOrderManageRegistMaster Start. >>>>>>>>>> " + params);

		return OrderManageService.deleteOrderManageStateListMasterList(params);
	}

	/**
	 * 수주등록 // 디테일 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */

	@RequestMapping(value = "/delete/order/manage/OrderManageRegistDetail.do")
	@ResponseBody
	public Object deleteOrderManageRegistDetail(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deletePurchaseRequestEtcRegistList Params. >>>>>>>>>> " + params);

		return OrderManageService.deleteOrderManageStateListDetailList(params);
	}

	/**
	 * 주문현황조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/manage/OrderStateList.do")
	public String showOrderStateListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		String temp = loVo.getAuthCode();
		String title = "수주";
				
		if(temp.equals("ROLE_SCM_R")){
			title = "주문";
		}
		
		model.addAttribute("pageTitle", title + "현황조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOrderStateListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
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

			// 수주구분
			
			requestMap.put("SOTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "OM");
			params.put("MIDDLECD", "SO_TYPE");

			labelBox.put("findBySoTypeGubun", searchService.SmallCodeLovList(params));

			// 수주상태
			requestMap.put("SOSTATUS", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "OM");
			params.put("MIDDLECD", "SO_STATUS");

			labelBox.put("findBySoStatusGubun", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showOrderStateListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showOrderStateListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/manage/OrderStateList";
	}

	/**
	 * 주문현황조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/manage/OrderStateList.do")
	@ResponseBody
	public Object selectOrderStateList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOrderStateList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

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
			extGrid.setTotcnt(OrderManageService.selectOrderStateListCount(params));
			extGrid.setData(OrderManageService.selectOrderStateList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOrderStateList End. >>>>>>>>>> ");
		return extGrid;
	}
	

	/**
	 * 단가적용 // 프로시저 호출
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/pkg/order/manage/UnitPriceManage.do")
	@ResponseBody
	public Object callUnitPriceManage(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("callUnitPriceManage Params. >>>>>>>>>> " + params);

		return OrderManageService.callUnitPriceManage(params);
	}

}