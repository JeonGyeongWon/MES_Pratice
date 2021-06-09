package kr.co.bps.scs.close;

import java.math.BigDecimal;
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
 * @ClassName : CloseService.java
 * @Description : Close Service class
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
public class CloseService extends BaseService {
	/**
	 * 마감관리 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMonthlyCloseList(Map<String, Object> params) throws Exception {
		System.out.println("selectMonthlyCloseList Start. >>>>>>>>>> " + params);

		List<?> result = null;

		result = dao.list("close.monthly.list.select", params);
		return result;
	}

	/**
	 * 마감관리 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMonthlyCloseCount(HashMap<String, Object> params) throws Exception {
		System.out.println("selectMonthlyCloseCount Start. >>>>>>>>>> " + params);

		int result = 0;

		result = (int) dao.select("close.monthly.list.count", params);
		return result;
	}
	

	/**
	 * 마감관리 데이터를 등록/변경
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMonthlyCloseManage(Map<String, Object> params) throws Exception {
		
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		String msgData = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			
			String gubun = "";
			
			// 등록유무 확인
			List noList = dao.selectListByIbatis("close.monthly.list.find.select", master);
			Map<String, Object> current = (Map<String, Object>) noList.get(0);
			int noCheck = NumberUtil.getInteger(current.get("COUNT"));
			if (noCheck == 0) {
				master.put("REGISTID", login.getId());
				gubun = "I";

				int insertResult = dao.update("close.monthly.list.insert", master);
				if (insertResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_MONTH_CLOSE fail.");
				}
			} else {
				master.put("UPDATEID", login.getId());
				gubun = "U";

				int updateResult = dao.update("close.monthly.list.update", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("UPDATE CB_MONTH_CLOSE fail.");
				}
			}

			String orgid = StringUtil.nullConvert(master.get("ORGID"));
			String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
			String standardmonth = StringUtil.nullConvert(master.get("STANDARDMONTH"));
			
			
			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("STANDARDMONTH", standardmonth);
			master.put("GUBUN", gubun);

			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("마감관리 프로시저 호출 Start. >>>>>>>> ");
			dao.list("close.monthly.manage.call.Procedure", master);
			System.out.println("마감관리 프로시저 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt++;
				msgData = StringUtil.nullConvert(master.get("MSGDATA"));
			} else {
				msgData = "정상적으로 등록/변경하였습니다.";
			}
			
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
//		params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		System.out.println("메시지 확인1. >>>>>>>> " + msgData);
		System.out.println("메시지 확인2. >>>>>>>> " + msgData.length());
		if (msgData.length() > 0) {
			params.put("success", isSuccess);
			params.put("msg", msgData);
		} else {
			params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		}
		
		return params;
	}

}