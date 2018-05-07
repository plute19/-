package me.hindoong.book.vo;

public class HamsterMember {
	
	private String userEmail;
	private String userPassword;
	private String nickname;
	private int level;
	
	public HamsterMember() {}

	public HamsterMember(String userEmail, String userPassword, String nickname, int level) {
		super();
		this.userEmail = userEmail;
		this.userPassword = userPassword;
		this.nickname = nickname;
		this.level = level;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getUserPassword() {
		return userPassword;
	}

	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	@Override
	public String toString() {
		return "HamsterMember [userEmail=" + userEmail + ", userPassword=" + userPassword + ", nickname=" + nickname
				+ ", level=" + level + "]";
	}

	
}
