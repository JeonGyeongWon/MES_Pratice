package kr.co.bps.scs.table;

import java.lang.reflect.Field;
import java.sql.Timestamp;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @ClassName : ImgFileVO.java
 * @Description : ImgFileVO class
 * @Modification Information
 *
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 05.
 * @version 1.0
 * @see
 * 
 *
 */
@Entity
@Table(name = "CB_FILE")
public class ImgFileVO {
	final Logger LOGGER = LoggerFactory.getLogger(getClass());

	private Integer fileid;
	private String filenmview = "";
	private String filenmreal = "";
	private String filepathview = "";
	private String filepathreal = "";
	private String fileexe = "";
	private String filecontype = "";
	private String registid;
	private Timestamp registdt;
	private String updateid;
	private Timestamp updatedt;

	@Id
	@Column(name = "FILEID")
	public Integer getFileid() {
		return fileid;
	}

	public void setFileid(Integer fileid) {
		this.fileid = fileid;
	}

	@Basic
	@Column(name = "FILENMVIEW")
	public String getFilenmview() {
		return filenmview;
	}

	public void setFilenmview(String filenmview) {
		this.filenmview = filenmview;
	}

	@Basic
	@Column(name = "FILENMREAL")
	public String getFilenmreal() {
		return filenmreal;
	}

	public void setFilenmreal(String filenmreal) {
		this.filenmreal = filenmreal;
	}

	@Basic
	@Column(name = "FILEPATHVIEW")
	public String getFilepathview() {
		return filepathview;
	}

	public void setFilepathview(String filepathview) {
		this.filepathview = filepathview;
	}

	@Basic
	@Column(name = "FILEPATHREAL")
	public String getFilepathreal() {
		return filepathreal;
	}

	public void setFilepathreal(String filepathreal) {
		this.filepathreal = filepathreal;
	}

	@Basic
	@Column(name = "FILEEXE")
	public String getFileexe() {
		return fileexe;
	}

	public void setFileexe(String fileexe) {
		this.fileexe = fileexe;
	}

	@Basic
	@Column(name = "FILECONTYPE")
	public String getFilecontype() {
		return filecontype;
	}

	public void setFilecontype(String filecontype) {
		this.filecontype = filecontype;
	}

	@Basic
	@Column(name = "CREATED_BY")
	public String getRegistid() {
		return registid;
	}

	public void setRegistid(String registid) {
		this.registid = registid;
	}

	@Basic
	@Column(name = "CREATION_DATE")
	public Timestamp getRegistdt() {
		return registdt;
	}

	public void setRegistdt(Timestamp registdt) {
		this.registdt = registdt;
	}

	@Basic
	@Column(name = "LAST_UPDATED_BY")
	public String getUpdateid() {
		return updateid;
	}

	public void setUpdateid(String updateid) {
		this.updateid = updateid;
	}

	@Basic
	@Column(name = "LAST_UPDATE_DATE")
	public Timestamp getUpdatedt() {
		return updatedt;
	}

	public void setUpdatedt(Timestamp updatedt) {
		this.updatedt = updatedt;
	}

	@Override
	public int hashCode() {

		int result = 0;
		try {
			for (Field field : this.getClass().getDeclaredFields()) {
				field.setAccessible(true);
				if (field.getName().equals("this$0")) continue;

				result = 31 * result + field.hashCode();
			}
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			LOGGER.error(this.getClass().getName() + "{}", e.getMessage());
		}
		return result;
	}

}