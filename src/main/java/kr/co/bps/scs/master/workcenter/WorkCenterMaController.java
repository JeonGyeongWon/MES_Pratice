package kr.co.bps.scs.master.workcenter;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : WorkCenterMaControllerController.java
 * @Description : WorkCenterMa Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 11.
 * @version 1.0
 * @see 설비 관리
 * 
 */
@Controller
public class WorkCenterMaController extends BaseController {

	@Autowired
	private WorkCenterMaService workCenterMaService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 작업장 관리 그리드 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/workcenter/WorkCenterMa.do")
	public String showWorkMaGridViewPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "설비 관리");
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();

			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

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

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/master/workcenter/WorkCenterMa";
	}

	/**
	 * 작업장 관리 그리드 // 모든 작업장 조회 처리
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/master/workcenter/WorkCenterMa.do")
	@ResponseBody
	public Object selectWorkMaGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectWorkMaGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(workCenterMaService.selectWorkCenterCount(params));
			extGrid.setData(workCenterMaService.selectWorkCenterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkMaGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 작업장 그리드 // 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/master/workcenter/WorkCenterMa.do")
	@ResponseBody
	public Object insertWorkCenterGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertWorkCenterGrid Start. >>>>>>>>>> " + params);

		return workCenterMaService.insertWorkCenterGrid(params);
	}

	/**
	 * 작업장 그리드 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/master/workcenter/WorkCenterMa.do")
	@ResponseBody
	public Object updateWorkCenterGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateWorkCenterGrid Start. >>>>>>>>>> " + params);

		return workCenterMaService.updateWorkCenterGrid(params);
	}

	/**
	 * 작업장 그리드 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/master/workcenter/WorkCenterMa.do")
	@ResponseBody
	public Object deleteWorkCenterGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteWorkCenterGrid Start. >>>>>>>>>> ");

		return workCenterMaService.deleteWorkCenterGrid(params);
	}

	/**
	 * 설비관리 // 설비이력관리 디테일 조회 처리
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/master/workcenter/WorkCenterRepairList.do")
	@ResponseBody
	public Object selectWorkCenterRepairList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectWorkCenterRepairList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
			if (workcentercode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(workCenterMaService.selectWorkCenterRepairCount(params));
			extGrid.setData(workCenterMaService.selectWorkCenterRepairList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkCenterRepairList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 설비관리 // 설비이력관리 디테일 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/master/workcenter/WorkCenterRepairList.do")
	@ResponseBody
	public Object insertWorkCenterRepairList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertWorkCenterRepairList Start. >>>>>>>>>> " + params);

		return workCenterMaService.insertWorkCenterRepairList(params);
	}

	/**
	 * 설비관리 // 설비이력관리 디테일 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/master/workcenter/WorkCenterRepairList.do")
	@ResponseBody
	public Object updateWorkCenterRepairList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateWorkCenterRepairList Start. >>>>>>>>>> " + params);

		return workCenterMaService.updateWorkCenterRepairList(params);
	}

	/**
	 * 설비관리 // 설비이력관리 디테일 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/master/workcenter/WorkCenterRepairList.do")
	@ResponseBody
	public Object deleteWorkCenterRepairList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteWorkCenterRepairList Start. >>>>>>>>>> " + params);

		return workCenterMaService.deleteWorkCenterRepairList(params);
	}

	/**
	 * 설비 I/F // 설비 인터페이스 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/master/workcenter/WorkCenterInterface.do")
	@ResponseBody
	public Object selectWorkCenterInterfaceGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectWorkCenterInterfaceGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(workCenterMaService.selectWorkCenterIFCount(params));
			extGrid.setData(workCenterMaService.selectWorkCenterIFList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkCenterInterfaceGrid End. >>>>>>>>>> ");
		return extGrid;
	}

}