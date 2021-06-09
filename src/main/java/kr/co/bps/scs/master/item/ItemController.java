package kr.co.bps.scs.master.item;

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
 * @ClassName : ItemControllerController.java
 * @Description : Item Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 07.
 * @modify 2017. 05.
 * @version 1.0
 * @see 품목 관리 - 제품 / 자재 / 공구
 * 
 */
@Controller
public class ItemController extends BaseController {

	@Autowired
	private ItemService itemService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 품목관리 (제품) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/item/ItemProductList.do")
	public String showItemProductGridViewPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "품목관리 (제품)");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);
			requestMap.put("datefrom", today);

			// 그룹코드 설정
			String group = "A"; // A : Product, M : Material
			requestMap.put("GROUPCODE", group);

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());

			// 로그인 사용자의 org company 정보 
			System.out.println("showHumanResourcePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showHumanResourcePage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showHumanResourcePage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			System.out.println("showHumanResourcePage userList. >>>>>>>>>>" + userList.size());
			if (userList.size() > 1) {

				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			} else {

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showHumanResourcePage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showHumanResourcePage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showHumanResourcePage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					} else {
						System.out.println("2 showHumanResourcePage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); //임의의값
					}
				} else {
					System.out.println("3 showHumanResourcePage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", orgid);
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));

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
			}

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showItemProductGridViewPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/master/item/ItemProductList";
	}

	/**
	 * 품목관리 (제품) // 대분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/item/Bigclass.do")
	@ResponseBody
	public Object selectBigclassList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectBigclassList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(itemService.selectbigclassCount(params));
		extGrid.setData(itemService.selectbigclassList(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("selectBigclassList End. >>>>>>>>>>");
		return extGrid;
	}

	@RequestMapping(value = "/insert/item/Bigclass.do")
	@ResponseBody
	public Object insertBigclassList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertBigclassList Start >>>>>>>>>>");
		return itemService.insertbigclassList(params);
	}

	@RequestMapping(value = "/update/item/Bigclass.do")
	@ResponseBody
	public Object updatetBigclassList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetBigclassList >>>>>>>>>>");
		return itemService.updatebigclassList(params);
	}

	/**
	 * 품목관리 (제품) // 중분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/item/Middleclass.do")
	@ResponseBody
	public Object selectMiddleclassList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectMiddleclassList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String bigcode = StringUtil.nullConvert(params.get("bigcode"));
			if (!bigcode.isEmpty()) {
				System.out.println("selectMiddleclassList bigcode >>>>>>>>>> " + bigcode);
			} else {
				// 대분류 코드 가져오는 부분
				String firstbigcode = StringUtil.nullConvert(itemService.selectFirstBigcode(params));

				if (!firstbigcode.isEmpty()) {
					params.put("bigcode", firstbigcode);
				} else {
					count++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(itemService.selectmiddleclassCount(params));
			extGrid.setData(itemService.selectmiddleclassList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectMiddleclassList End. >>>>>>>>>>");
		return extGrid;
	}

	@RequestMapping(value = "/insert/item/Middleclass.do")
	@ResponseBody
	public Object insertMiddleclassList(@RequestParam HashMap<String, Object> params) throws Exception {

		return itemService.insertmiddleclassList(params);
	}

	@RequestMapping(value = "/update/item/Middleclass.do")
	@ResponseBody
	public Object updateMiddleclassList(@RequestParam HashMap<String, Object> params) throws Exception {

		return itemService.updatemiddleclassList(params);
	}

	/**
	 * 품목관리 (제품) // 소분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/item/Smallclass.do")
	@ResponseBody
	public Object selectSmallclassList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectSmallclassList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String bigcode = StringUtil.nullConvert(params.get("bigcode"));
			if (!bigcode.isEmpty()) {
				System.out.println("selectSmallclassList bigcode >>>>>>>>>> " + bigcode);
			} else {
				// 대분류 코드 가져오는 부분
				String firstbigcode = StringUtil.nullConvert(itemService.selectFirstBigcode(params));

				if (!firstbigcode.isEmpty()) {
					params.put("bigcode", firstbigcode);
				} else {
					count++;
				}
			}

			String middlecode = StringUtil.nullConvert(params.get("middlecode"));
			if (!middlecode.isEmpty()) {
				System.out.println("selectSmallclassList middlecode >>>>>>>>>> " + middlecode);
			} else {
				// 중분류 코드 가져오는 부분
				String firstmiddlecode = StringUtil.nullConvert(itemService.selectFirstMiddlecode(params));

				if (!firstmiddlecode.isEmpty()) {
					params.put("middlecode", firstmiddlecode);
				} else {
					count++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(itemService.selectsmallclassCount(params));
			extGrid.setData(itemService.selectsmallclassList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectSmallclassList End. >>>>>>>>>>");
		return extGrid;
	}

	@RequestMapping(value = "/insert/item/Smallclass.do")
	@ResponseBody
	public Object insertSmallclassList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertSmallclassList Start >>>>>>>>>>");
		return itemService.insertsmallclassList(params);
	}

	@RequestMapping(value = "/update/item/Smallclass.do")
	@ResponseBody
	public Object updatetSmallclassList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetSmallclassList >>>>>>>>>>");
		return itemService.updatesmallclassList(params);
	}

	/**
	 * 품목관리 (제품) // 제품 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/item/itemList.do")
	@ResponseBody
	public Object selectitemList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectitemList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String bigcode = StringUtil.nullConvert(params.get("bigcode"));
			String itemcode = StringUtil.nullConvert(params.get("itemcode"));
			if (!bigcode.isEmpty() | !itemcode.isEmpty()) {
				System.out.println("selectitemList bigcode >>>>>>>>>> " + bigcode);
			} else {
				// 대분류 코드 가져오는 부분
				String firstbigcode = StringUtil.nullConvert(itemService.selectFirstBigcode(params));

				if (!firstbigcode.isEmpty()) {
					params.put("bigcode", firstbigcode);
				} else {
					count++;
				}
			}

			String middlecode = StringUtil.nullConvert(params.get("middlecode"));
			if (!middlecode.isEmpty() | !itemcode.isEmpty()) {
				System.out.println("selectitemList middlecode >>>>>>>>>> " + middlecode);
			} else {
				// 중분류 코드 가져오는 부분
				String firstmiddlecode = StringUtil.nullConvert(itemService.selectFirstMiddlecode(params));

				if (!firstmiddlecode.isEmpty()) {
					params.put("middlecode", firstmiddlecode);
				} else {
					count++;
				}
			}

			String smallcode = StringUtil.nullConvert(params.get("smallcode"));
			if (!smallcode.isEmpty() | !itemcode.isEmpty()) {
				System.out.println("selectitemList smallcode >>>>>>>>>> " + smallcode);
			} else {
				// 소분류 코드 가져오는 부분
				String firstsmallcode = StringUtil.nullConvert(itemService.selectFirstSmallcode(params));

				if (!firstsmallcode.isEmpty()) {
					params.put("smallcode", firstsmallcode);
				} else {
					count++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			try {
				String groupcode = StringUtil.nullConvert(params.get("groupcode"));
				if (!groupcode.isEmpty()) {
					if (groupcode.equals("A")) {
						// 제품일 때 조회
						extGrid.setTotcnt(itemService.selectitemProductCount(params));
						extGrid.setData(itemService.selectitemProductList(params));
					} else if (groupcode.equals("M")) {
						// 자재일 때 조회
						extGrid.setTotcnt(itemService.selectitemMaterialCount(params));
						extGrid.setData(itemService.selectitemMaterialList(params));
					} else if (groupcode.equals("T")) {
						// 공구일 때 조회
						extGrid.setTotcnt(itemService.selectitemToolCount(params));
						extGrid.setData(itemService.selectitemToolList(params));
					}
					System.out.println("Data : " + extGrid.getData());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		System.out.println("selectitemList End. >>>>>>>>>>");
		return extGrid;
	}

	@RequestMapping(value = "/insert/item/itemList.do")
	@ResponseBody
	public Object insertitemList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertitemList Start >>>>>>>>>> " + params);

		return itemService.insertitemList(params);
	}

	@RequestMapping(value = "/update/item/itemList.do")
	@ResponseBody
	public Object updatetitemList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updatetitemList >>>>>>>>>>" +params);

		return itemService.updateitemList(params);
	}

	/**
	 * 품목관리 (자재) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/item/ItemMaterialList.do")
	public String showItemMaterialGridViewPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "품목관리 (자재)");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);
			requestMap.put("datefrom", today);

			// 그룹코드 설정
			String group = "M"; // A : Product, M : Material
			requestMap.put("GROUPCODE", group);

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());

			// 로그인 사용자의 org company 정보 
			System.out.println("showItemMaterialGridViewPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showItemMaterialGridViewPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showItemMaterialGridViewPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			System.out.println("showItemMaterialGridViewPage userList. >>>>>>>>>>" + userList.size());
			if (userList.size() > 1) {

				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			} else {

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showItemMaterialGridViewPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showItemMaterialGridViewPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showItemMaterialGridViewPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					} else {
						System.out.println("2 showItemMaterialGridViewPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); //임의의값
					}
				} else {
					System.out.println("3 showItemMaterialGridViewPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", orgid);
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));

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
			}

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showItemMaterialGridViewPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/master/item/ItemMaterialList";
	}

	/**
	 * 품목관리 (공구) // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/item/ItemToolList.do")
	public String showItemToolGridViewPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "품목관리 (공구)");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 날짜 Dummy
			String today = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("TODAY", today);
			requestMap.put("datefrom", today);

			// 그룹코드 설정
			String group = "T"; // A : Product, M : Material, T : Tool
			requestMap.put("GROUPCODE", group);

			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());

			// 로그인 사용자의 org company 정보 
			System.out.println("showItemToolGridViewPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showItemToolGridViewPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showItemToolGridViewPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			System.out.println("showItemToolGridViewPage userList. >>>>>>>>>>" + userList.size());
			if (userList.size() > 1) {

				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			} else {

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showItemToolGridViewPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showItemToolGridViewPage companyid. >>>>>>>>>>" + companyid);

				if (orgid == "") {
					if (groupid.equals("ROLE_ADMIN")) {
						System.out.println("1 showItemToolGridViewPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					} else {
						System.out.println("2 showItemToolGridViewPage groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID", 999); //임의의값
					}
				} else {
					System.out.println("3 showItemToolGridViewPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", orgid);
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));

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
			}

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

			System.out.println("7. showItemToolGridViewPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/master/item/ItemToolList";
	}

	/**
	 * 2016.12.06 품목관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/item/ItemMaster.do")
	//	public String showItemMasterGridViewPage(@ModelAttribute("searchVO") HashMap<String, Object> searchVO, HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
	public String showItemMasterGridViewPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		requestMap.put("datefrom", datefrom);

		model.addAttribute("pageTitle", "품목마스터 관리");

		//		requestMap.putAll(super.getGridParam4paging(requestMap));
		//		System.out.println("requestMap >>>>>>>>> " + requestMap);

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
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

			// 품목유형
			requestMap.put("ITEMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");
			params.put("GUBUN", "STATUS");

			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));

			// 기종
			requestMap.put("MODELTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "MODEL");
			params.put("GUBUN", "STATUS");

			labelBox.put("findByModelType", searchService.SmallCodeLovList(params));

			// 업체명
			requestMap.put("CUSTOMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "CUSTOMER_GUBUN");
			params.put("GUBUN", "STATUS");

			labelBox.put("findByCusType", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/master/item/ItemMaster";
	}

	/**
	 * 품목관리 // 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/item/ItemMaster.do")
	@ResponseBody
	public Object selectItemMaster(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectItemMaster Start. >>>>>>>>>>");
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
			try {
				extGrid.setTotcnt(itemService.selectItemMasterCount(params));
				extGrid.setData(itemService.selectItemMasterList(params));
				System.out.println("Data : " + extGrid.getData());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		System.out.println("selectItemMaster End. >>>>>>>>>>");
		return extGrid;
	}

	@RequestMapping(value = "/insert/item/ItemMaster.do")
	@ResponseBody
	public Object insertItemMaster(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertItemMaster Start >>>>>>>>>>");

		return itemService.insertItemMaster(params);
	}

	@RequestMapping(value = "/update/item/ItemMaster.do")
	@ResponseBody
	public Object updatetItemMaster(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updatetItemMaster >>>>>>>>>>");

		return itemService.updateItemMaster(params);
	}

	@RequestMapping(value = "/delete/item/ItemMaster.do")
	@ResponseBody
	public Object deletetItemMaster(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deletetItemMaster >>>>>>>>>>");

		return itemService.deleteItemMaster(params);
	}

	/**
	 * 품목관리 단가 // 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/item/ItemMasterPrice.do")
	@ResponseBody
	public Object selectItemMasterPrice(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectItemMasterPrice Start. >>>>>>>>>>" + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String bigcode = StringUtil.nullConvert(params.get("bigcode"));
			if (!bigcode.isEmpty()) {
				System.out.println("selectItemMasterPrice 1. >>>>>>>>>> " + bigcode);
			} else {
				// 대분류 코드 가져오는 부분
				String firstbigcode = StringUtil.nullConvert(itemService.selectFirstBigcode(params));

				if (!firstbigcode.isEmpty()) {
					params.put("bigcode", firstbigcode);
				} else {
					count++;
				}
			}
			bigcode = StringUtil.nullConvert(params.get("bigcode"));
			System.out.println("selectItemMasterPrice 1-1. >>>>>>>>>> " + bigcode);

			
			String middlecode = StringUtil.nullConvert(params.get("middlecode"));
			if (!middlecode.isEmpty()) {
				System.out.println("selectItemMasterPrice 2. >>>>>>>>>> " + middlecode);
			} else {
				// 중분류 코드 가져오는 부분
				String firstmiddlecode = StringUtil.nullConvert(itemService.selectFirstMiddlecode(params));

				if (!firstmiddlecode.isEmpty()) {
					params.put("middlecode", firstmiddlecode);
				} else {
					count++;
				}
			}
			middlecode = StringUtil.nullConvert(params.get("middlecode"));
			System.out.println("selectItemMasterPrice 2-1. >>>>>>>>>> " + middlecode);


			String smallcode = StringUtil.nullConvert(params.get("smallcode"));
			if (!smallcode.isEmpty()) {
				System.out.println("selectItemMasterPrice 3. >>>>>>>>>> " + smallcode);
			} else {
				// 소분류 코드 가져오는 부분
				String firstsmallcode = StringUtil.nullConvert(itemService.selectFirstSmallcode(params));

				if (!firstsmallcode.isEmpty()) {
					params.put("smallcode", firstsmallcode);
				} else {
					count++;
				}
			}
			smallcode = StringUtil.nullConvert(params.get("smallcode"));
			System.out.println("selectItemMasterPrice 3-1. >>>>>>>>>> " + smallcode);

			
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (!itemcode.isEmpty()) {
				System.out.println("selectItemMasterPrice 4. >>>>>>>>> " + itemcode);
			} else {

				List<?> itemList = dao.list("item.master.first.select", params);
				System.out.println("itemList >>>>>>>>>> " + itemList);

				if (itemList.size() > 0) {
					System.out.println("itemList size >>>>>>>>>> " + itemList.size());
					HashMap<String, Object> itemMap = (HashMap<String, Object>) itemList.get(0);
					System.out.println("itemMap >>>>>>>>>> " + itemMap);
					if (itemMap.size() > 0) {
						params.put("ORGID", itemMap.get("ORGID"));
						params.put("COMPANYID", itemMap.get("COMPANYID"));
						params.put("ITEMCODE", itemMap.get("ITEMCODE"));
					} else {
						count++;
					}
				} else {
					count++;
				}
			}
			itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			System.out.println("selectItemMasterPrice 4-1. >>>>>>>>>> " + itemcode);

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			try {
				extGrid.setTotcnt(itemService.selectItemMasterPriceCount(params));
				extGrid.setData(itemService.selectItemMasterPriceList(params));
//				System.out.println("Data : " + extGrid.getData());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		System.out.println("selectItemMasterPrice End. >>>>>>>>>>");
		return extGrid;
	}

	@RequestMapping(value = "/insert/item/ItemMasterPrice.do")
	@ResponseBody
	public Object insertItemMasterPrice(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertItemMasterPrice Start >>>>>>>>>>");

		return itemService.insertItemMasterPrice(params);
	}

	@RequestMapping(value = "/update/item/ItemMasterPrice.do")
	@ResponseBody
	public Object updatetItemMasterPrice(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updatetItemMasterPrice >>>>>>>>>>");

		return itemService.updateItemMasterPrice(params);
	}

	@RequestMapping(value = "/delete/item/ItemMasterPrice.do")
	@ResponseBody
	public Object deletetItemMasterPrice(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deletetItemMasterPrice >>>>>>>>>>");

		return itemService.deleteItemMasterPrice(params);
	}

	/**
	 * 2017.04.25 품목관리 판가 // 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/item/ItemMasterSales.do")
	@ResponseBody
	public Object selectItemMasterSales(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectItemMasterSales Start. >>>>>>>>>>");
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
			try {
				extGrid.setTotcnt(itemService.selectItemMasterSalesCount(params));
				extGrid.setData(itemService.selectItemMasterSalesList(params));
				System.out.println("Data : " + extGrid.getData());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		System.out.println("selectItemMasterSales End. >>>>>>>>>>");
		return extGrid;
	}

	@RequestMapping(value = "/insert/item/ItemMasterSales.do")
	@ResponseBody
	public Object insertItemMasterSales(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertItemMasterSales Start >>>>>>>>>>");

		return itemService.insertItemMasterSales(params);
	}

	@RequestMapping(value = "/update/item/ItemMasterSales.do")
	@ResponseBody
	public Object updatetItemMasterSales(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updatetItemMasterSales >>>>>>>>>>");

		return itemService.updateItemMasterSales(params);
	}

	@RequestMapping(value = "/delete/item/ItemMasterSales.do")
	@ResponseBody
	public Object deletetItemMasterSales(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deletetItemMasterSales >>>>>>>>>>");

		return itemService.deleteItemMasterSales(params);
	}
}