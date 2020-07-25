<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.BoardDAO" %>
<%@ page import="model1.BoardTO" %>

<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.io.File" %>
<%
	request.setCharacterEncoding("utf-8");

	String uploadPath = "C:/JSP/jsp-workspace/AlbumModel1Ex01/WebContent/upload";
	int maxFileSize = 1024 * 1024 * 5; //5MB
	String encType = "utf-8";
	
	MultipartRequest multi = new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());

	BoardTO to = new BoardTO();
	to.setSubject(multi.getParameter("subject"));
	to.setWriter(multi.getParameter("writer"));
	to.setMail("");
	if (!multi.getParameter("mail1").equals("") && !multi.getParameter("mail2").equals("")) {
		to.setMail(multi.getParameter("mail1") + "@" + multi.getParameter("mail2"));
	}
	to.setPassword(multi.getParameter("password"));
	to.setContent(multi.getParameter("content"));
	to.setFilename(multi.getFilesystemName("upload"));
	long filesize = 0;
	File file = multi.getFile("upload");
	if (file != null) {
		to.setFilesize(file.length());
	}
	to.setWip(request.getRemoteAddr());
	
	BoardDAO dao = new BoardDAO();
	int flag = dao.boardWriteOk(to);
	
	out.println("<script type='text/javascript'>");
	if (flag == 0) {
		out.println("alert('글이 작성되었습니다.');");
		out.println("location.href='./board_list1.jsp';");
	} else {
		out.println("alert('글쓰기를 실패했습니다.');");
		out.println("history.back();");
	}
	out.println("</script>");
%>