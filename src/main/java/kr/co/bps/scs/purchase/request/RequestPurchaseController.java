package kr.co.bps.scs.purchase.request;

import java.util.ArrayList;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : RequestPurchaseController.java
 * @Description : RequestPurchase Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 07.
 * @version 1.0
 * @see 자재관리
 * 
 */
@Controller
public class RequestPurchaseController extends BaseController {

	@Autowired
	private RequestPurchaseService requestPurchaseService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	private ArrayList<MultipartFile> uploadFile;

	/**
	 * 구매요청 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/purchase/request/PurchaseRequestList.do")
	public String showPurchaseRequestListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "구매요청 조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("purchase.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showPurchaseRequestListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
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

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/purchase/request/PurchaseRequestList";
	}

	
	/**
	 * 자재요청상세현황조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/purchase/request/PurchaseRequestDetailList.do")
	public String showPurchaseRequestDetailListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "자재요청상세현황조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("purchase.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showPurchaseRequestListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 사업부분/현장명
			requestMap.put("WORKAREA", "");
			params.put("BIGCD", "OM");
			params.put("MIDDLECD", "WORK_AREA");
			params.put("GUBUN", "WORKAREA");

			labelBox.put("findByWorkArea", searchService.SmallCodeLovList(params));

			// 요청부서
			requestMap.put("REQDEPTCODE", "");
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "DEPT_CODE");
			params.put("GUBUN", "REQDEPTCODE");

			labelBox.put("findByReqDeptCode", searchService.SmallCodeLovList(params));

			// 구분
			requestMap.put("USEDIV", "");
			params.put("BIGCD", "MAT");
			params.put("MIDDLECD", "USE_DIV");
			params.put("GUBUN", "USEDIV");

			labelBox.put("findByUseDiv", searchService.SmallCodeLovList(params));

			// 원/부/소/기타
			requestMap.put("ITEMTYPE", "");
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");
			params.put("GROUPCD", "M");
			params.put("GUBUN", "ITEMTYPE");

			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/purchase/request/PurchaseRequestDetailList";
	}
	
	/**
	 * 구매요청 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/purchase/request/PurchaseRequestManage.do")
	public String showPurchaseRequestManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "구매요청 관리");

		System.out.println("showPurchaseRequestManagePage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			// 2. 배송방법 ( Default : 화물 )
			String porno = StringUtil.nullConvert(requestMap.get("PORNO"));

			if (!porno.isEmpty()) {
				// 요청번호가 있을 경우 상세 조회
			} else {
				// 요청번호가 없을 경우 등록
				HashMap<String, Object> params = new HashMap<String, Object>();

				// 로그인 사용자의 org company 정보
				System.out.println("showPurchaseRequestListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showPurchaseRequestListPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showPurchaseRequestListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				//데이터 조회 처리
				System.out.println("showPurchaseRequestManagePage RequestMap. >>>>>>>>>>" + requestMap);
				String reqno = StringUtil.nullConvert(requestMap.get("reqno"));

				// 요청번호 없을 경우 
				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showPurchaseRequestListPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showPurchaseRequestListPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showPurchaseRequestListPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					} else {
						System.out.println("2 showPurchaseRequestListPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); //임의의값
					}
				} else {
					System.out.println("3 showPurchaseRequestListPage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showPurchaseRequestListPage groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						//params.put("ORGID", orgid );
						//params.put("COMPANYID", companyid );
					} else {
						System.out.println("5 showPurchaseRequestListPage groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);//임의의값
						params.put("COMPANYID", 999);//임의의값
					}
				} else {
					System.out.println("6 showPurchaseRequestListPage groupid. >>>>>>>>>>" + groupid);
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

				// 1. 상태
				requestMap.put("STATUS", "STAND_BY");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MAT");
				params.put("MIDDLECD", "STATUS");
				params.put("GUBUN", "STATUS");

				labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

				// 2. 구분
				requestMap.put("USEDIV", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MAT");
				params.put("MIDDLECD", "USE_DIV");
				params.put("GUBUN", "USE_DIV");
				//		     	params.put("USEDIVTYPE", "ETC");
				//		     	params.put("USEDIV1", "A");
				//		     	params.put("USEDIV2", "B");

				labelBox.put("findByUseDiv", searchService.SmallCodeLovList(params));

				// 기종
				requestMap.put("MODEL", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "MODEL");
				params.put("GUBUN", "MODEL");

				labelBox.put("findByModel", searchService.SmallCodeLovList(params));

				// 세액구분
				requestMap.put("TAXDIV", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "TAX_DIV");
				params.put("GUBUN", "TAXDIV");

				labelBox.put("findByTaxDiv", searchService.SmallCodeLovList(params));

				if (reqno.equals("") || "".equals(reqno)) {

				} else {
					// 요청번호 받았을 경우
					String org = StringUtil.nullConvert(requestMap.get("org"));
					String company = StringUtil.nullConvert(requestMap.get("company"));
					System.out.println("6 showPurchaseRequestListPage org. >>>>>>>>>>" + org);
					System.out.println("6 showPurchaseRequestListPage company. >>>>>>>>>>" + company);
					requestMap.put("REQUESTNO", reqno);
					requestMap.put("ORGID", org);
					requestMap.put("COMPANYID", company);
					labelBox.put("findByOrgId", searchService.OrgLovList(params));
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
				}

				model.addAttribute("labelBox", labelBox);

				System.out.println("9 showPurchaseRequestListPage groupid. >>>>>>>>>>" + groupid);
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

		return "/purchase/request/PurchaseRequestManage";
	}

	/**
	 * 구매요청현황 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/purchase/request/PurchaseRequestList.do")
	@ResponseBody
	public Object selectPurchaseRequestListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectPurchaseRequestListGrid Start. >>>>>>>>>> " + params);
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


			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.equals("LIST")) {

				String pofrom = StringUtil.nullConvert(params.get("REQFROM"));
				if (pofrom.isEmpty()) {
					count++;
				}

				String poto = StringUtil.nullConvert(params.get("REQTO"));
				if (poto.isEmpty()) {
					count++;
				}
			} else {
				String porno = StringUtil.nullConvert(params.get("PORNO"));
				if (porno.isEmpty()) {
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
			extGrid.setTotcnt(requestPurchaseService.selectRequestPurchaseCount(params));
			extGrid.setData(requestPurchaseService.selectRequestPurchaseList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectPurchaseRequestListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 구매요청등록 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/purchase/request/PurchaseRequestManage.do")
	@ResponseBody
	public Object insertPurchaseRequestManageList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertPurchaseRequestManageList Params. >>>>>>>>>> " + params);

		return requestPurchaseService.insertPurchaseRequestManageList(params);
	}

	/**
	 * 구매요청 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/purchase/request/PurchaseRequestManage.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updatePurchaseRequestManageList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updatePurchaseRequestManageList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = requestPurchaseService.updatePurchaseRequestManageList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 구매요청 삭제 // 마스터
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/purchase/request/PurchaseRequestManage.do")
	@ResponseBody
	public Object deletePurchaseRequestManageList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deletePurchaseRequestManageList Params. >>>>>>>>>> " + params);

		return requestPurchaseService.deletePurchaseRequestManageList(params);
	}

	
	/**
	 * 구매요청현황내역 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/purchase/request/PurchaseRequestDetailList.do")
	@ResponseBody
	public Object selectPurchaseRequestDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectPurchaseRequestDetailListGrid Start. >>>>>>>>>> " + params);
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

			String porno = StringUtil.nullConvert(params.get("PORNO"));
			if (porno.isEmpty()) {
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
			extGrid.setTotcnt(requestPurchaseService.selectRequestPurchaseDetailCount(params));
			extGrid.setData(requestPurchaseService.selectRequestPurchaseDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectPurchaseRequestDetailListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 구매요청등록 상세 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/purchase/request/PurchaseRequestEtcMaster.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertPurchaseRequestEtcMasterList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertPurchaseRequestEtcMasterList Start. >>>>>>>>>> " + params);

		mav.addObject("result", requestPurchaseService.insertPurchaseRequestEtcMasterList(params));
		return mav;
	}

	/**
	 * 구매요청등록 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/purchase/request/PurchaseRequestEtcMaster.do", method = RequestMethod.POST)
	public ModelAndView updatePurchaseRequestEtcMasterList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updatePurchaseRequestEtcMasterList Start. >>>>>>>>>> " + params);

		mav.addObject("result", requestPurchaseService.updatePurchaseRequestEtcMasterList(params));
		return mav;
	}

	/**
	 * 구매요청등록 상세 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/purchase/request/PurchaseRequestEtcMaster.do")
	@ResponseBody
	public Object deletePurchaseRequestEtcMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deletePurchaseRequestEtcMasterList Start. >>>>>>>>>> " + params);

		return requestPurchaseService.deletePurchaseRequestEtcMasterList(params);
	}

	/**
	 * 구매요청 // 상태변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/change/purchase/request/PurchaseRequestStatus.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object changePurchaseRequestStatus(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("changePurchaseRequestStatus Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = requestPurchaseService.changePurchaseRequestStatus(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

}