package me.hindoong.book.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import me.hindoong.book.vo.BookInfo;

public class NaverBookSearchApi {

	public static HashMap<String, Object> search(String keyword, String category, int display, int start) {

		/*
		 * 네이버 검색 api는 초당 10번 넘게 요청하면 에러가 난다..
		 * 그래서 일부러 딜레이를 준다......
		 */
		try {
			Thread.sleep(200);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		// total과 bookList가 담길 map
		HashMap<String, Object> resultMap = new HashMap<>();
		// 검색 결과 수
		Long total = 0L;
		// bookinfo가 담길 배열
		ArrayList<BookInfo> bookList = new ArrayList<>();

		String clientId = "71GOnimgLotnpEhuFPa5";// 애플리케이션 클라이언트 아이디값";
		String clientSecret = "uNUDEqtobU";// 애플리케이션 클라이언트 시크릿값";

		try {
			// 검색키워드
			String text = URLEncoder.encode(keyword, "UTF-8");

			String apiURL = "https://openapi.naver.com/v1/search/book_adv?d_titl=" + text + "&d_catg=" + category
					+ "&display=" + display + "&start=" + start;

			URL url = new URL(apiURL);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("X-Naver-Client-Id", clientId);
			con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
			int responseCode = con.getResponseCode();
			BufferedReader br;

			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
				System.out.println("에러 발생 -> " + responseCode + " / " + con.getResponseMessage());
				resultMap.put("error", 1);	//에러가 난 키워드를 보여주기 위해 맵에 담아 보냄.
			}

			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}
			br.close();

			JSONParser parser = new JSONParser();
			JSONObject jsonObj = (JSONObject) parser.parse(response.toString());
			total = (Long) jsonObj.get("total");
			JSONArray bookArray = (JSONArray) jsonObj.get("items");

			BookInfo book = null;

			if (bookArray != null) {
				for (int i = 0; i < bookArray.size(); i++) {
					book = new BookInfo();
					JSONObject tempObj = (JSONObject) bookArray.get(i);

					book.setIsbn(tempObj.get("isbn").toString().replaceAll("<b>", "").replaceAll("</b>", ""));
					book.setTitle(tempObj.get("title").toString().replaceAll("<b>", "").replaceAll("</b>", ""));
					book.setAuthor(tempObj.get("author").toString().replaceAll("<b>", "").replaceAll("</b>", ""));
					book.setPublisher(tempObj.get("publisher").toString().replaceAll("<b>", "").replaceAll("</b>", ""));
					book.setPubdate(tempObj.get("pubdate").toString().replaceAll("<b>", "").replaceAll("</b>", ""));
					book.setImage(tempObj.get("image").toString().replaceAll("<b>", "").replaceAll("</b>", ""));
					book.setLink(tempObj.get("link").toString().replaceAll("<b>", "").replaceAll("</b>", ""));
					book.setPrice(tempObj.get("price").toString());
					book.setDescription(tempObj.get("description").toString().replaceAll("<b>", "")
							.replaceAll("</b>", "").replaceAll("\n", " "));
					book.setCategory(category);

					bookList.add(book);
					book = null;
				}
			}
			resultMap.put("total", total);
			resultMap.put("bookList", bookList);

		} catch (Exception e) {
			e.printStackTrace();

		}
		
		return resultMap;
	}

}
