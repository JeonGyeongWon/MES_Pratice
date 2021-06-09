package kr.co.bps.scs.search;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @ClassName : SearchService.java
 * @Description : Search Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2015. 12.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class searchService extends BaseService {

	/**
	 * 로그인한 사용자 계정 롤을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public String selectGroupid(Map<String, Object> params) throws Exception {

		return (String) dao.select("userManageDAO.selectUserGroup_S", params);
	}

	/**
	 * org 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> OrgLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.org.lov.select", params);
	}

	/**
	 * org 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int OrgLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.org.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * Company 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> CompanyLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.company.lov.select", params);
	}

	/**
	 * Company 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int CompanyLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.company.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/** 2016.11.30
	 * 작업지시 투입관리 화면에서 품목 LOV 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> ItemNameLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.item.name.lov.select", params);
	}

	/**2016.11.30
	 * 작업지시 투입관리 화면에서 품목 LOV 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int ItemNameLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.item.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**2016.11.30
	 * 작업지시투입관리화면에서 작업지시번호 조회 부분에  항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> WorkNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.workno.list.lov.select", params);
	}

	/**2016.11.30
	 * 작업지시투입관리화면에서 작업지시번호 조회 부분에 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int WorkNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.workno.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**2016.12.01
	 * 작업지시투입관리화면에서 공정명 등록 부분에 항목을 조회한다. 해당 품목에 물려있는 공정명 표시
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> RoutingItemLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.routingitem.name.lov.select", params);
	}

	/**2016.12.01
	 * 작업지시투입관리화면에서 공정명 등록 부분에 항목 총 갯수를 조회한다.해당 품목에 물려있는 공정명 표시
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int RoutingItemLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.routingitem.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**2016.12.01
	 * 작업지시투입관리화면에서 설비명 조회 부분에 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> WorkCenterLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.workcenter.name.lov.select", params);
	}

	/**2016.12.01
	 * 작업지시투입관리화면에서 설비명  조회 부분에 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int WorkCenterLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.workcenter.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
		
	/**2016.12.01
	 * 작업지시투입관리화면에서 공정별 설비명  등록 부분에 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> EquipmentLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.equipment.name.lov.select", params);
	}

	/**2016.12.01
	 * 작업지시투입관리화면에서 공정별 설비명  등록 부분에 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int EquipmentLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.equipment.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/** 2016.12.16
	 * item code name ordername item type 팝업 lov 
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> ItemCodeOrderLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.itemcodeorder.lov.select", params);
	}

	/**2016.12.16
	 * item code name ordername item type 팝업 lov  총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int ItemCodeOrderLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.itemcodeorder.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
		
	/**
	 * 조회 부분에 소분류 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> SmallCodeLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.smallcode.lov.select", params);
	}

	/**
	 * 조회 부분에 소분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int SmallCodeLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.smallcode.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 중분류 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> MiddleCodeLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.middlecode.lov.select", params);
	}

	/**
	 * 조회 부분에 중분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int MiddleCodeLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.middlecode.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 대분류 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> BigCodeLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.bigcode.lov.select", params);
	}

	/**
	 * 조회 부분에 대분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int BigCodeLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.bigcode.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 검사항목 대분류 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> CheckBigCodeLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.check.bigcode.lov.select", params);
	}

	/**
	 * 조회 부분에 검사항목 대분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int CheckBigCodeLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.check.bigcode.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 검사항목 중분류 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> CheckMiddleCodeLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.check.middlecode.lov.select", params);
	}

	/**
	 * 조회 부분에 검사항목 중분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int CheckMiddleCodeLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.check.middlecode.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 검사항목 소분류 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> CheckSmallCodeLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.check.smallcode.lov.select", params);
	}

	/**
	 * 조회 부분에 검사항목 소분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int CheckSmallCodeLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.check.smallcode.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 Y / N 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> DummyYNLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.dummy.yn.lov.select", params);
	}

	/**
	 * 조회 부분에 Y / N 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int DummyYNLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.dummy.yn.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 OK / NG 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> DummyOKNG2LovList(Map<String, Object> params) throws Exception {

		return dao.list("search.dummy.okng2.lov.select", params);
	}

	/**
	 * 조회 부분에 OK / NG 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int DummyOKNG2LovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.dummy.okng2.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 OK / NG 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> DummyOKNGLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.dummy.okng.lov.select", params);
	}

	/**
	 * 조회 부분에 OK / NG 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int DummyOKNGLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.dummy.okng.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 시료값 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> DummyNumberLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.dummy.number.lov.select", params);
	}

	/**
	 * 조회 부분에 시료값 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int DummyNumberLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.dummy.number.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 고객사 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> CustomerLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.customer.name.lov.select", params);
	}

	/**
	 * 조회 부분에 고객사 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int CustomernameLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.customer.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 고객사 담당자 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> CustomerMemberLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.customer.member.lov.select", params);
	}

	/**
	 * 조회 부분에 고객사 담당자 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int CustomerMemberLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.customer.member.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 작업자 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> WorkerLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.worker.name.lov.select", params);
	}

	/**
	 * 조회 부분에 작업자 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int WorkerLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.worker.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 설비연결 작업자 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> WorkerEquipLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.worker.equip.name.lov.select", params);
	}

	/**
	 * 조회 부분에 설비연결 작업자 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int WorkerEquipLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.worker.equip.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 조회 부분에 설비연결 작업자 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchWorkerPCList(Map<String, Object> params) throws Exception {

		return dao.list("search.worker.pc.list.lov.select", params);
	}

	/**
	 * 조회 부분에 설비연결 작업자 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchWorkerPCTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.worker.pc.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 소분류 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> SmallClassLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.smallclass.lov.select", params);
	}

	/**
	 * 조회 부분에 소분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int SmallClassLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.smallclass.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 소분류 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> SmallClassDistinctLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.smallclass.distinct.lov.select", params);
	}

	/**
	 * 조회 부분에 소분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int SmallClassDistinctLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.smallclass.distinct.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 중분류 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> MiddleClassLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.middleclass.lov.select", params);
	}

	/**
	 * 조회 부분에 중분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int MiddleClassLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.middleclass.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 중분류 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> MiddleClassDistinctLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.middleclass.distinct.lov.select", params);
	}

	/**
	 * 조회 부분에 중분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int MiddleClassDistinctLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.middleclass.distinct.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 대분류 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> BigClassLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.bigclass.lov.select", params);
	}

	/**
	 * 조회 부분에 대분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int BigClassLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.bigclass.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 대분류 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> BigClassDistinctLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.bigclass.distinct.lov.select", params);
	}

	/**
	 * 조회 부분에 대분류 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int BigClassDistinctLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.bigclass.distinct.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 출고번호 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> RelNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.relno.list.lov.select", params);
	}

	/**
	 * 조회 부분에 출고번호 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int RelNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.relno.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 제품입출고번호 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> selectProdRelNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.prod.relno.list.lov.select", params);
	}

	/**
	 * 조회 부분에 제품입출고번호 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int selectProdRelNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.prod.relno.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/** 2017.01.20
	 * 생산출고 테이블에서 작업지시번호 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> RelNoLovList2(Map<String, Object> params) throws Exception {

		return dao.list("search.relno.list.lov.select2", params);
	}

	/**2017.01.20
	 * 생산출고 테이블에서 작업지시번호 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int RelNoLovTotCnt2(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.relno.list.lov.count2", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 조회 부분에 자재입고 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> TransNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.transno.list.lov.select", params);
	}

	/**
	 * 조회 부분에 자재입고 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int TransNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.transno.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}


	/**
	 * 조회 부분에 자재입고번호 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> TransNoLovList2(Map<String, Object> params) throws Exception {

		return dao.list("search.transno.list2.lov.select", params);
	}

	/**
	 * 조회 부분에 자재입고 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int TransNoLovTotCnt2(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.transno.list2.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}


	/**
	 * 조회 부분에 발주등록 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> PonoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.pono.list.lov.select", params);
	}

	/**
	 * 조회 부분에 발주등록 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int PonoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.pono.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 자재요청현황화면에서 요청번호 조회 부분에  항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> ReqNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.reqno.list.lov.select", params);
	}

	/**
	 * 자재요청현황화면에서 요청번호 조회 부분에 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int ReqNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.reqno.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}


	/**
	 * 조회 부분에 출하등록 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> ShipnoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.shipped.list.lov.select", params);
	}

	/**
	 * 조회 부분에 출하등록 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int ShipnoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.shipped.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 입고현황 팝업에 표시할 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> WarehousingLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.warehousing.list.lov.select", params);
	}

	/**
	 * 입고현황 팝업에 표시할 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int WarehousingLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.warehousing.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 자재요청 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> PorNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.porno.list.lov.select", params);
	}

	/**
	 * 조회 부분에 자재요청 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int PorNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.porno.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * item code name ordername item type 팝업 lov 
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> BarCodeOrderLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.barcodeorder.lov.select", params);
	}

	/**
	 * item code name ordername item type 팝업 lov  총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int BarCodeOrderLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.barcodeorder.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 검사기준정보 LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> CheckMasterLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.checkmaster.lov.select", params);
	}

	/**
	 * 검사기준정보 LOV 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int CheckMasterLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.checkmaster.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 공구명 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> ToolNameLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.tool.name.lov.select", params);
	}

	/**
	 * 조회 부분에 공구명 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int ToolNameLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.tool.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 공구명 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> ToolChangeNameLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.change.tool.name.lov.select", params);
	}

	/**
	 * 조회 부분에 공구명 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int ToolChangeNameLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.change.tool.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * LOT 이력 관리 LOT NO LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> HistoryLotNoList(Map<String, Object> params) throws Exception {

		return dao.list("search.history.lotno.lov.select", params);
	}

	/**
	 * LOT 이력 관리 조회 LOT NO LOV 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int HistoryLotNoTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.history.lotno.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 제품 LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchOrderItemLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.ordermanage.item.list.lov.select", params);
	}

	/**
	 * 제품 LOV 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchOrderItemLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.ordermanage.item.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 출하등록의 수주현황 Popup 항목 총갯수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchShipRegistManagePopupTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.order.shipregistmanagelistpopuplist.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 출하등록의 수주현황 Popup 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public List<?> searchShipRegistManagePopupList(Map<String, Object> params) throws Exception {

		return dao.list("search.order.shipregistmanagelistpopuplist.select", params);
	}

	/**
	 * 출하등록의 입고현황 Popup 항목 총갯수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchShipRegistManagePopup2TotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.order.shipregistmanagelistpopuplist2.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 출하등록의 입고현황 Popup 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public List<?> searchShipRegistManagePopup2List(Map<String, Object> params) throws Exception {

		return dao.list("search.order.shipregistmanagelistpopuplist2.select", params);
	}
	

	/**
	 * 수주번호 LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchSoNoFindLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.sonofing.number.list.lov.select", params);
	}

	/**
	 * 수주번호 LOV 항목 총 갯수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchSoNoFindLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.sonofing.number.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 출하번호 LOV 항목 총갯수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchShipNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.ship.shipno.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 출하번호 LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public List<?> searchShipNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.ship.shipno.lov.select", params);
	}

	/**
	 * 결과조회 LOV 항목 총갯수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchCheckResultPopupTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.check.result.popup.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 결과조회 LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public List<?> searchCheckResultPopupList(Map<String, Object> params) throws Exception {

		return dao.list("search.check.result.popup.select", params);
	}

	/**
	 * 결과조회 LOV 항목 총갯수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchCheckResultPopup2TotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.check.result.popup2.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 결과조회 LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public List<?> searchCheckResultPopup2List(Map<String, Object> params) throws Exception {

		return dao.list("search.check.result.popup2.select", params);
	}

	/**
	 * 거래명세서의 거래명세서 번호 Lov 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> TransnoLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.order.transno.lov.select", params);
	}

	/**
	 * 거래명세서의 거래명세서 번호 Lov 항목 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int TransnoLovTotcnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.order.transno.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * 거래명세서의 출하현황 Popup 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> TransShippingPopupList(Map<String, Object> params) throws Exception {

		return dao.list("search.shippinglist.popup.select", params);
	}

	/**
	 * 거래명세서의 출하현황 Popup 항목 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int TransShippingPopupTotcnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.shippinglist.popup.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * 거래명세서의 수주현황 Popup 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> TransSalesPopupList(Map<String, Object> params) throws Exception {

		return dao.list("search.saleslist.popup.select", params);
	}

	/**
	 * 거래명세서의 수주현황 Popup 항목 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int TransSalesPopupTotcnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.saleslist.popup.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * 작업자 투입/철수 관리 > 철수시간 선택시 설비 I/F 데이터 가공 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> WorkerInterfaceList(Map<String, Object> params) throws Exception {

		return dao2.list("mysql.search.worker.interface.list.select", params);
	}

	/**
	 * 작업자 투입/철수 관리 > 철수시간 선택시 설비 I/F 데이터 가공 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int WorkerInterfaceTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao2.list("mysql.search.worker.interface.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}


	/**
	 * 생산실적현황 (작업자) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchMonthlyWorkerList(Map<String, Object> params) throws Exception {

		return dao.list("search.monthly.worker.list.select", params);
	}

	/**
	 * 생산실적현황 (작업자) 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchMonthlyWorkerTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.monthly.worker.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 생산실적현황 (장비별) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchMonthlyEquipList(Map<String, Object> params) throws Exception {

		return dao.list("search.monthly.equip.list.select", params);
	}

	/**
	 * 생산실적현황 (장비별) 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchMonthlyEquipTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.monthly.equip.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 생산실적현황 (장비별) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchMonthlyWorkDeptList(Map<String, Object> params) throws Exception {

		return dao.list("search.monthly.equip.dept.list.select", params);
	}

	/**
	 * 생산실적현황 (장비별) 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchMonthlyWorkDeptTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.monthly.equip.dept.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 라우팅복사 LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> RoutingCopyList(Map<String, Object> params) throws Exception {

		return dao.list("search.routingregist.copy.lov.select", params);
	}

	/**
	 * 라우팅복사 LOV 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int RoutingCopyTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.routingregist.copy.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 자재 거래명세서 번호 LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchMatTradeNoList(Map<String, Object> params) throws Exception {

		return dao.list("search.mat.tradeno.list.lov.select", params);
	}

	/**
	 * 자재 거래명세서 번호 LOV 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchMatTradeNoTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.mat.tradeno.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 자재 거래명세서 > 발주현황 POPUP LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchScmTradePopupList(Map<String, Object> params) throws Exception {

		return dao.list("search.scm.trade.popup.lov.select", params);
	}

	/**
	 * 자재 거래명세서 > 발주현황 POPUP LOV 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchScmTradePopupTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.scm.trade.popup.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 외주발주 거래명세서 > 외주입고 POPUP LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchScmOutProcTradePopupList(Map<String, Object> params) throws Exception {

		return dao.list("search.scm.outproctrade.popup.lov.select", params);
	}

	/**
	 * 외주발주 거래명세서 > 외주입고 POPUP LOV 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchScmOutProcTradePopupTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.scm.outproctrade.popup.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 치공구관리 > 반출내역 POPUP LOV 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> ToolOutLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.tool.out.popup.lov.select", params);
	}

	/**
	 * 치공구관리 > 반출내역 POPUP LOV 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int ToolOutLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.tool.out.popup.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 조회 부분에 공구변경 > 공정명 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> ToolRoutingItemNameLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.tool.routingitem.name.lov.select", params);
	}

	/**
	 * 조회 부분에 공구변경 > 공정명 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int ToolRoutingItemNameLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.tool.routingitem.name.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 양품수량(CAVITY) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> WorkOrderProdQtyCavityLovList(Map<String, Object> params) throws Exception {

		return dao.list("search.work.routing.cavity.lov.select", params);
	}

	/**
	 * 조회 부분에 양품수량(CAVITY) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int WorkOrderProdQtyCavityLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.work.routing.cavity.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 조회 부분에 공정 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchRoutingList(Map<String, Object> params) throws Exception {

		return dao.list("search.routing.list.lov.select", params);
	}

	/**
	 * 조회 부분에 공정 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchRoutingCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.routing.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 타입 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchItemstandarddetailList(Map<String, Object> params) throws Exception {

		return dao.list("search.itemstandarddetail.list.lov.select", params);
	}

	/**
	 * 조회 부분에 타입 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchItemstandarddetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.itemstandarddetail.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	public int searchShippingItemGroupLovCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.ShippingItemGroup.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	public List<?> searchShippingItemGroupLovList(HashMap<String, Object> reqMap) {
		
		return dao.list("search.ShippingItemGroup.list.lov.list", reqMap);
	}

	public int searchOutTypeListLovCount(HashMap<String, Object> params) {
		List<?> count = dao.list("search.outType.list.lov.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	public List<?> searchOutTypeListLovList(HashMap<String, Object> params) {
		return dao.list("search.outType.list.lov.list", params);
	}
	
	public int searchAllEmployeeListLovCount(HashMap<String, Object> params) {
		List<?> count = dao.list("search.all.employee.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	public List<?> searchAllEmployeeListLovList(HashMap<String, Object> params) {
		return dao.list("search.all.employee.list", params);
	}
	

	/**
	 * 조회 부분에 매출그룹, 공정별 기종 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchGroupModelList(Map<String, Object> params) throws Exception {

		return dao.list("search.group.model.list.lov.select", params);
	}

	/**
	 * 조회 부분에 매출그룹, 공정별 기종 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchGroupModelCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.group.model.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 매출그룹, 공정별, 기종별 타입 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchGroupItemDetailList(Map<String, Object> params) throws Exception {

		return dao.list("search.group.itemdetail.list.lov.select", params);
	}

	/**
	 * 조회 부분에 매출그룹, 공정별, 기종별 타입 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchGroupItemDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.group.itemdetail.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 매출그룹, 공정별 기종 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchGroupYearModelList(Map<String, Object> params) throws Exception {

		return dao.list("search.group.year.model.list.lov.select", params);
	}

	/**
	 * 조회 부분에 매출그룹, 공정별 기종 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchGroupYearModelCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.group.year.model.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 설비별 기종 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchWorkModelList(Map<String, Object> params) throws Exception {

		return dao.list("search.work.model.list.lov.select", params);
	}

	/**
	 * 조회 부분에 설비별 기종 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchWorkModelCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.work.model.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 설비별 타입 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchWorkItemStandardDList(Map<String, Object> params) throws Exception {

		return dao.list("search.work.itemstandardd.list.lov.select", params);
	}

	/**
	 * 조회 부분에 설비별 타입 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchWorkItemStandardDCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.work.itemstandardd.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 기종그룹 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> ModelGroupList(Map<String, Object> params) throws Exception {

		return dao.list("search.model.group.list.lov.select", params);
	}

	/**
	 * 조회 부분에 기종그룹 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int ModelGroupListCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.model.group.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}


	/**
	 * 품목별 매출 실적현황 > 거래처 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchSalesCustomerList(Map<String, Object> params) throws Exception {

		return dao.list("search.sales.customer.list.lov.select", params);
	}

	/**
	 * 품목별 매출 실적현황 > 거래처 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchSalesCustomerCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.sales.customer.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 마감관리 > 영역별 마감 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchMonthlyCloseList(Map<String, Object> params) throws Exception {

		return dao.list("search.monthly.close.list.lov.select", params);
	}

	/**
	 * 마감관리 > 영역별 마감 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchMonthlyCloseCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.monthly.close.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 경영자정보 (모바일) > 모바일 메뉴 정보 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchMobileMenuList(Map<String, Object> params) throws Exception {

		return dao.list("search.mobile.button.list.select", params);
	}

	/**
	 * 경영자정보 (모바일) > 모바일 메뉴 정보 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchMobileMenuCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("search.mobile.button.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	public void callPython() {
		 Runtime rt = Runtime.getRuntime();
		 Process pc;
		try {
        	pc = null;
			
        	System.out.println("접속완료");
        	
			pc = rt.exec("C:/kakaoautomsgsender/main.exe");
			System.out.println("connDB.py 파이선 외부모듈 실행");
			
        } catch (Exception e) {
            System.out.println("예외났어요~~~~~~" + e);
        }
	
	
	}
}