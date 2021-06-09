package kr.co.bps.scs.equipment.manage;

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
 * @ClassName : ManageEquipmentControllerController.java
 * @Description : ManageEquipment Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2020. 12.
 * @version 1.0
 * @see 설비 관리
 * 
 */
@Controller
public class ManageEquipmentController extends BaseController {

	@Autowired
	private ManageEquipmentService ManageEquipmentService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 설비수리 이력등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/equipment/manage/EquipmentRepairRegist.do")
	public String showEquipmentRepairRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "설비수리 이력등록");
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();

			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showEquipmentRepairRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("PREDATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
				requestMap.put("DATESYS", dummy.get("DATESYS"));
			}

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

		return "/equipment/manage/EquipmentRepairRegist";
	}

	/**
	 * 설비 관리 > 수리내역 // 그리드 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/equipment/manage/EquipmentRepairList.do")
	@ResponseBody
	public Object selectEquipmentRepairListGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectEquipmentRepairListGrid Start. >>>>>>>>>> " + params);
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

			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if ( gubun.equals("REGIST") ) {
				String datefrom = StringUtil.nullConvert(params.get("DATEFROM"));
				if ( datefrom.isEmpty() ) {
					count++;
				}

				String dateto = StringUtil.nullConvert(params.get("DATETO"));
				if ( dateto.isEmpty() ) {
					count++;
				}
			} else {
				String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
				if ( workcentercode.isEmpty() ) {
					count++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(ManageEquipmentService.selectEquipmentRepairCount(params));
			extGrid.setData(ManageEquipmentService.selectEquipmentRepairList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectEquipmentRepairListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 설비 관리 > 수리내역 // 그리드 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/equipment/manage/EquipmentRepairList.do")
	@ResponseBody
	public Object insertEquipmentRepairList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertEquipmentRepairList Start. >>>>>>>>>> " + params);

		return ManageEquipmentService.insertEquipmentRepairList(params);
	}

	/**
	 * 설비 관리 > 수리내역 // 그리드 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/equipment/manage/EquipmentRepairList.do")
	@ResponseBody
	public Object updateEquipmentRepairList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateEquipmentRepairList Start. >>>>>>>>>> " + params);

		return ManageEquipmentService.updateEquipmentRepairList(params);
	}

	/**
	 * 설비 관리 > 수리내역 // 그리드 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/equipment/manage/EquipmentRepairList.do")
	@ResponseBody
	public Object deleteEquipmentRepairList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteEquipmentRepairList Start. >>>>>>>>>> ");

		return ManageEquipmentService.deleteEquipmentRepairList(params);
	}
	
	
	/**
	 *  설비수리 이력현황(월별/라인별 수리금액) 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/equipment/manage/EquipmentRepairList.do")
	public String EquipmentRepairListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "설비수리 이력현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("equipment.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("EquipmentRepairListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEMONTH"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			// 로그인 사용자의 org company 정보 
			System.out.println("EquipmentRepairList loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("EquipmentRepairList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("EquipmentRepairList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("EquipmentRepairList orgid. >>>>>>>>>>" + orgid);
			System.out.println("EquipmentRepairList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 EquipmentRepairList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					model.addAttribute("ORGID", "1");
				} else {
					System.out.println("2 EquipmentRepairList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 EquipmentRepairList groupid. >>>>>>>>>>" + groupid);
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
					params.put("ORGID", 999);//임의의값
					params.put("COMPANYID", 999);//임의의값
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

		return "/equipment/manage/EquipmentRepairList";
	}

	/**
	 * 설비수리이력 현황 //요약 Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/equipment/manage/EquipmentRepairMaster.do")
	@ResponseBody
	public Object selectEquipmentRepairMasterGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectEquipmentRepairMasterGrid Start. >>>>>>>>>> " + params);
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
			
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
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
			extGrid.setData(ManageEquipmentService.selectEquipmentRepairMasterList(params));
			extGrid.setTotcnt(ManageEquipmentService.selectEquipmentRepairMasterCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectEquipmentRepairMasterGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}
	
	/**
	 * 설비수리이력 현황 //요약 Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/equipment/manage/EquipmentRepairLine.do")
	@ResponseBody
	public Object selectEquipmentRepairLineGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectEquipmentRepairLineGrid Start. >>>>>>>>>> " + params);
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
			
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
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
			extGrid.setData(ManageEquipmentService.selectEquipmentRepairLine(params));
			extGrid.setTotcnt(ManageEquipmentService.selectEquipmentRepairLineCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectEquipmentRepairListGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}
	
	/**
	 * 2017.03.28 매출 현황 상세 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/equipment/manage/EquipmentRepairDetailList.do")
	@ResponseBody
	public Object selectEquipmentRepairDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectEquipmentRepairDetailListGrid Start. >>>>>>>>>> " + params);
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
			
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
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
			extGrid.setData(ManageEquipmentService.selectEquipmentRepairDetailList(params));
			extGrid.setTotcnt(ManageEquipmentService.selectEquipmentRepairDetailCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectEquipmentRepairDetailListGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}

	/**
	 *  비가동 요약 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/equipment/manage/NonOperateList.do")
	public String showNonOperateListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "비가동 요약");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("equipment.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showNonOperateListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEMONTH"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			// 로그인 사용자의 org company 정보 
			System.out.println("NonOperateList loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("NonOperateList params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("NonOperateList groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("NonOperateList orgid. >>>>>>>>>>" + orgid);
			System.out.println("NonOperateList companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 NonOperateList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					model.addAttribute("ORGID", "1");
				} else {
					System.out.println("2 NonOperateList groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 NonOperateList groupid. >>>>>>>>>>" + groupid);
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
					params.put("ORGID", 999);//임의의값
					params.put("COMPANYID", 999);//임의의값
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

		return "/equipment/manage/NonOperateList";
	}

	/**
	 * 설비수리이력 현황 //요약 Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/equipment/manage/NonOperateList.do")
	@ResponseBody
	public Object selectNonOperateListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectNonOperateMasterGrid Start. >>>>>>>>>> " + params);
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
			
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
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
			extGrid.setData(ManageEquipmentService.selectNonOperateMasterList(params));
			extGrid.setTotcnt(ManageEquipmentService.selectNonOperateMasterCount(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectNonOperateMasterGrid End. >>>>>>>>>> " + extGrid);
		return extGrid;
	}
}