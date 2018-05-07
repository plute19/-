package me.hindoong.book.service;

import java.util.ArrayList;
import java.util.Map;

import me.hindoong.book.vo.Reply;
import me.hindoong.book.vo.Board;

public interface BoardMapper {
	
	// 1. 게시글 등록
	public int insertBoard(Board b);
	
	// 2. 게시글 읽기
	public ArrayList<Board> selectBoardList(Map<String, Object> map);
	
	// 3. 게시글 하나 읽기
	public Board selectBoardOne(int boardnum);
	
	// 4. 조회수 수정
	public int addHits(int boardnum);
	
	// 5. 게시글 수정
	public int updateBoard(Board b);
	
	// 6. 게시글 삭제
	public int deleteBoard(Board board);
 
	// 7. 게시글 개수 조회
	public int boardCount(Map<String, Object> map);
	
	// 8. 댓글 조회
	public ArrayList<Reply> selectReplyList(int boardnum);
	
	// 9. 댓글 등록
	public int insertReply(Reply r);
	
	// 10. 댓글 삭제
	public int deleteReply(int replynum);
}