package kr.co.bps.scs.equipment.manage;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.util.NumberUtil;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : ManageEquipmentService.java
 * @Description : ManageEquipment Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2020. 12.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ManageEquipmentService extends BaseService {

	/**
	 * 설비 관리 > 수리내역 // 그리드 목록을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEquipmentRepairList(Map<String, Object> params) throws Exception {
		System.out.println("selectEquipmentRepairList SERVICE Start. >>>>>>>>>> " + params);

		return dao.list("equipment.manage.repair.list.select", params);
	}

	/**
	 * 설비 관리 > 수리내역 // 그리드 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEquipmentRepairCount(Map<String, Object> params) throws Exception {
		System.out.println("selectEquipmentRepairCount SERVICE Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("equipment.manage.repair.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 설비 관리 > 수리내역 // 그리드 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertEquipmentRepairList(Map<String, Object> params) throws Exception {
		System.out.println("insertEquipmentRepairList SERVICE Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		Integer seqno = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			List seqList = dao.selectListByIbatis("equipment.manage.repair.new.seqno.select", master);
			Map<String, Object> seqMap = (Map<String, Object>) seqList.get(0);
			seqno = NumberUtil.getInteger(seqMap.get("SEQNO"));
			master.put("SEQNO", seqno);

			master.put("REGISTID", login.getId());

			int updateResult = dao.update("equipment.manage.repair.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("INSERT INTO CB_WORK_CENTER_REPAIR fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "insert");
	}

	/**
	 * 설비 관리 > 수리내역 // 그리드 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateEquipmentRepairList(Map<String, Object> params) throws Exception {
		System.out.println("updateEquipmentRepairList SERVICE Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());

			int updateResult = dao.update("equipment.manage.repair.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("UPDATE CB_WORK_CENTER_REPAIR fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 설비 관리 > 수리내역 // 그리드 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteEquipmentRepairList(Map<String, Object> params) throws Exception {
		System.out.println("deleteEquipmentRepairList SERVICE Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			int deleteResult = dao.update("equipment.manage.repair.list.delete", master);
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("DELETE FROM CB_WORK_CENTER fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 설비 수리 이력 현황 마스터 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEquipmentRepairMasterList(Map<String, Object> params) throws Exception {

		System.out.println("selectEquipmentRepairMasterList Start. >>>>>>>>>> " + params);
		return dao.list("equipment.manage.repair.master.list.select", params);
	}

	/**
	 * 설비수리이력현황 마스터 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEquipmentRepairMasterCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("equipment.manage.repair.master.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 설비수리이력현황 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEquipmentRepairLine(Map<String, Object> params) throws Exception {

		System.out.println("selectEquipmentRepairLine Start. >>>>>>>>>> " + params);
		return dao.list("equipment.manage.repair.line.list.select", params);
	}

	/**
	 * 설비수리이력현황 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEquipmentRepairLineCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("equipment.manage.repair.line.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 설비수리이력현황 상세 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEquipmentRepairDetailList(Map<String, Object> params) throws Exception {

		System.out.println("selectEquipmentRepairDetailList params. >>>>>>>>>> " + params);
		return dao.list("equipment.manage.repair.detail.list.select", params);
	}

	/**
	 * 설비수리이력현황 상세 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEquipmentRepairDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("equipment.manage.repair.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	
	/**
	 * 비가동 요약 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectNonOperateMasterList(Map<String, Object> params) throws Exception {

		System.out.println("selectNonOperateMasterList params. >>>>>>>>>> " + params);
		return dao.list("equipment.manage.nonoperate.list.select", params);
	}

	/**
	 * 비가동 요약 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectNonOperateMasterCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("equipment.manage.nonoperate.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
}