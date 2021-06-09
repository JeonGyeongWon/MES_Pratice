package kr.co.bps.scs.prod.monitor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.NumberUtil;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : ProdMonitorController.java
 * @Description : ProdMonitor Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 07.
 * @version 1.0
 * @see 조회 - SPC 관리도
 *                 LOT 이력관리
 * 
 */
@Controller
public class ProdMonitorController extends BaseController {

	@Autowired
	private ProdMonitorService prodMonitorService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;
	
	private int divCount = 4;
	private int divCount3 = 15;

	/**
	 * SPC 관리도 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/monitor/ProdMonitor4.do")
	public String showProdMonitor4Page(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "SPC 관리도");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdMonitor4Page Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
				requestMap.put("dateMonth", dummy.get("DATEMONTH"));
				requestMap.put("lastDay", dummy.get("LASTDAY"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdMonitor4Page loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdMonitor4Page params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdMonitor4Page groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdMonitor4Page orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdMonitor4Page companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdMonitor4Page groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdMonitor4Page groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showProdMonitor4Page groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdMonitor4Page groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdMonitor4Page groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showProdMonitor4Page groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 검사구분
			requestMap.put("CHECKBIG", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("REMARKS", "Y");

			labelBox.put("findByCheckBig", searchService.CheckBigCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showProdMonitor4Page params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdMonitor4Page requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/monitor/ProdMonitor4";
	}

	/**
	 * SPC 리스트 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/ProdMonitor4.do")
	@ResponseBody
	public Object selectProdMonitor4Grid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdMonitor4Grid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 0. 일자 FROM ~ TO
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}
			
			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
				count++;
			}
			
			// 1. 품번, 품명
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}

			// 2. 공정
			String routingname = StringUtil.nullConvert(params.get("ROUTINGID"));
			if (routingname.isEmpty()) {
				count++;
			}

			// 3. 검사내용
			String checkitemcode = StringUtil.nullConvert(params.get("CHECKLISTID"));
			if (checkitemcode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if ( count > 0 ) {
			extGrid.setData(prodMonitorService.selectSPCDummyList(params));
			extGrid.setTotcnt(prodMonitorService.selectSPCDummyCount(params));
		} else {
			int temp = prodMonitorService.selectSPCCount(params);
			if ( temp == 0 ) {
				extGrid.setData(prodMonitorService.selectSPCDummyList(params));
				extGrid.setTotcnt(prodMonitorService.selectSPCDummyCount(params));
			} else {
				extGrid.setData(prodMonitorService.selectSPCList(params));
				extGrid.setTotcnt(prodMonitorService.selectSPCCount(params));
			}
		}

		System.out.println("selectProdMonitor4Grid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * FmlChart (X-R Chart) // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/XChartGrid.do")
	@ResponseBody
	public Object selectXChartGridGrid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectXChartGridGrid Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 0. 일자 FROM ~ TO
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}
			
			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
				count++;
			}
			
			// 1. 품번, 품명
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}

			// 2. 공정
			String routingname = StringUtil.nullConvert(params.get("ROUTINGID"));
			if (routingname.isEmpty()) {
				count++;
			}

			// 3. 검사내용
			String checkitemcode = StringUtil.nullConvert(params.get("CHECKLISTID"));
			if (checkitemcode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodMonitorService.selectXChartList(params));
			extGrid.setTotcnt(prodMonitorService.selectXChartCount(params));
		}

		System.out.println("selectXChartGridGrid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}

	/**
	 * FmlChart (X-R Chart) // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/RChartGrid.do")
	@ResponseBody
	public Object selectRChartGridGrid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectRChartGridGrid Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 0. 일자 FROM ~ TO
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}
			
			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
				count++;
			}
			
			// 1. 품번, 품명
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}

			// 2. 공정
			String routingname = StringUtil.nullConvert(params.get("ROUTINGID"));
			if (routingname.isEmpty()) {
				count++;
			}

			// 3. 검사내용
			String checkitemcode = StringUtil.nullConvert(params.get("CHECKLISTID"));
			if (checkitemcode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodMonitorService.selectRChartList(params));
			extGrid.setTotcnt(prodMonitorService.selectRChartCount(params));
		}

		System.out.println("selectRChartGridGrid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}

	/**
	 * SPC 결과 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/TotalProdMonitor4.do")
	@ResponseBody
	public Object selectTotalProdMonitor4Grid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectTotalProdMonitor4Grid Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 0. 일자 FROM ~ TO
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}
			
			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
				count++;
			}
			
			// 1. 품번, 품명
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}

			// 2. 공정
			String routingname = StringUtil.nullConvert(params.get("ROUTINGID"));
			if (routingname.isEmpty()) {
				count++;
			}

			// 3. 검사내용
			String checkitemcode = StringUtil.nullConvert(params.get("CHECKLISTID"));
			if (checkitemcode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodMonitorService.selectTotalList(params));
			extGrid.setTotcnt(prodMonitorService.selectTotalCount(params));
		}

		System.out.println("selectTotalProdMonitor4Grid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}


	/**
	 * LOT 이력 관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 * @throws Exception
	 */
	@RequestMapping(value = "/prod/monitor/ProdMonitor3.do")
	public String showProdMonitor3Page(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "LOT 이력 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdMonitor3Page Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("DATEFROM", dummy.get("DATEFROM"));
				requestMap.put("DATETO", dummy.get("DATETO"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showProdMonitor3Page loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showProdMonitor3Page params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showProdMonitor3Page groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showProdMonitor3Page orgid. >>>>>>>>>>" + orgid);
			System.out.println("showProdMonitor3Page companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showProdMonitor3Page groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showProdMonitor3Page groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showProdMonitor3Page groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showProdMonitor3Page groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showProdMonitor3Page groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showProdMonitor3Page groupid. >>>>>>>>>>" + groupid);
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

			System.out.println("7. showProdMonitor3Page params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdMonitor3Page requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);
		return "/prod/monitor/ProdMonitor3";
	}

	/**
	 * 공정 LOT // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/ProdMonitor3Work.do")
	@ResponseBody
	public Object selectProdMonitor3WorkList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3WorkList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}

			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
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
			extGrid.setTotcnt(prodMonitorService.selectProdMonitor3WorkCount(params));
			extGrid.setData(prodMonitorService.selectProdMonitor3WorkList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdMonitor3WorkList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 자재 LOT // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/ProdMonitor3Trans.do")
	@ResponseBody
	public Object selectProdMonitor3TransList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3TransList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}

			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
				count++;
			}

			List<?> workList = dao.list("work.monitor.work.find.select", params);

			System.out.println("selectProdMonitor3TransList workList >>>>>>>>> " + workList);
			if (workList.size() > 0) {
				System.out.println("selectProdMonitor3TransList 2-1 >>>>>>>>> ");
				HashMap<String, Object> woMap = (HashMap<String, Object>) workList.get(0);
				params.put("ORGID", woMap.get("ORGID"));
				params.put("COMPANYID", woMap.get("COMPANYID"));
				params.put("ITEMCODE", woMap.get("ITEMCODE"));
				params.put("LOTNO", woMap.get("LOTNO"));
				params.put("TRANSLOT", woMap.get("TRANSLOT"));
			} else {
				System.out.println("selectProdMonitor3TransList 2-2 >>>>>>>>> ");
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
			extGrid.setTotcnt(prodMonitorService.selectProdMonitor3TransCount(params));
			extGrid.setData(prodMonitorService.selectProdMonitor3TransList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdMonitor3TransList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 출하 LOT // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/ProdMonitor3Warehousing.do")
	@ResponseBody
	public Object selectProdMonitor3WarehousingList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3WarehousingList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}

			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
				count++;
			}

			List<?> workList = dao.list("work.monitor.work.find.select", params);

			System.out.println("selectProdMonitor3WarehousingList workList >>>>>>>>> " + workList);
			if (workList.size() > 0) {
				System.out.println("selectProdMonitor3TransList 2-1 >>>>>>>>> ");
				HashMap<String, Object> woMap = (HashMap<String, Object>) workList.get(0);
				params.put("ORGID", woMap.get("ORGID"));
				params.put("COMPANYID", woMap.get("COMPANYID"));
				params.put("ITEMCODE", woMap.get("ITEMCODE"));
				params.put("LASTLOTNO", woMap.get("LASTLOTNO"));
			} else {
				System.out.println("selectProdMonitor3WarehousingList 2-2 >>>>>>>>> ");
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
			extGrid.setTotcnt(prodMonitorService.selectProdMonitor3WarehousingCount(params));
			extGrid.setData(prodMonitorService.selectProdMonitor3WarehousingList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectProdMonitor3WarehousingList End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 1페이지 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/monitor/ProdMonitorPage1.do")
	public String showProdMonitorPage1(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "실적현황");
		model.addAttribute("pageSubTitle", "실적현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdMonitorPage1 Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
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

			System.out.println("7. showProdMonitorPage1 params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdMonitorPage1 requestMap >>>>>>>>>>>> " + requestMap);

			requestMap.put("ORGID", result_org);
			requestMap.put("COMPANYID", result_comp);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/monitor/ProdMonitorPage1";
	}

	/**
	 * 1페이지 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/ProdMonitorPage1.do")
	@ResponseBody
	public Object selectProdMonitorPage1Grid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdMonitorPage1Grid Start. >>>>>>>>>>");
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
			
			String searchdate = StringUtil.nullConvert(params.get("SEARCHDATE"));
			if (searchdate.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodMonitorService.selectProdMonitorPage1List(params));
			extGrid.setTotcnt(prodMonitorService.selectProdMonitorPage1Count(params));
		}

		System.out.println("selectProdMonitorPage1Grid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}

	/**
	 * 2페이지 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/monitor/ProdMonitorPage2.do")
	public String showProdMonitorPage2(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "공정별 실적현황");
		model.addAttribute("pageSubTitle", "공정별 실적현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 월, 마지막날 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showProdMonitorPage2 Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
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

			System.out.println("7. showProdMonitorPage2 params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdMonitorPage2 requestMap >>>>>>>>>>>> " + requestMap);

			requestMap.put("ORGID", result_org);
			requestMap.put("COMPANYID", result_comp);
			requestMap.put("SEARCHDATE", dummy.get("DATESYS"));
			int totcnt = prodMonitorService.selectProdMonitorPage2Count(requestMap);
			System.out.println("showProdMonitorPage2 totcnt. >>>>>>>>>> " + totcnt);

			requestMap.put("TOTALCOUNT", totcnt);
			requestMap.put("FIRSTPAGE", 1);
			int maxcount = (int) Math.ceil((double) totcnt / (double) divCount);
			System.out.println("showProdMonitorPage2 maxcount. >>>>>>>>>> " + maxcount);
			requestMap.put("LASTPAGE", maxcount);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/monitor/ProdMonitorPage2";
	}

	/**
	 * 2페이지 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/ProdMonitorPage2.do")
	@ResponseBody
	public Object selectProdMonitorPage2Grid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdMonitorPage2Grid Start. >>>>>>>>>>");
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
			
			String searchdate = StringUtil.nullConvert(params.get("SEARCHDATE"));
			if (searchdate.isEmpty()) {
				count++;
			}

			Integer searchPage = NumberUtil.getInteger(params.get("SEARCHPAGE"));
			if (searchPage.equals("")) {
				count++;
			} else {
				int start = (divCount * searchPage) - (divCount - 1);
				int end = searchPage * divCount;
				params.put("PAGESTART", start);
				params.put("PAGEEND", end);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodMonitorService.selectProdMonitorPage2List(params));
			extGrid.setTotcnt(prodMonitorService.selectProdMonitorPage2Count(params));
		}

		System.out.println("selectProdMonitorPage2Grid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}

	/**
	 * 3페이지 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/monitor/ProdMonitorPage3.do")
	public String showProdMonitorPage3(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "설비 가동현황");
		model.addAttribute("pageSubTitle", "설비 가동현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
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

			System.out.println("7. showProdMonitorPage3 params >>>>>>>>>>>> " + params);
			System.out.println("7. showProdMonitorPage3 requestMap >>>>>>>>>>>> " + requestMap);

			requestMap.put("ORGID", result_org);
			requestMap.put("COMPANYID", result_comp);
			int totcnt = prodMonitorService.selectProdMonitorPage3Count(requestMap);
			System.out.println("showProdMonitorPage3 totcnt. >>>>>>>>>> " + totcnt);

			requestMap.put("TOTALCOUNT", totcnt);
			requestMap.put("FIRSTPAGE", 1);
			int maxcount = (int) Math.ceil((double) totcnt / (double) divCount3);
			System.out.println("showProdMonitorPage3 maxcount. >>>>>>>>>> " + maxcount);
			requestMap.put("LASTPAGE", maxcount);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/monitor/ProdMonitorPage3";
	}

	/**
	 * 3페이지 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/ProdMonitorPage3.do")
	@ResponseBody
	public Object selectProdMonitorPage3Grid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdMonitorPage3Grid Start. >>>>>>>>>>");
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
			
			Integer searchPage = NumberUtil.getInteger(params.get("SEARCHPAGE"));
			if (searchPage.equals("")) {
				count++;
			} else {
				int start = (divCount3 * ( searchPage - 1 ) ) + 1;
				int end = searchPage * divCount3;
				params.put("PAGESTART", start);
				params.put("PAGEEND", end);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodMonitorService.selectProdMonitorPage3List(params));
			extGrid.setTotcnt(prodMonitorService.selectProdMonitorPage3Count(params));
		}

		System.out.println("selectProdMonitorPage3Grid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}

	/**
	 * 3페이지 // 목록을 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/monitor/ProdMonitorPage3ListAgg.do")
	@ResponseBody
	public Object selectProdMonitorPage3ListAggGrid(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectProdMonitorPage3ListAggGrid Start. >>>>>>>>>>");
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
			
			Integer searchPage = NumberUtil.getInteger(params.get("SEARCHPAGE"));
			if (searchPage.equals("")) {
				count++;
			}
			
			params.put("LISTCOUNT", divCount3);
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setData(null);
			extGrid.setTotcnt(0);
		} else {
			extGrid.setData(prodMonitorService.selectProdMonitorPage3ListAggList(params));
			extGrid.setTotcnt(prodMonitorService.selectProdMonitorPage3ListAggCount(params));
		}

		System.out.println("selectProdMonitorPage3ListAggGrid End. >>>>>>>>>> " + extGrid.getData());
		return extGrid;
	}

}