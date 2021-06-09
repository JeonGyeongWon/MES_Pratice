package kr.co.bps.scs.order.prod;

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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : OrderProdController.java
 * @Description : OrderProd Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsHwang,
 * @since 2018. 02.
 * @version 1.0
 * @see 조회 - 제품수불현황
 * 
 */
@Controller
public class OrderProdController extends BaseController {

	@Autowired
	private OrderProdService orderProdService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 제품수불현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/prod/ProdInventoryList.do")
	public String showProdInventoryListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "제품수불현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdInventoryListPage Dummy. >>>>>>>>>>" + dummy);

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

			System.out.println("7. showProdInventoryListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showProdInventoryListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/prod/ProdInventoryList";
	}

	/**
	 * 제품수불현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/prod/ProdInventoryList.do")
	@ResponseBody
	public Object selectProdInventoryList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdInventoryList Start. >>>>>>>>>> " + params);
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
			String trxdate = StringUtil.nullConvert(params.get("TRXDATE"));
			if (trxdate.isEmpty()) {
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
			extGrid.setTotcnt(orderProdService.selectProdInventoryCount(params));
			extGrid.setData(orderProdService.selectProdInventoryList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdInventoryList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 출하관리 > 제품 입출고 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/prod/ProdRelList.do")
	public String showProdRelRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		System.out.println("showProdRelRegistPage Start. >>>>>>>>>> " + requestMap);

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "제품 기타 입출고 조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("dist.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdRelRegistPage Dummy. >>>>>>>>>>" + dummy);

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

			// 기타입출고 구분 값으로 제약
			requestMap.put("USEDIV", "");

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/prod/ProdRelList";
	}

	/**
	 * 출하관리 > 제품 입출고 // Grid Master 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/prod/ProdRelList.do")
	@ResponseBody
	public Object selectProdRelListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdRelListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchFrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchFrom.isEmpty()) {
				count++;
			}

			String searchTo = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchTo.isEmpty()) {
				count++;
			}

			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			//			String usediv = StringUtil.nullConvert(params.get("USEDIV"));
			//			if (usediv.isEmpty()) {
			//				count++;
			//			}
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
			extGrid.setTotcnt(orderProdService.selectProdRelCount(params));
			extGrid.setData(orderProdService.selectProdRelList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdRelListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 출하관리 > 제품입출고 // Grid 상세 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/prod/ProdRelListDetail.do")
	@ResponseBody
	public Object selectProdRelListDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdRelListDetailGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String releaseno = StringUtil.nullConvert(params.get("RELEASENO"));
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (!releaseno.isEmpty()) {
				System.out.println("releaseno >>>>>>>>> " + releaseno);
				System.out.println("orgid >>>>>>>>> " + orgid);
				System.out.println("companyid >>>>>>>>> " + companyid);
			} else {
				String gubun = StringUtil.nullConvert(params.get("GUBUN"));
				if (gubun.equals("LIST")) {
					// 조회 화면
					List<?> itemcodeList = null;
					// 제품입출고
					itemcodeList = dao.list("order.prod.release.detail.etc.first.select", params);

					System.out.println("itemcodeList >>>>>>>>>> " + itemcodeList);

					if (itemcodeList.size() > 0) {
						HashMap<String, Object> itemcodeMap = (HashMap<String, Object>) itemcodeList.get(0);
						params.put("releaseno", itemcodeMap.get("RELEASENO"));
						params.put("orgid", itemcodeMap.get("ORGID"));
						params.put("companyid", itemcodeMap.get("COMPANYID"));
					} else {
						count++;
					}
				} else {
					// 등록 화면
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
			extGrid.setTotcnt(orderProdService.selectProdRelDetailCount(params));
			extGrid.setData(orderProdService.selectProdRelDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdRelListDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 제품 입출고 등록 / 상세 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/prod/ProdRelManage.do")
	public String showProdRelManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showProdRelManagePage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			HashMap<String, Object> params = new HashMap<String, Object>();
			String relno = StringUtil.nullConvert(requestMap.get("relno"));
			if (!relno.isEmpty()) {
				model.addAttribute("pageTitle", "제품 기타 입출고 상세 / 변경");

				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showProdRelManagePage org. >>>>>>>>>>" + org);
				System.out.println("2 showProdRelManagePage company. >>>>>>>>>>" + company);
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				requestMap.put("RELEASENO", relno); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				// 1. 구분
				System.out.println("2 showProdRelManagePage usediv. >>>>>>>>>>" + relno.substring(0, 2));
				requestMap.put("USEDIV", relno.substring(0, 2));
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "USE_DIV");
				params.put("keyword", relno.substring(0, 2));
				labelBox.put("findByUseDiv", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);
			} else {
				model.addAttribute("pageTitle", "제품 기타 입출고 등록");

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

				// 1. 구분
				requestMap.put("USEDIV", "EP");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "USE_DIV");
//				params.put("keyword", "EP");
				labelBox.put("findByUseDiv", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

				// 로그인 사용자명
				requestMap.put("uniqId", loVo.getId());
				requestMap.put("groupId", groupid);

				if ( !groupid.equals("ROLE_ADMIN") ) {
					params.put("ROLEUSER", loVo.getId());
					List<?> userList2 = dao.list("search.login.name.lov.select", params);
					Map<String, Object> userData2 = (Map<String, Object>) userList2.get(0);
					String employeenumber = StringUtil.nullConvert(userData.get("VALUE"));
					String krname = StringUtil.nullConvert(userData.get("LABEL"));
					String deptcode = StringUtil.nullConvert(userData.get("DEPTCODE"));
					String deptname = StringUtil.nullConvert(userData.get("DEPTNAME"));

					requestMap.put("employeenumber", employeenumber);
					requestMap.put("krname", krname);
					requestMap.put("deptcode", deptcode);
					requestMap.put("deptname", deptname);	
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/prod/ProdRelRegist";
	}

	/**
	 * 기타입출고 / 이동출고 // Grid 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/prod/ProdRelManage.do")
	@ResponseBody
	public Object deleteProdRelManage(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteProdRelManage Params. >>>>>>>>>> " + params);

		return orderProdService.deleteProdRelManage(params);
	}

	/**
	 * 재고실사,조정처리 // Grid 화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/prod/ProdInvAdjustRegist.do")
	public String showProdInvAdjustRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "재고실사,조정처리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {

			Map<String, ?> fm = RequestContextUtils.getInputFlashMap(super.request);
			if (fm != null && !fm.isEmpty()) {
				model.addAllAttributes(fm);
			}

			List dummyList = dao.selectListByIbatis("dist.mat.start.month.sql.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdInvAdjustRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM");
				requestMap.put("dateFrom", dateto);
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			// 로그인 사용자의 org company 정보 
			System.out.println("showProdInvAdjustRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdInvAdjustRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdInvAdjustRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdInvAdjustRegistPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdInvAdjustRegistPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdInvAdjustRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					model.addAttribute("ORGID", "1");
				} else {
					System.out.println("2 showProdInvAdjustRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showProdInvAdjustRegistPage groupid. >>>>>>>>>>" + groupid);
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
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
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

		return "/order/prod/ProdInvAdjustRegist";
	}

	/**
	 * 재고실사,조정처리 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/prod/ProdInvAdjustRegist.do")
	@ResponseBody
	public Object selectProdInvAdjustRegistGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdInvAdjustRegistGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(orderProdService.ProdInvAdjustRegistListCnt(params));
			extGrid.setData(orderProdService.ProdInvAdjustRegistList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatInvAdjustRegistGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 재고실사,조정처리  // 조정처리
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/pkg/order/prod/ProdInvAdjustRegist.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Object callProdInvAdjustRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("callProdInvAdjustRegist Start. >>>>>>>>>> " + params);
		
		Object result = null;
		try {
    		result = orderProdService.callProdInvAdjustRegist(params);
    		System.out.println("callProdInvAdjustRegist result >>>>>>>>> " + result);
    		
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return result;
	}
	
}