package kr.co.bps.scs.material.release;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @ClassName : ReleaseMaterialService.java
 * @Description : ReleaseMaterial Service class
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
public class ReleaseMaterialService extends BaseService {

	/**
	 * 조회 부분에 자재수불조회 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectInventoryReceiptList(Map<String, Object> params) throws Exception {

		return dao.list("material.release.inventory.list.select", params);
	}

	/**
	 * 조회 부분에 자재수불조회 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectInventoryReceiptCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("material.release.inventory.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * 조회 부분에 공구수불조회 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolInventoryReceiptList(Map<String, Object> params) throws Exception {

		return dao.list("material.release.tool.inventory.list.select", params);
	}

	/**
	 * 조회 부분에 공구수불조회 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolInventoryReceiptCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("material.release.tool.inventory.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 자재입출고현황 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatStoreRelStatusList(Map<String, Object> params) throws Exception {

		System.out.println("selectMatStoreRelStatusList params. >>>>>>>>>> " + params);
		return dao.list("material.release.matstorerelstatus.select", params);
	}

	/**
	 * 자재입출고현황 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatStoreRelStatusCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("material.release.matstorerelstatus.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 자재수불조회 (도급/사급) 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSubConInventoryReceiptList(Map<String, Object> params) throws Exception {

		System.out.println("selectSubConInventoryReceiptList params. >>>>>>>>>> " + params);
		return dao.list("material.release.subcontract.inventory.list.select", params);
	}

	/**
	 * 자재수불조회 (도급/사급) 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSubConInventoryReceiptCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("material.release.subcontract.inventory.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 소재 입고현황 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatWarehousingList(HashMap<String, Object> params) {
		System.out.println("selectMatWarehousingList Service Start. >>>>>>>>>> " + params);
		return dao.list("material.release.warehousing.total.list.select", params);
	}

	/**
	 * 소재 입고현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatWarehousingCount(HashMap<String, Object> params) {
		List<?> count = dao.list("material.release.warehousing.total.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
}