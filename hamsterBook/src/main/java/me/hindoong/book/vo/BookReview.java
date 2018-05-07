package me.hindoong.book.vo;

public class BookReview {
	
	private int reviewNum;
	private String userEmail;
	private String isbn;
	private String text;
	private int rate;
	private String inputDate;
	private String nickname;
	 
	public BookReview() {}

	public BookReview(int reviewNum, String userEmail, String isbn, String text, int rate, String inputDate,
			String nickname) {
		super();
		this.reviewNum = reviewNum;
		this.userEmail = userEmail;
		this.isbn = isbn;
		this.text = text;
		this.rate = rate;
		this.inputDate = inputDate;
		this.nickname = nickname;
	}

	public int getReviewNum() {
		return reviewNum;
	}

	public void setReviewNum(int reviewNum) {
		this.reviewNum = reviewNum;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getIsbn() {
		return isbn;
	}

	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public int getRate() {
		return rate;
	}

	public void setRate(int rate) {
		this.rate = rate;
	}

	public String getInputDate() {
		return inputDate;
	}

	public void setInputDate(String inputDate) {
		this.inputDate = inputDate;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	@Override
	public String toString() {
		return "BookReview [reviewNum=" + reviewNum + ", userEmail=" + userEmail + ", isbn=" + isbn + ", text=" + text
				+ ", rate=" + rate + ", inputDate=" + inputDate + ", nickname=" + nickname + "]";
	}

	
}
