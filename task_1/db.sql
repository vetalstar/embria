--
-- Структура таблицы `categories`
-- Уникальный индекс name_uniq нужен для поиска по названию категории
--

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uniq` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;


--
-- Структура таблицы `category_news`
-- Cоставной индекс category_created нужен для фильтрации по категории и сортировки. А также для связи с таблицей categories
--

CREATE TABLE IF NOT EXISTS `category_news` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL,
  `content` varchar(242) NOT NULL,
  `created` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_created` (`category_id`,`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;


--
-- Структура таблицы `news_likes`
-- Составной первичный ключ служит для ограничения: чтобы у одной новости мог быть только один голос от каждого пользователя
-- Индекс news_likes_fk_2 для связи с таблицей category_news
--

CREATE TABLE IF NOT EXISTS `news_likes` (
  `user_id` bigint(20) unsigned NOT NULL,
  `news_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`news_id`),
  KEY `news_likes_fk_2` (`news_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Структура таблицы `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;


--
-- Ограничения внешнего ключа таблицы `category_news`
--

ALTER TABLE `category_news`
ADD CONSTRAINT `category_news_fk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Ограничения внешнего ключа таблицы `news_likes`
--

ALTER TABLE `news_likes`
ADD CONSTRAINT `news_likes_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `news_likes_fk_2` FOREIGN KEY (`news_id`) REFERENCES `category_news` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Вставка категорий
--

INSERT INTO
  `categories` (`id`, `name`)
VALUES
  (1, 'Авто'),
  (2, 'Недвижимость');

--
-- Вставка новостей
--

INSERT INTO
  `category_news` (`id`, `category_id`, `content`, `created`)
VALUES
  (1, 1, 'Авто 1', 1476347387),
  (2, 1, 'Авто 2', 1476347387),
  (3, 2, 'Недвижимость 1', 1476347387);

--
-- Добавление пользователей
--

INSERT INTO
  `users` (`id`, `login`)
VALUES
  (1, 'v.kara'),
  (2, 'test');


--
-- Поиск категории
--

SELECT
  `id`,
  `name`
FROM
  `categories`
WHERE
  `name` = 'Авто';

--
-- Фильтр новостей по категориям
--

SELECT
  `cn`.`id`,
  `cn`.`category_id`,
  `c`.`name` AS `category_name`,
  `cn`.`content`,
  FROM_UNIXTIME(`cn`.`created`)
FROM
  `category_news` AS `cn`
JOIN
  `categories` AS `c`
ON
  `cn`.`category_id` = `c`.`id`
WHERE
  `cn`.`category_id` = 1
ORDER BY
  `cn`.`created` DESC;


--
-- Добавление лайка от пользователя с id = 1 к новости с id = 2
--

INSERT INTO
  `news_likes` (`user_id`, `news_id`)
VALUES
  (1, 2);

--
-- Просмотр списка всех оценивших пост с id = 2 пользователей
--

SELECT
  `cn`.`category_id`,
  `cn`.`content`,
  `nl`.`user_id`,
  `u`.`login`
FROM
  `category_news` as `cn`
JOIN
  `news_likes` as `nl`
ON
  `cn`.`id` = `nl`.`news_id`
JOIN
  `users` as `u`
ON
  `u`.`id` = `nl`.`user_id`
WHERE
  `cn`.`id` = 2;


--
-- Вывод всех новостей с кол-вом лайков
--

SELECT
  `cn`.`id`,
  `cn`.`category_id`,
  `cn`.`content`,
  `cn`.`created`,
  COUNT(`nl`.`user_id`) AS `num_likes`
FROM
  `category_news` AS `cn`
LEFT JOIN
  `news_likes` AS `nl`
ON
  `cn`.`id` = `nl`.`news_id`
GROUP BY
  `cn`.`id`;


--
-- Удаление лайка для новости с id = 2
--

DELETE FROM
  `news_likes`
WHERE
  `news_id` = 2
  AND
  `user_id` = 1;