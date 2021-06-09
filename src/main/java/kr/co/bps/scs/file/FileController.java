package kr.co.bps.scs.file;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.table.ImgFileVO;
import kr.co.bps.scs.util.StringUtil;
import egovframework.com.cmm.LoginVO;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@Controller
public class FileController extends BaseController {

	@Autowired
	private FileService fileService;

	@RequestMapping(value = "/file/delete.do")
	@ResponseBody
	public Object fileDelete(@RequestParam Map<String, Object> params) throws Exception {
		System.out.println("fileDelete Params. >>>>>>>>>> " + params);
		return fileService.deleteFile(params);
	}

	@RequestMapping(value = "/file/upload.do")
	@ResponseBody
	public Object fileUpload(final MultipartHttpServletRequest multiRequest,
			@RequestParam Map<String, Object> params) throws Exception {
		final Map<String, MultipartFile> files = multiRequest.getFileMap();

		if (!files.isEmpty()) {
			return fileService.updateFile(files);
		} else {
			return fileService.getAjaxResultMap(false, "fileupload");
		}
	}

	@RequestMapping(value = "/itemfile/upload.do")
	@ResponseBody
	public Object itemFileUpload(final MultipartHttpServletRequest multiRequest,
			@RequestParam Map<String, Object> params) throws Exception {
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		Map<String, Object> filemap = new HashMap<String, Object>();
		if (!files.isEmpty()) {
			filemap = fileService.updateFile(files);
		} else {
			return fileService.getAjaxResultMap(false, "fileupload");
		}

		if (!filemap.isEmpty()) {
			List<ImgFileVO> filelist = (List<ImgFileVO>) filemap.get("fileVo_list");
			//			LoginVO loginVO = getLoginVO();
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			for (ImgFileVO imgFileVO : filelist) {
				System.out.println(imgFileVO);
				Map<String, Object> paramsItemfile = new HashMap<String, Object>();
				paramsItemfile.put("itemcd", params.get("itemcd"));
				paramsItemfile.put("fileid", imgFileVO.getFileid());
				paramsItemfile.put("filetype", params.get("filetype"));

				String routingid = StringUtil.nullConvert(params.get("routingid"));
				if (!routingid.isEmpty()) {
					paramsItemfile.put("routingid", params.get("routingid"));
				}
				
				// 검사서 구분 항목
				String check = StringUtil.nullConvert(params.get("gubun"));
				if (!check.isEmpty()) {
					paramsItemfile.put("gubun", params.get("gubun"));
				}

				// 검사구분
				String checkbig = StringUtil.nullConvert(params.get("checkbig"));
				if (!checkbig.isEmpty()) {
					paramsItemfile.put("checkbig", params.get("checkbig"));
				}

				paramsItemfile.put("registid", loginVO.getId());
				paramsItemfile.put("updateid", loginVO.getId());
				fileService.insertTableByItemfile(paramsItemfile);
			}
		}

		return filemap;
	}

	@RequestMapping(value = "/itemfile/select.do")
	@ResponseBody
	public Object selectItemFile(@RequestParam Map<String, Object> params) throws Exception {
		return fileService.selectItemFile(params);
	}
}
