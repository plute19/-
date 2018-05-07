package me.hindoong.book.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		HttpSession session = request.getSession();
		if (session.getAttribute("userEmail") == null) {
			// 로그인 정보가 없음
			if (isAjaxRequest(request)) {
				//ajax 호출임
				 response.sendError(999);
                 return false;
			} else {
				response.sendRedirect("../");
				return false;
			}
			
		} else {
			if (isAjaxRequest(request)) {
				//ajax 호출임
                 return true;
			} else {
				super.preHandle(request, response, handler);
				return true;
			}
		}

		
	}

	private boolean isAjaxRequest(HttpServletRequest req) {
		String header = req.getHeader("AJAX");
		if ("true".equals(header)) {
			return true;
		} else {
			return false;
		}
	}

}
