drop database if exists tube;
create database tube;
use tube;

drop table if exists game_status_map;
drop table if exists battlefield_maps;
drop table if exists battlefield;
drop table if exists enemy_profiles;
drop table if exists stats;
drop table if exists grade_skills;
drop table if exists bag;
drop table if exists grade_map;
drop table if exists grade;
drop table if exists profile;


-- создаем карту боя: кто есть на карте, живой / убитый, тип карты.

create table battlefield(
id SERIAL primary key,
user_id bigint unsigned not null,
enemy_id bigint unsigned not null,
game_status_id bigint unsigned not null, -- жив / не жив
battle_map_id bigint unsigned not null, -- карт можно сделать много, но тут я решил ограничиться одной.

index battlefield_user_id (user_id),
index battlefield_enemy_id (enemy_id),
index battlefield_map_id (battle_map_id),
index battlefield_status_id (game_status_id)

);

-- игровые статусы: по идее, их всего два: живой / не живой. но можно пофантазировать на эту тему, поэтому я эту табличку, пожалуй, все же оставлю. 

create table game_status_map(
id SERIAL primary key,
game_status_id bigint unsigned not null,
status_name varchar(100),

index gsm_status_id (id),
index gsm_game_status_id (game_status_id),
foreign key game_status_map(id) references battlefield(game_status_id)


);

-- типы карт (играть, конечно, было бы интереснее на разных картах, но в рамках прототипа будет всего одна.

create table battlefield_maps(
id SERIAL primary key,
battle_maps_id bigint unsigned not null,
battlefield_map_name varchar(100),

index bmps_id (id),

foreign key battlefield_maps(id) references battlefield(battle_map_id)

);

-- Профайл игрока

create table profile(
id SERIAL primary key,
user_id bigint unsigned not null, -- id пользователя
email varchar(100) unique, -- уникальный почтовый ящик, может использоваться как логин
password_hash varchar(100), -- пароль аккаунта
nickname varchar(225) unique, -- Игровое имя пользователя
grade_id bigint unsigned null, -- Игровой ранг пользователя
stats_id bigint unsigned null, -- Игровые параметры пользователя (Здороевье / броня / урон / опыт)
bag_id bigint unsigned null, -- id инвентаря пользователя

index user_id_profiles (user_id),
index grade_id_profiles (grade_id),

foreign key profile(id) references battlefield(user_id)
);

-- Ранг игрока

create table user_grade(
id SERIAL primary key,
user_id bigint unsigned not null,
grade_id bigint unsigned not null,

 index user_grade_id(grade_id),
 foreign key (grade_id) references profile(grade_id),
 foreign key (user_id) references profile(id)
);

-- карта рангов

create table grade_map(
id SERIAL primary key,
grade_name varchar(225)
 );

alter table grade_map add constraint grade_map_id
	foreign key (id) references user_grade(id);

-- содержимое мешков каждого игрока. пока что там будет лежать валюта - монетки, по 1 на каждого. 
-- Монетки даются за убийство вражеских единиц, чем старше единица - тем больше монеток она стоит.

create table bag(
id SERIAL primary key,
user_id bigint unsigned not null,
coins bigint unsigned not null,

index bag_user_id (user_id));

alter table bag add constraint bag_user_idx
	foreign key (user_id) references profile(id)
;

-- Определяем характеристики каждого уровня игрока

create table grade_skills(
id SERIAL primary key,
grade_id bigint unsigned not null,
damage bigint unsigned not null, -- сила урона
speed bigint unsigned not null, -- интенсивность атаки

 index grade_skills_id(grade_id),
 foreign key (id) references user_grade (id)
);

-- Задаем статистику убитых героем врагов

create table stats (
id SERIAL primary key,
user_id bigint unsigned not null,
soldier_kills bigint unsigned not null,
scout_kills bigint unsigned not null,
troops_kills bigint unsigned not null,
dred_kills bigint unsigned not null,
warlords_kills bigint unsigned not null,
champ_kills bigint unsigned not null,

index stats_user_id (user_id),
foreign key (id) references profile(id)

);

-- создаем анкету неприятелей

create table enemy_profiles(
id SERIAL primary key,
enemy_id bigint unsigned not null,
name varchar(225),
damage bigint unsigned not null, -- сила урона
attack_speed bigint unsigned not null, -- интенсивность атаки
movement_speed bigint unsigned not null, -- скорость передвижения
health bigint unsigned not null, -- уровень здоровья
cost bigint unsigned not null, -- цена за убийство противника в монетках 

index enemy_profile_id(id),

foreign key enemy_profiles(id) references battlefield(enemy_id)
);

-- Наполняем данными

insert into battlefield values 

(1, 1, 1, 1, 1),
(2, 2, 2, 2, 1),
(3, 3, 3, 3, 1),
(4, 4, 4, 4, 1),
(5, 5, 5, 5, 1),
(6, 6, 6, 6, 1),
(7, 7, 7, 7, 1),
(8, 8, 8, 8, 1);

insert into battlefield_maps values
(1, 1, 'Истваан V');


insert into game_status_map values
(1, 1, 'alive'),
(2, 2, 'alive'),
(3, 3, 'alive'),
(4, 4, 'alive'),
(5, 5, 'dead'),
(6, 6, 'alive'),
(7, 7, 'alive'),
(8, 8, 'alive');


insert into profile values 
(1,1, 'DenisGurkin1991@mail.ru', 'DenisGurkin','Player1',1,1,1),
(2,2, 'SergeyMelnikov1991@mail.ru', 'SergeyMelnikov','Player2',2,2,2),
(3,3, 'IrinaSitnikova1992@mail.ru', 'IrinaSitnikova','Player3',3,3,3),
(4,4, 'IvinaVorobieva1996@mail.ru', 'IvinaVorobieva','Player4',4,4,4),
(5,5, 'PavelPugachev1985@mail.ru', 'PavelPugachev','Player5',5,5,5),
(6,6, 'MaribaPugacheva1988@mail.ru', 'MaribaPugacheva','Player6',6,6,6),
(7,7, 'StanislavVorobiev1963@mail.ru', 'StanislavVorobiev','Player7',7,7,7),
(8,8, 'AntonPugachev2018@mail.ru', 'AntonPugachev','Player8',8,8,8);

insert into user_grade values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8);

insert into grade_map values -- Скаут / Рядовой / Первый Капитан / Старший Капитан / Ветеран / Дредноут / Почтенный / Магистр Осады
(1, 'Скаут'),
(2, 'Офицер'),
(3, 'Первый Капитан'),
(4, 'Старший Капитан'),
(5, 'Ветеран'),
(6, 'Дредноут'),
(7, 'Почтенный'),
(8, 'Магистр Осады');

insert into bag values
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1);

insert into grade_skills values
(1, 1, 1, 2),
(2, 2, 3, 2),
(3, 3, 4, 3),
(4, 4, 5, 4),
(5, 5, 6, 6),
(6, 6, 8, 7),
(7, 7, 10, 10),
(8, 8, 20, 15);

insert into stats values
(1, 1, 0, 0, 0, 0, 0, 0),
(2, 2, 0, 0, 0, 0, 0, 0),
(3, 3, 0, 0, 0, 0, 0, 0),
(4, 4, 0, 0, 0, 0, 0, 0),
(5, 5, 0, 0, 0, 0, 0, 0),
(6, 6, 0, 0, 0, 0, 0, 0),
(7, 7, 0, 0, 0, 0, 0, 0),
(8, 8, 0, 0, 0, 0, 0, 0);

insert into enemy_profiles values
(1, 1, 'Солдат', 1, 1, 1, 1, 1),
(2, 2, 'Скаут', 1, 1, 2, 2, 2),
(3, 3, 'Десантник', 2, 2, 1, 1, 3),
(4, 4, 'Дредноут', 5, 1, 1, 10, 6),
(5, 5, 'Варлорд', 10, 3, 2, 8, 8),
(6, 6, 'Чемпион', 15, 5, 5, 11, 10),
(7, 7, 'Демон-принц', 20, 10, 10, 15, 16),
(8, 8, 'Примах хаоса', 100, 100, 100, 100, 100);


-- Cмотрим что получилось. На исходной 8 игроков начального уровня, у каждого по 1 монетке и никаких шансов против Примарха хаоса.

select p.user_id, p.nickname,gm.grade_name,b.coins, gs.damage, gs.speed from profile as p
join user_grade as ug on p.user_id = ug.user_id 
join grade_map as gm on ug.grade_id = gm.id
join bag as b on b.user_id = p.user_id
join grade_skills as gs on gs.grade_id = ug.grade_id;

-- Примерно так выглядит поле боя (отработаем вложенные запросы).

select bm.battlefield_map_name as "Локация",
	   p.nickname as "Имя игрока", 
	   gm.grade_name as "Уровень игрока",
	   ep.name as "Противник"
	  -- count(ep.enemy_id)
from battlefield b 
	 join profile as p on p.user_id = b.enemy_id 
	 join user_grade as ug on p.user_id = ug.user_id 
	 join grade_map as gm on ug.grade_id = gm.id 
	 join enemy_profiles as ep on ep.enemy_id = b.enemy_id 
	 join battlefield_maps as bm on bm.battle_maps_id = b.battle_map_id

where p.nickname = (select nickname from profile where user_id = 1);
	
-- чтобы в отслеживать сколько игроков находятся на карте, можно обернуть этот запрос в представление:

create view battlefield_view as 

select bm.battlefield_map_name as "Локация",
	   p.nickname as "Имя игрока", 
	   gm.grade_name as "Уровень игрока",
	   ep.name as "Противник"
	  -- count(ep.enemy_id)
from battlefield b 
	 join profile as p on p.user_id = b.enemy_id 
	 join user_grade as ug on p.user_id = ug.user_id 
	 join grade_map as gm on ug.grade_id = gm.id 
	 join enemy_profiles as ep on ep.enemy_id = b.enemy_id 
	 join battlefield_maps as bm on bm.battle_maps_id = b.battle_map_id;

-- Проверяем работу

select * from battlefield_view;

-- теперь посмотрим сколько выстртелов нужно сделать новичку, чтобы справиться со своим противником

select gm.grade_name as "Уровень игрока",
	   gs.damage as "Урон игрока",
	   ep.name as "Противник",
	   ep.health as "Здоровье противника",
	   (ep.health / gs.damage) as "Нужно выстрелов"
from battlefield b 
	 join profile as p on p.user_id = b.enemy_id 
	 join user_grade as ug on p.user_id = ug.user_id 
	 join grade_map as gm on ug.grade_id = gm.id 
	 join enemy_profiles as ep on ep.enemy_id = b.enemy_id
	 join grade_skills as gs on gs.grade_id = gm.id 
	   
-- конструкцию "FROM" так же можно завернуть в представление, чтобы не вбивать кучу джойнов в будущем:

create view showcase as 
	 select b.user_id, b.enemy_id, ep.name, b.battle_map_id, b.game_status_id, p.nickname, p.stats_id, p.bag_id,
ug.grade_id, gm.grade_name, ep.attack_speed, ep.cost, ep.damage as enemy_damage, ep.health, ep.movement_speed, gs.damage as player_damage, gs.speed 
	 from battlefield b 
	 join profile as p on p.user_id = b.enemy_id 
	 join user_grade as ug on p.user_id = ug.user_id 
	 join grade_map as gm on ug.grade_id = gm.id 
	 join enemy_profiles as ep on ep.enemy_id = b.enemy_id
	 join grade_skills as gs on gs.grade_id = gm.id;

-- Селектить стало удобнее, еще бы вьюху упорядочить - но тут уже дело вкуса. По мере доработки базы она будет меняться еще раз 10, наверное.
	
select grade_name as "Уровень игрока",
		   player_damage as "Урон игрока",
		   name as "Противник",
		   health as "Здоровье противника",
		  ceil(health / player_damage) as "Нужно выстрелов"
from showcase ;

-- Осталось придумать пару триггеров. Допустим, если врага убили, присвоим ему игровой статус game_status_map = 'dead'

-- подберем табличку, где наглядно будет видно количество здоровья и статус противника.
select ep.name, ep.health, gsm.status_name
from enemy_profiles ep
join battlefield b on b.enemy_id = ep.enemy_id 
left join game_status_map gsm on gsm.game_status_id = b.game_status_id;




-- Тут вызвается, которая выбирает противника, статус которого в игре (таблица game_status_map) равен 'dead'
-- На поле боя этот статус относится только к противнику. В случае, если здоровье игрока становится нулевым - гейм овер.
-- Кривая, наверное, логика, но на момент написания структуры таблиц мне это казалось очень правильным решением..

DROP FUNCTION IF EXISTS tube.game_status_dead;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` FUNCTION `tube`.`game_status_dead`(enemy_id INT) RETURNS float
    READS SQL DATA
begin
	declare dead_list varchar;
	
set dead_list = (
	select ep.enemy_id
	from enemy_profiles ep
	join battlefield b on b.enemy_id = ep.enemy_id 
	join game_status_map gsm on gsm.game_status_id = b.game_status_id
	where gsm.status_name = 'dead');
	
 return dead_list;
 
END$$
DELIMITER ;


select game_status_dead(1);

-- попробуем функцию применить, найдем кого убили.

select ep.name, ep.health, gsm.status_name
	from enemy_profiles ep
	join battlefield b on b.enemy_id = ep.enemy_id 
	join game_status_map gsm on gsm.game_status_id = b.game_status_id
	where ep.enemy_id = game_status_dead(1);



