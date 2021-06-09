package kr.co.bps.scs.master.company;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : CompanyService.java
 * @Description : Company Service class
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
public class CompanyService extends BaseService {

	// 사업장 SELECT
	public List<?> selectCompanyRegedit(Map<String, Object> params) throws Exception {
		System.out.println("selectCompanyRegedit >>>>>>>>>>");

		return dao.list("company.select", params);
	}

	public int selectCompanyRegeditCount(Map<String, Object> params) throws Exception {
		System.out.println("selectCompanyRegeditCount >>>>>>>>>>");

		List<?> count = dao.list("company.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * company 사업장 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return CompanyService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCompanyRegedit(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("company.insert", master);
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
	 * @return CompanyService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCompanyRegedit(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updatetCompanyRegedit >>>>>>>>>>" + list);
		boolean isSuccess = dao.updateListByIbatis("company.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 사업장 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CompanyService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCompanyRegedit(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("company.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}


}