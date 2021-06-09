package kr.co.bps.scs.order.manage;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.NumberUtil;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : OrderManageService.java
 * @Description : OrderManage Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 10.
 * @version 1.0
 * @see 수주관리
 * 
 * 
 */
@Transactional
@Service
public class OrderManageService extends BaseService {

	@Autowired
	private searchService searchService;
	
	/**
	 * 수주관리의 마스터 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOrderManageStateListMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectOrderManageStateListMasterList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.manage.ordermanagestatelist.master.select", params);
	}

	/**
	 * 수주관리의 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOrderManageStateListMasterListCount(HashMap<String, Object> params) {
		System.out.println("selectOrderManageStateListMasterListCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.manage.ordermanagestatelist.master.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 수주관리의 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOrderManageStateListDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectOrderManageStateListDetailList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.manage.ordermanagestatelist.detail.select", params);
	}

	/**
	 * 수주관리의 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOrderManageStateListDetailCount(HashMap<String, Object> params) {
		System.out.println("selectOrderManageStateListDetailCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.manage.ordermanagestatelist.detail.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 수주등록 // 마스터 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOrderManageStateListMasterList(HashMap<String, Object> params) throws Exception {
		System.out.println("insertOrderManageStateListMasterList Service Start. >>>>>>>>>> " + params);
		String sono = null;
		try {
			// 1. 수주번호 자동채번
			sono = StringUtil.nullConvert(params.get("SoNo"));
			if (sono.isEmpty()) {
				List sonolist = dao.selectListByIbatis("order.manage.ordermanagesono.find", params);
				Map<String, Object> current = (Map<String, Object>) sonolist.get(0);
				params.put("SoNo", current.get("FINDSONO"));
				sono = (String) current.get("FINDSONO");
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

		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			LoginVO loginVO = getLoginVO();

			master.put("REGISTID", loginVO.getId());

			master.put("SoNo", sono);
			System.out.println("insertOrderManageStateListMasterList Master >>>>>>>>>> " + master);
			System.out.println("insertOrderManageStateListMasterList No >>>>>>>>>> " + sono);

			int updateResult = dao.update("order.manage.ordermanagestatelist.master.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SALES_ORDER_H fail.");
			}else{
				
				// 카카오 관련 테이블 등록
				
				String p_org_id = StringUtil.nullConvert(master.get("ORGID"));
				String p_company_id = StringUtil.nullConvert(master.get("COMPANYID"));
				String p_employee = StringUtil.nullConvert(master.get("SalesPersonName")); /*실제 카카오에서 검색될 이름임 EMPLOYEENUBER 가 아님 */
				String p_foreignkey1 = StringUtil.nullConvert(master.get("SoNo"));
				String p_logiin = loginVO.getId();
				
				
//				 <parameter property="P_ORG_ID" jdbcType="VARCHAR" javaType="java.lang.String" mode="IN"/>
//			        <parameter property="P_COMPANY_ID" jdbcType="VARCHAR" javaType="java.lang.String" mode="IN"/>
//			        <parameter property="P_EMPLOYEE" jdbcType="VARCHAR" javaType="java.lang.String" mode="IN"/>
//			        <parameter property="P_FOREIGN_KEY1" jdbcType="VARCHAR" javaType="java.lang.String" mode="IN"/>
//			        <parameter property="P_FOREIGN_KEY2" jdbcType="VARCHAR" javaType="java.lang.String" mode="IN"/>
//			        <parameter property="P_FLAG" jdbcType="VARCHAR" javaType="java.lang.String" mode="IN"/>
//			        <parameter property="P_LOGIN" jdbcType="VARCHAR" javaType="java.lang.String" mode="IN"/>
//			        <parameter property="RS_CODE" jdbcType="VARCHAR" javaType="java.lang.String" mode="OUT"/>
//			        <parameter property="RS_STATUS" jdbcType="VARCHAR" javaType="java.lang.String" mode="OUT"/>
				
				
				master.put("P_ORG_ID",p_org_id);
				master.put("P_COMPANY_ID",p_company_id);
				master.put("P_EMPLOYEE",p_employee);
				master.put("P_FOREIGN_KEY1",p_foreignkey1);
				master.put("P_FOREIGN_KEY2",null);
				master.put("P_FLAG","SUJU");
				master.put("P_LOGIN",p_logiin);
				master.put("RS_CODE", "");
				master.put("RS_STATUS", "");

				System.out.println("카카오 메시지 보내기 프로시저 호출. >>>>>>>> ");
				dao.list("cb_kakao_insert.Procedure", master);
				System.out.println("카카오 메시지 보내기 프로시저 호출 End.  >>>>>>>> " + master);

				String rs_code = StringUtil.nullConvert(params.get("RS_CODE"));
				String rs_status = StringUtil.nullConvert(params.get("RS_STATUS"));
				if (!rs_code.equals("S")) {
					errcnt += 1;
					throw new Exception(rs_status);
				}else{
					searchService.callPython();
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
		return params;
	}

	/**
	 * 수주등록 // 디테일 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOrderManageStateListDetailList(Map<String, Object> params) throws Exception {
		System.out.println("insertOrderManageStateListDetailList Service Start. >>>>>>>>>> ");
		try {
			System.out.println("insertOrderManageStateListDetailList 1. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			Map<String, Object> temp = null;
			String sono = null;
			String orgid = null;
			String companyid = null;
			System.out.println("insertOrderManageStateListDetailList 2. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				master.put("REGISTID", loginVO.getId());

				sono = StringUtil.nullConvert(master.get("SoNo"));
				orgid = StringUtil.nullConvert(master.get("Orgid"));
				companyid = StringUtil.nullConvert(master.get("CompanyId"));

				String duedate = StringUtil.nullConvert(master.get("DUEDATE"));
				String castendplandate = StringUtil.nullConvert(master.get("CASTENDPLANDATE"));
				String workendplandate = StringUtil.nullConvert(master.get("WORKENDPLANDATE"));
				String[] sList1 = duedate.split("T");
				String[] sList2 = castendplandate.split("T");
				String[] sList3 = workendplandate.split("T");

				master.put("SoNo", sono);
				master.put("Orgid", orgid);
				master.put("CompanyId", companyid);
				master.put("DUEDATE", sList1[0]);
				master.put("CASTENDPLANDATE", sList2[0]);
				master.put("WORKENDPLANDATE", sList3[0]);

				int updateResult = dao.update("order.manage.ordermanagestatelist.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_SALES_ORDER_D fail.");
				}
			}
			System.out.println("insertOrderManageStateListDetailList 4. params >>>>>>>>>> " + params);

			// 수주 -> 생산계획 PKG 호출
			if (!sono.isEmpty()) {
				LoginVO login = getLoginVO();
				params.put("SONUM", sono);
				params.put("ORG", orgid);
				params.put("COMP", companyid);
				params.put("UPDATEID", login.getId());
				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");

				System.out.println("insertOrderManageStateListDetailList 6. params >>>>>>>>>> " + params);
				System.out.println("수주 -> 생산계획 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("order.manage.ordermanagestatelist.Procedure", params);
				System.out.println("수주 -> 생산계획 PROCEDURE 호출 End.  >>>>>>>> " + params);

				String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					errcnt += 1;
					throw new Exception("call CB_SO_PKG.CB_PROD_PLAN_PROC fail.");
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
	 * 수주등록 // 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOrderManageStateListMasterList(HashMap<String, Object> params) throws Exception {
		System.out.println("updateOrderManageStateListMasterList Service Start. >>>>>>>>>> " + params);

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

			System.out.println("updateOrderManageStateListMasterList 1. >>>>>>>>>> " + master);

			int updateResult = dao.update("order.manage.ordermanagestatelist.master.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_SALES_ORDER_H fail.");
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
	 * 수주등록 // 디테일 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOrderManageStateListDetailList(HashMap<String, Object> params) throws Exception {
		System.out.println("updateOrderManageStateListDetailList Service Start. >>>>>>>>>> ");

		try {
			System.out.println("updateOrderManageStateListDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updateOrderManageStateListDetailList 2. >>>>>>>>>> " + list.size());
			Map<String, Object> temp = null;
			String sono = null;
			String orgid = null;
			String companyid = null;

			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);
				sono = StringUtil.nullConvert(master.get("SoNo"));
				orgid = StringUtil.nullConvert(master.get("Orgid"));
				companyid = StringUtil.nullConvert(master.get("CompanyId"));

				String duedate = StringUtil.nullConvert(master.get("DUEDATE"));
				String castendplandate = StringUtil.nullConvert(master.get("CASTENDPLANDATE"));
				String workendplandate = StringUtil.nullConvert(master.get("WORKENDPLANDATE"));
				String[] sList1 = duedate.split("T");
				String[] sList2 = castendplandate.split("T");
				String[] sList3 = workendplandate.split("T");

				master.put("SoNo", sono);
				master.put("Orgid", orgid);
				master.put("CompanyId", companyid);

				master.put("DUEDATE", sList1[0]);
				master.put("CASTENDPLANDATE", sList2[0]);
				master.put("WORKENDPLANDATE", sList3[0]);

				LoginVO loginVO = getLoginVO();
				System.out.println("1. updateOrderManageStateListDetailList master >>>>>>>>>> " + master);
				// porno 등록유무 확인
				List sonoList = dao.selectListByIbatis("order.manage.ordermanagesoseq.find", master);
				Map<String, Object> current = (Map<String, Object>) sonoList.get(0);
				int soCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateOrderManageStateListDetailList soCheck >>>>>>>>>> " + soCheck);
				if (soCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("order.manage.ordermanagestatelist.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_SALES_ORDER_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("order.manage.ordermanagestatelist.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_PURCHASE_D fail.");
					}
				}
			}
			System.out.println("updateOrderManageStateListDetailList 4. params >>>>>>>>>> " + params);

			// 수주 -> 생산계획 PKG 호출
			if (!sono.isEmpty()) {
				LoginVO login = getLoginVO();
				params.put("SONUM", sono);
				params.put("ORG", orgid);
				params.put("COMP", companyid);
				params.put("UPDATEID", login.getId());
				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");

				System.out.println("updateOrderManageStateListDetailList 6. params >>>>>>>>>> " + params);
				System.out.println("수주 -> 생산계획 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("order.manage.ordermanagestatelist.Procedure", params);
				System.out.println("수주 -> 생산계획 PROCEDURE 호출 End.  >>>>>>>> " + params);

				String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					errcnt += 1;
					throw new Exception("call CB_SO_PKG.CB_PROD_PLAN_PROC fail.");
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
	 * 수주등록 // 마스터 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOrderManageStateListMasterList(Map<String, Object> params) throws Exception {
		System.out.println("deleteOrderManageStateListMasterList Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		boolean isSuccess = dao.deleteListByIbatis("order.manage.ordermanagestatelist.master.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 수주등록 // 디테일 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOrderManageStateListDetailList(HashMap<String, Object> params) throws Exception {
		System.out.println("deleteOrderManageStateListDetailList Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		int errcnt = 0;
		LoginVO login = getLoginVO();
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			
			int soseq = NumberUtil.getInteger(master.get("SOSEQ"));
			master.put("UPDATEID", login.getId());
			master.put("SOSEQ", soseq);
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("수주 -> 생산계획 삭제 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("order.manage.prodplan.delete.Procedure", master);
			System.out.println("수주 -> 생산계획 삭제 PROCEDURE 호출 End. >>>>>>>> " + master);
			String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				// "E" -> 해당작지가 존재함, "S" -> 생산계획 삭제완료
			} else {
				int updateResult = dao.delete("order.manage.ordermanagestatelist.detail.delete", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_SALES_ORDER_D fail.");
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
		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}

	/**
	 * 수주현황조회 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOrderStateList(Map<String, Object> params) throws Exception {
		System.out.println("selectOrderStateList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.manage.orderstatelist.select", params);
	}

	/**
	 * 수주현황조회 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOrderStateListCount(HashMap<String, Object> params) {
		System.out.println("selectOrderStateListCount Service Start. >>>>>>>>>> " + params);
		List<?> count = dao.list("order.manage.orderstatelist.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 수주 파일 업로드 // 파일 업로드 데이터 등록
	 * 
	 * @param params
	 *            - 등록 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> uploadOrderStateList(List<Object> list, String sourcecd) throws Exception {
		System.out.println("uploadOrderStateList Service Start. >>>>>>>>>> " + list);
		Map<String, Object> result = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			return super.getExtGridResultMap(false, "insert");
		}
		int totcnt = list.size();
		int failCnt = 0;

		HashMap<String, Object> params = new HashMap<String, Object>();
		LoginVO loVo = getLoginVO();
		String orgid = null, companyid = null;
		try {
			// 1. 사업장, 공장 자동 부여
			params.put("USERID", loVo.getId());
			List<?> userList = dao.list("search.login.lov.select", params);

			if (userList.size() > 0) {
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				orgid = StringUtil.nullConvert(userData.get("ORGID"));
				companyid = StringUtil.nullConvert(userData.get("COMPANYID"));

				if (orgid.isEmpty()) {
					orgid = 1 + "";
				}

				if (companyid.isEmpty()) {
					companyid = 1 + "";
				}
			} else {
				orgid = 1 + "";
				companyid = 1 + "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 에러실패 체크 시작
		int forCount = 0;
		String NameTemp = "";
		for (int i = 0; i < list.size(); i++) {
			if (forCount >= 5) {
				break;
			}
			Map<String, Object> CheckListMap = (Map<String, Object>) list.get(i);
			HashMap<String, Object> tempMap = new HashMap<String, Object>();

			String customerName = StringUtil.nullConvert(CheckListMap.get("CUSTOMERNAME"));
			String orderName = StringUtil.nullConvert(CheckListMap.get("ORDERNAME")).replace(".0", "");
			String drawingNo = StringUtil.nullConvert(CheckListMap.get("DRAWINGNO")).replace(".0", "");
			String itemName = StringUtil.nullConvert(CheckListMap.get("ITEMNAME"));
			String soQty = StringUtil.nullConvert(CheckListMap.get("SOQTY")).replace(".0", "");
			String soDate = StringUtil.nullConvert(CheckListMap.get("SODATE")).replace(".", "").replace("E7", "");

			if (customerName.length() == 0 || orderName.length() == 0 || soQty.length() == 0 || soDate.length() == 0) {
				NameTemp += "<br/>" + (i + 1) + "번째 라인의 ";
				forCount++;
			}
			String tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
			if (customerName.isEmpty()) {
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "거래처" : ", 거래처");
			}
			if (orderName.isEmpty() && drawingNo.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "품번" : ", 품번");
			}
			if (soQty.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "수주수량" : ", 수주수량");
			}
			if (soDate.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "수주일자" : ", 수주일자");
			}
			tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
			NameTemp += tempdata;
		}
		System.out.println("uploadOrderStateList NameTemp. >>>>>>>>>>" + NameTemp);
		// 에러실패 체크 끝

		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> excelMap = (Map<String, Object>) list.get(i);
			HashMap<String, Object> tempMap = new HashMap<String, Object>();
			excelMap.put("REGISTID", loVo.getId());

			try {
				excelMap.put("ORGID", orgid);
				tempMap.put("ORGID", orgid);
				System.out.println("uploadOrderStateList orgid. >>>>>>>>>>" + orgid);

				excelMap.put("COMPANYID", companyid);
				tempMap.put("COMPANYID", companyid);
				System.out.println("uploadOrderStateList companyid. >>>>>>>>>>" + companyid);

				String CustomerName = null, OrderName = null, DrawingNo = null, ItemName = null, CustomerOrder = null,
						CustomerOrderSeq = null, SoDate = null, DueDate = null;
				BigDecimal SoQty = null;
				// 2. 거래처
				CustomerName = StringUtil.nullConvert(excelMap.get("CUSTOMERNAME").toString());
				if (!CustomerName.isEmpty()) {

					tempMap.put("CUSTOMERNAME2", CustomerName);
					tempMap.put("CUSTOMERTYPE1", "S");
					List CustomerList = dao.selectListByIbatis("search.customer.name.lov.select", tempMap);
					System.out.println("uploadOrderStateList CustomerList. >>>>>>>>>>" + CustomerList.size());
					if ( CustomerList.size() == 0 ) {
						failCnt++;
						NameTemp += "<br/>" + (i + 1) + "번째 라인의 거래처";
					} else {
						Map<String, Object> CustomerMap = (Map<String, Object>) CustomerList.get(0);
						CustomerName = StringUtil.nullConvert(CustomerMap.get("LABEL"));

						excelMap.put("CUSTOMERNAME", CustomerName);
					}
				}
				System.out.println("uploadOrderStateList CustomerName. >>>>>>>>>>" + CustomerName);

				// 4. 품번
				OrderName = StringUtil.nullConvert(excelMap.get("ORDERNAME").toString()).replace(".0", "");
				if (!OrderName.isEmpty()) {
					// tempMap.put("ORDERNAME", OrderName); // .0 삭제

					tempMap.put("ORDERNAME2", OrderName);
					List OrderList = dao.selectListByIbatis("search.item.name.lov.select", tempMap);
					System.out.println("uploadOrderStateList OrderList. >>>>>>>>>>" + OrderList.size());
					if ( OrderList.size() == 0 ) {
						failCnt++; 
						NameTemp += "<br/>" + (i + 1) + "번째 라인의 품번&품명";
					} else {
						Map<String, Object> OrderMap = (Map<String, Object>) OrderList.get(0);
						OrderName = StringUtil.nullConvert(OrderMap.get("ORDERNAME"));

						excelMap.put("ORDERNAME", OrderName);
					}
				}
				System.out.println("uploadOrderStateList OrderName. >>>>>>>>>>" + OrderName);

				try {
					// 5. 도번
					DrawingNo = StringUtil.nullConvert(excelMap.get("DRAWINGNO").toString()).replace(".0", "");
					if (!DrawingNo.isEmpty()) {
						tempMap.put("DRAWINGNO", DrawingNo); // .0 삭제
					}
					System.out.println("uploadDrawingStateList DrawingNo. >>>>>>>>>>" + DrawingNo);

					// 6. 거래처 발주번호
					CustomerOrder = StringUtil.nullConvert(excelMap.get("CUSTOMERORDER").toString());
					if (!CustomerOrder.isEmpty()) {
						System.out.println("uploadOrderStateList CustomerOrder. >>>>>>>>>>" + CustomerOrder);
						excelMap.put("CUSTOMERORDER", CustomerOrder);
					}
					System.out.println("uploadOrderStateList CustomerOrder. >>>>>>>>>>" + CustomerOrder);

					// 7. 거래처 발주순번
					CustomerOrderSeq = StringUtil.nullConvert(excelMap.get("CUSTOMERORDERSEQ").toString());
					System.out.println("uploadOrderStateList CustomerOrderSeq. >>>>>>>>>>" + CustomerOrderSeq);
					if (!CustomerOrderSeq.isEmpty()) {
						excelMap.put("CUSTOMERORDERSEQ", CustomerOrderSeq);
					} else {
						excelMap.put("CUSTOMERORDERSEQ", "");
					}
					System.out.println("uploadOrderStateList CustomerOrderSeq. >>>>>>>>>>" + CustomerOrderSeq);

				} catch (Exception e) {

				}

				// 8. 수주수량
				SoQty = NumberUtil.getBigDecimal(excelMap.get("SOQTY")).setScale(0, BigDecimal.ROUND_FLOOR);
				System.out.println("uploadOrderStateList SoQty. >>>>>>>>>>" + SoQty);
				excelMap.put("SOQTY", SoQty);

				// 9. 수주일자
				SoDate = StringUtil.nullConvert(excelMap.get("SODATE").toString()).replace(".", "").replace("E7", "");
				System.out.println("uploadOrderStateList SoDate. >>>>>>>>>>" + SoDate);
				if (!SoDate.isEmpty()) {
					excelMap.put("SODATE", SoDate);
				}

				// 10. 납기일자
				DueDate = StringUtil.nullConvert(excelMap.get("DUEDATE").toString()).replace(".", "").replace("E7", "");
				System.out.println("uploadOrderStateList DueDate. >>>>>>>>>>" + StringUtil.nullConvert(excelMap.get("DUEDATE").toString()));
				System.out.println("uploadOrderStateList DueDate. >>>>>>>>>>" + DueDate);
				if (!DueDate.isEmpty()) {
					excelMap.put("DUEDATE", DueDate);
				}

				// 필수 항목이 입력되지 않으면 실패 처리
				// 수주수량, 수주일자 체크
				if (/*SoQty.length() == 0 || */SoDate.length() == 0) {
					failCnt++;
					// list.remove(i);
					// i--;
				}
			} catch (Exception e) {
				failCnt++;
				// list.remove(i);
				// i--;
			}
		}

		try {
			List chkList = dao.selectListByIbatis("excel.so.find.select", null);
			Map<String, Object> current = (Map<String, Object>) chkList.get(0);
			int isCheck = NumberUtil.getInteger(current.get("COUNT"));

			System.out.println("2. uploadOrderStateList isCheck >>>>>>>>>> " + isCheck);
			if (isCheck > 0) {
				System.out.println("uploadOrderStateList DELETE Start. >>>>>>>>>>");
				// 엑셀 TEMP 삭제
				int deleteResult = dao.delete("excel.so.delete", null);
				if (deleteResult == 0) {
					// 저장 실패시 띄우는 예외처리
					throw new Exception("delete CB_SALES_ORDER_TEMP fail.");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		List<Object> uploadlist = dao.insertListByIbatis("excel.so.insert", list);
		StringBuffer sbMsg = new StringBuffer();
		sbMsg.append("총 " + totcnt + " 건 중");
		sbMsg.append("<br/>생성 성공 : " + (uploadlist.size() - failCnt)  + "건");
		sbMsg.append("<br/>생성 실패 : " + failCnt + "건");
		if (!NameTemp.equals("") ) {
			sbMsg.append("<br/><br/>실패 요인 : " + NameTemp + " 항목을 확인해 주세요.");
		}
//		if (NameTemp.length() > 0) {
//			sbMsg.append("<br/><br/>실패 요인 : " + NameTemp + " 항목을 확인해 주세요.");
//		}
		System.out.println("uploadOrderStateList NameTemp >>>>>>>>>>" + NameTemp);
		System.out.println("uploadOrderStateList sbMsg >>>>>>>>>>" + sbMsg);

		if (failCnt == 0) {
			try {
				// 수주 UPLOAD PKG 호출
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
				params.put("REGISTID", loVo.getId());

				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");
				System.out.println("수주 UPLOAD PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("excel.so.upload.call.Procedure", params);
				System.out.println("수주 UPLOAD PROCEDURE 호출 End.  >>>>>>>> " + params);

				String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					String errMsg = StringUtil.nullConvert(params.get("MSGDATA"));
					sbMsg.append("<br/>오류메시지 : " + errMsg);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		result.put("successCnt", uploadlist.size());
		result.putAll(super.getExtGridResultMap(uploadlist.size() > 0, "insert", sbMsg.toString()));
		return result;
	}

	/**
	 * 단가적용 // 프로시저 호출
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> callUnitPriceManage(HashMap<String, Object> params) throws Exception {
		System.out.println("callUnitPriceManage SERVICE Start. >>>>>>>>>> ");
		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		String msgData = null;
		try {
			List<Object> list = super.getGridData(params);
			if (list == null || list.size() == 0) {
				super.setUpdateParams(params);
				list = new ArrayList<Object>();
				list.add(params);
			}

			System.out.println("callUnitPriceManage 2. >>>>>>>>>> " + list.size());
			try {
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> master = (Map<String, Object>) list.get(i);
					
					String orgid = StringUtil.nullConvert(master.get("ORGID"));
					String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
					String sono = StringUtil.nullConvert(master.get("SONO"));
					String soseq = StringUtil.nullConvert(master.get("SOSEQ"));
					String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
					
					master.put("ORGID", orgid);
					master.put("COMPANYID", companyid);
					master.put("SONO", sono);
					master.put("SOSEQ", soseq);
					master.put("ITEMCODE", itemcode);

					master.put("REGISTID", loginVO.getId());
					master.put("RETURNSTATUS", "");
					master.put("MSGDATA", "");
					System.out.println("단가 적용 프로시저 호출 Start. >>>>>>>> ");
					dao.list("order.manage.unitprice.call.Procedure", master);
					System.out.println("단가 적용 프로시저 호출 End.  >>>>>>>> " + master);

					String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt++;
						msgData = StringUtil.nullConvert(master.get("MSGDATA"));
					} else {
						msgData = "정상적으로 적용하였습니다.";
					}
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
			
			// 저장시 ajax 성공유무 여부 호출
			boolean isSuccess = false;
			if (errcnt > 0) {
				isSuccess = false;
			} else {
				isSuccess = true;
			}
			System.out.println("메시지 확인1. >>>>>>>> " + msgData);
			System.out.println("메시지 확인2. >>>>>>>> " + msgData.length());
			if (msgData.length() > 0) {
				params.put("success", isSuccess);
				params.put("msg", msgData);
			} else {
				params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

}