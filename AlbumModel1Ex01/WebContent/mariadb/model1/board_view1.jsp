<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model1.BoardDAO" %>
<%@ page import="model1.BoardTO" %>
<%@ page import="model1.CommentDAO" %>
<%@ page import="model1.CommentTO" %>

<%@ page import="java.util.ArrayList" %>
<%
	request.setCharacterEncoding("utf-8");

	BoardTO to = new BoardTO();
	to.setSeq(request.getParameter("seq"));
	to.setCpage(request.getParameter("cpage"));
	
	BoardDAO dao = new BoardDAO();
	to = dao.boardView(to);
	
	String seq = to.getSeq();
	String cpage = to.getCpage();
	String subject = to.getSubject();
	String writer = to.getWriter();
	String mail = to.getMail();
	String wip = to.getWip();
	String wdate = to.getWdate();
	String hit = to.getHit();
	String content = to.getContent();
	String filename = to.getFilename();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>앨범 게시판</title>
<link rel="stylesheet" type="text/css" href="../../css/board_view.css">
<script type="text/javascript">
	window.onload = function() {
		readServer();
		document.getElementById('cbtn').onclick = function() {
			if (document.cfrm.cwriter.value.trim() == '') {
				alert('이름을 입력하셔야 합니다.');
				return false;
			}
			if (document.cfrm.cpassword.value.trim() == '') {
				alert('비밀번호를 입력하셔야 합니다.');
				return false;
			}
			if (document.cfrm.ccontent.value.trim() == '') {
				alert('내용을 입력하셔야 합니다.');
				return false;
			}
			writeServer(
				document.cfrm.cwriter.value.trim(),
				document.cfrm.cpassword.value.trim(),
				document.cfrm.ccontent.value.trim()
			);
		};
		
		var writeServer = function(cwriter, cpassword, ccontent) {
			var request = new XMLHttpRequest();
			request.onreadystatechange = function() {
				if (request.readyState == 4) {
					if (request.status == 200) {
						var data = request.responseText.trim();
						var json = eval('(' + data + ')');
						if (json.flag == 0) {
							alert("댓글이 작성되었습니다");
							readServer();
							document.cfrm.cwriter.value ="";
							document.cfrm.cpassword.value ="";
							document.cfrm.ccontent.value ="";
						} else {
							alert("[오류] 댓글 작성 실패")
						}
					} else {
						alert('페이지 처리 에러');
					}
				}
			}
			var url = './data/comment_write1_ok_json.jsp?seq= <%=seq %>';
			url += '&cwriter=' + encodeURIComponent(cwriter) 
			url += '&cpassword=' + cpassword
			url += '&ccontent=' + encodeURIComponent(ccontent)
			request.open('get', url, true);
			request.send();
		}
	}
	var readServer = function() {
		var request = new XMLHttpRequest();
		request.onreadystatechange = function() {
			if (request.readyState == 4) {
				if (request.status == 200) {
					showData(request.responseText.trim());
				} else {
					alert('페이지 처리 에러');
				}
			}
		}
		request.open('get', './data/comment_list1_json.jsp?seq= <%=seq %>', true);
		request.send();
		
		var showData = function(data) {
			var json = eval('(' + data + ')');
			var result = '<table>';
			for (var i = 0; i < json.length; i++) {
				result += '<tr>';
				result += '<td class="coment_re" width="20%">';
				result += '<strong>'+ json[i].Cwriter +'</strong> ('+ json[i].Cdate +')';
				result += '<div class="coment_re_txt">';
				result += json[i].Ccontent;
				result += '<div class="align_right">'; 
				result += '<a href="javascript:void(0)"; onclick="location.href=\'./comment_modify1.jsp?cpage='+<%=cpage %>+'&cseq='+json[i].Cseq+'&seq='+<%=seq %>+'\'">수정</a>&nbsp;';
				result += '<a href="javascript:void(0)"; onclick="location.href=\'./comment_delete1.jsp?cpage='+<%=cpage %>+'&cseq='+json[i].Cseq+'&seq='+<%=seq %>+'\'">삭제</a>&nbsp;';
				result += '</div>';
				result += '</div>';
				result += '</td>';
				result += '</tr>';
			}
			result += '</table>';
			
			document.getElementById('result').innerHTML = result;
		}
	}
</script>
</head>

<body>
<!-- 상단 디자인 -->
<div class="contents1"> 
	<div class="con_title"> 
		<p style="margin: 0px; text-align: right">
			<img style="vertical-align: middle" alt="" src="../../images/home_icon.gif" /> &gt; 커뮤니티 &gt; <strong>여행지리뷰</strong>
		</p>
	</div>

	<div class="contents_sub">	
	<!--게시판-->
		<div class="board_view">
			<table>
			<tr>
				<th width="10%">제목</th>
				<td width="60%"><%=subject %></td>
				<th width="10%">등록일</th>
				<td width="20%"><%=wdate %></td>
			</tr>
			<tr>
				<th>글쓴이</th>
				<td><%=writer %>(<%=mail %>)(<%=wip %>)</td>
				<th>조회</th>
				<td><%=hit %></td>
			</tr>
			<tr>
				<td colspan="4" height="200" valign="top" style="padding:20px; line-height:160%">
					<div id="bbs_file_wrap">
						<div>
							<img src="../../upload/<%=filename %>" width="500" onerror="" /><br />
						</div>
					</div>
					<%=content %>
				</td>
			</tr>			
			</table>
			
			<div id="result"></div>

			<form action="" method="post" name="cfrm">
			<table>
				<tr>
					<td width="94%" class="coment_re">
						글쓴이 <input type="text" name="cwriter" maxlength="10" class="coment_input" />&nbsp;&nbsp;
						비밀번호 <input type="password" name="cpassword" class="coment_input pR10" />&nbsp;&nbsp;
					</td>
					<td width="6%" class="bg01"></td>
				</tr>
				<tr>
					<td class="bg01">
						<textarea name="ccontent" cols="" rows="" class="coment_input_text"></textarea>
					</td>
					<td align="right" class="bg01">
						<input type="button" id="cbtn" value="댓글등록" class="btn_write btn_txt01" style="cursor: pointer;"/>
					</td>
				</tr>
			</table>
			</form>
		</div>
		<div class="btn_area">
			<div class="align_left">			
				<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.jsp?cpage=<%=cpage %>'" />
			</div>
			<div class="align_right">
				<input type="button" value="수정" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_modify1.jsp?cpage=<%=cpage %>&seq=<%=seq %>'" />
				<input type="button" value="삭제" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_delete1.jsp?cpage=<%=cpage %>&seq=<%=seq %>'" />
				<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='board_write1.jsp?cpage=<%=cpage %>'" />
			</div>	
		</div>
		<!--//게시판-->
	</div>
<!-- 하단 디자인 -->
</div>

</body>
</html>
