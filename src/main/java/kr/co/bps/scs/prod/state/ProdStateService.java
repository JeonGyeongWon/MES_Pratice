package kr.co.bps.scs.prod.state;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @ClassName : ProdStateService.java
 * @Description : ProdState Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 08.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ProdStateService extends BaseService {

	/**
	 * 작업자별 실적달성율 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> WorkerAccPerformList(Map<String, Object> params) throws Exception {

		return dao.list("prod.state.workeraccperform.select", params);
	}

	/**
	 * 작업자별 실적달성율 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int WorkerAccPerformCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.state.workeraccperform.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 설비부하율 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> EquipLoadFactorList(Map<String, Object> params) throws Exception {

		return dao.list("prod.state.equiploadfactor.select", params);
	}

	/**
	 * 설비부하율 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int EquipLoadFactorTotcnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.state.equiploadfactor.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
}