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



-- Набор данных предварительно собирал в Excel - в нем удобнее работать с множеством идентичных "рандомных" строк.
-- Заполняем таблицу Users

insert into users 
VALUES 
(2,'User','Random','USER2@mail.ru','USER2','89261234562'), 
(3,'User','Random','USER3@mail.ru','USER3','89261234563'), 
(4,'User','Random','USER4@mail.ru','USER4','89261234564'), 
(5,'User','Random','USER5@mail.ru','USER5','89261234565'), 
(6,'User','Random','USER6@mail.ru','USER6','89261234566'), 
(7,'User','Random','USER7@mail.ru','USER7','89261234567'), 
(8,'User','Random','USER8@mail.ru','USER8','89261234568'), 
(9,'User','Random','USER9@mail.ru','USER9','89261234569'), 
(10,'User','Random','USER10@mail.ru','USER10','892612345610'), 
(11,'User','Random','USER11@mail.ru','USER11','892612345611')
;

insert into users_communities
values
(2,2), 
(3,3), 
(4,4), 
(5,5), 
(6,6), 
(7,7), 
(8,8), 
(9,9), 
(10,10), 
(11,11)
;

insert into communities 
VALUES 
(2,'Running'), 
(3,'Swimming'), 
(4,'Ciclyng'), 
(5,'Football'), 
(6,'Hockey'), 
(7,'Baseball'), 
(8,'Tennis'), 
(9,'Judo'), 
(10,'Eating'), 
(11,'Sleaping')
;

insert into profiles
values
(2,'M','1990-01-01',2,'Moscow','2019-12-22'), 
(3,'W','1990-01-04',3,'Colorado','2019-12-22'), 
(4,'M','1990-01-08',4,'New York','2019-12-22'), 
(5,'W','1990-01-13',5,'Habarovsk','2019-12-22'), 
(6,'M','1990-01-19',6,'Tula','2019-12-22'), 
(7,'W','1990-01-26',7,'Perm','2019-12-22'), 
(8,'M','1990-02-03',8,'Saratov','2019-12-22'), 
(9,'W','1990-02-12',9,'Krasnoyarsk','2019-12-22'), 
(10,'M','2009-02-22',10,'Omsk','2019-12-22'), 
(11,'W','2010-03-05',11,'Tutuevo','2019-12-22')
;

insert into profile_status
values
(2,2,'active'), 
(3,3,'active'), 
(4,4,'active'), 
(5,5,'active'), 
(6,6,'active'), 
(7,7,'active'), 
(8,8,'active'), 
(9,9,'active'), 
(10,10,'active'), 
(11,11,'active')
;

insert into messages
values
(1,2,3,'Hi, User 3','2019-12-22'),
(2,4,5,'Hi, User 5','2019-12-22'),
(3,6,7,'Hi, User 7','2019-12-22'),
(4,8,9,'Hi, User 9','2019-12-22'),
(5,10,11,'Hi, User 11','2019-12-22'),
(6,2,4,'Hi, User 4','2019-12-22'),
(7,4,7,'Hi, User 7','2019-12-23'),
(8,6,9,'Hi, User 9','2019-12-23'),
(9,8,11,'Hi, User 11','2019-12-24'),
(10,10,4,'Hi, User 4','2019-12-25')
;

insert into friend_requests
values
(2,3,'requested','2019-12-22','2019-12-23'),
(4,5,'requested','2019-12-22','2019-12-23'),
(6,7,'requested','2019-12-22','2019-12-23'),
(8,9,'requested','2019-12-22','2019-12-23'),
(10,11,'requested','2019-12-22','2019-12-23'),
(2,4,'requested','2019-12-22','2019-12-23'),
(4,7,'requested','2019-12-22','2019-12-23'),
(6,9,'requested','2019-12-22','2019-12-23'),
(8,11,'requested','2019-12-22','2019-12-23'),
(10,4,'requested','2019-12-22','2019-12-23')
;



insert into media_types
values
(1,'image1','2019-12-22','2019-12-22'),
(2,'image2','2019-12-22','2019-12-22'),
(3,'image3','2019-12-22','2019-12-22'),
(4,'image4','2019-12-22','2019-12-22'),
(5,'image5','2019-12-22','2019-12-22'),
(6,'image6','2019-12-22','2019-12-22'),
(7,'image7','2019-12-22','2019-12-22'),
(8,'image8','2019-12-22','2019-12-22'),
(9,'image9','2019-12-22','2019-12-22'),
(10,'image10','2019-12-22','2019-12-22'),
(11,'video11','2019-12-22','2019-12-22'),
(12,'video12','2019-12-22','2019-12-22'),
(13,'video13','2019-12-22','2019-12-22'),
(14,'video14','2019-12-22','2019-12-22'),
(15,'video15','2019-12-22','2019-12-22'),
(16,'video16','2019-12-22','2019-12-22'),
(17,'video17','2019-12-22','2019-12-22'),
(18,'video18','2019-12-22','2019-12-22'),
(19,'video19','2019-12-22','2019-12-22'),
(20,'video20','2019-12-22','2019-12-22'),
(21,'music21','2019-12-22','2019-12-22'),
(22,'music22','2019-12-22','2019-12-22'),
(23,'music23','2019-12-22','2019-12-22'),
(24,'music24','2019-12-22','2019-12-22'),
(25,'music25','2019-12-22','2019-12-22'),
(26,'music26','2019-12-22','2019-12-22'),
(27,'music27','2019-12-22','2019-12-22'),
(28,'music28','2019-12-22','2019-12-22'),
(29,'music29','2019-12-22','2019-12-22'),
(30,'music30','2019-12-22','2019-12-22')
;

insert into media
values
(1,1,2,'Images','image1',10,'{"image": "jpg", "size": "10mb"}','2019-12-22','2019-12-22'),
(2,2,3,'Images','image2',11,'{"image": "jpg", "size": "11mb"}','2019-12-22','2019-12-22'),
(3,3,4,'Images','image3',12,'{"image": "jpg", "size": "12mb"}','2019-12-22','2019-12-22'),
(4,4,5,'Images','image4',13,'{"image": "jpg", "size": "13mb"}','2019-12-22','2019-12-22'),
(5,5,6,'Images','image5',14,'{"image": "jpg", "size": "14mb"}','2019-12-22','2019-12-22'),
(6,6,7,'Images','image6',15,'{"image": "jpg", "size": "15mb"}','2019-12-22','2019-12-22'),
(7,7,8,'Images','image7',16,'{"image": "jpg", "size": "16mb"}','2019-12-22','2019-12-22'),
(8,8,9,'Images','image8',17,'{"image": "jpg", "size": "17mb"}','2019-12-22','2019-12-22'),
(9,9,10,'Images','image9',18,'{"image": "jpg", "size": "18mb"}','2019-12-22','2019-12-22'),
(10,10,11,'Images','image10',19,'{"image": "jpg", "size": "19mb"}','2019-12-22','2019-12-22'),
(11,11,2,'Images','video11',10,'{"video": "jpg", "size": "10mb"}','2019-12-22','2019-12-22'),
(12,12,3,'Images','video12',11,'{"video": "jpg", "size": "11mb"}','2019-12-22','2019-12-22'),
(13,13,4,'Images','video13',12,'{"video": "jpg", "size": "12mb"}','2019-12-22','2019-12-22'),
(14,14,5,'Images','video14',13,'{"video": "jpg", "size": "13mb"}','2019-12-22','2019-12-22'),
(15,15,6,'Images','video15',14,'{"video": "jpg", "size": "14mb"}','2019-12-22','2019-12-22'),
(16,16,7,'Images','video16',15,'{"video": "jpg", "size": "15mb"}','2019-12-22','2019-12-22'),
(17,17,8,'Images','video17',16,'{"video": "jpg", "size": "16mb"}','2019-12-22','2019-12-22'),
(18,18,9,'Images','video18',17,'{"video": "jpg", "size": "17mb"}','2019-12-22','2019-12-22'),
(19,19,10,'Images','video19',18,'{"video": "jpg", "size": "18mb"}','2019-12-22','2019-12-22'),
(20,10,11,'Images','video20',19,'{"video": "jpg", "size": "19mb"}','2019-12-22','2019-12-22'),
(21,21,2,'Images','music21',10,'{"music": "jpg", "size": "10mb"}','2019-12-22','2019-12-22'),
(22,22,3,'Images','music22',11,'{"music": "jpg", "size": "11mb"}','2019-12-22','2019-12-22'),
(23,23,4,'Images','music23',12,'{"music": "jpg", "size": "12mb"}','2019-12-22','2019-12-22'),
(24,24,5,'Images','music24',13,'{"music": "jpg", "size": "13mb"}','2019-12-22','2019-12-22'),
(25,25,6,'Images','music25',14,'{"music": "jpg", "size": "14mb"}','2019-12-22','2019-12-22'),
(26,26,7,'Images','music26',15,'{"music": "jpg", "size": "15mb"}','2019-12-22','2019-12-22'),
(27,27,8,'Images','music27',16,'{"music": "jpg", "size": "16mb"}','2019-12-22','2019-12-22'),
(28,28,9,'Images','music28',17,'{"music": "jpg", "size": "17mb"}','2019-12-22','2019-12-22'),
(29,29,10,'Images','music29',18,'{"music": "jpg", "size": "18mb"}','2019-12-22','2019-12-22'),
(30,10,11,'Images','music30',19,'{"music": "jpg", "size": "19mb"}','2019-12-22','2019-12-22')
;


insert into likes
values
(2,2,21,'2019-12-22',1),
(3,3,22,'2019-12-22',2),
(4,4,23,'2019-12-22',3),
(5,5,24,'2019-12-22',4),
(6,6,25,'2019-12-22',5),
(7,7,26,'2019-12-22',6),
(8,8,27,'2019-12-22',7),
(9,9,28,'2019-12-22',8),
(10,10,29,'2019-12-22',9),
(11,11,10,'2019-12-22',10)
;


insert into type_of_likes
values
(1,8,'like'), 
(2,9,'dislike'), 
(3,10,'meh')
;

insert into video_albums
values
(1,2,'Видео альбом пользователя 2'),
(2,3,'Видео альбом пользователя 3'),
(3,4,'Видео альбом пользователя 4'),
(4,5,'Видео альбом пользователя 5'),
(5,6,'Видео альбом пользователя 6'),
(6,7,'Видео альбом пользователя 7'),
(7,8,'Видео альбом пользователя 8'),
(8,9,'Видео альбом пользователя 9'),
(9,10,'Видео альбом пользователя 10'),
(10,11,'Видео альбом пользователя 11')
;

insert into videos
values

(1,1,1),
(2,2,2),
(3,3,3),
(4,4,4),
(5,5,5),
(6,6,6),
(7,7,7),
(8,8,8),
(9,9,9),
(10,10,10)
;

insert into photo_albums
values
(1,2,'Фото альбом пользователя 2'),
(2,3,'Фото альбом пользователя 3'),
(3,4,'Фото альбом пользователя 4'),
(4,5,'Фото альбом пользователя 5'),
(5,6,'Фото альбом пользователя 6'),
(6,7,'Фото альбом пользователя 7'),
(7,8,'Фото альбом пользователя 8'),
(8,9,'Фото альбом пользователя 9'),
(9,10,'Фото альбом пользователя 10'),
(10,11,'Фото альбом пользователя 11')
;

insert into photos
values

(1,1,1),
(2,2,2),
(3,3,3),
(4,4,4),
(5,5,5),
(6,6,6),
(7,7,7),
(8,8,8),
(9,9,9),
(10,10,10)
;

insert into music_albums
values
(1,2,'Музыкальный плейлист пользователя 2'),
(2,3,'Музыкальный плейлист пользователя 3'),
(3,4,'Музыкальный плейлист пользователя 4'),
(4,5,'Музыкальный плейлист пользователя 5'),
(5,6,'Музыкальный плейлист пользователя 6'),
(6,7,'Музыкальный плейлист пользователя 7'),
(7,8,'Музыкальный плейлист пользователя 8'),
(8,9,'Музыкальный плейлист пользователя 9'),
(9,10,'Музыкальный плейлист пользователя 10'),
(10,11,'Музыкальный плейлист пользователя 11')
;

insert into music
values

(1,1,1),
(2,2,2),
(3,3,3),
(4,4,4),
(5,5,5),
(6,6,6),
(7,7,7),
(8,8,8),
(9,9,9),
(10,10,10)
;


-- Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
-- У меня имена довольно скучные получились, но конструкция выглядит следующим образом:

select distinct firstname from users
order by firstname

-- Можно еще вот так:
select firstname from users
group by firstname
order by firstname
;

-- Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true). 
-- При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0)

-- Попытался вывести конструкцию для апдейта таблицы, но завести так и не смог..Как сделать правильно? Гуглил, но безуспешно.

update profile_status

set profile_status.staus = (select t1.user_id, t1.status from 
(select profiles.user_id, profile_status.id, profile_status.staus, profiles.birthday, 
(case when (profiles.birthday >= date'2001-12-22') then profile_status.staus = 'disabled' else profile_status.staus ='active' end) as status
from profiles 
join profile_status 
	on profile_status.id = profiles.user_id
where (case when (profiles.birthday >= date'2001-12-22') then profile_status.staus = 'disabled' else profile_status.staus ='active' end) = 'disabled') t1) t2

where profile_status.id = t2.user_id;

-- Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)

delete from messages
where 
 -- created_at >= TO_DAYS(NOW()); почему-то не сработало.( будто бы ошибка формата..
 created_at >= date'2019-12-23'; -- вот этот заработал.

select * from messages -- проверка работы скрипта






