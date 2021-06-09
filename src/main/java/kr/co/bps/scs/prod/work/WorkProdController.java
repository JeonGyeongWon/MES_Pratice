package kr.co.bps.scs.prod.work;

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

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : WorkProdController.java
 * @Description : WorkProd Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jmpark, ymha
 * @since 2016. 12.
 * @version 1.0
 * @see 생산관리 > 공정관리 - 1. 작업지시투입관리 - 2. 작업지시완료/마감
 * 
 */
@Controller
public class WorkProdController extends BaseController {

	@Autowired
	private WorkProdService workProdService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 작업지시투입관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/work/WorkOrderStart.do")
	public String showWorkOrderStartPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "작업지시 투입관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showWorkOrderStartPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
				requestMap.put("LastDate", dummy.get("LASTDATE"));
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
			// 상태
			requestMap.put("STATUS", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "STATUS");
			//params.put("GUBUN", "STATUS");

			labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

			// 상태
			requestMap.put("WORKTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "WORK_TYPE");
			//params.put("GUBUN", "STATUS");

			labelBox.put("findByWorkType", searchService.SmallCodeLovList(params));

			// 기종
			requestMap.put("MODEL", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "MODEL");
			params.put("GUBUN", "MODEL");

			labelBox.put("findByModel", searchService.SmallCodeLovList(params));
			
			// 대분류
			requestMap.put("BIGCODE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("GROUPCODE", "A");
			params.put("GUBUN", "ORDER BY");

			labelBox.put("findByBigNmType", searchService.BigClassLovList(params));

			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			List dateList = dao.selectListByIbatis("prod.work.startdate.select", params);
			Map<String, Object> maxdate = (Map<String, Object>) dateList.get(0);
			System.out.println("showWorkOrderStartPage maxdate. >>>>>>>>>> " + maxdate);

			if (maxdate.size() > 0) {
				// 더미 사용
				requestMap.put("dateMax", maxdate.get("WORKSTARTDATE"));
			}

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/work/WorkProdStart";
	}

	/**
	 * 작업지시투입관리 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/work/WorkProdStart.do")
	@ResponseBody
	public Object selectWorkProdStartGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWorkProdStartGrid Start. >>>>>>>>>> " + params);
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
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(workProdService.selectWorkProdCount(params));
			extGrid.setData(workProdService.selectWorkProdList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkProdStartGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2016.12.01 작업지시투입관리 // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/work/WorkProdStart.do")
	@ResponseBody
	public Object insertWorkProdStart(@RequestParam HashMap<String, Object> params) throws Exception {

		return workProdService.insertWorkProdStart(params);
	}

	/**
	 * 2016.12.01 작업지시투입관리 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/work/WorkProdStart.do")
	@ResponseBody
	public Object updatetWorkProdStart(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetWorkProdStart Start. >>>>>>>>>> " + params);
		Object result = null;
		try {
			result = workProdService.updateWorkProdStart(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2016.12.01 작업지시투입관리 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/work/WorkProdStart.do")
	@ResponseBody
	public Object deleteWorkProdStart(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteWorkProdStart >>>>>>>>>> " + params);
		return workProdService.deleteWorkProdStart(params);
	}

	
	/**
	 * 작업지시투입관리 상세 // 상태 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/work/WorkProdStartMonth.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updatetWorkProdStartMonth(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updatetWorkProdStartMonth Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = workProdService.updatetWorkProdStartMonth(params);
			System.out.println("updatetWorkProdStartMonth result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
	
	/**
	 * 2017.01.04 작업지시투입관리 내역 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/work/WorkProdStartD.do")
	@ResponseBody
	public Object selectWorkProdStartDGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWorkProdStartDGrid Start. >>>>>>>>>> " + params);
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

			String workorderid = StringUtil.nullConvert(params.get("WORKORDERID"));
			if (workorderid.isEmpty()) {
				System.out.println("selectWorkProdStartDGrid 3 >>>>>>>>> " + workorderid);
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
			extGrid.setTotcnt(workProdService.selectWorkProdDCount(params));
			extGrid.setData(workProdService.selectWorkProdDList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkProdStartDGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2017.01.04 작업지시투입관리 DETAIL // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/work/WorkProdStartD.do")
	@ResponseBody
	public Object insertWorkProdStartD(@RequestParam HashMap<String, Object> params) throws Exception {

		return workProdService.insertWorkProdStartD(params);
	}

	/**
	 * 2017.01.04 작업지시투입관리 DETAIL// 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/work/WorkProdStartD.do")
	@ResponseBody
	public Object updatetWorkProdStartD(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetWorkProdStartD Start. >>>>>>>>>> " + params);
		Object result = null;
		try {
			result = workProdService.updateWorkProdStartD(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2017.01.04 작업지시투입관리 DETAIL// 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/work/WorkProdStartD.do")
	@ResponseBody
	public Object deleteWorkProdStartD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteWorkProdStartD >>>>>>>>>> " + params);
		return workProdService.deleteWorkProdStartD(params);
	}

	/**
	 * 작업지시투입관리 // 상태 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/work/WorkProdStatus.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateWorkProdStatus(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateWorkProdStatus Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = workProdService.updateWorkProdStatus(params);
			System.out.println("updateWorkProdStatus result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 작업지시투입관리 상세 // 상태 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/work/WorkProdDetailStatus.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateWorkProdDetailStatus(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateWorkProdDetailStatus Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = workProdService.updateWorkProdDetailStatus(params);
			System.out.println("updateWorkProdDetailStatus result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2017.04.19 작업지시투입관리 // 초중종 생성(버튼)
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/fml/prod/work/WorkProdStart.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object fmlWorkProdStart(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("fmlWorkProdStart Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = workProdService.fmlWorkProdStart(params);
			System.out.println("fmlWorkProdStart result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 작업지시 완료 / 마감 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/work/WorkOrderEnd.do")
	public String showWorkOrderEndPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("showWorkOrderEndPage Start. >>>>>>>>>>" + requestMap);

		model.addAttribute("pageTitle", "작업지시 완료 / 마감");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showWorkOrderEndPage Dummy. >>>>>>>>>>" + dummy);

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

			// 상태
			requestMap.put("STATUS", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "STATUS");
			//params.put("GUBUN", "STATUS");

			labelBox.put("findByStatus", searchService.SmallCodeLovList(params));

			// 상태
			requestMap.put("WORKTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "WORK_TYPE");
			//params.put("GUBUN", "STATUS");

			labelBox.put("findByWorkType", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/work/WorkOrderEnd";
	}

	/**
	 * 작업지시 완료 / 마감 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/work/WorkOrderEnd.do")
	@ResponseBody
	public Object selectWorkOrderEndGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWorkOrderEndGrid Start. >>>>>>>>>> " + params);
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
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(workProdService.selectWorkOrderEndCount(params));
			extGrid.setData(workProdService.selectWorkOrderEndList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkOrderEndGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2017.01.23 작업지시완료/마감 내역 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/work/WorkOrderEndD.do")
	@ResponseBody
	public Object selectWorkOrderEndDGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWorkOrderEndDGrid Start. >>>>>>>>>> " + params);
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

			String workorderid = StringUtil.nullConvert(params.get("WORKORDERID"));
			if (workorderid.isEmpty()) {
				System.out.println("selectWorkOrderEndDGrid 3 >>>>>>>>> " + workorderid);
				
				List<?> workList = dao.list("prod.work.end.list.first.select", params);
				System.out.println("workList >>>>>>>>>> " + workList);
				
				if ( workList.size() > 0 ) {
					System.out.println("workList size >>>>>>>>>> " + workList.size() );
					HashMap<String, Object> itemMap = (HashMap<String, Object>) workList.get(0);
					System.out.println("itemMap >>>>>>>>>> " + itemMap);
					if (itemMap.size() > 0) {
						params.put("ORGID", itemMap.get("ORGID"));
						params.put("COMPANYID", itemMap.get("COMPANYID"));
						params.put("WORKORDERID", itemMap.get("WORKORDERID"));
					} else {
						count++;
					}
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
			extGrid.setTotcnt(workProdService.selectWorkEndDCount(params));
			extGrid.setData(workProdService.selectWorkEndDList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkProdStartDGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 작업지시 완료/마감 // 상태 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/work/WorkProdEndStatus.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateWorkProdEndStatus(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateWorkProdEndStatus Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = workProdService.updateWorkProdEndStatus(params);
			System.out.println("updateWorkProdEndStatus result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 작업지시 COPY // 데이터 생성
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/work/WorkOrderCopy.do")
	@ResponseBody
	public Object insertWorkOrderCopy(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertWorkOrderCopy Params. >>>>>>>>>> " + params);

		return workProdService.insertWorkOrderCopy(params);
	}

	/**
	 * 작업지시 투입현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/work/WorkOrderEquipmentList.do")
	public String showWorkOrderEquipmentListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "작업지시 투입현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showWorkOrderEquipmentListPage Dummy. >>>>>>>>>>" + dummy);

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
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999);
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
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
			
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			
			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/work/WorkOrderEquipmentList";
	}

	/**
	 * 작업지시투입현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/work/WorkOrderEquipmentList.do")
	@ResponseBody
	public Object selectWorkOrderEquipmentListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWorkOrderEquipmentListGrid Start. >>>>>>>>>> " + params);
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
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(workProdService.selectWorkOrderEquipmentCount(params));
			extGrid.setData(workProdService.selectWorkOrderEquipmentList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkOrderEquipmentListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 작업지시 -> 생산계획 -> 수주 연결 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/work/WorkOrderEquipmentList.do")
	@ResponseBody
	public Object updateWorkOrderEquipmentList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateWorkOrderEquipmentList Params. >>>>>>>>>> " + params);

		return workProdService.updateWorkOrderEquipmentList(params);
	}

}