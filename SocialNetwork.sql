-- DDL = data definision language

drop database if exists sn;
create database sn;
use sn;


drop table if exists sn;
create table users(
	id SERIAL primary key, -- ключевое поле
	firstname varchar(100),
	lastname varchar(100),
	email varchar(100) unique,
	password_hash varchar(100),
	phone varchar (12),
	
	-- индексы:
	index users_phone_idx(phone),
	index users_username_idx(firstname, lastname)
);
	

drop table if exists `profiles`;
create table `profiles`(
	user_id SERIAL primary key,
	gender char(1),
	birthday date,
	photo_id BIGINT unsigned null,
	hometown varchar(100),
	created_at datetime default now()
);

alter table `profiles` add constraint fk_user_id
	-- внешний ключ
	foreign key (user_id) references users(id)
	on update cascade
	on delete restrict
;


drop table if exists messages;
create table messages(
	id SERIAL primary key,
	from_user_id bigint unsigned not null,
	to_user_id bigint unsigned not null,
	body text,
	created_at datetime default now(),
	
	index (from_user_id),
	index (to_user_id),
	foreign key (from_user_id) references users(id),
	foreign key (to_user_id) references users(id)
);


drop table if exists friend_requests;
create table friend_requests(
	initiator_user_id bigint unsigned not null,	
	target_user_id bigint unsigned not null,	
	`status` ENUM('requested', 'approved', 'unfriended', 'declined'),
	created_at datetime default now(),
	updated_at datetime,
	
	primary key (initiator_user_id, target_user_id),
	index (initiator_user_id),
	index(target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
);


-- связь многие ко многим
drop table if exists communities;
create table communities(
	id SERIAL primary key,
	name varchar(200),
	
	index(name)
);

drop table if exists users_communities;
create table users_communities(
user_id bigint unsigned not null,
community_id bigint unsigned not null,

primary key (user_id, community_id),
foreign key (user_id) references users(id),
foreign key (community_id) references communities(id)
);


drop table if exists media_types;
create table media_types(
	id SERIAL primary key,
	name varchar(200),
	created_at datetime default now(),
	updated_at datetime default current_timestamp
);


drop table if exists media;
create table media(
	id SERIAL primary key,
	media_type_id bigint unsigned not null,	
	user_id bigint unsigned not null,	
	body text,
	filename varchar(225),
	`size` int,
	metadata JSON,
	created_at datetime default now(),
	updated_at datetime default current_timestamp on update current_timestamp,
	
	index(user_id),
	foreign key (user_id) references users(id),
	foreign key (media_type_id) references media_types(id)
	
);


drop table if exists `likes`;
create table `likes`(
	id SERIAL primary key,
	user_id bigint unsigned not null,
	media_id bigint unsigned not null,
	created_at datetime default now(),
	
	foreign key (id) references users(id),
	foreign key (id) references media_types(id)

);


drop table if exists photo_albums;
create table photo_albums(
	id SERIAL,
	user_id bigint unsigned not null,
	name varchar(200),

	primary key (id),
	foreign key (user_id) references users(id)
);


drop table if exists photos;
create table photos(
	id SERIAL primary key,
	media_id bigint unsigned not null,
	album_id bigint unsigned not null,

	foreign key (media_id) references media(id),
	foreign key (album_id) references photo_albums(id)
);

-- Домашнее задание
-- Я давно хотел эту фичу в социальной сети, поэтому оторвусь хотя бы тут: расширяем реакции пользователей на лайки, дизлайки и безразличие.:)


drop table if exists `likes`;
create table `likes`(
	id SERIAL primary key,
	user_id bigint unsigned not null,
	media_id bigint unsigned not null,
	created_at datetime default now(),
	
	-- Изменил таблицу с лайками - добавил новое поле
	like_id bigint unsigned not null,
	index(like_id),
	
	foreign key (id) references users(id),
	foreign key (id) references media_types(id)

);

 -- добавляем таблицу с реакциями: лайк, дизлайк, пофиг
drop table if exists type_of_likes;
create table type_of_likes(
	id SERIAL primary key,
	tol_id bigint unsigned not null,
	emotion varchar(200),

	
	 foreign key (tol_id) references likes(like_id)
);


-- Добавляем таблицу со статусом профиля: активный или мёртвый

drop table if exists profile_status;
create table profile_status(
	id SERIAL primary key,
	ps_id bigint unsigned not null,
	index(ps_id),
	staus varchar(200),

	foreign key (ps_id) references profiles(user_id)
);



-- Расширяем доступные медиа

-- Добавляем музыку, складываем в альбомы

drop table if exists music_albums;
create table music_albums(
	id SERIAL,
	user_id bigint unsigned not null,
	name varchar(200),

	primary key (id),
	foreign key (user_id) references users(id)
);


drop table if exists music;
create table music(
	id SERIAL primary key,
	media_id bigint unsigned not null,
	album_id bigint unsigned not null,

	foreign key (media_id) references media(id),
	foreign key (album_id) references music_albums(id)
);


-- Добавляем видео, складываем в альбомы

drop table if exists video_albums;
create table video_albums(
	id SERIAL,
	user_id bigint unsigned not null,
	name varchar(200),

	primary key (id),
	foreign key (user_id) references users(id)
);


drop table if exists videos;
create table videos(
	id SERIAL primary key,
	media_id bigint unsigned not null,
	album_id bigint unsigned not null,

	foreign key (media_id) references media(id),
	foreign key (album_id) references video_albums(id)
);






















