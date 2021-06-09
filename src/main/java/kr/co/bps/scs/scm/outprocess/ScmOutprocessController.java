package kr.co.bps.scs.scm.outprocess;

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
 * @ClassName : ProdOutController.java
 * @Description : DistMat Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jmpark, ymha, gjyang
 * @since 2016. 12.
 * @version 1.0
 * @see SCM - 1. 입고등록
 * 
 */
@Controller
public class ScmOutprocessController extends BaseController {

	@Autowired
	private ScmOutprocessService scmOutprocessService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	private ArrayList<MultipartFile> uploadFile;

	/**
	 * 2018.03.09 외주입고관리 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutWarehousingRegist.do")
	public String showOutWarehousingRegisttPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "외주입고관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOutWarehousingRegisttPage Dummy. >>>>>>>>>>" + dummy);

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
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 1);
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
					params.put("ORGID", 1);
					params.put("COMPANYID", 1);
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

			// 출고상태
			requestMap.put("TRANSYN", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "SCM");
			params.put("MIDDLECD", "RELEASE_YN");

			labelBox.put("findByReleaseLov", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

			if (groupid.equals("ROLE_ADMIN") || groupid.equals("ROLE_MANAGER")) {
				requestMap.put("CustomerCode", "admin");
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

			// 불량유형
			params.put("ORGID", result_org );
			params.put("COMPANYID", result_comp );
			List<?> faulttypeList = dao.selectListByIbatis("prod.work.fault.group.list.select", params);
			
			if ( faulttypeList.size() > 0 ) {
				HashMap<String, Object> faulttypeMap = (HashMap<String, Object>) faulttypeList.get(0);

				String value = StringUtil.nullConvert(faulttypeMap.get("VALUE"));
				String label = StringUtil.nullConvert(faulttypeMap.get("LABEL"));
				
				requestMap.put("FAULTTYPE", value);
				requestMap.put("FAULTTYPENAME", label);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/scm/outprocess/OutWarehousingList";
	}

	/**
	 * 2018.03.09 외주입고관리 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutWarehousingList.do")
	@ResponseBody
	public Object selectOutWarehousingListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutWarehousingListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.isEmpty()) {
				String pofrom = StringUtil.nullConvert(params.get("WORKORDERFROM"));
				if (pofrom.isEmpty()) {
					count++;
				}

				String poto = StringUtil.nullConvert(params.get("WORKORDERTO"));
				if (poto.isEmpty()) {
					count++;
				}
			}

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
			System.out.println("selectOutWarehousingListGrid params >>>>>>>>> 2 " + params);
			extGrid.setTotcnt(scmOutprocessService.selectOutWarehousingCount(params));
			extGrid.setData(scmOutprocessService.selectOutWarehousingList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutWarehousingListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2018.03.14 외주입고관리 현황 내역 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutWarehousingGrid.do")
	@ResponseBody
	public Object selectOutWarehousingGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutWarehousingGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String transno = StringUtil.nullConvert(params.get("OUTTRANSNO"));
			String orgid = StringUtil.nullConvert(params.get("orgid"));
			String companyid = StringUtil.nullConvert(params.get("companyid"));
			if (!transno.isEmpty()) {
				System.out.println("transno >>>>>>>>> " + transno);
				System.out.println("orgid >>>>>>>>> " + orgid);
				System.out.println("companyid >>>>>>>>> " + companyid);
			} else {
				String gubun = StringUtil.nullConvert(params.get("GUBUN"));
				if (gubun.isEmpty()) {

					String pofrom = StringUtil.nullConvert(params.get("WORKORDERFROM"));
					if (pofrom.isEmpty()) {
						count++;
					}

					String poto = StringUtil.nullConvert(params.get("WORKORDERTO"));
					if (poto.isEmpty()) {
						count++;
					}
				}

				// 아이템 코드 가져오는 부분
				List<?> noList = dao.list("scm.outprocess.detail.first.select", params);
				System.out.println("noList >>>>>>>>>> " + noList);

				if (noList.size() > 0) {
					HashMap<String, Object> noMap = (HashMap<String, Object>) noList.get(0);
					System.out.println("noMap >>>>>>>>>> " + noMap);
					if (noMap.size() > 0) {
						params.put("OUTTRANSNO", noMap.get("OUTTRANSNO"));
						params.put("ORGID", noMap.get("ORGID"));
						params.put("COMPANYID", noMap.get("COMPANYID"));
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
			extGrid.setTotcnt(scmOutprocessService.selectScmOutprocessDetailCount(params));
			extGrid.setData(scmOutprocessService.selectScmOutprocessDetail(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutWarehousingGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	//  여기까지 입고등록 조회화면
	

	//  여기부터 입고등록 등록 수정화면
	/**
	 * 2018.03.14 입고등록 화면 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutWarehousingRegistDetail.do")
	public String showOutWarehousingRegistDetail(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "외주입고상세정보");

		System.out.println("showOutWarehousingRegistDetail Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			// 2.  
			String transno = StringUtil.nullConvert(requestMap.get("OUTTRANSNO"));
			if (!transno.isEmpty()) {
				HashMap<String, Object> params = new HashMap<String, Object>();
				String orgid = StringUtil.nullConvert(requestMap.get("org"));
				String companyid = StringUtil.nullConvert(requestMap.get("company"));
				// 불량유형
				params.put("ORGID", orgid );
				params.put("COMPANYID", companyid );
				List<?> faulttypeList = dao.selectListByIbatis("prod.work.fault.group.list.select", params);
				
				if ( faulttypeList.size() > 0 ) {
					HashMap<String, Object> faulttypeMap = (HashMap<String, Object>) faulttypeList.get(0);

					String value = StringUtil.nullConvert(faulttypeMap.get("VALUE"));
					String label = StringUtil.nullConvert(faulttypeMap.get("LABEL"));
					
					requestMap.put("FAULTTYPE", value);
					requestMap.put("FAULTTYPENAME", label);
				}
			} else {
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

				//데이터 조회 처리
				System.out.println(" RequestMap. >>>>>>>>>>" + requestMap);
				String no = StringUtil.nullConvert(requestMap.get("no"));

				// 요청번호 없을 경우 
				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println(" orgid. >>>>>>>>>>" + orgid);
				System.out.println(" companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1  groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", 1);
						params.put("ORGID", 1);
					} else {
						System.out.println("2  groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", orgid);
						params.put("ORGID", orgid);
					}
				} else {
					System.out.println("3  groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", orgid);
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
						requestMap.put("COMPANYID", "");
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
				System.out.println("no >>>>>>>>>> " + no);

				if (no.equals("") || "".equals(no)) {

				} else {
					// 요청번호 받았을 경우
					String org = StringUtil.nullConvert(requestMap.get("org"));
					String company = StringUtil.nullConvert(requestMap.get("company"));
					String customer = StringUtil.nullConvert(requestMap.get("customer"));
					String person = StringUtil.nullConvert(requestMap.get("person"));
					String remark = StringUtil.nullConvert(requestMap.get("remark"));
					System.out.println("6 showOutWarehousingRegistDetail org. >>>>>>>>>>" + org);
					System.out.println("6 showOutWarehousingRegistDetail company. >>>>>>>>>>" + company);
					System.out.println("6 showOutWarehousingRegistDetail customer. >>>>>>>>>>" + customer);
					System.out.println("6 showOutWarehousingRegistDetail person. >>>>>>>>>>" + person);
					System.out.println("6 showOutWarehousingRegistDetail remark. >>>>>>>>>>" + remark);
					requestMap.put("OUTTRANSNO", no); // 수정
					requestMap.put("ORGID", org);
					requestMap.put("COMPANYID", company);
					requestMap.put("CUSTOMER", customer);
					requestMap.put("PERSON", person);
					requestMap.put("REMARK", remark);
					labelBox.put("findByOrgId", searchService.OrgLovList(params));
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
				}

				model.addAttribute("labelBox", labelBox);

				// 로그인 사용자명
				//				if (!groupid.equals("ROLE_ADMIN")) {
				//					params.put("ROLEUSER", loVo.getId());
				//					System.out.println("params >>>>>>>>>> " + params);
				//					List<?> userList2 = dao.list("search.login.name.lov.select", params);
				//					Map<String, Object> userData2 = (Map<String, Object>) userList2.get(0);
				//					String employeenumber = StringUtil.nullConvert(userData2.get("VALUE"));
				//					String krname = StringUtil.nullConvert(userData2.get("LABEL"));
				//
				//					requestMap.put("EMPLOYEENUMBER", employeenumber);
				//					requestMap.put("KRNAME", krname);
				//				}

				// 현재 사용자의 회사명, ID 조회
				if (groupid.equals("ROLE_ADMIN") || groupid.equals("ROLE_MANAGER")) {
					requestMap.put("CustomerCode", "admin");
				} else {
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

				// 불량유형
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				List<?> faulttypeList = dao.selectListByIbatis("prod.work.fault.group.list.select", params);
				
				if ( faulttypeList.size() > 0 ) {
					HashMap<String, Object> faulttypeMap = (HashMap<String, Object>) faulttypeList.get(0);

					String value = StringUtil.nullConvert(faulttypeMap.get("VALUE"));
					String label = StringUtil.nullConvert(faulttypeMap.get("LABEL"));
					
					requestMap.put("FAULTTYPE", value);
					requestMap.put("FAULTTYPENAME", label);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);
		System.out.println(" showOutWarehousingRegistDetail >>>>>>>>>> ");

		return "/scm/outprocess/OutWarehousingRegist";
	}

	/**
	 * 2018.03.15 외주입고관리 등록수정화면 // Grid 상세 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutprocessRegist.do")
	@ResponseBody
	public Object selectOutprocessRegistGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutprocessRegistGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String TransNo = StringUtil.nullConvert(params.get("OUTTRANSNO"));
			if (TransNo.isEmpty()) {
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
			extGrid.setTotcnt(scmOutprocessService.selectScmOutprocessRegistDetailCount(params));
			extGrid.setData(scmOutprocessService.selectScmOutprocessRegistDetail(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutprocessRegistGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2018.03.20 외주입고상세정보 화면에서 입고대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/ScmOutprocessRegistPop.do")
	@ResponseBody
	public Object ScmOutprocessRegistPop(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("ScmOutprocessRegistPop Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(scmOutprocessService.ScmOutprocessRegistPopTotCnt(params));
			extGrid.setData(scmOutprocessService.ScmOutprocessRegistPopList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("ScmOutprocessRegistPop End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2018.03.22 외주입고관리 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/outprocess/OutWarehousingRegist.do")
	@ResponseBody
	public Object insertOutWarehousingRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertOutWarehousingRegist Params. >>>>>>>>>> " + params);

		return scmOutprocessService.insertOutWarehousingRegist(params);
	}

	/**
	 * 2018.03.22 외주입고관리 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/outprocess/OutWarehousingRegistGrid.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertOutWarehousingRegistGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertScmOutWarehousingGrid Start. >>>>>>>>>> " + params);

		mav.addObject("result", scmOutprocessService.insertOutWarehousingRegistGrid(params)); //insertProdOuttransManageGrid(params));
		return mav;
	}

	/**
	 * 2018.03.23 외주입고관리 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/outprocess/OutWarehousingRegist.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateOutWarehousingRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateOutWarehousingRegist Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = scmOutprocessService.updateOutWarehousingRegist(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2018.03.23 외주입고관리 등록 수정 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/outprocess/OutWarehousingRegistGrid.do", method = RequestMethod.POST)
	public ModelAndView updateOutWarehousingRegistGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateOutWarehousingRegistGrid Start. >>>>>>>>>> " + params);
		mav.addObject("result", scmOutprocessService.updateOutWarehousingRegistGrid(params));
		return mav;
	}

	/**
	 * 2018.03.26 외주입고관리 등록 수정화면 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/scm/outprocess/OutWarehousingRegistDetail.do")
	@ResponseBody
	public Object deleteScmOutprocessRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteScmOutWarehousingRegistDetail Start. >>>>>>>>>> " + params);

		return scmOutprocessService.deleteScmOutprocessRegistDetail(params);
	}

	/**
	 * 2018.03.26 입하상세정보 마스터데이터 삭제 // 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/scm/outprocess/OutWarehousingRegistHeader.do")
	@ResponseBody
	public Object deleteScmOutprocessRegistDM(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteScmOutWarehousingRegistHeader Params. >>>>>>>>>> " + params);

		return scmOutprocessService.deleteScmOutprocessRegistHeader(params);
	}

	//  여기부터 입고등록(SCM관리자) 조회화면
	/**
	 * 2018.03.09 외주입고관리 SCM 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/ScmOutTransList.do")
	public String showProdOutTransSCMListRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "외주입고관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showScmOutTransListPage Dummy. >>>>>>>>>>" + dummy);

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

			// 불량유형
			params.put("ORGID", result_org );
			params.put("COMPANYID", result_comp );
			params.put("OUTTRANSCHK", "Y");
			List<?> faulttypeList = dao.selectListByIbatis("prod.work.fault.group.list.select", params);
			
			if ( faulttypeList.size() > 0 ) {
				HashMap<String, Object> faulttypeMap = (HashMap<String, Object>) faulttypeList.get(0);

				String value = StringUtil.nullConvert(faulttypeMap.get("VALUE"));
				String label = StringUtil.nullConvert(faulttypeMap.get("LABEL"));
				
				requestMap.put("FAULTTYPE", value);
				requestMap.put("FAULTTYPENAME", label);
			}

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/scm/outprocess/ScmOutTransList";
	}

	/**
	 * 2018.03.09 외주입고관리 SCM 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutTransList.do")
	@ResponseBody
	public Object selectOutTransListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutTransListGrid Start. >>>>>>>>>> " + params);
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
			if (gubun.isEmpty()) {

				String pofrom = StringUtil.nullConvert(params.get("WORKORDERFROM"));
				if (pofrom.isEmpty()) {
					count++;
				}

				String poto = StringUtil.nullConvert(params.get("WORKORDERTO"));
				if (poto.isEmpty()) {
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
			System.out.println("selectOutWarehousingHeader params >>>>>>>>> 2 " + params);
			extGrid.setTotcnt(scmOutprocessService.selectOutWarehousingCount(params));
			extGrid.setData(scmOutprocessService.selectOutWarehousingList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutWarehousingGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2018.03.14 외주입고관리 SCM 현황 내역 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutTransGrid.do")
	@ResponseBody
	public Object selectScmOutTransRegistDetail(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectScmOutTransDetail Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String transno = StringUtil.nullConvert(params.get("OUTTRANSNO"));
			String orgid = StringUtil.nullConvert(params.get("orgid"));
			String companyid = StringUtil.nullConvert(params.get("companyid"));
			if (!transno.isEmpty()) {
				System.out.println("transno >>>>>>>>> " + transno);
				System.out.println("orgid >>>>>>>>> " + orgid);
				System.out.println("companyid >>>>>>>>> " + companyid);
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
			extGrid.setTotcnt(scmOutprocessService.selectScmOutprocessDetailCount(params));
			extGrid.setData(scmOutprocessService.selectScmOutprocessDetail(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectScmOutTransDetail End. >>>>>>>>>> ");
		return extGrid;
	}
	//  여기까지 입고등록(SCM관리자) 조회화면

	
	//  여기부터 입고등록(SCM관리자) 등록 수정화면
	/**
	 * 2018.03.14 입고등록 화면 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutTransRegistDetail.do")
	public String showScmOutTransRegistD(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

//		model.addAttribute("pageTitle", "외주입고상세정보(SCM입고용)");

		System.out.println("showProdOutTransManage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			// 2.  
			String transno = StringUtil.nullConvert(requestMap.get("OUTTRANSNO"));
			if (!transno.isEmpty()) {
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				String orgid = StringUtil.nullConvert(requestMap.get("org"));
				String companyid = StringUtil.nullConvert(requestMap.get("company"));
				// 불량유형
				params.put("ORGID", orgid );
				params.put("COMPANYID", companyid );
				params.put("OUTTRANSCHK", "Y");
				List<?> faulttypeList = dao.selectListByIbatis("prod.work.fault.group.list.select", params);
				
				if ( faulttypeList.size() > 0 ) {
					HashMap<String, Object> faulttypeMap = (HashMap<String, Object>) faulttypeList.get(0);

					String value = StringUtil.nullConvert(faulttypeMap.get("VALUE"));
					String label = StringUtil.nullConvert(faulttypeMap.get("LABEL"));
					
					requestMap.put("FAULTTYPE", value);
					requestMap.put("FAULTTYPENAME", label);
				}
			} else {
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

				//데이터 조회 처리
				System.out.println(" RequestMap. >>>>>>>>>>" + requestMap);
				String no = StringUtil.nullConvert(requestMap.get("no"));

				// 요청번호 없을 경우 
				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println(" orgid. >>>>>>>>>>" + orgid);
				System.out.println(" companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1  groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2  groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
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
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
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
					model.addAttribute("pageTitle", "외주입고등록");
				} else {
					model.addAttribute("pageTitle", "외주입고상세정보");
					// 요청번호 받았을 경우
					String org = StringUtil.nullConvert(requestMap.get("org"));
					String company = StringUtil.nullConvert(requestMap.get("company"));
					String customer = StringUtil.nullConvert(requestMap.get("customer"));
					String person = StringUtil.nullConvert(requestMap.get("person"));
					String remark = StringUtil.nullConvert(requestMap.get("remark"));
					System.out.println("6 showPurchaseRequestListPage org. >>>>>>>>>>" + org);
					System.out.println("6 showPurchaseRequestListPage company. >>>>>>>>>>" + company);
					System.out.println("6 showPurchaseRequestListPage customer. >>>>>>>>>>" + customer);
					System.out.println("6 showPurchaseRequestListPage person. >>>>>>>>>>" + person);
					System.out.println("6 showPurchaseRequestListPage remark. >>>>>>>>>>" + remark);
					requestMap.put("OUTTRANSNO", no); // 수정
					requestMap.put("ORGID", org);
					requestMap.put("COMPANYID", company);
					requestMap.put("CUSTOMER", customer);
					requestMap.put("PERSON", person);
					requestMap.put("REMARK", remark);
					labelBox.put("findByOrgId", searchService.OrgLovList(params));
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
				}

				model.addAttribute("labelBox", labelBox);

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
				
				// 불량유형
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				params.put("OUTTRANSCHK", "Y");
				List<?> faulttypeList = dao.selectListByIbatis("prod.work.fault.group.list.select", params);
				
				if ( faulttypeList.size() > 0 ) {
					HashMap<String, Object> faulttypeMap = (HashMap<String, Object>) faulttypeList.get(0);

					String value = StringUtil.nullConvert(faulttypeMap.get("VALUE"));
					String label = StringUtil.nullConvert(faulttypeMap.get("LABEL"));
					
					requestMap.put("FAULTTYPE", value);
					requestMap.put("FAULTTYPENAME", label);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);
		System.out.println(" OutTransManage >>>>>>>>>> ");

		return "/scm/outprocess/ScmOutTransRegist";
	}

	/**
	 * 2018.03.15 외주입고관리 등록수정화면 // Grid 상세 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutTransRegist.do")
	@ResponseBody
	public Object selectScmOutTransRegistDGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdOuttransOutTransManageGrid Start. >>>>>>>>>> " + params);
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
			
			String transno = StringUtil.nullConvert(params.get("OUTTRANSNO"));
			if (transno.isEmpty()) {
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
			extGrid.setTotcnt(scmOutprocessService.selectScmOutprocessRegistDetailCount(params));
			extGrid.setData(scmOutprocessService.selectScmOutprocessRegistDetail(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdOuttransOutTransManageDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	//  여기까지 입고등록(SCM관리자) 등록 수정화면

	/**
	 * 외주공정 LOT 바코드 관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutProcLotRegist.do")
	public String showOutProcLotRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "외주공정 LOT 바코드 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("scm.mat.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMatReceivingInspRegistPage Dummy. >>>>>>>>>>" + dummy);

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
					requestMap.put("ORGID", 1);
					params.put("ORGID", 1); //임의의값
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
					requestMap.put("COMPANYID", 1);
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

		return "/scm/outprocess/OutProcLotRegist";
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutProcLotRegistD.do")
	public String showMatLotBarcodeRegistD(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showMatReceivingInspRegistD Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

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

			//데이터 조회 처리
			System.out.println(" RequestMap. >>>>>>>>>>" + requestMap);
			String no = StringUtil.nullConvert(requestMap.get("no"));

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println(" orgid. >>>>>>>>>>" + orgid);
			System.out.println(" companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1  groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2  groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", 1);
					params.put("ORGID", 1); //임의의값
				}
			} else {
				System.out.println("3  groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4  groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				} else {
					System.out.println("5  groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", 1);
					params.put("ORGID", 1);//임의의값
					params.put("COMPANYID", 1);//임의의값
				}
			} else {
				System.out.println("6  groupid. >>>>>>>>>>" + groupid);
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

			if (no.equals("") || "".equals(no)) {
				model.addAttribute("pageTitle", "외주공정 LOT 바코드 등록");
			} else {
				// 요청번호 받았을 경우
				model.addAttribute("pageTitle", "외주공정 LOT 바코드 상세/수정");
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("6 org. >>>>>>>>>>" + org);
				System.out.println("6 company. >>>>>>>>>>" + company);
				requestMap.put("LOTNO", no); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
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

		return "/scm/outprocess/OutProcLotRegistD";
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Master List 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutProcLotRegist.do")
	@ResponseBody
	public Object selectOutProcLotRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcLotRegist Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(scmOutprocessService.selectOutProcLotRegistMasterTotCnt(params));
			extGrid.setData(scmOutprocessService.selectOutProcLotRegistMasterList(params));
		}

		System.out.println("selectOutProcLotRegist End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Detail List 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutProcLotRegistD.do")
	@ResponseBody
	public Object selectOutProcLotRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcLotRegistD Start. >>>>>>>>>> " + params);
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
			if (gubun.isEmpty()) {
				String lotno = StringUtil.nullConvert(params.get("LOTNO"));
				if (lotno.isEmpty()) {
					count++;
				}
			} else {
				String firstlotno = StringUtil.nullConvert(scmOutprocessService.selectOutProcLotRegistFirstMasterList(params));
				System.out.println("firstlotno >>>>>>>>> " + firstlotno);

				if (firstlotno != "") {
					params.put("LOTNO", firstlotno);
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
			extGrid.setTotcnt(scmOutprocessService.selectOutProcLotRegistDetailTotCnt(params));
			extGrid.setData(scmOutprocessService.selectOutProcLotRegistDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutProcLotRegistD End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Lot 발행예정 PopUp List 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/ListPop/scm/outprocess/OutProcLotRegist.do")
	@ResponseBody
	public Object selectOutProcLotRegistPopUp(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcLotRegistPopUp Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(scmOutprocessService.OutProcLotRegistPopTotCnt(params));
			extGrid.setData(scmOutprocessService.OutProcLotRegistPopList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutProcLotRegistPopUp End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Master 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/outprocess/OutProcLotRegist.do")
	@ResponseBody
	public Object insertOutProcLotRegist(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertOutProcLotRegist Params. >>>>>>>>>> " + params);

		return scmOutprocessService.insertOutProcLotRegist(params);
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Detail 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/outprocess/OutProcLotRegistD.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertOutProcLotRegistD(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertOutProcLotRegistD Start. >>>>>>>>>> " + params);

		mav.addObject("result", scmOutprocessService.insertOutProcLotRegistD(params));
		return mav;
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Master 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/outprocess/OutProcLotRegist.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateOutProcLotRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateOutProcLotRegist Start. >>>>>>>>>> " + params);
		Object result = null;
		try {
			result = scmOutprocessService.updateOutProcLotRegist(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Detail 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/outprocess/OutProcLotRegistD.do", method = RequestMethod.POST)
	public ModelAndView updateOutProcLotRegistD(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("updateOutProcLotRegistD Start. >>>>>>>>>> " + params);

		mav.addObject("result", scmOutprocessService.updateOutProcLotRegistD(params));
		return mav;
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Master 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/scm/outprocess/OutProcLotRegist.do")
	@ResponseBody
	public Object deleteOutProcLotRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteOutProcLotRegist Start. >>>>>>>>>> " + params);

		return scmOutprocessService.deleteOutProcLotRegist(params);
	}

	/**
	 * 외주공정 LOT 바코드 등록 // Detail 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/scm/outprocess/OutProcLotRegistD.do")
	@ResponseBody
	public Object deleteOutProcLotRegistD(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteOutProcLotRegistD Params. >>>>>>>>>> " + params);

		return scmOutprocessService.deleteOutProcLotRegistD(params);
	}

	//  여기부터 외주공정검사관리(SCM)
	/**
	 * 외주공정검사 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutProcessInspRegist.do")
	public String showMatReceivingInspRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "외주공정검사 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("scm.mat.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOutProcessInspRegistPage Dummy. >>>>>>>>>>" + dummy);

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
			//System.out.println("show requestMap. >>>>>>>>>>" + requestMap);
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
					requestMap.put("ORGID", 1);
					params.put("ORGID", 1); //임의의값
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
					requestMap.put("COMPANYID", 1);
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

			// 판정구분
			requestMap.put("CHECKYN", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "QM");
			params.put("MIDDLECD", "CHECK_YN");
			params.put("GUBUN", "CHECKYN");

			labelBox.put("findByCheckYn", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

			if (groupid.equals("ROLE_ADMIN") || groupid.equals("ROLE_MANAGER")) {
				requestMap.put("CustomerCode", "admin");
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

		return "/scm/outprocess/OutProcessInspRegist";
	}

	/**
	 * 외주공정검사 등록 // Detail Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutProcessInspRegistD.do")
	public String showMatReceivingInspRegistD(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showOutProcessInspRegistD Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

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

			//데이터 조회 처리
			System.out.println(" RequestMap. >>>>>>>>>>" + requestMap);
			String no = StringUtil.nullConvert(requestMap.get("no"));

			// 요청번호 없을 경우 
			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("orgid. >>>>>>>>>>" + orgid);
			System.out.println("companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1  groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2  groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", 1);
					params.put("ORGID", 1); //임의의값
				}
			} else {
				System.out.println("3  groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4  groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				} else {
					System.out.println("5  groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", 1);
					params.put("ORGID", 1);//임의의값
					params.put("COMPANYID", 1);//임의의값
				}
			} else {
				System.out.println("6  groupid. >>>>>>>>>>" + groupid);
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

			if (no.equals("") || "".equals(no)) {
				model.addAttribute("pageTitle", "외주공정검사 등록");
			} else {
				// 요청번호 받았을 경우
				model.addAttribute("pageTitle", "외주공정검사 상세/수정");
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("6 org. >>>>>>>>>>" + org);
				System.out.println("6 company. >>>>>>>>>>" + company);
				requestMap.put("INSPECTIONPLANNO", no); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			}

			model.addAttribute("labelBox", labelBox);

			if (groupid.equals("ROLE_ADMIN") || groupid.equals("ROLE_MANAGER")) {
				requestMap.put("CustomerCode", "admin");
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

		return "/scm/outprocess/OutProcessInspRegistD";
	}

	/**
	 * 외주공정검사 등록 // Master List 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutProcessInspMasterRegist.do")
	@ResponseBody
	public Object selectMatReceivingInspMasterRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcessInspMasterRegist Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(scmOutprocessService.selectOutProcessInspMasterTotCnt(params));
			extGrid.setData(scmOutprocessService.selectOutProcessInspMasterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutProcessInspMasterRegist End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주공정검사 등록 // Detail List 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutProcessInspDetailRegist.do")
	@ResponseBody
	public Object selectMatReceivingInspDetailRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcessInspDetailRegist Start. >>>>>>>>>> " + params);
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
			if (gubun.isEmpty()) {
				String inspectionplanno = StringUtil.nullConvert(params.get("INSPECTIONPLANNO"));
				System.out.println("INSPECTIONPLANNO >>>>>>>>> " + inspectionplanno);
				if (inspectionplanno.isEmpty()) {
					count++;
				}
			} else {
				String firstinspectionplanno = StringUtil.nullConvert(scmOutprocessService.selectOutProcessInspMasterFirstList(params));
				System.out.println("firstinspectionplanno >>>>>>>>> " + firstinspectionplanno);

				if (firstinspectionplanno != "") {
					params.put("INSPECTIONPLANNO", firstinspectionplanno);
				} else {
					count++;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("COUNT >>>>>>>>> " + count);
		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(scmOutprocessService.selectOutProcessInspDetailTotCnt(params));
			extGrid.setData(scmOutprocessService.selectOutProcessInspDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatReceivingInspDetailRegist End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2018.04.19 외주공정검사등록 화면에서 입고대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/ScmOutprocessInspRegistPop.do")
	@ResponseBody
	public Object selectOutProcessInspRegistPopUp(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("OutProcessInspRegistPop.do Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(scmOutprocessService.selectOutProcessInspRegistPopTotCnt(params));
			extGrid.setData(scmOutprocessService.selectOutProcessInspRegistPopList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("ScmOutWarehousingRegistPop End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 외주공정검사 등록// 입고대기 PopUp의 적용부분 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutProcessInspPopup.do")
	@ResponseBody
	public Object selectOutProcessInspRegistApplyPopUp(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcessInspRegistApplyPopUp Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(scmOutprocessService.selectOutProcessInspRegistApplyTotCnt(params));
			extGrid.setData(scmOutprocessService.selectOutProcessInspRegistApplyList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutProcessInspRegistApplyPopUp End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 외주공정검사 등록 // Master 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/outprocess/OutProcessInspRegist.do")
	@ResponseBody
	public Object insertOutProcessInspRegist(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertOutProcessInspRegist Params. >>>>>>>>>> " + params);

		return scmOutprocessService.insertOutProcessInspRegist(params);
	}

	/**
	 * 외주공정검사 등록 // Detail 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/outprocess/OutProcessInspRegistD.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertOutProcessInspRegistD(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertOutProcessInspRegistD Start. >>>>>>>>>> " + params);

		mav.addObject("result", scmOutprocessService.insertOutProcessInspRegistD(params));
		return mav;
	}

	/**
	 * 외주공정검사 등록 // Master 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/outprocess/OutProcessInspRegist.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateOutProcessInspRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateOutProcessInspRegistD Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = scmOutprocessService.updateOutProcessInspRegist(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 외주공정검사 등록 // Detail 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/outprocess/OutProcessInspRegistD.do", method = RequestMethod.POST)
	public ModelAndView updateOutProcessInspRegistD(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateOutProcessInspRegistD Start. >>>>>>>>>> " + params);

		mav.addObject("result", scmOutprocessService.updateOutProcessInspRegistD(params));
		return mav;
	}

	/**
	 * 외주공정검사 등록 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/scm/outprocess/OutProcessInspRegistMD.do")
	@ResponseBody
	public Object deleteOutProcessInspRegistMD(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteOutProcessInspRegistMD Params. >>>>>>>>>> " + params);

		return scmOutprocessService.deleteOutProcessInspRegistMD(params);
	}

	/**
	 * 외주공정검사관리 // 검사번호 Lov List를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutProcessInspNoListLov.do")
	@ResponseBody
	public Object MatReceivingInspNoLovList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("OutProcessInspNoLovList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String inspfrom = StringUtil.nullConvert(params.get("INSPFROM"));
			if (inspfrom.isEmpty()) {
				count++;
			}

			String inspto = StringUtil.nullConvert(params.get("INSPTO"));
			if (inspto.isEmpty()) {
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
			extGrid.setTotcnt(scmOutprocessService.OutProcessInspNoLovTotCnt(params));
			extGrid.setData(scmOutprocessService.OutProcessInspNoLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("OutProcessInspNoLovList End. >>>>>>>>>>");
		return extGrid;
	}

	//  여기까지 외주검사관리(SCM)

	// 여기부터 외주공정 발주현황조회
	/**
	 * 외주공정 발주현황 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/OutProcOrderStateList.do")
	public String showMatOrderStateListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "외주발주현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
//			List dummyList = dao.selectListByIbatis("scm.mat.dummy.month.select", requestMap);
//			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
//			System.out.println("showOutProcOrderStateListPage Dummy. >>>>>>>>>>" + dummy);
//
//			if (dummy.size() > 0) {
//				// 더미 사용
//				requestMap.put("dateFrom", dummy.get("DATEFROM"));
//				requestMap.put("dateTo", dummy.get("DATETO"));
//			}
			
			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, -1, 0, "yyyy-MM-dd");
			String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 1, "yyyy-MM-dd");

			requestMap.put("dateFrom", datefrom);
			requestMap.put("dateTo", dateto);

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
					requestMap.put("ORGID", 1);
					params.put("ORGID", 1); //임의의값
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
					requestMap.put("COMPANYID", 1);
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

		return "/scm/outprocess/OutProcOrderStateList";
	}

	/**
	 * 외주공정 발주현황 조회 // Grid화면을 처리한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/OutProcOrderStateList.do")
	@ResponseBody
	public Object selectOutProcOrderStateList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutProcOrderStateList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(scmOutprocessService.selectOutProcOrderStateTotCnt(params));
			extGrid.setData(scmOutprocessService.selectOutProcOrderStateList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutProcOrderStateList End. >>>>>>>>>> ");
		return extGrid;
	}
	// 여기까지 외주공정 발주현황조회 끝

	/**
	 * 기준단가 // 상태 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/outprocess/OutProcOrderStateList.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertOutProcOrderStateList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertMatTransDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", scmOutprocessService.insertOutProcOrderStateList(params));
		return mav;
	}
	
	
	/**
	 * 외주입고 확정 // 상태 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/scm/outprocess/OutTransDetailStatus.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateOutTransDetailStatus(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateOutTransDetailStatus Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = scmOutprocessService.updateOutTransDetailStatus(params);
			System.out.println("updateOutTransDetailStatus result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * 치공구 반출/회수 현황(scm용)
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/ScmToolInOutList")
	public String showOutProcessScmInOutListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "치공구 반출/회수 현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showOutProcessScmInOutListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 org company 정보 //
			System.out.println("showOutProcessScmInOutListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showOutProcessScmInOutListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showOutProcessScmInOutListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showShipPlanRegistPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showShipPlanRegistPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showOutProcessScmInOutListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 1 );
				} else {
					System.out.println("2 showOutProcessScmInOutListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 1); //임의의값
				}
			} else {
				System.out.println("3 showOutProcessScmInOutListPage groupid. >>>>>>>>>>" + groupid);
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
					params.put("ORGID", 1 );
					params.put("COMPANYID", 1 );
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

			// 반출상태
			requestMap.put("STATUS", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MFG");
			params.put("MIDDLECD", "TOOL_STATUS");
			params.put("GUBUN", "TOOL_STATUS");

			labelBox.put("findByStatus", searchService.SmallCodeLovList(params));
			model.addAttribute("labelBox", labelBox);
			
			if (groupid.equals("ROLE_ADMIN") || groupid.equals("ROLE_MANAGER")) {
				requestMap.put("CustomerCode", "");	
			}else{
				// 현재 사용자의 회사명, ID 조회
				params.put("ROLEUSER", loVo.getId());
				List<?> CustomerList = dao.list("scm.search.customid.select", params);
				System.out.println("4. CustomerData >>>>>>>>>> " + CustomerList);
				if(CustomerList.size() > 0){
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

		return "/scm/outprocess/ScmToolInOutList";
	}
	

	/**
	 * 외주입고대기 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/ScmOutTransWaitList.do")
	public String showScmOutTransWaitListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "외주입고대기");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showScmOutTransListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATESYS"));
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


			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/scm/outprocess/ScmOutTransWaitList";
	}
	
	/**
	 * 외주입고대기 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/scm/outprocess/ScmOutTransWaitList.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public Object insertScmOutTransWaitList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertScmOutTransWaitList Start. >>>>>>>>>> " + params);

		mav.addObject("result", scmOutprocessService.insertScmOutTransWaitList(params));
		return mav;
	}
	
	
	/**
	 * 월별 외주입고현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/ScmOutTransModelList.do")
	public String showScmOutTransModelListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "월별 외주입고현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showScmOutTransModelListPage Dummy. >>>>>>>>>>" + dummy);

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

			System.out.println("7. showScmOutTransModelListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showScmOutTransModelListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/scm/outprocess/ScmOutTransModelList";
	}

	/**
	 * 월별 외주입고 현황  // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/scm/outprocess/ScmOutTransModelList.do")
	@ResponseBody
	public Object selectScmOutTransModelListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectScmOutTransModelListGrid Start. >>>>>>>>>> " + params);
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
			
			String searchmonth = StringUtil.nullConvert(params.get("SEARCHMONTH"));
			if (searchmonth.isEmpty()) {
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
			extGrid.setTotcnt(scmOutprocessService.selectScmOutTransModelCount(params));
			extGrid.setData(scmOutprocessService.selectScmOutTransModelList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectScmOutTransModelListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
}