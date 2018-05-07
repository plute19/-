drop table bookReview;
drop table sentenceHit;
drop table bookSentence;
drop table bookHit;
drop table bookInfo;
drop table bookCategory;
drop table hamsterMember;

create table hamsterMember(
	userEmail varchar(30) PRIMARY KEY,
	nickname VARCHAR(30) UNIQUE not NULL,
	userPassword VARCHAR(60) NOT NULL,
	level int(1) DEFAULT 0
);

create table bookCategory(
	category varchar(10) PRIMARY KEY,
	c_name varchar(20) UNIQUE not null,
	updateDate DATETIME
);

create table bookInfo(
	isbn varchar(30) PRIMARY KEY,
	title varchar(256) not NULL,
	author varchar(256) not NULL,
	publisher varchar(256),
	pubdate varchar(20),
	category varchar(10),
	image varchar(260),
	link varchar(200),
	price varchar(10),
	description varchar(600)
);

alter table bookInfo
add CONSTRAINT bookInfo_category_fk
FOREIGN KEY (category) REFERENCES bookCategory (category);

create table bookHit(
	isbn varchar(30) not NULL,
	useremail varchar(30) not NULL,
	hitdate DATETIME DEFAULT now()
);

alter table bookHit
add CONSTRAINT bookHit_useremail_fk
FOREIGN KEY (useremail) REFERENCES hamsterMember (useremail);
alter table bookHit
add CONSTRAINT bookHit_isbn_fk
FOREIGN KEY (isbn) REFERENCES bookInfo (isbn);

create table bookReview(
	reviewnum int PRIMARY KEY AUTO_INCREMENT,
	useremail varchar(30) not NULL,
	isbn varchar(30) not NULL,
	text varchar(300),
	rate int(2) not null,
	inputdate DATETIME DEFAULT now()
);

alter table bookReview
add CONSTRAINT review_useremail_fk
FOREIGN KEY (useremail) REFERENCES hamsterMember (useremail);
alter table bookReview
add CONSTRAINT review_isbn_fk
FOREIGN KEY (isbn) REFERENCES bookInfo (isbn);


create table bookSentence(
	sentencenum int PRIMARY key auto_increment,
	useremail varchar(30) not NULL,
	isbn varchar(30) not null,
	page int(4),
	sentence varchar(300) not NULL,
	inputdate DATETIME DEFAULT now()
);

alter table bookSentence
add CONSTRAINT sentence_useremail_fk
FOREIGN KEY (useremail) REFERENCES hamsterMember (useremail);
alter table bookSentence
add CONSTRAINT sentence_isbn_fk
FOREIGN KEY (isbn) REFERENCES bookInfo (isbn);

create table sentenceHit(
	useremail varchar(30) not null,
	sentencenum int not null,
	hitdate DATETIME DEFAULT now()
);

alter table sentenceHit
add CONSTRAINT sentenceHit_sentencenum_fk
FOREIGN KEY (sentenceNum) REFERENCES bookSentence (sentencenum);
alter table sentenceHit
add CONSTRAINT sentenceHit_useremail_fk
FOREIGN KEY (useremail) REFERENCES hamsterMember (useremail);