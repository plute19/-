package me.hindoong.book.service;

import java.util.HashMap;
import java.util.Map;

import me.hindoong.book.vo.HamsterMember;

public interface HamsterMemberMapper {
	
	//1. 회원가입
	public int insertMember(HamsterMember member);
	
	//2. 멤버 한 명 조회
	public HamsterMember selectMemberOne(Map<String, String> map);
	
	//3. 멤버 정보 업데이트
	public int updateMember(HashMap<String, String> map);
	
	//3-1. 이메일 업데이트
	int updateEmail(HashMap<String, String> map);
	
	//4. 멤버 탈퇴
	public int deleteMember(HamsterMember member);
	
	
	
}
