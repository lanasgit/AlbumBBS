<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.BoardDAO" %>
<%@ page import="model1.BoardTO" %>

<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.io.File" %>
<%
	request.setCharacterEncoding("utf-8");
	
	String uploadPath = "C:/Users/KIM/git/repository2/AlbumModel1Ex01/WebContent/upload";
	int maxFileSize = 1024 * 1024 * 5; //5MB
	String encType = "utf-8";
	
	MultipartRequest multi = new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());

	BoardTO to = new BoardTO();	
	to.setCpage(multi.getParameter("cpage"));
	to.setSeq(multi.getParameter("seq"));
	to.setSubject(multi.getParameter("subject"));
	to.setPassword(multi.getParameter("password"));
	to.setContent(multi.getParameter("content"));
	to.setMail("");
	if (!multi.getParameter("mail1").equals("") && !multi.getParameter("mail2").equals("")) {
		to.setMail(multi.getParameter("mail1") + "@" + multi.getParameter("mail2"));
	}
	to.setNewFilename(multi.getFilesystemName("upload"));
	long newFilesize = 0;
	File newFile = multi.getFile("upload");
	if (newFile != null) {
		to.setNewFilesize(newFile.length());
	}

	BoardDAO dao = new BoardDAO();
	int flag = dao.boardModifyOk(to);
	
	out.println("<script type='text/javascript'>");
	if (flag == 0) {
		out.println("alert('글이 수정되었습니다.');");
		out.println("location.href='./board_view1.jsp?cpage="+to.getCpage()+"&seq="+to.getSeq()+"';");
	} else if (flag == 1) {
		out.println("alert('비밀번호가 잘못되었습니다.');");
		out.println("history.back();");
	} else {
		out.println("alert('글수정을 실패했습니다.');");
		out.println("history.back();");
	}
	out.println("</script>");
%>