<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.CommentDAO" %>
<%@ page import="model1.CommentTO" %>
<%
	request.setCharacterEncoding("utf-8");

	String cpage = request.getParameter("cpage");
	String seq = request.getParameter("seq");

	CommentTO cto = new CommentTO();
	cto.setSeq(request.getParameter("seq"));
	cto.setWriter(request.getParameter("cwriter"));
	cto.setPassword(request.getParameter("cpassword"));
	cto.setContent(request.getParameter("ccontent"));
	
	CommentDAO cdao = new CommentDAO();
	int flag = cdao.commentWriteOk(cto);
	
	out.println("<script type='text/javascript'>");
	if (flag == 0) {
		out.println("alert('댓글 작성 완료');");
		out.println("location.href='./board_view1.jsp?cpage="+cpage+"&seq="+seq+"';");
	} else {
		out.println("alert('댓글 등록 실패');");
		out.println("history.back();");
	}
	out.println("</script>");
%>