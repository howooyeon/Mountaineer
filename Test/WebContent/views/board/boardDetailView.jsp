<%@page import="board.model.vo.Board"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
   Board b = (Board)request.getAttribute("b");
   // 글번호, 글제목, 글내용, 해시태그, 조회수, 닉네임, 말머리, 작성일자, 댓글수, 작성자유저번호
   
   String[] hashtagList = new String[20];
   
   if(b.getHashtag() != null){
   String hashtag = b.getHashtag().trim().replaceAll(" ", "");
   hashtagList = hashtag.split(",");            
   }
   
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 - MOUNTAINEER</title>
 <!-- jQuery library -->
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>

<style>
        .outer{
            width: 1200px;
            margin: auto;
            margin-top: 50px;
            box-sizing: border-box;
            /* border: 1px solid black; */
        }
        .wrap{
            width: 800px; 
            /* border: 1px solid red; */
            margin: auto;
            font-family: 'NanumBarunGothic';
            overflow: hidden;
        }
        #header, #bar {
            border: none;
            border-bottom: 2px solid lightgray;
            padding: 10px;
            padding-bottom: 7px;
            margin-top: 20px;
        }
        
        #header>*{margin: 15px;}
        #h_etc{margin-bottom: 2px;}
        #subject{font-size: 20px; color: rgb(149, 193, 31);}
        #title{font-size: 40px;}
        #writer{font-size: 20px;}
        #h_etc{font-style: 10px; color: gray;}

        #content{
            padding: 15px;
            padding-top: 30px;
            font-size: 20px;
            line-height: 35px;
            /* border: 1px solid black; */
            margin-bottom: 30px;
        }
   
      #content-img{
            margin-bottom: 100px;
      }
       #content-img>img{
            border: 1px solid rgb(219, 219, 219);
            margin:10px;
        }
   
        #h_etc>span, #bar>span, #cmt_etc>span{margin-right: 10px;}
        #comment{
            padding: 20px;
          
        }
        
        .comment-area1{
            border: none;
            background-color: rgb(244, 244, 244);
            padding: 10px;
            margin-top: 10px;
        }
        .comment-area1>*{margin: 5px;}
        .cmt_id{font-size: 15px; font-weight: bold;}
        .cmt_txt{margin-top: 10px; margin-bottom: 10px; font-size: 14px;}
        .cmt_etc{font-size: 12px; color: gray;}
        #comment-area2{
            border: 1px solid gray;
            border-radius: 5px;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 30px;
        }
        #cmt_btn{
            padding-right: 10px;
        }
        #cmt_btn>button{
            border: none;
            width: 60px;
            height: 30px;
            font-family: 'NanumBarunGothic';
        }

        #reportBoard{
            font-family: 'NanumBarunGothic';
        }

        #bar>button{
            border: none;
            background-color: rgba(0, 0, 0, 0);
            font-size: 14px;
        }
        .hashtag{
            display: inline-block;
            border: 1px solid lightgray;
            padding: 10px;
            padding-top: 5px;
            padding-bottom: 5px;
            border-radius: 10%;
            color:white;
            background-color: rgb(190, 188, 188);
            margin-right: 4px;
            font-size: 15px;
        }

        #hashtag{
            padding-left: 10px;
        }
        
        .modal-body>form>p{
            margin: 10px;
        }

        .deleteReply-btn{
            margin: 0;
            color: tomato;
            margin-top: 5px;
            cursor: pointer;
        }

        #link>a{
            /* border: 1px solid black; */
            border-radius: 5px;
            display: inline-block;
            padding: 10px;
            background-color: rgb(149, 193, 31);
            color: white;
            font-weight: bold;
            margin: 5px;
            margin-top: 20px;
            font-size: 17px;
        }
        #writer:hover{
            cursor: pointer;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div id="topbtn"></div>
   <%@ include file="../common/menubar.jsp" %>
    <div class="outer">
        <div class="wrap">
            <div id="header">
                <div id="subject"><%= b.getCategory() %></div>
                <div id="title"><%= b.getBoardTitle() %></div>
                <div id="writer"onclick="userProfile(<%= b.getUserNo()%>)"><%= b.getBoardWriter() %></div>
                <div id="h_etc">
                    <span><%= b.getCreateDate() %></span>
                    <span>조회수 <%= b.getCount() %></span>
                </div>
                
            </div>
            <div id="content">
               <%= b.getBoardContent() %>
            </div>
            
            <div id="content-img">
               
            </div>
            
            <div id="hashtag">
            <%if(hashtagList[0] != null){ %>
                <% for(int i=0; i<hashtagList.length; i++){ %>
                    <div class="hashtag">
                        # <%= hashtagList[i] %>
                    </div>
                <%} %>
            <%}else{ %>
               <div></div>
            <%} %>
            </div>
            
            <%if(loginMember == null){ %>
            <div id="bar" align="right"></div>
            <%}else if(loginMember.getUserNo() == b.getUserNo()){%>
            <div id="bar" align="right"><button style="color:tomato;" onclick="deleteBoard();">글 삭제</button><button style="color:rgb(58,58,58);" onclick="updateBoard();">글 수정</button></div>
            <%}else if(loginMember.getUserNo() == 1){ %>
            <div id="bar" align="right"><button style="color:tomato;" onclick="deleteBoard();">글 삭제</button></div>
            <%}else{ %>
            <div id="bar" align="right">
                <button type="button" data-toggle="modal" data-target="#reportBoard">신고</button>
                <button id="like1" onclick="insertLike();">🤍 <span class="countLike" style="font-size:15px;">0</span></button>
                <button id="like2" style="display: none;" onclick="deleteLike();">💚 <span class="countLike" style="font-size:15px;"></span></button>
                <button id="bookmark1" onclick="insertBook();"><img src="resources/image/bookmark_blank.png" width="25" height="25"></button>
                <button id="bookmark2" onclick="deleteBook();" style="display: none;"><img src="resources/image/bookmark.png" width="25" height="25"></button>
            </div>
            <%} %>
            
            <div id="comment">
                <b>댓글 <span id="countReply">보기와 작성은 로그인 후 가능합니다</span></b>
                <div id="comment-area2">
                    <form action="<%= contextPath %>/insertReply.bo" method="post">
                    </form>
                        <textarea id="rContent" style="resize: none; border: none; width: 95%; height: 50px;" placeholder="댓글을 입력하세요" required></textarea>
                        <div id="cmt_btn" align="right">
                            <button type="reset">취소</button>
                            <%if(loginMember != null){ %>
                            <input name="userNo" type="hidden" value="<%= loginMember.getUserNo()%>">
                            <button type="button" onclick="insertReply();">등록</button>
                            <%}else{ %>
                            <button type="submit" disabled>등록</button>
                            <%} %>
                        </div>
                </div>
                <div id="comment-list">
                    
                    
                </div>
                <div id="link" align="center">
                    <a href="<%= contextPath%>/listView.bo">목록가기</a> <a href="#topbtn">TOP</a>
                </div>
            </div>
        </div>
    </div>

    <script>
    function userProfile(userNo) {
        // userNo를 사용하여 URL을 생성
        location.href = '<%= contextPath %>/feedProfile.me?userNo=' + userNo;

      }
       let bno = "B<%= b.getBoardNo()%>";
      <% if(loginMember != null){%>
         let userNo = "<%= loginMember.getUserNo()%>";
    
       // ----- 좋아요 관련 -----------
        function insertLike(){
            
              $.ajax({
               url:"like.bo",
               data:{boardNo:bno, userNo:userNo},
               success:function(result){
                   
                   if(result == 'Y'){
                      $("#like1").css("display", "none");
                       $("#like2").css("display", "");
                      likeCount(); 
                   }
               },
               error:function(){
                   
               }
              })
               
        }
        
        function deleteLike(){
            
                $.ajax({
                     url:"likeDelete.bo",
                     data:{boardNo:bno, userNo:userNo},
                     success:function(result){
                         
                         if(result == 'Y'){
                            $("#like2").css("display", "none");
                             $("#like1").css("display", "");
                            likeCount();
                         }
                     },
                     error:function(){
                        
                     }
                    })
          
        }
        
        
   
      // ----- 북마크 관련 -----------

        function insertBook(){
            
              $.ajax({
               url:"book.bo",
               data:{boardNo:bno, userNo:userNo},
               success:function(result){
                   
                   if(result == 'Y'){
                      $("#bookmark1").css("display", "none");
                       $("#bookmark2").css("display", "");
                   }
               },
               error:function(){
                  
               }
              })
               
        }

        function deleteBook(){
            
              $.ajax({
               url:"deleteBook.bo",
               data:{boardNo:bno, userNo:userNo},
               success:function(result){
                   
                   if(result == 'Y'){
                      $("#bookmark1").css("display", "");
                       $("#bookmark2").css("display", "none");
                   }
               },
               error:function(){
                   
               }
              })
               
        }
        
        function likeCount(){
           
           $.ajax({
              url:"countLike.bo",
              data:{boardNo:bno},
              success:function(count){
                 $(".countLike").text(count);
              }
           })
        }
        
        $(function(){
           selectReplyList();
           likeCount();
               
        // 북마크, 좋아요 체크 함수
               $.ajax({
                   url:"likeCheck.bo",
                   data:{boardNo:bno, userNo:userNo},
                   success:function(result){
                       ;
                       if(result == 'Y'){
                          $("#like2").css("display", "");
                           $("#like1").css("display", "none");
                       }else{
                          $("#like2").css("display", "none");
                           $("#like1").css("display", "");                       
                       }
                   },
                   error:function(result){
                       
                   }
               })
               
               $.ajax({
                   url:"bookCheck.bo",
                   data:{boardNo:bno, userNo:userNo},
                   success:function(result){
                       ;
                       if(result == 'Y'){
                          $("#bookmark2").css("display", "");
                           $("#bookmark1").css("display", "none");
                       }else{
                          $("#bookmark2").css("display", "none");
                           $("#bookmark1").css("display", "");                       
                       }
                   },
                   error:function(result){
                       
                   }
               })
               
               
        })   
        
          function selectReplyList(){
             
              // 오늘날짜
            let today = new Date();
            let year = today.getFullYear();
            let month = ('0' + (today.getMonth() + 1)).slice(-2);
            let day = ('0' + today.getDate()).slice(-2);         
            let dateString = year + '/' + month  + '/' + day;
           
             // 댓글 리스트
               let charHtml = "";
               
               $.ajax({
                  url:"replyList.bo",
                  data:{boardNo:bno},
                  success:function(list){
                    
                     for(let i=0; i<list.length; i++){
                        charHtml += "<div class='comment-area1'>"
                                + "<div class='cmt_id'>" + list[i].replyWriter + "</div>"
                                + "<div class='cmt_txt'>" + list[i].replyContent + "</div>";
                            if('20' + list[i].createDate.substr(0,8) == dateString){
                        charHtml += "<div class='cmt_etc'>" + list[i].createDate.substr(9);
                            }else{
                        charHtml += "<div class='cmt_etc'>" + list[i].createDate;       
                            }
                             if(userNo == list[i].userNo){
                                charHtml += "<p class='deleteReply-btn' onclick='deleteReply($(this));'>삭제</p>"
                                         + "<input type='hidden' value='" + list[i].replyNo + "'>"
                                        + "</div></div>"; 
                             }else{
                                charHtml += "</div></div>";
                             }
                                
                     }
                     
                     $("#comment-list").html(charHtml);
                     
                  },
                  error:function(){
                  }
                  
               })
               
               // 댓글 갯수
               $.ajax({
                  url:"countReply.bo",
                  data:{boardNo:bno},
                  success:function(result){
                     $("#countReply").text(result);
                  },
                  error:function(){
                  }
               })
             }
          
       
       <%}%> 
       
       // 댓글 작성 함수
       function insertReply(){
          
          $.ajax({
             url:"insertReply.bo",
             data:{
                comment:$("#rContent").val(),
                boardNo:bno
             },
             type:"post",
             success:function(result){
                if(result > 0){
                   selectReplyList();
                   $("#rContent").val("");
                }
             }
             
          })
       }
       
       
        // 댓글 삭제 함수
      function deleteReply(e){
           let replyNo = e.next().val();
           
           if(confirm("댓글을 삭제하시겠습니까?")){
              $.ajax({
                 url:"deleteReply.bo",
                 data:{rno:replyNo},
                 success:function(result){
                    if(result > 0){
                       selectReplyList();
                    }
                 },
                 error:function(){
               
                 }
              })
           }
     
        }
        
        // 게시글 삭제 함수
        function deleteBoard(){
           
           if(confirm("해당 게시글을 삭제하시겠습니까?")){
              location.href = "<%= contextPath %>/delete.bo?bno=" + bno;
           }
           
        }
        
        // 게시글 수정 함수
        function updateBoard(){
         location.href="<%= contextPath%>/updateView.bo?bno="+<%= b.getBoardNo()%>;           
        }
        
        
        
        // 게시글 사진 불러오는 함수
        $(function(){
           
           $.ajax({
              url:"list.img",
              data:{boardNo:bno},
            success:function(imgList){
               if(imgList.length > 0){
                  let inputHtml = "";
                  let contextPath = "<%= contextPath %>";
                  for(let i=0; i<imgList.length; i++){
                     inputHtml += "<img src='" + contextPath + "/" + imgList[i].filePath + "/" + imgList[i].changeName + "' width='500' height='500'>"; 
                  }
                     
                  $("#content-img").html(inputHtml);
               }else{
               }
            },
            error:function(){
            }
           })
           
        })
        
    </script>

    <div class="modal" id="reportBoard">
        <div class="modal-dialog">
          <div class="modal-content">
      
            <!-- Modal Header -->
            <div class="modal-header">
              <h4 class="modal-title"><b>신고하기</b></h4>
              <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
      
            <!-- Modal body -->
            <div class="modal-body">
              <form action="<%= contextPath %>/reportBoard.bo" method="post">
                <p>작성자 : <%= b.getBoardWriter() %> </p>
                <p>글 제목 : <%= b.getBoardTitle() %> </p>
                
                <input name="bno" type="hidden" value="B<%= b.getBoardNo() %>">
                <input name="reportedUserNo" type="hidden" value="<%= b.getUserNo()%>">
                <% if(loginMember != null){ %>
                <input name="reportUserNo" type="hidden" value="<%= loginMember.getUserNo()%>">
                <%} %>
                <hr>
                
                    <input type="radio" id="r1" name="report" value="영리목적/홍보성">
                    <label for="r1">영리목적/홍보성</label><br>
                    <input type="radio" id="r2" name="report" value="욕설/인신공격">
                    <label for="r2">욕설/인신공격</label> <br>
                    <input type="radio" id="r3" name="report" value="도배">
                    <label for="r3">같은 내용 반복(도배)</label> <br>
                    <input type="radio" id="r4" name="report" value="개인정보노출">
                    <label for="r4">개인정보노출</label> <br>
                    <input type="radio" id="r5" name="report" value="불법정보">
                    <label for="r5">불법정보</label><br>
                    <input type="radio" id="r6" name="report" value="음란성/선정성">
                    <label for="r6">음란성/선정성</label> <br>
        
                <textarea name="reportContent" style="resize: none;" placeholder=" 신고 사유 설명이 필요하신 경우 작성해주세요." cols="50" rows="3" style="margin: 20px;"></textarea>
                <br><button type="submit" class="btn btn-secondary" id="rpt_btn" style="width: 100%; height: 40px; margin-top: 15px;">신고</button>
              </form>
            </div>
  
         </div>
            
        </div>
    </div>
    
    <%@ include file="../common/footerbar.jsp" %>
</body>
</html>