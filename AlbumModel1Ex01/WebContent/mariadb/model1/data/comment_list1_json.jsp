<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
    
<%@ page import="java.util.ArrayList"%>
<%@ page import="model1.CommentDAO" %>
<%@ page import="model1.CommentTO" %>

<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%
	request.setCharacterEncoding("utf-8");

	String seq = request.getParameter("seq");
	
	CommentDAO cdao = new CommentDAO();
	ArrayList<CommentTO> lists = cdao.CommentList(seq);
	
	JSONArray jsonArray = new JSONArray();
	for (CommentTO cto : lists) {
		String Cseq = cto.getCseq();
		String Cwriter = cto.getWriter();
		String Ccontent = cto.getContent();
		String Cdate = cto.getCdate();
		
		JSONObject obj = new JSONObject();
		obj.put("Cseq", Cseq);
		obj.put("Cwriter", Cwriter);
		obj.put("Ccontent", Ccontent);
		obj.put("Cdate", Cdate);
		
		jsonArray.add(obj);
	}
	out.println(jsonArray);
%>