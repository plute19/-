package me.hindoong.book.vo;

public class BookSentence {

	private int sentenceNum;
	private String userEmail;
	private String isbn;
	private int page;
	private String sentence;
	private String inputDate;
	private String nickname;
	private int hit;
	private String title;
	private String author;
	private String image;
	private String hitdate;
	
	public BookSentence() {}

	public BookSentence(int sentenceNum, String userEmail, String isbn, int page, String sentence, String inputDate,
			String nickname, int hit, String title, String author, String image, String hitdate) {
		super();
		this.sentenceNum = sentenceNum;
		this.userEmail = userEmail;
		this.isbn = isbn;
		this.page = page;
		this.sentence = sentence;
		this.inputDate = inputDate;
		this.nickname = nickname;
		this.hit = hit;
		this.title = title;
		this.author = author;
		this.image = image;
		this.hitdate = hitdate;
	}

	public int getSentenceNum() {
		return sentenceNum;
	}

	public void setSentenceNum(int sentenceNum) {
		this.sentenceNum = sentenceNum;
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

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public String getSentence() {
		return sentence;
	}

	public void setSentence(String sentence) {
		this.sentence = sentence;
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

	public int getHit() {
		return hit;
	}

	public void setHit(int hit) {
		this.hit = hit;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getHitdate() {
		return hitdate;
	}

	public void setHitdate(String hitdate) {
		this.hitdate = hitdate;
	}

	@Override
	public String toString() {
		return "BookSentence [sentenceNum=" + sentenceNum + ", userEmail=" + userEmail + ", isbn=" + isbn + ", page="
				+ page + ", sentence=" + sentence + ", inputDate=" + inputDate + ", nickname=" + nickname + ", hit="
				+ hit + ", title=" + title + ", author=" + author + ", image=" + image + ", hitdate=" + hitdate + "]";
	}

	
}
