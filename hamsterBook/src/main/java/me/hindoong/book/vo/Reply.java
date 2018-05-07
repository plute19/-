package me.hindoong.book.vo;

public class Reply {

	private int replynum;
	private int boardnum;
	private String nickname;
	private String replyText;
	private String inputdate;
	
	public Reply() {}

	public Reply(int replynum, int boardnum, String nickname, String replyText, String inputdate) {
		super();
		this.replynum = replynum;
		this.boardnum = boardnum;
		this.nickname = nickname;
		this.replyText = replyText;
		this.inputdate = inputdate;
	}

	public int getReplynum() {
		return replynum;
	}

	public void setReplynum(int replynum) {
		this.replynum = replynum;
	}

	public int getBoardnum() {
		return boardnum;
	}

	public void setBoardnum(int boardnum) {
		this.boardnum = boardnum;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getReplyText() {
		return replyText;
	}

	public void setReplyText(String replyText) {
		this.replyText = replyText;
	}

	public String getInputdate() {
		return inputdate;
	}

	public void setInputdate(String inputdate) {
		this.inputdate = inputdate;
	}

	@Override
	public String toString() {
		return "Reply [replynum=" + replynum + ", boardnum=" + boardnum + ", nickname=" + nickname + ", replyText="
				+ replyText + ", inputdate=" + inputdate + "]";
	}

	
}
