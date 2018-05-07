package me.hindoong.book.vo;

public class BookInfo {

	private String isbn;
	private String title;
	private String author;
	private String publisher;
	private String pubdate;
	private String image;
	private String link;
	private String category;
	private String price;
	private String description;
	private int hit;
	private String hitdate;
	
	public BookInfo() {}

	public BookInfo(String isbn, String title, String author, String publisher, String pubdate, String image,
			String link, String category, String price, String description, int hit, String hitdate) {
		super();
		this.isbn = isbn;
		this.title = title;
		this.author = author;
		this.publisher = publisher;
		this.pubdate = pubdate;
		this.image = image;
		this.link = link;
		this.category = category;
		this.price = price;
		this.description = description;
		this.hit = hit;
		this.hitdate = hitdate;
	}

	public String getIsbn() {
		return isbn;
	}

	public void setIsbn(String isbn) {
		this.isbn = isbn;
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

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getPubdate() {
		return pubdate;
	}

	public void setPubdate(String pubdate) {
		this.pubdate = pubdate;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getHit() {
		return hit;
	}

	public void setHit(int hit) {
		this.hit = hit;
	}

	public String getHitdate() {
		return hitdate;
	}

	public void setHitdate(String hitdate) {
		this.hitdate = hitdate;
	}

	@Override
	public String toString() {
		return "BookInfo [isbn=" + isbn + ", title=" + title + ", author=" + author + ", publisher=" + publisher
				+ ", pubdate=" + pubdate + ", image=" + image + ", link=" + link + ", category=" + category + ", price="
				+ price + ", description=" + description + ", hit=" + hit + ", hitdate=" + hitdate + "]";
	}

	
	
}
