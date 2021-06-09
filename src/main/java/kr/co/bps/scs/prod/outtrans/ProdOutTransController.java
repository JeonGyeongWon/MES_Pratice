package kr.co.bps.scs.prod.outtrans;

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
 * @author jmpark, ymha
 * @since 2016. 12.
 * @version 1.0
 * @see 조달관리 - 1. 입하등록 - 2. 기타입출고 - 3. 이동출고 - 4. 공급사 반품등록
 * 
 */
@Controller
public class ProdOutTransController extends BaseController {

	@Autowired
	private ProdOutTransService prodOutTransService;

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
	@RequestMapping(value = "/prod/outtrans/OutTransList.do")
	public String showProdOutTransOutTransListRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "외주입고관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("prod.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdOutTransListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			// 로그인 사용자의 org company 정보
			System.out.println("showProdOutTransOutTransListRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdOutTransOutTransListRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdOutTransOutTransListRegistPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("1 showProdOutTransOutTransListRegistPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 showProdOutTransOutTransListRegistPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 showProdOutTransOutTransListRegistPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdOutTransOutTransListRegistPage groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				} else {
					System.out.println("5 showProdOutTransOutTransListRegistPage groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의값
					params.put("COMPANYID", 999); // 임의의값
				}
			} else {
				System.out.println("6 showProdOutTransOutTransListRegistPage groupid. >>>>>>>>>>" + groupid);
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

			// 입하구분
			requestMap.put("TRANSDIV", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MAT");
			params.put("MIDDLECD", "TRANS_DIV");
			params.put("GUBUN", "TRANSDIV");

			labelBox.put("findByTransDiv", searchService.SmallCodeLovList(params));

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

			model.addAttribute("labelBox", labelBox);
			
			System.out.println("showProdOutTransListPage requestMap. >>>>>>>>>>" + requestMap);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/prod/outtrans/OutTransList";
	}

	/**
	 * 2018.03.09 외주입고관리 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/outtrans/OutTransList.do")
	@ResponseBody
	public Object selectOutTransListRegistGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectOutTransListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.isEmpty()) {
				String pofrom = StringUtil.nullConvert(params.get("OUTTRANSFROM"));
				if (pofrom.isEmpty()) {
					count++;
				}

				String poto = StringUtil.nullConvert(params.get("OUTTRANSTO"));
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
			extGrid.setTotcnt(prodOutTransService.selectProdOutTransCount(params));
			extGrid.setData(prodOutTransService.selectProdOutTransList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectOutTransListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2018.03.14 외주입고관리 현황 내역 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/outtrans/OutTransDetail.do")
	@ResponseBody
	public Object selectDistMatMatReceiveRegistDetail(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdOutTransDetail Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			String transno = StringUtil.nullConvert(params.get("OUTTRANSNO"));
			if (!transno.isEmpty()) {
				System.out.println("orgid >>>>>>>>> " + orgid);
				System.out.println("companyid >>>>>>>>> " + companyid);
				System.out.println("transno >>>>>>>>> " + transno);
			} else {
				// 아이템 코드 가져오는 부분
				List<?> noList = dao.list("prod.outtrans.detail.first.select", params);
				System.out.println("noList >>>>>>>>>> " + noList);
				
				if ( noList.size() > 0 ) {

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
			extGrid.setTotcnt(prodOutTransService.selectProdOutTransDetailCount(params));
			extGrid.setData(prodOutTransService.selectProdOutTransDetail(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdOutTransDetail End. >>>>>>>>>> ");
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
	@RequestMapping(value = "/prod/outtrans/OutTransManage.do")
	public String showDistMatMatReceiveRegistD(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "외주입고상세정보");

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

				} else {
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

		return "/prod/outtrans/OutTransManage";
	}

	/**
	 * 2018.03.15 외주입고관리 등록수정화면 // Grid 상세 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/outtrans/OutTransManage.do")
	@ResponseBody
	public Object selectDistMatReceiveRegistDGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdOuttransOutTransManageGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String TransNo = StringUtil.nullConvert(params.get("OUTTRANSNO"));
			if (!TransNo.isEmpty()) {
//				count++;
			} else {
				String pofrom = StringUtil.nullConvert(params.get("OUTTRANSFROM"));
				if (pofrom.isEmpty()) {
					count++;
				}

				String poto = StringUtil.nullConvert(params.get("OUTTRANSTO"));
				if (poto.isEmpty()) {
					count++;
				}
				
				List<?> masterList = dao.list("prod.outtrans.detail.first.select", params);
				System.out.println("masterList >>>>>>>>>> " + masterList);

				if (masterList.size() > 0) {
					HashMap<String, Object> masterMap = (HashMap<String, Object>) masterList.get(0);
					params.put("OUTTRANSNO", masterMap.get("OUTTRANSNO"));
					params.put("ORGID", masterMap.get("ORGID"));
					params.put("COMPANYID", masterMap.get("COMPANYID"));

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
			extGrid.setTotcnt(prodOutTransService.selectProdOutTransManageDetailCount(params));
			extGrid.setData(prodOutTransService.selectProdOutTransManageDetail(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdOuttransOutTransManageDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2018.03.20 외주입고상세정보 화면에서 입고대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/ProdOutTransManagePop.do")
	@ResponseBody
	public Object MatReceiveRegistPop1(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("ProdOutTransManagePop.do Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(prodOutTransService.ProdOutTransMnagePopTotCnt(params));
			extGrid.setData(prodOutTransService.ProdOutTransMnagePopList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("ProdOutTransManagePop End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2018.03.22 외주입고관리 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/outtrans/OutTransManage.do")
	@ResponseBody
	public Object insertDistMatReceiveRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertProdOuttransManage Params. >>>>>>>>>> " + params);

		return prodOutTransService.insertProdOuttransManage(params);
	}

	/**
	 * 2018.03.22 외주입고관리 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/prod/outtrans/OutTransManageGrid.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertDistMatReceiveRegistDGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertProdOuttransManageGrid Start. >>>>>>>>>> " + params);

		mav.addObject("result", prodOutTransService.insertProdOuttransManageGrid(params));
		return mav;
	}
	
	/**
	 * 2018.03.23 외주입고관리 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/prod/outtrans/OutTransManage.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateMatReceiveRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateProdOutTransManageH Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = prodOutTransService.updateProdOutTransManage(params);
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
	@RequestMapping(value = "/update/prod/outtrans/OutTransManageGrid.do", method = RequestMethod.POST)
	public ModelAndView updateMatReceiveRegistDGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateProdOutTransManageD Start. >>>>>>>>>> " + params);
		mav.addObject("result", prodOutTransService.updateProdOutTransManageGrid(params));
		return mav;
	}
	
	/**
	 * 2018.03.26 외주입고관리 등록 수정화면 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/outtrans/ProdOutTransManageD.do")
	@ResponseBody
	public Object deleteDistMatReceiveRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteProdOutTransManageD Start. >>>>>>>>>> " + params);

		return prodOutTransService.deleteProdOutTransManageD(params);
	}

	/**
	 * 2018.03.26 입하상세정보 마스터데이터 삭제 // 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/prod/outtrans/ProdOutTransManageH.do")
	@ResponseBody
	public Object deleteDistMatReceiveRegistDM(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteProdOutTransManageH Params. >>>>>>>>>> " + params);

		return prodOutTransService.deleteProdOutTransManageH(params);
	}

}