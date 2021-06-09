package kr.co.bps.scs.master.spc;

import java.util.ArrayList;
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
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jshwang
 * @since 2017. 11
 * @modify 2017. 11.
 * @version 1.0
 * 
 * 
 */
@Transactional
@Service
public class SpcCalcService extends BaseService {
	
	/**
	 * 관리도 계수 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSpcCalcList(Map<String, Object> params) throws Exception {

		return dao.list("master.spccalc.list.select", params);
	}

	/**
	 * 관리도 계수 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSpcCalcCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("master.spccalc.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 관리도 계수 // 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertSpcCalcList(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		System.out.println("insert params >>>>>>>>>> " + params);

		int errcnt = 0;
		String shipno = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", login.getId());
			
			int updateResult = dao.update("master.spccalc.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SPC_CALC fail.");
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
	 * 관리도 계수 // 데이터 수정
	 * 
	 * @param params - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateSpcCalcList(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		System.out.println("update params >>>>>>>>>> " + params);

		int errcnt = 0;
		String shipno = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());

			System.out.println("update master >>>>>>>>>> " + master);

			int updateResult = dao.update("master.spccalc.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update into CB_SPC_CALC fail.");
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
	 * 관리도 계수 // 데이터 삭제
	 * 
	 * @param params - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteSpcCalcList(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("master.spccalc.list.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}
}