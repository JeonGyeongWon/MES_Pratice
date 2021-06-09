package kr.co.bps.scs.base.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.dao.BaseDAO;
import kr.co.bps.scs.base.dao.BaseDAO2;
import kr.co.bps.scs.util.StringUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * @ClassName : BaseService.java
 * @Description : Base Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2015. 11.
 * @version 1.0
 * @see
 * 
 * 
 */
@Service
public class BaseService {

	protected final Logger LOGGER = LoggerFactory.getLogger(getClass());

	@Autowired
	protected HttpServletRequest request;

	@Autowired
	protected HttpSession session;

//	@Autowired
//	protected DefaultDao dao;

	@Autowired
	@Resource(name="BaseDAO")
	protected BaseDAO dao;

	@Autowired
	@Resource(name="BaseDAO2")
	protected BaseDAO2 dao2;

	@Resource(name = "egovMessageSource")
	protected EgovMessageSource egovMessageSource;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;

	protected LoginVO getLoginVO() {
		return (LoginVO) session.getAttribute("LoginVO");
	}

	public Map<String, Object> getAjaxResultMap(boolean isSuccess, String oper, String msg) throws Exception {

		Map<String, Object> result = getAjaxResultMap(isSuccess, oper);
		result.put("msg", msg);
		return result;
	}

	public Map<String, Object> getAjaxResultMap(boolean isSuccess, String oper) throws Exception {
		String success = isSuccess ? "success" : "fail";
		String msg = "";

		if (oper != null && oper.length() > 0) {
			msg = egovMessageSource.getMessage(success + ".common." + oper);
		}
		//oper부재
		else {
			msg = egovMessageSource.getMessage("fail.request.msg");
		}

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("success", isSuccess);
		result.put("msg", msg);

		return result;
	}

	protected List<Object> getGridData(Map<String, Object> params) throws Exception {
		String content = StringUtil.nullConvert((String) params.get("data"));
		if (content.length() == 0)
			return null;

		ObjectMapper om = new ObjectMapper();
		List<?> list = om.readValue(content, ArrayList.class);

		LoginVO loginVO = getLoginVO();
		List<Object> result = new ArrayList<Object>();
		for (Object o : list) {
			Map<String, Object> m = (Map<String, Object>) o;
			m.put("registid", loginVO.getId());
			m.put("updateid", loginVO.getId());
			result.add(m);
		}
		return result;
	}

	protected Map<String, Object> getExtGridResultMap(boolean isSuccess) throws Exception {
		return getExtGridResultMap(isSuccess, "");
	}

	protected Map<String, Object> getExtGridResultMap(boolean isSuccess, String oper) throws Exception {
		String success = isSuccess ? "success" : "fail";
		String msg = "";

		if (oper != null && oper.length() > 0) {
			msg = egovMessageSource.getMessage(success + ".common." + oper);
		}
		//oper부재
		else {
			msg = egovMessageSource.getMessage(success + ".request.msg");
		}

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("success", isSuccess);
		result.put("msg", msg);

		return result;
	}

	protected Map<String, Object> getExtGridResultMap(boolean isSuccess, String oper, String msg) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		result.putAll(getExtGridResultMap(isSuccess, oper));
		result.put("msg", msg);
		return result;
	}

	protected void setInsertParams(Map<String, Object> params) throws Exception {
		LoginVO loginVO = getLoginVO();
		params.put("registid", loginVO.getId());
		params.put("updateid", loginVO.getId());
	}

	protected void setUpdateParams(Map<String, Object> params) throws Exception {
		LoginVO loginVO = getLoginVO();
		params.put("updateid", loginVO.getId());
	}
}