package kr.co.bps.scs.order.ship;

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
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : ShipOrderController.java
 * @Description : ShipOrder Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jmpark, ymha, jshwang
 * @since 2017. 06
 * @version 1.0
 * 
 */
@Controller
public class ShipOrderController extends BaseController {

	@Autowired
	private ShipOrderService shipOrderService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;
	
	/**
	 * 출하계획관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ShipPlanRegist.do")
	public String showShipPlanRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "출하계획 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showShipPlanRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			
			// 로그인 사용자의 org company 정보 
			System.out.println("showShipPlanRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showShipPlanRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showShipPlanRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showShipPlanRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showShipPlanRegistPage companyid. >>>>>>>>>>" + companyid);

				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 showShipPlanRegistPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					}else {
						System.out.println("2 showShipPlanRegistPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID",999 ); //임의의값
					}
				}else {
					System.out.println("3 showShipPlanRegistPage groupid. >>>>>>>>>>" + groupid);
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

		return "/order/ship/ShipPlanRegist";
	}
	
	/**
	 * 출하계획관리 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipPlanRegist.do")
	@ResponseBody
	public Object selectShipPlanListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipPlanListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(shipOrderService.selectShipPlanCount(params));
			extGrid.setData(shipOrderService.selectShipPlanList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipPlanListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/** 
	 * 출하계획관리  // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/ship/ShipPlanRegist.do")
	@ResponseBody
	public Object insertShipPlanRegist(@RequestParam HashMap<String, Object> params) throws Exception {

		return shipOrderService.insertShipPlanRegist(params);
	}

	/** 
	 * 출하계획관리 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/ship/ShipPlanRegist.do")
	@ResponseBody
	public Object updatetShipPlanRegist(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetShipPlanRegist Start. >>>>>>>>>> " + params);
		Object result = null;
		try {
    		result = shipOrderService.updateShipPlanRegist(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return result;
	}

	/** 
	 * 출하계획관리 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/ship/ShipPlanRegist.do")
	@ResponseBody
	public Object deleteShipPlanRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteShipPlanRegist >>>>>>>>>> " + params);
		return shipOrderService.deleteShipPlanRegist(params);
	}

	/**
	 * 출하지시관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ShipOrderRegist.do")
	public String showShipOrderRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "출하지시 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showShipOrderRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			HashMap<String, Object> params = new HashMap<String, Object>();
			
			// 로그인 사용자의 org company 정보 
			System.out.println("showShipOrderRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showShipOrderRegistPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showShipOrderRegistPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showShipOrderRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showShipOrderRegistPage companyid. >>>>>>>>>>" + companyid);

				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 showShipOrderRegistPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					}else {
						System.out.println("2 showShipOrderRegistPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID",999 ); //임의의값
					}
				}else {
					System.out.println("3 showShipOrderRegistPage groupid. >>>>>>>>>>" + groupid);
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

		return "/order/ship/ShipOrderRegist";
	}

	/**
	 * 출하지시관리 MASTER // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipOrderRegist.do")
	@ResponseBody
	public Object selectShipOrderRegistGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipOrderRegistGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(shipOrderService.selectShipOrderCount(params));
			extGrid.setData(shipOrderService.selectShipOrderList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipOrderRegistGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 출하지시관리 Detail // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipOrderDetail.do")
	@ResponseBody
	public Object selectShipOrderDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipOrderRegistGrid Start. >>>>>>>>>> " + params);
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
			
			String shipno = StringUtil.nullConvert(params.get("SHIPNO"));
			if (shipno.isEmpty()) {
				System.out.println("selectShipOrderRegistGrid 3 >>>>>>>>> " + params);

				List<?> shipList = dao.list("ship.order.list.first.select", params);
				System.out.println("shipList >>>>>>>>>> " + shipList);
				
				if ( shipList.size() > 0 ) {
					System.out.println("shipList size >>>>>>>>>> " +  shipList.size() );
					HashMap<String, Object> shipMap = (HashMap<String, Object>) shipList.get(0);
					System.out.println("shipMap >>>>>>>>>> " + shipMap);
					if (shipMap.size() > 0) {
						params.put("ORGID", shipMap.get("ORGID"));
						params.put("COMPANYID", shipMap.get("COMPANYID"));
						params.put("SHIPNO", shipMap.get("SHIPNO"));
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
			extGrid.setTotcnt(shipOrderService.selectShipOrderDetailCount(params));
			extGrid.setData(shipOrderService.selectShipOrderDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipOrderRegistGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 출하지시관리 // 이월 데이터  PKG 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/ship/ShipOrderPkgStart.do")
	@ResponseBody
	public Object insertWorkProdStart(@RequestParam HashMap<String, Object> params) throws Exception {
		Object result = null;
		result = shipOrderService.insertShipOrderPkgStart(params);
		result = params;
		return result;
	}

	/** 
	 * 출하지시관리  // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/ship/ShipOrderRegist.do")
	@ResponseBody
	public Object insertShipOrderRegist(@RequestParam HashMap<String, Object> params) throws Exception {

		return shipOrderService.insertShipOrderDetailRegist(params);
	}

	/** 
	 * 출하지시관리 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/ship/ShipOrderRegist.do")
	@ResponseBody
	public Object updatetShipOrderRegist(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetShipOrderRegist Start. >>>>>>>>>> " + params);
		Object result = null;
		try {
    		result = shipOrderService.updateShipOrderDetailRegist(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return result;
	}

	/** 2016.12.30 
	 * 출하지시관리 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/ship/ShipOrderRegist.do")
	@ResponseBody
	public Object deleteShipOrderRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteShipOrderRegist >>>>>>>>>> " + params);
		return shipOrderService.deleteShipOrderDetailRegist(params);
	}
	
	/**2016.12.30 
	 * 출하지시관리  // 투입확정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/appr/order/ship/ShipOrderRegist.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Object apprShipOrderRegist(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("apprShipOrderRegist Start. >>>>>>>>>> " + params);
		
		Object result = null;
		try {
    		result = shipOrderService.apprShipOrderRegist(params);
    		System.out.println("apprShipOrderRegist result >>>>>>>>> " + result);
    		
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return result;
	}
		
	/**
	 * 2016.12.14 입하관리 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/MatReceiveRegist.do")
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

		return "/order/ship/MatReceiveRegist";
	}

	/**
	 * 2016.12.14 입하관리현황 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/MatReceiveRegist.do")
	@ResponseBody
	public Object selectMatReceiveRegistGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectMatReceiveRegistGrid Start. >>>>>>>>>> ");
		System.out.println("selectMatReceiveRegistGrid params >>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String pofrom = StringUtil.nullConvert(params.get("TRANSFROM"));
			if (pofrom.isEmpty()) {
				count++;
			}

			String poto = StringUtil.nullConvert(params.get("TRANSTO"));
			if (poto.isEmpty()) {
				count++;
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
			extGrid.setTotcnt(shipOrderService.selectDistMatMatReceiveRegistCount(params));
			extGrid.setData(shipOrderService.selectDistMatMatReceiveRegistList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMatReceiveRegistGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2016.12.14 입하관리 현황 내역 조회 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/MatReceiveRegistDetail.do")
	@ResponseBody
	public Object selectDistMatMatReceiveRegistDetail(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectDistMatMatReceiveRegistDetail Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String transno = StringUtil.nullConvert(params.get("transno"));
			String orgid = StringUtil.nullConvert(params.get("orgid"));
			String companyid = StringUtil.nullConvert(params.get("companyid"));
			if (!transno.isEmpty()) {
				System.out.println("transno >>>>>>>>> " + transno);
				System.out.println("orgid >>>>>>>>> " + orgid);
				System.out.println("companyid >>>>>>>>> " + companyid);
			} else {
				// 아이템 코드 가져오는 부분
				List<?> itemcodeList = dao.list("order.ship.detail.first.select", params);
				System.out.println("itemcodeList >>>>>>>>>> " + itemcodeList);
				//
				HashMap<String, Object> itemcodeMap = (HashMap<String, Object>) itemcodeList.get(0);
				System.out.println("itemcodeMap >>>>>>>>>> " + itemcodeMap);
				if (itemcodeMap.size() > 0) {
					params.put("TRANSNO", itemcodeMap.get("TRANSNO"));
					params.put("ORGID", itemcodeMap.get("ORGID"));
					params.put("COMPANYID", itemcodeMap.get("COMPANYID"));
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
			extGrid.setTotcnt(shipOrderService.selectDistMatMatReceiveRegistDetailCount(params));
			extGrid.setData(shipOrderService.selectDistMatMatReceiveRegistDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectDistMatMatReceiveRegistDetail End. >>>>>>>>>> ");
		return extGrid;
	}
	//  여기까지 입하등록 조회화면

	//  여기부터 입하등록 등록 수정화면
	/**
	 * 2016.12.14 입하등록 화면 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ReceiveRegistD.do")
	public String showDistMatMatReceiveRegistD(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "입하상세정보");

		System.out.println("showDistMatMatReceiveRegistD Start >>>>>>>>>>" + requestMap);
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
					System.out.println("6 showPurchaseRequestListPage org. >>>>>>>>>>" + org);
					System.out.println("6 showPurchaseRequestListPage company. >>>>>>>>>>" + company);
					requestMap.put("TRANSNO", no); // 수정
					requestMap.put("ORGID", org);
					requestMap.put("COMPANYID", company);
					labelBox.put("findByOrgId", searchService.OrgLovList(params));
					labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
				}

				model.addAttribute("labelBox", labelBox);

				//				// 로그인 사용자명
				//				requestMap.put("uniqId", loVo.getId());
				//				//String groupid = searchService.selectGroupid(requestMap);
				//				requestMap.put("groupId", groupid);
				//
				//				params.put("ROLEUSER", loVo.getId());
				//				List<?> userList2 = dao.list("search.login.name.lov.select", params);
				//				Map<String, Object> userData2 = (Map<String, Object>) userList2.get(0);
				//				String employeenumber = StringUtil.nullConvert(userData.get("VALUE"));
				//				String krname = StringUtil.nullConvert(userData.get("LABEL"));
				//				String deptcode = StringUtil.nullConvert(userData.get("DEPTCODE"));
				//				String deptname = StringUtil.nullConvert(userData.get("DEPTNAME"));
				//
				//				requestMap.put("employeenumber", employeenumber);
				//				requestMap.put("krname", krname);
				//				requestMap.put("deptcode", deptcode);
				//				requestMap.put("deptname", deptname);
				//				//				model.addAttribute("EMPLOYEENUMBER", !employeenumber.isEmpty() ? employeenumber : "");
				//				//				model.addAttribute("KRNAME", !krname.isEmpty() ? krname : "");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/ship/MatReceiveRegistD";
	}

	/**
	 * 2016.12.16 입하관리 등록수정화면 // Grid 상세 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ReceiveRegistD.do")
	@ResponseBody
	public Object selectDistMatReceiveRegistDGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectDistMatReceiveManagerDGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String TransNo = StringUtil.nullConvert(params.get("TRANSNO"));
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
			extGrid.setTotcnt(shipOrderService.selectDistMatReceiveRegistDCount(params));
			extGrid.setData(shipOrderService.selectDistMatReceiveRegistDList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectDistMatReceiveRegistDGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 2016.12.14 입하관리 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/ship/MatReceiveRegistD.do")
	@ResponseBody
	public Object insertDistMatReceiveRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertDistMatReceiveRegistD Params. >>>>>>>>>> " + params);

		return shipOrderService.insertDistMatMatReceiveRegistD(params);
	}

	/**
	 * 2016.12.14 입하관리 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/ship/MatReceiveRegistDGrid.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertDistMatReceiveRegistDGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertDistMatReceiveRegistDGrid Start. >>>>>>>>>> " + params);

		mav.addObject("result", shipOrderService.insertDistMatMatReceiveRegistDGrid(params));
		return mav;
	}

	/**
	 * 2016.12.14 입하관리 // 마스터 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/ship/MatReceiveRegistD.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateMatReceiveRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateMatReceiveRegistD Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = shipOrderService.updateMatReceiveRegistD(params);
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
	@RequestMapping(value = "/update/order/ship/MatReceiveRegistDGrid.do", method = RequestMethod.POST)
	public ModelAndView updateMatReceiveRegistDGrid(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateMatReceiveRegistDGrid Start. >>>>>>>>>> " + params);
		mav.addObject("result", shipOrderService.updateMatReceiveRegistDGrid(params));
		return mav;
	}

	/**
	 * 2016.12.16 입하관리 등록 수정화면 // Grid 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/ship/ReceiveRegistD.do")
	@ResponseBody
	public Object deleteDistMatReceiveRegistD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteDistMatReceiveRegistD Start. >>>>>>>>>> " + params);

		return shipOrderService.deleteReceiveRegistD(params);
	}

	/**
	 * 2016.12.19 입하상세정보 마스터데이터 삭제 // 마스터
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/ship/ReceiveRegistDM.do")
	@ResponseBody
	public Object deleteDistMatReceiveRegistDM(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteDistMatReceiveRegistDM Params. >>>>>>>>>> " + params);

		return shipOrderService.deleteReceiveRegistDM(params);
	}
	//여기까지 입하등록 등록 수정 화면


	/**
	 * SHIPNO / 출하계획번호 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/searchShipNoListLov.do")
	@ResponseBody
	public Object searchShipNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchShipNoListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(shipOrderService.ShipNoLovTotCnt(params));
			extGrid.setData(shipOrderService.ShipNoLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchShipNoListLov End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 출하계획관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ShipStatusRegist.do")
	public String showShipStatusRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());
		
		model.addAttribute("pageTitle", "출하현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showShipStatusRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("predateSys", dummy.get("PREDATESYS"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
				requestMap.put("predateFrom", dummy.get("PREDATEFROM"));
				requestMap.put("predateTo", dummy.get("PREDATETO"));
				requestMap.put("postdateFrom", dummy.get("POSTDATEFROM"));
				requestMap.put("postdateTo", dummy.get("POSTDATETO"));
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

		return "/order/ship/ShipStatusRegist";
	}
	
	/**
	 * 출하계획관리 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipStatusRegist.do")
	@ResponseBody
	public Object selectShipStatusListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipStatusListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(shipOrderService.selectShipStatusCount(params));
			extGrid.setData(shipOrderService.selectShipStatusList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipStatusListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	

	/**
	 * 출하검사등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ShipInspectionRegist.do")
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

		return "/order/ship/ShipInspectionRegist";
	}


	/**
	 * 출하검사등록 마스터 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipInspectionMaster.do")
	@ResponseBody
	public Object selectShipInspectionMasterGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipInspectionMasterGrid Start. >>>>>>>>>> " + params);
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

				String shipno = StringUtil.nullConvert(params.get("SHIPNO"));
				if (shipno.isEmpty()) {
					count++;
				}

				String shipseq = StringUtil.nullConvert(params.get("SHIPSEQ"));
				if (shipseq.isEmpty()) {
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

		System.out.println("selectShipInspectionMasterGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	

	/**
	 * 출하검사등록 상세 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipInspectionDetail.do")
	@ResponseBody
	public Object selectShipInspectionDetailGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipInspectionDetailGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(shipOrderService.selectShipInspectionDetailCount(params));
			extGrid.setData(shipOrderService.selectShipInspectionDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipInspectionDetailGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	

	/**
	 * 출하검사등록 마스터 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/ship/ShipInspectionMaster.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Object updateShipInspectionMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateShipInspectionMasterList Start. >>>>>>>>>> " + params);
		
		Object result = null;
		List<?> Presult = null;
		try {
    		result = shipOrderService.updateShipInspectionMasterList(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * 출하검사등록 상세 // Grid 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/ship/ShipInspectionDetail.do", method = RequestMethod.POST)
	public ModelAndView updateShipInspectionDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateShipInspectionDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", shipOrderService.updateShipInspectionDetailList(params));
		System.out.println("updateShipInspectionDetailList End. >>>>>>>>>> " + mav);
		return mav;
	}


	/**
	 * 출하등록 관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ShipRegistManageList.do")
	public String showShipRegistManageListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "출하등록 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
			
			try {
				Map<String, ?> fm = RequestContextUtils.getInputFlashMap(super.request);
				if (fm != null && !fm.isEmpty()) {
					model.addAllAttributes(fm);
				}
				
				// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
				List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
				Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
				System.out.println("showShipRegistManageListPage Dummy. >>>>>>>>>>" + dummy);

				if (dummy.size() > 0) {
					// 더미 사용
					requestMap.put("dateFrom", dummy.get("DATEFROM"));
					requestMap.put("dateTo", dummy.get("DATETO"));
				}

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showShipRegistManageListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showShipRegistManageListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showShipRegistManageListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showShipRegistManageListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showShipRegistManageListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showShipRegistManageListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 showShipRegistManageListPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 showShipRegistManageListPage groupid. >>>>>>>>>>" + groupid);
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

			// 매출구분
			requestMap.put("SHIPGUBUN", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "OM");
			params.put("MIDDLECD", "SHIP_GUBUN");
			//params.put("GUBUN", "STATUS");
			
			labelBox.put("findByShipGubun", searchService.SmallCodeLovList(params));
			
			// 발주상태
			requestMap.put("STATUSCODE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "MAT");
			params.put("MIDDLECD", "STATUS_CODE");
			labelBox.put("findByStatusCodeGubun", searchService.SmallCodeLovList(params));
						
			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/ship/ShipRegistManageList";
	}
	

	/**
	 * 출하등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ShipRegistManageRegist.do")
	public String showShipRegistManageRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "출하등록");
		System.out.println("showShipRegistManageRegistPage Start >>>>>>>>>>" + requestMap);
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();
			// 1. 현재 날짜 데이터 가져오기
			List dummyList = dao.selectListByIbatis("ship.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showShipRegistManageRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("datefrom", dummy.get("DATEFROM"));
				requestMap.put("dateto", dummy.get("DATETO"));
				requestMap.put("TODAY", dummy.get("DATESYS"));
			}


			String shipno = StringUtil.nullConvert(requestMap.get("SHIPNO"));
			if (!shipno.isEmpty()) {
				// 출하번호가 있을 경우 상세
				model.addAttribute("pageTitle", "출하 상세 / 수정");

				String org = StringUtil.nullConvert(requestMap.get("org"));
				String company = StringUtil.nullConvert(requestMap.get("company"));
				System.out.println("1 showOutWarehousingRegistPage org. >>>>>>>>>>" + org);
				System.out.println("2 showOutWarehousingRegistPage company. >>>>>>>>>>" + company);
				requestMap.put("SHIPNO", shipno);
				requestMap.put("ORGID", org);
				requestMap.put("COMPANYID", company);
				labelBox.put("findByOrgId", searchService.OrgLovList(requestMap));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(requestMap));
				
				// 상태
				requestMap.put("SHIPGUBUN", "");
				params.put("ORGID", org );
				params.put("COMPANYID", company );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SHIP_GUBUN");
				//params.put("GUBUN", "STATUS");

				labelBox.put("findByShipGubun", searchService.SmallCodeLovList(params));

				// 용차구분
				requestMap.put("DELIVERYVAN", "");
				params.put("ORGID", org );
				params.put("COMPANYID", company );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "DELIVERY_VAN");
				//params.put("GUBUN", "DELIVERY_VAN");

				labelBox.put("findByDeliveryVan", searchService.SmallCodeLovList(params));

				// 세액구분
				requestMap.put("TAXDIV", "");
				params.put("ORGID", org);
				params.put("COMPANYID", company);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "TAX_DIV");

				labelBox.put("findByTaxDivGubun", searchService.SmallCodeLovList(params));

//				// 인도장소
//				requestMap.put("WORKAREA", "");
//				params.put("ORGID", org);
//				params.put("COMPANYID", company);
//				params.put("BIGCD", "CMM");
//				params.put("MIDDLECD", "DELIVERY_PLACE");
//
//				labelBox.put("findByDeliveryPlaceGubun", searchService.SmallCodeLovList(params));
								
				model.addAttribute("labelBox", labelBox);
			} else {
				// 입고번호가 없을 경우 등록
				model.addAttribute("pageTitle", "출하등록");

				// 로그인 사용자의 org company 정보
				System.out.println("showShipRegistManageRegistPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
				params.put("USERID", loVo.getId());
				System.out.println("showShipRegistManageRegistPage params. >>>>>>>>>>" + params);
				requestMap.put("uniqId", loVo.getId());
				String groupid = searchService.selectGroupid(requestMap);
				System.out.println("showShipRegistManageRegistPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("groupId", groupid);

				List<?> userList = dao.list("search.login.lov.select", params);
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showShipRegistManageRegistPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showShipRegistManageRegistPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showShipRegistManageRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
					} else {
						System.out.println("2 showShipRegistManageRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("ORGID", "");
						params.put("ORGID", 999);
					}
				} else {
					System.out.println("3 showShipRegistManageRegistPage groupid. >>>>>>>>>>" + groupid);
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
						System.out.println("4 showShipRegistManageRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
					} else {
						System.out.println("5 showShipRegistManageRegistPage groupid. >>>>>>>>>>" + groupid);
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999);
						params.put("COMPANYID", 999);
					}
				} else {
					System.out.println("6 showShipRegistManageRegistPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid);
					params.put("COMPANYID", companyid);
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				// 매출구분
				requestMap.put("SHIPGUBUN", "01");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "SHIP_GUBUN");
				//params.put("GUBUN", "STATUS");
				
				labelBox.put("findByShipGubun", searchService.SmallCodeLovList(params));

				// 용차구분
				requestMap.put("DELIVERYVAN", "01");
				params.put("ORGID", result_org );
				params.put("COMPANYID", result_comp );
				params.put("BIGCD", "OM");
				params.put("MIDDLECD", "DELIVERY_VAN");
				//params.put("GUBUN", "DELIVERY_VAN");

				labelBox.put("findByDeliveryVan", searchService.SmallCodeLovList(params));

				// 세액구분
				requestMap.put("TAXDIV", "");
				params.put("ORGID", result_org);
				params.put("COMPANYID", result_comp);
				params.put("BIGCD", "CMM");
				params.put("MIDDLECD", "TAX_DIV");

				labelBox.put("findByTaxDivGubun", searchService.SmallCodeLovList(params));

				// 인도장소
//				requestMap.put("WORKAREA", "");
//				params.put("ORGID", result_org);
//				params.put("COMPANYID", result_comp);
//				params.put("BIGCD", "CMM");
//				params.put("MIDDLECD", "DELIVERY_PLACE");
//
//				labelBox.put("findByDeliveryPlaceGubun", searchService.SmallCodeLovList(params));
								
				model.addAttribute("labelBox", labelBox);

				System.out.println("showShipRegistManageRegistPage requestMap >>>>>>>>>>" + requestMap);
				if (!groupid.equals("ROLE_ADMIN")) {
					// 로그인 사용자명
					requestMap.put("uniqId", loVo.getId());
					requestMap.put("groupId", groupid);

					params.put("ROLEUSER", loVo.getId());
					List<?> userList2 = dao.list("search.login.name.lov.select", params);
					Map<String, Object> userData2 = (Map<String, Object>) userList2.get(0);
					String employeenumber = StringUtil.nullConvert(userData2.get("VALUE"));
					String krname = StringUtil.nullConvert(userData2.get("LABEL"));

					requestMap.put("employeenumber", employeenumber);
					requestMap.put("krname", krname);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/ship/ShipRegistManageRegist";
	}
	

	/**
	 * 출하등록관리 // Grid Master 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipRegistManageMasterList.do")
	@ResponseBody
	public Object selectShipRegistManageMasterListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipRegistManageMasterListGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

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
			extGrid.setTotcnt(shipOrderService.selectShipRegistManageMasterCount(params));
			extGrid.setData(shipOrderService.selectShipRegistManageMasterList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipRegistManageMasterListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 출하등록관리 // Grid Detail 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipRegistManageDetailList.do")
	@ResponseBody
	public Object selectShipRegistManageDetailListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipRegistManageDetailListGrid params >>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;

		try {
			String shipno = StringUtil.nullConvert(params.get("SHIPNO"));
			if (shipno.isEmpty()) {
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
			extGrid.setTotcnt(shipOrderService.selectShipRegistManageDetailCount(params));
			extGrid.setData(shipOrderService.selectShipRegistManageDetailList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipRegistManageDetailListGrid End. >>>>>>>>>> ");
		return extGrid;
	}
	
	/**
	 * 출하등록 // 마스터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/ship/ShipRegistManageMasterList.do")
	@ResponseBody
	public Object insertShipRegistManageMasterList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertShipRegistManageMasterList Params. >>>>>>>>>> " + params);

		return shipOrderService.insertShipRegistManageMasterList(params);
	}

	/**
	 * 출하등록 // 디테일 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/order/ship/ShipRegistManageDetailList.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertShipRegistManageDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("insertShipRegistManageDetailList Params. >>>>>>>>>> " + params);

		mav.addObject("result", shipOrderService.insertShipRegistManageDetailList(params));
		System.out.println("insertShipRegistManageDetailList End. >>>>>>>>>> " + mav);
		return mav;
	}

	/**
	 * 출하등록 // 마스터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/ship/ShipRegistManageMasterList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateShipRegistManageMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateShipRegistManageMasterList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = shipOrderService.updateShipRegistManageMasterList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}	
	
	/**
	 * 출하등록 // 디테일 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/order/ship/ShipRegistManageDetailList.do", method = RequestMethod.POST)
	public ModelAndView updateShipRegistManageDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");

		System.out.println("updateShipRegistManageDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", shipOrderService.updateShipRegistManageDetailList(params));
		return mav;
	}
	
	/**
	 * 출하등록 // 마스터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/order/ship/ShipRegistManageMasterList.do")
	@ResponseBody
	public Object deleteShipRegistManageMasterList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteShipRegistManageMasterList Start. >>>>>>>>>> "+ params);

		return shipOrderService.deleteShipRegistManageMasterList(params);
	}

	/**
	 * 출하등록 // 디테일 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */

	@RequestMapping(value = "/delete/order/ship/ShipRegistManageDetailList.do")
	@ResponseBody
	public Object deleteShipRegistManageDetailList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("deleteShipRegistManageDetailList Params. >>>>>>>>>> " + params);
		
		return shipOrderService.deleteShipRegistManageDetailList(params);
	}
	
	
	/**
	 * 월별 출하현황  // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/ship/ShipModelList.do")
	public String showShipModelListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "월별 출하현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("material.release.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showShipModelListPage Dummy. >>>>>>>>>>" + dummy);

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

			System.out.println("7. showShipModelListPage params >>>>>>>>>>>> " + params);
			System.out.println("8. showShipModelListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/order/ship/ShipModelList";
	}

	/**
	 * 월별 출하현황 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/order/ship/ShipModelList.do")
	@ResponseBody
	public Object selectShipModelListGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectShipModelListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(shipOrderService.selectShipModelCount(params));
			extGrid.setData(shipOrderService.selectShipModelList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectShipModelListGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 단가적용 // 프로시저 호출
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/pkg/order/ship/UnitPriceManage.do")
	@ResponseBody
	public Object callUnitPriceManage(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("callUnitPriceManage Params. >>>>>>>>>> " + params);

		return shipOrderService.callUnitPriceManage(params);
	}

	
}