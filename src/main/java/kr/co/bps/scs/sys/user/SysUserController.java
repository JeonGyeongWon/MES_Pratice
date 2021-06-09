package kr.co.bps.scs.sys.user;

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

/**
 * @ClassName : SysUserController.java
 * @Description : SysUser Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 02.
 * @version 1.0
 * @see 내부시스템관리 > 사용자 조회 및 관리
 */
@Controller
public class SysUserController extends BaseController {

	@Autowired
	private SysUserService SysUserService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 사용자 조회 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/sys/user/NewUserList.do")
	public String showNewUserListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "사용자 조회");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			System.out.println("showNewUserListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/sys/user/NewUserList";
	}

	/**
	 * 사용자 목록 조회 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/sys/user/NewUserList.do")
	@ResponseBody
	public Object searchNewUserListGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchNewUserListGrid Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(SysUserService.NewUserTotCnt(params));
			extGrid.setData(SysUserService.NewUserList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchNewUserListGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 사용자별 사용현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/sys/user/UserList.do")
	public String showUserListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "사용자별 사용현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			System.out.println("showUserListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());

			List dummyList = dao.selectListByIbatis("sys.user.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showUserListPage Dummy. >>>>>>>>>>" + dummy);

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
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/sys/user/UserList";
	}

	/**
	 * 사용자별 사용현황 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/sys/user/UserList.do")
	@ResponseBody
	public Object selectUserList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectUserList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchFrom = StringUtil.nullConvert(params.get("DTFROM"));
			if (searchFrom.isEmpty()) {
				count++;
			}

			String searchTo = StringUtil.nullConvert(params.get("DTTO"));
			if (searchTo.isEmpty()) {
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
			extGrid.setTotcnt(SysUserService.selectUserListCount(params));
			extGrid.setData(SysUserService.selectUserList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectUserList End. >>>>>>>>>>");
		return extGrid;
	}
}