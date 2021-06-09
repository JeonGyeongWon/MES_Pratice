package kr.co.bps.scs.order.deposit;

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
 * @ClassName : OrderDepositService.java
 * @Description : OrderDeposit Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 10.
 * @version 1.0
 * @see 수금관리
 * 
 * 
 */
@Transactional
@Service
public class OrderDepositService extends BaseService {

	/**
	 * 수금 등록관리의 마스터 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOrderDepositListMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectOrderDepositListMasterList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.deposit.orderdepositlist.master.select", params);
	}

	/**
	 * 수금 등록관리의 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOrderDepositListMasterCount(HashMap<String, Object> params) {
		System.out.println("selectOrderDepositListMasterCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.deposit.orderdepositlist.master.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 수금 등록관리의 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOrderDepositListDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectOrderDepositListDetailRegist Service Start. >>>>>>>>>> " + params);

		return dao.list("order.deposit.orderdepositlist.detail.select", params);
	}

	/**
	 * 수금 등록관리의 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOrderDepositListDetailCount(HashMap<String, Object> params) {
		System.out.println("selectOrderDepositListDetailCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.deposit.orderdepositlist.detail.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 수금등록 // 마스터 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOrderDepositRegistMasterRegist(HashMap<String, Object> params) throws Exception {
		System.out.println("insertOrderDepositRegistMasterRegist Service Start. >>>>>>>>>> " + params);
		String taxno = null;
		try {
			// 1. 세금계산서번호 자동채번
			taxno = StringUtil.nullConvert(params.get("TaxNo"));
			if (taxno.isEmpty()) {
				List taxnolist = dao.selectListByIbatis("order.deposit.orderdeposittaxno.find", params);
				Map<String, Object> current = (Map<String, Object>) taxnolist.get(0);
				params.put("TaxNo", current.get("FINDTAXNO"));
				taxno = (String) current.get("FINDTAXNO");
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

			master.put("TaxNo", taxno);
			System.out.println("insertOrderDepositRegistMasterRegist Master >>>>>>>>>> " + master);
			System.out.println("insertOrderDepositRegistMasterRegist No >>>>>>>>>> " + taxno);

			int updateResult = dao.update("order.deposit.orderdepositlist.master.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_TAX_INVOICE_H fail.");
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
	 * 수금등록 // 디테일 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOrderDepositRegistDetailRegist(Map<String, Object> params) throws Exception {
		System.out.println("insertOrderDepositRegistDetailRegist Service Start. >>>>>>>>>> ");
		try {
			System.out.println("insertOrderDepositRegistDetailRegist 1. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			Map<String, Object> temp = null;
			String taxno = null;
			String orgid = null;
			String companyid = null;
			System.out.println("insertOrderDepositRegistDetailRegist 2. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				master.put("REGISTID", loginVO.getId());

				taxno = StringUtil.nullConvert(master.get("TaxNo"));
				orgid = StringUtil.nullConvert(master.get("Orgid"));
				companyid = StringUtil.nullConvert(master.get("CompanyId"));

				String invoicedate = StringUtil.nullConvert(master.get("DepositDate"));
				String[] sList1 = invoicedate.split("T");

				master.put("TAXINVOICENO", taxno);
				master.put("Orgid", orgid);
				master.put("CompanyId", companyid);
				master.put("DepositDate", sList1[0]);

				int updateResult = dao.update("order.deposit.orderdepositlist.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_TAX_INVOICE_D fail.");
				}
			}
			System.out.println("insertOrderDepositRegistDetailRegist 4. params >>>>>>>>>> " + params);

			/*// 수금 -> 생산계획 PKG 호출
			if (!taxno.isEmpty()) {
				LoginVO login = getLoginVO();
				params.put("SONUM", taxno);
				params.put("ORG", orgid);
				params.put("COMP", companyid);
				params.put("UPDATEID", login.getId());
				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");

				System.out.println("insertOrderDepositRegistDetailRegist 6. params >>>>>>>>>> " + params);
				System.out.println("수금 -> 생산계획 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("order.deposit.orderdepositlist.Procedure", params);
				System.out.println("수금 -> 생산계획 PROCEDURE 호출 End.  >>>>>>>> " + params);

				String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					errcnt += 1;
					throw new Exception("call CB_SO_PKG.CB_PROD_PLAN_PROC fail.");
				}
			}*/
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
	 * 수금등록 // 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOrderDepositRegistMasterRegist(HashMap<String, Object> params) throws Exception {
		System.out.println("updateOrderDepositRegistMasterRegist Service Start. >>>>>>>>>> " + params);

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
			String price = StringUtil.nullConvert(master.get("SupplyPrice_f"));
			String tax = StringUtil.nullConvert(master.get("AdditionalTax_f"));
			
			String price2, tax2;
			price2=price.replaceAll(",", "");
			tax2=tax.replaceAll(",", "");
			master.put("SupplyPrice",price2);
			master.put("AdditionalTax",tax2);
			System.out.println("updateOrderDepositRegistMasterRegist 1. >>>>>>>>>> " + master);

			int updateResult = dao.update("order.deposit.orderdepositlist.master.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_TAX_INVOICE_H fail.");
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
	 * 수금등록 // 디테일 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOrderDepositRegistDetailRegist(HashMap<String, Object> params) throws Exception {
		System.out.println("updateOrderDepositRegistDetailRegist Service Start. >>>>>>>>>> ");

		try {
			System.out.println("updateOrderDepositRegistDetailRegist 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updateOrderDepositRegistDetailRegist 2. >>>>>>>>>> " + list.size());
			Map<String, Object> temp = null;
			String taxno = null;
			String orgid = null;
			String companyid = null;

			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);
				taxno = StringUtil.nullConvert(master.get("TaxNo"));
				orgid = StringUtil.nullConvert(master.get("Orgid"));
				companyid = StringUtil.nullConvert(master.get("CompanyId"));

				String deopositdate = StringUtil.nullConvert(master.get("DEPOSITDATE"));
				String[] sList1 = deopositdate.split("T");

				master.put("TaxNo", taxno);
				master.put("Orgid", orgid);
				master.put("CompanyId", companyid);

				master.put("DEOPOSITDATE", sList1[0]);

				LoginVO loginVO = getLoginVO();
				System.out.println("1. updateOrderDepositRegistDetailRegist master >>>>>>>>>> " + master);
				// porno 등록유무 확인
				List taxnoList = dao.selectListByIbatis("order.deposit.orderdepositinvoiceseq.find", master);
				Map<String, Object> current = (Map<String, Object>) taxnoList.get(0);
				int soCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateOrderDepositRegistDetailRegist soCheck >>>>>>>>>> " + soCheck);
				if (soCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("order.deposit.orderdepositlist.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_TAX_INVOICE_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("order.deposit.orderdepositlist.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_TAX_INVOICE_D fail.");
					}
				}
			}
			System.out.println("updateOrderDepositRegistDetailRegist 4. params >>>>>>>>>> " + params);

			// 수금 -> 생산계획 PKG 호출
			if (!taxno.isEmpty()) {
				LoginVO login = getLoginVO();
				params.put("SONUM", taxno);
				params.put("ORG", orgid);
				params.put("COMP", companyid);
				params.put("UPDATEID", login.getId());
				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");

				System.out.println("updateOrderDepositRegistDetailRegist 6. params >>>>>>>>>> " + params);
				System.out.println("수금 -> 생산계획 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("order.deposit.orderdepositlist.Procedure", params);
				System.out.println("수금 -> 생산계획 PROCEDURE 호출 End.  >>>>>>>> " + params);

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
	 * 수금등록 // 마스터 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOrderDepositRegistMasterRegist(Map<String, Object> params) throws Exception {
		System.out.println("deleteOrderDepositRegistMasterRegist Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		boolean isSuccess = dao.deleteListByIbatis("order.deposit.orderdepositlist.master.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 수금등록 // 디테일 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOrderDepositRegistDetailRegist(HashMap<String, Object> params) throws Exception {
		System.out.println("deleteOrderDepositRegistDetailRegist Service Start. >>>>>>>>>> " + params);

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
			
			int taxinvoiceseq = NumberUtil.getInteger(master.get("TAXINVOICESEQ"));
			master.put("UPDATEID", login.getId());
			master.put("TAXINVOICESEQ", taxinvoiceseq);
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
//			System.out.println("수금 -> 생산계획 삭제 PROCEDURE 호출 Start. >>>>>>>> ");
//			dao.list("order.deposit.prodplan.delete.Procedure", master);
//			System.out.println("수금 -> 생산계획 삭제 PROCEDURE 호출 End. >>>>>>>> " + master);
//			String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
//			if (!status.equals("S")) {
				// "E" -> 해당작지가 존재함, "S" -> 생산계획 삭제완료
//			} else {
				int updateResult = dao.delete("order.deposit.orderdepositlist.detail.delete", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_TAX_INVOICE_D fail.");
				}
//			}
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
	 * 수금 파일 업로드 // 파일 업로드 데이터 등록
	 * 
	 * @param params
	 *            - 등록 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> uploadDepositList(List<Object> list, String sourcecd) throws Exception {
		System.out.println("uploadDepositList Service Start. >>>>>>>>>> " + list);
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
			String invoiceDate = StringUtil.nullConvert(CheckListMap.get("INVOICEDATE")).replace(".", "").replace("E7", "");

			if (customerName.length() == 0 || invoiceDate.length() == 0) {
				NameTemp += "<br/>" + (i + 1) + "번째 라인의 ";
				forCount++;
			}
			String tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
			if (customerName.isEmpty()) {
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "거래처" : ", 거래처");
			}
			if (invoiceDate.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "발행일자" : ", 발행일자");
			}
			tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
			NameTemp += tempdata;
		}
		System.out.println("uploadDepositList NameTemp. >>>>>>>>>>" + NameTemp);
		// 에러실패 체크 끝

		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> excelMap = (Map<String, Object>) list.get(i);
			HashMap<String, Object> tempMap = new HashMap<String, Object>();
			excelMap.put("REGISTID", loVo.getId());

			System.out.println("uploadDepositList list.size(). >>>>>>>>>>" + list.size());

			try {
				excelMap.put("ORGID", orgid);
				tempMap.put("ORGID", orgid);
				System.out.println("uploadDepositList orgid. >>>>>>>>>>" + orgid);

				excelMap.put("COMPANYID", companyid);
				tempMap.put("COMPANYID", companyid);
				System.out.println("uploadDepositList companyid. >>>>>>>>>>" + companyid);

				String CustomerName = null, OrderName = null, DrawingNo = null, ItemName = null, CustomerOrder = null,
						CustomerOrderSeq = null, SoQty = null, InvoiceDate = null, DueDate = null;
				// 2. 거래처
				Map<String, Object> searchCustomerList = null;
				CustomerName = StringUtil.nullConvert(excelMap.get("CUSTOMERNAME").toString());
				if (!CustomerName.isEmpty()) {

					tempMap.put("CUSTOMERNAME2", CustomerName);
					tempMap.put("CUSTOMERTYPE1", "S");
					List CustomerList = dao.selectListByIbatis("search.customer.name.lov.select", tempMap);
					System.out.println("uploadShipRegistList CustomerList. >>>>>>>>>>" + CustomerList.size());
					if ( CustomerList.size() == 0 ) {
						failCnt++;
						NameTemp += "<br/>" + (i + 1) + "번째 라인의 거래처";
					} else {
						Map<String, Object> CustomerMap = (Map<String, Object>) CustomerList.get(0);
						CustomerName = StringUtil.nullConvert(CustomerMap.get("LABEL"));

						excelMap.put("CUSTOMERNAME", CustomerName);
					}
				}
				System.out.println("uploadDepositList CustomerName. >>>>>>>>>>" + CustomerName);
				
				// 3. 발행일자
				InvoiceDate = StringUtil.nullConvert(excelMap.get("INVOICEDATE").toString()).replace(".", "").replace("E7", "");
				System.out.println("uploadDepositList InvoiceDate. >>>>>>>>>>" + InvoiceDate);
				if (!InvoiceDate.isEmpty()) {
					excelMap.put("INVOICEDATE", InvoiceDate);
				}


			} catch (Exception e) {
				failCnt++;
				// list.remove(i);
				// i--;
			}
		}

		List chkList = dao.selectListByIbatis("excel.invoice.find.select", null);
		Map<String, Object> current = (Map<String, Object>) chkList.get(0);
		int isCheck = NumberUtil.getInteger(current.get("COUNT"));

		System.out.println("2. uploadDepositList isCheck >>>>>>>>>> " + isCheck);
		if (isCheck > 0) {
			System.out.println("uploadDepositList DELETE Start. >>>>>>>>>>");
			// 엑셀 TEMP 삭제
			int deleteResult = dao.delete("excel.invoice.delete", null);
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				throw new Exception("delete CB_INVOICE_TEMP fail.");
			}
		}

		List<Object> uploadlist = dao.insertListByIbatis("excel.invoice.insert", list);
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

		System.out.println("uploadDepositList NameTemp >>>>>>>>>>" + NameTemp);
		System.out.println("uploadDepositList sbMsg >>>>>>>>>>" + sbMsg);


		if (failCnt == 0) {
			try {
				// 수금 UPLOAD PKG 호출
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
				params.put("REGISTID", loVo.getId());

				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");
				System.out.println("수금 UPLOAD PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("excel.invoice.upload.call.Procedure", params);
				System.out.println("수금 UPLOAD PROCEDURE 호출 End.  >>>>>>>> " + params);

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
	 * 미수금 현황조회의 마스터 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectReceivableStateListMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectReceivableStateListMasterList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.deposit.receivablestatelist.master.select", params);
	}

	/**
	 * 미수금 현황조회의 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectReceivableStateListMasterCount(HashMap<String, Object> params) {
		System.out.println("selectReceivableStateListMasterCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.deposit.receivablestatelist.master.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
}