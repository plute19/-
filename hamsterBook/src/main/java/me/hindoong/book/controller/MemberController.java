package me.hindoong.book.controller;

import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import me.hindoong.book.service.HamsterMemberDAO;
import me.hindoong.book.vo.HamsterMember;

@RequestMapping(value = "member")
@Controller
public class MemberController {

	@Inject
	private HamsterMemberDAO dao;
	
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	//로그인 폼으로 이동
	@RequestMapping(value = "/loginForm", method = {RequestMethod.GET, RequestMethod.POST})
	public String loginForm() {

		return "member/loginForm";
	}
	
	//회원가입 폼으로 이동
	@RequestMapping(value = "/joinForm", method = RequestMethod.GET)
	public String joinForm() {

		return "member/joinForm";
	}
	
	//마이 페이지로 이동
	@RequestMapping(value = "/myPage", method = RequestMethod.GET)
	public String myPage(HttpSession session) {
		
		String userEmail = (String) session.getAttribute("userEmail");
		int level = selectMemberOne("userEmail", userEmail).getLevel();
		
		if (level == 9) {
			//관리자 페이지로 이동
			return "manage/admin";
		}

		return "member/myPage";
	}
	
	//1. 회원가입
	@ResponseBody
	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public int insertMember(HamsterMember member, HttpSession session) {
		
		int result = 0;
		
		String hashpassword = BCrypt.hashpw(member.getUserPassword(), BCrypt.gensalt());
		member.setUserPassword(hashpassword);
		
		try {
			result = dao.insertMember(member);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if (result == 1) {
			session.removeAttribute("joinEmail");
			session.setAttribute("userEmail", member.getUserEmail());
			session.setAttribute("userNickname", member.getNickname());
		}
		
		return result;
	}
	
	//2. 회원조회
	@ResponseBody
	@RequestMapping(value = "/selectMemberOne", method = RequestMethod.POST)
	public HamsterMember selectMemberOne(String keyword, String value) {
		
		HamsterMember result = null;
		HashMap<String, String> map = new HashMap<String, String>();
		
		if (keyword != null && value != null) {
			map.put("keyword", keyword);
			map.put("value", value);
			
			try {
				result = dao.selectMemberOne(map);
				if (result == null) {
					result = new HamsterMember("", "", "", 0);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	//3. 회원수정
	@ResponseBody
	@RequestMapping(value = "/updateMember", method = RequestMethod.POST)
	public int updateMember(HamsterMember member, HttpSession session) {
		
		int result = 0;
		
		String password = BCrypt.hashpw(member.getUserPassword(), BCrypt.gensalt());
		
		HashMap<String, String> map = new HashMap<>();
		map.put("userEmail", member.getUserEmail());
		map.put("nickname", member.getNickname());
		map.put("userPassword", password);
		
		try {
			
			result = dao.updateMember(map);
			
			//전송받은 password의 길이가 6 이하일 경우 비밀번호 찾기로 설정된 임시비밀번호이므로 session에 기록하지 않는다.
			if (result == 1 && member.getUserPassword().length() > 6) {
				session.setAttribute("userEmail", member.getUserEmail());
				session.setAttribute("userNickname", member.getNickname());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	//3-1. 이메일 수정
	@ResponseBody
	@RequestMapping(value = "/updateEmail", method = RequestMethod.POST)
	public int updateEmail(HttpSession session, String UserEmail, String beforeUserEmail) {
		
		int result = 0;
		
		HashMap<String, String> map = new HashMap<>();
		map.put("userEmail", UserEmail);
		map.put("beforeUserEmail", beforeUserEmail);
		
		try {
			
			result = dao.updateEmail(map);
			
			if (result == 1) {
				session.setAttribute("userEmail", UserEmail);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	//4. 로그아웃
	@ResponseBody
	@RequestMapping(value = "/logout", method = RequestMethod.POST)
	public int logout(String userEmail, HttpSession session) {
		
		try {
			session.removeAttribute("userEmail");
			session.removeAttribute("userNickname");
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		
	}
	
	//5. 로그인(ajax)
	@ResponseBody
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public int login(HamsterMember member, HttpSession session) {
		
		System.out.println("로그인 시도.. ->" + member);
		
		int result = 0;
		HamsterMember DBMember = null;
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("keyword", "userEmail");
		map.put("value", member.getUserEmail());
		
		try {
			System.out.println("in try");
			
			DBMember = dao.selectMemberOne(map);
			
			if (DBMember != null) {
				//존재하는 계정
				
				System.out.println("exist in db");
				
				logger.debug(DBMember.toString());
				if (BCrypt.checkpw(member.getUserPassword(), DBMember.getUserPassword())) {
					//로그인 성공
					System.out.println("login success");
					
					session.setAttribute("userEmail", DBMember.getUserEmail());
					session.setAttribute("userNickname", DBMember.getNickname());
					
					result = 1;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	//6. 중복 체크(ajax)
	@ResponseBody
	@RequestMapping(value = "/duplicateCheck", method = RequestMethod.POST)
	public int duplicateCheck(String userEmail, String nickname) {
		
		// 가입 불가능한 계정이거나 검증이 안 될 경우 1을 리턴. 가입 가능할 경우 0을 리턴
		int result = 1;
		
		if (userEmail == null && nickname == null) {
			return result;
		}
		
		HashMap<String, String> searchMap = new HashMap<>();
		
		if (userEmail == null) {
			// 닉네임 검사 요청
			searchMap.put("keyword", "nickname");
			searchMap.put("value", nickname);
		} else {
			// 이메일 검사 요청
			searchMap.put("keyword", "userEmail");
			searchMap.put("value", userEmail);
		}
		try {
			HamsterMember member = dao.selectMemberOne(searchMap);
			if (member == null) {
				//가입가능
				result = 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	//7. 회원 탈퇴
	@ResponseBody
	@RequestMapping(value = "/deleteMember", method = RequestMethod.POST)
	public int deleteMember(HamsterMember member, HttpSession session) {
		
		int result = 0;
		HamsterMember DBMember = null;
		HashMap<String, String> map = new HashMap<>();
		map.put("keyword", "userEmail");
		map.put("value", member.getUserEmail());
		
		
		try {
			
			DBMember = dao.selectMemberOne(map);
			
			if (DBMember != null) {
				//존재하는 계정
				
				if (BCrypt.checkpw(member.getUserPassword(), DBMember.getUserPassword())) {
					//비밀번호 일치
					
					result = dao.deleteMember(DBMember);
				}
				if (result == 1) {
					session.removeAttribute("userEmail");
					session.removeAttribute("userNickname");
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		
		
		return result;
	}

	//이메일 인증 코드 검증
	@ResponseBody
	@RequestMapping(value="/submitCode", method = RequestMethod.POST)
	public String joinCodeCheck(String userCode, HttpSession session) {
		
		String sendCode = (String) session.getAttribute("joinCode");
		if (userCode.equals(sendCode)) {
			return "ok";   
		} else {
			return "no";
		}
	}

	
	

}
