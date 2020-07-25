<%@page import="model1.CommentDAO"%>
<%@page import="model1.CommentTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	String cpage = request.getParameter("cpage");
	String seq = request.getParameter("seq");
	String cseq = request.getParameter("cseq");
	String password = request.getParameter("password");
	String content = request.getParameter("content");
			
	CommentTO to = new CommentTO();
	to.setCseq(cseq);
	to.setPassword(password);
	to.setContent(content);
	
	CommentDAO dao = new CommentDAO();
	int flag = dao.commentModifyOk(to);
	
	out.println("<script type='text/javascript'>");
	   if(flag == 0){
		      out.println("alert('댓글 수정을 성공했습니다.');"); 
		      out.println("location.href='./board_view1.jsp?cpage="+cpage+"&seq="+seq+"';");
		   }
		   else if(flag == 1){
		      out.println("alert('비밀번호가 잘못 되었습니다.');"); 
		      out.println("history.back();");
		   }
		   else{
		      out.println("alert('댓글 수정을 실패했습니다.');");
		      out.println("history.back();");
		   }
	out.println("</script>");
	
%>