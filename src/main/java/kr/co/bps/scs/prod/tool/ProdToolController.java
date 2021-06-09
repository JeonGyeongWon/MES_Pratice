package kr.co.bps.scs.prod.tool;

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
 * @ClassName : ProdToolController.java
 * @Description : ProdToolController class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 07.
 * @version 1.0
 * @see 치공구 관리
 * 
 */
@Controller
public class ProdToolController extends BaseController {

	@Autowired
	private ProdToolService prodToolService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 치공구 반출 현황
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/tool/ToolOutList.do")
	public String showProdToolOutListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "치공구 반출 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdToolOutListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdToolOutListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdToolOutListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdToolOutListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdToolOutListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdToolOutListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdToolOutListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdToolOutListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showProdToolOutListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdToolOutListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdToolOutListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 showProdToolOutListPage groupid. >>>>>>>>>>" + groupid);
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

			// 반출상태
			requestMap.put("STATUS", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "TOOL_STATUS");
			params.put("GUBUN", "TOOL_STATUS");

			labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/tool/ToolOutList";
	}

	/**
	 * 치공구 반출 MASTER 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/tool/ToolOutList.do")
	@ResponseBody
	public Object selectToolOutListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectToolOutListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.isEmpty()) {

				String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
				if (searchfrom.isEmpty()) {
					count++;
				}

				String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
				if (searchto.isEmpty()) {
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
			extGrid.setTotcnt(prodToolService.selectToolOutMasterCount(params));
			extGrid.setData(prodToolService.selectToolOutMasterList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolOutListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 치공구 반출 DETAIL 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/tool/ToolOutDetail.do")
	@ResponseBody
	public Object selectToolOutDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectToolOutDetailGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String outno = StringUtil.nullConvert(params.get("OUTNO"));
			if (outno.isEmpty()) {
				String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
				if (searchfrom.isEmpty()) {
					count++;
				}

				String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
				if (searchto.isEmpty()) {
					count++;
				}
				List<?> masterList = null;
				masterList = dao.list("prod.tool.out.header.first.select", params);
				System.out.println("masterList >>>>>>>>>> " + masterList);

				if (masterList.size() > 0) {
					HashMap<String, Object> masterMap = (HashMap<String, Object>) masterList.get(0);
					params.put("ORGID", masterMap.get("ORGID"));
					params.put("COMPANYID", masterMap.get("COMPANYID"));
					params.put("OUTNO", masterMap.get("OUTNO"));

				} else {
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
			extGrid.setTotcnt(prodToolService.selectToolOutDetailCount(params));
			extGrid.setData(prodToolService.selectToolOutDetailList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolOutDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 치공구 반출 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/tool/ToolOutManage.do")
	public String showToolOutManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showToolOutManagePage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			String outno = StringUtil.nullConvert(requestMap.get("no"));
			System.out.println("0 showToolOutManagePage outno. >>>>>>>>>>" + outno);

			if (!outno.isEmpty()) {
				// 번호가 있을 경우 상세 조회
				model.addAttribute("pageTitle", "치공구 반출 상세 / 수정");
				model.addAttribute("gubun", "MODIFY");

				// 번호 받았을 경우
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showToolOutManagePage org. >>>>>>>>>>" + org);
				System.out.println("2 showToolOutManagePage company. >>>>>>>>>>" + company);
				requestMap.put("OUTNO", outno); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));

				// 상태구분
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "MFG");
				params.put("MIDDLECD", "TOOL_STATUS");
				params.put("GUBUN", "TOOL_STATUS");

				labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

			} else {
				// 번호가 없을 경우 등록
				model.addAttribute("pageTitle", "치공구 반출등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showToolOutManagePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showToolOutManagePage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showToolOutManagePage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 요청번호 없을 경우 
				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showToolOutManagePage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showToolOutManagePage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showToolOutManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showToolOutManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
					}
				} else {
					System.out.println("3 showToolOutManagePage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showToolOutManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showToolOutManagePage groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
					}
				} else {
					System.out.println("6 showToolOutManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				// 상태구분
				requestMap.put("ORDERDIV", "01");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MFG");
				params.put("MIDDLECD", "TOOL_STATUS");
				params.put("GUBUN", "TOOL_STATUS");

				labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

				System.out.println("9 showToolOutManagePage groupid. >>>>>>>>>>" + groupid);
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

				System.out.println("0 showToolOutManagePage outno. >>>>>>>>>>" + outno);

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/tool/ToolOutManage";
	}

	/**
	 * 치공구 반출 등록 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/tool/ToolOutList.do")
	@ResponseBody
	public Object insertToolOutList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertToolOutList Params. >>>>>>>>>> " + params);

		return prodToolService.insertToolOutList(params);
	}

	/**
	 * 치공구 반출 등록 상세 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/tool/ToolOutDetail.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertToolOutDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertToolOutDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodToolService.insertToolOutDetailList(params));
		return mav;
	}

	/**
	 * 치공구 반출 변경 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/tool/ToolOutList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateToolOutList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateToolOutList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = prodToolService.updateToolOutList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 치공구 반출 삭제 // 마스터 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/tool/ToolOutList.do")
	@ResponseBody
	public Object deleteToolOutList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteToolOutList Params. >>>>>>>>>> " + params);

		return prodToolService.deleteToolOutList(params);
	}

	/**
	 * 치공구 반출 변경 // 상세 Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/tool/ToolOutDetail.do", method = RequestMethod.POST)
	public ModelAndView updateToolOutDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateToolOutDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodToolService.updateToolOutDetailList(params));
		return mav;
	}

	/**
	 * 치공구 반출 상세 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/tool/ToolOutDetail.do")
	@ResponseBody
	public Object deleteToolOutDetailList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteToolOutDetailList Start. >>>>>>>>>> " + params);

		return prodToolService.deleteToolOutDetailList(params);
	}

	/**
	 * 치공구 반입 현황
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/tool/ToolInList.do")
	public String showProdToolInListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "치공구 반입 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdToolInListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdToolInListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdToolInListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdToolInListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdToolInListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdToolInListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdToolInListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdToolInListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showProdToolInListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdToolInListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdToolInListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 showProdToolInListPage groupid. >>>>>>>>>>" + groupid);
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

			// 반출상태
//			requestMap.put("STATUS", "");
//			params.put("ORGID", result_org);
//			params.put("COMPANYID", result_comp);
//			params.put("BIGCD", "MFG");
//			params.put("MIDDLECD", "TOOL_STATUS");
//			params.put("GUBUN", "TOOL_STATUS");
//
//			labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/tool/ToolInList";
	}

	/**
	 * 치공구 반입 MASTER 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/tool/ToolInList.do")
	@ResponseBody
	public Object selectToolInListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectToolInListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.isEmpty()) {

				String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
				if (searchfrom.isEmpty()) {
					count++;
				}

				String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
				if (searchto.isEmpty()) {
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
			extGrid.setTotcnt(prodToolService.selectToolInMasterCount(params));
			extGrid.setData(prodToolService.selectToolInMasterList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolInListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 치공구 반입 DETAIL 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/tool/ToolInDetail.do")
	@ResponseBody
	public Object selectToolInDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectToolInDetailGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String inno = StringUtil.nullConvert(params.get("INNO"));
			if (inno.isEmpty()) {
				String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
				if (searchfrom.isEmpty()) {
					count++;
				}

				String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
				if (searchto.isEmpty()) {
					count++;
				}
				List<?> masterList = null;
				masterList = dao.list("prod.tool.in.header.first.select", params);
				System.out.println("masterList >>>>>>>>>> " + masterList);

				if (masterList.size() > 0) {
					HashMap<String, Object> masterMap = (HashMap<String, Object>) masterList.get(0);
					params.put("ORGID", masterMap.get("ORGID"));
					params.put("COMPANYID", masterMap.get("COMPANYID"));
					params.put("INNO", masterMap.get("INNO"));

				} else {
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
			extGrid.setTotcnt(prodToolService.selectToolInDetailCount(params));
			extGrid.setData(prodToolService.selectToolInDetailList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolInDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 치공구 반입 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/tool/ToolInManage.do")
	public String showToolInManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showToolInManagePage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			String inno = StringUtil.nullConvert(requestMap.get("no"));
			System.out.println("0 showToolInManagePage inno. >>>>>>>>>>" + inno);

			if (!inno.isEmpty()) {
				// 번호가 있을 경우 상세 조회
				model.addAttribute("pageTitle", "치공구 반입 상세 / 수정");
				model.addAttribute("gubun", "MODIFY");

				// 번호 받았을 경우
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showToolInManagePage org. >>>>>>>>>>" + org);
				System.out.println("2 showToolInManagePage company. >>>>>>>>>>" + company);
				requestMap.put("INNO", inno); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));

				// 상태구분
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "MFG");
				params.put("MIDDLECD", "TOOL_STATUS");
				params.put("GUBUN", "TOOL_STATUS");

				labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

			} else {
				// 번호가 없을 경우 등록
				model.addAttribute("pageTitle", "치공구 반입등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showToolInManagePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showToolInManagePage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showToolInManagePage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 요청번호 없을 경우 
				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showToolInManagePage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showToolInManagePage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showToolInManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showToolInManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
					}
				} else {
					System.out.println("3 showToolInManagePage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showToolInManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showToolInManagePage groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
					}
				} else {
					System.out.println("6 showToolInManagePage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				// 상태구분
				requestMap.put("ORDERDIV", "01");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MFG");
				params.put("MIDDLECD", "TOOL_STATUS");
				params.put("GUBUN", "TOOL_STATUS");

				labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

				System.out.println("9 showToolInManagePage groupid. >>>>>>>>>>" + groupid);
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

				System.out.println("0 showToolInManagePage inno. >>>>>>>>>>" + inno);

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/tool/ToolInManage";
	}

	/**
	 * 치공구 반입 등록 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/tool/ToolInList.do")
	@ResponseBody
	public Object insertToolInList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertToolInList Params. >>>>>>>>>> " + params);

		return prodToolService.insertToolInList(params);
	}

	/**
	 * 치공구 반입 등록 상세 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/tool/ToolInDetail.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertToolInDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertToolInDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodToolService.insertToolInDetailList(params));
		return mav;
	}

	/**
	 * 치공구 반입 변경 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/tool/ToolInList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateToolInList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateToolInList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = prodToolService.updateToolInList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 치공구 반입 삭제 // 마스터 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/tool/ToolInList.do")
	@ResponseBody
	public Object deleteToolInList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteToolInList Params. >>>>>>>>>> " + params);

		return prodToolService.deleteToolInList(params);
	}

	/**
	 * 치공구 반입 변경 // 상세 Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/tool/ToolInDetail.do", method = RequestMethod.POST)
	public ModelAndView updateToolInDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateToolInDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodToolService.updateToolInDetailList(params));
		return mav;
	}

	/**
	 * 치공구 반입 상세 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/tool/ToolInDetail.do")
	@ResponseBody
	public Object deleteToolInDetailList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteToolInDetailList Start. >>>>>>>>>> " + params);

		return prodToolService.deleteToolInDetailList(params);
	}


	/**
	 * 치공구 반출/회수 현황
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/tool/ToolInOutList.do")
	public String showProdToolInOutListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "치공구 반출/회수 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdToolInOutListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdToolInOutListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdToolInOutListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdToolInOutListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdToolInOutListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdToolInOutListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdToolInOutListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdToolInOutListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showProdToolInOutListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdToolInOutListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdToolInOutListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 showProdToolInOutListPage groupid. >>>>>>>>>>" + groupid);
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

			// 반출상태
			requestMap.put("STATUS", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "TOOL_STATUS");
			params.put("GUBUN", "TOOL_STATUS");

			labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/tool/ToolInOutList";
	}

	/**
	 * 치공구 반출/회수 현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/tool/ToolInOutList.do")
	@ResponseBody
	public Object selectToolInOutListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectToolInOutListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String searchdate = StringUtil.nullConvert(params.get("SEARCHDATE"));
			if (searchdate.isEmpty()) {
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
			extGrid.setTotcnt(prodToolService.selectToolInOutCount(params));
			extGrid.setData(prodToolService.selectToolInOutList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolInOutListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

}