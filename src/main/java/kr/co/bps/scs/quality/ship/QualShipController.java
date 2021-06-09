package kr.co.bps.scs.quality.ship;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.order.ship.ShipOrderService;
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
 * @ClassName : QualityController.java
 * @Description : Quality Controller class
 * @Modification Information
 *
 * Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 10. 
 * @version 1.0
 * @see
 *  품질관리 - 출하검사
 *
 */

@Controller
public class QualShipController extends BaseController {

	@Autowired
	private ShipOrderService shipOrderService;
	
	@Autowired
	private QualShipService QualShipService;

	@Autowired
	private searchService searchService;
	
	@Resource(name = "egovAuthorGroupService")
    private EgovAuthorGroupService egovAuthorGroupService;

	
	/**
	 * 출하검사등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/quality/ship/ShipInspectionList.do")
	public String showShipInspectionListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "출하검사");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showShipInspectionListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			
			// 로그인 사용자의 org company 정보 
			System.out.println("showShipInspectionListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showShipInspectionListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showShipInspectionListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showShipInspectionListPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showShipInspectionListPage companyid. >>>>>>>>>>" + companyid);

				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 showShipInspectionListPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					}else {
						System.out.println("2 showShipInspectionListPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID",999 ); //임의의값
					}
				}else {
					System.out.println("3 showShipInspectionListPage groupid. >>>>>>>>>>" + groupid);
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
				
				// 상태
				requestMap.put("SHIPGUBUN", "");
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SHIP_GUBUN");
				//params.put("GUBUN", "STATUS");

				labelBox.put("findByShipGubun", searchService.SmallCodeLovList(params));

				model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/quality/ship/ShipInspectionList";
	}

	
	/**
	 * 출하검사등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/quality/ship/ShipInspectionRegist.do")
	public String showShipInspectionRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "출하검사등록");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showShipInspectionRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("TODAY", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			
			// 로그인 사용자의 org company 정보 
			System.out.println("showShipInspectionRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showShipInspectionRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showShipInspectionRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showShipInspectionRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showShipInspectionRegistPage companyid. >>>>>>>>>>" + companyid);

				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 showShipInspectionRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					}else {
						System.out.println("2 showShipInspectionRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID",999 ); //임의의값
					}
				}else {
					System.out.println("3 showShipInspectionRegistPage groupid. >>>>>>>>>>" + groupid);
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
						params.put("ORGID", 999 );//임의의값
						params.put("COMPANYID", 999 );//임의의값
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
				
				
				System.out.println("7. showShipInspectionRegistPage params >>>>>>>>>>>> " + params);
				System.out.println("8. showShipInspectionRegistPage requestMap >>>>>>>>>>>> " + requestMap);

				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );

				String shipno = StringUtil.nullConvert(requestMap.get("shipno"));
				params.put("SHIPNO", shipno );
				
				Integer shipseq = NumberUtil.getInteger(requestMap.get("shipseq"));
				params.put("SHIPSEQ", shipseq );	
				
				String itemcode = StringUtil.nullConvert(requestMap.get("itemcode"));
				params.put("ITEMCODE", itemcode );
				System.out.println("9. showShipInspectionRegistPage params >>>>>>>>>>>> " + params);

				params.put("REGISTID", loVo.getId());
				
				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");
				System.out.println("출하검사등록 생성 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("ship.inspection.create.call.procedure", params);
				System.out.println("출하검사등록 생성 PROCEDURE 호출 End.  >>>>>>>> " + params);

				String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
				System.out.println("showShipInspectionRegistPage status >>>>>>>> " + status);
				
				model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/quality/ship/ShipInspectionRegist";
	}

	/**
	 * 출하검사현황 // 화면 조회
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/quality/ship/ShipmentInspList.do")
	public String showShipmentInspListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("showShipmentInspListPage .getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "출하검사현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showShipmentInspListPage Dummy. >>>>>>>>>>" + dummy);

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
					// org
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

			// 판정구분
			requestMap.put("CHECKYN", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "QM");
			params.put("MIDDLECD", "CHECK_YN");
			params.put("GUBUN", "CHECKYN");

			labelBox.put("findByCheckYn", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/quality/ship/ShipmentInspList";
	}

	/**
	 * 출하검사등록 마스터 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/quality/ship/ShipmentInspMaster.do")
	@ResponseBody
	public Object selectShipmentInspMasterGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipmentInspMasterGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if ( gubun.isEmpty() ) {
				String orgid = StringUtil.nullConvert(params.get("ORGID"));
				if (orgid.isEmpty()) {
					count++;
				}

				String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
				if (companyid.isEmpty()) {
					count++;
				}

				String inspno = StringUtil.nullConvert(params.get("SHIPINSNO"));
				if (inspno.isEmpty()) {
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
			extGrid.setTotcnt(shipOrderService.selectShipInspectionMasterCount(params));
			extGrid.setData(shipOrderService.selectShipInspectionMasterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipmentInspMasterGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	

	/**
	 * 출하검사등록 상세 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/quality/ship/ShipmentInspDetail.do")
	@ResponseBody
	public Object selectShipmentInspDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipmentInspDetailGrid Start. >>>>>>>>>> " + params);
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

			String shipinsno = StringUtil.nullConvert(params.get("SHIPINSNO"));
			if (shipinsno.isEmpty()) {
				String gubun = StringUtil.nullConvert(params.get("GUBUN"));
				if ( !gubun.isEmpty() ) {
					List<?> firstList = dao.list("ship.inspection.master.first.select", params);
					System.out.println("firstList >>>>>>>>>> " + firstList);
					
					if ( firstList.size() > 0 ) {
						HashMap<String, Object> firstMap = (HashMap<String, Object>) firstList.get(0);
						System.out.println("firstMap >>>>>>>>>> " + firstMap);
						
						if (firstMap.size() > 0) {
							params.put("ORGID", firstMap.get("ORGID"));
							params.put("COMPANYID", firstMap.get("COMPANYID"));
							params.put("SHIPINSNO", firstMap.get("SHIPINSNO"));
						} else {
							count++;
						}
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
			extGrid.setTotcnt(shipOrderService.selectShipInspectionDetailCount(params));
			extGrid.setData(shipOrderService.selectShipInspectionDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipmentInspDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 출하검사 등록 / 상세 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/quality/ship/ShipmentInspManage.do")
	public String showShipmentInspManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		System.out.println("showShipmentInspManagePage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);

			String inspno = StringUtil.nullConvert(requestMap.get("no"));
			System.out.println("0 showShipmentInspManagePage inspno. >>>>>>>>>>" + inspno);

			if (!inspno.isEmpty()) {
				// 번호가 있을 경우 상세 조회
				model.addAttribute("pageTitle", "출하검사 상세 / 수정");
				model.addAttribute("gubun", "MODIFY");

				// 번호 받았을 경우
				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 inspno org. >>>>>>>>>>" + org);
				System.out.println("2 inspno company. >>>>>>>>>>" + company);
				requestMap.put("SHIPINSNO", inspno); // 수정
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));

				model.addAttribute("labelBox", labelBox);

			} else {
				// 번호가 없을 경우 등록
				model.addAttribute("pageTitle", "출하검사 등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showShipmentInspManagePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showShipmentInspManagePage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showShipmentInspManagePage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 요청번호 없을 경우 
				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showShipmentInspManagePage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showShipmentInspManagePage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showShipmentInspManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showShipmentInspManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
					}
				} else {
					System.out.println("3 showShipmentInspManagePage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showShipmentInspManagePage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showShipmentInspManagePage groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
					}
				} else {
					System.out.println("6 showShipmentInspManagePage groupid. >>>>>>>>>>" + groupid);
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

				System.out.println("9 showShipmentInspManagePage groupid. >>>>>>>>>>" + groupid);
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

				System.out.println("0 showShipmentInspManagePage inspno. >>>>>>>>>>" + inspno);

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/quality/ship/ShipmentInspManage";
	}

	/**
	 * 출하검사등록 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/quality/ship/ShipmentInspMaster.do")
	@ResponseBody
	public Object insertShipmentInspMasterList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertShipmentInspMasterList Params. >>>>>>>>>> " + params);

		return QualShipService.insertShipmentInspMasterList(params);
	}

	/**
	 * 출하검사등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/quality/ship/ShipmentInspDetail.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertShipmentInspDetailGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertShipmentInspDetailGrid Start. >>>>>>>>>> " + params);

		mav.addObject("result", QualShipService.insertShipmentInspDetailGrid(params));
		return mav;
	}

	/**
	 * 출하검사등록 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/quality/ship/ShipmentInspMaster.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateShipmentInspMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateShipmentInspMasterList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = QualShipService.updateShipmentInspMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 출하검사등록 삭제 // 마스터 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/quality/ship/ShipmentInspMaster.do")
	@ResponseBody
	public Object deleteShipmentInspMaster(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteShipmentInspMaster Params. >>>>>>>>>> " + params);

		return QualShipService.deleteShipmentInspMaster(params);
	}

	/**
	 * 출하검사등록 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/quality/ship/ShipmentInspDetail.do", method = RequestMethod.POST)
	public ModelAndView updateShipmentInspDetailGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateShipmentInspDetailGrid Start. >>>>>>>>>> " + params);

		mav.addObject("result", QualShipService.updateShipmentInspDetailGrid(params));
		return mav;
	}

	/**
	 * 출하검사등록 상세 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/quality/ship/ShipmentInspDetail.do")
	@ResponseBody
	public Object deleteShipmentInspDetailList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteShipmentInspDetailList Start. >>>>>>>>>> " + params);

		return QualShipService.deleteShipmentInspDetailList(params);
	}

	/**
	 * 출하대기LIST POPUP // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/quality/ship/ShipmentInspPopup.do")
	@ResponseBody
	public Object selectShipmentInspPopupGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipmentInspPopupGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String popupgubun = StringUtil.nullConvert(params.get("POPGUBUN"));
			if ( popupgubun.isEmpty() ) {
				
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
			extGrid.setTotcnt(QualShipService.selectShipmentInspPopupCount(params));
			extGrid.setData(QualShipService.selectShipmentInspPopupList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipmentInspMasterGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	

}