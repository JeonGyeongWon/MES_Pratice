package kr.co.bps.scs.prod.process;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.file.FileService;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.NumberUtil;
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
 * @ClassName : ProdProcessController.java
 * @Description : ProdProcess Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 11. @modify 2017. 01.
 * @version 1.0
 * @see 공정시작관리 / 공정실적관리
 * 
 */
@Controller
public class ProdProcessController extends BaseController {

	@Autowired
	private ProdProcessService prodProcessService;

	@Autowired
	private searchService searchService;

	@Autowired
	private FileService fileService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 생산관리 > 공정관리 > 공정시작관리 ( 첫번째 ) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/ProcessStart.do")
	public String showProcessStartPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "공정시작관리");
		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 에러메시지 표시
			String errorcode = StringUtil.nullConvert(requestMap.get("err"));
			if (!errorcode.isEmpty()) {
				model.addAttribute("errCode", errorcode);
			}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProcessStartPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProcessStartPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProcessStartPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			switch (groupid) {
			case "ROLE_EQUIPMENT":
				// 설비권한일 경우
				List<?> equipList = dao.list("search.equipment.login.lov.select", params);

				System.out.println("1. showProcessStartPage size >>>>>>>>>>>> " + equipList.size());
				if (equipList.size() > 0) {
					Map<String, Object> equipData = (Map<String, Object>) equipList.get(0);

					// 더미 사용
					String orgid = StringUtil.nullConvert(equipData.get("ORGID"));
					String companyid = StringUtil.nullConvert(equipData.get("COMPANYID"));
					String workdept = StringUtil.nullConvert(equipData.get("WORKDEPT"));
					String workcentercode = StringUtil.nullConvert(equipData.get("WORKCENTERCODE"));
					System.out.println("showProcessStartPage orgid >>>>>>>>>>>> " + orgid);
					System.out.println("showProcessStartPage companyid >>>>>>>>>>>> " + companyid);
					System.out.println("showProcessStartPage workdept >>>>>>>>>>>> " + workdept);
					System.out.println("showProcessStartPage workcentercode >>>>>>>>>>>> " + workcentercode);

					requestMap.put("WORKDEPT", workdept);
					requestMap.put("WORKCENTERCODE", workcentercode);
				}

				break;
			default:
				// 그 외 권한

				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		requestMap.put("ORGID", 1);
		requestMap.put("COMPANYID", 1);
		requestMap.put("BIGCD", "CMM");
		requestMap.put("MIDDLECD", "WORK_DEPT");
		requestMap.put("ATTRIBUTE2", loVo.getId());
		List<?> workdeptlist = dao.list("search.smallcode.lov.select", requestMap);
		System.out.println("1. showProcessStartPage size >>>>>>>>>>>> " + workdeptlist.size());
		if (workdeptlist.size() > 0) {
			Map<String, Object> workdeptdata = (Map<String, Object>) workdeptlist.get(0);
			
			return "redirect:/prod/process/selectWorkOrderRegist.do?type=14&gubun="+workdeptdata.get("VALUE")+"&work=Y" ;
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/process/ProcessStart";
	}

	/**
	 * 생산관리 > 공정관리 > 공정시작 / 실적 ( 2.5번째 ) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/selectWorkDeptList.do")
	public String showWorkDeptListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 에러메시지 표시
			String errorcode = StringUtil.nullConvert(requestMap.get("err"));
			if (!errorcode.isEmpty()) {
				model.addAttribute("errCode", errorcode);
			}

			String type = StringUtil.nullConvert(requestMap.get("type"));
			if (type.isEmpty()) {
				// 존재하지 않는 메뉴를 선택하였을 경우?
				return "redirect:/prod/process/ProcessStart.do?err=1";
			} else {
				switch (type) {
				case "1":
					// 1. 공정시작
					model.addAttribute("pageTitle", "공정관리");
					break;
				case "7":
					// 7. 공구변경 등록
					model.addAttribute("pageTitle", "공구변경 등록");
					break;
				case "14":
					// 14. 생산실적
					model.addAttribute("pageTitle", "생산실적 등록");
					break;
				default:
					// 그 밖의 예외 상황

					break;
				}

				// 로그인 사용자의 ORG Company 정보 
				System.out.println("showWorkDeptListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showWorkDeptListPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showWorkDeptListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showWorkDeptListPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showWorkDeptListPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showWorkDeptListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showWorkDeptListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); // 임의의 값
					}
				} else {
					System.out.println("3 showWorkDeptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", orgid);
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));

				if (companyid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("4 showWorkDeptListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showWorkDeptListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999); // 임의의 값
						params.put("COMPANYID", 999); // 임의의 값
					}
				} else {
					System.out.println("6 showWorkDeptListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				model.addAttribute("labelBox", labelBox);

				System.out.println("7. showWorkDeptListPage params >>>>>>>>>>>> " + params);
				System.out.println("8. showWorkDeptListPage requestMap >>>>>>>>>>>> " + requestMap);
				List<?> workList = dao.list("search.work.dept.list.lov.select", params);
				System.out.println("9. showWorkDeptListPage workList >>>>>>>>>>>> " + workList);
				model.addAttribute("selectWork", workList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/process/selectWorkDeptList";
	}

	/**
	 * 생산관리 > 공정관리 > 공정시작 / 실적 ( 두번째 ) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/selectQualityList.do")
	public String showQualityListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 에러메시지 표시
			String errorcode = StringUtil.nullConvert(requestMap.get("err"));
			if (!errorcode.isEmpty()) {
				model.addAttribute("errCode", errorcode);
			}

			String type = StringUtil.nullConvert(requestMap.get("type"));
			if (type.isEmpty()) {
				// 존재하지 않는 메뉴를 선택하였을 경우?
				return "redirect:/prod/process/ProcessStart.do?err=1";
			} else {
				switch (type) {
				case "1":
					// 1. 공정시작
					model.addAttribute("pageTitle", "공정관리");
					break;
				case "7":
					// 7. 공구변경 등록
					model.addAttribute("pageTitle", "공구변경 등록");
					break;
				default:
					// 그 밖의 예외 상황

					break;
				}

				// 로그인 사용자의 ORG Company 정보 
				System.out.println("showQualityListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showQualityListPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showQualityListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showQualityListPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showQualityListPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showQualityListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showQualityListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); // 임의의 값
					}
				} else {
					System.out.println("3 showQualityListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", orgid);
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));

				if (companyid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("4 showQualityListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showQualityListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999); // 임의의 값
						params.put("COMPANYID", 999); // 임의의 값
					}
				} else {
					System.out.println("6 showQualityListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				model.addAttribute("labelBox", labelBox);

				String gubun = StringUtil.nullConvert(requestMap.get("gubun"));
				if (!gubun.isEmpty()) {
					params.put("WORKDEPT", gubun);
				}
				System.out.println("7. showQualityListPage params >>>>>>>>>>>> " + params);
				System.out.println("8. showQualityListPage requestMap >>>>>>>>>>>> " + requestMap);
				List<?> equipmentList = dao.list("search.workcenter.list.lov.select", params);
				System.out.println("9. showQualityListPage equipmentList >>>>>>>>>>>> " + equipmentList);
				model.addAttribute("selectEquipment", equipmentList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/process/selectQualityList";
	}

	/**
	 * 생산관리 > 공정관리 > 설비선택 > 작업지시 선택 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/selectWorkOrderRegist.do")
	public String showselectWorkOrderRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		String result = null;

		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");
		System.out.println("showselectWorkOrderRegistPage Start >>>>>>>>>> requestMap " + requestMap);
		System.out.println("showselectWorkOrderRegistPage Start >>>>>>>>>> type " + requestMap.get("type"));

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {

			String type = StringUtil.nullConvert(requestMap.get("type"));
			if (type.isEmpty()) {
				// 존재하지 않는 메뉴를 선택하였을 경우?
				//return "redirect:/prod/process/selectQualityList.do?err=1";
				return "redirect:/prod/process/selectWorkDeptList.do?err=1";
			} else {

				// 로그인 사용자의 ORG Company 정보 
				System.out.println("showselectWorkOrderRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showselectWorkOrderRegistPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showselectWorkOrderRegistPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);
				System.out.println("showselectWorkOrderRegistPage requestMap. >>>>>>>>>>" + requestMap);

				switch (groupid) {
				case "ROLE_EQUIPMENT":
					// 설비권한일 경우

					List<?> equipList = dao.list("search.equipment.login.lov.select", params);

					System.out.println("1. showselectWorkOrderRegistPage size >>>>>>>>>>>> " + equipList.size());
					if (equipList.size() > 0) {
						Map<String, Object> equipData = (Map<String, Object>) equipList.get(0);

						// 더미 사용
						String orgid = StringUtil.nullConvert(equipData.get("ORGID"));
						String companyid = StringUtil.nullConvert(equipData.get("COMPANYID"));
						//						String workdept = StringUtil.nullConvert(equipData.get("WORKDEPT"));
						//						String workcentercode = StringUtil.nullConvert(equipData.get("WORKCENTERCODE"));
						System.out.println("showselectWorkOrderRegistPage orgid >>>>>>>>>>>> " + orgid);
						System.out.println("showselectWorkOrderRegistPage companyid >>>>>>>>>>>> " + companyid);
						//						System.out.println("showselectWorkOrderRegistPage workdept >>>>>>>>>>>> " + workdept);
						//						System.out.println("showselectWorkOrderRegistPage workcentercode >>>>>>>>>>>> " + workcentercode);

						requestMap.put("ORGID", orgid);
						params.put("ORGID", orgid);
						labelBox.put("findByOrgId", searchService.OrgLovList(params));

						requestMap.put("COMPANYID", companyid);
						params.put("COMPANYID", companyid);
						labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

						//						requestMap.put("WORKDEPT", workdept);
						//						requestMap.put("WORKCENTERCODE", workcentercode);
					}

					break;
				default:
					// 그 외 권한
					List<?> userList = dao.list("search.login.lov.select", params);
					Map<String, Object> userData = (Map<String, Object>) userList.get(0);

					// 더미 사용
					String orgid = StringUtil.nullConvert(userData.get("ORGID"));
					String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
					System.out.println("showselectWorkOrderRegistPage orgid. >>>>>>>>>>" + orgid);
					System.out.println("showselectWorkOrderRegistPage companyid. >>>>>>>>>>" + companyid);

					if (orgid == "") {
						if (groupid.equals("ROLE_ADMIN")) {
							System.out.println("1 showselectWorkOrderRegistPage groupid. >>>>>>>>>>" + groupid);
							requestMap.put("ORGID", "");
						} else {
							System.out.println("2 showselectWorkOrderRegistPage groupid. >>>>>>>>>>" + groupid);
							requestMap.put("ORGID", 1);
							params.put("ORGID", 1); //임의의값
						}
					} else {
						System.out.println("3 showselectWorkOrderRegistPage groupid. >>>>>>>>>>" + groupid);
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
							System.out.println("4 showselectWorkOrderRegistPage groupid. >>>>>>>>>>" + groupid);
							requestMap.put("COMPANYID", "");
						} else {
							System.out.println("5 showselectWorkOrderRegistPage groupid. >>>>>>>>>>" + groupid);
							requestMap.put("COMPANYID", 1);
							params.put("ORGID", 1); // 임의의값
							params.put("COMPANYID", 1); // 임의의값
						}
					} else {
						System.out.println("6 showselectWorkOrderRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", orgid);
						params.put("COMPANYID", companyid);
					}
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

					List<?> compList = (List<?>) searchService.CompanyLovList(params);
					HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

					String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
					System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

					requestMap.put("ORGID", result_org);
					requestMap.put("COMPANYID", result_comp);

					break;
				}
				model.addAttribute("labelBox", labelBox);

				System.out.println("6. showselectWorkOrderRegistPage requestMap >>>>>>>>>>>> " + requestMap);
				String code = StringUtil.nullConvert(requestMap.get("code"));
				System.out.println("7. showselectWorkOrderRegistPage code >>>>>>>>>>>> " + code);

				String routing_gubun = null;
				switch (type) {
				case "1":
					routing_gubun = "Normal";
					
					// 선택한 작업반 명칭 가져오기
					params.put("ORGID", requestMap.get("ORGID"));
					params.put("COMPANYID", requestMap.get("COMPANYID"));
					params.put("BIGCD", "CMM");
					params.put("MIDDLECD", "WORK_DEPT");
					params.put("keyword", code);
					List<?> workList = dao.list("search.smallcode.lov.select", params);
					System.out.println("8. showWorkResultListListPage workList >>>>>>>>>>>> " + workList);
					if ( workList.size() > 0 ) {
						HashMap<String, Object> workMap = (HashMap<String, Object>) workList.get(0);
						System.out.println("8-1. showWorkResultListListPage workMap >>>>>>>>>>>> " + workMap);
						String label = StringUtil.nullConvert(workMap.get("LABEL"));
						model.addAttribute("pageTitle", label);
					}
					
					model.addAttribute("STATUS", "START");
					model.addAttribute("WORKDEPT", code);
					result = "/prod/process/selectWorkResult" + routing_gubun + "Regist";
					
					requestMap.put("WORKDEPT", code);
					break;
				case "7":
					// 7. 공구 변경점 등록
					// 공구 변경점 등록에서는 진행 중인 목록만 표기
					model.addAttribute("pageTitle", "공구 변경 등록");
					model.addAttribute("STATUS", "PROGRESS");
					result = "/prod/process/ToolChangeRegist";
					break;
				case "14":
					// 스무고개 프로그램 시작
					model.addAttribute("pageTitle", "생산실적 등록");
					routing_gubun = "Question";
					
					model.addAttribute("STATUS", "START");
					model.addAttribute("WORKDEPT", code);
					result = "/prod/process/selectWorkResult" + routing_gubun + "Regist";
					
					requestMap.put("WORKDEPT", code);
					break;
				case "15":
					// 스무고개 프로그램 시작
					model.addAttribute("pageTitle", "생산실적 등록");
					routing_gubun = "OldQuestion";
					
					model.addAttribute("STATUS", "START");
					model.addAttribute("WORKDEPT", code);
					result = "/prod/process/selectWorkResult" + routing_gubun + "Regist";
					
					requestMap.put("WORKDEPT", code);
					break;
				default:
					// 그 밖의 예외 상황
					result = "redirect:/prod/process/selectQualityList.do?err=1&type=" + type;
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return result;
	}

	/**
	 * 2017.03.13 생산관리 > 공정관리 > 설비선택 > 작업지시 선택 > 자주검사 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/FmlRegist.do")
	public String showFmlRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		String result = null;

		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {

			String type = StringUtil.nullConvert(requestMap.get("type"));
			if (type.isEmpty()) {
				// 존재하지 않는 메뉴를 선택하였을 경우?
				return "redirect:/prod/process/selectQualityList.do?err=1";
			} else {
				// 로그인 사용자의 ORG Company 정보 
				System.out.println("showFmlRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showFmlRegistPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showFmlRegistPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				String orgid = StringUtil.nullConvert(params.get("org"));
				if (!orgid.isEmpty()) {
					params.put("ORGID", orgid);
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));

				List<?> orgList = (List<?>) searchService.OrgLovList(params);
				HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

				String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
				System.out.println("1-1. orgid >>>>>>>>>> " + result_org);

				String companyid = StringUtil.nullConvert(params.get("company"));
				if (!companyid.isEmpty()) {
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("1-2. companyid >>>>>>>>>> " + result_comp);

				requestMap.put("ORGID", result_org);
				requestMap.put("COMPANYID", result_comp);

				model.addAttribute("labelBox", labelBox);

				String workorderid = StringUtil.nullConvert(requestMap.get("workorder"));
				if (!workorderid.isEmpty()) {
					System.out.println("5-1. showFmlRegistPage workorderid >>>>>>>>>>>> " + workorderid);
					params.put("WORKORDERID", workorderid);
					requestMap.put("WORKORDERID", workorderid);
				}

				String workorderseq = StringUtil.nullConvert(requestMap.get("seq"));
				if (!workorderseq.isEmpty()) {
					System.out.println("5-2. showFmlRegistPage workorderseq >>>>>>>>>>>> " + workorderseq);
					params.put("WORKORDERSEQ", workorderseq);
					requestMap.put("WORKORDERSEQ", workorderseq);
				}

				String ftype = StringUtil.nullConvert(requestMap.get("ftype"));
				if (!ftype.isEmpty()) {
					// 현재 초중종 상태 가져오기
					switch (type) {
					case "10":
						// 10. 자주검사 등록
						requestMap.put("CHECKBIG", "F");
						break;
					default:
						requestMap.put("CHECKBIG", "F");
						break;
					}
					System.out.println("5-3. showFmlRegistPage ftype >>>>>>>>>>>> " + ftype);
					model.addAttribute("FMLTYPE", ftype);
					requestMap.put("FMLTYPE", ftype);
				} else {
					System.out.println("5. showFmlRegistPage requestMap >>>>>>>>>>>> " + requestMap);
					// 현재 초중종 상태 가져오기
					switch (type) {
					case "10":
						// 10. 자주검사 등록
						requestMap.put("CHECKBIG", "F");
						break;
					default:
						requestMap.put("CHECKBIG", "F");
						break;
					}
					// 현재 초중종 상태 가져오기
					List fmltypeList = dao.list("prod.work.fmltype.find.select", requestMap);
					System.out.println("showFmlRegistPage 5. fmltypeList >>>>>>>>>> " + fmltypeList.size());

					if (fmltypeList.size() > 0) {
						Map<String, Object> fmltypes = (Map<String, Object>) fmltypeList.get(0);
						String fmltype = StringUtil.nullConvert(fmltypes.get("FMLTYPE"));

						System.out.println("showFmlRegistPage 5-1. fmltype >>>>>>>>>> " + fmltype);
						model.addAttribute("FMLTYPE", fmltype);
						requestMap.put("FMLTYPE", fmltype);

					} else {
						model.addAttribute("FMLTYPE", "L");
						requestMap.put("FMLTYPE", "L");
						System.out.println("showFmlRegistPage 5-2. fmltype is L >>>>>>>>>> ");
					}
				}

				// 설비 조회
				String gubun = StringUtil.nullConvert(requestMap.get("gubun"));
				if (!gubun.isEmpty()) {
					params.put("WORKDEPT", gubun);
				}
				
				String id = StringUtil.nullConvert(requestMap.get("id"));
				if (!id.isEmpty()) {
					params.put("FMLID", id);
					requestMap.put("FMLID", id);
				}
				
				System.out.println("3. showFmlRegistPage params >>>>>>>>>>>> " + params);
				System.out.println("4. showFmlRegistPage requestMap >>>>>>>>>>>> " + requestMap);

				List item_routing_List = dao.list("prod.work.item.routing.find.select", requestMap);
				System.out.println("showFmlRegistPage 5. item_routing_List >>>>>>>>>> " + item_routing_List.size());

				if (item_routing_List.size() > 0) {
					Map<String, Object> itemList = (Map<String, Object>) item_routing_List.get(0);
					System.out.println("showFmlRegistPage 5-0. itemList >>>>>>>>>> " + itemList);
					String itemcode = StringUtil.nullConvert(itemList.get("ITEMCODE"));
					String routingid = StringUtil.nullConvert(itemList.get("ROUTINGID"));
					String customername = StringUtil.nullConvert(itemList.get("CUSTOMERNAME"));
					String cartypename = StringUtil.nullConvert(itemList.get("CARTYPENAME"));
					String ordername = StringUtil.nullConvert(itemList.get("ORDERNAME"));
					String itemname = StringUtil.nullConvert(itemList.get("ITEMNAME"));
					String routingop = StringUtil.nullConvert(itemList.get("ROUTINGOP"));
					String routingname = StringUtil.nullConvert(itemList.get("ROUTINGNAME"));
					String equipmentcode = StringUtil.nullConvert(itemList.get("EQUIPMENTCODE"));
					String equipmentname = StringUtil.nullConvert(itemList.get("EQUIPMENTNAME"));
					String workcentercode = StringUtil.nullConvert(itemList.get("WORKCENTERCODE"));
					String starttime = StringUtil.nullConvert(itemList.get("CHECKSTARTTIME"));
					String endtime = StringUtil.nullConvert(itemList.get("CHECKENDTIME"));
					String lotnovisual = StringUtil.nullConvert(itemList.get("LOTNOVISUAL"));
					String personid = StringUtil.nullConvert(itemList.get("PERSONID"));
					String krname = StringUtil.nullConvert(itemList.get("KRNAME"));
					String itemstandarddetail = StringUtil.nullConvert(itemList.get("ITEMSTANDARDDETAIL"));
//					String standardstarttime = StringUtil.nullConvert(itemList.get("STANDARDSTARTTIME"));
//					String standardendtime = StringUtil.nullConvert(itemList.get("STANDARDENDTIME"));

					System.out.println("showFmlRegistPage 5-1. itemcode >>>>>>>>>> " + itemcode);
					System.out.println("showFmlRegistPage 5-2. routingid >>>>>>>>>> " + routingid);
					requestMap.put("ITEMCODE", itemcode);
					requestMap.put("ROUTINGID", routingid);
					requestMap.put("CUSTOMERNAME", customername);
					requestMap.put("CARTYPENAME", cartypename);
					requestMap.put("ORDERNAME", ordername);
					requestMap.put("ITEMNAME", itemname);
					requestMap.put("ROUTINGOP", routingop);
					requestMap.put("ROUTINGNAME", routingname);
					requestMap.put("LOTNOVISUAL", lotnovisual);
					requestMap.put("PERSONID", personid);
					requestMap.put("KRNAME", krname);
					requestMap.put("ITEMSTANDARDDETAIL", itemstandarddetail);
					//					requestMap.put("EQUIPMENTCODE", equipmentcode);
					//					requestMap.put("EQUIPMENTNAME", equipmentname);
					//					params.put("EQUIPMENTCODE", workcentercode);

					if (starttime.isEmpty()) {
						starttime = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "HH:mm");
					}
					requestMap.put("STARTTIME", starttime);
					requestMap.put("ENDTIME", endtime);
//					requestMap.put("STANDARDSTARTTIME", standardstarttime);
//					requestMap.put("STANDARDENDTIME", standardendtime);

					// 설비 조회
					String code = StringUtil.nullConvert(requestMap.get("code"));
					if (!code.isEmpty()) {
						params.put("EQUIPMENTCODE", code);
						model.addAttribute("WORKCENTERCODE", code);
					}

					System.out.println("3. showFmlRegistPage params >>>>>>>>>>>> " + params);
					System.out.println("4. showFmlRegistPage requestMap >>>>>>>>>>>> " + requestMap);
					List<?> equipmentList = dao.list("search.workcenter.list.lov.select", params);
					System.out.println("5. showFmlRegistPage equipmentList >>>>>>>>>>>> " + equipmentList);
					HashMap<String, Object> equipMap = (HashMap<String, Object>) equipmentList.get(0);
					equipmentcode = StringUtil.nullConvert(equipMap.get("VALUE"));
					equipmentname = StringUtil.nullConvert(equipMap.get("LABEL"));
					String routinggroup = StringUtil.nullConvert(equipMap.get("ROUTINGGROUP"));
					String routinggroupname = StringUtil.nullConvert(equipMap.get("ROUTINGGROUPNAME"));
					model.addAttribute("EQUIPMENTCODE", equipmentcode);
					model.addAttribute("EQUIPMENTNAME", equipmentname);
					model.addAttribute("ROUTINGGROUP", routinggroup);
					model.addAttribute("ROUTINGGROUPNAME", routinggroupname);
					//					List<?> equipmentList = dao.list("search.workcenter.list.lov.select", params);
					//					System.out.println("6. showFmlRegistPage equipmentList >>>>>>>>>>>> " + equipmentList);
					//					HashMap<String, Object> equipMap = (HashMap<String, Object>) equipmentList.get(0);
					//					equipmentcode = StringUtil.nullConvert(equipMap.get("VALUE"));
					//					equipmentname = StringUtil.nullConvert(equipMap.get("LABEL"));
					//					String routinggroup = StringUtil.nullConvert(equipMap.get("ROUTINGGROUP"));
					//					String routinggroupname = StringUtil.nullConvert(equipMap.get("ROUTINGGROUPNAME"));
					//					String workdept = StringUtil.nullConvert(equipMap.get("WORKDEPT"));
					//					String workdeptname = StringUtil.nullConvert(equipMap.get("WORKDEPTNAME"));
					//					model.addAttribute("EQUIPMENTCODE", equipmentcode);
					//					model.addAttribute("EQUIPMENTNAME", equipmentname);
					//					model.addAttribute("ROUTINGGROUP", routinggroup);
					//					model.addAttribute("ROUTINGGROUPNAME", routinggroupname);
					//					model.addAttribute("WORKDEPT", workdept);
					//					model.addAttribute("WORKDEPTNAME", workdeptname);

//					List<?> filelist5 = fileService.selectItemFile(itemcode, "check", "Image5", routingid);
//					model.addAttribute("filelist5", filelist5.isEmpty() ? "" : filelist5);
//
//					List<?> filelist2 = fileService.selectItemFile(itemcode, "check", "Image2", routingid);
//					model.addAttribute("filelist2", filelist2.isEmpty() ? "" : filelist2);
				}
				System.out.println("showFmlRegistPage 7. requestMap >>>>>>>>>> " + requestMap);

				switch (type) {
				case "10":
					// 10. 자주 검사
					model.addAttribute("pageTitle", "자주 검사");
					model.addAttribute("pageSubTitle1", "자주검사 등록");

					result = "/prod/process/FmlRegist";
					break;
				default:
					// 그 밖의 예외 상황
					result = "redirect:/prod/process/selectQualityList.do?err=1&type=" + type;
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return result;
	}

	/**
	 * 2017.03.13 자주 검사 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/FmlRegist.do")
	@ResponseBody
	public Object selectFmlRegist(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectFmlRegist Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String workorderid = StringUtil.nullConvert(params.get("WORKORDERID"));
			if (workorderid.isEmpty()) {
				count++;
			}

			String workorderseq = StringUtil.nullConvert(params.get("WORKORDERSEQ"));
			if (workorderseq.isEmpty()) {
				count++;
			}

			String fmltype = StringUtil.nullConvert(params.get("FMLTYPE"));
			if (fmltype.isEmpty()) {
				count++;
			}

			String type = StringUtil.nullConvert(params.get("TYPE"));
			switch (type) {
			case "10":
				// 10. 자주 검사
				params.put("CHECKBIG", "F");
				break;
			default:
				params.put("CHECKBIG", "F");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(prodProcessService.selectFmlCount(params));
			extGrid.setData(prodProcessService.selectFmlList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkOrderList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2017.03.13 자주 검사 // 검사 값 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/process/FmlRegist.do")
	@ResponseBody
	public Object updateFmlRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateFmlRegist Start >>>>>>>>>> " + params);
		return prodProcessService.updateFmlRegist(params);
	}
	
	/**
	 * 공구 변경점 관리 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/selectToolChangeRegist.do")
	@ResponseBody
	public Object selectToolChangeRegist(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectToolChangeRegist Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
//			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
//			if (workcentercode.isEmpty()) {
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
			extGrid.setTotcnt(prodProcessService.selectToolChangeRegistCount(params));
			extGrid.setData(prodProcessService.selectToolChangeRegistList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectToolChangeRegist End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공구 변경점 관리 // 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/process/selectToolChangeRegist.do")
	@ResponseBody
	public Object insertToolChangeRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertToolChangeRegist >>>>>>>>>> " + params);

		return prodProcessService.insertToolChangeRegist(params);
	}

	/**
	 * 공구 변경점 관리 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/process/selectToolChangeRegist.do")
	@ResponseBody
	public Object updateToolChangeRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateToolChangeRegist >>>>>>>>>> " + params);

		return prodProcessService.updateToolChangeRegist(params);
	}

	/**
	 * 공정관리 > 입고등록 ( 현장용 ) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/WarehousingRegist.do")
	public String showWarehousingRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		
		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");
		model.addAttribute("pageTitle", "입고등록");
		System.out.println("showWarehousingRegistPage Start >>>>>>>>>>");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showWarehousingRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showWarehousingRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showWarehousingRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			System.out.println("showWarehousingRegistPage requestMap. >>>>>>>>>>" + requestMap);

			switch (groupid) {
			case "ROLE_EQUIPMENT":
				// 설비권한일 경우
				List<?> equipList = dao.list("search.equipment.login.lov.select", params);

				System.out.println("1. showWarehousingRegistPage size >>>>>>>>>>>> " + equipList.size());
				if (equipList.size() > 0) {
					Map<String, Object> equipData = (Map<String, Object>) equipList.get(0);

					// 더미 사용
					String orgid = StringUtil.nullConvert(equipData.get("ORGID"));
					String companyid = StringUtil.nullConvert(equipData.get("COMPANYID"));
					//						String workdept = StringUtil.nullConvert(equipData.get("WORKDEPT"));
					//						String workcentercode = StringUtil.nullConvert(equipData.get("WORKCENTERCODE"));
					System.out.println("showWarehousingRegistPage orgid >>>>>>>>>>>> " + orgid);
					System.out.println("showWarehousingRegistPage companyid >>>>>>>>>>>> " + companyid);
					//						System.out.println("showWarehousingRegistPage workdept >>>>>>>>>>>> " + workdept);
					//						System.out.println("showWarehousingRegistPage workcentercode >>>>>>>>>>>> " + workcentercode);

					requestMap.put("ORGID", orgid);
					params.put("ORGID", orgid);
					labelBox.put("findByOrgId", searchService.OrgLovList(params));

					requestMap.put("COMPANYID", companyid);
					params.put("COMPANYID", companyid);
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

					//						requestMap.put("WORKDEPT", workdept);
					//						requestMap.put("WORKCENTERCODE", workcentercode);
				}

				break;
			default:
				// 그 외 권한
				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showWarehousingRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showWarehousingRegistPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showWarehousingRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showWarehousingRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); //임의의값
					}
				} else {
					System.out.println("3 showWarehousingRegistPage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showWarehousingRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showWarehousingRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999); // 임의의값
						params.put("COMPANYID", 999); // 임의의값
					}
				} else {
					System.out.println("6 showWarehousingRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				requestMap.put("ORGID", result_org);
				requestMap.put("COMPANYID", result_comp);

				break;
			}
			model.addAttribute("labelBox", labelBox);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/process/WarehousingRegist";
	}

	/**
	 * 공정관리 > 입고등록 ( 현장용 ) // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/WarehousingRegist.do")
	@ResponseBody
	public Object selectWarehousingRegist(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWarehousingRegist Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(prodProcessService.selectWarehousingRegistCount(params));
			extGrid.setData(prodProcessService.selectWarehousingRegistList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWarehousingRegist End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공정관리 > 입고등록 ( 현장용 ) // LOT 번호 입력시 호출
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/pkg/prod/process/TradeLotNoList.do")
	public ModelAndView callTradeLotNoList(@RequestParam HashMap<String, Object> params, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		System.out.println("callTradeLotNoList Start. >>>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("jsonView");

		LoginVO login = getLoginVO();
		int errcnt = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			String lotno = StringUtil.nullConvert(params.get("LOTNO"));

			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			params.put("LOTNO", lotno);
			
			params.put("REGISTID", login.getId());
			params.put("RETURNSTATUS", "");
			params.put("MSGDATA", "");

			System.out.println("LOT NO 입고 등록 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("prod.work.warehousing.lotno.call.Procedure", params);
			System.out.println("LOT NO 입고 등록 PROCEDURE 호출 End.  >>>>>>>> " + params);

			String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
			String msgdata = StringUtil.nullConvert(params.get("MSGDATA"));
			if ( status.equals("S") ) {
				msgdata = "정상적으로 저장하였습니다.";
			}
			mav.addObject("RETURNSTATUS", status);
			mav.addObject("MSGDATA", msgdata);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	/**
	 * 공정관리 > 입고등록 ( 현장용 ) // 입고번호생성
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/process/createTransNoList.do")
	public ModelAndView insertTransNoList(@RequestParam HashMap<String, Object> params, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		System.out.println("insertTransNoList Start. >>>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("jsonView");

		LoginVO login = getLoginVO();
		int errcnt = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));

			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			params.put("TRANSDIV", "OT");

			List noList = dao.selectListByIbatis("prod.work.warehousing.new.transno.select", params);
			Map<String, Object> noMap = (Map<String, Object>) noList.get(0);
			
			String transno = StringUtil.nullConvert(noMap.get("TRANSNO"));
			mav.addObject("TRANSNO", transno);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	/**
	 * 공정관리 > 입고등록 ( 현장용 ) // 입고처리
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/pkg/prod/process/WarehousingRegist.do")
	public ModelAndView callWarehousingRegist(@RequestParam HashMap<String, Object> params, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		System.out.println("callTradeLotNoList Start. >>>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("jsonView");

		LoginVO login = getLoginVO();
		int errcnt = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			String pono = StringUtil.nullConvert(params.get("PONO"));
			Integer poseq = NumberUtil.getInteger(params.get("POSEQ"));
			BigDecimal transqty = NumberUtil.getBigDecimal(params.get("TRANSQTY"));
			String gubun = StringUtil.nullConvert(params.get("TABLEGUBUN"));
			String transperson = StringUtil.nullConvert(params.get("TRANSPERSON"));

			BigDecimal con1 = NumberUtil.getBigDecimal(params.get("CON1"));
			BigDecimal con9 = NumberUtil.getBigDecimal(params.get("CON9"));
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			params.put("PONO", pono);
			params.put("POSEQ", poseq);
			params.put("TRANSQTY", transqty);
			params.put("GUBUN", gubun);
			params.put("TRANSPERSON", transperson);
			params.put("CON1", con1);
			params.put("CON9", con9);
			params.put("REGISTID", login.getId());
			params.put("RETURNSTATUS", "");
			params.put("MSGDATA", "");

			System.out.println("공정관리 > 입고처리 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("prod.work.warehousing.list.call.Procedure", params);
			System.out.println("공정관리 > 입고처리 PROCEDURE 호출 End.  >>>>>>>> " + params);

			String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
			String msgdata = StringUtil.nullConvert(params.get("MSGDATA"));
			if ( status.equals("S") ) {
				msgdata = "정상적으로 저장하였습니다.";
			}
			mav.addObject("RETURNSTATUS", status);
			mav.addObject("MSGDATA", msgdata);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	/**
	 * 생산관리 > 공정관리 > 작업지시 선택 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/selectWorkOrderNewRegist.do")
	public String showWorkOrderNewRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		String result = null;

		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {

			String type = StringUtil.nullConvert(requestMap.get("type"));
			if (type.isEmpty()) {
				// 존재하지 않는 메뉴를 선택하였을 경우?
				return "redirect:/prod/process/selectQualityList.do?err=1";
			} else {

				// 로그인 사용자의 ORG Company 정보 
				System.out.println("showWorkOrderNewRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showWorkOrderNewRegistPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showWorkOrderNewRegistPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				switch (groupid) {
				case "ROLE_EQUIPMENT":
					// 설비권한일 경우

					List<?> equipList = dao.list("search.equipment.login.lov.select", params);

					System.out.println("1. showWorkOrderNewRegistPage size >>>>>>>>>>>> " + equipList.size());
					if (equipList.size() > 0) {
						Map<String, Object> equipData = (Map<String, Object>) equipList.get(0);

						// 더미 사용
						String orgid = StringUtil.nullConvert(equipData.get("ORGID"));
						String companyid = StringUtil.nullConvert(equipData.get("COMPANYID"));
						System.out.println("showselectWorkOrderRegistPage orgid >>>>>>>>>>>> " + orgid);
						System.out.println("showselectWorkOrderRegistPage companyid >>>>>>>>>>>> " + companyid);

						requestMap.put("ORGID", orgid);
						params.put("ORGID", orgid);
						labelBox.put("findByOrgId", searchService.OrgLovList(params));

						requestMap.put("COMPANYID", companyid);
						params.put("COMPANYID", companyid);
						labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
					}

					break;
				default:
					// 그 외 권한
					List<?> userList = dao.list("search.login.lov.select", params);
					Map<String, Object> userData = (Map<String, Object>) userList.get(0);

					// 더미 사용
					String orgid = StringUtil.nullConvert(userData.get("ORGID"));
					String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
					System.out.println("showWorkOrderNewRegistPage orgid. >>>>>>>>>>" + orgid);
					System.out.println("showWorkOrderNewRegistPage companyid. >>>>>>>>>>" + companyid);

					if (orgid == "") {
						if (groupid.equals("ROLE_ADMIN")) {
							System.out.println("1 showWorkOrderNewRegistPage groupid. >>>>>>>>>>" + groupid);
							requestMap.put("ORGID", "");
						} else {
							System.out.println("2 showWorkOrderNewRegistPage groupid. >>>>>>>>>>" + groupid);
							requestMap.put("ORGID", 1);
							params.put("ORGID", 1); //임의의값
						}
					} else {
						System.out.println("3 showWorkOrderNewRegistPage groupid. >>>>>>>>>>" + groupid);
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
							System.out.println("4 showWorkOrderNewRegistPage groupid. >>>>>>>>>>" + groupid);
							requestMap.put("COMPANYID", "");
						} else {
							System.out.println("5 showWorkOrderNewRegistPage groupid. >>>>>>>>>>" + groupid);
							requestMap.put("COMPANYID", "");
							params.put("ORGID", 999); // 임의의값
							params.put("COMPANYID", 999); // 임의의값
						}
					} else {
						System.out.println("6 showWorkOrderNewRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", orgid);
						params.put("COMPANYID", companyid);
					}
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

					List<?> compList = (List<?>) searchService.CompanyLovList(params);
					HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

					String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
					System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

					requestMap.put("ORGID", result_org);
					requestMap.put("COMPANYID", result_comp);

					break;
				}
				model.addAttribute("labelBox", labelBox);

				String title_gubun = "New";
				switch (type) {
				case "10":
					// 10. 자주 검사
					title_gubun = "ReNew";
					model.addAttribute("pageTitle", "자주 검사");
					requestMap.put("CHECKBIG", "F");
					result = "/prod/process/WorkOrder" + title_gubun + "List";
					break;
				default:
					// 그 밖의 예외 상황
					result = "redirect:/prod/process/ProcessStart.do?err=1";
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return result;
	}

	/**
	 * 공정관리 > 공정실적 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/selectWorkResultNewList.do")
	@ResponseBody
	public Object selectWorkResultNewList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkResultNewList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(prodProcessService.selectWorkResultNewCount(params));
			extGrid.setData(prodProcessService.selectWorkResultNewList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkResultNewList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 자주검사 목록 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/selectWorkCheckNewList.do")
	@ResponseBody
	public Object selectWorkCheckNewList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkCheckNewList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String checkbig = StringUtil.nullConvert(params.get("CHECKBIG"));
			if (checkbig.isEmpty()) {
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
			extGrid.setTotcnt(prodProcessService.selectWorkCheckNewCount(params));
			extGrid.setData(prodProcessService.selectWorkCheckNewList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkCheckNewList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공정관리 > 작업반선택 > 실적등록 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/selectWorkOrderRegist.do")
	@ResponseBody
	public Object selectWorkOrderRegist(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkOrderRegist Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
//			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
//			if (workcentercode.isEmpty()) {
//				count++;
//			}
			//			String equipmentcode = StringUtil.nullConvert(params.get("EQUIPMENTCODE"));
			//			if (equipmentcode.isEmpty()) {
			//				count++;
			//			}

//			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
//			if (!gubun.isEmpty()) {
//				System.out.println("isEmpty Start. >>>>>>>>>> " + params);
//				if (gubun.equals("JIG") || gubun.equals("END")) {
//					String lotno = StringUtil.nullConvert(params.get("LOTNO"));
//					if (lotno.isEmpty()) {
//						System.out.println("isEmpty Start2. >>>>>>>>>> " + params);
//						count++;
//					}
//				}
//				
//				else if ( gubun.equals("REG")) {
//					
//				} else {
//
//					String routinggroup = StringUtil.nullConvert(params.get("ROUTINGGROUP"));
//					if (routinggroup.isEmpty()) {
//						count++;
//					}
//
//				}
//			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			System.out.println("selectWorkOrderRegist COUNT. >>>>>>>>>> " + count);
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(prodProcessService.selectWorkOrderCount(params));
			extGrid.setData(prodProcessService.selectWorkOrderList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkOrderRegist End. >>>>>>>>>>");
		return extGrid;
	}
	
	/** 2018.06.14
	 * 생산실적등록 조회 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/WorkOrderResultHeader.do")
	@ResponseBody
	public Object selectWorkOrderResultHeader(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectpopupWorkOrderResultHeader Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String workorderid = StringUtil.nullConvert(params.get("WORKORDERID"));
			if (workorderid.isEmpty()) {
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
			extGrid.setTotcnt(prodProcessService.selectWorkOrderResultHeaderCount(params));
			extGrid.setData(prodProcessService.selectWorkOrderResultHeader(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkOrderResultHeader End. >>>>>>>>>>");
		return extGrid;
	}
	
	/** 2017-12-05
	 *  생산실적 등록 // 
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/process/WorkFaultListH.do")
	@ResponseBody
	public Object insertWorkOrderResultHeader(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateWorkFaultListH >>>>>>>>>> " + params);
		return prodProcessService.updateWorkFaultListH(params);
	}
	
	/**
	 * 생산실적 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/process/WorkFaultListH.do")
	@ResponseBody
	public Object deleteWorkOrderResultHeader(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteWorkOrderResultHeader >>>>>>>>>> " + params);
		
		return prodProcessService.deleteWorkFaultListH(params);
	}
	
	/** 2018.06.14
	 * 공정검사 불량유형등록 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/WorkOrderResultDetail.do")
	@ResponseBody
	public Object selectWorkOrderResultDetail(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkOrderResultDetail Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String workorderid = StringUtil.nullConvert(params.get("WORKORDERID"));
			if (workorderid.isEmpty()) {
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
			extGrid.setTotcnt(prodProcessService.selectWorkOrderResultDetailCount(params));
			extGrid.setData(prodProcessService.selectWorkOrderResultDetailList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectpopupWorkFaultListN End. >>>>>>>>>>");
		return extGrid;
	}
	
	/** 2017-12-05
	 *  공정검사 불량유형 등록 // 
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/process/WorkOrderResultDetail.do")
	@ResponseBody
	public Object insertWorkOrderResultDetail(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertWorkOrderResultDetail >>>>>>>>>> " + params);
		return prodProcessService.insertWorkOrderResultDetail(params);
	}
	
	/** 2017-12-05
	 *  생산실적 등록 // 
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/process/WorkFaultListH.do")
	@ResponseBody
	public Object updateWorkOrderResultHeader(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateWorkFaultListH >>>>>>>>>> " + params);
		return prodProcessService.updateWorkFaultListH(params);
	}
	
	/**
	 * 비가동유형 // Grid화면을 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/WorkOrderOperateList.do")
	@ResponseBody
	public Object selectWorkOrderOperateList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkOrderOperateList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		

		ExtGridVO extGrid = new ExtGridVO();
		
		if ( count > 0 ) {
			extGrid.setTotcnt( 0 );
			extGrid.setData( null );
		} else {
			extGrid.setTotcnt(prodProcessService.selectWorkOrderOperateListCount(params));
			extGrid.setData(prodProcessService.selectWorkOrderOperateList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkOrderOperateList End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 비가동유형 // 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/process/WorkOrderOperateList.do")
	@ResponseBody
	public Object insertWorkOrderOperateList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertWorkerPaintList Start >>>>>>>>>> " + params);
		return prodProcessService.insertWorkOrderOperateList(params);
	}

	/**
	 * 비가동유형 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/process/WorkOrderOperateList.do")
	@ResponseBody
	public Object updateWorkOrderOperateList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateWorkerPaintList >>>>>>>>>> " + params);
		return prodProcessService.updateWorkOrderOperateList(params);
	}

	/**
	 * 비가동유형 // 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/process/WorkOrderOperateList.do")
	@ResponseBody
	public Object deleteWorkOrderOperateList(@RequestParam HashMap<String, Object> params) throws Exception {

		return prodProcessService.deleteWorkOrderOperateList(params);
	}
	
	/**
	 * 공정관리 > 설비그룹 변경등록 ( 현장용 ) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/WorkgroupChangeRegist.do")
	public String showWorkgroupChangeRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		
		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");
		model.addAttribute("pageTitle", "설비그룹 변경등록");
		System.out.println("showWorkgroupChangeRegistPage Start >>>>>>>>>>");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showWorkgroupChangeRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showWorkgroupChangeRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			System.out.println("showWorkgroupChangeRegistPage requestMap. >>>>>>>>>>" + requestMap);

			switch (groupid) {
			case "ROLE_EQUIPMENT":
				// 설비권한일 경우
				List<?> equipList = dao.list("search.equipment.login.lov.select", params);

				System.out.println("1. showWorkgroupChangeRegistPage size >>>>>>>>>>>> " + equipList.size());
				if (equipList.size() > 0) {
					Map<String, Object> equipData = (Map<String, Object>) equipList.get(0);

					// 더미 사용
					String orgid = StringUtil.nullConvert(equipData.get("ORGID"));
					String companyid = StringUtil.nullConvert(equipData.get("COMPANYID"));
					//						String workdept = StringUtil.nullConvert(equipData.get("WORKDEPT"));
					//						String workcentercode = StringUtil.nullConvert(equipData.get("WORKCENTERCODE"));
					System.out.println("showWorkgroupChangeRegistPage orgid >>>>>>>>>>>> " + orgid);
					System.out.println("showWorkgroupChangeRegistPage companyid >>>>>>>>>>>> " + companyid);
					//						System.out.println("showWarehousingRegistPage workdept >>>>>>>>>>>> " + workdept);
					//						System.out.println("showWarehousingRegistPage workcentercode >>>>>>>>>>>> " + workcentercode);

					requestMap.put("ORGID", orgid);
					params.put("ORGID", orgid);
					labelBox.put("findByOrgId", searchService.OrgLovList(params));

					requestMap.put("COMPANYID", companyid);
					params.put("COMPANYID", companyid);
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

					//						requestMap.put("WORKDEPT", workdept);
					//						requestMap.put("WORKCENTERCODE", workcentercode);

					params.put("ORGID", requestMap.get("ORGID"));
					params.put("COMPANYID", requestMap.get("COMPANYID"));
					params.put("BIGCD", "CMM");
					params.put("MIDDLECD", "WORK_DEPT");
					labelBox.put("findByWorkDept", searchService.SmallCodeLovList(params));
				}

				break;
			default:
				// 그 외 권한
				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showWorkgroupChangeRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showWorkgroupChangeRegistPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); //임의의값
					}
				} else {
					System.out.println("3 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999); // 임의의값
						params.put("COMPANYID", 999); // 임의의값
					}
				} else {
					System.out.println("6 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				requestMap.put("ORGID", result_org);
				requestMap.put("COMPANYID", result_comp);

				params.put("ORGID", requestMap.get("ORGID"));
				params.put("COMPANYID", requestMap.get("COMPANYID"));
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "WORK_DEPT");
				params.put("GUBUN", "WORKGROUP");
				params.put("ORDERATTRIBUTE1", "WORKGROUP");
				labelBox.put("findByWorkDept", searchService.SmallCodeLovList(params));
				
				break;
			}
			
			model.addAttribute("labelBox", labelBox);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/process/WorkgroupChangeRegist";
	}

	/**
	 * 설비그룹 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/process/WorkgroupChangeRegist.do")
	@ResponseBody
	public Object updateWorkgroupChangeGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateWorkgroupChangeGrid Start. >>>>>>>>>> " + params);

		return prodProcessService.updateWorkgroupChangeGrid(params);
	}
	
	
	/**
	 * 공정관리 > 외주발주 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/WorkOutOrderRegist.do")
	public String showWorkOutOrderRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		
		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");
		model.addAttribute("pageTitle", "외주발주");
		System.out.println("showWorkOutOrderRegistPage Start >>>>>>>>>>");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showWorkOutOrderRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showWorkOutOrderRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showWorkOutOrderRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			System.out.println("showWorkOutOrderRegistPage requestMap. >>>>>>>>>>" + requestMap);

			// 그 외 권한
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showWorkgroupChangeRegistPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showWorkgroupChangeRegistPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
				} else {
					System.out.println("2 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					params.put("ORGID", 1); //임의의값
				}
			} else {
				System.out.println("3 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "1");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "1");
				} else {
					System.out.println("5 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "1");
					params.put("ORGID", 1); // 임의의값
					params.put("COMPANYID", 1); // 임의의값
				}
			} else {
				System.out.println("6 showWorkgroupChangeRegistPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "1");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			model.addAttribute("labelBox", labelBox);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/process/WorkOutOrderRegist";
	}

	/**
	 * 공정관리 > 외주발주 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/WorkOutOrderRegist.do")
	@ResponseBody
	public Object selectWorkOutOrderRegist(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkOutOrderRegist Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {


		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			System.out.println("selectWorkOutOrderRegist COUNT. >>>>>>>>>> " + count);
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(prodProcessService.selectWorkOutOrderCount(params));
			extGrid.setData(prodProcessService.selectWorkOutOrderList(params));
		}

		System.out.println("selectWorkOrderRegist End. >>>>>>>>>>");
		return extGrid;
	}
	
	
	/**
	 * 공정관리 > 외주발주
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/process/WorkOutOrderRegist.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView updateWorkOutOrderRegist(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("updateWorkOutOrderRegist Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodProcessService.updateWorkOutOrderRegist(params));
		return mav;
	}
	
	/**
	 * 공정관리 > 반입반출관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/process/WorkOrderInOut.do")
	public String showWorkOrderInOutPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		
		model.addAttribute("pageSubTitle", "공정관리 > 초기화면");
		model.addAttribute("pageTitle", "반입반출관리");
		System.out.println("showWorkOrderInOutPage Start >>>>>>>>>>");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showWorkOrderInOutPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("FIRSTDAY"));
				requestMap.put("dateTo", dummy.get("LASTDATE"));
				requestMap.put("datesys", dummy.get("DATESYS"));
			}
			
			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showWorkOrderInOutPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showWorkOrderInOutPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showWorkOrderInOutPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			System.out.println("showWorkOrderInOutPage requestMap. >>>>>>>>>>" + requestMap);

			// 그 외 권한
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showWorkOrderInOutPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showWorkOrderInOutPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showWorkOrderInOutPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
				} else {
					System.out.println("2 showWorkOrderInOutPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "1");
					params.put("ORGID", 1); //임의의값
				}
			} else {
				System.out.println("3 showWorkOrderInOutPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "1");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showWorkOrderInOutPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "1");
				} else {
					System.out.println("5 showWorkOrderInOutPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "1");
					params.put("ORGID", 1); // 임의의값
					params.put("COMPANYID", 1); // 임의의값
				}
			} else {
				System.out.println("6 showWorkOrderInOutPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "1");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			requestMap.put("ORGID", 1);
			requestMap.put("COMPANYID", 1);
			requestMap.put("BIGCD", "CMM");
			requestMap.put("MIDDLECD", "WORK_DEPT");
			requestMap.put("ATTRIBUTE2", loVo.getId());
			List<?> workdeptlist = dao.list("search.smallcode.lov.select", requestMap);
			System.out.println("1. showProcessStartPage size >>>>>>>>>>>> " + workdeptlist.size());
			if (workdeptlist.size() > 0) {
				Map<String, Object> workdeptdata = (Map<String, Object>) workdeptlist.get(0);
				
				requestMap.put("workdept",workdeptdata.get("LABEL"));
			}
			
			model.addAttribute("labelBox", labelBox);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/process/WorkOrderInOut";
	}
	

	/**
	 * 반입반출 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/WorkOrderInOut.do")
	@ResponseBody
	public Object selectWorkOrderInOutList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkOrderInOutList Start. >>>>>>>>>> " + params);
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
			System.out.println("selectWorkOrderInOutList COUNT. >>>>>>>>>> " + count);
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(prodProcessService.selectWorkOrderInOutCount(params));
			extGrid.setData(prodProcessService.selectWorkOrderInOutList(params));
		}

		System.out.println("selectWorkOrderInOutList End. >>>>>>>>>>");
		return extGrid;
	}
	
	
	/**
	 * 반입반출관리 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/process/WorkOrderInOut.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public Object insertWorkOrderInOut(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertWorkOrderInOut Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodProcessService.insertWorkOrderInOut(params));
		return mav;
	}
	
	/** 
	 *  반입반출관리 // 
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/process/WorkOrderInOut.do")
	@ResponseBody
	public Object updateWorkOrderInOut(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateWorkOrderInOut >>>>>>>>>> " + params);
		return prodProcessService.updateWorkOrderInOut(params);
	}

	/**
	 * 공정관리 > 생산실적등록 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/process/WorkOrderBtnList.do")
	@ResponseBody
	public Object selectWorkOrderBtnList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkOrderBtnList Start. >>>>>>>>>> " + params);
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

			String workdept = StringUtil.nullConvert(params.get("WORKDEPT"));
			if ( workdept.isEmpty() ) {
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
			extGrid.setTotcnt(prodProcessService.selectWorkOrderBtnCount(params));
			extGrid.setData(prodProcessService.selectWorkOrderBtnList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkOrderBtnList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 생산실적등록 // 실적 등록, 완료
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/process/WorkOrderBtnList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateWorkOrderBtnList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateWorkOrderBtnList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = prodProcessService.updateWorkOrderBtnList(params);
			System.out.println("updateWorkOrderBtnList result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 생산실적 > 작업지시 생성 // PKG 호출전 유무 확인
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/pre/prod/process/WorkOrderCreate.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object preWorkOrderInterface(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("preWorkOrderInterface Params. >>>>>>>>>> " + params);

		Object result = null;
		try {
			// 승인 여부 체크
			List apList = dao.selectListByIbatis("prod.work.order.create.find.select", params);
			Map<String, Object> current = (Map<String, Object>) apList.get(0);
			int count = NumberUtil.getInteger(current.get("COUNT"));

			System.out.println("preWorkOrderInterface count >>>>>>>>>> " + count);
			// 메시지 호출
			if (count > 0) {
				params.put("RETURNSTATUS", "Y");
				params.put("MSGDATA", "");
			} else {
				params.put("RETURNSTATUS", "N");
				params.put("MSGDATA", "");
			}

			result = params;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 생산실적 > 작업지시 생성 // 프로시저 호출
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/pkg/prod/process/WorkOrderCreate.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object insertWorkOrderCreateInterface(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertWorkOrderCreateInterface Params. >>>>>>>>>> " + params);

		Object result = null;
		LoginVO login = getLoginVO();
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			Integer routingid = NumberUtil.getInteger(params.get("ROUTINGID"));
			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
			
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			params.put("ITEMCODE", itemcode);
			params.put("ROUTINGID", routingid);
			params.put("WORKCENTERCODE", workcentercode);
			
			params.put("REGISTID", login.getId());

			params.put("RETURNSTATUS", "");
			params.put("MSGDATA", "");

			// 프로시저 호출
			System.out.println("생산실적 > 작업지시 생성 PROCEDURE 호출 Start. >>>>>>>> " + params);
			dao.list("prod.work.order.create.call.Procedure", params);
			System.out.println("생산실적 > 작업지시 생성 PROCEDURE 호출 End.  >>>>>>>> " + params);

			result = params;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
}