package me.hindoong.book.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import me.hindoong.book.vo.BookSentence;

@Repository
public class BookSentenceDAO implements BookSentenceMapper {

	@Inject
	SqlSession session;

	@Override
	public int insertBookSentence(BookSentence sentence) {
		
		return session.getMapper(BookSentenceMapper.class).insertBookSentence(sentence);
	}

	@Override
	public int updateBookSentence(BookSentence sentence) {
		
		return session.getMapper(BookSentenceMapper.class).updateBookSentence(sentence);
	}

	@Override
	public int deleteBookSentence(int reviewnum) {
		
		return session.getMapper(BookSentenceMapper.class).deleteBookSentence(reviewnum);
	}

	@Override
	public ArrayList<BookSentence> selectBookSentence(HashMap<String, Object> searchMap) {
		
		return session.getMapper(BookSentenceMapper.class).selectBookSentence(searchMap);
	}

	@Override
	public int selectBookSentenceCount(HashMap<String, Object> searchMap) {
		
		return session.getMapper(BookSentenceMapper.class).selectBookSentenceCount(searchMap);
	}

	@Override
	public int insertSentenceHit(Map<String, String> map) {
		
		return session.getMapper(BookSentenceMapper.class).insertSentenceHit(map);
	}

	@Override
	public int selectSentenceHit(Map<String, String> map) {
		
		return session.getMapper(BookSentenceMapper.class).selectSentenceHit(map);
	}
	
	
	
}
