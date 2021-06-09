package kr.co.bps.common.file.service;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
/**
 * @Class Name : ShipmentProcessVO.java
 * @Description : ShipmentProcessV VO class
 * @Modification Information
 *
 * @author jslee
 * @since 2012-09-15
 * @version 1.0
 * @see
 *  
 *  Copyright (C)  All right reserved.
 */
public class FileVO {
	
	private BigDecimal fileId;
	private String entityName;
	
	public BigDecimal getFileId() {
		return fileId;
	}
	public void setFileId(BigDecimal fileId) {
		this.fileId = fileId;
	}
	public String getEntityName() {
		return entityName;
	}
	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}
	   
}
