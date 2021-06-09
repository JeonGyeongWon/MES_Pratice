package kr.co.bps.scs.master.customer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : CustomerService.java
 * @Description : Customer Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 10
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class CustomerService extends BaseService {

	/**
	 * 거래처 목록을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectCustomerList(Map<String, Object> params) throws Exception {
		System.out.println("selectCustomerList Start.  >>>>>>>> " + params);

		return dao.list("customer.list.select", params);
	}

	/**
	 * 거래처 목록 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectCustomerCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("customer.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 조회 부분에 거래처 첫번째 리스트를 출력한다. 
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public String selectCustomerFirstList(HashMap<String, Object> params) {
		String result = null;

		Map<String, Object> FirstListMap = (Map<String, Object>) dao.selectByIbatis("customer.list.firstlist.select", params);
		System.out.println("FirstListMap >>>>>>>>>> " + FirstListMap);

		if (FirstListMap == null) {
			result = null;
		} else {
			String[] customercode = FirstListMap.get("CUSTOMERCODE").toString().split(",");

			result = customercode[0].toString();
		}

		return result;
	}
		
	/**
	 * 거래처 등록
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCustomerManage(HashMap<String, Object> params) throws Exception {

		System.out.println("insertCustomerManage Start. >>>>>>>>> " + params);
		String customercode = null;
		try {
			List customerList = dao.selectListByIbatis("customer.new.code.select", params);
			Map<String, Object> current = (Map<String, Object>) customerList.get(0);
			params.put("CUSTOMERCODE", current.get("CUSTOMERCODE"));
			customercode = (String) current.get("CUSTOMERCODE");
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			LoginVO loginVO = getLoginVO();
			
			master.put("REGISTID", loginVO.getId());

			master.put("CUSTOMERCODE", customercode);
			System.out.println("CUSTOMERCODE >>>>>>>>>> " + customercode);

			int updateResult = dao.update("customer.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_CUSTOMER fail.");
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
	 * 거래처 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCustomerManage(Map<String, Object> params) throws Exception {

		System.out.println("updateCustomerManage params. >>>>>>>>>> " + params);
		boolean isSuccess = false;
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updateCustomerManage >>>>>>>>>> " + list);
		isSuccess = dao.updateListByIbatis("customer.update", list) > 0;

		params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
		return params;
	}
	
	/**
	 * 거래처의 추가정보 목록을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectCustomerMemberList(Map<String, Object> params) throws Exception {
		System.out.println("selectCustomerMemberList Start.  >>>>>>>> " + params);

		return dao.list("customer.member.list.select", params);
	}

	/**
	 * 거래처의 추가정보 목록 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectCustomerMemberTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("customer.member.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 거래처의 추가정보 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCustomerMemberList(HashMap<String, Object> params) throws Exception {

		String memberid = null;
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			LoginVO loginVO = getLoginVO();
			
			List ordernoList = dao.selectListByIbatis("customer.member.memberid.find", master);
			Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
			master.put("MEMBERID", current.get("MEMBERID"));
			master.put("REGISTID", loginVO.getId());

			int updateResult = dao.update("customer.member.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_CUSTOMER_MEMBER fail.");
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
	 * 거래처의 추가정보 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCustomerMemberList(HashMap<String, Object> params) throws Exception {
		System.out.println("updateCustomerMemberList Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			LoginVO loginVO = getLoginVO();

			master.put("UPDATEID", loginVO.getId());

			int updateResult = dao.update("customer.member.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_CUSTOMER_MEMBER fail.");
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
	 * 거래처의 추가정보 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCustomerMemberList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
					
		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			
			LoginVO loginVO = getLoginVO();
			
			master.put("REGISTID", loginVO.getId());
			
			int updateResult = dao.delete("customer.member.list.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_CUSTOMER_MEMBER fail.");
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
}