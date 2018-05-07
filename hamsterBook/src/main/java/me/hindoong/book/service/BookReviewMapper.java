package me.hindoong.book.service;

import java.util.ArrayList;
import java.util.HashMap;

import me.hindoong.book.vo.BookReview;

public interface BookReviewMapper {
	
	//1. 리뷰 등록
	public int insertBookReview(BookReview bookReview);
	//2. 리뷰 수정
	public int updateBookReview(BookReview bookReview);
	//3. 리뷰 삭제
	public int deleteBookReview(int reviewnum);
	//4. 리뷰 읽기
	public ArrayList<BookReview> selectBookReview(HashMap<String, Object> searchMap);
	//4-1. 리뷰 읽기 - 총 결과 수
	public int selectBookReviewCount(HashMap<String, Object> searchMap);
}
