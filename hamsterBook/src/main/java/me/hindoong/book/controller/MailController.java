package me.hindoong.book.controller;

import java.util.Random;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import me.hindoong.book.service.MailService;
import me.hindoong.book.vo.HamsterMember;

@Controller
public class MailController {
	
	@Inject
    private MemberController memberService;
    
    @Inject
    private MailService mailService;
 
    // 회원가입 이메일 인증
    @ResponseBody
    @RequestMapping(value = "sendMail/sendCode", method = RequestMethod.POST, produces = "application/json")  
    public String sendMailAuth(HttpSession session, String userEmail) {
        	String result = "";
        	
    		int ran = new Random().nextInt(100000) + 10000; // 10000 ~ 99999
        String joinCode = String.valueOf(ran);
        session.setAttribute("joinCode", joinCode);
        session.setAttribute("joinEmail", userEmail);
 
        String subject = "회원가입 인증 코드 발급 안내 입니다.";
        StringBuilder sb = new StringBuilder();
        sb.append("귀하의 인증 코드는 " + joinCode + " 입니다.");
        
        if(mailService.send(subject, sb.toString(), "plute19@gmail.com", userEmail, null)) {
        		result = "send";
        } else {
        		result = "fail";
        }
        return result;
    }
 
    // 비밀번호 찾기
    @ResponseBody
    @RequestMapping(value = "sendMail/password", method = RequestMethod.POST)
    public String sendMailPassword(HttpSession session, String userEmail) {
    		
        HamsterMember member = null; 
        		
        	try {
			member = memberService.selectMemberOne("userEmail", userEmail);
		} catch (Exception e) {
		}
        	
        String result = "";
        
        if (member != null) {
        	
            int ran = new Random().nextInt(100000) + 10000; // 10000 ~ 99999
            String password = String.valueOf(ran);
            member.setUserPassword(password);
            
            //회원 정보 수정에 실패한 경우 바로 리턴함.
            if (memberService.updateMember(member, session) != 1) {
				return "fail";
			}
 
            String subject = "임시 비밀번호 발급 안내 입니다.";
            StringBuilder sb = new StringBuilder();
            sb.append("귀하의 임시 비밀번호는 " + password + " 입니다.");
            mailService.send(subject, sb.toString(), "plute19@gmail.com", userEmail, null);
            result = "send";
        } else {
            result = "fail";
        }
        
        return result;
    }
}
