package kr.co.bps.scs.master.checkclass;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.file.ExcelFileService;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : CheckclassController.java
 * @Description : Checkclass Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author sjmun
 * @since 2016. 01
 * @version 1.0
 * @see 기준정보
 * 
 */

@Controller
public class CheckclassController extends BaseController {

	@Autowired
	private CheckclassService checkclassService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	@Autowired
	private ExcelFileService excelFileService;

	/**
	 * Checkclass // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/checkclass/Checkclass.do")
	public String showCheckclassGridViewPage(@ModelAttribute("searchVO") HashMap<String, Object> searchVO, HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> params)
			throws Exception {
		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "검사항목 분류");
		model.addAttribute("searchVO", searchVO);

		params.putAll(super.getGridParam4paging(params));
		System.out.println("params >>>>>>>>> " + params);

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 로그인 사용자의 org company 정보 
			
			System.out.println("showCmmclassGridViewPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showCmmclassGridViewPage params. >>>>>>>>>>" + params);
			params.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(params);
			System.out.println("showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
			params.put("groupId", groupid);
			
			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				// 더미 사용
				String orgid = StringUtil.nullConvert(userData.get("ORGID"));
				String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
				System.out.println("showCmmclassGridViewPage orgid. >>>>>>>>>>" + orgid);
				System.out.println("showCmmclassGridViewPage companyid. >>>>>>>>>>" + companyid);

				
				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
						// org
						params.put("ORGID", "");
						//params.put("ORGID", orgid );
					}else {
						System.out.println("2 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
						// org
						params.put("ORGID", "");
						params.put("ORGID",999 ); //임의의값
					}
				}else {
					System.out.println("3 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
					// org
					params.put("ORGID", "");
					params.put("ORGID", orgid );
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));

				if  (companyid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("4 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
						// company
						params.put("COMPANYID", "");
						//params.put("ORGID", orgid );
						//params.put("COMPANYID", companyid );
					}else {
						System.out.println("5 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
						// company
						params.put("COMPANYID", "");
						params.put("ORGID", 999 );//임의의값
						params.put("COMPANYID", 999 );//임의의값
					}
				}else {
					System.out.println("6 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
					// company
					params.put("COMPANYID", "");
					params.put("ORGID", orgid );
					params.put("COMPANYID", companyid );
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));
			
				model.addAttribute("labelBox", labelBox);
				
				// 예외 처리
			String firstbigcd = StringUtil.nullConvert(checkclassService.selectFirstbigcd(params));
			
			if ( !firstbigcd.isEmpty() ) {
				model.addAttribute("BigcdVal", firstbigcd);
			}

			String firstmiddlecd = StringUtil.nullConvert(checkclassService.selectFirstmiddlecd(params));
			
			if ( !firstmiddlecd.isEmpty() ) {
				model.addAttribute("MiddlecdVal", firstmiddlecd);
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		return "/master/checkclass/Checkclass";
	}

	/**
	 * Bigclass // 대분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/checkclass/Checkbigclass.do")
	@ResponseBody
	public Object selectCheckbigclassList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectCheckbigclassList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(checkclassService.selectCheckbigclassListCount(params));
		extGrid.setData(checkclassService.selectCheckbigclassList(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("selectCheckbigclassList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공통코드 대분류 LOV // 진행중인 목록과 총 갯수를 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/checkclass/searchlov.do")
	@ResponseBody
	public Object selectCheckclassLovList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectCheckclassLovList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(checkclassService.selectCheckclassLovListCount(params));
		extGrid.setData(checkclassService.selectCheckclassLovList(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("selectCmmclassLovList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * Middleclass // 중분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/checkclass/Checkmiddleclass.do")
	@ResponseBody
	public Object selectCheckmiddleclassList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		params.putAll(super.getGridParam4paging(params));
		System.out.println("params >>>>>>>>> " + params);
		try {
			String bigcd = StringUtil.nullConvert(params.get("bigcd"));
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			int count = 0;

			if (!bigcd.isEmpty()) {
				System.out.println("bigcd >>>>>>>>> " + bigcd);
			} else {
//				// 대분류 코드 가져오는 부분
//				String firstbigcd = checkclassService.selectFirstbigcd(params);
//				params.put("bigcd", firstbigcd);
//				params.put("orgid", itemcodeMap.get("ORGID"));
//				params.put("companyid", itemcodeMap.get("COMPANYID"));

				List<?> itemcodeList = dao.list("checkclass.first.select", params);
				System.out.println("itemcodeList >>>>>>>>>> " + itemcodeList);
	//
				HashMap<String, Object> itemcodeMap = (HashMap<String, Object>) itemcodeList.get(0);
				System.out.println("itemcodeMap >>>>>>>>>> " + itemcodeMap);
				if ( itemcodeMap.size() > 0 ) {
					params.put("bigcd", itemcodeMap.get("BIGCD"));
					params.put("orgid", itemcodeMap.get("ORGID"));
					params.put("companyid", itemcodeMap.get("COMPANYID"));
				} else {
					count++;
				}					
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(checkclassService.selectCheckmiddleclassListCount(params));
		extGrid.setData(checkclassService.selectCheckmiddleclassList(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("selectCheckmiddleclassList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * Smallclass // 소분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/checkclass/Checksmallclass.do")
	@ResponseBody
	public Object selectChecksmallclassList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectChecksmallclassList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		try {
			String bigcd = StringUtil.nullConvert(params.get("bigcd"));
			if (!bigcd.isEmpty()) {
				System.out.println("bigcd >>>>>>>>> " + bigcd);
			} else {
				// 대분류 코드 가져오는 부분
				String firstbigcd = checkclassService.selectFirstbigcd(params);
				params.put("bigcd", firstbigcd);
			}
			String middlecd = StringUtil.nullConvert(params.get("middlecd"));
			if (!middlecd.isEmpty()) {
				System.out.println("middlecd >>>>>>>>> " + middlecd);
			} else {
				// 대,중분류 코드 가져오는 부분
				String firstbigcd = StringUtil.nullConvert(checkclassService.selectFirstbigcd(params));
				String firstmiddlecd = StringUtil.nullConvert(checkclassService.selectFirstmiddlecd(params));

				params.put("firstbigcd", firstbigcd);
				params.put("middlecd", firstmiddlecd);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(checkclassService.selectChecksmallclassListCount(params));
		extGrid.setData(checkclassService.selectChecksmallclassList(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("selectChecksmallclassList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * Bigclass // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/checkclass/Checkbigclass.do")
	@ResponseBody
	public Object insertCheckBigClass(@RequestParam HashMap<String, Object> params) throws Exception {

		return checkclassService.insertCheckBigclass(params);
	}

	/**
	 * Bigclass // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/checkclass/Checkbigclass.do")
	@ResponseBody
	public Object updateCheckBigclass(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetCheckBigclass >>>>>>>>>>");
		return checkclassService.updateCheckBigclass(params);
	}

	/**
	 * Bigclass // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/checkclass/Checkbigclass.do")
	@ResponseBody
	public Object deleteCheckBigclass(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCheckBigclass >>>>>>>>>>");
		return checkclassService.deleteCheckBigclass(params);
	}

	/**
	 * Middleclass // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/checkclass/Checkmiddleclass.do")
	@ResponseBody
	public Object insertChcekMiddleclass(@RequestParam HashMap<String, Object> params) throws Exception {

		return checkclassService.insertCheckMiddleclass(params);
	}

	/**
	 * Middleclass // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/checkclass/Checkmiddleclass.do")
	@ResponseBody
	public Object updatetCheckMiddleclass(@RequestParam HashMap<String, Object> params) throws Exception {

		return checkclassService.updateCheckMiddleclass(params);
	}

	/**
	 * Middleclass // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/checkclass/Checkmiddleclass.do")
	@ResponseBody
	public Object deleteCheckMiddleclass(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCheckMiddleclass >>>>>>>>>>");
		return checkclassService.deleteCheckMiddleclass(params);
	}

	/**
	 * Smallclass // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/checkclass/Checksmallclass.do")
	@ResponseBody
	public Object insertCheckSmallclass(@RequestParam HashMap<String, Object> params) throws Exception {

		return checkclassService.insertCheckSmallclass(params);
	}

	/**
	 * Smallclass // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/checkclass/Checksmallclass.do")
	@ResponseBody
	public Object updatetCheckSmallclass(@RequestParam HashMap<String, Object> params) throws Exception {

		return checkclassService.updateCheckSmallclass(params);
	}

	/**
	 * Smallclass // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/checkclass/Checksmallclass.do")
	@ResponseBody
	public Object deleteCheckSmallclass(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCheckSmallclass >>>>>>>>>>");
		return checkclassService.deleteCheckSmallclass(params);
	}
}