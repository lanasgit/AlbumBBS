<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>

<%
	request.setCharacterEncoding("utf-8");

	Connection conn = null;
	PreparedStatement pstmt = null;
	
	//성공, 실패 표현
	int flag = 1;
	
	try {
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup("java:comp/env");
		DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mariadb1");
		
		conn = dataSource.getConnection();	
		
		//자동증가 컬럼(seq : 게시글 번호) 초기화 먼저 실행
		String sql = "alter table album_board1 auto_increment = 1";
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
				
		sql = "insert into album_board1 values (0, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, now())";
		pstmt = conn.prepareStatement(sql);
		
		for (int i = 1; i <= 100; i++) {
			pstmt.setString(1, "제목" + i);
			pstmt.setString(2, "이름");
			pstmt.setString(3, "test@test.com");
			pstmt.setString(4, "123456");
			pstmt.setString(5, "내용" + i);
			pstmt.setString(6, null);
			pstmt.setInt(7, 0);
			pstmt.setString(8, "000.000.000.000");
			
			pstmt.executeUpdate();
		}
	} catch (NamingException e) {
		System.out.println("[에러] : " + e.getMessage());
	} catch (SQLException e) {
		System.out.println("[에러] : " + e.getMessage());
	} finally {
		if (pstmt != null) pstmt.close();
		if (conn != null) conn.close();
	}
	out.println("<script type='text/javascript'>");
	out.println("alert('글쓰기를 성공했습니다.');");
	out.println("location.href='./board_list1.jsp';");
	out.println("</script>");
%>