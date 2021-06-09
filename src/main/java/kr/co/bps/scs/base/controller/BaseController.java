package kr.co.bps.scs.base.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.dao.DefaultDao;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * @ClassName : BaseController.java
 * @Description : Base Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2015. 11.
 * @version 1.0
 * @see Grid 페이징 컨트롤
 * 
 */
public class BaseController {

	protected final Logger LOGGER = LoggerFactory.getLogger(getClass());

	@Autowired
	protected HttpServletRequest request;

	@Autowired
	protected HttpSession session;

	@Autowired
	protected DefaultDao dao;

	@Resource(name = "egovMessageSource")
	protected EgovMessageSource egovMessageSource;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	protected LoginVO getLoginVO() {
		return (LoginVO) session.getAttribute("LoginVO");
	}

	protected Map<String, Object> getGridParam4paging(Map<String, Object> params) {
		int page, limit, start;
		String sidx, sord;

		try {
			page = Integer.parseInt((String) params.get("page"));
		} catch (Exception nullexp) {
			page = 1;
		}

		try {
			limit = Integer.parseInt((String) params.get("rows"));
		} catch (Exception nullexp) {
			limit = 20;
		}

		try {
			start = Integer.parseInt((String) params.get("start"));
			if (start < 0)
				start = 0;
		} catch (Exception nullexp) {
			start = 0;
		}

		try {
			sidx = (String) params.get("sidx");
		} catch (Exception nullexp) {
			sidx = "";
		}

		try {
			sord = (String) params.get("sord");
		} catch (Exception nullexp) {
			sord = "";
		}

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("page", page);
		result.put("limit", limit);
		result.put("start", start);
		result.put("sidx", sidx);
		result.put("sord", sord);
		return result;
	}
}