package egovframework.let.uat.uia.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.context.ApplicationContext;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.support.WebApplicationContextUtils;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.uat.uap.service.EgovLoginPolicyService;
import egovframework.let.uat.uap.service.LoginPolicyVO;
import egovframework.let.uat.uia.service.EgovLoginService;
import egovframework.let.utl.sim.service.EgovClntInfo;
import egovframework.rte.fdl.cmmn.trace.LeaveaTrace;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 일반 로그인, 인증서 로그인을 처리하는 컨트롤러 클래스
 * 
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 * 
 *      <pre>
 * << 개정이력(Modification Information) >>
 * 
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성 
 *  2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 * 
 * </pre>
 */
@Controller
public class EgovLoginController extends BaseController {

	/** EgovLoginService */
	@Resource(name = "loginService")
	private EgovLoginService loginService;

	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

	/** EgovLoginPolicyService */
	@Resource(name = "egovLoginPolicyService")
	EgovLoginPolicyService egovLoginPolicyService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/** TRACE */
	@Resource(name = "leaveaTrace")
	LeaveaTrace leaveaTrace;


	/**
	 * 로그인 화면으로 들어간다
	 * 
	 * @param vo
	 *            - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value = "/uat/uia/egovLoginUsr.do")
	public String loginUsrView(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		String result = null;
		try {
			String userAgent = request.getHeader("user-agent");
			String[] mobileKeywords = {"iPhone", "iPod", "BlackBerry", "Android", "Windows CE", "Windows Phone", "Nokia", "Webos", "Opera Mini", "Opera Mobi", "IEMobile", "LG", "MOT", "SAMSUNG", "SonyEricsson"};
			
			boolean isMobile = false;
			int j = -1;
			if ( userAgent != null && !userAgent.equals("") ) {
				for ( int i = 0 ; i < mobileKeywords.length ; i++ ) {
					j = userAgent.indexOf(mobileKeywords[i]);
					if ( j > -1 ) {
						isMobile = true;
						break;
					}
				}

				System.out.println("1. PC / 모바일 여부 확인 >>>>>>>>>> " + isMobile);
				if ( isMobile ) {
					System.out.println("1-1. 모바일 화면으로 >>>>>>>>>> ");
					result = "uat/uia/EgovMobileLoginUsr";
				} else {
					System.out.println("1-2. PC 화면으로 >>>>>>>>>> ");
					result = "uat/uia/EgovLoginUsr";
				}
			}
//			System.out.println("1. 운영체제 종류 >>>>>>>>>> " + System.getProperty("os.name"));
//			System.out.println("2. 자바 가상머신 버전 >>>>>>>>>> " + System.getProperty("java.vm.version"));
//			System.out.println("3. 클래스 버전 >>>>>>>>>> " + System.getProperty("java.class.version"));
//			System.out.println("4. 사용자 로그인ID >>>>>>>>>> " + System.getProperty("user.name"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);
		return result;
	}

	
	/**
	 * 로그인 화면으로 들어간다
	 * 
	 * @param vo
	 *            - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value = "/uat/uia/egovMobileLoginUsr.do")
	public String mobileloginUsrView(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String result = null;
		try {
			String userAgent = request.getHeader("user-agent");
			String[] mobileKeywords = {"iPhone", "iPod", "BlackBerry", "Android", "Windows CE", "Windows Phone", "Nokia", "Webos", "Opera Mini", "Opera Mobi", "IEMobile", "LG", "MOT", "SAMSUNG", "SonyEricsson"};
			
			boolean isMobile = false;
			int j = -1;
			if ( userAgent != null && !userAgent.equals("") ) {
				for ( int i = 0 ; i < mobileKeywords.length ; i++ ) {
					j = userAgent.indexOf(mobileKeywords[i]);
					if ( j > -1 ) {
						isMobile = true;
						break;
					}
				}

				System.out.println("1. PC / 모바일 여부 확인 >>>>>>>>>> " + isMobile);
				if ( isMobile ) {
					System.out.println("1-1. 모바일 화면으로 >>>>>>>>>> ");
					result = "uat/uia/EgovMobileLoginUsr";
				} else {
					System.out.println("1-2. PC 화면으로 >>>>>>>>>> ");
					result = "uat/uia/EgovMobileLoginUsr";
				}
			}
//			System.out.println("1. 운영체제 종류 >>>>>>>>>> " + System.getProperty("os.name"));
//			System.out.println("2. 자바 가상머신 버전 >>>>>>>>>> " + System.getProperty("java.vm.version"));
//			System.out.println("3. 클래스 버전 >>>>>>>>>> " + System.getProperty("java.class.version"));
//			System.out.println("4. 사용자 로그인ID >>>>>>>>>> " + System.getProperty("user.name"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	/**
	 * 일반(스프링 시큐리티) 로그인을 처리한다
	 * 
	 * @param vo
	 *            - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request
	 *            - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
//	@ RequestMapping(value = "/uat/uia/actionSecurityLogin.do")
//	public String actionSecurityLogin( @ ModelAttribute("loginVO")LoginVO loginVO,
//		HttpServletRequest request, ModelMap model)throws Exception {
//
//		// 접속IP String userIp = EgovClntInfo.getClntIP(request);
//
//		System.out.println("접속IP : " + userIp);
//		loginVO.setIp("userIp"); // 1. 일반 로그인 처리
//		LoginVO resultVO = loginService.actionLogin(loginVO);
//		boolean
//		loginPolicyYn = true;
//
//		LoginPolicyVO loginPolicyVO = new LoginPolicyVO();
//		loginPolicyVO.setEmplyrId(resultVO.getId());
//		loginPolicyVO =
//			egovLoginPolicyService.selectLoginPolicy(loginPolicyVO);
//
//		if (loginPolicyVO == null) {
//			loginPolicyYn = true;
//		} else {
//			if
//			(loginPolicyVO.getLmttAt().equals("Y")) {
//				if
//				(!userIp.equals(loginPolicyVO.getIpInfo())) {
//					loginPolicyYn = false;
//				}
//			}
//		}
//		if (resultVO != null && resultVO.getId() != null &&
//			!resultVO.getId().equals("") && loginPolicyYn) { // 2. spring security 연동
//			request.getSession().setAttribute("LoginVO", resultVO);
//			return
//			"redirect:/j_spring_security_check?j_username=" + resultVO.getUserSe() +
//			resultVO.getId() + "&j_password=" + resultVO.getUniqId();
//
//		} else {
//			model.addAttribute("message",
//				egovMessageSource.getMessage("fail.common.login"));
//			return
//			"uat/uia/EgovLoginUsr";
//		}
//	}

	@RequestMapping(value = "/uat/uia/actionSecurityLogin.do")
	public String actionSecurityLogin(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletResponse response, HttpServletRequest request, ModelMap model) throws Exception {

		// 접속IP
		String userIp = EgovClntInfo.getClntIP(request);

		// 1. 일반 로그인 처리
		LoginVO resultVO = loginService.actionLogin(loginVO);

		boolean loginPolicyYn = true;

		LoginPolicyVO loginPolicyVO = new LoginPolicyVO();
		loginPolicyVO.setEmplyrId(resultVO.getId());
		loginPolicyVO = egovLoginPolicyService.selectLoginPolicy(loginPolicyVO);

		if (loginPolicyVO == null) {
			loginPolicyYn = true;
		} else {
			if (loginPolicyVO.getLmttAt().equals("Y")) {
				if (!userIp.equals(loginPolicyVO.getIpInfo())) {
					loginPolicyYn = false;
				}
			}
		}
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("") && loginPolicyYn) {

			// 2. spring security 연동
			request.getSession().setAttribute("LoginVO", resultVO);
			UsernamePasswordAuthenticationFilter springSecurity = null;
			ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());

			@SuppressWarnings("rawtypes")
			Map beans = act.getBeansOfType(UsernamePasswordAuthenticationFilter.class);
			if (beans.size() > 0) {
				springSecurity = (UsernamePasswordAuthenticationFilter) beans.values().toArray()[0];
			} else {
				throw new IllegalStateException("No AuthenticationProcessingFilter");
			}

			springSecurity.setContinueChainBeforeSuccessfulAuthentication(false); // false 이면 chain 처리 되지 않음..(filter가 아닌 경우 false로...)
			System.out.println("USER SE: " + resultVO.getUserSe());
			System.out.println("USER ID: " + resultVO.getId());
			System.out.println("UNIQUE ID: " + resultVO.getUniqId());

			springSecurity.doFilter(new RequestWrapperForSecurity(request, resultVO.getUserSe() + resultVO.getId(), resultVO.getUniqId()), response, null);

			return "forward:/uat/uia/actionMain.do"; // 성공 시 페이지.. (redirect 불가)

		} else {

			model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
			return "uat/uia/EgovLoginUsr";
		}
	}

	/**
	 * 로그인 후 메인화면으로 들어간다
	 * 
	 * @param
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value = "/uat/uia/actionMain.do")
	public String actionMain(ModelMap model, HttpServletRequest request) throws Exception {
		// 1. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
			return "uat/uia/EgovLoginUsr";
		} else {
			LoginVO resultVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			String author = egovAuthorGroupService.selectAuthorGroupList1(resultVO.getUniqId());

			// 2016.12.28 추가 - 권한별 최초 메뉴로 이동
			if ( !author.isEmpty() ) {
				HashMap<String, Object> params = new HashMap<String, Object>();
				
				params.put("AUTHORCODE", author);

				List<?> menuList = dao.list("search.login.first.menu.list.select", params);
				Map<String, Object> menuData = (Map<String, Object>) menuList.get(0);

				String menuno = StringUtil.nullConvert(menuData.get("MENUNO"));
				if ( !menuno.isEmpty() ) {
					return "forward:/cmm/main/mainPage.do?menuno=" + menuno;
				} else {
					return "forward:/cmm/main/mainPage.do";
				}
			} else {
	    		// 2. 메인 페이지 이동
				return "forward:/cmm/main/mainPage.do";
			}
			
			// 2016.12.28 주석 - 권한별 최초 메뉴 코드 추가로 현 기능 사용 중지
//        	if(author.equals("ROLE_MONITOR")) {
//        		return "forward:/eis/ProdMonitorWeekList.do?cur=1";
//        	} else if(author.equals("ROLE_WORK")) {
//    			return "forward:/prod/process/ProcessStart.do";
//        	} else{
//    			return "forward:/cmm/main/mainPage.do";
//        	}
		}
	}

	/**
	 * 로그아웃한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/uat/uia/actionLogout.do")
	public String actionLogout(HttpServletRequest request, ModelMap model) throws Exception {

		System.out.println(">>>>>>>>>>>>>>1111");
		try {
			request.getSession().setAttribute("LoginVO", null);
		} catch (Exception e) {
			// 1. Security 연동
			leaveaTrace.trace("fail.common.msg", this.getClass());
		}
//		return "redirect:/j_spring_security_logout";
		return "redirect:/uat/uia/egovLoginUsr.do";
	}

	class RequestWrapperForSecurity extends HttpServletRequestWrapper {
		private String username = null;
		private String password = null;

		public RequestWrapperForSecurity(HttpServletRequest request, String username, String password) {
			super(request);

			this.username = username;
			this.password = password;
		}

		@Override
		public String getRequestURI() {
			return ((HttpServletRequest) super.getRequest()).getContextPath() + "/j_spring_security_check";
		}

		@Override
		public String getParameter(String name) {
			if (name.equals("j_username")) {
				return username;
			}

			if (name.equals("j_password")) {
				return password;
			}

			return super.getParameter(name);
		}
	}
	
//	class RequestWrapperForSecurity extends HttpServletRequestWrapper {
//		private String username = null;
//		private String password = null;
//
//		public RequestWrapperForSecurity(HttpServletRequest request, String
//			username, String password) {
//			super(request);
//
//			this.username = username;
//			this.password = password;
//		}
//
//		 @ Override public String getRequestURI() {
//			return
//			((HttpServletRequest)super.getRequest()).getContextPath() +
//			"/j_spring_security_check";
//		}
//
//		 @ Override public String getParameter(String name) {
//			if
//			(name.equals("j_username")) {
//				return username;
//			}
//
//			if (name.equals("j_password")) {
//				return password;
//			}
//
//			return super.getParameter(name);
//		}
//	}
}