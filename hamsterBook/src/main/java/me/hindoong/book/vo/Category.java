package me.hindoong.book.vo;

public class Category {

	private String category;
	private String c_name;
	private String updateDate;
	private int volume;
	
	public Category() {}

	public Category(String category, String c_name, String updateDate, int volume) {
		super();
		this.category = category;
		this.c_name = c_name;
		this.updateDate = updateDate;
		this.volume = volume;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getC_name() {
		return c_name;
	}

	public void setC_name(String c_name) {
		this.c_name = c_name;
	}

	public String getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}

	public int getVolume() {
		return volume;
	}

	public void setVolume(int volume) {
		this.volume = volume;
	}

	@Override
	public String toString() {
		return "Category [category=" + category + ", c_name=" + c_name + ", updateDate=" + updateDate + ", volume="
				+ volume + "]";
	}
	
	
	
}
