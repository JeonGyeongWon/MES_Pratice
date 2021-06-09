package kr.co.bps.scs.order.trans;

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

/**
 * @ClassName : TransDetailController.java
 * @Description : TransDetail Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsHwang
 * @since 2017. 11.
 * @version 1.0
 * @see
 * 
 */
@Controller
public class TransDetailController extends BaseController {

	@Autowired
	private TransDetailService TransDetailService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 거래명세서 관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/trans/TransDetailList.do")
	public String showTransDetailListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "거래명세서 관리");

		Map<String, List> labelBox = new HashMap<String, List>();

		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showTransDetailListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showTransDetailListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showTransDetailListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showTransDetailListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showTransDetailListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showTransDetailListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showTransDetailListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showTransDetailListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 showTransDetailListPage groupid. >>>>>>>>>>" + groupid);
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

		return "/order/trans/TransDetailList";
	}

	/**
	 * 거래명세서 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/trans/TransDetailRegist.do")
	public String showTransDetailRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "거래명세서 등록");
		System.out.println("showTransDetailRegistPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 데이터 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showTransDetailRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("datefrom", dummy.get("DATEFROM"));
				requestMap.put("dateto", dummy.get("DATETO"));
				requestMap.put("TODAY", dummy.get("DATESYS"));
			}

			String tradeno = StringUtil.nullConvert(requestMap.get("TRADENO"));
			if (!tradeno.isEmpty()) {
				// 거래명세서 번호가 있을 경우 상세
				model.addAttribute("pageTitle", "거래명세서 상세 / 수정");

				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showTransDetailRegistPage org. >>>>>>>>>>" + org);
				System.out.println("2 showTransDetailRegistPage company. >>>>>>>>>>" + company);
				requestMap.put("TRADENO", tradeno);
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));
				
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("TRADENO", tradeno);
				List<?> ReportCnt = dao.selectListByIbatis("report.transaction.sub1.select", params);
				
				requestMap.put("reportsize", ReportCnt.size());				
				System.out.println("reportsize >>>>>>>>>> " + ReportCnt.size());

				//				// 인도장소
				//				requestMap.put("WORKAREA", "");
				//				params.put("ORGID", org);
				//				params.put("COMPANYID", company);
				//				params.put("BIGCD", "CMM");
				//				params.put("MIDDLECD", "DELIVERY_PLACE");
				//
				//				labelBox.put("findByDeliveryPlaceGubun", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);
			} else {
				// 거래명세서 번호가 없을 경우 등록
				model.addAttribute("pageTitle", "거래명세서 등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showTransDetailRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showTransDetailRegistPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showTransDetailRegistPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showTransDetailRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showTransDetailRegistPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showTransDetailRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showTransDetailRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
					}
				} else {
					System.out.println("3 showTransDetailRegistPage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showTransDetailRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showTransDetailRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
					}
				} else {
					System.out.println("6 showTransDetailRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				// 인도장소
				//				requestMap.put("WORKAREA", "");
				//				params.put("ORGID", result_org);
				//				params.put("COMPANYID", result_comp);
				//				params.put("BIGCD", "CMM");
				//				params.put("MIDDLECD", "DELIVERY_PLACE");
				//
				//				labelBox.put("findByDeliveryPlaceGubun", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

				System.out.println("showTransDetailRegistPage requestMap >>>>>>>>>>" + requestMap);
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

		return "/order/trans/TransDetailRegist";
	}

	/**
	 * 거래명세서 // Grid Master 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/trans/TransDetailMasterList.do")
	@ResponseBody
	public Object selectTransDetailMasterListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectTransDetailMasterListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(TransDetailService.selectTransDetailMasterTotcnt(params));
			extGrid.setData(TransDetailService.selectTransDetailMasterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectTransDetailMasterListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 거래명세서 // Grid Detail 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/trans/TransDetailDetailList.do")
	@ResponseBody
	public Object selectTransDetailDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectTransDetailDetailListGrid params >>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String tradeno = StringUtil.nullConvert(params.get("TRADENO"));
			if (tradeno.isEmpty()) {
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
			extGrid.setTotcnt(TransDetailService.selectTransDetailDetailTotcnt(params));
			extGrid.setData(TransDetailService.selectTransDetailDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectTransDetailDetailListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 거래명세서 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/trans/TransDetailMasterList.do")
	@ResponseBody
	public Object insertTransDetailMasterList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertTransDetailMasterList Params. >>>>>>>>>> " + params);

		return TransDetailService.insertTransDetailMasterList(params);
	}

	/**
	 * 거래명세서 // 디테일 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/trans/TransDetailDetailList.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertTransDetailDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertTransDetailDetailList Params. >>>>>>>>>> " + params);

		mav.addObject("result", TransDetailService.insertTransDetailDetailList(params));
		return mav;
	}

	/**
	 * 거래명세서 // 마스터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/trans/TransDetailMasterList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateTransDetailMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateTransDetailMasterList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = TransDetailService.updateTransDetailMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 거래명세서 // 디테일 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/trans/TransDetailDetailList.do", method = RequestMethod.POST)
	public ModelAndView updateTransDetailDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateTransDetailDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", TransDetailService.updateTransDetailDetailList(params));
		return mav;
	}

	/**
	 * 거래명세서 // 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/trans/TransDetailMasterList.do")
	@ResponseBody
	public Object deleteTransDetailMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteTransDetailMasterList Start. >>>>>>>>>> " + params);

		return TransDetailService.deleteTransDetailMasterList(params);
	}

	/**
	 * 거래명세서 // 디테일 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */

	@RequestMapping(value = "/delete/order/trans/TransDetailDetailList.do")
	@ResponseBody
	public Object deleteTransDetailDetailList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteTransDetailDetailList Params. >>>>>>>>>> " + params);

		return TransDetailService.deleteTransDetailDetailList(params);
	}

	/**
	 * 거래명세서 발행현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/trans/TransDetailStatus.do")
	public String showTransDetailStatusPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "거래명세서 발행현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println(" Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("predateSys", dummy.get("PREDATESYS"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
				requestMap.put("predateFrom", dummy.get("PREDATEFROM"));
				requestMap.put("predateTo", dummy.get("PREDATETO"));
				requestMap.put("postdateFrom", dummy.get("POSTDATEFROM"));
				requestMap.put("postdateTo", dummy.get("POSTDATETO"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			
			// 로그인 사용자의 org company 정보 
			System.out.println(" loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println(" params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println(" groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println(" orgid. >>>>>>>>>>" + orgid);
				System.out.println(" companyid. >>>>>>>>>>" + companyid);

				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1  groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					}else {
						System.out.println("2  groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID",999 );
					}
				}else {
					System.out.println("3  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", orgid );
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				
				List<?> orgList = (List<?>) searchService.OrgLovList(params);
				HashMap<String, Object> orgMap = (HashMap<String,Object>) orgList.get(0);
				
				String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
				System.out.println("3-1. orgid >>>>>>>>>> " + result_org);
				
				if  (companyid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					}else {
						System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999 );
						params.put("COMPANYID", 999 );
					}
				}else {
					System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid );
					params.put("COMPANYID", companyid );
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String,Object>) compList.get(0);
				
				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);
				
				model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/trans/TransDetailStatus";
	}
	
	/**
	 * 거래명세서 발행현황 // Grid Master 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/trans/TransDetailStatus.do")
	@ResponseBody
	public Object selectTransDetailStatusListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectTransDetailStatusListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(TransDetailService.selectTransDetailStatusTotcnt(params));
			extGrid.setData(TransDetailService.selectTransDetailStatusList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectTransDetailStatusListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 거래명세서 // 마감일자(이월) 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/trans/TransDetailStatus.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateTransDetailStatusList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateTransDetailStatusList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = TransDetailService.updateTransDetailStatus(params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}