package me.hindoong.book.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import me.hindoong.book.vo.BookSentence;

public interface BookSentenceMapper {
	
	//1. 문장 등록
	public int insertBookSentence(BookSentence sentence);
	//2. 문장 수정
	public int updateBookSentence(BookSentence sentence);
	//3. 문장 삭제
	public int deleteBookSentence(int reviewnum);
	//4. 문장 읽기
	public ArrayList<BookSentence> selectBookSentence(HashMap<String, Object> searchMap);
	//4-1. 문장 읽기 - 총 결과 수
	public int selectBookSentenceCount(HashMap<String, Object> searchMap);
	//5. 문장 추천
	public int insertSentenceHit(Map<String, String> map);
	//6. 문장 추천 조회(중복 추천 방지)
	public int selectSentenceHit(Map<String, String> map);
}
