package kr.co.bps.scs.sys.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @ClassName : SysUserService.java
 * @Description : SysUser Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 02.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class SysUserService extends BaseService {

	/**
	 * 내부시스템관리 > 사용자 조회 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> NewUserList(Map<String, Object> params) throws Exception {

		return dao.list("sys.user.list.select", params);
	}

	/**
	 * 내부시스템관리 > 사용자 조회 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int NewUserTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("sys.user.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 사용자 사용현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectUserList(Map<String, Object> params) throws Exception {

		return dao.list("sys.user.userlist.select", params);
	}

	/**
	 * 사용자 사용현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectUserListCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("sys.user.userlist.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

}