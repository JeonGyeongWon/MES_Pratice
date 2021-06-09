package kr.co.bps.scs.master.bom;

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
 * @ClassName : BomController.java
 * @Description : Bom Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 12.
 * @version 1.0
 * @see BOM 등록
 * 
 */
@Controller
public class BomController extends BaseController {

	@Autowired
	private BomService bomService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	@Autowired
	private searchService searchService;
	
	/**
	 * BOM 등록 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/bom/BomRegister.do")
	public String showBomGridViewPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		System.out.println("showBomGridViewPage Start. >>>>>>>>>>" + requestMap);
		LoginVO loVo = super.getLoginVO();
		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		requestMap.put("datefrom", datefrom);

		model.addAttribute("pageTitle", "BOM 등록");
		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("showBomGridViewPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showBomGridViewPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showBomGridViewPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showBomGridViewPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showBomGridViewPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showBomGridViewPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 showBomGridViewPage groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 showBomGridViewPage groupid. >>>>>>>>>>" + groupid);
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

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/master/bom/BomRegister";
	}

	/**
	 * BOM 등록 // 진행중인 목록과 총 갯수를 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/bom/BomRegister.do")
	@ResponseBody
	public Object selectBomRegisterList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectBomRegisterList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

     	int count = 0;
     	try {
     		String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
     		if ( itemcode.isEmpty() ) {
				System.out.println("selectBomRegisterList 1 params >>>>>>>>> " + params);

     			List<?> itemList = dao.list("checkmaster.first.select", params);
				System.out.println("itemList >>>>>>>>>> " + itemList.size());
				
				if ( itemList.size() > 0 ) {
					System.out.println("selectBomRegisterList size >>>>>>>>>> " + itemList.size() );
					HashMap<String, Object> itemMap = (HashMap<String, Object>) itemList.get(0);
					System.out.println("selectBomRegisterList >>>>>>>>>> " + itemMap);
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
     	} catch ( Exception e ) {
     		e.printStackTrace();
     	}

     	ExtGridVO extGrid = new ExtGridVO();

     	if ( count > 0 ) {
         	extGrid.setTotcnt( 0 );
     		extGrid.setData( null );
     	} else {
         	extGrid.setTotcnt(bomService.BomRegisterTotCnt(params));
     		extGrid.setData(bomService.BomRegisterList(params));
//         	System.out.println("Data : "+ extGrid.getData());
     	}
		System.out.println("selectBomRegisterList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * BOM 등록 // 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/bom/BomRegister.do")
	@ResponseBody
	public Object insertBomRegister(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertBomRegister >>>>>>>>>> " + params);

		return bomService.insertBomRegister(params);
	}

	/**
	 * BOM 등록 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/bom/BomRegister.do")
	@ResponseBody
	public Object updateBomRegister(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateBomRegister >>>>>>>>>> "+ params );

		return bomService.updateBomRegister(params);
	}

	/**
	 * BOM 등록 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/bom/BomRegister.do")
	@ResponseBody
	public Object deleteBomRegister(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteBomRegister >>>>>>>>>> " + params);
		
		return bomService.deleteBomRegister(params);
	}
}