package kr.co.bps.common.scheduling.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.bps.common.scheduling.TempDelLogService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("TempDelLogService")
public class TempDelLogServiceImpl extends EgovAbstractServiceImpl implements 
	TempDelLogService {

	@Resource(name="TempDelLogDAO")
	private TempDelLogDAO tempDelLogDAO;	
	
	public void del(String method) throws Exception {
		// TODO Auto-generated method stub
		tempDelLogDAO.del(method);    	
	}

}
