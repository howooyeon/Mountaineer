package member.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import member.model.vo.Attachment;
import member.model.service.MemberService;
import member.model.vo.Member;

/**
 * Servlet implementation class profileView
 */
@WebServlet("/feedProfile.me")
public class feedProfileVIew extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public feedProfileVIew() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		

		Integer userNo = (Integer) session.getAttribute("userNo");
		if (userNo == null) {
		    userNo =   Integer.parseInt(request.getParameter("userNo"));
		}

		
		
		MemberService mService = new MemberService();
		Member m = mService.selectProfile(userNo);
		ArrayList<Attachment> list = mService.selectProfileImg(String.valueOf(userNo));
		
		
		request.getSession().setAttribute("m", m);

		request.setAttribute("m", m);
		request.setAttribute("list", list);
		request.getRequestDispatcher("views/mypage/feedProfile.jsp").forward(request, response);
    
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
