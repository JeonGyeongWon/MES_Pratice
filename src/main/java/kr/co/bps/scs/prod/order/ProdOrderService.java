package kr.co.bps.scs.prod.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @ClassName : ProdOrderService.java
 * @Description : ProdOrder Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 09.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ProdOrderService extends BaseService {
	/**
	 * 기간별 검사현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkHistoryList(Map<String, Object> params) throws Exception {

		return dao.list("work.order.history.list.select", params);
	}

	/**
	 * 기간별 검사현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkHistoryCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("work.order.history.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
}