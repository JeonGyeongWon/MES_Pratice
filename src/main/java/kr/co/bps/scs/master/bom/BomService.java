package kr.co.bps.scs.master.bom;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : BomService.java
 * @Description : Bom Service class
 * @Modification Information
 *
 * Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 12. 
 * @version 1.0
 * @see
 *  
 *
 */
@Transactional
@Service
public class BomService extends BaseService {

	/**
	 * BOM 등록 // 목록 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> BomRegisterList(Map<String, Object> params) throws Exception {
		System.out.println("BomRegisterList >>>>>>>>>> " + params);

		return dao.list("master.bom.list.select", params);
	}

	/**
	 * BOM 등록 // 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int BomRegisterTotCnt(Map<String, Object> params) throws Exception {
		System.out.println("BomRegisterTotCnt >>>>>>>>>> " + params);

		List<?> count = dao.list("master.bom.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * BOM 등록 //  데이터 등록
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertBomRegister(Map<String, Object> params) throws Exception {
		System.out.println("insertBomRegister Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", login.getId());

			int updateResult = dao.update("master.bom.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_BOM fail.");
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
	 * BOM 등록 //  데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateBomRegister(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updateBomRegister >>>>>>>>>> " + list);
		boolean isSuccess = dao.updateListByIbatis("master.bom.list.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * BOM 등록 선택 데이터 삭제
	 * 
	 * @param params - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteBomRegister(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("master.bom.list.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}
}