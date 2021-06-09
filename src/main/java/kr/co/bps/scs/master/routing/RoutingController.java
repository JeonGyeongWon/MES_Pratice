package kr.co.bps.scs.master.routing;

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
 * @ClassName : RoutingController.java
 * @Description : Routing Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 12.
 * @version 1.0
 * @see 기준정보 - 공정 관리
 * 
 */

@Controller
public class RoutingController extends BaseController {

	@Autowired
	private RoutingService routingService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	@Autowired
	private searchService searchService;

	/**
	 * 공정 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/routing/RoutingRegister.do")
	public String showRoutingRegisterPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		System.out.println("showRoutingRegisterPage Start. >>>>>>>>>>" + requestMap);
		LoginVO loVo = super.getLoginVO();
		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		requestMap.put("datefrom", datefrom);

		model.addAttribute("pageTitle", "ROUTING 등록");
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showRoutingRegisterPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showRoutingRegisterPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showRoutingRegisterPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showRoutingRegisterPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showRoutingRegisterPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showRoutingRegisterPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 showRoutingRegisterPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 showRoutingRegisterPage groupid. >>>>>>>>>>" + groupid);
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
			
			// 품목유형
			requestMap.put("ITEMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");
			params.put("GUBUN", "STATUS");
			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/master/routing/RoutingRegister";
	}

	/**
	 * ROUTING 등록 // 진행중인 목록과 총 갯수를 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/routing/RoutingRegister.do")
	@ResponseBody
	public Object selectRoutingRegisterList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectRoutingRegisterList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

     	int count = 0;
     	try {
     		String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
     		if ( itemcode.isEmpty() ) {
				System.out.println("selectRoutingDetail 1 params >>>>>>>>> " + params);

     			List<?> itemList = dao.list("checkmaster.first.select", params);
				System.out.println("itemList >>>>>>>>>> " + itemList.size());
				
				if ( itemList.size() > 0 ) {
					System.out.println("routingList size >>>>>>>>>> " + itemList.size() );
					HashMap<String, Object> itemMap = (HashMap<String, Object>) itemList.get(0);
					System.out.println("routingMap >>>>>>>>>> " + itemMap);
					if (itemMap.size() > 0) {
						params.put("orgid", itemMap.get("ORGID"));
						params.put("companyid", itemMap.get("COMPANYID"));
						params.put("ITEMCODE", itemMap.get("ITEMCODE"));
					} else {
						count++;
					}
				} else {
					count++;
				}
     		}
     	} catch ( Exception e ) {
     		e.printStackTrace();
     	}

     	ExtGridVO extGrid = new ExtGridVO();

     	if ( count > 0 ) {
         	extGrid.setTotcnt( 0 );
     		extGrid.setData( null );
     	} else {
         	extGrid.setTotcnt(routingService.RoutingRegisterTotCnt(params));
     		extGrid.setData(routingService.RoutingRegisterList(params));
//         	System.out.println("Data : "+ extGrid.getData());
     	}
		System.out.println("selectRoutingRegisterList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * ROUTING 등록 // 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/routing/RoutingRegister.do")
	@ResponseBody
	public Object insertRoutingRegister(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertRoutingRegister >>>>>>>>>> " + params);

		return routingService.insertRoutingRegister(params);
	}

	/**
	 * ROUTING 등록 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/routing/RoutingRegister.do")
	@ResponseBody
	public Object updateRoutingRegister(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateRoutingRegister >>>>>>>>>> "+ params );

		return routingService.updateRoutingRegister(params);
	}

	/**
	 * ROUTING 등록 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/routing/RoutingRegister.do")
	@ResponseBody
	public Object deleteRoutingRegister(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteRoutingRegister >>>>>>>>>> " + params);
		
		return routingService.deleteRoutingRegister(params);
	}

	/** 2016.12.10
	 * 공정별 설비 //  조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/routing/RoutingDetail.do")
	@ResponseBody
	public Object selectRoutingDetail(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		params.putAll(super.getGridParam4paging(params));
		System.out.println("selectRoutingDetail params >>>>>>>>> " + params);
		int count = 0;
		
		try {
			String orgid = StringUtil.nullConvert(params.get("orgid"));
			if ( orgid.isEmpty() ) {
				System.out.println("selectRoutingDetail 1 >>>>>>>>> " + orgid);
				count++;		
			}
			String companyid = StringUtil.nullConvert(params.get("companyid"));
			if ( companyid.isEmpty() ) {
				System.out.println("selectRoutingDetail 2 >>>>>>>>> " + companyid);
				count++;
			}
			String routingid = StringUtil.nullConvert(params.get("routingid"));
			if ( routingid.isEmpty() ) {
				System.out.println("selectRoutingDetail 3 routingid >>>>>>>>> " + routingid);
				System.out.println("selectRoutingDetail 3 params >>>>>>>>> " + params);

				
				List<?> itemList = dao.list("checkmaster.first.select", params);
				System.out.println("itemList >>>>>>>>>> " + itemList.size());
				
				if ( itemList.size() > 0 ) {
					System.out.println("itemList size >>>>>>>>>> " + itemList.size() );
					HashMap<String, Object> itemMap = (HashMap<String, Object>) itemList.get(0);
					System.out.println("itemMap >>>>>>>>>> " + itemMap);
					if (itemMap.size() > 0) {
						params.put("ITEMCODE", itemMap.get("ITEMCODE"));
					}
					
					List<?> routingList = dao.list("master.routing.first.select", params);
					System.out.println("routingList >>>>>>>>>> " + routingList.size());
					
					if ( routingList.size() > 0 ) {
						System.out.println("routingList size >>>>>>>>>> " + routingList.size() );
						HashMap<String, Object> routingMap = (HashMap<String, Object>) routingList.get(0);
						System.out.println("routingMap >>>>>>>>>> " + routingMap);
						if (routingMap.size() > 0) {
							params.put("orgid", routingMap.get("ORGID"));
							params.put("companyid", routingMap.get("COMPANYID"));
							params.put("itemcode", routingMap.get("ITEMCODE"));
							params.put("routingid", routingMap.get("ROUTINGID"));
							params.put("routingno", routingMap.get("ROUTINGNO"));
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

		System.out.println("selectRoutingDetail count. >>>>>>>>>>" + count);
		// detail 부분의 조회를 최초에는 실행x, master 클릭시 조회.
		if ( count > 0 ) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(routingService.selectRoutingDetailCount(params));
			extGrid.setData(routingService.selectRoutingDetailList(params));
//			System.out.println("Data : " + extGrid.getData());			
		}

		System.out.println("selectRoutingDetail End. >>>>>>>>>>");
		return extGrid;
	}

	/** 2016.12.10
	 * 공정별 설비 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/routing/RoutingDetail.do")
	@ResponseBody
	public Object updateRoutingDetail(@RequestParam HashMap<String, Object> params) throws Exception {
		
		System.out.println("updateRoutingDetail Start. >>>>>>>>>> " + params);
		System.out.println("updateRoutingDetail Data. >>>>>>>>>> " + params.get("data"));
		
		Object result = null;
		try {
			result = routingService.updateRoutingDetail(params);

		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 공구 LIST 정보 // 진행중인 목록과 총 갯수를 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/routing/ToolCheckList.do")
	@ResponseBody
	public Object selectToolCheckList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectToolCheckList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

     	int count = 0;
     	try {
//     		String routingid = StringUtil.nullConvert(params.get("routingid"));
//			if ( routingid.isEmpty() ) {
//				System.out.println("selectToolCheckList 1 >>>>>>>>> " + routingid);
//
//     			List<?> routingList = dao.list("master.routing.first.select", params);
//				System.out.println("routingList >>>>>>>>>> " + routingList.size());
//				
//				if ( routingList.size() > 0 ) {
//					HashMap<String, Object> routingMap = (HashMap<String, Object>) routingList.get(0);
//					System.out.println("routingMap >>>>>>>>>> " + routingMap.size());
//					if (routingMap.size() > 0) {
//						params.put("orgid", routingMap.get("ORGID"));
//						params.put("companyid", routingMap.get("COMPANYID"));
//						params.put("itemcode", routingMap.get("ITEMCODE"));
//						params.put("routingid", routingMap.get("ROUTINGID"));
//						params.put("routingno", routingMap.get("ROUTINGNO"));
//					} else {
//						count++;
//					}
//				} else {
//					count++;
//				}
//			}

			String routingid = StringUtil.nullConvert(params.get("routingid"));
			if ( routingid.isEmpty() ) {
				System.out.println("selectToolCheckList 3 routingid >>>>>>>>> " + routingid);
				System.out.println("selectToolCheckList 3 params >>>>>>>>> " + params);

				List<?> itemList = dao.list("checkmaster.first.select", params);
				System.out.println("itemList >>>>>>>>>> " + itemList.size());
				
				if ( itemList.size() > 0 ) {
					System.out.println("itemList size >>>>>>>>>> " + itemList.size() );
					HashMap<String, Object> itemMap = (HashMap<String, Object>) itemList.get(0);
					System.out.println("itemMap >>>>>>>>>> " + itemMap);
					if (itemMap.size() > 0) {
						params.put("ITEMCODE", itemMap.get("ITEMCODE"));
					}
					
					List<?> routingList = dao.list("master.routing.first.select", params);
					System.out.println("routingList >>>>>>>>>> " + routingList.size());
					
					if ( routingList.size() > 0 ) {
						System.out.println("routingList size >>>>>>>>>> " + routingList.size() );
						HashMap<String, Object> routingMap = (HashMap<String, Object>) routingList.get(0);
						System.out.println("routingMap >>>>>>>>>> " + routingMap);
						if (routingMap.size() > 0) {
							params.put("orgid", routingMap.get("ORGID"));
							params.put("companyid", routingMap.get("COMPANYID"));
							params.put("itemcode", routingMap.get("ITEMCODE"));
							params.put("routingid", routingMap.get("ROUTINGID"));
							params.put("routingno", routingMap.get("ROUTINGNO"));
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
//	     	if ( count == 0 ) {
//	     		String equipmentcode = StringUtil.nullConvert(params.get("equipmentcode"));
//	     		if ( equipmentcode.isEmpty() ) {
//					System.out.println("selectToolCheckList 2 >>>>>>>>> " + equipmentcode);
//	
//	     			List<?> routingDetailList = dao.list("master.routing.detail.first.select", params);
//					System.out.println("routingDetailList >>>>>>>>>> " + routingDetailList.size());
//					
//					if ( routingDetailList.size() > 0 ) {
//						HashMap<String, Object> routingDetailMap = (HashMap<String, Object>) routingDetailList.get(0);
//						System.out.println("routingDetailMap >>>>>>>>>> " + routingDetailMap.size());
//						if (routingDetailMap.size() > 0) {
//							params.put("orgid", routingDetailMap.get("ORGID"));
//							params.put("companyid", routingDetailMap.get("COMPANYID"));
//							params.put("itemcode", routingDetailMap.get("ITEMCODE"));
//							params.put("routingid", routingDetailMap.get("ROUTINGID"));
//							params.put("equipmentcode", routingDetailMap.get("EQUIPMENTCODE"));
//	
//				     		String equipmentcode1 = StringUtil.nullConvert(params.get("equipmentcode"));
//				     		if ( equipmentcode1.isEmpty() ) {
//				     			count++;
//				     		}
//						} else {
//							count++;
//						}
//					} else {
//						count++;
//					}
//	     		}
//	     	}
     	} catch ( Exception e ) {
     		e.printStackTrace();
     	}

     	ExtGridVO extGrid = new ExtGridVO();

     	if ( count > 0 ) {
         	extGrid.setTotcnt( 0 );
     		extGrid.setData( null );
     	} else {
         	extGrid.setTotcnt(routingService.ToolCheckTotCnt(params));
     		extGrid.setData(routingService.ToolCheckList(params));
         	System.out.println("Data : "+ extGrid.getData());
     	}
		System.out.println("selectToolCheckList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공구 LIST 정보 // 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/routing/ToolCheckList.do")
	@ResponseBody
	public Object insertToolCheckList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertToolCheckList >>>>>>>>>> " + params);

		return routingService.insertToolCheckList(params);
	}

	/**
	 * 공구 LIST 정보 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/routing/ToolCheckList.do")
	@ResponseBody
	public Object updateToolCheckList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateToolCheckList >>>>>>>>>> "+ params );

		return routingService.updateToolCheckList(params);
	}

	/**
	 * 라우팅복사 pakage 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/pkg/routing/RoutingCopyRegister.do")
	@ResponseBody
	public Object pkgRoutingCopyRegister(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("pkgRoutingRegister >>>>>>>>>> "+ params );

		return routingService.pkgRoutingItemCopy(params);
	}
	

	/**
	 * 기준단가 // 진행중인 목록과 총 갯수를 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/routing/SalesPriceRouting.do")
	@ResponseBody
	public Object selectSalesPriceRouting(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectSalesPriceRouting Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

     	int count = 0;
     	try {
     		
     	} catch ( Exception e ) {
     		e.printStackTrace();
     	}

     	ExtGridVO extGrid = new ExtGridVO();

     	if ( count > 0 ) {
         	extGrid.setTotcnt( 0 );
     		extGrid.setData( null );
     	} else {
         	extGrid.setTotcnt(routingService.selectSalesPriceRoutingCount(params));
     		extGrid.setData(routingService.selectSalesPriceRoutingList(params));
//         	System.out.println("Data : "+ extGrid.getData());
     	}
		System.out.println("selectSalesPriceRouting End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 기준단가 등록 // 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/routing/SalesPriceRouting.do")
	@ResponseBody
	public Object insertSalesPriceRouting(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertSalesPriceRouting >>>>>>>>>> " + params);

		return routingService.insertSalesPriceRouting(params);
	}

	/**
	 * 기준단가 등록 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/routing/SalesPriceRouting.do")
	@ResponseBody
	public Object updateSalesPriceRouting(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateSalesPriceRouting >>>>>>>>>> "+ params );

		return routingService.updateSalesPriceRouting(params);
	}

	/**
	 * 기준단가 등록 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/routing/SalesPriceRouting.do")
	@ResponseBody
	public Object deleteSalesPriceRouting(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteSalesPriceRouting >>>>>>>>>> " + params);
		
		return routingService.deleteSalesPriceRouting(params);
	}

}