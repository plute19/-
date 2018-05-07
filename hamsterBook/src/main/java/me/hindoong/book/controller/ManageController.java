package me.hindoong.book.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import me.hindoong.book.service.BookInfoDAO;
import me.hindoong.book.util.BookCategory;
import me.hindoong.book.util.Hangul;
import me.hindoong.book.util.NaverBookSearchApi;
import me.hindoong.book.vo.BookInfo;
import me.hindoong.book.vo.Category;

@RequestMapping(value = "manage")
@Controller
public class ManageController {
	@Inject
	private BookInfoDAO dao;

	private static final Logger logger = LoggerFactory.getLogger(ManageController.class);

	// 책 정보 추가
	@ResponseBody
	@RequestMapping(value = "/insertBookInfo", method = RequestMethod.POST)
	public HashMap<String, String> insertBookInfo(String category) {
		
		//반환할 맵
		HashMap<String, String> resultMap = new HashMap<>();
		int result = 0;	//추가된 책 정보
		int display = 100;	//한 번에 조회할 데이터
		int start = 1;	//검색 시작 지점
		int total = 0;	// 검색 결과 수
		String failText = "";	//검색 중 오류 발생한 키워드
		ArrayList<BookInfo> bookList = null;	//검색 결과를 담을 리스트
		int count = 0;	//작업이 몇 번 이루어졌는지 저장할 변수
		
		//한글 조합을 불러온다.
		ArrayList<String> hangluList = new Hangul().hangulList();

		System.out.println("검색 예상 횟수 -> " + hangluList.size());

		for (int i = 0; i < hangluList.size(); i++) {
			
			HashMap<String, Object> map = NaverBookSearchApi.search(hangluList.get(i), category, display, start);
			
			//검색 중 에러가 난 경우 해당 키워드를 표시.
			if (map == null || map.containsKey("error")) {
				failText += hangluList.get(i);
				continue;
			}
			
			total = ((Long)map.get("total")).intValue();			
			bookList = (ArrayList<BookInfo>) map.get("bookList");
			
			try {
				for (BookInfo bookInfo : bookList) {
					result += dao.insertBookInfo(bookInfo);
				}
				count++;
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			if (total > display) {
				// T	ODO 검색 결과가 100이 넘는 경우 start = 101로 해서 추가로 받아와야 함
				for (int j = 101; j < total; j += display) {
					map = null;
					map = NaverBookSearchApi.search(hangluList.get(i), category, display, j);
					
					bookList = (ArrayList<BookInfo>) map.get("bookList");

					try {
						for (BookInfo bookInfo : bookList) {
							result += dao.insertBookInfo(bookInfo);
						}			
						count++;
					} catch (Exception e) {
						//e.printStackTrace();
					}
				}
			}			
		}
		
		Category c = new Category();
		c.setCategory(category);
		
		int updateDate = dao.updateCategory(c);
		
		resultMap.put("updateRow", result+"");
		resultMap.put("updateDate", updateDate+"");
		resultMap.put("fail", failText);
		
		return resultMap;
	}
	
	// 책 카테고리 설정
	@ResponseBody
	@RequestMapping(value = "/insertCategory", method = RequestMethod.POST)
	public int insertCategory() {

		int result = 0;
		
		for (String key : new BookCategory().getBookCategory().keySet()) {
			Category category = new Category();
			category.setCategory(key);
			category.setC_name(new BookCategory().getBookCategory().get(key));
			try {
				result += dao.insertCategory(category);
			} catch (Exception e) {
			}
			
		}
		
		return result;
	}
	
	// 업데이트 일자 조회, 카테고리 별 책 권수 조회
	@ResponseBody
	@RequestMapping(value = "/selectCategory", method = RequestMethod.POST)
	public ArrayList<Category> selectCategory() {

		ArrayList<Category> categories = new ArrayList<>();
		
		try {
			categories = dao.selectCategory();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return categories;
	}
}
