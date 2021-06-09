package kr.co.bps.scs.pda;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.StringUtil;

/**
 * @ClassName : PdaController.java
 * @Description : Pda Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2021. 02.
 * @version 1.0
 * @see PDA 화면
 * 
 */

@Controller
public class PdaController extends BaseController {

	@Autowired
	private PdaService pdaService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * PDA Main
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/pda/PDAMain.do")
	public String showPDAMainPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "PDA Main");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {

			// 로그인 사용자의 ORG Company 정보
			System.out.println("showPDAMainPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showPDAMainPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showPDAMainPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			switch (groupid) {
			case "ROLE_PDA":
				// PDA권한일 경우

				break;
			default:
				// 그 외 권한

				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/pda/PdaMain";
	}

	/**
	 * 외주공정 입고등록 ( PDA )
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/pda/PdaOutTransBarcode.do")
	public String showPdaOutTransBarcodePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "외주 입고등록");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {

			// 로그인 사용자의 ORG Company 정보
			System.out.println("showPdaOutTransBarcodePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showPdaOutTransBarcodePage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showPdaOutTransBarcodePage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			switch (groupid) {
			case "ROLE_PDA":
				// PDA권한일 경우

				break;
			default:
				// 그 외 권한

				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/pda/PdaOutTransBarcode";
	}

	/**
	 * PDA 외주공정 입고등록에 사용할 LOT를 확인한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/pda/searchOutTransBarcodeCheck.do")
	@ResponseBody
	public Object searchOutTransBarcodeCheck(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchOutTransBarcodeCheck Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String lotno = StringUtil.nullConvert(params.get("LOTNO"));
			if ( lotno.isEmpty() ) {
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
			extGrid.setTotcnt(pdaService.searchOutTransBarcodeChecktotCnt(params));
			extGrid.setData(pdaService.searchOutTransBarcodeCheckList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchOutTransBarcodeCheck End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 외주입고등록 바코드 정보
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/pda/PdaOutTransRegist.do")
	public String showPdaOutTransRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "외주 입고등록 바코드");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {

			// 로그인 사용자의 ORG Company 정보
			System.out.println("showPdaOutTransBarcodePage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showPdaOutTransBarcodePage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showPdaOutTransBarcodePage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);
			
			String no = StringUtil.nullConvert(requestMap.get("NO"));
			if ( !no.isEmpty() ) {
				model.put("LOTNO", no);
			}
			
			switch (groupid) {
			case "ROLE_PDA":
				// PDA권한일 경우

				break;
			default:
				// 그 외 권한

				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/pda/PdaOutTransRegist";
	}

	/**
	 * PDA 외주공정 입고등록에 사용할 LOT를 확인한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/pda/PdaOutTransDetailList.do")
	@ResponseBody
	public Object selectPdaOutTransDetailList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectPdaOutTransDetailList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String lotno = StringUtil.nullConvert(params.get("TRADENO"));
			if ( lotno.isEmpty() ) {
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
			extGrid.setTotcnt(pdaService.selectPdaOutTransDetailListCount(params));
			extGrid.setData(pdaService.selectPdaOutTransDetailList(params));
		}

		System.out.println("selectPdaOutTransDetailList End. >>>>>>>>>>");
		return extGrid;
	}


	/**
	 * 외주입고관리 등록 // Grid 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/pda/pda/PdaOutTransDetailList.do", method = { RequestMethod.GET, RequestMethod.POST }, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView insertPdaOutTransDetailList(@RequestBody HashMap<String, Object> params, ModelMap model) throws Exception {

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("insertPdaOutTransDetailList Start. >>>>>>>>>> " + params);

		mav.addObject("result", pdaService.insertPdaOutTransDetailList(params)); //insertProdOuttransManageGrid(params));
		return mav;
	}
}