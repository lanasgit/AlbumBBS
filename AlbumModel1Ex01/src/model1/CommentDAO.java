package model1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class CommentDAO {
	private DataSource dataSource = null;
	
	public CommentDAO() {
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context)initCtx.lookup("java:comp/env");
			this.dataSource = (DataSource)envCtx.lookup("jdbc/mariadb1");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			System.out.println("[에러] : " + e.getMessage());
		}
	}
	
	public int commentWriteOk(CommentTO cto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		int flag = 1;
		
		try {
			conn = this.dataSource.getConnection();
			
			//자동증가 컬럼(seq) 초기화
			String sql = "alter table album_comment1 auto_increment = 1";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
			pstmt.close();
			
			//해당 게시글 댓글 개수(cmt) 1 증가
			sql ="update album_board1 set cmt=cmt+1 where seq=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, cto.getSeq());
			pstmt.executeUpdate();
			pstmt.close();
			
			sql = "insert into album_comment1 values (0, ?, ?, ?, ?, now())";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, cto.getSeq());
			pstmt.setString(2, cto.getWriter());
			pstmt.setString(3, cto.getPassword());
			pstmt.setString(4, cto.getContent());
			
			int result = pstmt.executeUpdate();
			if (result == 1) {
				flag = 0;
			} 
		} catch (SQLException e) {
			System.out.println("[에러] : " + e.getMessage());
		} finally {
			if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
			if (conn != null) try {conn.close();} catch (SQLException e) {}
		}		
		return flag;
	}
	
	public ArrayList<CommentTO> CommentList(String seq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		ArrayList<CommentTO> lists = new ArrayList<CommentTO>();
		try {
			conn = this.dataSource.getConnection();
			
			String sql = "select writer, password, content, cdate from album_comment1 where seq=? order by seq desc";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			pstmt.setString(1, seq);
			
			rs = pstmt.executeQuery();
			
			rs.last();
			rs.beforeFirst();
			
			while (rs.next()) {
				CommentTO to = new CommentTO();
				to.setWriter(rs.getString("writer"));
				to.setPassword(rs.getString("password"));
				to.setContent(rs.getString("content"));
				to.setCdate(rs.getString("cdate"));
				
				lists.add(to);
			}
		} catch (SQLException e) {
			System.out.println("[에러] : " + e.getMessage());
		} finally {
			if (rs != null) try {rs.close();} catch (SQLException e) {}
			if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
			if (conn != null) try {conn.close();} catch (SQLException e) {}
		}		
		return lists;
	}
	
}
