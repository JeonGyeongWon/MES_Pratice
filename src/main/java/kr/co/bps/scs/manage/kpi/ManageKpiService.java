package kr.co.bps.scs.manage.kpi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.bps.scs.base.service.BaseService;

/**
 * @ClassName : ManageKpiService.java
 * @Description : ManageKpi Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jshwang
 * @since 2017. 01.
 * @version 1.0
 * @see
 */
@Transactional
@Service
public class ManageKpiService extends BaseService {
	
	
	/**
	 * 해당 월 시간당생산량 현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi2Area1List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi2.ManigeArea1.select", params);
	}
	
	/**
	 * 해당 월 시간당생산량 현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi2Area1Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi2.ManigeArea1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 월별 시간당 생산량 조건으로 차트를 출력한다
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi2Area2List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi2.ManigeArea2.select", params);
	}
	
	/**
	 * 월별 시간당 생산량 조건 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi2Area2Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi2.ManigeArea2.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 일별/설비별 시간당 생산량 조건으로 차트를 출력한다
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi2Area3List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi2.ManigeArea3.select", params);
	}
	
	/**
	 * 일별/설비별 시간당 생산량 차트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi2Area3Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi2.ManigeArea3.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 공정별 검사불량율 막대차트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi3Area1List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi3.ManigeArea1.select", params);
	}
	
	/**
	 * 공정별 검사불량율 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi3Area1Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi3.ManigeArea1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 공정별 검사불량율 꺾은선 차트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi3Area2List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi3.ManigeArea2.select", params);
	}
	
	/**
	 *  공정별 검사불량율 꺾은선 차트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi3Area2Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi3.ManigeArea2.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 공정별 검사불량율 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi3Area3List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi3.ManigeArea3.select", params);
	}
	
	/**
	 *  공정별 검사불량율 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi3Area3Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi3.ManigeArea3.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 납기단축감소 막대차트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi4Area1List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi4.ManigeArea1.select", params);
	}
	
	/**
	 *  납기단축감소 막대차트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi4Area1Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi4.ManigeArea1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 납기단축감소 꺾은선 차트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi4Area2List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi4.ManigeArea2.select", params);
	}
	
	/**
	 *  납기단축감소 꺾은선 차트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi4Area2Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi4.ManigeArea2.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 납기단축감소 상세현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi4Area3List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi4.ManigeArea3.select", params);
	}
	
	/**
	 *  납기단축감소 상세현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi4Area3Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi4.ManigeArea3.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 제조리드타임 단축 막대차트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi5Area1List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi5.ManigeArea1.select", params);
	}
	
	/**
	 *  제조리드타임 단축 막대차트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi5Area1Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi5.ManigeArea1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 제조리드타임 단축 꺾은선 차트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi5Area2List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi5.ManigeArea2.select", params);
	}
	
	/**
	 * 제조리드타임 단축 꺾은선 차트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi5Area2Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi5.ManigeArea2.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 제조리드타임 단축 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi5Area3List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi5.ManigeArea3.select", params);
	}
	
	/**
	 *  제조리드타임 단축 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi5Area3Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi5.ManigeArea3.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	


	/**
	 * 재공재고감소 꺾은선 차트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi7Area1List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi7.ManigeArea1.select", params);
	}
	
	/**
	 * 재공재고감소 꺾은선 차트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi7Area1Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi7.ManigeArea1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 재공재고감소 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi7Area2List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi7.ManigeArea2.select", params);
	}
	
	/**
	 *  재공재고감소 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi7Area2Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi7.ManigeArea2.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 재고비용 꺾은선 차트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi8Area1List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi8.ManigeArea1.select", params);
	}
	
	/**
	 * 재고비용 꺾은선 차트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi8Area1Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi8.ManigeArea1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 재고비용 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectManigeKpi8Area2List(Map<String, Object> params) throws Exception {

		return dao.list("manage.kpi8.ManigeArea2.select", params);
	}
	
	/**
	 *  재고비용 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectManigeKpi8Area2Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("manage.kpi8.ManigeArea2.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
}