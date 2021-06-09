package kr.co.bps.scs.scm.trade;

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
 * @ClassName : ScmTradeController.java
 * @Description : ScmTrade Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2021. 02.
 * @version 1.0
 * @see SCM관리 - 외주 거래명세서 관리
 * 
 */
@Controller
public class ScmTradeController extends BaseController {

	@Autowired
	private ScmTradeService ScmTradeService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 외주 거래명세서 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/trade/OutProcTradeList.do")
	public String showOutProcTradeListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "외주 거래명세서 등록");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("scm.mat.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOutProcTradeListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showOutProcTradeListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showOutProcTradeListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showOutProcTradeListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showOutProcTradeListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showOutProcTradeListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showOutProcTradeListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 1);
				} else {
					System.out.println("2 showOutProcTradeListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 1); //임의의값
				}
			} else {
				System.out.println("3 showOutProcTradeListPage groupid. >>>>>>>>>>" + groupid);
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
					params.put("ORGID", 1);
					params.put("COMPANYID", 1);
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 1);//임의의값
					params.put("COMPANYID", 1);//임의의값
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

			if (groupid.equals("ROLE_ADMIN") || groupid.equals("ROLE_MANAGER")) {
				requestMap.put("CustomerCode", "");
			} else {
				// 현재 사용자의 회사명, ID 조회
				params.put("ROLEUSER", loVo.getId());
				List<?> CustomerList = dao.list("scm.search.customid.select", params);
				System.out.println("4. CustomerData >>>>>>>>>> " + CustomerList);
				if (CustomerList.size() > 0) {
					Map<String, Object> CustomerData = (Map<String, Object>) CustomerList.get(0);
					String CustomerCode = StringUtil.nullConvert(CustomerData.get("VALUE"));
					String CustomerName = StringUtil.nullConvert(CustomerData.get("LABEL"));
					requestMap.put("CustomerCode", CustomerCode);
					requestMap.put("CustomerName", CustomerName);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/scm/trade/OutProcTradeList";
	}

	/**
	 * 외주 거래명세서 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/trade/OutProcTradeMasterList.do")
	@ResponseBody
	public Object selectOutProcTradeMasterListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcTradeMasterListGrid Start. >>>>>>>>>> " + params);
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

				String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
				if (searchfrom.isEmpty()) {
					count++;
				}

				String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
				if (searchto.isEmpty()) {
					count++;
				}

			} else {

				String tradeno = StringUtil.nullConvert(params.get("TRADENO"));
				if (tradeno.isEmpty()) {
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
			extGrid.setTotcnt(ScmTradeService.selectOutProcTradeMasterTotCnt(params));
			extGrid.setData(ScmTradeService.selectOutProcTradeMasterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutProcTradeMasterListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주 거래명세서 내역 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/trade/OutProcTradeDetailList.do")
	@ResponseBody
	public Object selectOutProcTradeDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcTradeDetailListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			String tradeno = StringUtil.nullConvert(params.get("TRADENO"));
			if (!tradeno.isEmpty()) {
				System.out.println("orgid >>>>>>>>> " + orgid);
				System.out.println("companyid >>>>>>>>> " + companyid);
				System.out.println("tradeno >>>>>>>>> " + tradeno);
			} else {
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
			extGrid.setTotcnt(ScmTradeService.selectOutProcTradeDetailTotCnt(params));
			extGrid.setData(ScmTradeService.selectOutProcTradeDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutProcTradeDetailListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주 거래명세서 등록/수정 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/trade/OutProcTradeManage.do")
	public String showOutProcTradeManage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("OutProcTradeManage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("scm.mat.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("OutProcTradeManage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println(" params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			//데이터 조회 처리
			System.out.println("RequestMap. >>>>>>>>>>" + requestMap);
			String no = StringUtil.nullConvert(requestMap.get("no"));

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("orgid. >>>>>>>>>>" + orgid);
			System.out.println("companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", 1);
					params.put("ORGID", 1);
				}
			} else {
				System.out.println("3  groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", 1);
					params.put("ORGID", 1);
					params.put("COMPANYID", 1);
				}
			} else {
				System.out.println("6  groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			if (no.equals("") || "".equals(no)) {
				model.addAttribute("pageTitle", "외주 거래명세서 등록");
			} else {
				// 요청번호 받았을 경우
				model.addAttribute("pageTitle", "외주 거래명세서 상세/수정");
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				String tradedate = StringUtil.nullConvert(requestMap.get("tradedate"));
				System.out.println("6 org. >>>>>>>>>>" + org);
				System.out.println("6 company. >>>>>>>>>>" + company);
				requestMap.put("TRADENO", no); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
				
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("TRADENO", no);
				params.put("TRADEDATE",tradedate);
				List<?> ReportCnt = dao.selectListByIbatis("report.scm.out.transaction.sub1.select", params);
				
				requestMap.put("reportsize", ReportCnt.size());				
				System.out.println("reportsize >>>>>>>>>> " + ReportCnt.size());
			}

			model.addAttribute("labelBox", labelBox);

			if (groupid.equals("ROLE_ADMIN") || groupid.equals("ROLE_MANAGER")) {
				requestMap.put("CustomerCode", "");
			} else {
				// 현재 사용자의 회사명, ID 조회
				params.put("ROLEUSER", loVo.getId());
				List<?> CustomerList = dao.list("scm.search.customid.select", params);
				System.out.println("4. CustomerData >>>>>>>>>> " + CustomerList);
				if (CustomerList.size() > 0) {
					Map<String, Object> CustomerData = (Map<String, Object>) CustomerList.get(0);
					String CustomerCode = StringUtil.nullConvert(CustomerData.get("VALUE"));
					String CustomerName = StringUtil.nullConvert(CustomerData.get("LABEL"));
					requestMap.put("CustomerCode", CustomerCode);
					requestMap.put("CustomerName", CustomerName);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/scm/trade/OutProcTradeManage";
	}

	/**
	 * 외주 거래명세서 등록 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/trade/OutProcTradeMasterList.do")
	@ResponseBody
	public Object insertOutProcTradeMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertOutProcTradeMasterList Params. >>>>>>>>>> " + params);

		return ScmTradeService.insertOutProcTradeMasterList(params);
	}

	/**
	 * 외주 거래명세서 등록 // 상세 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/trade/OutProcTradeDetailList.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertOutProcTradeDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertOutProcTradeDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", ScmTradeService.insertOutProcTradeDetailList(params));
		return mav;
	}

	/**
	 * 외주 거래명세서 등록 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/trade/OutProcTradeMasterList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateOutProcTradeMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateOutProcTradeMasterList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = ScmTradeService.updateOutProcTradeMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 외주 거래명세서 등록 // 상세 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/trade/OutProcTradeDetailList.do", method = RequestMethod.POST)
	public ModelAndView updateOutProcTradeDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateOutProcTradeDetailList Start. >>>>>>>>>> " + params);
		mav.addObject("result", ScmTradeService.updateOutProcTradeDetailList(params));
		return mav;
	}

	/**
	 * 외주 거래명세서 등록 // 마스터 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/scm/trade/OutProcTradeMasterList.do")
	@ResponseBody
	public Object deleteOutProcTradeMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteMatTradeMasterList Params. >>>>>>>>>> " + params);

		return ScmTradeService.deleteOutProcTradeMasterList(params);
	}

	/**
	 * 외주 거래명세서 등록 // 상세 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/scm/trade/OutProcTradeDetailList.do")
	@ResponseBody
	public Object deleteOutProcTradeDetailList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteOutProcTradeDetailList Start. >>>>>>>>>> " + params);

		return ScmTradeService.deleteOutProcTradeDetailList(params);
	}
}