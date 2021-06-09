package kr.co.bps.scs.prod.tool;

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
 * @ClassName : ProdToolService.java
 * @Description : ProdTool Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 07.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ProdToolService extends BaseService {

	/**
	 * 치공구 반출 마스터 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolOutMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectToolOutMasterList Service Start. >>>>>>>>>> " + params);

		return dao.list("prod.tool.out.header.list.select", params);
	}

	/**
	 * 치공구 반출 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolOutMasterCount(HashMap<String, Object> params) {
		System.out.println("selectToolOutMasterCount Service Start. >>>>>>>>>> " + params);
		
		List<?> count = dao.list("prod.tool.out.header.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 치공구 반출 상세 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolOutDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectToolOutDetailList Service Start. >>>>>>>>>> " + params);

		return dao.list("prod.tool.out.detail.list.select", params);
	}

	/**
	 * 치공구 반출 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolOutDetailCount(HashMap<String, Object> params) {
		System.out.println("selectToolOutDetailCount Service Start. >>>>>>>>>> " + params);
		
		List<?> count = dao.list("prod.tool.out.detail.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 치공구 반출 등록
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertToolOutList(HashMap<String, Object> params) throws Exception {
		System.out.println("insertToolOutList Service Start. >>>>>>>>>> " + params);

		String outno = null;
		try {

			String OutNo = StringUtil.nullConvert(params.get("OutNo"));
			if (!OutNo.isEmpty()) {

			} else {
				params.put("FIRSTWORD", "TO");
				List createnoList = dao.selectListByIbatis("prod.tool.new.outno.select", params);
				Map<String, Object> current = (Map<String, Object>) createnoList.get(0);
				params.put("OUTNO", current.get("OUTNO"));
				outno = (String) current.get("OUTNO");
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
		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", loginVO.getId());

			System.out.println("insertToolOutList Service outno. >>>>>>>>>> " + outno);
			master.put("OUTNO", outno);

			int updateResult = dao.update("prod.tool.out.header.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_TOOL_OUT_H fail.");
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
	 * 치공구 반출 상세 데이터 생성
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertToolOutDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertToolOutDetailList Service Start. >>>>>>>>>> ");
		try {
			System.out.println("insertToolOutDetailList 1. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			System.out.println("insertToolOutDetailList 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				master.put("REGISTID", loginVO.getId());
				
				int updateResult = dao.update("prod.tool.out.detail.list.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_TOOL_OUT_D fail.");
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
	 * 치공구 반출 // 마스터 데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateToolOutList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateToolOutList Service Start. >>>>>>>>>> ");
		
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

			int updateResult = dao.update("prod.tool.out.header.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_TOOL_OUT_H fail.");
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
	 * 치공구 반출 마스터 삭제
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteToolOutList(HashMap<String, Object> params) throws Exception {

		System.out.println("deleteToolOutList Service Start. >>>>>>>>>> ");

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			int updateResult = dao.delete("prod.tool.out.header.list.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("DELETE CB_TOOL_OUT_H fail.");
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
	 * 치공구 반출 상세 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateToolOutDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateToolOutDetailList Service Start. >>>>>>>>>> ");
		try {
			System.out.println("updateToolOutDetailList 1. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updateToolOutDetailList 2. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				// 내역 등록유무 확인
				List noList = dao.selectListByIbatis("prod.tool.out.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				int isCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateSalesOrderMasterList isCheck >>>>>>>>>> " + isCheck);
				if (isCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("prod.tool.out.detail.list.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_TOOL_OUT_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("prod.tool.out.detail.list.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_TOOL_OUT_D fail.");
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
	 * 치공구 반출 상세 삭제
	 * 
	 * @param params - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteToolOutDetailList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		try {
			LoginVO loginVO = getLoginVO();
			int errcnt = 0;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);

				int updateResult = dao.update("prod.tool.out.detail.list.delete", detail);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_TOOL_OUT_D fail.");
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

	
	/**
	 * 치공구 반입 마스터 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolInMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectToolInMasterList Service Start. >>>>>>>>>> " + params);

		return dao.list("prod.tool.in.header.list.select", params);
	}

	/**
	 * 치공구 반입 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolInMasterCount(HashMap<String, Object> params) {
		System.out.println("selectToolInMasterCount Service Start. >>>>>>>>>> " + params);
		
		List<?> count = dao.list("prod.tool.in.header.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 치공구 반입 상세 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolInDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectToolInDetailList Service Start. >>>>>>>>>> " + params);

		return dao.list("prod.tool.in.detail.list.select", params);
	}

	/**
	 * 치공구 반입 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolInDetailCount(HashMap<String, Object> params) {
		System.out.println("selectToolInDetailCount Service Start. >>>>>>>>>> " + params);
		
		List<?> count = dao.list("prod.tool.in.detail.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 치공구 반입 등록
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertToolInList(HashMap<String, Object> params) throws Exception {
		System.out.println("insertToolInList Service Start. >>>>>>>>>> " + params);

		String inno = null;
		try {

			String InNo = StringUtil.nullConvert(params.get("InNo"));
			if (!InNo.isEmpty()) {

			} else {
				params.put("FIRSTWORD", "TI");
				List<?> createnoList = dao.selectListByIbatis("prod.tool.new.inno.select", params);
				Map<String, Object> current = (Map<String, Object>) createnoList.get(0);
				params.put("INNO", current.get("INNO"));
				inno = (String) current.get("INNO");
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
		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", loginVO.getId());

			System.out.println("insertToolInList Service inno. >>>>>>>>>> " + inno);
			master.put("INNO", inno);

			int updateResult = dao.update("prod.tool.in.header.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_TOOL_IN_H fail.");
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
	 * 치공구 반입 상세 데이터 생성
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertToolInDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertToolInDetailList Service Start. >>>>>>>>>> ");
		try {
			System.out.println("insertToolInDetailList 1. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");

			LoginVO loginVO = getLoginVO();
			System.out.println("insertToolInDetailList 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				master.put("REGISTID", loginVO.getId());
				
				int updateResult = dao.update("prod.tool.in.detail.list.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_TOOL_IN_D fail.");
				}

				Integer orgid = NumberUtil.getInteger(master.get("ORGID"));
				Integer companyid = NumberUtil.getInteger(master.get("COMPANYID"));
				String outno = String.valueOf(master.get("OUTNO"));
				Integer outseq = NumberUtil.getInteger(master.get("OUTSEQ"));

				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("OUTNO", outno);
				master.put("OUTSEQ", outseq);

				master.put("REGISTID", loginVO.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("치공구반입 등록 > 반출 상태 변경 PROCEDURE 호출 Start. >>>>>>>> " + master);
				dao.list("prod.tool.out..status.update.proc.call.Procedure", master);
				System.out.println("치공구반입 등록 > 반출 상태 변경 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					errcnt += 1;
					throw new Exception("call CB_MFG_PKG.CB_TOOL_OUT_STATUS_U fail.");
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
	 * 치공구 반입 // 마스터 데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateToolInList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateToolInList Service Start. >>>>>>>>>> ");
		
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

			int updateResult = dao.update("prod.tool.in.header.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_TOOL_IN_H fail.");
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
	 * 치공구 반입 마스터 삭제
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteToolInList(HashMap<String, Object> params) throws Exception {

		System.out.println("deleteToolInList Service Start. >>>>>>>>>> ");

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			int updateResult = dao.delete("prod.tool.in.header.list.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("DELETE CB_TOOL_IN_H fail.");
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
	 * 치공구 반입 상세 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateToolInDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateToolInDetailList Service Start. >>>>>>>>>> ");
		try {
			System.out.println("updateToolInDetailList 1. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");

			System.out.println("updateToolInDetailList 2. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				// 내역 등록유무 확인
				List noList = dao.selectListByIbatis("prod.tool.in.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				int isCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateToolInDetailList isCheck >>>>>>>>>> " + isCheck);
				if (isCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("prod.tool.in.detail.list.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_TOOL_IN_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("prod.tool.in.detail.list.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_TOOL_IN_D fail.");
					}
				}

				Integer orgid = NumberUtil.getInteger(master.get("ORGID"));
				Integer companyid = NumberUtil.getInteger(master.get("COMPANYID"));
				String outno = String.valueOf(master.get("OUTNO"));
				Integer outseq = NumberUtil.getInteger(master.get("OUTSEQ"));

				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("OUTNO", outno);
				master.put("OUTSEQ", outseq);

				master.put("REGISTID", loginVO.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("치공구반입 변경 > 반출 상태 변경 PROCEDURE 호출 Start. >>>>>>>> " + master);
				dao.list("prod.tool.out..status.update.proc.call.Procedure", master);
				System.out.println("치공구반입 변경 > 반출 상태 변경 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					errcnt += 1;
					throw new Exception("call CB_MFG_PKG.CB_TOOL_OUT_STATUS_U fail.");
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
	 * 치공구 반입 상세 삭제
	 * 
	 * @param params - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteToolInDetailList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		try {
			LoginVO loginVO = getLoginVO();
			int errcnt = 0;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);

				Integer orgid = NumberUtil.getInteger(detail.get("ORGID"));
				Integer companyid = NumberUtil.getInteger(detail.get("COMPANYID"));
				String outno = String.valueOf(detail.get("OUTNO"));
				Integer outseq = NumberUtil.getInteger(detail.get("OUTSEQ"));

				int updateResult = dao.update("prod.tool.in.detail.list.delete", detail);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_TOOL_IN_D fail.");
				}

				detail.put("ORGID", orgid);
				detail.put("COMPANYID", companyid);
				detail.put("OUTNO", outno);
				detail.put("OUTSEQ", outseq);

				detail.put("REGISTID", loginVO.getId());
				detail.put("RETURNSTATUS", "");
				detail.put("MSGDATA", "");
				System.out.println("치공구반입 삭제 > 반출 상태 삭제 PROCEDURE 호출 Start. >>>>>>>> " + detail);
				dao.list("prod.tool.out..status.update.proc.call.Procedure", detail);
				System.out.println("치공구반입 삭제 > 반출 상태 변경 PROCEDURE 호출 End.  >>>>>>>> " + detail);

				String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					errcnt += 1;
					throw new Exception("call CB_MFG_PKG.CB_TOOL_OUT_STATUS_U fail.");
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

	/**
	 * 치공구 반출/회수 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolInOutList(Map<String, Object> params) throws Exception {
		System.out.println("selectToolInOutList Service Start. >>>>>>>>>> " + params);

		return dao.list("prod.tool.in.out.list.select", params);
	}

	/**
	 * 치공구 반출/회수 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolInOutCount(HashMap<String, Object> params) {
		System.out.println("selectToolInOutCount Service Start. >>>>>>>>>> " + params);
		
		List<?> count = dao.list("prod.tool.in.out.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

}