package kr.co.bps.scs.master.human;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : HumanController.java
 * @Description : Human Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author shseo
 * @modify ymha
 * @since 2016. 02. / 2021. 01. 
 * @version 1.0
 * @see 기준정보
 * 
 */

@Controller
public class HumanController extends BaseController {

	@Autowired
	private HumanService humanService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	@Autowired
	private searchService searchService;

	@Autowired
	private ExcelFileService excelFileService;

	/**
	 * 사원 관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/human/HumanResource.do")
	public String showHumanResourcePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		egovframework.com.cmm.LoginVO loVo = (egovframework.com.cmm.LoginVO) session.getAttribute("LoginVO");
		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");

		requestMap.put("searchLoginId", loVo.getId());
		requestMap.put("datefrom", datefrom);

		model.addAttribute("pageTitle", "사원 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 

			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());

			String result_org = "1";
			String result_comp = "1";

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/master/human/HumanResourceList";
	}

	/**
	 * 사원 관리 // 진행중인 목록과 총 갯수를 조회한다.
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/human/HumanResourceList.do")
	@ResponseBody
	public Object selectHumanResourceList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectHumanResourceList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(humanService.selectHumanCount(params));
		extGrid.setData(humanService.selectHumanList(params));
//		System.out.println("Data : " + extGrid.getData());

		System.out.println("selectHumanResourceList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 사원 관리 // 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/human/HumanResourceList.do")
	@ResponseBody
	public Object insertHumanResourceList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertHumanResourceList >>>>>>>>>>");

		return humanService.insertHumanResourceList(params);
	}

	/**
	 * 사원 관리 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/human/HumanResourceList.do")
	@ResponseBody
	public Object updateHumanResourceList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateHumanResourceList >>>>>>>>>>" + params);

		return humanService.updateHumanResourceList(params);
	}

	/**
	 * 사원 관리 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/human/HumanResourceList.do")
	@ResponseBody
	public Object deleteHumanResourceList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteHumanResourceList >>>>>>>>>>");
		return humanService.deleteHumanResourceList(params);
	}

	/**
	 * 2016.12.07 사원별 권한 // 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/human/HumanResourceDetail.do")
	@ResponseBody
	public Object selectHumanRousourceDetail(@RequestParam HashMap<String, Object> params) throws Exception {

		params.putAll(super.getGridParam4paging(params));
		System.out.println("selectHumanRousourceDetail params >>>>>>>>> " + params);
		int count = 0;

		try {
			String EmpNo = StringUtil.nullConvert(params.get("EMPLOYEENUMBER"));
			if (!EmpNo.isEmpty()) {
				System.out.println("selectHumanRousourceDetail 1 >>>>>>>>> " + params);
			} else {
				System.out.println("selectHumanRousourceDetail 2 >>>>>>>>> " + params);
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		// detail 부분의 조회를 최초에는 실행x, master 클릭시 조회.
		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(humanService.selectHumanDetailCount(params));
			extGrid.setData(humanService.selectHumanDetailList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectHumanRousourceDetail End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.07 HumanRousourcedetail // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/human/HumanResourceDetail.do")
	@ResponseBody
	public Object updateHumanResourceDetail(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateHumanResourceDetail >>>>>params :  " + params);
		Object result = null;
		try {
			System.out.println("updateHumanResourceDetail 1-1 >>>>>>>>> " + params);
			result = humanService.updateHumanResourceDetail(params);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2016.12.28 사원별 설비 // 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/human/HumanResourceEquip.do")
	@ResponseBody
	public Object selectHumanRousourceEquip(@RequestParam HashMap<String, Object> params) throws Exception {

		params.putAll(super.getGridParam4paging(params));
		System.out.println("selectHumanRousourceEquip params >>>>>>>>> " + params);
		int count = 0;

		try {
			String EmpNo = StringUtil.nullConvert(params.get("EMPLOYEENUMBER"));
			if (!EmpNo.isEmpty()) {
				System.out.println("selectHumanRousourceEquip 1 >>>>>>>>> " + params);
			} else {
				System.out.println("selectHumanRousourceEquip 2 >>>>>>>>> " + params);
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		// detail 부분의 조회를 최초에는 실행x, master 클릭시 조회.
		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(humanService.selectHumanEquipCount(params));
			extGrid.setData(humanService.selectHumanEquipList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectHumanRousourceEquip End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.28 HumanRousourceEquip // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/human/HumanResourceEquip.do")
	@ResponseBody
	public Object updateHumanResourceEquip(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateHumanResourceEquip START >>>>> " + params.get("data"));
		Object result = null;
		try {
			result = humanService.updateHumanResourceEquip(params);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
}