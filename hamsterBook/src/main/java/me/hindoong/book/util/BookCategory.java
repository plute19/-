package me.hindoong.book.util;

import java.util.HashMap;

public class BookCategory {

	private HashMap<String, String> bookCategory;
	
	public BookCategory() {
		bookCategory = new HashMap<>();
		
		bookCategory.put("100", "소설");
		bookCategory.put("100010", "나라별소설");
		bookCategory.put("100010010", "한국소설");
		bookCategory.put("100010020", "영미소설");
		bookCategory.put("100010030", "일본소설");
		bookCategory.put("100010040", "중국소설");
		bookCategory.put("100010050", "러시아소설");
		bookCategory.put("100010060", "프랑스소설");
		bookCategory.put("100010070", "독일소설");
		bookCategory.put("100010080", "기타나라소설");
		bookCategory.put("100020", "고전/문학");
		bookCategory.put("100020010", "한국고전소설");
		bookCategory.put("100020020", "세계문학");
		bookCategory.put("100020030", "세계고전");
		bookCategory.put("100030", "장르소설");
		bookCategory.put("100030010", "SF/판타지");
		bookCategory.put("100030020", "추리");
		bookCategory.put("100030030", "전쟁/역사");
		bookCategory.put("100030040", "로맨스");
		bookCategory.put("100030050", "무협");
		bookCategory.put("100030060", "공포/스릴러");
		bookCategory.put("100040", "테마소설");
		bookCategory.put("100040010", "인터넷소설");
		bookCategory.put("100040010", "영화/드라마소설");
		bookCategory.put("100040010", "가족/성장소설");
		bookCategory.put("100040010", "어른을 위한 동화");		
		bookCategory.put("100040010", "라이트 노벨");
		bookCategory.put("330", "만화");
		bookCategory.put("330010", "교양만화");
		bookCategory.put("330020", "드라마");
		bookCategory.put("330030", "성인만화");
		bookCategory.put("330040", "순정만화");
		bookCategory.put("330050", "스포츠만화");
		bookCategory.put("330060", "SF/판타지");
		bookCategory.put("330070", "액션/무협만화");
		bookCategory.put("330080", "명랑/코믹만화");
		bookCategory.put("330090", "공포/추리");
		bookCategory.put("330100", "학원만화");
		bookCategory.put("330110", "웹툰/카툰에세이");
		bookCategory.put("330120", "기타만화");
		bookCategory.put("330130", "일본어판 만화");
		bookCategory.put("330140", "영문판 만화");
	}

	public HashMap<String, String> getBookCategory() {
		
		return bookCategory;
	}
	
	public String searchBookCatecory(String code) {
		
		return bookCategory.get(code);
	}
	
}
