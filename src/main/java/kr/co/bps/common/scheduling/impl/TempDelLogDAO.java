package kr.co.bps.common.scheduling.impl;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("TempDelLogDAO")
public class TempDelLogDAO extends EgovAbstractDAO {

	/**
	 * 시스템 로그정보를 생성한다.
	 * 
	 * @param SysLog
	 * @return
	 * @throws Exception 
	 */
	public void del(String method) throws Exception{
		delete(method, "");
	}

}
