package kr.co.bps.scs.dist.mat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : DistMatController.java
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
public class DistMatController extends BaseController {

	@Autowired
	private DistMatService distMatService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	private ArrayList<MultipartFile> uploadFile;

	/**
	 * 2016.12.14 입하관리 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/mat/MatReceiveRegist.do")
	public String showDistMatMatReceiveRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "입하관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("dist.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showPurchaseRequestListPage Dummy. >>>>>>>>>>" + dummy);

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

		return "/dist/mat/MatReceiveRegist";
	}

	/**
	 * 2016.12.14 입하관리현황 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/dist/mat/MatTransMasterList.do")
	@ResponseBody
	public Object selectMatTransMasterListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatTransMasterListGrid Start. >>>>>>>>>> " + params);
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

			String pofrom = StringUtil.nullConvert(params.get("TRANSFROM"));
			if (pofrom.isEmpty()) {
				count++;
			}

			String poto = StringUtil.nullConvert(params.get("TRANSTO"));
			if (poto.isEmpty()) {
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
			extGrid.setTotcnt(distMatService.selectDistMatCount(params));
			extGrid.setData(distMatService.selectDistMatList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatTransMasterListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2016.12.14 입하관리 현황 내역 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/dist/mat/MatTransDetailList.do")
	@ResponseBody
	public Object selectMatTransDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatTransDetailListGrid Start. >>>>>>>>>> " + params);
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
			
			String transno = StringUtil.nullConvert(params.get("TRANSNO"));
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
			extGrid.setTotcnt(distMatService.selectDistMatDetailCount(params));
			extGrid.setData(distMatService.selectDistMatDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatTransDetailListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2016.12.14 입하등록 화면 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/mat/ReceiveRegistD.do")
	public String showDistMatReceiveRegistD(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "입하상세정보");

		System.out.println("showDistMatReceiveRegistD Start >>>>>>>>>>" + requestMap);
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

			// 데이터 조회 처리
			System.out.println(" RequestMap. >>>>>>>>>>" + requestMap);
			String no = StringUtil.nullConvert(requestMap.get("no"));

			// 번호 없을 경우
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

			if (no.isEmpty()) {

			} else {
				// 번호 받았을 경우
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("6 showDistMatReceiveRegistD org. >>>>>>>>>>" + org);
				System.out.println("6 showDistMatReceiveRegistD company. >>>>>>>>>>" + company);
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				requestMap.put("TRANSNO", no); // 수정
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			}

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/dist/mat/MatReceiveRegistD";
	}

	/**
	 * 2016.12.14 입하관리 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/dist/mat/MatTransMasterList.do")
	@ResponseBody
	public Object insertMatTransMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertMatTransMasterList Params. >>>>>>>>>> " + params);

		return distMatService.insertMatTransMasterList(params);
	}

	/**
	 * 2016.12.14 입하관리 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/dist/mat/MatTransDetailList.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertMatTransDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertMatTransDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", distMatService.insertMatTransDetailList(params));
		return mav;
	}

	/**
	 * 2016.12.14 입하관리 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/dist/mat/MatTransMasterList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateMatTransMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateMatTransMasterList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = distMatService.updateMatTransMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2016.12.14 입하관리 등록 수정 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/dist/mat/MatTransDetailList.do", method = RequestMethod.POST)
	public ModelAndView updateMatTransDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateMatTransDetailList Start. >>>>>>>>>> " + params);
		mav.addObject("result", distMatService.updateMatTransDetailList(params));
		return mav;
	}

	/**
	 * 2016.12.19 입하상세정보 마스터데이터 삭제 // 마스터
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/dist/mat/MatTransMasterList.do")
	@ResponseBody
	public Object deleteMatTransMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteMatTransMasterList Params. >>>>>>>>>> " + params);

		return distMatService.deleteMatTransMasterList(params);
	}

	/**
	 * 2016.12.16 입하관리 등록 수정화면 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/dist/mat/MatTransDetailList.do")
	@ResponseBody
	public Object deleteMatTransDetailList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteMatTransDetailList Start. >>>>>>>>>> " + params);

		return distMatService.deleteMatTransDetailList(params);
	}

	//여기까지 입하등록 등록 수정 화면

	/**
	 * 조달관리 > 자재관리 > 기타입출고 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/mat/MatEtcRelRegist.do")
	public String showMatEtcRelRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		System.out.println("showMatEtcRelRegistPage Start. >>>>>>>>>> " + requestMap);

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "기타입출고 조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("dist.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMatEtcRelRegistPage Dummy. >>>>>>>>>>" + dummy);

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

			model.addAttribute("labelBox", labelBox);

			// 기타입출고 구분 값으로 제약
			requestMap.put("USEDIV", "E");

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/dist/mat/MatEtcRelList";
	}

	/**
	 * 조달관리 > 자재관리 > 기타입출고 / 이동출고 / 생산출고 // Grid Master 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/dist/mat/MatRelListMaster.do")
	@ResponseBody
	public Object selectMatRelListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatRelListGrid Start. >>>>>>>>>> " + params);
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

			String searchFrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchFrom.isEmpty()) {
				count++;
			}

			String searchTo = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchTo.isEmpty()) {
				count++;
			}

			String usediv = StringUtil.nullConvert(params.get("USEDIV"));
			if (usediv.isEmpty()) {
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
			String usediv = StringUtil.nullConvert(params.get("USEDIV"));

			if (usediv.equals("E")) {
				// 기타입출고
				extGrid.setTotcnt(distMatService.selectMatEtcRelCount(params));
				extGrid.setData(distMatService.selectMatEtcRelList(params));
			} else if (usediv.equals("M")) {
				// 이동출고
				extGrid.setTotcnt(distMatService.selectMatMoveRelCount(params));
				extGrid.setData(distMatService.selectMatMoveRelList(params));
			} else if (usediv.equals("P")) {
				// 생산출고
				extGrid.setTotcnt(distMatService.selectMatProdRelCount(params));
				extGrid.setData(distMatService.selectMatProdRelList(params));
			} else if (usediv.equals("PS")) {
				// 생산출고(부자재)
				extGrid.setTotcnt(distMatService.selectMatEtcRel2Count(params));
				extGrid.setData(distMatService.selectMatEtcRel2List(params));
			} else {
				// 그외
				extGrid.setTotcnt(0);
				extGrid.setData(null);
			}
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatRelListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 조달관리 > 자재관리 > 기타입출고 / 이동출고 / 생산출고 // Grid 상세 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/dist/mat/MatRelListDetail.do")
	@ResponseBody
	public Object selectMatRelListDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatRelListDetailGrid Start. >>>>>>>>>> " + params);
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
			
			String releaseno = StringUtil.nullConvert(params.get("RELEASENO"));
			if (releaseno.isEmpty()) {
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
			String usediv = StringUtil.nullConvert(params.get("USEDIV"));
			if (usediv.equals("E")) {
				// 기타입출고
				extGrid.setTotcnt(distMatService.selectMatEtcRelDetailCount(params));
				extGrid.setData(distMatService.selectMatEtcRelDetailList(params));
			} else if (usediv.equals("M")) {
				// 이동출고
				extGrid.setTotcnt(distMatService.selectMatMoveRelDetailCount(params));
				extGrid.setData(distMatService.selectMatMoveRelDetailList(params));
			} else if (usediv.equals("P")) {
				// 생산출고
				extGrid.setTotcnt(distMatService.selectMatProdRelDetailCount(params));
				extGrid.setData(distMatService.selectMatProdRelDetailList(params));
			} else if (usediv.equals("PS")) {
				// 생산출고(부자재)
				extGrid.setTotcnt(distMatService.selectMatEtcRelDetailCount(params));
				extGrid.setData(distMatService.selectMatEtcRelDetailList(params));
			}
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatRelListDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 기타입출고 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/mat/MatEtcRelManage.do")
	public String showMatEtcRelManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showMatEtcRelManagePage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			HashMap<String, Object> params = new HashMap<String, Object>();
			String relno = StringUtil.nullConvert(requestMap.get("relno"));
			if (!relno.isEmpty()) {
				model.addAttribute("pageTitle", "기타입출고 상세 / 변경");

				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showMatEtcRelManagePage org. >>>>>>>>>>" + org);
				System.out.println("2 showMatEtcRelManagePage company. >>>>>>>>>>" + company);
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				requestMap.put("RELEASENO", relno); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				// 1. 구분
				requestMap.put("USEDIV", "E");
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "MAT");
				params.put("MIDDLECD", "USE_DIV");
				params.put("keyword", "E");
				labelBox.put("findByUseDiv", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);
			} else {
				model.addAttribute("pageTitle", "기타입출고 등록");

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
						params.put("ORGID", 999);//임의의값
						params.put("COMPANYID", 999);//임의의값
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

				// 1. 구분
				requestMap.put("USEDIV", "E");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MAT");
				params.put("MIDDLECD", "USE_DIV");
				params.put("keyword", "E");
				labelBox.put("findByUseDiv", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);

				System.out.println("9 showMatEtcRelManagePage groupid. >>>>>>>>>>" + groupid);
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

		return "/dist/mat/MatEtcRelRegist";
	}

	/**
	 * 기타입출고 / 이동출고 // Grid 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/dist/mat/MatRelManage.do")
	@ResponseBody
	public Object deleteMatRelManage(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteMatRelManage Params. >>>>>>>>>> " + params);

		return distMatService.deleteMatRelManage(params);
	}

	/**
	 * 기타입출고 / 이동출고 / 생산출고 // Grid 상세 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/dist/mat/MatRelListDetail.do")
	@ResponseBody
	public Object deleteMatRelListDetail(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteMatRelListDetail Start. >>>>>>>>>> " + params);

		return distMatService.deleteMatRelListDetail(params);
	}

	/**
	 * 기타입출고 / 이동출고 / 생산출고 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/dist/mat/MatRelMaster.do")
	@ResponseBody
	public Object insertMatRelMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertMatRelMasterList Params. >>>>>>>>>> " + params);

		return distMatService.insertMatRelMasterList(params);
	}

	/**
	 * 기타입출고 / 이동출고 / 생산출고 // 상세 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/dist/mat/MatRelDetail.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertMatRelDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertMatRelDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", distMatService.insertMatRelDetailList(params));
		return mav;
	}

	/**
	 * 기타입출고 / 이동출고 / 생산출고 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/dist/mat/MatRelMaster.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateMatRelMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateMatRelMasterList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = distMatService.updateMatRelMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 기타입출고 / 이동출고 / 생산출고 // 상세 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/dist/mat/MatRelDetail.do", method = RequestMethod.POST)
	public ModelAndView updateMatRelDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateMatRelDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", distMatService.updateMatRelDetailList(params));
		return mav;
	}

	/**
	 * 조달관리 > 자재관리 > 생산출고(무바코드) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/mat/MatProdRelRegist.do")
	public String showMatProdRelRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		System.out.println("showMatProdRelRegistPage Start. >>>>>>>>>> " + requestMap);

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "생산출고 조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("dist.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMatMoveRelRegistPage Dummy. >>>>>>>>>>" + dummy);

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

			model.addAttribute("labelBox", labelBox);

			// 이동출고 구분 값으로 제약
			requestMap.put("USEDIV", "P");

			// 1. 아이템타입
			requestMap.put("ITEMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");
			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));

			// 1. 아이템타입
			requestMap.put("WORKDEPT", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "WORK_DEPT");
			labelBox.put("findByWorkDept", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/dist/mat/MatProdRelList";
	}

	
	/**
	 * 2017.02.22 입하상세정보 화면에서 입하대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/MatReceiveRegistPop1.do")
	@ResponseBody
	public Object MatReceiveRegistPop1(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("MatReceiveRegistPop1 Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(distMatService.MatReceiveRegistPop1TotCnt(params));
			extGrid.setData(distMatService.MatReceiveRegistPop1List(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("MatReceiveRegistPop1 End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 발주대비 입고현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/dist/mat/MatOrderReceiveList.do")
	public String showMatOrderReceiveListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "발주대비 입고현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showMatOrderReceiveListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
			}
			
			HashMap<String, Object> params = new HashMap<String, Object>();
			
			// 로그인 사용자의 org company 정보 
			System.out.println("showMatOrderReceiveListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showMatOrderReceiveListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showMatOrderReceiveListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showMatOrderReceiveListPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showMatOrderReceiveListPage companyid. >>>>>>>>>>" + companyid);

				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 showMatOrderReceiveListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					}else {
						System.out.println("2 showMatOrderReceiveListPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID",999 );
					}
				}else {
					System.out.println("3 showMatOrderReceiveListPage groupid. >>>>>>>>>>" + groupid);
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
				
 			    // 입고구분
				requestMap.put("TRANSDIV", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MAT");
				params.put("MIDDLECD", "TRANS_DIV");
				params.put("GUBUN", "TRANSDIV");

				labelBox.put("findByTransDiv", searchService.SmallCodeLovList(params));
				
				// 발주구분
				requestMap.put("ORDERDIV", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MAT");
				params.put("MIDDLECD", "ORDER_DIV");
				params.put("GUBUN", "ORDER_DIV");

				labelBox.put("findByOrderDiv", searchService.SmallCodeLovList(params));

				// 발주상태
				requestMap.put("STATUS", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "MAT");
				params.put("MIDDLECD", "STATUS_CODE");
				params.put("GUBUN", "STATUS_CODE");

				labelBox.put("findByStatus", searchService.SmallCodeLovList(params));
				
				// 품목유형
				requestMap.put("ITEMTYPE", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "ITEM_TYPE");
				params.put("GROUPCD", "M");
				params.put("ITEMTYPE", "M");
				params.put("GUBUN", "ITEMTYPE");

				labelBox.put("findByItemType", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/dist/mat/MatOrderReceiveList";
	}
	
	
	/**
	 * 발주대비 입고현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/dist/mat/MatOrderReceiveList.do")
	@ResponseBody
	public Object selectMatOrderReceiveListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatOrderReceiveListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(distMatService.MatOrderReceiveListCnt(params));
			extGrid.setData(distMatService.MatOrderReceiveList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatOrderReceiveListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
}