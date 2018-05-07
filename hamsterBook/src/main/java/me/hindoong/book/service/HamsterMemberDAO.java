package me.hindoong.book.service;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import me.hindoong.book.vo.HamsterMember;

@Repository
public class HamsterMemberDAO implements HamsterMemberMapper {

	@Inject
	private SqlSession session;

	//1. 멤버 가입
	@Override
	public int insertMember(HamsterMember member) {
		
		int result = 0;
		
		try {
			result = session.getMapper(HamsterMemberMapper.class).insertMember(member);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	//2. 멤버 조회
	@Override
	public HamsterMember selectMemberOne(Map<String, String> map) {
		
		return session.getMapper(HamsterMemberMapper.class).selectMemberOne(map);
	}

	//3. 멤버 수정
	@Override
	public int updateMember(HashMap<String, String> map) {
		
		return session.getMapper(HamsterMemberMapper.class).updateMember(map);
	}
	
	//3-1. 이메일 수정
	@Override
	public int updateEmail(HashMap<String, String> map) {
		
		return session.getMapper(HamsterMemberMapper.class).updateEmail(map);
	}

	//4. 멤버 탈퇴
	@Override
	public int deleteMember(HamsterMember member) {
		
		return session.getMapper(HamsterMemberMapper.class).deleteMember(member);
	}

	

	
}
