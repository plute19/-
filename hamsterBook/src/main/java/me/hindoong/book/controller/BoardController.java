package me.hindoong.book.controller;

import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import me.hindoong.book.service.BoardDAO;
import me.hindoong.book.util.FileService;
import me.hindoong.book.vo.Board;
import me.hindoong.book.vo.Reply;

/**
 * Handles requests for the application home page.
 */
@RequestMapping(value = "board")
@Controller
public class BoardController {
	
	@Inject
	private BoardDAO dao;
	
	//업로드 경로
	// 아래처럼 "/boardfile"이라고만 쓰면 c:\boardfile 가 됨.
	// 맥에서는 /Users/username.../ 아래로 저장하자... 바로 /를 쓰고 디렉토리를 쓰면.. root에 저장된다...
	private final String UPLOAD_PATH = "/var/lib/tomcat8/webapps/upload/";
	private final String UPLOAD_PATH_mac = "/Users/insect/hindoong_upload";
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	//게시글목록으로 이동
	@RequestMapping(value = "/list", method = {RequestMethod.GET, RequestMethod.POST })
	public String list(Model model, String page, String limit,
			String option, String keyword) {
		
		Integer limit1;
		Integer page1;
		
		try {
			if (limit == null) limit = "10";
			limit1 = Integer.parseInt(limit);
		} catch (Exception e) {
			limit1 = 10;			
		}
		
		try {
			if (page == null) page = "1";
			page1 = Integer.parseInt(page);
		} catch (Exception e) {
			page1 = 1;
		}

		int offset = 0;
		
		try {
			offset = (page1 - 1 ) * limit1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		HashMap<String, Object> search = new HashMap<>();
		search.put("offset", offset);
		search.put("limit", limit1);
		
		if (option != null && keyword != null) {
			//검색을 하는 경우
			search.put("searchOption", option);
			search.put("keyword", keyword);
		} else {
			//검색을 하지 않는 경우
			search.put("searchOption", "none");

		}
		
		ArrayList<Board> list = (ArrayList<Board>) dao.selectBoardList(search);
		
		if (list != null) {
			//조회 결과 검색 결과가 존재함
			int countboard = dao.boardCount(search);
			model.addAttribute("list", list);
			model.addAttribute("page", page);
			model.addAttribute("totalBoard", countboard);
			model.addAttribute("startPage", ( page1 - 1) / 10 * 10 + 1);
			int endPage =  ( ( countboard-1) / limit1 ) + 1;
			model.addAttribute("endPage", endPage);
			model.addAttribute("endPageStart", (((endPage-1) / 10) * 10) + 1);
		}

		return "board/list";
	}
	
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public String writeForm() {
		
		return "board/write";
	}
	
	@RequestMapping(value = "/insertBoard", method = RequestMethod.POST)
	public String boardWrite(Board board, MultipartFile upload) {
		
		String text = board.getContent().replaceAll("\r\n", "<br>");
		board.setContent(text);
		
		if (!upload.isEmpty()) {
			
			
			String savedfile = FileService.saveFile(upload, UPLOAD_PATH);
			String originalfile = upload.getOriginalFilename();
			
			board.setSavedfile(savedfile);
			board.setOriginalfile(originalfile);
		}
		
		dao.insertBoard(board);
		
		return "redirect:list";
	}
	
	@RequestMapping(value = "/read", method = RequestMethod.GET)
	public String readBoard(int boardnum, Model model) {
		
		try {
			dao.addHits(boardnum);
			Board board = dao.selectBoardOne(boardnum);
			model.addAttribute("board", board);
			model.addAttribute("reply", dao.selectReplyList(boardnum));
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("읽기 실패");
		}
		
		return "board/read";
	}
	
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String updateBoardForm(Model model, int boardnum) {
		
		try {
			Board board = dao.selectBoardOne(boardnum);
			String text = board.getContent().replaceAll("<br>", "\r\n");
			board.setContent(text);
			model.addAttribute("board", board);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("수정창 이동 중 오류 발생");
		}
		
		return "board/update";
	}
	
	@RequestMapping(value = "/updateBoard", method = RequestMethod.POST)
	public String updateBoard(Board board, RedirectAttributes ra, MultipartFile upload) {

		try {
			String text = board.getContent().replaceAll("\r\n", "<br>");
			board.setContent(text);
			
			// 기존에 파일을 등록했던 게시글임
			if (board.getSavedfile().length() > 0) {	
				// 서버에 저장된 기존 파일 삭제
				FileService.deleteFile(UPLOAD_PATH + "/" + board.getSavedfile());
				board.setSavedfile(null);
				board.setOriginalfile(null);
			}
			// 수정 시 파일을 첨부함
			if (upload != null && !upload.isEmpty()) {
				// 파일 새로 등록
				System.out.println("파일 새로 등록...");
				String savedfile = FileService.saveFile(upload, UPLOAD_PATH);
				String originalfile = upload.getOriginalFilename();
					
				board.setSavedfile(savedfile);
				board.setOriginalfile(originalfile);
			}
			System.out.println("결과는 -> " + dao.updateBoard(board));
			ra.addFlashAttribute("updateResult", true);
		} catch (Exception e) {
			ra.addFlashAttribute("updateResult", false);
		}

		return "redirect:resultPage";
	}
	
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String deleteBoard(Board board, Model model) {

		try {
			dao.deleteBoard(board);
			FileService.deleteFile(UPLOAD_PATH + "/" + board.getSavedfile()); 
			model.addAttribute("deleteResult", true);
		} catch (Exception e) {
 			e.printStackTrace();
			model.addAttribute("deleteResult", false);
		}

		return "board/resultPage";
	}
	
	@RequestMapping(value = "/insertReply", method = RequestMethod.POST)
	public String insertReply(Reply reply) {
		try {
			dao.insertReply(reply);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "redirect:read?boardnum=" +reply.getBoardnum();
	}
	
	
	@RequestMapping(value = "/download", method = RequestMethod.GET)
	public String download(Integer boardnum, HttpServletResponse response) {
		
		// 1. 글 정보 수집
		Board board = dao.selectBoardOne(boardnum);
		
		if (board == null) {
			return "redirect:/";
		}
		
		// 2. 저장된 파일명 & 실제 파일명
		String savedfile = board.getSavedfile();
		String originalfile = board.getOriginalfile();
		
		// 3. response의 header를 수정
		try {
			// key: value 형식임..
			response.setHeader("Content-Disposition", "attachment;filename=" 
					+ URLEncoder.encode(originalfile, "UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String fullpath = UPLOAD_PATH + "/" + savedfile;
		
		// 4. 스트림을 가지고 와서 파일을 전송..
		FileInputStream fis = null;
		ServletOutputStream sos = null;
		try {
			fis = new FileInputStream(fullpath);
			sos = response.getOutputStream();
			
			FileCopyUtils.copy(fis, sos);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (sos != null) {
				try {
					sos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		return null;
	}
	
	@RequestMapping(value = "/resultPage", method = RequestMethod.GET)
	public String resultPage() {


		return "board/resultPage";
	}
	
}
