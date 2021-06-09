package kr.co.bps.scs.dist.mat;

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
 * @ClassName : DistMatService.java
 * @Description : DistMat Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 12.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class DistMatService extends BaseService {

	//	여기부터 입하등록 조회 화면
	/**
	 * 조회 부분에 입하등록현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDistMatList(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.list.select", params);
	}

	/**
	 * 조회 부분에 입하등록현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDistMatCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 입하등록상세현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDistMatDetailList(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.detaillist.select", params);
	}

	/**
	 * 조회 부분에 자재요청상세현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDistMatDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.detaillist.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 2016.12.16 입하등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertMatTransMasterList(HashMap<String, Object> params) throws Exception {

		String transno = null;
		try {
			String TransNo = StringUtil.nullConvert(params.get("TransNo"));
			if (TransNo.isEmpty()) {
				List ordernoList = dao.selectListByIbatis("dist.new.transno.select", params);
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

			int updateResult = dao.update("dist.mat.header.insert", master);
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
	 * 입하등록 그리드 데이터 insert
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertMatTransDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertMatTransDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("insertMatTransDetailList 1. >>>>>>>>>> " + params.get("data"));
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
					String trxtype = "자재-입하";
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
					System.out.println("입하등록 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("dist.trans.item.transaction.call.procedure", master);
					System.out.println("입하등록 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
					
					
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
					if ((transqty + old_transqty) >= orderqty) {
						System.out.println("발주상태 업데이트 시작 >>>>>" + master);
						master.put("COMPLETE", "COMPLETE");
						master.put("UPDATEID", loginVO.getId());
						dao.update("dist.trans.update.order.status", master);
						System.out.println("발주상태 업데이트 종료 >>>>>" + master);
					}
				}
				
				master.put("REGISTID", loginVO.getId());
				master.put("REQCONFIRMQTY", "0");
				master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

				int updateResult = dao.update("dist.mat.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("INSERT INTO CB_TRANS_D fail.");
				}
				
				if(i==SIZE-1){
					int postatus=0, old_status=0;
					postatus = NumberUtil.getInteger(dao.list("dist.trans.count.order.status",master).get(0));
					old_status = NumberUtil.getInteger(dao.list("dist.trans.count.trans.status",master).get(0));
					
					System.out.println("postatus >>>>>>>" + postatus);
					System.out.println("old_status >>>>>>>" + old_status);
					if (postatus > old_status) {
						System.out.println("발주상태 업데이트 시작 >>>>>" + master);
						master.put("COMPLETE", "STAND_BY");
						master.put("UPDATEID", loginVO.getId());
						dao.update("dist.trans.update.order.status", master);
						System.out.println("발주상태 업데이트 종료 >>>>>" + master);
					} else {
						System.out.println("발주상태 업데이트 시작2 >>>>>" + master);
						master.put("COMPLETE", "COMPLETE");
						master.put("UPDATEID", loginVO.getId());
						dao.update("dist.trans.update.order.status", master);
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
	 * 2016.12.19 입하 상세정보 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMatTransMasterList(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.update("dist.mat.header.update", master);
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
	 * 2016.12.19 입하상세정보 그리드 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMatTransDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateMatTransDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("updateMatTransDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();
			int transqty = 0;
			int old_transqty = 0;

			System.out.println("updateMatTransDetailList 3. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				// porno 등록유무 확인
				List pornoList = dao.selectListByIbatis("dist.mat.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
				int poCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateMatTransDetailList poCheck >>>>>>>>>> " + poCheck);
				if (poCheck == 0) {
					// 생성
					{
						// 재고 트랜잭션 호출
						String orgid = StringUtil.nullConvert(master.get("ORGID"));
						String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
						String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
						String lotno = StringUtil.nullConvert(master.get("CUSTOMERLOT"));
						String trxgubun = "I";
						String trxtype = "자재-입하";
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
						System.out.println("입하등록 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("dist.trans.item.transaction.call.procedure", master);
						System.out.println("입하등록 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
						
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

					int updateResult = dao.update("dist.mat.detail.insert", master);
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
						String trxtype = "자재-입하";
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
						System.out.println("입하변경 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("dist.trans.item.transaction.call.procedure", master);
						System.out.println("입하변경 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
					}
					
					master.put("UPDATEID", loginVO.getId());
					
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
					
					int updateResult = dao.update("dist.mat.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_TRANS_D fail.");
					}
				}
				
				if(i==SIZE-1){
					int postatus=0, old_status=0;
					postatus = NumberUtil.getInteger(dao.list("dist.trans.count.order.status",master).get(0));
					old_status = NumberUtil.getInteger(dao.list("dist.trans.count.trans.status",master).get(0));
					
					System.out.println("postatus >>>>>>>" + postatus);
					System.out.println("old_status >>>>>>>" + old_status);
					if (postatus > old_status) {
						System.out.println("발주상태 업데이트 시작 >>>>>" + master);
						master.put("COMPLETE", "STAND_BY");
						master.put("UPDATEID", loginVO.getId());
						dao.update("dist.trans.update.order.status", master);
						System.out.println("발주상태 업데이트 종료 >>>>>" + master);
					} else {
						System.out.println("발주상태 업데이트 시작2 >>>>>" + master);
						master.put("COMPLETE", "COMPLETE");
						master.put("UPDATEID", loginVO.getId());
						dao.update("dist.trans.update.order.status", master);
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
	 * 2016.12.19 입하 상세정보 등록 마스터 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteMatTransMasterList(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.delete("dist.mat.header.delete", master);
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
	 * 2016.12.19 입하 상세정보 등록 내역 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteMatTransDetailList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		System.out.println("deleteMatTransDetailList 3. >>>>>>>>>> " + list.size());
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
				String trxtype = "자재-입하";
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
				System.out.println("입하삭제 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("dist.trans.item.transaction.call.procedure", master);
				System.out.println("입하삭제 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
			}
			
			master.put("UPDATEID", loginVO.getId());

			int orderqty = 0;
			int transqty = NumberUtil.getInteger(master.get("TRANSQTY"));
			int old_transqty = NumberUtil.getInteger(dao.list("dist.trans.old.transqty",master).get(0));
			orderqty = NumberUtil.getInteger(dao.list("dist.trans.orderqty",master).get(0));
			
			String pono = StringUtil.nullConvert(master.get("PONO"));
			
			master.put("PONO",pono);
			
			System.out.println("old_transqty >>>>>>>" + old_transqty);
			System.out.println("transqty >>>>>>>" + transqty);
			System.out.println("orderqty >>>>>>>" + orderqty);
			
			
			System.out.println("발주상태 업데이트 시작2 >>>>>" + master);
			master.put("COMPLETE", "STAND_BY");
			master.put("UPDATEID", loginVO.getId());
			dao.update("dist.trans.update.order.status", master);
			System.out.println("발주상태 업데이트 종료2 >>>>>" + master);
			
			int deleteResult = dao.update("dist.mat.detail.delete", master);
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
	 * 조달관리 > 자재관리 > 기타입출고 // Master 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatEtcRelList(Map<String, Object> params) throws Exception {
		System.out.println("selectMatEtcRelList Start. >>>>>>>>>> " + params);

		return dao.list("dist.mat.release.master.list.select", params);
	}

	/**
	 * 조달관리 > 자재관리 > 기타입출고 // Master 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatEtcRelCount(HashMap<String, Object> reqMap) {
		System.out.println("selectMatEtcRelCount Start. >>>>>>>>>> " + reqMap);
		List<?> count = dao.list("dist.mat.release.master.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/** 2017.04.04
	 * 조달관리 > 자재관리 > 생산출고(부자재) // Master 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatEtcRel2List(Map<String, Object> params) throws Exception {
		System.out.println("selectMatEtcRelList Start. >>>>>>>>>> " + params);

		return dao.list("dist.mat.release.master.list.select", params);
	}

	/**2017.04.04
	 * 조달관리 > 자재관리 > 생산출고(부자재) // Master 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatEtcRel2Count(HashMap<String, Object> reqMap) {
		System.out.println("selectMatEtcRelCount Start. >>>>>>>>>> " + reqMap);
		List<?> count = dao.list("dist.mat.release.master.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조달관리 > 자재관리 > 기타입출고 // 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatEtcRelDetailList(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.release.detail.list.select", params);
	}

	/**
	 * 조달관리 > 자재관리 > 기타입출고 // 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatEtcRelDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.release.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/** 2017.04.04
	 * 조달관리 > 자재관리 > 생산출고(부자재) // 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatEtcRelDetail2List(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.release.detail.list.select", params);
	}

	/**2017.04.04
	 * 조달관리 > 자재관리 > 생산출고(부자재) // 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatEtcRelDetail2Count(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.release.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	/**
	 * 기타입출고 / 이동출고 // Grid 마스터 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteMatRelManage(HashMap<String, Object> params) throws Exception {

		String relno = null;
		try {
			relno = StringUtil.nullConvert(params.get("RelNo"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("RELNO", relno);

			System.out.println("Release No >>>>>>>>>> " + relno);

			int deleteResult = dao.delete("dist.mat.release.header.delete", master);
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_RELEASE_H fail.");
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
	 * 기타입출고 / 이동출고 // Grid 상세 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteMatRelListDetail(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("dist.mat.release.detail.delete", list) > 0;

		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 기타입출고 / 이동출고
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertMatRelMasterList(HashMap<String, Object> params) throws Exception {

		String relno = null;
		try {
			String RelNo = StringUtil.nullConvert(params.get("RelNo"));
			if (!RelNo.isEmpty()) {
				relno = RelNo;
			} else {
				//2017.01.12 화면상으로 보이는 기타입고/출고 값
				String usediv1 = StringUtil.nullConvert(params.get("UseDivTemp"));
				String usediv = StringUtil.nullConvert(params.get("UseDiv"));
				System.out.println("usediv1  . >>>>>>>>>> " + usediv1);
				System.out.println("usediv  . >>>>>>>>>> " + usediv);
				if (usediv1.equals("E") || usediv1.equals("EP")) {
					System.out.println("1 usediv1  . >>>>>>>>>> " + usediv1);
					System.out.println("1 usediv  . >>>>>>>>>> " + usediv);
					usediv = StringUtil.nullConvert(params.get("UseDiv"));
				} else {
					System.out.println("2 usediv1  . >>>>>>>>>> " + usediv1);
					System.out.println("2 usediv  . >>>>>>>>>> " + usediv);
					if ( !usediv.equals("FP")) {
						usediv = usediv1;
					}
				}
				params.put("USEDIV", usediv);
				List relnoList = dao.selectListByIbatis("dist.mat.release.new.relno.select", params);
				Map<String, Object> current = (Map<String, Object>) relnoList.get(0);
				params.put("RELNO", current.get("RELNO"));
				relno = (String) current.get("RELNO");
			}
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

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", loginVO.getId());

			master.put("RELEASESTATUS", "STAND_BY");
			master.put("RELNO", relno);
			System.out.println("Release No >>>>>>>>>> " + relno);

			int updateResult = dao.update("dist.mat.release.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_RELEASE_H fail.");
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
	 * 기타입출고 상세 데이터 생성
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertMatRelDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertMatRelDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("insertMatRelDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			String relNo = "";
			String orgId = "";
			String companyId = "";
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				{
					// 재고 트랜잭션 호출
					String orgid = StringUtil.nullConvert(master.get("ORGID"));
					orgId = StringUtil.nullConvert(master.get("ORGID"));
					System.out.println("insertMatRelDetailList orgid >>>>>>>>>> " + orgid);
					String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
					companyId = StringUtil.nullConvert(master.get("COMPANYID"));
					System.out.println("insertMatRelDetailList companyid >>>>>>>>>> " + companyid);
					String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
					System.out.println("insertMatRelDetailList itemcode >>>>>>>>>> " + itemcode);
//					String lotno = StringUtil.nullConvert(master.get("LOTNO"));
					String trxgubun = "I";
					String trxno = StringUtil.nullConvert(master.get("RELEASENO"));
					relNo = StringUtil.nullConvert(master.get("RELEASENO"));
					boolean firstchk = (trxno.startsWith("EP") || trxno.startsWith("FP"));
					String firstname = (( firstchk ) ? "제품" : "자재");
					System.out.println("insertMatRelDetailList firstname >>>>>>>>>> " + firstname);
					String trxtype = firstname + "-기타입출고";
					System.out.println("insertMatRelDetailList trxtype >>>>>>>>>> " + trxtype);
					Integer trxqty = NumberUtil.getInteger(master.get("RELEASEQTY"));
					System.out.println("insertMatRelDetailList trxqty >>>>>>>>>> " + trxqty);
//					Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
//					String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
					Integer trxseq = NumberUtil.getInteger(master.get("RELEASESEQ"));
					System.out.println("insertMatRelDetailList trxseq >>>>>>>>>> " + trxseq);
					String trxiud = "INSERT";
					String remarks = StringUtil.nullConvert(master.get("REMARKS"));
					
					master.put("ORGID", orgid);
					master.put("COMPANYID", companyid);
					master.put("ITEMCODE", itemcode);
//					master.put("LOTNO", lotno);
					master.put("TRXGUBUN", trxgubun);
					master.put("TRXTYPE", trxtype);
					master.put("TRXQTY", trxqty);
//					master.put("TRXUNITPRICE", trxunitprice);
//					master.put("TRXWAREHOUSING", trxwarehousing);
					master.put("TRXNO", trxno);
					master.put("TRXSEQ", trxseq);
					master.put("TRXIUD", trxiud);
					master.put("REMARKS", remarks);
					master.put("REGISTID", loginVO.getId());
					master.put("RETURNSTATUS", "");
					master.put("MSGDATA", "");
					System.out.println(firstname + "-기타입출고등록 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("dist.etc.item.transaction.call.procedure", master);
					System.out.println(firstname + "-기타입출고등록 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
				}
				
				master.put("REGISTID", loginVO.getId());

				int updateResult = dao.update("dist.mat.release.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_RELEASE_D fail.");
				}
			}
			String orgid = orgId;
			String companyid = companyId;
			String relno = relNo;
			if(relno.startsWith("EP")){
				// 제품입고시만 패키지 태움
				LoginVO login = getLoginVO();				
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
				params.put("RELNO", relno);
				params.put("REGISTID", login.getId());
				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");				
				System.out.println("입고등록 PROCEDURE 호출 Start. >>>>>>>> "+ params);
				dao.list("order.prod.prodrelwarehcreate.Procedure", params);
				System.out.println("입고등록 PROCEDURE 호출 End.  >>>>>>>> " + params);
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
	 * 기타입출고 / 이동출고 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMatRelMasterList(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.update("dist.mat.release.header.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_RELEASE_H fail.");
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
	 * 기타입출고 / 이동출고 상세 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMatRelDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateMatRelDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("updateMatRelDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				// 등록유무 확인
				List relnoList = dao.selectListByIbatis("dist.mat.release.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) relnoList.get(0);
				int roCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateMatRelDetailList roCheck >>>>>>>>>> " + roCheck);
				if (roCheck == 0) {
					// 생성
					{
						// 재고 트랜잭션 호출
						String orgid = StringUtil.nullConvert(master.get("ORGID"));
						System.out.println("updateMatRelDetailList orgid >>>>>>>>>> " + orgid);
						String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
						System.out.println("updateMatRelDetailList companyid >>>>>>>>>> " + companyid);
						String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
						System.out.println("updateMatRelDetailList itemcode >>>>>>>>>> " + itemcode);
//						String lotno = StringUtil.nullConvert(master.get("LOTNO"));
						String trxgubun = "I";
						String trxno = StringUtil.nullConvert(master.get("RELEASENO"));
						boolean firstchk = (trxno.startsWith("EP") || trxno.startsWith("FP"));
						String firstname = (( firstchk ) ? "제품" : "자재");
						System.out.println("updateMatRelDetailList firstname >>>>>>>>>> " + firstname);
						String trxtype = firstname + "-기타입출고";
						System.out.println("insertMatRelDetailList trxtype >>>>>>>>>> " + trxtype);
						Integer trxqty = NumberUtil.getInteger(master.get("RELEASEQTY"));
						System.out.println("updateMatRelDetailList trxqty >>>>>>>>>> " + trxqty);
//						Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
//						String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
						Integer trxseq = NumberUtil.getInteger(master.get("RELEASESEQ"));
						System.out.println("updateMatRelDetailList trxseq >>>>>>>>>> " + trxseq);
						String trxiud = "INSERT";
						String remarks = StringUtil.nullConvert(master.get("REMARKS"));
						
						master.put("ORGID", orgid);
						master.put("COMPANYID", companyid);
						master.put("ITEMCODE", itemcode);
//						master.put("LOTNO", lotno);
						master.put("TRXGUBUN", trxgubun);
						master.put("TRXTYPE", trxtype);
						master.put("TRXQTY", trxqty);
//						master.put("TRXUNITPRICE", trxunitprice);
//						master.put("TRXWAREHOUSING", trxwarehousing);
						master.put("TRXNO", trxno);
						master.put("TRXSEQ", trxseq);
						master.put("TRXIUD", trxiud);
						master.put("REMARKS", remarks);
						master.put("REGISTID", loginVO.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println(firstname + "-기타입출고등록 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("dist.etc.item.transaction.call.procedure", master);
						System.out.println(firstname + "-기타입출고등록 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
					}
					
					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("dist.mat.release.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_RELEASE_D fail.");
					}
				} else {
					// 변경
					{
						// 재고 트랜잭션 호출
						String orgid = StringUtil.nullConvert(master.get("ORGID"));
						System.out.println("updateMatRelDetailList orgid >>>>>>>>>> " + orgid);
						String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
						System.out.println("updateMatRelDetailList companyid >>>>>>>>>> " + companyid);
						String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
						System.out.println("updateMatRelDetailList itemcode >>>>>>>>>> " + itemcode);
//						String lotno = StringUtil.nullConvert(master.get("LOTNO"));
						String trxgubun = "U";
						String trxno = StringUtil.nullConvert(master.get("RELEASENO"));
						boolean firstchk = (trxno.startsWith("EP") || trxno.startsWith("FP"));
						String firstname = (( firstchk ) ? "제품" : "자재");
						System.out.println("updateMatRelDetailList firstname >>>>>>>>>> " + firstname);
						String trxtype = firstname + "-기타입출고";
						System.out.println("insertMatRelDetailList trxtype >>>>>>>>>> " + trxtype);
						Integer trxqty = NumberUtil.getInteger(master.get("RELEASEQTY"));
						System.out.println("updateMatRelDetailList trxqty >>>>>>>>>> " + trxqty);
//						Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
//						String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
						Integer trxseq = NumberUtil.getInteger(master.get("RELEASESEQ"));
						System.out.println("updateMatRelDetailList trxseq >>>>>>>>>> " + trxseq);
						String trxiud = "UPDATE";
						String remarks = StringUtil.nullConvert(master.get("REMARKS"));
						
						master.put("ORGID", orgid);
						master.put("COMPANYID", companyid);
						master.put("ITEMCODE", itemcode);
//						master.put("LOTNO", lotno);
						master.put("TRXGUBUN", trxgubun);
						master.put("TRXTYPE", trxtype);
						master.put("TRXQTY", trxqty);
//						master.put("TRXUNITPRICE", trxunitprice);
//						master.put("TRXWAREHOUSING", trxwarehousing);
						master.put("TRXNO", trxno);
						master.put("TRXSEQ", trxseq);
						master.put("TRXIUD", trxiud);
						master.put("REMARKS", remarks);
						master.put("REGISTID", loginVO.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println(firstname + "-기타입출고변경 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("dist.etc.item.transaction.call.procedure", master);
						System.out.println(firstname + "-기타입출고변경 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
					}
					
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("dist.mat.release.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_RELEASE_D fail.");
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
	 * 사출품반납 // Master 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatReturnMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectMatMoveRelList Start. >>>>>>>>>> " + params);

		return dao.list("dist.mat.rereturn.master.list.select", params);
	}

	/**
	 * 사출품반납 // Master 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatReturnMasterCount(HashMap<String, Object> reqMap) {
		System.out.println("selectMatMoveRelCount Start. >>>>>>>>>> " + reqMap);
		List<?> count = dao.list("dist.mat.rereturn.master.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 사출품관리 // 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatReturnDetailList(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.return.detail.select", params);
	}

	/**
	 * 사출품관리 // 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatReturnDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.return.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조달관리 > 자재관리 > 이동출고 // Master 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatMoveRelList(Map<String, Object> params) throws Exception {
		System.out.println("selectMatMoveRelList Start. >>>>>>>>>> " + params);

		return dao.list("dist.mat.release.master.move.select", params);
	}

	/**
	 * 조달관리 > 자재관리 > 이동출고 // Master 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatMoveRelCount(HashMap<String, Object> reqMap) {
		System.out.println("selectMatMoveRelCount Start. >>>>>>>>>> " + reqMap);
		List<?> count = dao.list("dist.mat.release.master.move.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조달관리 > 자재관리 > 이동출고 // 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatMoveRelDetailList(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.release.detail.move.select", params);
	}

	/**
	 * 조달관리 > 자재관리 > 이동출고 // 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatMoveRelDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.release.detail.move.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조달관리 > 자재관리 > 생산출고 // Master 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatProdRelList(Map<String, Object> params) throws Exception {
		System.out.println("selectMatProdRelList Start. >>>>>>>>>> " + params);

		return dao.list("dist.mat.release.master.prod.select", params);
	}

	/**
	 * 조달관리 > 자재관리 > 생산출고 // Master 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatProdRelCount(HashMap<String, Object> reqMap) {
		System.out.println("selectMatProdRelCount Start. >>>>>>>>>> " + reqMap);
		List<?> count = dao.list("dist.mat.release.master.prod.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조달관리 > 자재관리 > 생산출고 // 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectMatProdRelDetailList(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.release.detail.move.select", params);
	}

	/**
	 * 조달관리 > 자재관리 > 생산출고 // 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectMatProdRelDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.release.detail.move.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2017.02.22 입하상세정보 화면에서 입하대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> MatReceiveRegistPop1List(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.list.pop1.select", params);
	}

	/**
	 * 2017.02.22 입하상세정보 화면에서 입하대기LIST(발주정보) // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int MatReceiveRegistPop1TotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.list.pop1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 발주대비 입고현황 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> MatOrderReceiveList(Map<String, Object> params) throws Exception {

		return dao.list("dist.mat.matorderreceive.select", params);
	}

	/**
	 * 발주대비 입고현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int MatOrderReceiveListCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.mat.matorderreceive.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
}