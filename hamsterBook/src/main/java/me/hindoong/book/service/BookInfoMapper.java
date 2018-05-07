package me.hindoong.book.service;

import java.util.ArrayList;
import java.util.Map;

import me.hindoong.book.vo.BookInfo;
import me.hindoong.book.vo.Category;

public interface BookInfoMapper {
	
	//1. 책 정보 등록
	public int insertBookInfo(BookInfo bookInfo);
	//2. 책 정보 수정
	public int updateBookInfo(Map<String, Object> map);
	//3. 책 정보 삭제
	public int deleteBookInfo(int isbn);
	//4. 책 정보 조회(여러 건)
	public ArrayList<BookInfo> selectBookList(Map<String, Object> map);
	//4-1. 책 정보 조회(여러 건) - 총 결과 수
	public int selectBookListCount(Map<String, Object> map);
	//5. 책 정보 조회(하나)
	public BookInfo selectBookOne(String isbn);
	//6. 카테고리 설정
	public int insertCategory(Category category);
	//6-1. 카테고리 업데이트 일자 입력
	public int updateCategory(Category category);
	//6-2. 카테고리 조회
	public ArrayList<Category> selectCategory();
	//7. 좋아요 추가
	public int insertBookHit(Map<String, String> map);
	//8. 좋아요 확인(중복 좋아요 방지)
	public int selectBookHit(Map<String, String> map);
}
