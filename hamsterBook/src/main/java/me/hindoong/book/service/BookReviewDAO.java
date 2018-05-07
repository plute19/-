package me.hindoong.book.service;

import java.util.ArrayList;
import java.util.HashMap;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import me.hindoong.book.vo.BookReview;

@Repository
public class BookReviewDAO implements BookReviewMapper {

	@Inject
	SqlSession session;
	
	@Override
	public int insertBookReview(BookReview bookReview) {
		
		return session.getMapper(BookReviewMapper.class).insertBookReview(bookReview);
	}

	@Override
	public int updateBookReview(BookReview bookReview) {
		
		return session.getMapper(BookReviewMapper.class).updateBookReview(bookReview);
	}

	@Override
	public int deleteBookReview(int reviewnum) {
		
		return session.getMapper(BookReviewMapper.class).deleteBookReview(reviewnum);
	}

	@Override
	public ArrayList<BookReview> selectBookReview(HashMap<String, Object> searchMap) {
		
		return session.getMapper(BookReviewMapper.class).selectBookReview(searchMap);
	}

	@Override
	public int selectBookReviewCount(HashMap<String, Object> searchMap) {
		// 
		return session.getMapper(BookReviewMapper.class).selectBookReviewCount(searchMap);
	}

	
}
