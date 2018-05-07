package me.hindoong.book.service;

import java.util.ArrayList;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import me.hindoong.book.vo.BookInfo;
import me.hindoong.book.vo.Category;

@Repository
public class BookInfoDAO implements BookInfoMapper {

	@Inject
	SqlSession session;
	
	@Override
	public int insertBookInfo(BookInfo bookInfo) {
		
		int result = 0;
		try {
			result = session.getMapper(BookInfoMapper.class).insertBookInfo(bookInfo);
		} catch (Exception e) {
			//e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public int updateBookInfo(Map<String, Object> map) {
		
		return session.getMapper(BookInfoMapper.class).updateBookInfo(map);
	}

	@Override
	public int deleteBookInfo(int isbn) {
		
		return session.getMapper(BookInfoMapper.class).deleteBookInfo(isbn);
	}

	@Override
	public ArrayList<BookInfo> selectBookList(Map<String, Object> map) {
		ArrayList<BookInfo> result = new ArrayList<>();
		try {
			result = session.getMapper(BookInfoMapper.class).selectBookList(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public BookInfo selectBookOne(String isbn) {
		
		return session.getMapper(BookInfoMapper.class).selectBookOne(isbn);
	}

	@Override
	public int selectBookListCount(Map<String, Object> map) {
		
		return session.getMapper(BookInfoMapper.class).selectBookListCount(map);
	}

	@Override
	public int insertBookHit(Map<String, String> map) {
		
		return session.getMapper(BookInfoMapper.class).insertBookHit(map);
	}

	@Override
	public int selectBookHit(Map<String, String> map) {
		
		return session.getMapper(BookInfoMapper.class).selectBookHit(map);
	}

	@Override
	public int insertCategory(Category category) {
		
		return session.getMapper(BookInfoMapper.class).insertCategory(category);
	}

	@Override
	public int updateCategory(Category category) {
		
		return session.getMapper(BookInfoMapper.class).updateCategory(category);
	}

	@Override
	public ArrayList<Category> selectCategory() {
		ArrayList<Category> arr_category = null;
		try {
			arr_category = session.getMapper(BookInfoMapper.class).selectCategory();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return arr_category;
	}

	
}
