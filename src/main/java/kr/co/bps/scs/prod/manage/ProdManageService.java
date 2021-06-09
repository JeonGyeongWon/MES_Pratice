package kr.co.bps.scs.prod.manage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.util.NumberUtil;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : ProdManageService.java
 * @Description : ProdManage Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 08.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ProdManageService extends BaseService {
	/**
	 * 공구변경 현황 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolChangeList(Map<String, Object> params) throws Exception {
		System.out.println("selectToolChangeList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("work.order.toolchange.manage.select", params);
	}

	/**
	 * 공구변경 현황 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolChangeCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("work.order.toolchange.manage.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 생산 실적현황 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkTotalList(Map<String, Object> params) throws Exception {
		System.out.println("selectWorkTotalList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("work.order.total.manage.select", params);
	}

	/**
	 * 생산 실적현황 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkTotalCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("work.order.total.manage.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 생산계획 등록관리 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdPlanRegistManageList(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.ProdPlanRegistManage.select", params);
	}

	/**
	 * 생산계획 등록관리 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdPlanRegistManageCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.ProdPlanRegistManage.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 생산계획 등록관리 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateProdPlanRegistManage(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
			System.out.println("update CB_PROD_PLAN >>>>>>>>>> " + master);

			int updateResult = dao.update("prod.manage.ProdPlanRegistManage.update", master);
			if (updateResult == 0) {
				errcnt++;
				throw new Exception("update CB_PROD_PLAN fail.");
			}

			String orgid = StringUtil.nullConvert(master.get("ORGID"));
			String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
			String workplanno = StringUtil.nullConvert(master.get("WORKPLANNO"));
			
			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("WORKPLANNO", workplanno);
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			master.put("WORKORDERID", "");
			System.out.println("생산계획 > 작업지시 자동생성 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("prod.plan.work.order.create.call.Procedure", master);
			System.out.println("생산계획 > 작업지시 자동생성 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			System.out.println("updateProdPlanRegistManage status >>>>>>>> " + status);
//			if (!status.equals("S")) {
//				errcnt += 1;
//				throw new Exception("call CB_MFG_PKG.CB_PLAN_WORK_ORDER_CREATE fail.");
//			}
		}

		boolean isSuccess = true;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "update");
	}

	
	/**
	 * 생산현황 및 CAPA 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdCapaList(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.capa.list.select", params);
	}

	/**
	 * 생산현황 및 CAPA 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdCapaCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.capa.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 월별 생산실적현황(작업자) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonthlyWorkerList(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.monthly.worker.list.select", params);
	}

	/**
	 * 월별 생산실적현황(작업자) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonthlyWorkerCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.monthly.worker.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 월별 생산실적현황(장비별) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonthlyEquipList(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.monthly.equip.list.select", params);
	}

	/**
	 * 월별 생산실적현황(장비별) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonthlyEquipCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.monthly.equip.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * 설비 실적현황 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdEquipResultList(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.equip.result.list.select", params);
	}

	/**
	 * 설비 실적현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdEquipResultCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.equip.result.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 월별 공구불출 현황 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMonthlyDischargeList(Map<String, Object> params) throws Exception {
		System.out.println("selectMonthlyDischargeList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("work.order.monthly.discharge.select", params);
	}

	/**
	 * 월별 공구불출 현황 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMonthlyDischargeCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.monthly.discharge.count", params);
	}

	/**
	 * 작업지시 현황조회 (설비별) 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDailyEquipList(Map<String, Object> params) throws Exception {
		System.out.println("selectDailyEquipList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("work.order.daily.equip.list.select", params);
	}

	/**
	 * 작업지시 현황조회 (설비별) 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDailyEquipCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.daily.equip.list.count", params);
	}

	
	/**
	 * 공정진행현황 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdStatusList(Map<String, Object> params) throws Exception {
		System.out.println("selectProdStatusList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("work.order.prod.status.list.select", params);
	}

	/**
	 * 공정진행현황 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdStatusCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.prod.status.list.count", params);
	}

	/**
	 * 공정진행현황 집계 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdStatusTotalList(Map<String, Object> params) throws Exception {
		System.out.println("selectProdStatusTotalList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("work.order.prod.status.total.select", params);
	}

	/**
	 * 공정진행현황 집계 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdStatusTotalCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.prod.status.total.count", params);
	}
	

	/**
	 * 기종별 생산실적현황 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkTotalDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectWorkTotalDetailList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("work.order.total.detail.select", params);
	}

	/**
	 * 기종별 생산실적현황 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkTotalDetailCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("work.order.total.detail.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	

	/**
	 * 생산현황 (타입별) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdModelDetailList(Map<String, Object> params) throws Exception {

		return dao.list("prod.model.detail.list.select", params);
	}

	/**
	 * 생산현황 (타입별) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdModelDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.model.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 생산현황 (종합) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdModelList(Map<String, Object> params) throws Exception {

		return dao.list("prod.model.total.list.select", params);
	}

	/**
	 * 생산현황 (종합) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdModelCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.model.total.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 생산현황 (월별) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdModelYearList(Map<String, Object> params) throws Exception {

		return dao.list("prod.model.year.list.select", params);
	}

	/**
	 * 생산현황 (월별) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdModelYearCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.model.year.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 일별기종별생산실적 ( 월별종합 ) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDailyModelMonthlyList(Map<String, Object> params) throws Exception {

		return dao.list("prod.daily.model.month.list.select", params);
	}

	/**
	 * 일별기종별생산실적 ( 월별종합 ) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDailyModelMonthlyCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.daily.model.month.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 일별기종별생산실적 ( 타입별 ) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDailyItemDetailMonthlyList(Map<String, Object> params) throws Exception {

		return dao.list("prod.daily.itemdetail.month.list.select", params);
	}

	/**
	 * 일별기종별생산실적 ( 타입별 ) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDailyItemDetailMonthlyCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.daily.itemdetail.month.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 일별기종별생산실적 ( 그래프 ) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDailyGraphMonthlyList(Map<String, Object> params) throws Exception {

		return dao.list("prod.daily.graph.month.list.select", params);
	}

	/**
	 * 일별기종별생산실적 ( 그래프 ) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDailyGraphMonthlyCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.daily.graph.month.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 일별기종별생산실적 ( 년간종합 ) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectYearModelMonthlyList(Map<String, Object> params) throws Exception {

		return dao.list("prod.year.model.month.list.select", params);
	}

	/**
	 * 일별기종별생산실적 ( 년간종합 ) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectYearModelMonthlyCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.year.model.month.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 일별기종별생산실적 ( 3개년 그래프 ) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDailyGraphYearList(Map<String, Object> params) throws Exception {

		return dao.list("prod.daily.graph.year.list.select", params);
	}

	/**
	 * 일별기종별생산실적 ( 3개년 그래프 ) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDailyGraphYearCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.daily.graph.year.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 일별기종별생산실적 ( 금년도 비율 그래프 ) 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDailyGraphModelList(Map<String, Object> params) throws Exception {

		return dao.list("prod.daily.graph.year.model.select", params);
	}

	/**
	 * 일별기종별생산실적 ( 금년도 비율 그래프 ) 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDailyGraphModelCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.daily.graph.year.model.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}


	/**
	 * 공정진행현황 공정 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdStatusList2HeaderList(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.status.list.header.select", params);
	}

	/**
	 * 공정진행현황 공정 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdStatusList2HeaderCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.status.list.header.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 공정진행현황 공정 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdStatusList2(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.status.list.select", params);
	}

	/**
	 * 공정진행현황 공정 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdStatusList2Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.status.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 공구 입고관리 마스터 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolWarehousingManageMasterList(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.toolwarehousing.master.list.select", params);
	}

	/**
	 * 공구입고관리 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolWarehousingManageMasterCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.toolwarehousing.master.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 공구입고관리 상세 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolWarehousingManageDetailList(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.toolwarehousing.detail.list.select", params);
	}

	/**
	 * 공구입고관리 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolWarehousingManageDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.toolwarehousing.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 공구입고관리 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertToolWarehousingMasterList(HashMap<String, Object> params) throws Exception {

		String transno = null;
		try {
			String TransNo = StringUtil.nullConvert(params.get("TransNo"));
			if (TransNo.isEmpty()) {
				List ordernoList = dao.selectListByIbatis("toolwarehousing.new.transno.select", params);
				Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
				params.put("TRANSNO", current.get("TRANSNO"));
				transno = (String) current.get("TRANSNO");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", loginVO.getId());

			// 접수시 상태
			master.put("STATUS", "STAND_BY");
			master.put("TRANSNO", transno);

			System.out.println("transno No >>>>>>>>>> " + transno);

			int updateResult = dao.update("prod.manage.toolwarehousing.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("INSERT INTO CB_TRANS_H fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
		return params;
	}

	/**
	 * 공구입고관리 등록 그리드 데이터 insert
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertToolWarehousingDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertToolWarehousingDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("insertToolWarehousingDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();
			int transqty =0;	
			int old_transqty = 0;

			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				{
					// 재고 트랜잭션 호출
					String orgid = StringUtil.nullConvert(master.get("ORGID"));
					String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
					String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
					String lotno = StringUtil.nullConvert(master.get("CUSTOMERLOT"));
					String trxgubun = "I";
					String trxtype = "공구-입고";
					Integer trxqty = NumberUtil.getInteger(master.get("TRANSQTY"));
					Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
//					String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
					String trxno = StringUtil.nullConvert(master.get("TRANSNO"));
					Integer trxseq = NumberUtil.getInteger(master.get("TRANSSEQ"));
					String trxiud = "INSERT";
					String remarks = StringUtil.nullConvert(master.get("REMARKS"));
					
					master.put("ORGID", orgid);
					master.put("COMPANYID", companyid);
					master.put("ITEMCODE", itemcode);
					master.put("LOTNO", lotno);
					master.put("TRXGUBUN", trxgubun);
					master.put("TRXTYPE", trxtype);
					master.put("TRXQTY", trxqty);
					master.put("TRXUNITPRICE", trxunitprice);
//					master.put("TRXWAREHOUSING", trxwarehousing);
					master.put("TRXNO", trxno);
					master.put("TRXSEQ", trxseq);
					master.put("TRXIUD", trxiud);
					master.put("REMARKS", remarks);
					master.put("REGISTID", loginVO.getId());
					master.put("RETURNSTATUS", "");
					master.put("MSGDATA", "");
					System.out.println("공구입고 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("prod.tool.trans.item.transaction.call.procedure", master);
					System.out.println("공구입고 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
					
					// 발주상태변경을 위한 CODE
					int orderqty = 0;
					transqty = NumberUtil.getInteger(master.get("TRANSQTY"));
					old_transqty = NumberUtil.getInteger(dao.list("prod.manage.toolwarehousing.old.transqty",master).get(0));
					orderqty = NumberUtil.getInteger(dao.list("prod.manage.toolwarehousing.orderqty",master).get(0));
					
					String pono = StringUtil.nullConvert(master.get("PONO"));
					
					master.put("PONO",pono);
					System.out.println("old_transqty >>>>>>>" + old_transqty);
					System.out.println("transqty >>>>>>>" + transqty);
					System.out.println("orderqty >>>>>>>" + orderqty);
					if ((transqty + old_transqty) >= orderqty) {
						System.out.println("발주상태 업데이트 시작 >>>>>" + master);
						master.put("COMPLETE", "COMPLETE");
						master.put("UPDATEID", loginVO.getId());
						dao.update("prod.manage.toolwarehousing.update.order.status", master);
						System.out.println("발주상태 업데이트 종료 >>>>>" + master);
					}
				}
				
				master.put("REGISTID", loginVO.getId());
				master.put("REQCONFIRMQTY", "0");
				master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

				int updateResult = dao.update("prod.manage.toolwarehousing.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("INSERT INTO CB_TRANS_D fail.");
				}
				
				if(i==SIZE-1){		//insert 다 끝나고 마지막에 변경.
					int postatus=0, old_status=0;
					postatus = NumberUtil.getInteger(dao.list("prod.manage.toolwarehousing.count.order.status",master).get(0));
					old_status = NumberUtil.getInteger(dao.list("prod.manage.toolwarehousing.count.trans.status",master).get(0));
					
					System.out.println("postatus >>>>>>>" + postatus);
					System.out.println("old_status >>>>>>>" + old_status);
					if (postatus > old_status) {
						System.out.println("발주상태 업데이트 시작 >>>>>" + master);
						master.put("COMPLETE", "STAND_BY");
						master.put("UPDATEID", loginVO.getId());
						dao.update("prod.manage.toolwarehousing.update.order.status", master);
						System.out.println("발주상태 업데이트 종료 >>>>>" + master);
					} else {
						System.out.println("발주상태 업데이트 시작2 >>>>>" + master);
						master.put("COMPLETE", "COMPLETE");
						master.put("UPDATEID", loginVO.getId());
						dao.update("prod.manage.toolwarehousing.update.order.status", master);
						System.out.println("발주상태 업데이트 종료2 >>>>>" + master);
						
					}
				}
			}

			// 저장시 ajax 성공유무 여부 호출
			boolean isSuccess = false;
			if (errcnt > 0) {
				isSuccess = false;
			} else {
				isSuccess = true;
			}
			params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

	/**
	 * 공구입고관리 상세정보 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateToolWarehousingMasterList(HashMap<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", loginVO.getId());

			int updateResult = dao.update("prod.manage.toolwarehousingheader.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("UPDATE CB_TRANS_H fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		return params;
	}

	/**
	 * 공구입고관리 상세정보 그리드 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateToolWarehousingDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateToolWarehousingDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("updateToolWarehousingDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();
			int transqty = 0;
			int old_transqty = 0;

			System.out.println("updateToolWarehousingDetailList 3. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				// porno 등록유무 확인
				List pornoList = dao.selectListByIbatis("prod.manage.toolwarehousingdetail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
				int poCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateToolWarehousingDetailList poCheck >>>>>>>>>> " + poCheck);
				if (poCheck == 0) {
					// 생성
					{
						// 재고 트랜잭션 호출
						String orgid = StringUtil.nullConvert(master.get("ORGID"));
						String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
						String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
						String lotno = StringUtil.nullConvert(master.get("CUSTOMERLOT"));
						String trxgubun = "I";
						String trxtype = "공구-입고";
						Integer trxqty = NumberUtil.getInteger(master.get("TRANSQTY"));
						Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
//						String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
						String trxno = StringUtil.nullConvert(master.get("TRANSNO"));
						Integer trxseq = NumberUtil.getInteger(master.get("TRANSSEQ"));
						String trxiud = "INSERT";
						String remarks = StringUtil.nullConvert(master.get("REMARKS"));
						
						master.put("ORGID", orgid);
						master.put("COMPANYID", companyid);
						master.put("ITEMCODE", itemcode);
						master.put("LOTNO", lotno);
						master.put("TRXGUBUN", trxgubun);
						master.put("TRXTYPE", trxtype);
						master.put("TRXQTY", trxqty);
						master.put("TRXUNITPRICE", trxunitprice);
//						master.put("TRXWAREHOUSING", trxwarehousing);
						master.put("TRXNO", trxno);
						master.put("TRXSEQ", trxseq);
						master.put("TRXIUD", trxiud);
						master.put("REMARKS", remarks);
						master.put("REGISTID", loginVO.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println("공구입고 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("prod.tool.trans.item.transaction.call.procedure", master);
						System.out.println("공구입고 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
						
						// 발주상태변경을 위한 CODE
						int orderqty = 0;
						transqty = NumberUtil.getInteger(master.get("TRANSQTY"));
						old_transqty = NumberUtil.getInteger(dao.list("dist.trans.old.transqty",master).get(0));
						orderqty = NumberUtil.getInteger(dao.list("dist.trans.orderqty",master).get(0));
						
						String pono = StringUtil.nullConvert(master.get("PONO"));
						
						master.put("PONO",pono);
						System.out.println("old_transqty >>>>>>>" + old_transqty);
						System.out.println("transqty >>>>>>>" + transqty);
						System.out.println("orderqty >>>>>>>" + orderqty);
						if((transqty + old_transqty) >= orderqty){
						System.out.println("발주상태 업데이트 시작 >>>>>" + master);		
							master.put("COMPLETE", "COMPLETE");
							master.put("UPDATEID", loginVO.getId());
							dao.update("dist.trans.update.order.status",master);
						System.out.println("발주상태 업데이트 종료 >>>>>" + master);	
						}
					}
					
					master.put("REGISTID", loginVO.getId());
					//					master.put("REQCONFRIMQTY", "0");
					master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

					int updateResult = dao.update("prod.manage.toolwarehousingdetail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("INSERT INTO CB_TRANS_D fail.");
					}
				} else {
					// 변경
					{
						// 재고 트랜잭션 호출
						String orgid = StringUtil.nullConvert(master.get("ORGID"));
						String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
						String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
						String lotno = StringUtil.nullConvert(master.get("CUSTOMERLOT"));
						String trxgubun = "U";
						String trxtype = "공구-입고";
						Integer trxqty = NumberUtil.getInteger(master.get("TRANSQTY"));
						Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
//						String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
						String trxno = StringUtil.nullConvert(master.get("TRANSNO"));
						Integer trxseq = NumberUtil.getInteger(master.get("TRANSSEQ"));
						String trxiud = "UPDATE";
						String remarks = StringUtil.nullConvert(master.get("REMARKS"));
						
						master.put("ORGID", orgid);
						master.put("COMPANYID", companyid);
						master.put("ITEMCODE", itemcode);
						master.put("LOTNO", lotno);
						master.put("TRXGUBUN", trxgubun);
						master.put("TRXTYPE", trxtype);
						master.put("TRXQTY", trxqty);
						master.put("TRXUNITPRICE", trxunitprice);
//						master.put("TRXWAREHOUSING", trxwarehousing);
						master.put("TRXNO", trxno);
						master.put("TRXSEQ", trxseq);
						master.put("TRXIUD", trxiud);
						master.put("REMARKS", remarks);
						master.put("REGISTID", loginVO.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println("공구입고변경 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("prod.tool.trans.item.transaction.call.procedure", master);
						System.out.println("공구입고변경 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
						
						String pono = StringUtil.nullConvert(master.get("PONO"));
						
						master.put("PONO",pono);
						int orderqty = 0;
						transqty = NumberUtil.getInteger(master.get("TRANSQTY"));
						old_transqty = NumberUtil.getInteger(dao.list("dist.trans.old.transqty",master).get(0));
						orderqty = NumberUtil.getInteger(dao.list("dist.trans.orderqty",master).get(0));
						
						System.out.println("old_transqty >>>>>>>" + old_transqty);
						System.out.println("transqty >>>>>>>" + transqty);
						System.out.println("orderqty >>>>>>>" + orderqty);
						if((transqty + old_transqty) >= orderqty){
							System.out.println("발주상태 업데이트 시작 >>>>>" + master);		
								master.put("COMPLETE", "COMPLETE");
								master.put("UPDATEID", loginVO.getId());
								dao.update("dist.trans.update.order.status",master);
							System.out.println("발주상태 업데이트 종료 >>>>>" + master);	
						}else{
							System.out.println("발주상태 업데이트 시작2 >>>>>" + master);		
								master.put("COMPLETE", "STAND_BY");
								master.put("UPDATEID", loginVO.getId());
								dao.update("dist.trans.update.order.status",master);
							System.out.println("발주상태 업데이트 종료2 >>>>>" + master);	
						}
					}
					
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("prod.manage.toolwarehousingdetail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_TRANS_D fail.");
					}
				}
				
				if(i==SIZE-1){		//업데이트 다 끝나고 마지막에 발주상태 변경.
					int postatus=0, old_status=0;
					postatus = NumberUtil.getInteger(dao.list("prod.manage.toolwarehousing.count.order.status",master).get(0));
					old_status = NumberUtil.getInteger(dao.list("prod.manage.toolwarehousing.count.trans.status",master).get(0));
					
					System.out.println("postatus >>>>>>>" + postatus);
					System.out.println("old_status >>>>>>>" + old_status);
					if (postatus > old_status) {
						System.out.println("발주상태 업데이트 시작 >>>>>" + master);
						master.put("COMPLETE", "STAND_BY");
						master.put("UPDATEID", loginVO.getId());
						dao.update("prod.manage.toolwarehousing.update.order.status", master);
						System.out.println("발주상태 업데이트 종료 >>>>>" + master);
					} else {
						System.out.println("발주상태 업데이트 시작2 >>>>>" + master);
						master.put("COMPLETE", "COMPLETE");
						master.put("UPDATEID", loginVO.getId());
						dao.update("prod.manage.toolwarehousing.update.order.status", master);
						System.out.println("발주상태 업데이트 종료2 >>>>>" + master);
						
					}
				}
			}

			// 저장시 ajax 성공유무 여부 호출
			boolean isSuccess = false;
			if (errcnt > 0) {
				isSuccess = false;
			} else {
				isSuccess = true;
			}
			params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

	/**
	 * 공구입고관리 상세정보 등록 마스터 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteToolWarehousingMasterList(HashMap<String, Object> params) throws Exception {

		String transno = null;
		try {
			transno = StringUtil.nullConvert(params.get("TransNo"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", loginVO.getId());

			master.put("TRADENO", transno);
			System.out.println("transno No >>>>>>>>>> " + transno);

			int updateResult = dao.delete("prod.manage.toolwarehousingheader.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_TRANS_H fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}

	/**
	 * 공구입고관리  상세정보 등록 내역 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteToolWarehousingDetailList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		System.out.println("deleteToolWarehousingDetailList 3. >>>>>>>>>> " + list.size());
		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			{
				// 재고 트랜잭션 호출
				String orgid = StringUtil.nullConvert(master.get("ORGID"));
				String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
				String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
				String lotno = StringUtil.nullConvert(master.get("CUSTOMERLOT"));
				String trxgubun = "D";
				String trxtype = "공구-입고";
				Integer trxqty = NumberUtil.getInteger(master.get("TRANSQTY"));
				Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
//				String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
				String trxno = StringUtil.nullConvert(master.get("TRANSNO"));
				Integer trxseq = NumberUtil.getInteger(master.get("TRANSSEQ"));
				String trxiud = "DELETE";
				String remarks = StringUtil.nullConvert(master.get("REMARKS"));
				
				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("ITEMCODE", itemcode);
				master.put("LOTNO", lotno);
				master.put("TRXGUBUN", trxgubun);
				master.put("TRXTYPE", trxtype);
				master.put("TRXQTY", trxqty);
				master.put("TRXUNITPRICE", trxunitprice);
//				master.put("TRXWAREHOUSING", trxwarehousing);
				master.put("TRXNO", trxno);
				master.put("TRXSEQ", trxseq);
				master.put("TRXIUD", trxiud);
				master.put("REMARKS", remarks);
				master.put("REGISTID", loginVO.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("공구입고삭제 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("prod.tool.trans.item.transaction.call.procedure", master);
				System.out.println("공구입고삭제 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
			}
			
			master.put("UPDATEID", loginVO.getId());

			int orderqty = 0;
			int transqty = NumberUtil.getInteger(master.get("TRANSQTY"));
			int old_transqty = NumberUtil.getInteger(dao.list("prod.manage.toolwarehousing.old.transqty",master).get(0));
			orderqty = NumberUtil.getInteger(dao.list("prod.manage.toolwarehousing.orderqty",master).get(0));
			
			String pono = StringUtil.nullConvert(master.get("PONO"));
			
			master.put("PONO",pono);
			
			System.out.println("old_transqty >>>>>>>" + old_transqty);
			System.out.println("transqty >>>>>>>" + transqty);
			System.out.println("orderqty >>>>>>>" + orderqty);
			
			
			System.out.println("발주상태 업데이트 시작2 >>>>>" + master);
			master.put("COMPLETE", "STAND_BY");
			master.put("UPDATEID", loginVO.getId());
			dao.update("prod.manage.toolwarehousing.update.order.status", master);
			System.out.println("발주상태 업데이트 종료2 >>>>>" + master);
			
			int deleteResult = dao.update("prod.manage.toolwarehousingdetail.delete", master);
			if (deleteResult == 0) {
				// 삭제 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("DELETE CB_TRANS_D fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}

	/**
	 * 2017.02.22 입하상세정보 화면에서 입하대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> ToolWarehousingRegistPop1List(Map<String, Object> params) throws Exception {

		return dao.list("prod.manage.toolwarehousing.list.pop1.select", params);
	}

	/**
	 * 2017.02.22 입하상세정보 화면에서 입하대기LIST(발주정보) // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int ToolWarehousingRegistPop1TotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.manage.toolwarehousing.list.pop1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	


	/**
	 * 래핑I/F 실적현황 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWrappingIFPerformMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectWrappingIFPerformMasterList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("prod.manage.wrapping.if.perform.list.select", params);
	}

	/**
	 * 래핑I/F 실적현황 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWrappingIFPerformListCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("prod.manage.wrapping.if.perform.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 래핑I/F 실적현황 제품별 집계내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWrappingIFPerformCountList(Map<String, Object> params) throws Exception {
		System.out.println("selectWrappingIFPerformCountList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("prod.manage.wrapping.if.perform.count.select", params);
	}

	/**
	 * 래핑I/F 실적현황 제품별집계내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWrappingIFPerformCountCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("prod.manage.wrapping.if.perform.count.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 래핑I/F 실적현황 상세내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWrappingIFPerformDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectWrappingIFPerformDetailList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("prod.manage.wrapping.if.perform.detail.select", params);
	}

	/**
	 * 래핑I/F 실적현황 상세내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWrappingIFPerformDetailCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("prod.manage.wrapping.if.perform.detail.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
}