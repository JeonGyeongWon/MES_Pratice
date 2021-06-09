package kr.co.bps.scs.purchase.order;

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
 * @ClassName : PurchaseOrderController.java
 * @Description : PurchaseOrder Controller class
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
public class PurchaseOrderController extends BaseController {

	@Autowired
	private PurchaseOrderService purchaseorderService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 발주현황조회.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/purchase/order/PurchaseOrderRegist.do")
	public String showPurchaseOrderRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "구매발주 조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("purchase.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showPurchaseOrderRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showPurchaseOrderRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showPurchaseOrderRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showPurchaseOrderRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showPurchaseOrderRegistPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showPurchaseOrderRegistPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showPurchaseOrderRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showPurchaseOrderRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showPurchaseOrderRegistPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showPurchaseOrderRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showPurchaseOrderRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 showPurchaseOrderRegistPage groupid. >>>>>>>>>>" + groupid);
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

		return "/purchase/order/PurchaseOrderList";
	}

	/**
	 * 발주 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/purchase/order/PurchaseOrderList.do")
	@ResponseBody
	public Object selectPurchaseOrderListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectPurchaseOrderListGrid Start. >>>>>>>>>> " + params);
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
			
			String pofrom = StringUtil.nullConvert(params.get("POFROM"));
			if (pofrom.isEmpty()) {
				count++;
			}

			String poto = StringUtil.nullConvert(params.get("POTO"));
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
			extGrid.setTotcnt(purchaseorderService.selectPurchaseOrderCount(params));
			extGrid.setData(purchaseorderService.selectPurchaseOrderList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectPurchaseOrderListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 발주 상세 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/purchase/order/PurchaseOrderListDetail.do")
	@ResponseBody
	public Object selectPurchaseOrderListDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectPurchaseOrderListDetailGrid Start. >>>>>>>>>> " + params);
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
			
			String pono = StringUtil.nullConvert(params.get("PONO"));
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
			extGrid.setTotcnt(purchaseorderService.selectPurchaseOrderDetailCount(params));
			extGrid.setData(purchaseorderService.selectPurchaseOrderDetailList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectPurchaseOrderListDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 구매발주등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/purchase/order/PurchaseOrderManage.do")
	public String showPurchaseOrderManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showPurchaseOrderManagePage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			String pono = StringUtil.nullConvert(requestMap.get("PONO"));

			if (!pono.isEmpty()) {
				// 발주번호가 있을 경우 상세 조회
				model.addAttribute("pageTitle", "구매발주 상세 / 수정");
				model.addAttribute("gubun", "MODIFY");

				// 발주번호 받았을 경우
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showPurchaseOrderManagePage org. >>>>>>>>>>" + org);
				System.out.println("2 showPurchaseOrderManagePage company. >>>>>>>>>>" + company);
				requestMap.put("PONO", pono); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));

				// 세액구분
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "TAX_DIV");

				labelBox.put("findByTaxDivGubun", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

			} else {
				// 발주번호가 없을 경우 등록
				model.addAttribute("pageTitle", "구매발주등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showPurchaseOrderManagePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showPurchaseOrderManagePage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showPurchaseOrderManagePage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				//데이터 조회 처리
				System.out.println("showPurchaseOrderManagePage RequestMap. >>>>>>>>>>" + requestMap);
				String reqno = StringUtil.nullConvert(requestMap.get("reqno"));

				// 요청번호 없을 경우 
				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showPurchaseOrderManagePage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showPurchaseOrderManagePage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showPurchaseOrderManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showPurchaseOrderManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
					}
				} else {
					System.out.println("3 showPurchaseOrderManagePage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showPurchaseOrderManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showPurchaseOrderManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
					}
				} else {
					System.out.println("6 showPurchaseOrderManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				// 세액구분
				requestMap.put("TAXDIV", "01");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "TAX_DIV");

				labelBox.put("findByTaxDivGubun", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

				System.out.println("9 showPurchaseOrderManagePage groupid. >>>>>>>>>>" + groupid);
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
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/purchase/order/PurchaseOrderRegist";
	}

	/**
	 * 구매발주 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/purchase/order/PurchaseOrderMaster.do")
	@ResponseBody
	public Object insertPurchaseOrderMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertPurchaseOrderMasterList Params. >>>>>>>>>> " + params);

		return purchaseorderService.insertPurchaseOrderMasterList(params);
	}

	/**
	 * 구매발주 // 상세 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/purchase/order/PurchaseOrderDetail.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertPurchaseOrderDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertPurchaseOrderDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", purchaseorderService.insertPurchaseOrderDetailList(params));
		return mav;
	}

	/**
	 * 구매발주 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/purchase/order/PurchaseOrderMaster.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updatePurchaseOrderMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updatePurchaseOrderMasterList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = purchaseorderService.updatePurchaseOrderMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 구매발주 // 상태변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/change/purchase/order/PurchaseOrderStatus.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object changePurchaseOrderStatus(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("changePurchaseOrderStatus Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = purchaseorderService.changePurchaseOrderStatus(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 구매발주 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/purchase/order/PurchaseOrderDetail.do", method = RequestMethod.POST)
	public ModelAndView updatePurchaseOrderDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updatePurchaseOrderDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", purchaseorderService.updatePurchaseOrderDetailList(params));
		return mav;
	}

	/**
	 * 구매발주 상세 // 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/purchase/order/PurchaseOrderListDetail.do")
	@ResponseBody
	public Object deletePurchaseOrderListDetail(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deletePurchaseOrderListDetail Params. >>>>>>>>>> " + params);

		return purchaseorderService.deletePurchaseOrderListDetail(params);
	}

	/**
	 * 구매발주 마스터 // 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/purchase/order/PurchaseOrderRegist.do")
	@ResponseBody
	public Object deletePurchaseOrderRegistList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deletePurchaseOrderRegistList Params. >>>>>>>>>> " + params);

		return purchaseorderService.deletePurchaseOrderRegistList(params);
	}

	/**
	 * 2017.02.23 구매발주 화면에서 요청서불러오기 // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/PurchaseOrderPop1.do")
	@ResponseBody
	public Object PurchaseOrderPop1(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("PurchaseOrderPop1 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			//			// 필수 조건 미입력시 제약
			//			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			//			if (groupcode.isEmpty()) {
			//				count++;
			//			}
			//
			//			String bigcode = StringUtil.nullConvert(params.get("BIGCODE"));
			//			if (bigcode.isEmpty()) {
			//				count++;
			//			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(purchaseorderService.PurchaseOrderPop1TotCnt(params));
			extGrid.setData(purchaseorderService.PurchaseOrderPop1List(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("PurchaseOrderPop1 End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 구매발주의 단가적용 Package
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/pkg/purchase/order/PurchaseOrderPriceDefault.do")
	@ResponseBody
	public Object PkgPurchasePriceDefault(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("PkgPurchasePriceDefault Params. >>>>>>>>>> " + params);

		return purchaseorderService.PkgPurchasePriceDefault(params);
	}
}