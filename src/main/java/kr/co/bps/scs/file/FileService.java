package kr.co.bps.scs.file;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.co.bps.scs.DateUtil;
import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.table.ImgFileVO;
import kr.co.bps.scs.util.FileUtil;
import egovframework.com.cmm.LoginVO;

@Service
public class FileService extends BaseService {

	private FileUtil fileUtil = new FileUtil();

	public Map<String, Object> updateFile(final Map<String, MultipartFile> files) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		if (files != null) {
			String filepathview = "";
			String filepathreal = "";

			String path = "";
			path += super.propertyService.getString("Globals.fileStorePath");
			path += super.propertyService.getString("Globals.path.images") + "/";
			path += DateUtil.getCurrentDate("yyyyMM") + "/";
			path = path.replaceAll("//", "/");

			filepathreal = addWebAppPath(path.toString());
			filepathview = addContextPath(path.toString());

			List<ImgFileVO> fileVo_list = fileUtil.listUploadFiles(files, filepathreal);
			LoginVO loginVO = super.getLoginVO();

			for (ImgFileVO fileVo : fileVo_list) {

				fileVo.setFilepathview(filepathview);
				fileVo.setFilepathreal(filepathreal);
				fileVo.setRegistid(loginVO.getId());
				//				fileVo.setRegistdt(DateUtil.getToday());
				fileVo.setUpdateid(loginVO.getId());
				//				fileVo.setUpdatedt(DateUtil.getToday());

				dao.insert("file.insert", fileVo);
			}

			result.put("fileVo_list", fileVo_list);
		}
		return result;
	}

	public Map<String, Object> deleteFile(Map<String, Object> params) throws Exception {

		dao.delete("itemfile.delete", params);
		List<ImgFileVO> list = (List<ImgFileVO>) dao.selectListByIbatis("file.select", params);
		int r = 0;
		for (ImgFileVO imgFileVO : list) {
			dao.delete("file.delete", imgFileVO);
			fileUtil.deleteFile(imgFileVO);
			r++;
		}
		return super.getAjaxResultMap(r > 0, "delete");
	}

	public List<?> selectItemFile(Map<String, Object> params) throws Exception {
		List<?> list = dao.selectListByIbatis("itemfile.select", params);
		return list;
	}

	public List<?> selectItemFile(String itemcd, String filetype) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemcd", itemcd);
		params.put("filetype", filetype);
		return selectItemFile(params);
	}

	public List<?> selectItemFile(String itemcd, String filetype, String gubun) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemcd", itemcd);
		params.put("filetype", filetype);
		params.put("gubun", gubun);
		return selectItemFile(params);
	}

	public List<?> selectItemFile(String itemcd, String filetype, String gubun, String routingid) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemcd", itemcd);
		params.put("filetype", filetype);
		params.put("gubun", gubun);
		params.put("routingid", routingid);
		return selectItemFile(params);
	}

	public Map<String, Object> insertTableByItemfile(Map<String, Object> params) throws Exception {
		boolean isSuccess = dao.insertByIbatis("itemfile.insert", params) == null;
		return super.getAjaxResultMap(isSuccess, "insert");
	}

	private String addWebAppPath(String url) throws Exception {
		return super.propertyService.getString("Globals.path.webapp") + url;
	}

	private String addContextPath(String url) throws Exception {
		return super.request.getContextPath() + url;
	}

}
