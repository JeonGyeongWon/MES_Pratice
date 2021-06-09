package kr.co.bps.scs.prod.state;

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
 * @ClassName : ProdStateController.java
 * @Description : ProdState Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 08.
 * @version 1.0
 * @see 조회현황 - 작업자별 실적달성율
 * 
 */
@Controller
public class ProdStateController extends BaseController {

	@Autowired
	private ProdStateService ProdStateService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 작업자별 실적달성율 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/state/WorkerAccPerform.do")
	public String showShipStatusRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "작업자별 실적달성율");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdWorkTotalListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("Predate", dummy.get("YESTERDAY"));
			}
			
			HashMap<String, Object> params = new HashMap<String, Object>();
			
			// 로그인 사용자의 org company 정보 
			System.out.println("showShipStatusRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showShipStatusRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showShipStatusRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showShipStatusRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showShipStatusRegistPage companyid. >>>>>>>>>>" + companyid);

				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 showShipStatusRegistPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					}else {
						System.out.println("2 showShipStatusRegistPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID",999 ); //임의의값
					}
				}else {
					System.out.println("3 showShipStatusRegistPage groupid. >>>>>>>>>>" + groupid);
					// org
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
						// company
						requestMap.put("COMPANYID", "");
						//params.put("ORGID", orgid );
						//params.put("COMPANYID", companyid );
					}else {
						System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999 );//임의의값
						params.put("COMPANYID", 999 );//임의의값
					}
				}else {
					System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid );
					params.put("COMPANYID", companyid );
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String,Object>) compList.get(0);
				
				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);
				
				// 작업반
				requestMap.put("WORKDEPT", "");
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "WORK_DEPT");
				labelBox.put("findByWorkDeptGubun", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/state/WorkerAccPerform";
	}
	
	/**
	 * 작업자별 실적달성율 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/state/WorkerAccPerform.do")
	@ResponseBody
	public Object selectWorkerAccPerformListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectWorkerAccPerformListGrid Start. >>>>>>>>>> " + params);
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

			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if ( searchfrom.isEmpty() ) {
				count++;
			}

			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if ( searchto.isEmpty() ) {
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
			extGrid.setTotcnt(ProdStateService.WorkerAccPerformCnt(params));
			extGrid.setData(ProdStateService.WorkerAccPerformList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkerAccPerformListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 설비부하율 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/state/EquipLoadFactor.do")
	public String showEquipLoadFactorPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "설비부하율");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.week.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdWorkTotalListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("MONDAY"));
				requestMap.put("DATETO", dummy.get("SUNDAY"));
			}
			
			HashMap<String, Object> params = new HashMap<String, Object>();
			
			// 로그인 사용자의 org company 정보 
			System.out.println("showEquipLoadFactorPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showEquipLoadFactorPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showEquipLoadFactorPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showEquipLoadFactorPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showEquipLoadFactorPage companyid. >>>>>>>>>>" + companyid);

				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 showEquipLoadFactorPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					}else {
						System.out.println("2 showEquipLoadFactorPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID",999 ); //임의의값
					}
				}else {
					System.out.println("3 showEquipLoadFactorPage groupid. >>>>>>>>>>" + groupid);
					// org
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
						// company
						requestMap.put("COMPANYID", "");
						//params.put("ORGID", orgid );
						//params.put("COMPANYID", companyid );
					}else {
						System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999 );//임의의값
						params.put("COMPANYID", 999 );//임의의값
					}
				}else {
					System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
					// company
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

		return "/prod/state/EquipLoadFactor";
	}
	
	/**
	 * 설비부하율 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/state/EquipLoadFactor.do")
	@ResponseBody
	public Object selectEquipLoadFactorListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectEquipLoadFactorListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(ProdStateService.EquipLoadFactorTotcnt(params));
			extGrid.setData(ProdStateService.EquipLoadFactorList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectEquipLoadFactorListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
}