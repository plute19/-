package me.hindoong.book.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import me.hindoong.book.service.BookInfoDAO;
import me.hindoong.book.service.BookReviewDAO;
import me.hindoong.book.util.PageNavigator;
import me.hindoong.book.vo.BookInfo;
import me.hindoong.book.vo.BookReview;

@RequestMapping(value = "book")
@Controller
public class BookController {

	@Inject
	private BookInfoDAO dao;
	
	@Inject
	private BookReviewDAO reviewDao;
	
	// 책 목록 조회
	@ResponseBody
	@RequestMapping(value = "/getBookList", method= {RequestMethod.POST, RequestMethod.GET})
	public HashMap<String, Object> selectBookInfo(String limit, String page, String searchOption, String keyword,
			String category, String orderOption, String period, String myPage, HttpSession session) {
		
		// 한 번에 가져올 결과
		int selectLimit = 0;
		// 보여줄 페이지
		int selectPage = 0;
		// 건너 뛸 결과
		int offset = 0;
		
		try {
			if (limit == null) limit = "10";
			selectLimit = Integer.parseInt(limit);
		} catch (Exception e) {
			selectLimit = 10;			
		}
		
		try {
			if (page == null) page = "1";
			selectPage = Integer.parseInt(page);
		} catch (Exception e) {
			selectPage = 1;
		}
		
		offset = (selectPage - 1 ) * selectLimit;
		
		HashMap<String, Object> searchMap = new HashMap<>();
		searchMap.put("offset", offset);
		searchMap.put("limit", selectLimit);
		
		// 검색 설정
		if (keyword != null &&keyword.length() > 0) {
			//검색을 하는 경우
			searchMap.put("searchOption", searchOption);
			searchMap.put("keyword", keyword);
		}
		
		//정렬 순서
		if (orderOption != null && orderOption.length() > 0) {
			// 정렬 순서를 지정한 경우
			searchMap.put("orderOption", orderOption);
		}
		
		// 기간 설정
		if (period != null && period.length() > 0) {
			// 기간을 지정한 경우(기간은 일 단위)
			searchMap.put("period", period);
		}
		
		// 마이페이지에서 요청한 것인지 여부
		if (myPage != null && myPage.length() > 0) {
			// 기간을 지정한 경우(기간은 일 단위)
			searchMap.put("myPage", myPage);
			searchMap.put("userEmail", (String)session.getAttribute("userEmail"));
		}
		
		ArrayList<BookInfo> bookList = null;
		int totalRecordsCount = 0;
		
		try {
			bookList = (ArrayList<BookInfo>) dao.selectBookList(searchMap);
			totalRecordsCount = dao.selectBookListCount(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
				
		HashMap<String, Object> resultMap = new HashMap<>();
		PageNavigator pageNav = new PageNavigator(selectLimit, 10, selectPage, totalRecordsCount);
		
		resultMap.put("bookList", bookList);
		resultMap.put("page", page);	
		resultMap.put("totalRecords", totalRecordsCount);
		resultMap.put("totalPage", pageNav.getTotalPageCount());
		resultMap.put("currentGroup", pageNav.getCurrentGroup());
		resultMap.put("startPage", pageNav.getStartPageGroup());
		resultMap.put("endPage", pageNav.getEndPageGroup());
		
		return resultMap;
	}
	
	// 책 리스트... 가져오기
	@RequestMapping(value = "/info", method = RequestMethod.GET)
	public String readBookInfo(String isbn, Model model) {
		
		//isbn을 안 들고 왔으면 홈으로..
		if (isbn == null) {
			return "../";
		}
		
		//결과를 담을 맵
		HashMap<String, Object> resultMap = new HashMap<>();
		
		BookInfo book = null;
		
		try {
			book  = dao.selectBookOne(isbn);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		resultMap.put("book", book);
		
		model.addAttribute("book", book);
		
		return "book/book";
	}
	
	//TODO 이거랑 위 메소드랑 뭐가 다른 건지 확인할 것.
	@RequestMapping(value="/list", method= {RequestMethod.GET, RequestMethod.POST })
	public String bookList(String page, String searchOption, String keyword,
			String category, String orderOption, Model model) {

		// 보여줄 페이지
		int selectPage = 0;
		// 건너 뛸 결과
		int offset = 0;
		// 한 번에 보여줄 책
		int limit = 12;
		
		try {
			if (page == null) page = "1";
			selectPage = Integer.parseInt(page);
		} catch (Exception e) {
			selectPage = 1;
		}
		
		offset = (selectPage - 1 ) * limit;
		
		HashMap<String, Object> searchMap = new HashMap<>();
		searchMap.put("offset", offset);
		searchMap.put("limit", limit);
		
		//검색을 하는 경우
		if (keyword != null &&keyword.length() > 0) {		
			searchMap.put("searchOption", searchOption);
			searchMap.put("keyword", keyword);
		}
		
		//정렬 순서
		if (orderOption != null &&orderOption.length() > 0) {		
			searchMap.put("orderOption", orderOption);
		}
		
		ArrayList<BookInfo> bookList = null;
		int totalRecordsCount = 0;
		
		try {
			bookList = (ArrayList<BookInfo>) dao.selectBookList(searchMap);
			totalRecordsCount = dao.selectBookListCount(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
				
		HashMap<String, Object> resultMap = new HashMap<>();
		PageNavigator pageNav = new PageNavigator(limit, 10, selectPage, totalRecordsCount);
		
		resultMap.put("bookList", bookList);
		resultMap.put("page", selectPage);	
		resultMap.put("totalRecords", totalRecordsCount);
		resultMap.put("totalPage", pageNav.getTotalPageCount());
		resultMap.put("currentGroup", pageNav.getCurrentGroup());
		resultMap.put("startPage", pageNav.getStartPageGroup());
		resultMap.put("endPage", pageNav.getEndPageGroup());
		resultMap.put("keyword", keyword);
		resultMap.put("searchOption", searchOption);
		
		model.addAttribute("resultMap", resultMap);
		
		return "book/list";
	}
	
	@ResponseBody
	@RequestMapping(value="/getReview", method=RequestMethod.POST)
	public HashMap<String, Object> getReview(String limit, String page, String searchOption, String keyword,
			String category, String orderOption, String period, HttpSession session) {
		
		// 한 번에 가져올 결과
		int selectLimit = 0;
		// 보여줄 페이지
		int selectPage = 0;
		// 건너 뛸 결과
		int offset = 0;
		
		try {
			if (limit == null) limit = "10";
			selectLimit = Integer.parseInt(limit);
		} catch (Exception e) {
			selectLimit = 10;			
		}
		
		try {
			if (page == null) page = "1";
			selectPage = Integer.parseInt(page);
		} catch (Exception e) {
			selectPage = 1;
		}
		
		offset = (selectPage - 1 ) * selectLimit;
		
		HashMap<String, Object> searchMap = new HashMap<>();
		searchMap.put("offset", offset);
		searchMap.put("limit", selectLimit);
		
		// 검색 설정
		if (keyword != null &&keyword.length() > 0) {
			//검색을 하는 경우
			searchMap.put("searchOption", searchOption);
			searchMap.put("keyword", keyword);
		}
		
		//정렬 순서
		if (orderOption != null && orderOption.length() > 0) {
			// 정렬 순서를 지정한 경우
			searchMap.put("orderOption", orderOption);
		}
		
		// 기간 설정
		if (period != null && period.length() > 0) {
			// 기간을 지정한 경우(기간은 일 단위)
			searchMap.put("period", period);
		}
		
		int totalRecordsCount = 0;
		ArrayList<BookReview> reviewList = null;		
		
		try {
			reviewList = reviewDao.selectBookReview(searchMap);		
			totalRecordsCount = reviewDao.selectBookReviewCount(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		PageNavigator pageNav = new PageNavigator(selectLimit, 10, selectPage, totalRecordsCount);
		HashMap<String, Object> resultMap = new HashMap<>();
		
		resultMap.put("reviewList", reviewList);
		resultMap.put("page", selectPage);	
		resultMap.put("totalRecords", totalRecordsCount);
		resultMap.put("totalPage", pageNav.getTotalPageCount());
		resultMap.put("currentGroup", pageNav.getCurrentGroup());
		resultMap.put("startPage", pageNav.getStartPageGroup());
		resultMap.put("endPage", pageNav.getEndPageGroup());
		
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/insertReview", method=RequestMethod.POST)
	public int insertReview(BookReview review, HttpSession session) {
		
		int result = 0;

		String userEmail = (String)session.getAttribute("userEmail");
		
		review.setUserEmail(userEmail);
		
		try {
			result = reviewDao.insertBookReview(review);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/updateBookInfo", method=RequestMethod.POST)
	public int insertReview(BookInfo book, String keyword) {
		
		HashMap<String, Object> searchMap = new HashMap<>();
		
		int result = 0;
		
		if (keyword == null) {
			return 0;
		} else {
			searchMap.put("keyword", keyword);
			searchMap.put("book", book);
		}
		
		try {
			result = dao.updateBookInfo(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/getBookInfo", method = RequestMethod.POST)
	public BookInfo getBookInfo(String isbn) {
		
		//isbn을 안 들고 왔으면 홈으로..
		if (isbn == null) {
			return null;
		}
		
		BookInfo book = null;
		
		try {
			book  = dao.selectBookOne(isbn);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return book;
	}
	
	@ResponseBody
	@RequestMapping(value = "/insertBookHit", method = RequestMethod.POST)
	public int insertBookHit(String isbn, HttpSession session) {
		
		//isbn을 안 들고 왔으면 홈으로..
		if (isbn == null) {
			return 0;
		}
		
		int result = 0;

		String userEmail = (String)session.getAttribute("userEmail");
		
		HashMap<String, String> searchMap = new HashMap<>();
		
		searchMap.put("isbn", isbn);
		searchMap.put("userEmail", userEmail);
		
		try {
			result  = dao.insertBookHit(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/selectBookHit", method = RequestMethod.POST)
	public int selectBookHit(String isbn, HttpSession session) {
		
		//isbn을 안 들고 왔으면 홈으로..
		if (isbn == null) {
			return 1;
		}
		
		// 1일 경우 이미 좋아요를 한 상태, 0일 경우 좋아요 한 적이 없는 상태
		int result = 1;

		String userEmail = (String)session.getAttribute("userEmail");
		
		HashMap<String, String> searchMap = new HashMap<>();
		
		searchMap.put("isbn", isbn);
		searchMap.put("userEmail", userEmail);
		
		try {
			result  = dao.selectBookHit(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
}
