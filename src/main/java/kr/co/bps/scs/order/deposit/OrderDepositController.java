package kr.co.bps.scs.order.deposit;

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
 * @ClassName : OrderDepositController.java
 * @Description : OrderDeposit Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 10.
 * @version 1.0
 * @see 수금관리
 */
@Controller
public class OrderDepositController extends BaseController {

	@Autowired
	private OrderDepositService OrderDepositService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 수금등록관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/deposit/DepositList.do")
	public String showOrderDepositListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "수금 등록관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {

			Map<String, ?> fm = RequestContextUtils.getInputFlashMap(super.request);
			if (fm != null && !fm.isEmpty()) {
				model.addAllAttributes(fm);
			}

			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("deposit.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOrderDepositListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showOrderDepositListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showOrderDepositListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showOrderDepositListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showOrderDepositListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
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

			// 수금상태
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

		return "/order/deposit/DepositList";
	}

	/**
	 * 수금관리 // Grid Master 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/deposit/OrderDepositListMaster.do")
	@ResponseBody
	public Object selectOrderDepositListMasterGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOrderDepositListMasterGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(OrderDepositService.selectOrderDepositListMasterCount(params));
			extGrid.setData(OrderDepositService.selectOrderDepositListMasterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOrderDepositListMasterGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 수금관리 // Grid Detail 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/deposit/OrderDepositListDetail.do")
	@ResponseBody
	public Object selectOrderDepositListDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOrderDepositListDetailGrid params >>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;

		try {
			String taxno = StringUtil.nullConvert(params.get("TAXINVOICENO"));
			if (taxno.isEmpty()) {
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
			extGrid.setTotcnt(OrderDepositService.selectOrderDepositListDetailCount(params));
			extGrid.setData(OrderDepositService.selectOrderDepositListDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOrderDepositListDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	

	/**
	 * 수금관리 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/deposit/DepositRegist.do")
	public String showOrderDepositRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "수금 상세/등록");
		System.out.println("showOrderDepositListPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 데이터 가져오기
			List dummyList = dao.selectListByIbatis("deposit.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOrderDepositListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
			}

			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			String taxno = StringUtil.nullConvert(requestMap.get("TAXINVOICENO"));
			if (!taxno.isEmpty()) {
				// 수금번호가 있을 경우 상세
				model.addAttribute("pageTitle", "수금 상세 / 수정");

				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showOrderDepositListPage org. >>>>>>>>>>" + org);
				System.out.println("2 showOrderDepositListPage company. >>>>>>>>>>" + company);
				requestMap.put("TAXINVOICENO", taxno);
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));

				// 방향
				requestMap.put("DIRECTIONGUBUN", "01");
				params.put("ORGID", org );
				params.put("COMPANYID", company );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "DIRECTION");

				labelBox.put("findByDirection", searchService.SmallCodeLovList(params));
				
				// 입/출구분
				requestMap.put("SALESBUYGUBUN", "01");
				params.put("ORGID", org );
				params.put("COMPANYID", company );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SALES_BUY_TYPE");

				labelBox.put("findBySalesBuyType", searchService.SmallCodeLovList(params));

				// 과세구분
				requestMap.put("TAXGUBUN", "01");
				params.put("ORGID", org );
				params.put("COMPANYID", company );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "TAX_TYPE");

				labelBox.put("findByTaxType", searchService.SmallCodeLovList(params));

				// 영수/청구
				requestMap.put("CHARGEGUBUN", "01");
				params.put("ORGID", org );
				params.put("COMPANYID", company );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "CHARGE_TYPE");

				labelBox.put("findByChargeType", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);
			} else {
				// 금형코드가 없을 경우 등록
				model.addAttribute("pageTitle", "수금등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showOrderDepositListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showOrderDepositListPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showOrderDepositListPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showOrderDepositListPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
					}
				} else {
					System.out.println("3 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
					}
				} else {
					System.out.println("6 showOrderDepositListPage groupid. >>>>>>>>>>" + groupid);
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

				System.out.println("showMoldDepositPage requestMap >>>>>>>>>>" + requestMap);
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
				
				// 방향
				requestMap.put("DIRECTIONGUBUN", "01");
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "DIRECTION");

				labelBox.put("findByDirection", searchService.SmallCodeLovList(params));
				
				// 입/출구분
				requestMap.put("SALESBUYGUBUN", "01");
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SALES_BUY_TYPE");

				labelBox.put("findBySalesBuyType", searchService.SmallCodeLovList(params));

				// 과세구분
				requestMap.put("TAXGUBUN", "01");
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "TAX_TYPE");

				labelBox.put("findByTaxType", searchService.SmallCodeLovList(params));

				// 영수/청구
				requestMap.put("CHARGEGUBUN", "01");
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "CHARGE_TYPE");

				labelBox.put("findByChargeType", searchService.SmallCodeLovList(params));
				

				model.addAttribute("labelBox", labelBox);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/deposit/DepositRegist";
	}

	/**
	 * 수금등록 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/deposit/OrderDepositRegistMaster.do")
	@ResponseBody
	public Object insertOrderDepositRegistMaster(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertOrderDepositRegistMaster Params. >>>>>>>>>> " + params);

		return OrderDepositService.insertOrderDepositRegistMasterRegist(params);
	}

	/**
	 * 수금등록 // 디테일 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/deposit/OrderDepositRegistDetail.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertOrderDepositRegistDetail(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertOrderDepositRegistDetail Params. >>>>>>>>>> " + params);

		mav.addObject("result", OrderDepositService.insertOrderDepositRegistDetailRegist(params));
		System.out.println("insertOrderDepositRegistDetail End. >>>>>>>>>> " + mav);
		return mav;
	}

	/**
	 * 수금등록 // 마스터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/deposit/OrderDepositRegistMaster.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateOrderDepositRegistMaster(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateOrderDepositRegistMaster Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = OrderDepositService.updateOrderDepositRegistMasterRegist(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 수금등록 // 디테일 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/deposit/OrderDepositRegistDetail.do", method = RequestMethod.POST)
	public ModelAndView updateOrderDepositRegistDetail(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateOrderDepositRegistDetail Start. >>>>>>>>>> " + params);

		mav.addObject("result", OrderDepositService.updateOrderDepositRegistDetailRegist(params));
		return mav;
	}

	/**
	 * 수금등록 // 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/deposit/OrderDepositRegistMaster.do")
	@ResponseBody
	public Object deleteOrderDepositRegistMaster(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteOrderDepositRegistMaster Start. >>>>>>>>>> " + params);

		return OrderDepositService.deleteOrderDepositRegistMasterRegist(params);
	}

	/**
	 * 수금등록 // 디테일 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */

	@RequestMapping(value = "/delete/order/deposit/OrderDepositRegistDetail.do")
	@ResponseBody
	public Object deleteOrderDepositRegistDetail(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deletePurchaseRequestEtcRegistRegist Params. >>>>>>>>>> " + params);

		return OrderDepositService.deleteOrderDepositRegistDetailRegist(params);
	}
	/**
	 * 수금등록관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/deposit/ReceivableStateList.do")
	public String showReceivableStateListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "미수금 현황 조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {

			Map<String, ?> fm = RequestContextUtils.getInputFlashMap(super.request);
			if (fm != null && !fm.isEmpty()) {
				model.addAllAttributes(fm);
			}

			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("deposit.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showReceivableStateListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showReceivableStateListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showReceivableStateListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showReceivableStateListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showReceivableStateListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showReceivableStateListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showReceivableStateListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 showReceivableStateListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 showReceivableStateListPage groupid. >>>>>>>>>>" + groupid);
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

			// 수금상태
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

		return "/order/deposit/ReceivableStateList";
	}

	/**
	 * 미수금현황조회 // Grid Master 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/deposit/ReceivableStateList.do")
	@ResponseBody
	public Object selectReceivableStateListMasterGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectReceivableStateListMasterGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(OrderDepositService.selectReceivableStateListMasterCount(params));
			extGrid.setData(OrderDepositService.selectReceivableStateListMasterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectReceivableStateListMasterGrid End. >>>>>>>>>> ");
		return extGrid;
	}
}