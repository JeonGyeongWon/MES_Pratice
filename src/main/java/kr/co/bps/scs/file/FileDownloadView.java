package kr.co.bps.scs.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class FileDownloadView extends AbstractView {

	private Logger logger = Logger.getLogger(getClass());

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		String fileName = null;

		Map<String, Object> t_file = (Map<String, Object>) model.get("t_file");
		File file = new File((String) t_file.get("PATH_ORG") + (String) t_file.get("FILE_NM_ORG"));

		if (file.exists() && file.isFile()) {
			response.setContentType(getContentType());
			response.setContentLength((int) file.length());

			if (request.getHeader("User-Agent").indexOf("MSIE") > -1)
				fileName = URLEncoder.encode((String) t_file.get("FILE_NM_VIEW"), "utf-8");
			else
				fileName = URLEncoder.encode((String) t_file.get("FILE_NM_VIEW"), "utf-8");

			response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
			response.setHeader("Content-Transfer-Encoding", "binary");

			OutputStream out = response.getOutputStream();

			FileInputStream fis = null;

			try {
				fis = new FileInputStream(file);
				FileCopyUtils.copy(fis, out);
			} catch (Exception e) {
				logger.error(e);
			} finally {
				if (fis != null) {
					try {
						fis.close();
					} catch (Exception e) {
					}
				}
				out.flush();
			}
		} else
			response.sendRedirect(request.getContextPath() + "/common/except/file404.hrb");

	}
}