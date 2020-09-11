<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.CommentDAO" %>
<%@ page import="model1.CommentTO" %>

<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%
	request.setCharacterEncoding("utf-8");

	String seq = request.getParameter("seq");

	CommentTO cto = new CommentTO();
	cto.setSeq(request.getParameter("seq"));
	cto.setWriter(request.getParameter("cwriter"));
	cto.setPassword(request.getParameter("cpassword"));
	cto.setContent(request.getParameter("ccontent"));
	
	CommentDAO cdao = new CommentDAO();
	int flag = cdao.commentWriteOk(cto);
	
	JSONObject obj = new JSONObject();
	obj.put("flag", flag);
	
	out.println(obj);
%>