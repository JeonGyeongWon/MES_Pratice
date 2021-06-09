package kr.co.bps.scs.util;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.web.multipart.MultipartFile;

import kr.co.bps.scs.table.ImgFileVO;

public class FileUtil {

	private static int suffix = 0;
	private static int prefix = 0;

	public List<ImgFileVO> listUploadFiles(final Map<String, MultipartFile> files, String path) throws Exception {

		List<ImgFileVO> result = new ArrayList<ImgFileVO>();

		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();
			MultipartFile file = entry.getValue();
			ImgFileVO fileVo = (ImgFileVO) uploadFile(file, path);
			if (fileVo != null)
				result.add(fileVo);
		}

		return result;
	}

	synchronized public ImgFileVO uploadFile(MultipartFile file, String filepathreal) throws Exception {

		ImgFileVO fileVo = new ImgFileVO();

		String[] dirs = filepathreal.split("/");
		String tempPath = "";
		for (String dirPath : dirs) {
			tempPath += dirPath + "/";
			if (dirPath.length() > 0) {
				File dir = new File(tempPath);
				if (!dir.isDirectory())
					dir.mkdir();
			}
		}

		if (!file.isEmpty() && file.getSize() > 0) {
			suffix++;
			if (suffix == 100)
				suffix = 1;
			String filenmview = file.getOriginalFilename();
			String fileexe = StringUtil.removeLastOnce(filenmview, ".");
			String filenmreal = System.currentTimeMillis() + ("_" + ((suffix + "").length() > 1 ? suffix : "0" + suffix));

			//이미 존재하는 파일인지  생성해봄
			File tempfile = new File(filepathreal, filenmreal);
			// 이미 존재하는 파일일경우 리네임
			if (tempfile.exists() && tempfile.isFile()) {
				prefix++;
				if (prefix == 100)
					prefix = 1;
				tempfile = new File(filepathreal, filenmreal + ("_" + prefix));
			}

			file.transferTo(tempfile); // 업로드 디렉토리로 파일 이동

			fileVo.setFilenmreal(filenmreal);
			fileVo.setFilenmview(filenmview);
			fileVo.setFilepathreal(filepathreal);
			fileVo.setFileexe(fileexe);
			fileVo.setFilecontype(file.getContentType());
			return fileVo;
		} else
			return null;
	}

	public boolean deleteFile(ImgFileVO imgFileVO) throws Exception {
		boolean isSuccess = false;
		if (imgFileVO == null)
			return isSuccess;

		String filepathreal = StringUtil.nullConvert(imgFileVO.getFilepathreal());
		String filenmreal = StringUtil.nullConvert(imgFileVO.getFilenmreal());
		String PATH_FULL = filepathreal + filenmreal;

		if (PATH_FULL.length() == 0)
			return isSuccess;

		File file = new File(PATH_FULL);
		// 파일이 존재하면
		if (file.isFile()) {
			file.delete();
			isSuccess = true;
		}

		return isSuccess;
	}
}