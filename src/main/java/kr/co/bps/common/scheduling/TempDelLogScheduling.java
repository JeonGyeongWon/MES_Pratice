package kr.co.bps.common.scheduling;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

@Service("tempDelLogScheduling")
public class TempDelLogScheduling {

	@Resource(name = "TempDelLogService")
	private TempDelLogService sysLogService;

	public void del() throws Exception {
		sysLogService.del("SchedulingDao.delBuyOrderDtlTmp");
		sysLogService.del("SchedulingDao.delBuyOrderMst");
		sysLogService.del("SchedulingDao.delJobOrderLot");
		sysLogService.del("SchedulingDao.delOrderLot");
	}

}
