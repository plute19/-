package me.hindoong.book.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import me.hindoong.book.service.BookSentenceDAO;
import me.hindoong.book.util.PageNavigator;
import me.hindoong.book.vo.BookSentence;

@RequestMapping(value = "sentence")
@Controller
public class SentenceController {

	@Inject
	private BookSentenceDAO dao;
	
	@ResponseBody
	@RequestMapping(value = "/getSentenceList", method= {RequestMethod.POST, RequestMethod.GET})
	public HashMap<String, Object> getSentenceList(String limit, String page, String searchOption, String keyword,
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
		
		//검색을 하는 경우
		if (keyword != null &&keyword.length() > 0) {			
			searchMap.put("searchOption", searchOption);
			searchMap.put("keyword", keyword);
		}
		
		//정렬 순서
		if (orderOption != null &&orderOption.length() > 0) {
			//검색을 하는 경우
			searchMap.put("orderOption", orderOption);
		}
		
		//기간 설정
		if (period != null &&period.length() > 0) {
			searchMap.put("period", period);
		}
		
		// 마이페이지에서 요청한 것인지 여부
		if (myPage != null && myPage.length() > 0) {
			searchMap.put("myPage", myPage);
			searchMap.put("userEmail", (String)session.getAttribute("userEmail"));
		}
	
		
		ArrayList<BookSentence> sentenceList = null;
		int totalRecordsCount = 0;
		
		try {
			sentenceList = (ArrayList<BookSentence>) dao.selectBookSentence(searchMap);
			totalRecordsCount = dao.selectBookSentenceCount(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
				
		HashMap<String, Object> resultMap = new HashMap<>();
		PageNavigator pageNav = new PageNavigator(selectLimit, 10, selectPage, totalRecordsCount);
		
		resultMap.put("sentenceList", sentenceList);
		resultMap.put("page", page);	
		resultMap.put("totalRecords", totalRecordsCount);
		resultMap.put("totalPage", pageNav.getTotalPageCount());
		resultMap.put("currentGroup", pageNav.getCurrentGroup());
		resultMap.put("startPage", pageNav.getStartPageGroup());
		resultMap.put("endPage", pageNav.getEndPageGroup());
		
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/insertSentence", method=RequestMethod.POST)
	public int insertSentence(BookSentence sentence, HttpSession session) {
		
		int result = 0;

		String userEmail = (String)session.getAttribute("userEmail");
		
		sentence.setUserEmail(userEmail);
		
		try {
			result = dao.insertBookSentence(sentence);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/updateBookSentence", method=RequestMethod.POST)
	public int updateBookSentence(BookSentence sentence) {
		
		int result = 0;
		
		try {
			result = dao.updateBookSentence(sentence);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/insertSentenceHit", method = RequestMethod.POST)
	public int insertSentenceHit(String sentenceNum, HttpSession session) {
		
		//isbn을 안 들고 왔으면 실패..
		if (sentenceNum == null) {
			return 0;
		}
		
		int result = 0;

		String userEmail = (String)session.getAttribute("userEmail");
		
		HashMap<String, String> searchMap = new HashMap<>();
		
		searchMap.put("sentenceNum", sentenceNum);
		searchMap.put("userEmail", userEmail);
		
		try {
			result  = dao.insertSentenceHit(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/selectSentenceHit", method = RequestMethod.POST)
	public int selectSentenceHit(String sentenceNum, HttpSession session) {
		
		//isbn을 안 들고 왔으면 실패..
		if (sentenceNum == null) {
			return 1;
		}
		
		// 1일 경우 이미 좋아요를 한 상태, 0일 경우 좋아요 한 적이 없는 상태
		int result = 1;

		String userEmail = (String)session.getAttribute("userEmail");
		
		HashMap<String, String> searchMap = new HashMap<>();
		
		searchMap.put("sentenceNum", sentenceNum);
		searchMap.put("userEmail", userEmail);
		
		try {
			result  = dao.selectSentenceHit(searchMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
}
