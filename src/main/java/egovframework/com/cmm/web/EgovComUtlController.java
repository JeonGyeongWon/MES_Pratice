package egovframework.com.cmm.web;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.dao.DefaultDao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.cmm.LoginVO;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 공통유틸리티성 작업을 위한 Controller 클래스
 * @author 공통 서비스 개발팀 JJY
 * @since 2009.03.02
 * @version 1.0
 * @see
 *  
 * <pre>
 * << 개정이력(Modification Information) >>
 * 
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.02  JJY            최초 생성
 *  2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성 
 *  2018.04.30  YMHA        화면별 접속정보 등록 부분 추가
 *  
 *  </pre>
 */
@Controller
public class EgovComUtlController {

	@Autowired
	protected HttpSession session;

	@Autowired
	protected DefaultDao dao;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
    
	protected LoginVO getLoginVO() {
		return (LoginVO) session.getAttribute("LoginVO");
	}

    /**
	 * JSP 호출작업만 처리하는 공통 함수
	 */
	@RequestMapping(value="/EgovPageLink.do")
	public String moveToPage(@RequestParam("link") String linkPage, 
			HttpSession session, 
			@RequestParam(value="baseMenuNo", required=false) String baseMenuNo){
		HashMap<String, Object> params = new HashMap<String, Object>();

		System.out.println("moveToPage 1. >>>>>>>> " + linkPage);
		String link = linkPage;

		// service 사용하여 리턴할 결과값 처리하는 부분은 생략하고 단순 페이지 링크만 처리함
		if (linkPage==null || linkPage.equals("")){
			link="cmm/egovError";
		}else{
			if(link.indexOf(",")>-1){
			    link=link.substring(0,link.indexOf(","));
			}
		}
		// 선택된 메뉴정보를 세션으로 등록한다.
		if (baseMenuNo!=null && !baseMenuNo.equals("") && !baseMenuNo.equals("null")){
			session.setAttribute("baseMenuNo",baseMenuNo);

			System.out.println("moveToPage 2. >>>>>>>> " + linkPage);
			String [] linkArray = linkPage.split(",");
			System.out.println("moveToPage 3. >>>>>>>> " + linkArray.length);
			if ( linkArray.length == 1 ) {
				System.out.println("moveToPage 4. >>>>>>>> " + linkArray[0].indexOf("forward:/"));
				if ( linkArray[0].indexOf("forward:/") > -1 ) {

					try {
						// 2018-04-30 추가, 화면별 접속시 접속 정보 등록
						LoginVO login = getLoginVO();
						params.put("VIEWID", baseMenuNo);
						params.put("REGISTID", login.getId());
						params.put("GUBUN", "TOP");

						System.out.println("화면별 접속정보 등록 PROCEDURE 호출 Start. >>>>>>>> " + params);
						dao.list("CmmUse.login.save.call.Procedure", params);
						System.out.println("화면별 접속정보 등록 PROCEDURE 호출 End.  >>>>>>>> " + params);
					} catch ( Exception e ) {
						e.printStackTrace();
					}
				}
			}
		}
		return link;
	}

    /**
	 * 좌측 메뉴 JSP 호출작업만 처리하는 공통 함수
	 */
	@RequestMapping(value="/EgovLeftPageLink.do")
	public String moveToLeftPage(@RequestParam("cid") String childrenId,
			                             @RequestParam("pid") String parentId,
			                             @RequestParam("link") String linkPage){
		HashMap<String, Object> params = new HashMap<String, Object>();

		System.out.println("moveToLeftPage 1. >>>>>>>> " + linkPage);
		String link = linkPage;

		try {
			// 2018-04-30 추가, 화면별 접속시 접속 정보 등록
			LoginVO login = getLoginVO();
			params.put("VIEWID", childrenId);
			params.put("REGISTID", login.getId());
			params.put("GUBUN", "LEFT");

			System.out.println("화면별 접속정보 등록 PROCEDURE 호출 Start. >>>>>>>> " + params);
			dao.list("CmmUse.login.save.call.Procedure", params);
			System.out.println("화면별 접속정보 등록 PROCEDURE 호출 End.  >>>>>>>> " + params);
			
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return "redirect:" + link.replace(",", "");
	}

    /**
	 * JSP 호출작업만 처리하는 공통 함수
	 */
	@RequestMapping(value="/EgovPageLink.action")
	public String moveToPage_action(@RequestParam("link") String linkPage){
		String link = linkPage;
		// service 사용하여 리턴할 결과값 처리하는 부분은 생략하고 단순 페이지 링크만 처리함
		if (linkPage==null || linkPage.equals("")){
			link="cmm/egovError";
		}
		return link;
	}
	
    /**
	 * validation rule dynamic java script
	 */
	@RequestMapping("/validator.do")
	public String validate(){
		return "cmm/validator";
	}

}