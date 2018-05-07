package me.hindoong.book.service;

import java.util.ArrayList;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import me.hindoong.book.vo.Board;
import me.hindoong.book.vo.Reply;

@Repository
public class BoardDAO implements BoardMapper {

	@Inject
	SqlSession session;

	@Override
	public int insertBoard(Board b) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).insertBoard(b);
	}

	@Override
	public ArrayList<Board> selectBoardList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).selectBoardList(map);
	}

	@Override
	public Board selectBoardOne(int boardnum) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).selectBoardOne(boardnum);
	}

	@Override
	public int addHits(int boardnum) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).addHits(boardnum);
	}

	@Override
	public int updateBoard(Board b) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).updateBoard(b);
	}

	@Override
	public int deleteBoard(Board board) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).deleteBoard(board);
	}

	@Override
	public int boardCount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).boardCount(map);
	}

	@Override
	public ArrayList<Reply> selectReplyList(int boardnum) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).selectReplyList(boardnum);
	}

	@Override
	public int insertReply(Reply r) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).insertReply(r);
	}

	@Override
	public int deleteReply(int replynum) {
		// TODO Auto-generated method stub
		return session.getMapper(BoardMapper.class).deleteReply(replynum);
	}
	
	
	
}
