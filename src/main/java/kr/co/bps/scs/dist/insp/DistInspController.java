package kr.co.bps.scs.dist.insp;

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
 * @ClassName : RequestPurchaseController.java
 * @Description : RequestPurchase Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jmpark
 * @since 2016. 12.
 * @version 1.0
 * @see 물류관리 입고검사
 * 
 */
@Controller
public class DistInspController extends BaseController {

	@Autowired
	private DistInspService distInspService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	private ArrayList<MultipartFile> uploadFile;

	/**
	 * 2016.12.21 입고검사 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/insp/MatReceiptInspRegist.do")
	public String showMatReceiptInspRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "수입검사");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("dist.insp.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMatReceiptInspRegistPage Dummy. >>>>>>>>>>" + dummy);

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

			// 판정구분
			requestMap.put("CHECKYN", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "QM");
			params.put("MIDDLECD", "CHECK_YN");
			params.put("GUBUN", "CHECKYN");

			labelBox.put("findByCheckYn", searchService.SmallCodeLovList(params));

			// 입하구분
			requestMap.put("TRANSDIV", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MAT");
			params.put("MIDDLECD", "TRANS_DIV");
			params.put("GUBUN", "TRANSDIV");

			labelBox.put("findByTransDiv", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/dist/insp/MatReceiptInspRegist";
	}

	/**
	 * 2016.12.14 입하관리현황 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/dist/insp/MatReceiptInspRegist.do")
	@ResponseBody
	public Object selectMatReceiptInspRegistGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatReceiptInspRegistGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String from = StringUtil.nullConvert(params.get("INSPFROM"));
			if (from.isEmpty()) {
				count++;
			}

			String to = StringUtil.nullConvert(params.get("INSPTO"));
			if (to.isEmpty()) {
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
			extGrid.setTotcnt(distInspService.selectMatReceiptInspRegistCount(params));
			extGrid.setData(distInspService.selectMatReceiptInspRegistList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatReceiptInspRegistGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2016.12.21 입고검사(원재료) 현황 디테일 내역 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/dist/insp/MatReceiptInspRegistDetail.do")
	@ResponseBody
	public Object selectMatReceiptInspRegistDetail(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatReceiptInspRegistDetail Start. >>>>>>>>>> " + params);
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

			String inspectionplanno = StringUtil.nullConvert(params.get("INSPECTIONPLANNO"));
			if (inspectionplanno.isEmpty()) {
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
			extGrid.setTotcnt(distInspService.selectMatReceiptInspRegistDetailCount(params));
			extGrid.setData(distInspService.selectMatReceiptInspRegistDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatReceiptInspRegistDetail End. >>>>>>>>>> ");
		return extGrid;
	}

	//    여기까지 입고검사등록 조회화면

	//  여기부터 입고검사등록 등록 수정화면
	/**
	 * 2016.12.21 입고검사등록 화면 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/insp/MatReceiptInspRegistD.do")
	public String showMatReceiptInspRegistD(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "수입검사 상세정보");

		System.out.println("showMatReceiptInspRegistD Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			// 2.  
			String transno = StringUtil.nullConvert(requestMap.get("TRANSNO"));

			if (!transno.isEmpty()) {
				// 요청번호가 있을 경우 상세 조회
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
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					} else {
						System.out.println("2  groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); //임의의값
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
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);//임의의값
						params.put("COMPANYID", 999);//임의의값
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

				// 입하구분
				requestMap.put("TRANSDIV", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MAT");
				params.put("MIDDLECD", "TRANS_DIV");
				params.put("GUBUN", "TRANSDIV");

				labelBox.put("findByTransDiv", searchService.SmallCodeLovList(params));

				if (no.equals("") || "".equals(no)) {

				} else {
					// 요청번호 받았을 경우
					String org = StringUtil.nullConvert(requestMap.get("org"));
					String company = StringUtil.nullConvert(requestMap.get("company"));
					System.out.println("6  org. >>>>>>>>>>" + org);
					System.out.println("6  company. >>>>>>>>>>" + company);
					requestMap.put("INSPECTIONPLANNO", no); // 수정
					requestMap.put("ORGID", org);
					requestMap.put("COMPANYID", company);
					labelBox.put("findByOrgId", searchService.OrgLovList(params));
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
				}

				model.addAttribute("labelBox", labelBox);

				System.out.println("9 showMatReceiptInspRegistD groupid. >>>>>>>>>>" + groupid);
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
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/dist/insp/MatReceiptInspRegistD";
	}

	/**
	 * 2016.12.21 입고검사관리 등록수정화면 // Grid 상세 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/dist/insp/MatReceiptInspRegistD.do")
	@ResponseBody
	public Object selectMatReceiptInspRegistDGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatReceiptInspRegistDGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String InspNo = StringUtil.nullConvert(params.get("INSPECTIONPLANNO"));

			if (InspNo.isEmpty()) {
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
			extGrid.setTotcnt(distInspService.selectMatReceiptInspRegistDCount(params));
			extGrid.setData(distInspService.selectMatReceiptInspRegistDList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatReceiptInspRegistDGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2016.12.21 입고등록관리 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/dist/insp/MatReceiptInspRegistD.do")
	@ResponseBody
	public Object insertMatReceiptInspRegistD(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertMatReceiptInspRegistD Params. >>>>>>>>>> " + params);

		return distInspService.insertMatReceiptInspRegistD(params);
	}

	/**
	 * 2016.12.21 입고등록관리 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/dist/insp/MatReceiptInspRegistDGrid.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertMatReceiptInspRegistDGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertMatReceiptInspRegistDGrid Start. >>>>>>>>>> " + params);

		mav.addObject("result", distInspService.insertMatReceiptInspRegistDGrid(params));
		return mav;
	}

	/**
	 * 2016.12.21 입고검사관리 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/dist/insp/MatReceiptInspRegistD.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateMatReceiptInspRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateMatReceiptInspRegistD Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = distInspService.updateMatReceiptInspRegistD(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2016.12.21 입고검사관리 등록 수정 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/dist/insp/MatReceiptInspRegistDGrid.do", method = RequestMethod.POST)
	public ModelAndView updateMatReceiptInspRegistDGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateMatReceiptInspRegistDGrid Start. >>>>>>>>>> " + params);

		mav.addObject("result", distInspService.updateMatReceiptInspRegistDGrid(params));
		return mav;
	}

	/**
	 * 2016.12.21 입고검사관리 등록 수정화면 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/dist/insp/MatReceiptInspRegistD.do")
	@ResponseBody
	public Object deleteMatReceiptInspRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteMatReceiptInspRegistD Start. >>>>>>>>>> " + params);

		return distInspService.deleteMatReceiptInspRegistD(params);
	}

	/**
	 * 2016.12.21 입고검사 상세정보 마스터데이터 삭제 // 마스터
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/dist/insp/MatReceiptInspRegistDM.do")
	@ResponseBody
	public Object deleteMatReceiptInspRegistDM(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteMatReceiptInspRegistDM Params. >>>>>>>>>> " + params);

		return distInspService.deleteMatReceiptInspRegistDM(params);
	}

	//여기까지 입고검사 등록 등록 수정 화면

	/**
	 * INSPNO // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/MatReceiptInspRegistInspNoListLov.do")
	@ResponseBody
	public Object MatReceiptInspRegistInspNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("MatReceiptInspRegistInspNoListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(distInspService.InspNoLovTotCnt(params));
			extGrid.setData(distInspService.InspNoLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("MatReceiptInspRegistInspNoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.22 INSPNO // 조회 화면에서 마스터 정보 클릭시 세부정보 조회 화면 호출 데이터
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/MatReceiptInspRegistInspNoListLovD.do")
	@ResponseBody
	public Object MatReceiptInspRegistInspNoListLovD(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("MatReceiptInspRegistInspNoListLovD Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String inspno = StringUtil.nullConvert(params.get("INSPECTIONPLANNO"));
			if (inspno.isEmpty()) {
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
			extGrid.setTotcnt(distInspService.InspNoLovDTotCnt(params));
			extGrid.setData(distInspService.InspNoLovDList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("MatReceiptInspRegistInspNoListLovD End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.23 입고검사 상세화면에서 입고검사 LIST // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/MatReceiptInspRegistInspPop.do")
	@ResponseBody
	public Object MatReceiptInspRegistInspPop(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("MatReceiptInspRegistInspPop Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			//			// 필수 조건 미입력시 제약
			//			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			//			if (groupcode.isEmpty()) {
			//				count++;
			//			}
			//
			//			String bigcode = StringUtil.nullConvert(params.get("BIGCODE"));
			//			if (bigcode.isEmpty()) {
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
			extGrid.setTotcnt(distInspService.MatReceiptInspRegistInspPopTotCnt(params));
			extGrid.setData(distInspService.MatReceiptInspRegistInspPopList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("MatReceiptInspRegistInspPop End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.23 입고검사 상세화면에서 아이템별 품질 기준 마스터 // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/MatReceiptInspRegistInspPopCheck.do")
	@ResponseBody
	public Object MatReceiptInspRegistInspPopCheck(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("MatReceiptInspRegistInspPopCheck Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			//			// 필수 조건 미입력시 제약
			//			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			//			if (groupcode.isEmpty()) {
			//				count++;
			//			}
			//
			//			String bigcode = StringUtil.nullConvert(params.get("BIGCODE"));
			//			if (bigcode.isEmpty()) {
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
			extGrid.setTotcnt(distInspService.MatReceiptInspRegistInspPopCheckTotCnt(params));
			extGrid.setData(distInspService.MatReceiptInspRegistInspPopCheckList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("MatReceiptInspRegistInspPopCheck End. >>>>>>>>>>");
		return extGrid;
	}

}