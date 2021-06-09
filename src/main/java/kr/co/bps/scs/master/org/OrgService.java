package kr.co.bps.scs.master.org;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : OrgService.java
 * @Description : Org Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author sjmun
 * @since 2016.12
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class OrgService extends BaseService {

	// 사업장 SELECT
	public List<?> selectOrgRegedit(Map<String, Object> params) throws Exception {
		System.out.println("selectOrgRegedit >>>>>>>>>>");

		return dao.list("org.select", params);
	}

	public int selectOrgRegeditCount(Map<String, Object> params) throws Exception {
		System.out.println("selectOrgRegeditCount >>>>>>>>>>");

		List<?> count = dao.list("org.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * org 사업장 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return OrgService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOrgRegedit(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", login.getId());

			int updateResult = dao.update("org.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update into item fail.");
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
	 * 시ㅏ업장 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return OrgService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOrgRegedit(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updatetOrgRegedit >>>>>>>>>>" + list);
		boolean isSuccess = dao.updateListByIbatis("org.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 사업장 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return OrgService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOrgRegedit(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("org.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}


}