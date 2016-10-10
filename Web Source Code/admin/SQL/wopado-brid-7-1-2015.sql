-- phpMyAdmin SQL Dump
-- version 4.0.10.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 07, 2016 at 06:05 AM
-- Server version: 5.5.32-cll-lve
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `wopado`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `login_id` int(10) unsigned NOT NULL,
  `account_name` varchar(256) NOT NULL,
  `allowed_stores` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_id` (`login_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `login_id`, `account_name`, `allowed_stores`) VALUES
(1, 2, 'KFC''s', 2),
(6, 11, 'Shirish Test Account', 3),
(7, 13, 'Bamboo Lounge', 1),
(8, 17, 'Test', 1);

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE IF NOT EXISTS `admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `login_id` int(10) unsigned NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `security_question` varchar(256) NOT NULL,
  `security_answer` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_id` (`login_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `login_id`, `mobile`, `security_question`, `security_answer`) VALUES
(1, 1, '9924400799', 'What is the name of application ? [Hint: starting from "W" ;)]', 'wopado');

-- --------------------------------------------------------

--
-- Table structure for table `admin_login_devices`
--

CREATE TABLE IF NOT EXISTS `admin_login_devices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(256) NOT NULL,
  `used_datetime` datetime NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Dumping data for table `admin_login_devices`
--

INSERT INTO `admin_login_devices` (`id`, `ip_address`, `used_datetime`, `status`) VALUES
(2, '150.129.151.10', '2015-11-25 08:53:27', 1),
(3, '103.240.76.196', '2015-11-25 10:22:59', 1),
(4, '103.240.76.19', '2015-11-25 11:42:33', 1),
(5, '103.240.76.137', '2015-11-27 10:45:54', 1),
(6, '123.243.24.179', '2015-12-01 21:02:58', 1),
(7, '27.32.94.38', '2015-12-02 22:35:34', 1),
(8, '150.129.151.38', '2015-12-05 04:35:05', 1),
(9, '43.248.34.186', '2015-12-05 06:22:13', 1),
(10, '150.129.151.246', '2015-12-07 05:41:26', 1),
(11, '150.129.151.17', '2015-12-09 10:07:01', 1),
(12, '43.248.34.223', '2015-12-11 05:21:37', 1),
(13, '150.129.150.233', '2015-12-11 08:43:21', 1),
(14, '150.129.150.73', '2015-12-12 07:14:13', 1),
(15, '150.129.151.66', '2015-12-14 05:36:46', 1),
(16, '43.248.34.161', '2015-12-17 10:02:10', 1),
(17, '150.129.151.208', '2015-12-21 07:23:11', 1),
(18, '182.237.14.179', '2016-01-04 04:52:21', 1);

-- --------------------------------------------------------

--
-- Table structure for table `app_rating`
--

CREATE TABLE IF NOT EXISTS `app_rating` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `rating` tinyint(2) NOT NULL,
  `review` varchar(264) NOT NULL,
  `added_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `app_rating`
--

INSERT INTO `app_rating` (`id`, `user_id`, `rating`, `review`, `added_date`) VALUES
(2, 4, 2, 'hello', '2015-11-26 10:32:20'),
(7, 2, 3, 'nyc app\nexcellent', '2015-12-01 05:22:10');

-- --------------------------------------------------------

--
-- Table structure for table `beacons`
--

CREATE TABLE IF NOT EXISTS `beacons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL,
  `beacon_major` smallint(5) unsigned NOT NULL,
  `beacon_minor` smallint(5) unsigned NOT NULL,
  `table_id` varchar(256) NOT NULL,
  `added_datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_id` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `beacons`
--

INSERT INTO `beacons` (`id`, `store_id`, `beacon_major`, `beacon_minor`, `table_id`, `added_datetime`) VALUES
(1, 1, 1, 1, 'Table 1', '2015-11-26 06:52:28'),
(2, 13, 13, 1, 'Table 1', '2015-12-21 07:23:25'),
(3, 1, 1, 2, 'Table 2', '2015-12-21 09:45:24'),
(5, 8, 8, 1, 'Table 1', '2015-12-21 09:45:45'),
(6, 9, 9, 1, 'Table 1', '2015-12-21 09:45:50'),
(8, 11, 11, 1, 'Table 1', '2015-12-21 09:46:03');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `category_name` varchar(256) NOT NULL,
  `images` varchar(256) DEFAULT NULL,
  `added_datetime` datetime NOT NULL,
  `status` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_id` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=39 ;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `store_id`, `parent_id`, `category_name`, `images`, `added_datetime`, `status`) VALUES
(1, 1, 0, 'Burger', '1448253311-KFC-burger1.jpg,1448253311-KFC-burger2.jpeg,1448253311-KFC-burger3.jpg', '2015-11-23 04:35:11', 1),
(2, 1, 0, 'Drinks', '1448255533-vodka.jpg,1448255533-Beer.jpg,1448255533-shots.jpg', '2015-11-23 05:12:13', 1),
(3, 1, 2, 'Whiskey', '1448255587-rum.jpg', '2015-11-23 05:13:07', 1),
(4, 1, 0, 'Pizza', '1448257371-pizza-1.jpg,1448257371-pizza-2.jpg', '2015-11-23 05:42:51', 1),
(5, 1, 2, 'Beer', '1448357706-Beer.jpg', '2015-11-24 09:35:06', 1),
(6, 1, 0, 'Pasta', '1448433852-Tasty-Kitchen-Blog-Smoky-Tomato-Roasted-Red-Pepper-and-Arugula-Pasta.jpg,1448433852-2_qont.jpg,1448433852-sweet-potato-garlicky-kale-pasta_3.jpg', '2015-11-25 06:44:12', 1),
(7, 1, 6, 'White', '1448433966-DSC00288.JPG', '2015-11-25 06:46:06', 1),
(8, 1, 6, 'Red', '1448434025-pasta-in-tomato-sauce.jpg', '2015-11-25 06:47:05', 1),
(9, 1, 6, 'Green', '1448434068-img_7746.jpg', '2015-11-25 06:47:48', 1),
(10, 1, 0, 'Wraps & Burritos', '1448441137-turkey-provolone-wrap-lrg.jpg,1448441137-cat-1318-300-1.jpg,1448441137-mixwrpa.jpg', '2015-11-25 08:45:37', 1),
(12, 1, 0, 'Panini', '1448446145-panini2.jpg,1448446145-italianpannini.jpg,1448446145-pan2.jpg', '2015-11-25 10:09:05', 1),
(13, 1, 0, 'Bakery', '1448447187-buns-bakeries-tea-ale-four-weird-icelandic-sayings-3.jpg,1448447187-bakery_dept.jpg', '2015-11-25 10:26:27', 1),
(14, 1, 13, 'Cookies', '1448447347-holiday_cookies3.jpg', '2015-11-25 10:29:07', 1),
(15, 1, 13, 'Fruit Breads', '1448447413-fresh-fruit-danish.jpg', '2015-11-25 10:30:13', 1),
(16, 1, 13, 'Donuts', '1448447494-Donuts-image-donuts-36666750-313-361.jpg', '2015-11-25 10:31:34', 1),
(18, 1, 13, 'Muffins', '1448449088-blog_muffins.jpg', '2015-11-25 10:58:08', 1),
(19, 1, 13, 'Brownies', '1448450876-cookies-and-cream-oreo-fudge-brownies-7.jpg', '2015-11-25 11:27:56', 1),
(20, 1, 2, 'Red Wine', '1449097916-3355.jpg', '2015-11-28 05:43:48', 1),
(21, 8, 0, 'Lunch & Dinner', '1448963300-6684.jpg,1448963300-2654.jpg,1448963300-9515.jpg', '2015-12-01 09:29:40', 1),
(22, 8, 21, 'Salad', '1448963636-5647.jpg', '2015-12-01 09:43:04', 1),
(23, 8, 0, 'Breakfast', '1448963499-7219.jpg', '2015-12-01 09:51:39', 1),
(24, 11, 0, 'Breakfast', '1449004237-5217.jpg', '2015-12-01 21:10:37', 1),
(25, 11, 0, 'Lunch', '1449004327-1485.jpg', '2015-12-01 21:12:07', 1),
(26, 11, 0, 'Coffee', '1449004423-9461.jpg', '2015-12-01 21:13:43', 1),
(27, 11, 0, 'Drinks', '1449004443-7051.jpg', '2015-12-01 21:14:03', 1),
(28, 11, 0, 'Pastry', '1449004541-8914.jpg', '2015-12-01 21:15:41', 1),
(29, 1, 2, 'White Wine', '1449097948-5151.jpg', '2015-12-02 23:12:28', 1),
(30, 13, 0, 'Breakfast', '1449657792-1447.jpg', '2015-12-09 10:43:12', 1),
(31, 13, 0, 'Lunch', '1449657916-4322.jpg', '2015-12-09 10:45:16', 1),
(32, 13, 0, 'Dinner', '1449657986-6663.jpg', '2015-12-09 10:46:26', 1),
(33, 13, 0, 'Drinks', '1449658005-7645.jpg', '2015-12-09 10:46:45', 1),
(36, 9, 0, 'Break Fast', '1450162238-7467.jpg', '2015-12-15 06:50:38', 1),
(37, 9, 36, 'TEMp', '1450162253-9778.jpg', '2015-12-15 06:50:53', 2),
(38, 9, 0, 'TEMp', '1450169564-3282.jpg', '2015-12-15 08:52:44', 1);

-- --------------------------------------------------------

--
-- Table structure for table `category_discount`
--

CREATE TABLE IF NOT EXISTS `category_discount` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL,
  `discount_id` int(10) unsigned NOT NULL,
  `promotion_main_type` tinyint(3) unsigned NOT NULL COMMENT '1 = Based on daterange, 2 = Based on fix days range',
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `category_discount`
--

INSERT INTO `category_discount` (`id`, `category_id`, `discount_id`, `promotion_main_type`) VALUES
(1, 19, 1, 1),
(2, 19, 2, 1),
(3, 1, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `cat_discount_daterange`
--

CREATE TABLE IF NOT EXISTS `cat_discount_daterange` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `promotion_sub` tinyint(1) unsigned NOT NULL COMMENT '1 = Discount Percentage, 2 = Fixed Price',
  `promotion_sub_value` decimal(10,2) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `cat_discount_daterange`
--

INSERT INTO `cat_discount_daterange` (`id`, `start_date`, `end_date`, `promotion_sub`, `promotion_sub_value`) VALUES
(1, '2015-11-28', '2015-12-03', 1, '20.00'),
(2, '2015-11-28', '2015-12-03', 1, '50.00');

-- --------------------------------------------------------

--
-- Table structure for table `cat_discount_days`
--

CREATE TABLE IF NOT EXISTS `cat_discount_days` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day` varchar(20) NOT NULL COMMENT '1 (for Monday) through 7 (for Sunday)',
  `all_day` tinyint(1) unsigned NOT NULL COMMENT '0 = For selected time range, 1 = For all day',
  `time_start` time NOT NULL,
  `time_end` time NOT NULL,
  `promotion_sub` tinyint(1) unsigned NOT NULL COMMENT '1 = Discount Percentage, 2 = Fixed Price',
  `promotion_sub_value` decimal(10,2) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cat_discount_days`
--

INSERT INTO `cat_discount_days` (`id`, `day`, `all_day`, `time_start`, `time_end`, `promotion_sub`, `promotion_sub_value`) VALUES
(1, ',5,6,7,', 0, '06:00:00', '10:00:00', 1, '10.00');

-- --------------------------------------------------------

--
-- Table structure for table `device_registered`
--

CREATE TABLE IF NOT EXISTS `device_registered` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `device_id` varchar(512) NOT NULL,
  `notif_id` varchar(512) NOT NULL,
  `type` tinyint(1) unsigned NOT NULL COMMENT '1 = iOs, 2 = Android',
  `reg_datetime` datetime NOT NULL,
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=31 ;

--
-- Dumping data for table `device_registered`
--

INSERT INTO `device_registered` (`id`, `user_id`, `device_id`, `notif_id`, `type`, `reg_datetime`, `status`) VALUES
(3, 2, 'ff6d5ed9d23e238d', 'APA91bGRj8yzTaq_BIA-7lISNhZ7EVACrbCeqqz_p_UurmgO3EgiO2gGkaZGF-zb1ryGRt0cFBmVt-yAUs7NOWOT2Eo2EW_P9LKOH3V0pWTRG0bKfsd3v_7zElE2wcL1ceJGlcgZzTzF', 2, '2015-12-15 09:53:06', 1),
(16, 2, '2a1b156000fa93c53274f7e2103e8475', '745c12295afeb6751f46a59570e42e97a24f7ed25ca1034f718de9258e0c4535', 1, '2016-01-04 13:12:44', 1),
(17, 5, 'de665c5446685673', 'APA91bESKnYuIfhIEE4oz_fNWGVdhOxD15nn7Mw4MYo6pzYztzMJbRUJzAlDx9dqSONufH8n_1J4N9tOK9gEld0ANMdlTlm95VrSJjxl_rFSt441m68eP_4Q10xvRh1fDkRsOcuNeP82', 2, '2016-01-04 23:49:14', 1),
(18, 1, '8cc1d29ad9c080ba', 'APA91bEoa3KB2swTaDld6M0iJP-zA-V5y32EV4xp9Xxf9S679ZzBTh-22G8IgubFNh8w5LaMwyQ_Qg4Q2_ICs_-0jph5V5HuYCHhzeIDG1Idp84iSK7tbt_hei9CgExYDTeGR1jIIujN', 2, '2016-01-05 05:01:58', 1),
(24, 1, 'c5261d270aa5c68540d521b636db4405', 'a34fd268d8e17b3b513646c8ea694dfe92a251e17f27e887b8e46a7d7ac1ed34', 1, '2016-01-05 06:04:46', 1),
(30, 12, 'f47e9e5d3fd6206fe4b00280643bbb4a', 'testingRegistrationId', 1, '2016-01-07 12:34:38', 1);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE IF NOT EXISTS `employee` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `login_id` int(10) unsigned DEFAULT NULL,
  `store_id` int(10) unsigned NOT NULL,
  `kitchen_id` int(10) unsigned DEFAULT NULL,
  `emp_name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_id` (`login_id`),
  KEY `store_id` (`store_id`),
  KEY `kitchen_id` (`kitchen_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`id`, `login_id`, `store_id`, `kitchen_id`, `emp_name`) VALUES
(8, 15, 1, 1, 'Parth'),
(9, 16, 1, NULL, 'viraj vaishnav'),
(10, 18, 13, 7, 'David'),
(11, 19, 13, 8, 'Krishna'),
(12, 20, 8, 5, 'Test Cook');

-- --------------------------------------------------------

--
-- Table structure for table `feedback_review`
--

CREATE TABLE IF NOT EXISTS `feedback_review` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `review` text NOT NULL,
  `added_datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE IF NOT EXISTS `items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL,
  `kitchen_id` int(10) unsigned NOT NULL,
  `item_name` varchar(256) NOT NULL,
  `item_description` text NOT NULL,
  `item_size` varchar(256) NOT NULL,
  `price` decimal(10,2) unsigned NOT NULL,
  `tax_percentage` decimal(10,2) NOT NULL,
  `images` varchar(256) DEFAULT NULL,
  `has_variety` tinyint(1) unsigned NOT NULL,
  `no_of_option` tinyint(1) unsigned NOT NULL,
  `is_new` tinyint(1) NOT NULL,
  `added_datetime` datetime NOT NULL,
  `status` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `kitchen_id` (`kitchen_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=89 ;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `category_id`, `kitchen_id`, `item_name`, `item_description`, `item_size`, `price`, `tax_percentage`, `images`, `has_variety`, `no_of_option`, `is_new`, `added_datetime`, `status`) VALUES
(1, 1, 1, 'Cheezy Crunch', 'Two crispy golden potato hashbrowns, tri-pepper cheddar cheese sauce with jalapenos, paprika and green chillies, creamy thousand island sauce, fresh lettuce and crunchy onions - all enclosed inside a warm, soft bun.', 'Small', '50.00', '0.00', '1448253592-KFC-New-Cheesy-Crunch-Burger.png', 0, 0, 1, '2015-11-23 04:39:52', 1),
(2, 1, 1, 'Paneer Zinger', 'A unique double layered Paneer patty with a spicy creamy sauce, covered with fresh lettuce in a soft warm bun', 'Medium', '80.00', '10.10', '1448253699-KFC_PaneerZinger.jpg', 0, 0, 0, '2015-11-23 04:41:39', 1),
(3, 1, 1, 'Spicy Paneer', 'A balanced blend of freshly caramelized bread, tender and soft crispy coated paneer which has spicy and dairy notes, fresh crisp lettuce and creamy tandoori mayonnaise taste. Spicy Paneer won''t only satisfy your need for spice but also satiate your hunger!', 'Small', '80.00', '0.00', '1448429202-McSpicy_Paneer.png', 0, 0, 0, '2015-11-23 04:43:25', 1),
(4, 3, 2, 'Johnny Walker Red Label', 'Renowned the world over, Johnnie Walker Red Label is the quintessential Scotch', 'Small', '8.00', '10.00', '1449096003-9041.png', 0, 1, 0, '2015-11-23 05:17:09', 1),
(5, 4, 1, 'Margherita', 'A hugely popular Margherita, with a deliciously tangy single cheese topping.', '', '15.00', '10.00', '1448429482-cheeselovers.jpg', 3, 1, 1, '2015-11-23 05:44:02', 1),
(6, 4, 1, 'Peppy Paneer', 'Chunky paneer with crisp capsicum and spicy red pepper - quite a mouthful !', '', '16.00', '10.00', '1448429789-dish19-peppy-paneer-copy-1346593406-427x298.jpg', 3, 1, 1, '2015-11-23 05:45:05', 1),
(7, 5, 2, 'Pure Blonde', 'Pure Blonde is a crisp, clean, easy drinking beer that delivers refreshment while looking after the waistline', 'Lager', '8.00', '10.00', '1449096992-8067.png', 0, 0, 0, '2015-11-24 09:38:51', 1),
(8, 5, 2, 'James Boag''s', 'a unique yeast culture - delivers a world-renowned, smooth, malty and subtle lager styled beer.', 'Medium', '8.00', '10.00', '1449097075-1040.png', 0, 0, 1, '2015-11-24 09:39:50', 1),
(9, 5, 2, 'Corona', 'a unique yeast culture - delivers a world-renowned, smooth, malty and subtle lager styled beer.', 'Small', '9.00', '10.00', '1449097161-6548.png', 0, 0, 0, '2015-11-24 09:44:31', 1),
(10, 1, 3, 'Spicy Grill Chicken', 'A balanced blend of freshly toasted bun with tender and juicy bite of minced chicken grilled patty along with mint sauce, fresh onions and tomatoes.', '', '76.53', '10.10', '1448427200-Chicken-McGrill.png', 3, 0, 1, '2015-11-25 04:53:20', 1),
(11, 1, 3, 'Egg and Cheese Muffin', 'Steamed egg that is tender and moist served with a slice of cheese in a muffin, uniquely baked to have a crisp exterior and a soft and tender interior.', '', '56.42', '10.10', '1448427587-HM-Egg-Cheese-McMuffin.png', 3, 1, 0, '2015-11-25 04:59:47', 1),
(12, 1, 3, 'Bacon & Cheese', 'Our Bacon and Cheese Burger is a ¼ lb.* of savory flame-grilled beef topped with thick-cut smoked bacon, melted American cheese, ripe tomatoes, fresh lettuce, creamy mayonnaise, crunchy pickles, and sliced white onions on a soft sesame seed bun.', 'Medium', '86.78', '10.10', '1448428404-BC-Whopper-detail.png', 0, 1, 1, '2015-11-25 05:13:24', 1),
(13, 1, 3, 'Ham, Egg & Cheese', 'Our grab-and-go Ham, Egg & Cheese Burger is piled high with thin sliced sweet black forest ham, fluffy eggs, and melted American cheese on a toasted, flaky croissant.', 'Small', '47.23', '10.10', '1448428657-HERO_0037_Croissanwich_Ham_Egg_Cheese.png', 0, 1, 0, '2015-11-25 05:17:37', 1),
(14, 4, 1, 'Deluxe Veggie', 'For a vegetarian looking for a BIG treat that goes easy on the spices, this one''s got it all. The onions, the capsicum, those delectable mushrooms - with paneer and golden corn to top it all.', '', '17.00', '10.00', '1448430102-dp.jpg', 3, 1, 0, '2015-11-25 05:41:42', 1),
(15, 4, 3, 'Cheese & Barbecue Chicken', 'A thrill from the grill - barbecue chicken with generous topping of cheese.', '', '17.00', '10.00', '1448430808-Dish17-bbq-chickenA.jpg', 3, 1, 1, '2015-11-25 05:53:28', 1),
(16, 4, 3, 'Cheese Pepperoni', 'Loaded with Pepperoni & Extra Mozzarella Cheese.', '', '16.00', '10.00', '1448431513-20100201-delivery-dominos.jpg', 3, 1, 0, '2015-11-25 06:05:13', 1),
(17, 8, 1, 'Tangy Twist Fusilli', 'Creamy tomato sauce spiked with tangy spices.', 'Regular', '124.89', '10.10', '1448434341-pan_pizza_image2.jpg', 0, 1, 1, '2015-11-25 06:52:21', 1),
(18, 8, 1, 'Go Italia! Spaghetti', 'Noodle pasta, lightly tossed with olive oil, parmesan cheese, mushroom, baby corn, zucchini, parsley, garlic and bell peppers.', 'Regular', '245.78', '10.10', '1448434591-italian-food-recipes-not-from-italy-spaghetti-bolognese.jpg', 0, 2, 0, '2015-11-25 06:56:31', 1),
(19, 8, 1, 'Arrabbiata Penne', 'Flavorful, tangy tomato sauce with black olives, tossed with tube shaped pasta.', 'Regular', '345.12', '10.10', '1448435043-Penne-all-arrabbiata.jpg', 0, 0, 0, '2015-11-25 07:04:03', 1),
(20, 7, 3, 'Fettuccini Alfredo', 'A Rich Parmesan Cream Sauce. Available with Chicken.', 'Regular', '478.56', '10.10', '1448435314-fettucine-7.jpg', 0, 1, 1, '2015-11-25 07:08:34', 1),
(21, 8, 3, 'Four Cheese Pasta', 'Penne Pasta, Mozzarella, Ricotta, Romano and Parmesan Cheeses, Marinara Sauce and Fresh Basil. Also served with Chicken.', 'Regular', '238.45', '10.10', '1448435482-o.jpg', 0, 1, 1, '2015-11-25 07:11:22', 1),
(22, 7, 3, 'Carbonara', 'Spaghettini with Smoked Bacon, Green Peas, and a Garlic-Parmesan Cream Sauce. Available with Chicken.', 'Regular', '268.12', '10.10', '1448435663-CCF_Social_PastaCarbonara.jpg', 0, 1, 0, '2015-11-25 07:14:23', 1),
(23, 7, 3, 'Louisiana Chicken', 'Parmesan Crusted Chicken Served Over Pasta with Mushrooms, Peppers and Onions in a Spicy New Orleans Sauce.', 'Regular', '312.89', '10.10', '1448435864-CCF_LousianaChickenPasta.jpg', 0, 1, 0, '2015-11-25 07:17:44', 1),
(24, 7, 3, 'Farfalle with Chicken & Roasted Garlic', 'Bow-Tie Pasta, Chicken, Mushrooms, Tomato, Pancetta, Peas and Caramelized Onions in a Roasted Garlic-Parmesan Cream Sauce.', 'Regular', '279.00', '10.10', '1448436067-CCF_Social_FarfalleWithChickenAndRoastedGarlic.jpg', 0, 1, 0, '2015-11-25 07:21:07', 1),
(25, 8, 3, 'Spicy Chicken Chipotle', 'Honey Glazed Chicken, Asparagus, Red and Yellow Peppers, Peas, Garlic and Onion in a Spicy Chipotle Parmesan Cream Sauce.', 'Regular', '325.00', '10.10', '1448436199-CCF_SpicyChickenChipotlePasta.jpg', 0, 1, 0, '2015-11-25 07:23:19', 1),
(26, 9, 1, 'Pesto Fettuccine', 'French Beans | Shallots | Corn Kernels | Red Capsicum | Parmesan Cheese | Fresh basil | Pine Nuts | Garlic | Black Pepper | Extra Virgin Olive Oil', 'Regular', '186.12', '10.10', '1448437253-20417_l.jpg', 0, 0, 0, '2015-11-25 07:40:53', 1),
(27, 9, 1, 'Fettuccine in Spinach Sauce', 'White Sauce | Fresh Cream | Spinach Leaves | Black Pepper | Extra Virgin Olive Oil', 'Regular', '145.89', '10.10', '1448440693-RM0615_Spinach-Fettuccine-with-Clam-Butter-Sauce-and-Diced-tomatoes.jpg', 0, 1, 0, '2015-11-25 08:38:13', 1),
(28, 10, 1, 'Cheezy Crunch Wrap', 'Two crispy golden potato hash-browns, tri-pepper cheddar cheese sauce with jalapenos, paprika and green chillies, creamy thousand island sauce, fresh lettuce and crunchy onions; all wrapped inside a warm, soft tortilla.', '', '156.32', '10.10', '1448441485-cheezy_crunch_wrap_big.png', 2, 2, 0, '2015-11-25 08:51:25', 1),
(29, 10, 1, 'Spicy Paneer Wrap', 'Get ready to elevate your taste quotient with the superior, sizzling Paneer Wrap. Soft and tender paneer in a fiery, crunchy batter, dressed with fresh veggies & seasonings along with creamy sauce and a dash of mustard & melted cheese to surprise your taste buds each time you sink your teeth into it.', '', '305.00', '10.10', '1448443479-McSpicy-Paneer-Wrap.png', 2, 1, 1, '2015-11-25 09:24:39', 1),
(30, 10, 3, 'Grilled Chicken Wrap', 'Tender & juicy Grilled Chicken Patty wrapped in baked tortilla with crispy lettuce crunchy onions and lip-smacking chipotle sauce: it''s easy falling in love with it.', '', '289.56', '10.10', '1448444034-grilled-chicken-patty.png', 2, 0, 1, '2015-11-25 09:33:54', 1),
(31, 10, 3, 'Spicy Chicken Wrap', 'You will love the balanced blend of fresh soft tortilla wrap with tender and juicy chicken, fresh crisp lettuce, firm tomatoes and onions. Further topped with delicious creamy sauce and supple cheese slices seasoned with herbs & spices, the Spicy Chicken Wrap satiates your hunger like no other!', '', '319.78', '10.10', '1448444157-McSpicy-Chicken-Wrap.png', 2, 1, 0, '2015-11-25 09:35:57', 1),
(32, 10, 3, 'Beef & Potato Burritos', 'Saute diced potato with jalapeno, onion, and ground beef, then simmer with canned tomatoes and cumin to make the hearty filling for these burritos. Roll up in flour tortillas with sour cream, Monterey Jack cheese, and fresh cilantro.', '', '196.84', '10.10', '1448445053-cut_meatpotatoburrito.png', 2, 0, 0, '2015-11-25 09:48:33', 1),
(33, 12, 3, 'Ham & Swiss Panini', 'It is the simplicity of this sandwich that makes it so very elegant. Just ham and Swiss cheese served with tangy Dijon mustard on a focaccia roll. Irresistible in its minimalism, anything more would be overkill.', 'Regular', '355.75', '10.10', '1448446302-f0368361982644e1b2633814c7a1a359.jpg', 0, 0, 1, '2015-11-25 10:11:42', 1),
(34, 12, 3, 'Holiday Turkey & Stuffing Panini', 'A generous portion of sliced turkey breast is at the heart of this holiday-inspired panini. It''s topped with cranberry-herb stuffing, savory herbs and turkey gravy. Served on warm and toasty focaccia bread.', 'Regular', '365.48', '10.10', '1448446416-3b7f1e9729b34702b9be6fe0c7566964.jpg', 0, 1, 0, '2015-11-25 10:13:36', 1),
(35, 12, 1, 'Roasted Tomato & Mozzarella Panini', 'Roasted tomatoes, mozzarella, spinach and basil pesto on toasted focaccia.', 'Regular', '328.75', '10.10', '1448446659-e32921b35e62471ba269a370b15d59ed.jpg', 0, 1, 1, '2015-11-25 10:17:39', 1),
(36, 12, 1, 'Turkey Pesto Panini', 'Sliced turkey and melted provolone cheese with fire-roasted peppers and basil pesto on a toasted focaccia roll.', 'Regular', '334.56', '10.10', '1448446768-864ab6a1ad794d4fad61c0a8a64dd794.jpg', 0, 1, 0, '2015-11-25 10:19:28', 1),
(37, 12, 1, 'Turkey Rustico Panini', 'Sliced turkey, smoked Swiss cheese, Dijon mustard, sweet onion marmalade and baby kale on toasted wheat focaccia.', 'Regular', '308.89', '10.10', '1448446884-f684ade47fb64a93b2932570349fc580.jpg', 0, 1, 1, '2015-11-25 10:21:24', 1),
(38, 14, 4, 'Chewy Chocolate Cookie', 'Powdered sugar, egg whites and melted semisweet chocolate drops come together to create this crispy, chewy, gluten free cookie. Just a handful of ingredients bring a heaping of happiness.', '', '150.00', '10.10', '1448448636-1.png', 2, 1, 1, '2015-11-25 10:38:45', 1),
(39, 14, 4, 'Chocolate Chip Cookie', 'The more cookie, the merrier. We took our Chocolate Chip Cookie to the next level with a more generous size--and a more generous helping of chocolate chunks. Served warm and gooey in seconds.', '', '200.00', '0.00', '1448448752-2.png', 2, 1, 0, '2015-11-25 10:43:42', 1),
(40, 14, 4, 'Oatmeal Cookie', 'Our versatile cookie packed with rolled oats, chewy raisins and dried apricots doubles as a quick breakfast and an afternoon snack.', '', '212.89', '10.10', '1448448866-3.png', 2, 0, 1, '2015-11-25 10:54:26', 1),
(41, 14, 4, 'Pumpkin Cookie', 'Nothing says autumn yum like a whimsical, buttery, pumpkin shaped sugar cookie.', '', '205.45', '10.10', '1448448978-bb382ada654641dfb8fcc480a333b811.jpg', 2, 0, 0, '2015-11-25 10:56:18', 1),
(42, 15, 4, 'Banana Nut Bread', 'We start with bananas. Lots of them, to create the perfect slice that balances the flavor of creamy banana with hints of cinnamon, crunchy walnuts and pecans. Moist cake with nutty flavor and just a hint of crunch.', 'Regular', '195.00', '10.10', '1448449409-IMG_1698_1.jpg', 0, 0, 1, '2015-11-25 11:03:29', 1),
(43, 15, 4, 'Pumpkin Bread', 'Under a topping of crushed pepitas, this super moist slice is full of rich pumpkin flavor. It is a little bit spicy, a little bit creamy, a little bit chewy, and perfect with your favorite Starbucks beverage.', '', '208.56', '10.10', '1448449544-23a92776-6168-4095-ac73-492d97e7bb34.jpg', 0, 0, 0, '2015-11-25 11:05:44', 1),
(44, 15, 4, 'Applesauce Nut Bread', 'Moist cinnamon apple bread made with homemade applesauce, small chunks of fresh apples and walnuts in every bite. It''s so moist and delicious, you won''t believe it''s low fat!', '', '302.89', '10.10', '1448449635-applesauce-nut-bread.jpg', 0, 0, 1, '2015-11-25 11:07:15', 1),
(45, 15, 4, 'Lemon Yogurt Bread', 'Butter | Eggs | Lemon Juice | Baking Powder | Milk | Sugar', '', '315.55', '10.10', '1448450752-Glazed-Lemon-Bread-Loaf-Sliced.jpg', 0, 0, 0, '2015-11-25 11:25:52', 1),
(46, 16, 4, 'Devil''s Food Doughnut', 'A glazed, chocolate cake doughnut. Classic and wonderful.', '', '105.55', '10.10', '1448451302-b5d3d321a5274034808592813f5bc2d7.jpg', 0, 1, 1, '2015-11-25 11:35:02', 1),
(47, 16, 4, 'Everything Bagel with Cheese', 'A New York style bagel topped with Asiago cheese, poppy and sesame seeds, onion and garlic.', '', '125.50', '10.10', '1448452015-39eec89db0434789956ef032aa5f46a8.jpg', 0, 1, 0, '2015-11-25 11:46:55', 1),
(48, 16, 4, 'Mini Snowman Donut', 'Your sweet treat has never been this cute. A frosted mini chocolate cake donut adorned with a playful white chocolate snowman face.', '', '129.75', '10.10', '1448452079-35b42e6eed87461bbae03313b32e0f9d.jpg', 0, 1, 0, '2015-11-25 11:47:59', 1),
(49, 16, 4, 'Plain Bagel', 'A classic New York style bagel.', '', '102.80', '10.10', '1448452192-b5fed282e665482094729b35e276db67.jpg', 0, 1, 0, '2015-11-25 11:49:52', 1),
(50, 16, 4, 'Chonga Bagel', 'A bagel topped with Cheddar cheese, poppy seeds, sesame seeds, onion and garlic.', '', '115.55', '10.10', '1448452280-a58a1073a64440d6a1da454ab06e4473.jpg', 0, 1, 0, '2015-11-25 11:51:20', 1),
(51, 18, 4, 'Blueberry Muffin with Yogurt & Honey', 'Sweet, juicy blueberries are beautifully balanced with tangy yogurt and honey. The only way you could possibly improve on this muffin is to add a dollop of butter or jam.', '', '180.45', '10.10', '1448452495-0008cc8f22ba4d51999297d4cc9c78c0.jpg', 0, 1, 0, '2015-11-25 11:54:55', 1),
(52, 18, 4, 'Triple Chocolate Muffin', 'Delicious Chocolate muffin with white, milk and dark chocolate chunks and a gooey rich chocolate sauce centre.', '', '202.40', '10.10', '1448452743-ea6866e699804be197cbe69dc90f65b2.jpg', 0, 1, 0, '2015-11-25 11:59:03', 1),
(53, 18, 4, 'Spelt and Fruit Muffin', 'Packed with seeds, cranberries, raisins, honey and apple.', '', '199.50', '10.10', '1448452790-7f010fac0cf64107be5e120eb431566c.jpg', 0, 0, 0, '2015-11-25 11:59:50', 1),
(54, 18, 4, 'Snowball Muffin', 'Chocolate muffin filled with a smooth white chocolate filling, decorated with coconut.', '', '210.20', '10.10', '1448452841-8bfaf5413e8245899101d85b153e9a3a.jpg', 0, 1, 1, '2015-11-25 12:00:41', 1),
(55, 18, 4, 'Lemon & Poppyseed Muffin', 'A lemon muffin made with poppy seeds, lemon zest and buttermilk. Hand finished with lemon flavored icing.', '', '134.85', '10.10', '1448452919-681f49dec894450e8ed6341184700bc8.jpg', 0, 1, 0, '2015-11-25 12:01:59', 1),
(56, 19, 4, 'Brownie Fudge Sundae', 'One soft warm brownie. One mind-numbingly good scoop of vanilla ice cream. Chocolate sauce, whipped cream and a cherry. The Brownie Fudge Sundae is a true masterpiece of flavor!', '', '189.99', '10.10', '1448453397-SNS_Dessert_Brownie_Sundae_090612_350x300.png', 0, 0, 0, '2015-11-25 12:09:57', 1),
(57, 19, 4, 'Sizzle Dazzle Brownie', 'Sizzling hot gooey chocolate brownie served with vanilla ice cream and chocolate sauce.', '', '300.45', '10.10', '1448453681-ccd-sizzle-dazzle-brownie.jpg', 0, 0, 1, '2015-11-25 12:14:41', 1),
(58, 19, 4, 'Double Chocolate Brownie', 'A classic brownie made with premium chocolate and cocoa.', '', '303.45', '10.10', '1448453766-351bd17e0110484fb0a390a5536c51ed.jpg', 0, 0, 1, '2015-11-25 12:16:06', 1),
(59, 19, 4, 'Double Chocolate Chunk Brownie', 'Our Double Chocolate Brownie is a celebration of chocolaty goodness. We add plenty of rich chocolate chunks to our yummy brownie batter, then bake it all to melty perfection. Yes, it tastes as incredible as it sounds.', '', '345.00', '10.10', '1448453902-4.png', 0, 0, 0, '2015-11-25 12:18:22', 1),
(60, 19, 4, 'Michigan Cherry Oat Bar', 'Hearty oats and buttery streusel set the stage for the main attraction - a crop of plump, juicy cherries homegrown in Michigan. Sweet yet tart, this seasonal oat bar is the perfect wake-up call or afternoon pick-me-up.', '', '230.55', '10.10', '1448453944-5.png', 0, 0, 0, '2015-11-25 12:19:04', 1),
(61, 19, 4, 'Salted Caramel Brownie with Pecans', 'Discover a sweet and chewy treat with just the right amount of crunch. Made of rich chocolate, salty pretzels, pecans and creamy caramel, our decadent Salted Caramel Square is not to be missed.', '', '274.23', '10.10', '1448454017-7de9fbd038164908b56dbdf7eba50f56.jpg', 0, 0, 0, '2015-11-25 12:20:17', 1),
(62, 22, 5, 'Spicy Carrot Salad', 'Microwave grated carrots and minced garlic in 1/4 cup water until crisp-tender. Drain; toss with lemon juice, olive oil, salt, red pepper flakes and parsley.', 'small', '80.00', '10.10', '1448964620-7272.jpg', 0, 0, 0, '2015-12-01 10:09:11', 1),
(63, 22, 5, 'Asian Apple Slaw', 'Mix rice vinegar and lime juice with salt, sugar and fish sauce. Toss with julienned jicama and apple, chopped scallions and mint.', '', '80.00', '10.10', '1448965001-9802.jpg', 0, 0, 0, '2015-12-01 10:16:41', 1),
(64, 24, 6, 'Bacon Egg Roll', '', '', '5.50', '0.00', '1449006162-6397.jpg', 1, 1, 0, '2015-12-01 21:42:42', 1),
(65, 3, 2, 'Jack Daniels', 'Jack Daniel''s has a smooth aroma and flavour of vanilla, toasted oak and caramel translates well to the palate.', '', '9.00', '10.00', '1449096096-5708.png', 0, 1, 0, '2015-12-02 22:41:36', 1),
(66, 3, 2, 'Jim Beam', 'Jim Beam Kentucky Straight Bourbon Whiskey was originally distilled in 1795.', '', '8.00', '10.00', '1449096456-7441.png', 0, 1, 0, '2015-12-02 22:47:36', 1),
(67, 3, 2, 'Chivas Regal 12 yr old', 'Matured for 12 years the result is a rich and generous Whisky with honey and hazelnut notes and a long creamy finish.', '', '9.00', '10.00', '1449096572-6099.png', 0, 1, 0, '2015-12-02 22:49:32', 1),
(68, 3, 2, 'Southern Comfort', 'A fusion of peach, spices and Bourbon that captures the essence of America''s South', '', '8.00', '10.00', '1449096698-3136.png', 0, 1, 0, '2015-12-02 22:51:38', 1),
(69, 3, 2, 'Wild Turkey', 'Produced with a corn dominate mash, Wild Turkey''s 86.8 Proof has a deep golden colour and exceptional taste', '', '8.00', '10.00', '1449096799-9502.png', 0, 1, 0, '2015-12-02 22:53:19', 1),
(70, 5, 2, 'Matilda Bay Fat Yak', 'Fat Yak first impresses with its golden colour, distinctive, hop driven, fruity and herbaceous aromas, giving characteristic passionfruit and melon notes, followed by a whack of hop flavour at the finish', '', '9.00', '10.00', '1449097251-6809.png', 0, 0, 0, '2015-12-02 23:00:51', 1),
(71, 5, 2, 'Rekorderlig', 'Rekorderlig Strawberry & Lime Cider is made from the purest Swedish spring water and is bursting with deliciously ripe summer strawberry flavours', '', '9.00', '10.00', '1449097339-4645.png', 0, 0, 0, '2015-12-02 23:02:19', 1),
(72, 5, 2, 'Heineken', 'Crisp, clean and refreshing, this ever-popular beer is a classic European style Lager', '', '8.00', '10.00', '1449097608-1474.png', 0, 0, 0, '2015-12-02 23:06:48', 1),
(73, 3, 2, 'Glenfiddich 12 Yr Old', 'distinctive fresh and fruity nose with a hint of pear followed by a palate of butterscotch, cream, malt and a subtle oak thanks to its long maturation in Oloroso sherry and bourbon oak casks.', '', '9.00', '10.00', '1449097748-6073.png', 0, 0, 0, '2015-12-02 23:09:08', 1),
(74, 3, 2, 'Glenlivet 12 Year Old', 'Glenlivet is a supremely elegant whisky of rewarding and subtle complexity. Smoke, clover honey and heather', '', '9.00', '10.00', '1449097842-1868.png', 0, 0, 0, '2015-12-02 23:10:42', 1),
(75, 20, 2, 'Penfold''s Bin 128 Shiraz', 'Medium deep colour. Fresh redcurrant, red plum, cassis and cola aromas with lifted earthy, sage notes. Supple sweet redcurrant, cola, herb flavours, fine-grained tannins and underlying savoury complexity', '', '9.00', '10.00', '1449099120-1903.png', 2, 0, 0, '2015-12-02 23:32:00', 1),
(76, 20, 2, 'Penfold''s Bin 2005 Cabernet Shiraz', 'Nice ripeness, dark berries and clean, not overt but harmonious and measured. Good cassis, raspberry and hints of mint. Plenty of oak but it''s cleverly integrated with the fruit', '', '19.00', '10.00', '1449099355-5751.png', 2, 0, 0, '2015-12-02 23:35:55', 1),
(77, 20, 2, 'Cloudy Bay Pinot Noir', 'Leather, boysenberry and sweet spices combine. The supple palate with its transparent flavours of red fruit and earthy textures leads to a finish that is both balanced and intriguing', '', '10.00', '10.00', '1449099639-6476.png', 2, 0, 0, '2015-12-02 23:40:39', 1),
(78, 20, 2, 'Saltram 1859 Shiraz', 'The 1859 Shiraz is made in a contemporary vibrant and textural style, displaying notes of dark berry fruits and plums. The palate is typically rich with an excellent balance of fruit flavours, subtle tannins and a soft, velvety finish', '', '9.00', '10.00', '1449099923-8460.png', 0, 0, 0, '2015-12-02 23:45:23', 1),
(79, 29, 2, 'Cape Mentelle Sauvignon Blanc', 'Cape Mentelle Sauvignon Blanc Semillon is delicate yet full, the palate is distinctively lemon and lime with subtle star anise, lemongrass and clove.', '', '9.00', '10.00', '1449101544-8612.png', 0, 0, 0, '2015-12-03 00:12:24', 1),
(80, 29, 2, 'Chandon Brut', 'Chandon Non Vintage Brut is a classic in Australian sparkling', '', '9.00', '10.00', '1449101911-7893.png', 0, 0, 0, '2015-12-03 00:18:31', 1),
(81, 29, 2, 'Moet & Chandon Brut Imperial', 'Moët & Chandon Brut Impérial, with its perfect balance of Pinot Noir, Chardonnay and Pinot Meunier has become one of the world''s most-loved Champagnes', '', '9.00', '10.00', '1449102040-8136.png', 2, 0, 0, '2015-12-03 00:20:40', 1),
(82, 30, 7, 'Bacon Egg Roll', '', '', '5.50', '10.00', '1449658659-8745.jpg', 0, 1, 0, '2015-12-09 10:57:39', 1),
(83, 31, 7, 'BLT', 'Bacon Lettuce Tomato sandwich', '', '11.00', '10.00', '1449658790-9231.jpg', 0, 0, 0, '2015-12-09 10:59:50', 1),
(84, 32, 7, 'Rump Steak', 'Angus Rump 250g grainfed', '', '19.00', '10.00', '1449658935-8966.jpg', 0, 3, 0, '2015-12-09 11:02:15', 1),
(85, 33, 8, 'Coca Cola', '', '', '3.00', '10.00', '1449659223-2754.jpg', 0, 0, 0, '2015-12-09 11:07:03', 1),
(86, 33, 8, 'Orange Juice', 'Freshly squeezed orange juice', '', '3.00', '0.00', '1449659331-2596.jpg', 0, 0, 0, '2015-12-09 11:08:51', 1),
(88, 22, 5, 'It is temp ', 'asdkjlaksd', '', '200.00', '10.00', NULL, 0, 0, 0, '2015-12-15 08:53:55', 1);

-- --------------------------------------------------------

--
-- Table structure for table `item_discount`
--

CREATE TABLE IF NOT EXISTS `item_discount` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `discount_id` int(10) unsigned NOT NULL,
  `promotion_main_type` tinyint(1) unsigned NOT NULL COMMENT '1 = Based on daterange, 2 = Based on fix days range',
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `item_discount`
--

INSERT INTO `item_discount` (`id`, `item_id`, `discount_id`, `promotion_main_type`) VALUES
(1, 56, 1, 2),
(2, 57, 1, 1),
(3, 16, 2, 2),
(4, 56, 2, 1),
(5, 82, 3, 2),
(6, 83, 4, 2),
(7, 86, 5, 2);

-- --------------------------------------------------------

--
-- Table structure for table `item_discount_daterange`
--

CREATE TABLE IF NOT EXISTS `item_discount_daterange` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `promotion_sub` tinyint(1) unsigned NOT NULL COMMENT '1 = Discount Percentage, 2 = Fixed Price',
  `promotion_sub_value` decimal(10,2) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `item_discount_daterange`
--

INSERT INTO `item_discount_daterange` (`id`, `start_date`, `end_date`, `promotion_sub`, `promotion_sub_value`) VALUES
(1, '2015-12-01', '2015-12-31', 1, '10.00'),
(2, '2015-12-07', '2015-12-19', 1, '20.00');

-- --------------------------------------------------------

--
-- Table structure for table `item_discount_days`
--

CREATE TABLE IF NOT EXISTS `item_discount_days` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day` varchar(20) NOT NULL COMMENT '1 (for Monday) through 7 (for Sunday)',
  `all_day` tinyint(1) unsigned NOT NULL COMMENT '0 = For selected time range, 1 = For all day',
  `time_start` time NOT NULL,
  `time_end` time NOT NULL,
  `promotion_sub` tinyint(1) unsigned NOT NULL COMMENT '1 = Discount Percentage, 2 = Fixed Price',
  `promotion_sub_value` decimal(10,2) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `item_discount_days`
--

INSERT INTO `item_discount_days` (`id`, `day`, `all_day`, `time_start`, `time_end`, `promotion_sub`, `promotion_sub_value`) VALUES
(1, ',5,7,', 1, '00:00:00', '00:00:00', 1, '20.00'),
(2, ',5,6,7,', 1, '00:00:00', '00:00:00', 1, '10.00'),
(3, ',1,', 1, '00:00:00', '00:00:00', 1, '10.00'),
(4, ',1,2,3,4,', 1, '00:00:00', '00:00:00', 1, '10.00'),
(5, ',2,3,4,5,', 1, '00:00:00', '00:00:00', 2, '2.00');

-- --------------------------------------------------------

--
-- Table structure for table `item_option`
--

CREATE TABLE IF NOT EXISTS `item_option` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `option_main_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=60 ;

--
-- Dumping data for table `item_option`
--

INSERT INTO `item_option` (`id`, `item_id`, `option_main_id`) VALUES
(4, 5, 3),
(5, 11, 4),
(7, 12, 5),
(8, 13, 6),
(9, 6, 7),
(10, 14, 8),
(13, 15, 9),
(14, 16, 10),
(15, 17, 11),
(17, 18, 11),
(19, 18, 12),
(20, 20, 11),
(21, 21, 11),
(22, 22, 11),
(23, 23, 12),
(24, 24, 11),
(25, 25, 11),
(26, 27, 11),
(28, 28, 11),
(30, 28, 8),
(31, 29, 7),
(32, 31, 11),
(33, 34, 13),
(34, 35, 11),
(35, 36, 12),
(36, 37, 11),
(37, 38, 14),
(38, 39, 14),
(39, 46, 15),
(40, 47, 15),
(41, 48, 15),
(42, 49, 15),
(43, 50, 15),
(44, 51, 14),
(45, 52, 15),
(47, 54, 14),
(48, 55, 14),
(49, 64, 16),
(50, 65, 17),
(51, 4, 17),
(52, 66, 17),
(53, 67, 17),
(54, 68, 17),
(55, 69, 17),
(56, 84, 18),
(57, 84, 19),
(58, 84, 20),
(59, 82, 21);

-- --------------------------------------------------------

--
-- Table structure for table `item_options_old_backup`
--

CREATE TABLE IF NOT EXISTS `item_options_old_backup` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `option_name` varchar(64) NOT NULL,
  `description` varchar(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `images` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `item_option_main`
--

CREATE TABLE IF NOT EXISTS `item_option_main` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL,
  `option_name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_id` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `item_option_main`
--

INSERT INTO `item_option_main` (`id`, `store_id`, `option_name`) VALUES
(1, 1, 'Side Orders'),
(2, 1, 'Snacks'),
(3, 1, 'Toppings'),
(4, 1, 'Beverages'),
(5, 1, 'Customized Premium Ingredients'),
(6, 1, 'Customized Premium Ingredients'),
(7, 1, 'Toppings'),
(8, 1, 'Toppings'),
(9, 1, 'Toppings'),
(10, 1, 'Toppings'),
(11, 1, 'Cheese Toppings'),
(12, 1, 'Bell Peppers Toppings'),
(13, 1, 'Breads'),
(14, 1, 'Toppings for Muffins'),
(15, 1, 'Toppings for Muffin'),
(16, 11, 'Sauce'),
(17, 1, 'Mixers'),
(18, 13, 'Cook'),
(19, 13, 'Sauce'),
(20, 13, 'Sides'),
(21, 13, 'Sauce condiment');

-- --------------------------------------------------------

--
-- Table structure for table `item_option_sub`
--

CREATE TABLE IF NOT EXISTS `item_option_sub` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL,
  `sub_name` varchar(256) NOT NULL,
  `sub_amount` decimal(10,2) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `option_id` (`option_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=149 ;

--
-- Dumping data for table `item_option_sub`
--

INSERT INTO `item_option_sub` (`id`, `option_id`, `sub_name`, `sub_amount`) VALUES
(18, 2, 'Chocolate', '8.00'),
(19, 2, 'Pork ribs', '20.00'),
(25, 4, 'Iced Tea', '33.56'),
(26, 4, 'Cold Coffee', '42.67'),
(27, 4, 'Black Tea', '40.00'),
(28, 4, 'Black Coffee', '49.87'),
(78, 14, 'Nuts', '44.56'),
(79, 14, 'Chocolate Sauce', '13.78'),
(80, 14, 'Powdered Sugar', '0.00'),
(84, 1, 'Cheeze', '5.00'),
(85, 1, 'chips', '10.00'),
(86, 16, 'BBQ', '0.00'),
(87, 16, 'Tomato', '0.00'),
(88, 17, 'Soda', '0.00'),
(89, 17, 'Cola', '0.00'),
(90, 17, 'Tonic', '0.00'),
(91, 17, 'Dry Ginger Ale', '0.00'),
(92, 17, 'Orange', '0.00'),
(93, 17, 'Cranberry', '0.00'),
(94, 17, 'Pineapple', '0.00'),
(95, 17, 'Red Bull', '1.00'),
(96, 3, 'Extra Cheese', '1.00'),
(97, 3, 'Tomatoes', '1.00'),
(98, 7, 'Grilled Panner', '1.00'),
(99, 7, 'American Cheese', '1.00'),
(100, 8, 'Onions', '1.00'),
(101, 8, 'Mushrooms', '1.00'),
(102, 8, 'Bell Peppers', '1.00'),
(103, 8, 'Double Cheese', '1.00'),
(104, 9, 'Crispy Barbecue', '1.00'),
(105, 9, 'Parmesan Cheese', '1.00'),
(106, 5, 'Pickles', '1.00'),
(107, 5, 'American Cheese', '1.00'),
(108, 5, 'Tomatoes', '1.00'),
(109, 5, 'Onions', '1.00'),
(110, 6, 'American Chesse', '1.00'),
(111, 6, 'Eggs', '2.00'),
(112, 6, 'Ham', '1.00'),
(113, 10, 'Chicken Salami', '1.00'),
(114, 10, 'Pepper Roast Chicken', '1.00'),
(119, 12, 'Red Pepper', '1.00'),
(120, 12, 'Yellow Pepper', '1.00'),
(121, 12, 'Green Pepper', '1.00'),
(122, 13, 'White Bread', '2.00'),
(123, 13, 'Brown Bread', '2.00'),
(124, 13, 'Anadama Bread', '3.00'),
(125, 13, 'French Bread', '3.00'),
(126, 15, 'Caramelized', '1.00'),
(127, 15, 'Fresh Cream', '1.00'),
(128, 15, 'Vermicelli', '1.00'),
(129, 11, 'Tasty Cheese', '1.00'),
(130, 11, 'Mozzarella Cheese ', '1.00'),
(131, 11, 'Parmesan Cheese', '1.00'),
(132, 11, 'Cheddar Cheese', '10.00'),
(137, 19, 'Mushroom', '0.00'),
(138, 19, 'Pepper', '0.00'),
(139, 19, 'Gravy', '0.00'),
(140, 19, 'Diane', '0.00'),
(141, 20, 'Chips and Salad', '0.00'),
(142, 20, 'Mash Potato and Vegetable', '0.00'),
(143, 18, 'Rare', '0.00'),
(144, 18, 'Medium rare', '5.00'),
(145, 18, 'Medium', '5.50'),
(146, 18, 'Well Done', '5.99'),
(147, 21, 'Tomato', '0.00'),
(148, 21, 'BBQ', '0.00');

-- --------------------------------------------------------

--
-- Table structure for table `item_variety`
--

CREATE TABLE IF NOT EXISTS `item_variety` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `variety_name` varchar(64) NOT NULL,
  `variety_price` double(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=51 ;

--
-- Dumping data for table `item_variety`
--

INSERT INTO `item_variety` (`id`, `item_id`, `variety_name`, `variety_price`) VALUES
(3, 5, 'Regular', 15.00),
(4, 5, 'Medium', 18.00),
(5, 5, 'Large', 35.00),
(6, 6, 'Regular', 235.00),
(7, 6, 'Medium', 455.00),
(8, 6, 'Large', 685.00),
(9, 10, 'Small', 62.49),
(10, 10, 'Medium', 76.53),
(11, 10, 'Large', 90.23),
(12, 11, 'Small', 56.42),
(13, 11, 'Medium', 62.86),
(14, 11, 'Large', 71.84),
(15, 14, 'Regular', 17.00),
(16, 14, 'Medium', 20.00),
(17, 14, 'Large', 35.00),
(18, 15, 'Regular', 17.00),
(19, 15, 'Medium', 20.00),
(20, 15, 'Large', 25.00),
(21, 16, 'Regular', 16.00),
(22, 16, 'Medium', 19.00),
(23, 16, 'Large', 35.00),
(24, 28, 'Regular', 156.32),
(25, 28, 'Large', 285.15),
(26, 29, 'Regular', 305.00),
(27, 29, 'Large', 465.00),
(28, 30, 'Regular', 289.56),
(29, 30, 'Large', 323.78),
(30, 31, 'Regular', 319.78),
(31, 31, 'Large', 425.23),
(32, 32, 'Regular', 196.84),
(33, 32, 'Large', 296.23),
(34, 38, 'Regular', 174.23),
(35, 38, 'Large', 300.00),
(36, 39, 'Regular', 200.00),
(37, 39, 'Large', 225.00),
(38, 40, 'Regular', 212.89),
(39, 40, 'Large', 325.78),
(40, 41, 'Regular', 205.45),
(41, 41, 'Large', 295.56),
(42, 64, 'Coffee', 3.00),
(43, 75, 'Glass', 9.00),
(44, 75, 'Bottle', 68.00),
(45, 76, 'Glass', 19.00),
(46, 76, 'Bottle', 124.00),
(47, 77, 'Glass', 10.00),
(48, 77, 'Bottle', 90.00),
(49, 81, 'Glass', 9.00),
(50, 81, 'Bottle', 70.00);

-- --------------------------------------------------------

--
-- Table structure for table `kitchens`
--

CREATE TABLE IF NOT EXISTS `kitchens` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL,
  `kitchen_name` varchar(256) NOT NULL,
  `kitchen_description` text NOT NULL,
  `added_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_id` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `kitchens`
--

INSERT INTO `kitchens` (`id`, `store_id`, `kitchen_name`, `kitchen_description`, `added_date`) VALUES
(1, 1, 'Veg Section', 'dsf sere r wweori uwekxdfjhdkjf soeiruweo idjbfdkn bfds', '2015-12-03 00:00:00'),
(2, 1, 'Bar', 'asd 2qe3qweqwe', '2015-12-01 00:00:00'),
(3, 1, 'Non Veg Section', 'Non vegetarian dishes are available here. ', '2015-12-02 00:00:00'),
(4, 1, 'Bakery', '', '2015-12-01 00:00:00'),
(5, 8, 'Veg', '', '2015-12-02 00:00:00'),
(6, 11, 'Kitchen', '', '2015-12-01 00:00:00'),
(7, 13, 'Hot Food', '', '2015-12-09 10:28:34'),
(8, 13, 'Bar', '', '2015-12-09 10:28:51');

-- --------------------------------------------------------

--
-- Table structure for table `login_user`
--

CREATE TABLE IF NOT EXISTS `login_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(256) NOT NULL,
  `password` varchar(512) NOT NULL,
  `role` tinyint(2) unsigned NOT NULL COMMENT '1 = Super Admin, 2 = Account Login User, 3 = Kitchen Cook, 4 = Employee',
  `auth_key` varchar(256) DEFAULT NULL,
  `password_reset_token` varchar(256) DEFAULT NULL,
  `verif_code_exp` datetime DEFAULT NULL,
  `verif_link` varchar(512) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `last_login_ip` varchar(256) DEFAULT NULL,
  `added_date` datetime NOT NULL,
  `status` tinyint(1) NOT NULL COMMENT '1 = Active, 0 = Inactive',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `login_user`
--

INSERT INTO `login_user` (`id`, `email`, `password`, `role`, `auth_key`, `password_reset_token`, `verif_code_exp`, `verif_link`, `last_login_date`, `last_login_ip`, `added_date`, `status`) VALUES
(1, 'shirishm.makwana@gmail.com', '$2y$13$rThaWp3g3PdBwiHc2vu5Nuo8oX1qdz0NBxqlvztho6N/jjrrs7t/C', 1, '', NULL, NULL, '', '2016-01-07 07:18:25', '182.237.14.179', '2015-11-09 00:00:00', 1),
(2, 'shirishm.makwana@hotmail.com', '$2y$13$b/T48snutH.nbcgj136djuJfqglV5ktX99lgqH15M1dr/M/VNVY8W', 2, NULL, NULL, NULL, NULL, '2016-01-06 09:52:36', '182.237.14.179', '2015-11-21 18:37:05', 1),
(4, 'krishnamaru123@gmail.com', '$2y$13$CVDW3plcKdKcaHdKAPaepuptYPxryVRZdByRPLPimRaX0pvE2xBjW', 3, NULL, NULL, NULL, NULL, '2015-11-25 11:53:17', '103.240.76.19', '2015-11-23 04:39:02', 1),
(5, 'krs@gmail.com', '$2y$13$qaKbWiVOpMY.hklKN2AxZetK5IXEk6x0i1Qik5IelzFozrZwJWs.O', 3, NULL, NULL, NULL, NULL, NULL, NULL, '2015-11-23 05:10:37', 1),
(6, 'binnisheth2210@gmail.com', '$2y$13$hX0tdn5CSZqvCl1w1VTveeHT4Q4ld6OR4cqxgtxKUoXt9RBrZCF9C', 3, NULL, NULL, NULL, NULL, NULL, NULL, '2015-11-25 04:34:06', 1),
(8, 'aparmar714@gmail.com', '$2y$13$wszrpZpat24TI/ob.LXO2.6moCxbTsm9.0mBR/WdOIn6cv8vMvC3u', 3, NULL, NULL, NULL, NULL, NULL, NULL, '2015-11-25 10:37:45', 1),
(11, 'shirishm.makwana3@gmail.com', '$2y$13$HV/hY8CU2rRHlDWQLnqP3.g9rO88P05c1gRztI0mssrprTxL8rpxy', 2, NULL, NULL, NULL, NULL, NULL, NULL, '2015-12-01 05:04:18', 1),
(12, 'parth@gmail.com', '$2y$13$97X0jTkHsbZrj.cK/tb.x.Tx.gGXQR0TwpmJLFGzkVjTa0DtAOKJu', 3, NULL, NULL, NULL, NULL, NULL, NULL, '2015-12-01 10:07:54', 1),
(13, 'test@test.com', '$2y$13$D.DakZ6hTIxHkIPKAfbwVOHk1V.gy9dO8Y8vRaZxtTu0AyDtQodK2', 2, NULL, NULL, NULL, NULL, '2015-12-14 03:44:39', '27.32.94.38', '2015-12-01 21:03:45', 1),
(14, 'test1@test.com', '$2y$13$wdyj.sx.lYG0etlsOH9G1eiCKk2xoRXHLPR3UOgwrhUE2a7kIUvIW', 3, NULL, NULL, NULL, NULL, '2015-12-14 05:55:28', '150.129.151.66', '2015-12-01 21:42:02', 1),
(15, 'parthsadariya@gmail.com', '$2y$13$TUJOJU8jjrW5sN1g4Gt40eLZC2vb8uWa.FN9RQIuzrgfnyjryTgD.', 3, NULL, NULL, NULL, NULL, '2015-12-04 12:06:13', '103.240.76.137', '2015-12-04 12:05:55', 1),
(16, 'vv@gmail.com', '74fbba3034155ae597d04a2ec6f636d5', 4, NULL, NULL, NULL, NULL, '2016-01-05 10:36:05', '182.237.14.179', '2015-12-04 12:06:59', 1),
(17, 'spa_mme@yahoo.com.au', '$2y$13$fuyWODHi31JWktojQK5/7eF42JGu1wo0GYRvBetlzOsM18XVKRani', 2, NULL, NULL, NULL, NULL, '2015-12-28 05:51:17', '103.250.189.67', '2015-12-09 10:14:24', 1),
(18, 'test2@test.com', '$2y$13$vzzGh79ETt933O4K58sUTeUU0KFMkANT6Va9n432ys/hzCREg4XTy', 3, NULL, NULL, NULL, NULL, '2016-01-06 06:54:01', '182.237.14.179', '2015-12-09 10:39:28', 1),
(19, 'test3@test.com', '$2y$13$wO/eaMitzc7OZTE2Ru/C.uUJHq.wz0kwX4wa4txBnqF/w486bt.VC', 3, NULL, NULL, NULL, NULL, '2016-01-04 09:18:18', '182.237.14.179', '2015-12-09 10:40:56', 1),
(20, 'test@gmail.com', '$2y$13$oDlk.bFU3hF7G6LSczd8UOiyBIZxwcUT1E1e0kXe0Wb.pA7fIt5bG', 3, NULL, NULL, NULL, NULL, '2016-01-06 06:41:10', '182.237.14.179', '2015-12-10 05:20:49', 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `waiter_id` int(10) unsigned DEFAULT NULL,
  `store_id` int(10) unsigned NOT NULL,
  `order_number` varchar(20) NOT NULL,
  `invoice_number` varchar(30) NOT NULL,
  `order_type` tinyint(1) NOT NULL COMMENT '1 = Online, 2 = Offline',
  `table_location` varchar(256) NOT NULL,
  `total_amount` decimal(10,2) unsigned NOT NULL,
  `add_note` varchar(512) NOT NULL,
  `transaction_id` varchar(256) DEFAULT NULL,
  `payment_done_date` datetime DEFAULT NULL,
  `payment_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = Pending, ',
  `status` tinyint(1) unsigned NOT NULL,
  `n_datetime` datetime NOT NULL COMMENT 'New/Order Placed Datetime',
  `p_datetime` datetime DEFAULT NULL COMMENT 'Processing Datetime',
  `r_datetime` datetime DEFAULT NULL COMMENT 'Ready Datetime',
  `c_datetime` datetime DEFAULT NULL COMMENT 'Completed/Cancel Datetime',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `store_id` (`store_id`),
  KEY `waiter_id` (`waiter_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=219 ;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `waiter_id`, `store_id`, `order_number`, `invoice_number`, `order_type`, `table_location`, `total_amount`, `add_note`, `transaction_id`, `payment_done_date`, `payment_status`, `status`, `n_datetime`, `p_datetime`, `r_datetime`, `c_datetime`) VALUES
(1, 1, NULL, 1, '1', 'INV-1', 1, '1', '130.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 06:15:14', NULL, NULL, NULL),
(2, 1, NULL, 1, '2', 'INV-2', 1, '2', '690.30', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 06:17:10', NULL, NULL, NULL),
(3, 1, NULL, 1, '3', 'INV-3', 1, '3', '235.10', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 07:15:14', NULL, NULL, NULL),
(4, 1, NULL, 1, '4', 'INV-4', 1, '4', '50.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 07:17:11', NULL, NULL, NULL),
(5, 1, NULL, 1, '5', 'INV-5', 1, '5', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 10:10:46', NULL, NULL, NULL),
(6, 1, NULL, 1, '6', 'INV-6', 1, '6', '515.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 10:13:30', NULL, NULL, NULL),
(14, 2, NULL, 1, '7', '1', 1, '2', '316.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 13:34:09', NULL, NULL, NULL),
(15, 2, NULL, 1, '8', '2', 1, '2', '316.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 14:01:53', NULL, NULL, NULL),
(16, 2, NULL, 1, '9', '3', 1, '2', '416.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 14:02:49', NULL, NULL, NULL),
(17, 2, NULL, 1, '10', '4', 1, '2', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 14:09:29', NULL, NULL, NULL),
(18, 2, NULL, 1, '11', '5', 1, '2', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 14:11:12', NULL, NULL, NULL),
(19, 2, NULL, 1, '12', '6', 1, '2', '230.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 14:11:44', NULL, NULL, NULL),
(20, 2, NULL, 1, '13', '7', 1, '2', '530.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 14:16:07', NULL, NULL, NULL),
(21, 2, NULL, 1, '14', '8', 1, '2', '396.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-23 14:18:03', NULL, NULL, NULL),
(23, 3, NULL, 1, '15', '9', 1, '2', '235.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-24 03:59:09', NULL, NULL, NULL),
(24, 2, NULL, 1, '16', '10', 1, '2', '500.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-24 12:49:38', NULL, NULL, NULL),
(25, 4, NULL, 1, '17', '11', 1, '2', '76.53', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 04:59:28', NULL, NULL, NULL),
(26, 4, NULL, 1, '17', '12', 1, '2', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:39:16', NULL, NULL, NULL),
(27, 4, NULL, 1, '17', '13', 1, '2', '50.91', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:41:15', NULL, NULL, NULL),
(28, 2, NULL, 1, '17', '14', 1, '2', '235.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:42:41', NULL, NULL, NULL),
(29, 2, NULL, 1, '17', '15', 1, '2', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:46:18', NULL, NULL, NULL),
(30, 4, NULL, 1, '17', '16', 1, '2', '87.48', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:50:26', NULL, NULL, NULL),
(31, 4, NULL, 1, '17', '17', 1, '2', '235.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:50:53', NULL, NULL, NULL),
(32, 4, NULL, 1, '17', '18', 1, '2', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:53:09', NULL, NULL, NULL),
(33, 4, NULL, 1, '17', '19', 1, '2', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:53:26', NULL, NULL, NULL),
(34, 4, NULL, 1, '17', '20', 1, '2', '315.45', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:56:08', NULL, NULL, NULL),
(35, 4, NULL, 1, '17', '21', 1, '2', '130.91', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 05:57:28', NULL, NULL, NULL),
(36, 4, NULL, 1, '17', '22', 1, '2', '140.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 06:03:04', NULL, NULL, NULL),
(37, 4, NULL, 1, '17', '23', 1, '2', '335.45', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 06:04:49', NULL, NULL, NULL),
(38, 4, NULL, 1, '17', '24', 1, '2', '97.23', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 06:06:29', NULL, NULL, NULL),
(39, 4, NULL, 1, '17', '25', 1, '2', '511.54', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 06:08:29', NULL, NULL, NULL),
(40, 4, NULL, 1, '17', '26', 1, '2', '220.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 06:19:49', NULL, NULL, NULL),
(41, 4, NULL, 1, '17', '27', 1, '2', '178.13', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 06:21:38', NULL, NULL, NULL),
(42, 4, NULL, 1, '17', '28', 1, '2', '350.70', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 06:23:28', NULL, NULL, NULL),
(43, 4, NULL, 1, '18', '29', 1, '2', '75.23', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 07:33:22', NULL, NULL, NULL),
(44, 4, NULL, 1, '19', '30', 1, '2', '56.42', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 08:30:55', NULL, NULL, NULL),
(45, 4, NULL, 1, '20', '31', 1, '2', '56.42', 'repeat my old order', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 09:23:18', NULL, NULL, NULL),
(46, 5, NULL, 1, '21', '32', 1, '2', '56.42', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-25 22:57:35', NULL, NULL, NULL),
(47, 2, NULL, 1, '22', '33', 1, '2', '731.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-26 06:38:45', NULL, NULL, NULL),
(48, 2, NULL, 1, '22', '34', 1, '2', '300.45', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-26 06:40:33', NULL, NULL, NULL),
(49, 2, NULL, 1, '22', '35', 1, '2', '548.48', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-26 06:44:21', NULL, NULL, NULL),
(50, 2, NULL, 1, '1', '36', 1, '2', '305.58', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-27 07:02:42', NULL, NULL, NULL),
(51, 5, NULL, 1, '2', '37', 1, '2', '210.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-11-27 22:17:03', NULL, NULL, NULL),
(52, 7, NULL, 1, '1', '38', 1, '2', '237.95', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-01 04:54:59', NULL, NULL, NULL),
(53, 2, NULL, 1, '2', '39', 1, '2', '450.91', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 05:18:57', NULL, NULL, NULL),
(54, 2, NULL, 1, '2', '40', 1, '2', '513.30', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 05:26:56', NULL, NULL, NULL),
(55, 2, NULL, 1, '2', '41', 1, '2', '513.30', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 05:35:51', NULL, NULL, NULL),
(56, 2, NULL, 1, '2', '42', 1, '2', '75.23', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 06:36:45', NULL, NULL, NULL),
(57, 2, NULL, 1, '3', '43', 1, '2', '330.55', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 09:35:27', NULL, NULL, NULL),
(58, 2, NULL, 1, '4', '44', 1, '2', '165.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 11:02:08', NULL, NULL, NULL),
(59, 8, NULL, 1, '5', '45', 1, '2', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 11:02:30', NULL, NULL, NULL),
(60, 2, NULL, 1, '6', '46', 1, '2', '175.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 11:04:51', NULL, NULL, NULL),
(61, 8, NULL, 1, '7', '47', 1, '2', '62.50', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-02 11:10:34', NULL, NULL, NULL),
(62, 5, NULL, 1, '8', '48', 1, '2', '16.00', 'Boo', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-03 02:05:44', NULL, NULL, NULL),
(63, 2, NULL, 1, '9', '49', 1, '1', '60.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-03 11:54:41', NULL, NULL, NULL),
(64, 2, NULL, 1, '10', '50', 1, '1', '76.53', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-03 12:06:55', NULL, NULL, NULL),
(65, 6, NULL, 1, '11', '51', 1, '2', '62.50', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 03:54:28', NULL, NULL, NULL),
(66, 4, NULL, 1, '11', '52', 1, '1', '47.23', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 04:34:38', NULL, NULL, NULL),
(67, 3, NULL, 1, '11', '53', 1, '1', '56.42', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 04:44:05', NULL, NULL, NULL),
(68, 3, NULL, 1, '11', '54', 1, '1', '305.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 04:45:23', NULL, NULL, NULL),
(69, 2, NULL, 1, '12', '55', 1, '1', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 08:57:35', NULL, NULL, NULL),
(70, 3, NULL, 1, '13', '56', 1, '1', '50.91', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 09:28:03', NULL, NULL, NULL),
(71, 3, NULL, 1, '14', '57', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 10:29:23', NULL, NULL, NULL),
(72, 3, NULL, 1, '15', '58', 1, '1', '174.23', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 11:42:23', NULL, NULL, NULL),
(73, 3, NULL, 1, '16', '59', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 11:51:20', NULL, NULL, NULL),
(74, 3, NULL, 1, '17', '60', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 12:00:58', NULL, NULL, NULL),
(75, 3, NULL, 1, '18', '61', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 12:01:29', NULL, NULL, NULL),
(76, 3, NULL, 1, '19', '62', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 12:12:16', NULL, NULL, NULL),
(77, 3, NULL, 1, '20', '63', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 12:21:00', NULL, NULL, NULL),
(78, 3, NULL, 1, '21', '64', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 12:26:12', NULL, NULL, NULL),
(79, 3, NULL, 1, '22', '65', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 13:00:09', NULL, NULL, NULL),
(80, 3, NULL, 1, '22', '65', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-04 13:00:09', NULL, NULL, NULL),
(81, 3, NULL, 1, '23', '66', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-05 04:33:07', NULL, NULL, NULL),
(82, 3, NULL, 1, '23', '67', 1, '1', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-05 04:39:09', NULL, NULL, NULL),
(83, 3, NULL, 1, '23', '68', 1, '1', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-05 04:41:29', NULL, NULL, NULL),
(84, 3, NULL, 1, '23', '69', 1, '1', '151.99', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-05 04:55:50', NULL, NULL, NULL),
(85, 3, NULL, 1, '23', '70', 1, '1', '80.00', '', '123465', '2015-12-04 23:11:22', 1, 1, '2015-12-05 05:25:35', NULL, NULL, NULL),
(86, 3, NULL, 1, '24', '71', 1, '1', '151.99', '', NULL, NULL, 0, 1, '2015-12-05 13:21:59', NULL, NULL, NULL),
(87, 3, NULL, 1, '1', '72', 1, '1', '151.99', '', NULL, NULL, 0, 1, '2015-12-07 04:19:35', NULL, NULL, NULL),
(88, 3, NULL, 1, '1', '73', 1, '1', '263.48', '', NULL, NULL, 0, 1, '2015-12-07 06:44:31', NULL, NULL, NULL),
(89, 3, NULL, 1, '1', '74', 1, '1', '263.48', '', NULL, NULL, 0, 1, '2015-12-07 06:44:47', NULL, NULL, NULL),
(90, 3, NULL, 1, '1', '75', 1, '1', '202.12', '', NULL, NULL, 0, 1, '2015-12-07 06:49:04', NULL, NULL, NULL),
(91, 3, NULL, 1, '1', '76', 1, '1', '228.99', '', NULL, NULL, 0, 1, '2015-12-07 06:55:47', NULL, NULL, NULL),
(92, 3, NULL, 1, '2', '77', 1, '1', '608.31', '', NULL, NULL, 0, 1, '2015-12-07 07:00:16', NULL, NULL, NULL),
(93, 3, NULL, 1, '3', '78', 1, '1', '334.56', '', 'ch_17FJUtAh5ZKZcdGAmtl0b9K2', '2015-12-07 07:33:23', 1, 1, '2015-12-07 07:23:22', NULL, NULL, NULL),
(94, 4, NULL, 1, '4', '79', 1, '1', '129.75', '', NULL, NULL, 0, 1, '2015-12-07 08:19:09', NULL, NULL, NULL),
(95, 4, NULL, 1, '5', '80', 1, '1', '156.32', '', NULL, NULL, 0, 1, '2015-12-07 08:21:56', NULL, NULL, NULL),
(96, 4, NULL, 1, '6', '81', 1, '1', '470.00', '', 'ch_17FKL4Ah5ZKZcdGAUTunRQns', '2015-12-07 08:27:19', 1, 1, '2015-12-07 08:25:54', NULL, NULL, NULL),
(97, 4, NULL, 1, '7', '82', 1, '1', '80.00', '', 'ch_17FKhHAh5ZKZcdGA5CAmU3OX', '2015-12-07 08:50:15', 1, 1, '2015-12-07 08:50:05', NULL, NULL, NULL),
(98, 2, NULL, 1, '8', '83', 1, '1', '170.99', '', 'ch_17FKqSAh5ZKZcdGACiiFGRbE', '2015-12-07 08:59:45', 1, 1, '2015-12-07 08:58:23', NULL, NULL, NULL),
(99, 3, NULL, 1, '9', '84', 1, '1', '263.48', '', NULL, NULL, 0, 1, '2015-12-07 09:13:37', NULL, NULL, NULL),
(100, 2, NULL, 1, '10', '85', 1, '1', '334.56', '', NULL, NULL, 0, 1, '2015-12-07 09:18:07', NULL, NULL, NULL),
(101, 2, NULL, 1, '11', '86', 1, '1', '62.49', '', 'ch_17FLG0Ah5ZKZcdGADK4SXyRU', '2015-12-07 09:26:09', 1, 1, '2015-12-07 09:25:22', NULL, NULL, NULL),
(102, 4, NULL, 1, '12', '87', 1, '1', '15.00', '', NULL, NULL, 0, 1, '2015-12-07 09:43:45', NULL, NULL, NULL),
(103, 4, NULL, 1, '13', '88', 1, '1', '151.99', '', NULL, NULL, 0, 1, '2015-12-07 09:57:40', NULL, NULL, NULL),
(104, 4, NULL, 1, '14', '89', 1, '1', '289.56', '', NULL, NULL, 0, 1, '2015-12-07 10:03:50', NULL, NULL, NULL),
(105, 2, NULL, 1, '15', '90', 1, '1', '156.32', '', 'ch_17FM05Ah5ZKZcdGAA6dBuj2L', '2015-12-07 10:13:46', 1, 1, '2015-12-07 10:13:35', NULL, NULL, NULL),
(106, 2, NULL, 1, '16', '91', 1, '1', '30.00', '', NULL, NULL, 0, 1, '2015-12-07 10:17:25', NULL, NULL, NULL),
(107, 2, NULL, 1, '17', '92', 1, '1', '30.00', '', 'ch_17FM3rAh5ZKZcdGAVzETPEsA', '2015-12-07 10:17:39', 1, 1, '2015-12-07 10:17:31', NULL, NULL, NULL),
(108, 2, NULL, 1, '18', '93', 1, '1', '17.00', '', NULL, NULL, 0, 1, '2015-12-07 10:20:09', NULL, NULL, NULL),
(109, 2, NULL, 1, '19', '94', 1, '1', '289.56', '', NULL, NULL, 0, 1, '2015-12-07 10:24:48', NULL, NULL, NULL),
(110, 2, NULL, 1, '20', '95', 1, '1', '196.84', '', NULL, NULL, 0, 1, '2015-12-07 10:30:45', NULL, NULL, NULL),
(111, 2, NULL, 1, '21', '96', 1, '1', '289.56', '', NULL, NULL, 0, 1, '2015-12-07 10:36:25', NULL, NULL, NULL),
(112, 2, NULL, 1, '22', '97', 1, '1', '17.00', '', NULL, NULL, 0, 1, '2015-12-07 10:41:22', NULL, NULL, NULL),
(113, 2, NULL, 1, '23', '98', 1, '1', '16.00', '', NULL, NULL, 0, 1, '2015-12-07 10:46:37', NULL, NULL, NULL),
(114, 2, NULL, 1, '24', '99', 1, '1', '8.00', '', NULL, NULL, 0, 1, '2015-12-07 10:50:02', NULL, NULL, NULL),
(115, 5, NULL, 1, '25', '100', 1, '2', '1435.71', '', NULL, NULL, 0, 1, '2015-12-07 11:09:26', NULL, NULL, NULL),
(116, 5, NULL, 1, '26', '101', 1, '2', '1435.71', '', NULL, NULL, 0, 1, '2015-12-07 11:09:29', NULL, NULL, NULL),
(117, 2, NULL, 1, '27', '102', 1, '1', '50.00', '', NULL, NULL, 0, 1, '2015-12-07 11:15:38', NULL, NULL, NULL),
(118, 2, NULL, 1, '28', '103', 1, '1', '50.00', '', NULL, NULL, 0, 1, '2015-12-07 11:16:30', NULL, NULL, NULL),
(119, 2, NULL, 1, '29', '104', 1, '1', '50.00', '', NULL, NULL, 0, 1, '2015-12-07 11:16:41', NULL, NULL, NULL),
(120, 2, NULL, 1, '30', '105', 1, '1', '50.00', '', 'ch_17FMzoAh5ZKZcdGAufsWUvk2', '2015-12-07 11:17:33', 1, 1, '2015-12-07 11:16:50', NULL, NULL, NULL),
(121, 2, NULL, 1, '31', '106', 1, '1', '270.41', '', NULL, NULL, 0, 1, '2015-12-07 11:41:28', NULL, NULL, NULL),
(122, 2, NULL, 1, '32', '107', 1, '1', '151.99', '', 'ch_17FNQeAh5ZKZcdGAASVNIoAP', '2015-12-07 11:45:17', 1, 1, '2015-12-07 11:44:57', NULL, NULL, NULL),
(123, 2, NULL, 1, '33', '108', 1, '1', '8.00', '', NULL, NULL, 0, 1, '2015-12-07 11:48:55', NULL, NULL, NULL),
(124, 2, NULL, 1, '34', '109', 1, '1', '168.99', '', NULL, NULL, 0, 1, '2015-12-07 11:49:10', NULL, NULL, NULL),
(125, 2, NULL, 1, '35', '110', 1, '1', '16.00', '', NULL, NULL, 0, 1, '2015-12-07 11:50:52', NULL, NULL, NULL),
(126, 2, NULL, 1, '36', '111', 1, '1', '319.78', '', NULL, NULL, 0, 1, '2015-12-07 11:54:13', NULL, NULL, NULL),
(127, 2, NULL, 1, '37', '112', 1, '1', '151.99', '', 'ch_17FNoFAh5ZKZcdGANylMIxwc', '2015-12-07 12:09:39', 1, 1, '2015-12-07 12:09:30', NULL, NULL, NULL),
(128, 2, NULL, 1, '38', '113', 1, '1', '186.99', '', 'ch_17FOKlAh5ZKZcdGAsY7MKF3X', '2015-12-07 12:43:16', 1, 1, '2015-12-07 12:42:03', NULL, NULL, NULL),
(129, 2, NULL, 1, '39', '114', 1, '1', '9.00', '', NULL, NULL, 0, 1, '2015-12-07 12:46:57', NULL, NULL, NULL),
(130, 2, NULL, 1, '40', '115', 1, '1', '9.00', '', NULL, NULL, 0, 1, '2015-12-07 12:47:00', NULL, NULL, NULL),
(131, 2, NULL, 1, '41', '116', 1, '1', '9.00', '', 'ch_17FOOsAh5ZKZcdGAZ2kNJNDv', '2015-12-07 12:47:31', 1, 1, '2015-12-07 12:47:17', NULL, NULL, NULL),
(132, 2, NULL, 13, '1', '000001', 1, '1', '19.00', '', 'ch_17G7HaAh5ZKZcdGAuR03dtTf', '2015-12-09 12:42:58', 1, 4, '2015-12-09 12:42:47', '2015-12-09 12:55:47', '2015-12-10 04:50:50', '2015-12-10 04:50:50'),
(133, 1, NULL, 8, '1', '000001', 1, '1', '80.00', '', NULL, NULL, 0, 1, '2015-12-10 05:42:27', NULL, NULL, NULL),
(134, 1, NULL, 8, '1', '2', 1, '1', '80.00', '', NULL, NULL, 0, 1, '2015-12-10 05:48:22', NULL, NULL, NULL),
(135, 1, NULL, 8, '1', '3', 1, '1', '80.00', '', 'ch_17GNM1Ah5ZKZcdGAt4I7W31s', '2015-12-10 05:52:37', 1, 4, '2015-12-10 05:51:06', '2015-12-10 05:53:30', '2016-01-04 12:50:18', '2016-01-04 12:50:18'),
(136, 5, NULL, 13, '1', '2', 1, '1', '5.50', '', NULL, NULL, 0, 1, '2015-12-10 22:19:13', NULL, NULL, NULL),
(137, 5, NULL, 13, '2', '3', 1, '1', '11.00', '', NULL, NULL, 0, 1, '2015-12-11 04:52:28', NULL, NULL, NULL),
(138, 2, NULL, 13, '2', '4', 1, '1', '43.50', '', NULL, NULL, 0, 1, '2015-12-11 05:50:22', NULL, NULL, NULL),
(139, 5, NULL, 13, '2', '5', 1, '1', '43.50', '', NULL, NULL, 0, 1, '2015-12-11 05:51:51', NULL, NULL, NULL),
(140, 5, NULL, 13, '2', '6', 1, '1', '43.50', '', NULL, NULL, 0, 1, '2015-12-11 05:58:32', NULL, NULL, NULL),
(141, 5, NULL, 13, '2', '7', 1, '1', '43.50', '', NULL, NULL, 0, 1, '2015-12-11 06:01:11', NULL, NULL, NULL),
(142, 5, NULL, 13, '2', '8', 1, '1', '43.50', '', 'ch_17Gk5wAh5ZKZcdGAmqBReY5j', '2015-12-11 06:09:34', 1, 4, '2015-12-11 06:06:30', '2015-12-14 05:44:57', '2015-12-14 05:45:17', '2015-12-14 05:45:17'),
(143, 2, NULL, 13, '2', '9', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 06:06:52', NULL, NULL, NULL),
(144, 5, NULL, 13, '2', '10', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 06:18:23', NULL, NULL, NULL),
(145, 2, NULL, 13, '2', '11', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 06:18:43', NULL, NULL, NULL),
(146, 5, NULL, 13, '2', '12', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 06:21:41', NULL, NULL, NULL),
(147, 5, NULL, 13, '2', '13', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 06:21:53', NULL, NULL, NULL),
(148, 5, NULL, 13, '2', '14', 1, '1', '6.00', '', NULL, NULL, 0, 1, '2015-12-11 06:22:06', NULL, NULL, NULL),
(149, 2, NULL, 1, '1', '117', 1, '1', '14.40', '', NULL, NULL, 0, 1, '2015-12-11 07:17:21', NULL, NULL, NULL),
(150, 5, NULL, 13, '3', '15', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 09:08:18', NULL, NULL, NULL),
(151, 5, NULL, 13, '4', '16', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 09:10:16', NULL, NULL, NULL),
(152, 5, NULL, 13, '5', '17', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 09:11:26', NULL, NULL, NULL),
(153, 5, NULL, 13, '6', '18', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 09:29:47', NULL, NULL, NULL),
(154, 2, NULL, 13, '7', '19', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 10:06:59', NULL, NULL, NULL),
(155, 2, NULL, 13, '8', '20', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 10:08:26', NULL, NULL, NULL),
(156, 2, NULL, 13, '9', '21', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 10:11:32', NULL, NULL, NULL),
(157, 2, NULL, 13, '10', '22', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 10:12:43', NULL, NULL, NULL),
(158, 2, NULL, 13, '11', '23', 1, '1', '3.00', '', 'ch_17Gnx4Ah5ZKZcdGAbXQplUZ3', '2015-12-11 10:16:38', 1, 4, '2015-12-11 10:16:04', '2015-12-14 05:58:37', '2015-12-14 06:04:24', '2015-12-14 06:04:24'),
(159, 2, NULL, 13, '12', '24', 1, '1', '3.00', '', 'ch_17Go1TAh5ZKZcdGAqhDkyzKv', '2015-12-11 10:21:11', 1, 3, '2015-12-11 10:17:35', '2015-12-17 10:09:50', '2015-12-17 10:09:51', NULL),
(160, 5, NULL, 13, '13', '25', 1, '1', '11.00', '', NULL, NULL, 0, 1, '2015-12-11 10:22:27', NULL, NULL, NULL),
(161, 2, NULL, 13, '14', '26', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-11 10:22:58', NULL, NULL, NULL),
(162, 2, NULL, 13, '15', '27', 1, '1', '11.00', '', NULL, NULL, 0, 1, '2015-12-11 11:09:07', NULL, NULL, NULL),
(163, 2, NULL, 13, '16', '28', 1, '1', '16.50', '', NULL, NULL, 0, 1, '2015-12-12 05:13:38', NULL, NULL, NULL),
(164, 2, NULL, 13, '16', '29', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-12 05:19:54', NULL, NULL, NULL),
(165, 4, NULL, 13, '16', '30', 1, '1', '5.50', '', NULL, NULL, 0, 1, '2015-12-12 05:48:22', NULL, NULL, NULL),
(166, 4, NULL, 13, '16', '31', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-12 05:53:35', NULL, NULL, NULL),
(167, 4, NULL, 13, '16', '32', 1, '1', '3.00', '', 'ch_17H6PDAh5ZKZcdGA1unoHguh', '2015-12-12 05:58:55', 1, 3, '2015-12-12 05:58:08', '2015-12-14 05:58:53', '2015-12-14 06:00:10', NULL),
(168, 2, NULL, 13, '16', '33', 1, '1', '19.50', '', 'ch_17H7FcAh5ZKZcdGArznWzdK1', '2015-12-12 06:53:05', 1, 2, '2015-12-12 06:49:13', '2015-12-14 06:26:26', NULL, NULL),
(169, 2, NULL, 13, '17', '34', 1, '1', '5.50', '', 'ch_17H7Z0Ah5ZKZcdGAxveJrpEo', '2015-12-12 07:13:07', 1, 4, '2015-12-12 07:12:54', '2015-12-14 06:26:42', '2015-12-14 06:26:44', '2015-12-14 06:26:44'),
(170, 2, NULL, 13, '18', '35', 1, '1', '3.00', '', NULL, NULL, 0, 1, '2015-12-12 07:28:31', NULL, NULL, NULL),
(171, 2, NULL, 13, '19', '36', 1, '1', '5.50', '', 'ch_17H9HzAh5ZKZcdGAfYOaSdmL', '2015-12-12 09:03:40', 1, 4, '2015-12-12 09:03:02', '2015-12-14 06:00:28', '2015-12-14 06:05:30', '2015-12-14 06:05:30'),
(172, 5, NULL, 13, '20', '37', 1, '1', '8.50', '', 'ch_17HM0bAh5ZKZcdGA5L7IJ5Mv', '2015-12-12 22:38:33', 1, 2, '2015-12-12 22:37:54', '2015-12-14 06:26:48', NULL, NULL),
(173, 5, NULL, 13, '1', '38', 1, '1', '11.00', '', NULL, NULL, 0, 1, '2015-12-14 05:46:52', NULL, NULL, NULL),
(174, 5, NULL, 13, '1', '39', 1, '1', '35.50', '', NULL, NULL, 0, 1, '2015-12-14 06:08:10', NULL, NULL, NULL),
(175, 2, NULL, 13, '1', '40', 1, '1', '24.00', '', 'ch_17HpVgAh5ZKZcdGAaRPIN0Lp', '2015-12-14 06:08:36', 1, 4, '2015-12-14 06:08:22', '2015-12-14 06:26:38', '2015-12-14 06:26:40', '2015-12-14 06:26:40'),
(176, 5, NULL, 13, '1', '41', 1, '1', '35.50', '', NULL, NULL, 0, 1, '2015-12-14 06:08:43', NULL, NULL, NULL),
(177, 2, NULL, 13, '1', '42', 1, '1', '35.00', '', 'ch_17HpYJAh5ZKZcdGAIDyhJZDQ', '2015-12-14 06:11:20', 1, 4, '2015-12-14 06:11:13', '2015-12-14 06:27:44', '2015-12-14 06:29:20', '2015-12-14 06:29:20'),
(178, 5, NULL, 13, '1', '43', 1, '1', '45.40', '', NULL, NULL, 0, 1, '2015-12-14 06:27:48', NULL, NULL, NULL),
(179, 1, NULL, 13, '2', '44', 1, '1', '6.00', '', NULL, NULL, 0, 1, '2015-12-14 10:29:49', NULL, NULL, NULL),
(180, 1, NULL, 13, '3', '45', 1, '1', '6.00', '', NULL, NULL, 0, 1, '2015-12-14 10:34:07', NULL, NULL, NULL),
(181, 1, NULL, 13, '4', '46', 1, '1', '6.00', '', NULL, NULL, 0, 1, '2015-12-14 10:34:35', NULL, NULL, NULL),
(182, 1, NULL, 13, '5', '47', 1, '1', '6.00', '', 'ch_17HtiOAh5ZKZcdGAQRHnPx2h', '2015-12-14 10:38:01', 1, 1, '2015-12-14 10:37:06', NULL, NULL, NULL),
(183, 2, NULL, 13, '6', '48', 1, '1', '3.00', '', 'ch_17IAlmAh5ZKZcdGA2tx7vV6z', '2015-12-15 04:50:39', 1, 1, '2015-12-15 04:48:50', NULL, NULL, NULL),
(184, 2, NULL, 13, '7', '49', 1, '1', '3.00', '', 'ch_17ICpdAh5ZKZcdGAqq6HP2qa', '2015-12-15 07:02:45', 1, 4, '2015-12-15 07:02:27', '2015-12-17 10:10:22', '2015-12-17 10:10:24', '2015-12-17 10:10:24'),
(185, 5, NULL, 13, '1', '50', 1, '1', '19.00', '', 'ch_17IcJ1Ah5ZKZcdGAbUXefRuE', '2015-12-16 10:14:47', 1, 4, '2015-12-16 10:14:33', '2015-12-17 01:54:22', '2015-12-17 01:54:34', '2015-12-17 01:54:34'),
(186, 2, NULL, 13, '2', '51', 1, '1', '2.00', '', 'ch_17IcjjAh5ZKZcdGAtZL24XY4', '2015-12-16 10:42:25', 1, 1, '2015-12-16 10:42:15', NULL, NULL, NULL),
(187, 5, NULL, 13, '3', '52', 1, '1', '9.90', '', 'ch_17Iqv9Ah5ZKZcdGAUDusPjKJ', '2015-12-17 01:51:07', 1, 4, '2015-12-17 01:50:53', '2015-12-17 01:54:42', '2015-12-17 01:54:45', '2015-12-17 01:54:45'),
(188, 5, NULL, 13, '3', '53', 1, '1', '5.50', '', NULL, NULL, 0, 1, '2015-12-17 02:04:49', NULL, NULL, NULL),
(189, 5, NULL, 13, '3', '54', 1, '1', '5.50', '', 'ch_17Ir8zAh5ZKZcdGAwile1UEs', '2015-12-17 02:05:26', 1, 2, '2015-12-17 02:05:12', '2015-12-17 02:07:22', NULL, NULL),
(190, 5, NULL, 13, '3', '55', 1, '1', '24.00', '', NULL, NULL, 0, 1, '2015-12-17 02:06:06', NULL, NULL, NULL),
(191, 5, NULL, 13, '3', '56', 1, '1', '24.00', '', 'ch_17IrACAh5ZKZcdGAC68mvjwx', '2015-12-17 02:06:40', 1, 4, '2015-12-17 02:06:28', '2016-01-06 06:54:19', '2016-01-06 06:54:41', '2016-01-06 06:54:41'),
(192, 2, NULL, 13, '4', '57', 1, '1', '3.00', 'full cold...', 'ch_17IyXwAh5ZKZcdGAx4G69wNI', '2015-12-17 09:59:40', 1, 4, '2015-12-17 09:59:34', '2015-12-17 10:05:59', '2015-12-17 10:10:18', '2015-12-17 10:10:18'),
(193, 2, NULL, 13, '5', '58', 1, '1', '19.00', '', 'ch_17JGS5Ah5ZKZcdGAleAhd8Xe', '2015-12-18 05:06:50', 1, 4, '2015-12-18 05:06:43', '2016-01-06 06:48:33', '2016-01-06 06:54:56', '2016-01-06 06:54:56'),
(194, 2, NULL, 1, '1', '118', 1, '1', '17.00', '', NULL, NULL, 0, 1, '2015-12-24 11:19:27', NULL, NULL, NULL),
(200, 2, NULL, 13, '1', '59', 1, '1', '3.00', '', 'ch_17PUSxAh5ZKZcdGA8GGcAYMm', '2016-01-04 09:17:27', 1, 3, '2016-01-04 09:17:19', '2016-01-04 09:18:46', '2016-01-04 09:18:48', NULL),
(201, 2, NULL, 13, '2', '60', 1, '1', '9.90', '', 'ch_17PXhDAh5ZKZcdGAIdiuhknJ', '2016-01-04 12:44:24', 1, 4, '2016-01-04 12:40:47', '2016-01-05 05:20:21', '2016-01-06 06:54:54', '2016-01-06 06:54:54'),
(203, 2, NULL, 8, '1', '4', 1, '1', '80.00', '', 'ch_17PXn9Ah5ZKZcdGA0z6myg3g', '2016-01-04 12:50:32', 1, 4, '2016-01-04 12:50:24', '2016-01-04 12:50:50', '2016-01-04 12:51:24', '2016-01-04 12:51:24'),
(204, 2, NULL, 8, '2', '5', 1, '1', '80.00', '', 'ch_17PXpQAh5ZKZcdGAPiCNmdpz', '2016-01-04 12:52:52', 1, 4, '2016-01-04 12:52:47', '2016-01-04 12:53:03', '2016-01-04 12:53:37', '2016-01-04 12:53:37'),
(207, 1, NULL, 13, '3', '61', 1, '1', '9.90', 'testing orderrr', 'ch_17Pn1pAh5ZKZcdGA21a9mN5C', '2016-01-05 05:06:42', 1, 4, '2016-01-05 05:05:05', '2016-01-05 05:10:27', '2016-01-05 05:20:15', '2016-01-05 05:20:15'),
(208, 2, NULL, 13, '4', '62', 1, '1', '3.00', '', 'ch_17Ps1YAh5ZKZcdGAWaF2tJ9t', '2016-01-05 10:26:45', 1, 1, '2016-01-05 10:26:35', NULL, NULL, NULL),
(213, 2, NULL, 13, '5', '63', 1, '1', '5.50', '', NULL, NULL, 0, 1, '2016-01-05 10:55:25', NULL, NULL, NULL),
(214, 2, NULL, 13, '6', '64', 1, '1', '2.00', '', 'ch_17PswOAh5ZKZcdGADH4umpnT', '2016-01-05 11:25:29', 1, 1, '2016-01-05 11:25:14', NULL, NULL, NULL),
(216, NULL, 16, 1, '7', '65', 1, '1', '19.00', '', 'ch_17QB0JAh5ZKZcdGAltmSqnTb', '2016-01-06 06:42:44', 1, 4, '2016-01-06 06:42:30', '2016-01-06 06:53:13', '2016-01-06 06:54:57', '2016-01-06 06:54:57'),
(218, 12, NULL, 13, '1', '65', 1, '1', '2.00', '', 'ch_17Qcz7Ah5ZKZcdGA2uJRUN9w', '2016-01-07 12:35:22', 1, 1, '2016-01-07 12:34:54', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_complete`
--

CREATE TABLE IF NOT EXISTS `order_complete` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL,
  `order_id` int(10) unsigned NOT NULL,
  `order_detail_id` int(10) unsigned NOT NULL,
  `remaining_od` varchar(264) NOT NULL COMMENT 'Comma Separated Id',
  `added_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `order_detail_id` (`order_detail_id`),
  KEY `store_id` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=39 ;

--
-- Dumping data for table `order_complete`
--

INSERT INTO `order_complete` (`id`, `store_id`, `order_id`, `order_detail_id`, `remaining_od`, `added_date`) VALUES
(1, 1, 1, 1, '2', '2015-11-24 05:14:49'),
(2, 1, 1, 2, '', '2015-11-24 05:14:54'),
(7, 13, 167, 218, '', '2015-12-14 06:00:10'),
(10, 13, 159, 209, '', '2015-12-17 10:09:51'),
(11, 13, 200, 259, '', '2016-01-04 09:18:48'),
(12, 13, 200, 259, '', '2016-01-04 09:18:58'),
(14, 8, 203, 261, '', '2016-01-04 12:51:01'),
(15, 8, 203, 261, '', '2016-01-04 12:51:10'),
(17, 8, 204, 262, '', '2016-01-04 12:53:13'),
(18, 8, 204, 262, '', '2016-01-04 12:53:23'),
(22, 13, 193, 256, '', '2016-01-06 06:48:48'),
(23, 13, 193, 256, '', '2016-01-06 06:48:57'),
(24, 13, 193, 256, '', '2016-01-06 06:49:06'),
(25, 13, 193, 256, '', '2016-01-06 06:49:16'),
(26, 13, 193, 256, '', '2016-01-06 06:49:25'),
(27, 13, 193, 256, '', '2016-01-06 06:49:35'),
(28, 13, 193, 256, '', '2016-01-06 06:49:44'),
(29, 13, 193, 256, '', '2016-01-06 06:49:53'),
(30, 13, 193, 256, '', '2016-01-06 06:50:03'),
(31, 13, 193, 256, '', '2016-01-06 06:50:12'),
(32, 13, 193, 256, '', '2016-01-06 06:50:22'),
(33, 13, 193, 256, '', '2016-01-06 06:50:31'),
(34, 13, 193, 256, '', '2016-01-06 06:50:40'),
(35, 13, 193, 256, '', '2016-01-06 06:50:49'),
(38, 13, 191, 254, '', '2016-01-06 06:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE IF NOT EXISTS `order_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `kitchen_id` int(11) NOT NULL,
  `item_options_id` varchar(256) NOT NULL COMMENT 'item option sub id (comma_separated)',
  `item_variety_id` int(10) unsigned DEFAULT NULL,
  `quantity` tinyint(3) unsigned NOT NULL,
  `item_amount` decimal(10,2) unsigned NOT NULL,
  `item_options_amount` decimal(10,2) unsigned NOT NULL,
  `item_discount` decimal(10,2) unsigned NOT NULL,
  `tax_percentage` decimal(10,2) NOT NULL,
  `final_amount` decimal(10,2) unsigned NOT NULL,
  `add_note` varchar(512) NOT NULL,
  `status` tinyint(1) unsigned NOT NULL COMMENT '1 =New, 2 = Processing, 3 = Ready to be collected, 4 = Completed, 5 = Cancelled',
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=270 ;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`id`, `order_id`, `item_id`, `kitchen_id`, `item_options_id`, `item_variety_id`, `quantity`, `item_amount`, `item_options_amount`, `item_discount`, `tax_percentage`, `final_amount`, `add_note`, `status`) VALUES
(1, 1, 1, 1, '', NULL, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(2, 1, 2, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(3, 2, 5, 1, '12', 3, 1, '235.00', '0.10', '0.00', '0.00', '235.10', '', 1),
(4, 2, 6, 1, '13', 7, 1, '455.00', '0.20', '0.00', '0.00', '455.20', '', 1),
(5, 3, 5, 1, '12', 3, 1, '235.00', '0.10', '0.00', '0.00', '235.10', '', 1),
(6, 4, 1, 1, '', NULL, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(7, 5, 2, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(8, 6, 3, 1, '', NULL, 1, '60.00', '0.00', '0.00', '0.00', '60.00', '', 1),
(9, 6, 6, 1, '', 7, 1, '455.00', '0.00', '0.00', '0.00', '455.00', '', 1),
(10, 14, 4, 2, '4', 2, 2, '150.00', '8.00', '0.00', '0.00', '316.00', '', 1),
(11, 15, 4, 2, '4', 2, 2, '150.00', '8.00', '0.00', '0.00', '316.00', '', 1),
(12, 16, 4, 2, '4', 2, 2, '150.00', '8.00', '0.00', '0.00', '316.00', '', 1),
(13, 16, 4, 2, '4', 2, 2, '150.00', '8.00', '0.00', '0.00', '316.00', '', 1),
(14, 16, 4, 2, '5', NULL, 1, '80.00', '20.00', '0.00', '0.00', '100.00', '', 1),
(15, 17, 4, 2, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(16, 18, 4, 2, '', 1, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(17, 19, 4, 2, '', 1, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(18, 19, 4, 2, '', 1, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(19, 19, 4, 2, '', 2, 1, '150.00', '0.00', '0.00', '0.00', '150.00', '', 1),
(20, 20, 4, 2, '', 2, 3, '150.00', '0.00', '0.00', '0.00', '450.00', '', 1),
(21, 20, 4, 2, '', 1, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(22, 21, 4, 2, '4', 2, 2, '150.00', '8.00', '0.00', '0.00', '316.00', '', 1),
(23, 21, 4, 2, '', 1, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(24, 23, 5, 1, '', 3, 1, '235.00', '0.00', '0.00', '0.00', '235.00', '', 1),
(25, 24, 1, 1, '', NULL, 2, '50.89', '0.00', '0.00', '0.00', '101.78', '', 1),
(26, 24, 5, 1, '13', 3, 1, '235.00', '0.20', '0.00', '0.00', '235.20', '', 1),
(27, 24, 4, 2, '15,18', 2, 1, '150.00', '13.00', '0.00', '0.00', '163.00', '', 1),
(28, 25, 10, 3, '', NULL, 1, '76.53', '0.00', '0.00', '0.00', '76.53', '', 1),
(29, 26, 2, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(30, 27, 1, 1, '', NULL, 1, '50.89', '0.00', '0.00', '0.00', '50.89', '', 1),
(31, 28, 6, 1, '', 6, 1, '235.00', '0.00', '0.00', '0.00', '235.00', '', 1),
(32, 29, 2, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(33, 30, 5, 1, '36', 3, 1, '75.23', '12.23', '0.00', '0.00', '87.46', '', 1),
(34, 31, 5, 1, '36', 3, 1, '75.23', '12.23', '0.00', '0.00', '87.46', '', 1),
(35, 31, 6, 1, '', 6, 1, '235.00', '0.00', '0.00', '0.00', '235.00', '', 1),
(36, 32, 7, 2, '', NULL, 1, '20.00', '0.00', '0.00', '0.00', '20.00', '', 1),
(37, 32, 3, 1, '', NULL, 1, '60.00', '0.00', '0.00', '0.00', '60.00', '', 1),
(38, 33, 7, 2, '', NULL, 1, '20.00', '0.00', '0.00', '0.00', '20.00', '', 1),
(39, 33, 3, 1, '', NULL, 1, '60.00', '0.00', '0.00', '0.00', '60.00', '', 1),
(40, 33, 3, 1, '', NULL, 1, '60.00', '0.00', '0.00', '0.00', '60.00', '', 1),
(41, 34, 14, 1, '', 15, 1, '255.45', '0.00', '0.00', '0.00', '255.45', '', 1),
(42, 34, 3, 1, '', 15, 1, '60.00', '0.00', '0.00', '0.00', '60.00', '', 1),
(43, 35, 4, 2, '', 1, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(44, 35, 1, 1, '', 1, 1, '50.89', '0.00', '0.00', '0.00', '50.89', '', 1),
(45, 36, 3, 1, '', NULL, 1, '60.00', '0.00', '0.00', '0.00', '60.00', '', 1),
(46, 36, 2, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(47, 37, 14, 1, '', 15, 1, '255.45', '0.00', '0.00', '0.00', '255.45', '', 1),
(48, 37, 9, 2, '', 15, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(49, 38, 8, 2, '', NULL, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(50, 38, 13, 3, '', NULL, 1, '47.23', '0.00', '0.00', '0.00', '47.23', '', 1),
(51, 39, 16, 3, '', 21, 1, '455.12', '0.00', '0.00', '0.00', '455.12', '', 1),
(52, 39, 11, 3, '', 12, 1, '56.42', '0.00', '0.00', '0.00', '56.42', '', 1),
(53, 40, 3, 1, '', NULL, 1, '60.00', '0.00', '0.00', '0.00', '60.00', '', 1),
(54, 40, 2, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(55, 40, 9, 2, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(56, 41, 1, 1, '', NULL, 1, '50.89', '0.00', '0.00', '0.00', '50.89', '', 1),
(57, 41, 2, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(58, 41, 13, 3, '', NULL, 1, '47.23', '0.00', '0.00', '0.00', '47.23', '', 1),
(59, 42, 14, 1, '', 15, 1, '255.45', '0.00', '0.00', '0.00', '255.45', '', 1),
(60, 42, 5, 1, '', 3, 1, '75.23', '0.00', '0.00', '0.00', '75.23', '', 1),
(61, 42, 7, 2, '', 3, 1, '20.00', '0.00', '0.00', '0.00', '20.00', '', 1),
(62, 44, 11, 3, '', 12, 1, '56.42', '0.00', '0.00', '0.00', '56.42', 'wyeiw q qwoiueyqw e qwoeiu qw sdkfjshkj fs dfkuesh weori ewr askdjfhksdjfh', 1),
(63, 45, 11, 3, '', 12, 1, '56.42', '0.00', '0.00', '0.00', '56.42', 'wyeiw q qwoiueyqw e qwoeiu qw sdkfjshkj fs dfkuesh weori ewr askdjfhksdjfh', 1),
(64, 46, 11, 3, '', 12, 1, '56.42', '0.00', '0.00', '0.00', '56.42', '', 1),
(65, 47, 34, 3, '', NULL, 2, '365.48', '0.00', '0.00', '0.00', '730.96', '', 1),
(66, 48, 57, 4, '', NULL, 1, '300.45', '0.00', '0.00', '0.00', '300.45', '', 1),
(67, 49, 57, 4, '', NULL, 1, '300.45', '0.00', '0.00', '0.00', '300.45', '', 1),
(68, 49, 61, 4, '', NULL, 2, '274.23', '0.00', '0.00', '0.00', '548.46', '', 1),
(69, 50, 10, 3, '', 10, 2, '76.53', '0.00', '0.00', '0.00', '153.06', '', 1),
(70, 50, 10, 3, '', 9, 1, '62.49', '0.00', '0.00', '0.00', '62.49', '', 1),
(71, 50, 7, 2, '', 9, 2, '20.00', '0.00', '0.00', '0.00', '40.00', '', 1),
(72, 50, 8, 2, '', 9, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(73, 51, 3, 1, '', 12, 1, '60.00', '0.00', '0.00', '0.00', '60.00', '', 1),
(74, 51, 8, 2, '', 12, 3, '50.00', '0.00', '0.00', '0.00', '150.00', '', 1),
(75, 52, 52, 4, '76', NULL, 1, '202.40', '35.55', '0.00', '0.00', '237.95', '', 1),
(76, 53, 56, 4, '', NULL, 1, '189.99', '0.00', '95.00', '0.00', '95.00', '', 1),
(77, 53, 61, 4, '', NULL, 1, '274.23', '0.00', '137.12', '0.00', '137.12', '', 1),
(78, 53, 38, 4, '78', 34, 1, '174.23', '44.56', '0.00', '0.00', '218.79', '', 1),
(79, 53, 56, 4, '', NULL, 1, '189.99', '0.00', '95.00', '0.00', '95.00', '', 1),
(80, 53, 61, 4, '', NULL, 1, '274.23', '0.00', '137.12', '0.00', '137.12', '', 1),
(81, 53, 38, 4, '78', 34, 1, '174.23', '44.56', '0.00', '0.00', '218.79', '', 1),
(82, 54, 56, 4, '', NULL, 1, '189.99', '0.00', '95.00', '0.00', '95.00', '', 1),
(83, 54, 59, 4, '', NULL, 1, '345.00', '0.00', '172.50', '0.00', '172.50', '', 1),
(84, 54, 18, 1, '', NULL, 1, '245.78', '0.00', '0.00', '0.00', '245.78', '', 1),
(85, 55, 56, 4, '', NULL, 1, '189.99', '0.00', '95.00', '0.00', '94.99', '', 1),
(86, 55, 59, 4, '', NULL, 1, '345.00', '0.00', '172.50', '0.00', '172.50', '', 1),
(87, 55, 18, 1, '', NULL, 1, '245.78', '0.00', '0.00', '0.00', '245.78', '', 1),
(88, 56, 5, 1, '', 3, 1, '75.23', '0.00', '0.00', '0.00', '75.23', '', 1),
(89, 57, 28, 1, '', 24, 1, '156.32', '0.00', '0.00', '10.10', '156.32', '', 1),
(90, 57, 38, 4, '', 34, 1, '174.23', '0.00', '0.00', '10.10', '174.23', '', 1),
(91, 58, 39, 4, '', 36, 1, '165.00', '0.00', '0.00', '10.10', '165.00', '', 1),
(92, 59, 4, 2, '', 1, 1, '80.00', '0.00', '0.00', '20.20', '80.00', 'no ice', 1),
(93, 60, 39, 4, '', 36, 1, '175.00', '0.00', '0.00', '10.10', '175.00', '', 1),
(94, 61, 10, 3, '', 9, 1, '62.49', '0.00', '0.00', '10.10', '62.49', '', 1),
(95, 62, 7, 2, '', 49, 2, '8.00', '0.00', '0.00', '10.00', '16.00', '', 1),
(96, 63, 3, 1, '', NULL, 1, '60.00', '0.00', '0.00', '10.10', '60.00', '', 1),
(97, 64, 10, 3, '', 9, 1, '76.53', '0.00', '0.00', '10.10', '76.53', '', 1),
(98, 65, 10, 3, '', 9, 1, '62.49', '0.00', '0.00', '10.10', '62.49', '', 1),
(99, 66, 13, 3, '', NULL, 1, '47.23', '0.00', '0.00', '10.10', '47.23', '', 1),
(100, 67, 11, 3, '', 12, 1, '56.42', '0.00', '0.00', '10.10', '56.42', '', 1),
(101, 68, 29, 1, '', 26, 1, '305.00', '0.00', '0.00', '10.10', '305.00', '', 1),
(102, 69, 2, 1, '', NULL, 1, '80.00', '0.00', '0.00', '10.10', '80.00', '', 1),
(103, 70, 1, 1, '', NULL, 1, '50.89', '0.00', '0.00', '0.00', '50.89', '', 1),
(104, 72, 38, 4, '', 34, 1, '174.23', '0.00', '0.00', '10.10', '174.23', '', 1),
(105, 82, 1, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(106, 84, 56, 4, '', NULL, 1, '189.99', '0.00', '0.00', '10.10', '151.99', '', 1),
(107, 85, 1, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(108, 86, 56, 4, '', NULL, 1, '189.99', '0.00', '0.00', '10.10', '151.99', '', 1),
(109, 87, 56, 4, '', NULL, 1, '189.99', '0.00', '0.00', '10.10', '151.99', '', 1),
(110, 88, 56, 4, '', NULL, 1, '170.99', '0.00', '0.00', '10.10', '170.99', '', 1),
(111, 88, 16, 3, '', 23, 1, '30.00', '0.00', '0.00', '10.00', '30.00', '', 1),
(112, 88, 10, 3, '', 9, 1, '62.49', '0.00', '0.00', '10.10', '62.49', '', 1),
(113, 89, 56, 4, '', NULL, 1, '170.99', '0.00', '0.00', '10.10', '170.99', '', 1),
(114, 89, 16, 3, '', 23, 1, '30.00', '0.00', '0.00', '10.00', '30.00', '', 1),
(115, 89, 10, 3, '', 9, 1, '62.49', '0.00', '0.00', '10.10', '62.49', '', 1),
(116, 90, 26, 1, '', NULL, 1, '186.12', '0.00', '0.00', '10.10', '186.12', '', 1),
(117, 90, 16, 3, '', 21, 1, '16.00', '0.00', '0.00', '10.00', '16.00', '', 1),
(118, 91, 56, 4, '', NULL, 1, '170.99', '0.00', '0.00', '10.10', '170.99', '', 1),
(119, 91, 1, 1, '', NULL, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(120, 91, 7, 2, '', NULL, 1, '8.00', '0.00', '0.00', '10.00', '8.00', '', 1),
(121, 92, 48, 4, '', NULL, 1, '129.75', '0.00', '0.00', '10.10', '129.75', '', 1),
(122, 92, 20, 3, '', NULL, 1, '478.56', '0.00', '0.00', '10.10', '478.56', '', 1),
(123, 93, 36, 1, '', NULL, 1, '334.56', '0.00', '0.00', '10.10', '334.56', '', 1),
(124, 94, 48, 4, '', NULL, 1, '129.75', '0.00', '0.00', '10.10', '129.75', '', 1),
(125, 95, 28, 1, '', 24, 1, '156.32', '0.00', '0.00', '10.10', '156.32', '', 1),
(126, 96, 6, 1, '', 6, 2, '235.00', '0.00', '0.00', '10.00', '235.00', '', 1),
(127, 97, 3, 1, '', NULL, 1, '80.00', '0.00', '0.00', '0.00', '80.00', '', 1),
(128, 98, 56, 4, '', NULL, 1, '170.99', '0.00', '0.00', '10.10', '170.99', '', 1),
(129, 99, 56, 4, '', NULL, 1, '170.99', '0.00', '0.00', '10.10', '170.99', '', 1),
(130, 99, 16, 3, '', 23, 1, '30.00', '0.00', '0.00', '10.00', '30.00', '', 1),
(131, 99, 10, 3, '', 9, 1, '62.49', '0.00', '0.00', '10.10', '62.49', '', 1),
(132, 100, 36, 1, '', NULL, 1, '334.56', '0.00', '0.00', '10.10', '334.56', '', 1),
(133, 101, 10, 3, '', 9, 1, '62.49', '0.00', '0.00', '10.10', '62.49', '', 1),
(134, 102, 5, 1, '', 3, 1, '15.00', '0.00', '0.00', '10.00', '15.00', '', 1),
(135, 103, 56, 4, '', NULL, 1, '151.99', '0.00', '0.00', '10.10', '151.99', '', 1),
(136, 104, 30, 3, '', 28, 1, '289.56', '0.00', '0.00', '10.10', '289.56', '', 1),
(137, 105, 28, 1, '', 24, 1, '156.32', '0.00', '0.00', '10.10', '156.32', '', 1),
(138, 106, 14, 1, '', 17, 1, '30.00', '0.00', '0.00', '10.00', '30.00', '', 1),
(139, 107, 14, 1, '', 17, 1, '30.00', '0.00', '0.00', '10.00', '30.00', '', 1),
(140, 108, 14, 1, '', 15, 1, '17.00', '0.00', '0.00', '10.00', '17.00', '', 1),
(141, 109, 30, 3, '', 28, 1, '289.56', '0.00', '0.00', '10.10', '289.56', '', 1),
(142, 110, 32, 3, '', 32, 1, '196.84', '0.00', '0.00', '10.10', '196.84', '', 1),
(143, 111, 30, 3, '', 28, 1, '289.56', '0.00', '0.00', '10.10', '289.56', '', 1),
(144, 112, 15, 3, '', 18, 1, '17.00', '0.00', '0.00', '10.00', '17.00', '', 1),
(145, 113, 16, 3, '', 21, 1, '16.00', '0.00', '0.00', '10.00', '16.00', '', 1),
(146, 114, 4, 2, '', NULL, 1, '8.00', '0.00', '0.00', '10.00', '8.00', '', 1),
(147, 115, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(148, 115, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(149, 115, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(150, 115, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(151, 115, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(152, 115, 20, 3, '', NULL, 3, '478.56', '0.00', '0.00', '10.10', '1435.68', '', 1),
(153, 116, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(154, 116, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(155, 116, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(156, 116, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(157, 116, 20, 3, '', NULL, 2, '478.56', '0.00', '0.00', '10.10', '957.12', '', 1),
(158, 116, 20, 3, '', NULL, 3, '478.56', '0.00', '0.00', '10.10', '1435.68', '', 1),
(159, 116, 20, 3, '', NULL, 3, '478.56', '0.00', '0.00', '10.10', '1435.68', '', 1),
(160, 117, 1, 1, '', NULL, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(161, 118, 1, 1, '', NULL, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(162, 119, 1, 1, '', NULL, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(163, 120, 1, 1, '', NULL, 1, '50.00', '0.00', '0.00', '0.00', '50.00', '', 1),
(164, 121, 57, 4, '', NULL, 1, '270.41', '0.00', '0.00', '10.10', '270.41', '', 1),
(165, 122, 56, 4, '', NULL, 1, '151.99', '0.00', '0.00', '10.10', '151.99', '', 1),
(166, 123, 4, 2, '', NULL, 1, '8.00', '0.00', '0.00', '10.00', '8.00', '', 1),
(167, 124, 56, 4, '', NULL, 1, '151.99', '0.00', '0.00', '10.10', '151.99', '', 1),
(168, 124, 15, 3, '', 18, 1, '17.00', '0.00', '0.00', '10.00', '17.00', '', 1),
(169, 125, 16, 3, '', 21, 1, '16.00', '0.00', '0.00', '10.00', '16.00', '', 1),
(170, 126, 31, 3, '', 30, 1, '319.78', '0.00', '0.00', '10.10', '319.78', '', 1),
(171, 127, 56, 4, '', NULL, 1, '151.99', '0.00', '0.00', '10.10', '151.99', '', 1),
(172, 128, 56, 4, '', NULL, 1, '151.99', '0.00', '0.00', '10.10', '151.99', '', 1),
(173, 128, 16, 3, '', 23, 1, '35.00', '0.00', '0.00', '10.00', '35.00', '', 1),
(174, 129, 80, 2, '', NULL, 1, '9.00', '0.00', '0.00', '10.00', '9.00', '', 1),
(175, 130, 80, 2, '', NULL, 1, '9.00', '0.00', '0.00', '10.00', '9.00', '', 1),
(176, 131, 80, 2, '', NULL, 1, '9.00', '0.00', '0.00', '10.00', '9.00', '', 1),
(177, 132, 84, 7, '133,137', NULL, 1, '19.00', '0.00', '0.00', '10.00', '19.00', '', 4),
(178, 133, 62, 5, '', NULL, 1, '80.00', '0.00', '0.00', '10.10', '80.00', '', 1),
(179, 134, 62, 5, '', NULL, 1, '80.00', '0.00', '0.00', '10.10', '80.00', '', 1),
(180, 135, 62, 5, '', NULL, 1, '80.00', '0.00', '0.00', '10.10', '80.00', '', 4),
(181, 136, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(182, 137, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 1),
(183, 138, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(184, 138, 84, 7, '', NULL, 2, '19.00', '0.00', '0.00', '10.00', '19.00', '', 1),
(185, 139, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(186, 139, 84, 7, '134,137,141', NULL, 2, '19.00', '0.00', '0.00', '10.00', '19.00', '', 1),
(187, 140, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(188, 140, 84, 7, '134,137,141', NULL, 2, '19.00', '0.00', '0.00', '10.00', '19.00', '', 1),
(189, 141, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(190, 141, 84, 7, '134,137,141', NULL, 2, '19.00', '0.00', '0.00', '10.00', '19.00', '', 1),
(191, 142, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 4),
(192, 142, 84, 7, '134,137,141', NULL, 2, '19.00', '0.00', '0.00', '10.00', '19.00', '', 4),
(193, 143, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(194, 144, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(195, 145, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(196, 146, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(197, 147, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(198, 148, 85, 8, '', NULL, 2, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(199, 149, 16, 3, '', 21, 1, '14.40', '0.00', '0.00', '10.00', '14.40', '', 1),
(200, 150, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(201, 151, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(202, 152, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(203, 153, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(204, 154, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(205, 155, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(206, 156, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(207, 157, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(208, 158, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 4),
(209, 159, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 3),
(210, 160, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 1),
(211, 161, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(212, 162, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 1),
(213, 163, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(214, 163, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 1),
(215, 164, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(216, 165, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(217, 166, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(218, 167, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 3),
(219, 168, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 4),
(220, 168, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 4),
(221, 168, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(222, 169, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 4),
(223, 170, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(224, 171, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 4),
(225, 172, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 4),
(226, 172, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(227, 173, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 1),
(228, 174, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 1),
(229, 174, 84, 7, '145,138,141', NULL, 1, '19.00', '5.50', '0.00', '10.00', '24.50', '', 1),
(230, 175, 84, 7, '144', NULL, 1, '19.00', '5.00', '0.00', '10.00', '24.00', '', 4),
(231, 176, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 1),
(232, 176, 84, 7, '145,138,141', NULL, 1, '19.00', '5.50', '0.00', '10.00', '24.50', '', 1),
(233, 177, 84, 7, '144,138,141', NULL, 1, '19.00', '5.00', '0.00', '10.00', '24.00', '', 4),
(234, 177, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 4),
(235, 178, 83, 7, '', NULL, 1, '11.00', '0.00', '0.00', '10.00', '11.00', '', 1),
(236, 178, 84, 7, '145,138,141', NULL, 1, '19.00', '5.50', '0.00', '10.00', '24.50', '', 1),
(237, 178, 82, 7, '', NULL, 2, '4.95', '0.00', '0.00', '10.00', '4.95', '', 1),
(238, 179, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(239, 179, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(240, 180, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(241, 180, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(242, 181, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(243, 181, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(244, 182, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(245, 182, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 1),
(246, 183, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(247, 184, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 4),
(248, 185, 84, 7, '143,138,142', NULL, 1, '19.00', '0.00', '0.00', '10.00', '19.00', '', 4),
(249, 186, 86, 8, '', NULL, 1, '2.00', '0.00', '0.00', '0.00', '2.00', '', 1),
(250, 187, 83, 7, '', NULL, 1, '9.90', '0.00', '0.00', '10.00', '9.90', '', 4),
(251, 188, 82, 7, '147', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(252, 189, 82, 7, '147', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 2),
(253, 190, 84, 7, '144,139,142', NULL, 1, '19.00', '5.00', '0.00', '10.00', '24.00', '', 1),
(254, 191, 84, 7, '144,139,142', NULL, 1, '19.00', '5.00', '0.00', '10.00', '24.00', '', 4),
(255, 192, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', 'one by wo', 4),
(256, 193, 84, 7, '', NULL, 1, '19.00', '0.00', '0.00', '10.00', '19.00', '', 4),
(257, 194, 65, 2, '88', NULL, 1, '9.00', '0.00', '0.00', '10.00', '9.00', '', 1),
(258, 194, 69, 2, '88', NULL, 1, '8.00', '0.00', '0.00', '10.00', '8.00', '', 1),
(259, 200, 86, 8, '', NULL, 1, '3.00', '0.00', '0.00', '0.00', '3.00', '', 3),
(260, 201, 83, 7, '', NULL, 1, '9.90', '0.00', '0.00', '10.00', '9.90', '', 4),
(261, 203, 62, 5, '', NULL, 1, '80.00', '0.00', '0.00', '10.10', '80.00', '', 4),
(262, 204, 63, 5, '', NULL, 1, '80.00', '0.00', '0.00', '10.10', '80.00', '', 4),
(263, 207, 83, 7, '', NULL, 1, '9.90', '0.00', '0.00', '10.00', '9.90', '', 4),
(264, 208, 85, 8, '', NULL, 1, '3.00', '0.00', '0.00', '10.00', '3.00', '', 1),
(265, 213, 82, 7, '', NULL, 1, '5.50', '0.00', '0.00', '10.00', '5.50', '', 1),
(266, 214, 86, 8, '', NULL, 1, '2.00', '0.00', '0.00', '0.00', '2.00', '', 1),
(267, 216, 84, 7, '', NULL, 1, '19.00', '0.00', '0.00', '10.00', '19.00', '', 4),
(269, 218, 86, 8, '', NULL, 1, '2.00', '0.00', '0.00', '0.00', '2.00', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `request_water`
--

CREATE TABLE IF NOT EXISTS `request_water` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `table_number` mediumint(8) unsigned NOT NULL,
  `added_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `request_water`
--

INSERT INTO `request_water` (`id`, `store_id`, `user_id`, `table_number`, `added_date`) VALUES
(11, 1, 2, 1, '2015-12-05 11:05:43'),
(12, 1, 2, 1, '2015-12-07 12:43:49');

-- --------------------------------------------------------

--
-- Table structure for table `site_content`
--

CREATE TABLE IF NOT EXISTS `site_content` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `site_content`
--

INSERT INTO `site_content` (`id`, `title`, `value`) VALUES
(1, 'about', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
(2, 'terms', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
(3, 'faq', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\r\n\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
(4, 'Privacy Policy', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. \r\n\r\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');

-- --------------------------------------------------------

--
-- Table structure for table `site_info`
--

CREATE TABLE IF NOT EXISTS `site_info` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `site_info`
--

INSERT INTO `site_info` (`id`, `name`, `value`) VALUES
(1, 'contact_email', 'shirish@bridgetechnocrats.com'),
(2, 'beacon_uuid', 'f8sdf461sd646ds8e7r94efs1df2sfsfsdfsdf7');

-- --------------------------------------------------------

--
-- Table structure for table `stores`
--

CREATE TABLE IF NOT EXISTS `stores` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `account_id` int(10) unsigned NOT NULL,
  `store_name` varchar(256) NOT NULL,
  `store_branch` varchar(256) NOT NULL,
  `address` varchar(512) NOT NULL,
  `tax_invoice` varchar(256) NOT NULL,
  `abn_number` varchar(256) NOT NULL,
  `image` varchar(256) DEFAULT NULL,
  `welcome_notif` varchar(512) NOT NULL,
  `received_notif` varchar(512) NOT NULL,
  `ready_notif` varchar(512) NOT NULL,
  `display_note` tinyint(1) unsigned NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `stores`
--

INSERT INTO `stores` (`id`, `account_id`, `store_name`, `store_branch`, `address`, `tax_invoice`, `abn_number`, `image`, `welcome_notif`, `received_notif`, `ready_notif`, `display_note`, `status`) VALUES
(1, 1, 'KFC Restaurant', 'Kings Park Branch', 'Shenton Park WA 6008, Australia', 'INV1234', 'A451', '1448111887-KFC.png', 'Welcome to our Store.', 'Your Order has been Received.', 'Your order is ready.', 1, 1),
(8, 6, 'Testing Store 1', 'branch', 'address', 'inv 1', 'abn2', '1448963956-7822.png', 'Welcome to our Store.', 'Your Order has been Received.', 'Your order is ready.', 1, 1),
(9, 6, 'Testing Store 2', 'branch', 'address', 'inv 1', 'abn2', NULL, 'Welcome to our Store.', 'Your Order has been Received.', 'Your order is ready.', 1, 1),
(11, 7, 'Bamboo Lounge', 'Sussex St', 'Shop 2, 336 Sussex St, Sydney NSW 2000', '1889', '123456789', NULL, 'Welcome to Bamboo Lounge', 'Thank you for your order', 'Your order is ready for pick up', 0, 1),
(13, 8, 'Test', 'Sydney', '123 George St Sydney NSW 2000', '000100', '39265194765', NULL, 'Welcome to Bamboo Lounge', 'Thank you for your order', 'Your order is ready for pick up', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `table_beacon`
--

CREATE TABLE IF NOT EXISTS `table_beacon` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL,
  `table_id` varchar(64) NOT NULL,
  `beacon_major` int(10) unsigned NOT NULL,
  `beacon_minor` int(10) unsigned NOT NULL,
  `distance` decimal(10,5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tax`
--

CREATE TABLE IF NOT EXISTS `tax` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tax_percentage` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `tax`
--

INSERT INTO `tax` (`id`, `tax_percentage`) VALUES
(1, '10.00'),
(5, '0.00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(256) NOT NULL,
  `last_name` varchar(256) NOT NULL,
  `email` varchar(256) NOT NULL,
  `password` varchar(256) NOT NULL,
  `pin_number` smallint(5) unsigned DEFAULT NULL,
  `stripe_id` varchar(256) DEFAULT NULL,
  `mobile` varchar(20) NOT NULL,
  `image` varchar(256) NOT NULL,
  `reg_datetime` datetime DEFAULT NULL,
  `verif_account` tinyint(1) NOT NULL,
  `verif_code` varchar(64) DEFAULT NULL,
  `verif_code_exp_datetime` datetime DEFAULT NULL,
  `verif_datetime` datetime DEFAULT NULL,
  `facebook_connect` tinyint(1) unsigned NOT NULL,
  `fb_reg_datetime` datetime DEFAULT NULL,
  `google_connect` tinyint(1) unsigned NOT NULL,
  `g_reg_datetime` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `pin_number`, `stripe_id`, `mobile`, `image`, `reg_datetime`, `verif_account`, `verif_code`, `verif_code_exp_datetime`, `verif_datetime`, `facebook_connect`, `fb_reg_datetime`, `google_connect`, `g_reg_datetime`, `status`) VALUES
(1, 'Shirish Makwana', '', 'shirishm.makwana@gmail.com', '74fbba3034155ae597d04a2ec6f636d5', 1243, 'cus_7WxdhTVdtw2tb0', '9924400799', '', '2015-11-21 18:31:15', 1, '166134', '2015-12-09 12:45:37', '2015-11-21 18:31:15', 0, NULL, 0, NULL, 1),
(2, 'krishna', 'maru', 'krishnamaru123@gmail.com', '3a7c2a6566708e82fc3ceb2ff5f7be34', 1111, 'cus_7W9YGkBwZoyrU9', '9173188128', '', '2015-11-23 13:32:42', 1, NULL, NULL, '2015-11-23 13:32:57', 1, '2015-11-30 13:34:46', 1, '2015-11-30 13:42:28', 1),
(3, 'Varun', '', 'varun.raja.30@gmail.com', '1ea3c64d7bafbd7618e5d17b38c0e7a6', 8888, 'cus_7T7fzAcJOVHcHx', '9586097237', '', '2015-11-24 03:54:22', 1, NULL, NULL, '2015-11-24 03:54:57', 0, NULL, 0, NULL, 1),
(4, 'Divya', '', 'krishnamaru1991@gmail.com', 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, '9173188128', '', '2015-11-25 04:37:32', 1, NULL, NULL, '2015-11-25 04:38:25', 0, NULL, 0, NULL, 1),
(5, 'David Dang', '', 'ibe_david@yahoo.com.au', '198adb71086d832cf66dfb03186c80b5', 2575, 'cus_7WOoguyt2mZrJ0', '0449176090', '', '2015-11-25 16:30:30', 1, NULL, NULL, '2015-11-25 16:31:34', 0, NULL, 0, NULL, 1),
(6, 'Andrew Dang ', '', 'andydang95@gmail.com', '55d3dd0c82b67674c60ce027b66e96d3', NULL, NULL, '0427586781', '', '2015-11-26 03:53:18', 1, NULL, NULL, '2015-11-27 04:51:32', 0, NULL, 0, NULL, 1),
(7, 'Binni', '', 'binnisheth2210@gmail.com', '019ab65308b822e61cbc22498d936a86', NULL, NULL, '', '', NULL, 1, NULL, NULL, '2015-12-01 04:45:49', 0, NULL, 1, '2015-12-01 04:45:49', 1),
(8, 'clare', '', 'shiqueptyltd@gmail.com', 'b62107916c3cd01df3fba155693613c3', NULL, NULL, '0422881761', '', '2015-12-02 10:39:43', 1, NULL, NULL, '2015-12-02 10:40:19', 0, NULL, 0, NULL, 1),
(12, 'testAc', 'ac', 'testkrishapp@gmail.com', 'e10adc3949ba59abbe56e057f20f883e', 1111, 'cus_7fyxNLEpPYuo9m', '91752144521', '', '2016-01-07 12:34:24', 1, NULL, NULL, '2016-01-07 12:34:35', 0, NULL, 0, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `waiter`
--

CREATE TABLE IF NOT EXISTS `waiter` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL,
  `name` varchar(64) NOT NULL,
  `email` varchar(256) NOT NULL,
  `password` varchar(512) NOT NULL,
  `added_date` datetime NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `waiter_update`
--

CREATE TABLE IF NOT EXISTS `waiter_update` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `waiter_login_id` int(10) unsigned NOT NULL,
  `store_id` int(10) unsigned NOT NULL,
  `last_update_checked` datetime DEFAULT NULL,
  `category` datetime DEFAULT NULL,
  `category_discount` datetime DEFAULT NULL,
  `items` datetime DEFAULT NULL,
  `item_discount` datetime DEFAULT NULL,
  `item_option` datetime DEFAULT NULL,
  `item_variety` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `waiter_login_id` (`waiter_login_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `waiter_update`
--

INSERT INTO `waiter_update` (`id`, `waiter_login_id`, `store_id`, `last_update_checked`, `category`, `category_discount`, `items`, `item_discount`, `item_option`, `item_variety`) VALUES
(1, 16, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`login_id`) REFERENCES `login_user` (`id`);

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`login_id`) REFERENCES `login_user` (`id`);

--
-- Constraints for table `app_rating`
--
ALTER TABLE `app_rating`
  ADD CONSTRAINT `app_rating_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `beacons`
--
ALTER TABLE `beacons`
  ADD CONSTRAINT `beacons_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `category_discount`
--
ALTER TABLE `category_discount`
  ADD CONSTRAINT `category_discount_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `device_registered`
--
ALTER TABLE `device_registered`
  ADD CONSTRAINT `device_registered_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`login_id`) REFERENCES `login_user` (`id`),
  ADD CONSTRAINT `employee_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
  ADD CONSTRAINT `employee_ibfk_3` FOREIGN KEY (`kitchen_id`) REFERENCES `kitchens` (`id`);

--
-- Constraints for table `feedback_review`
--
ALTER TABLE `feedback_review`
  ADD CONSTRAINT `feedback_review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`kitchen_id`) REFERENCES `kitchens` (`id`),
  ADD CONSTRAINT `items_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `item_discount`
--
ALTER TABLE `item_discount`
  ADD CONSTRAINT `item_discount_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `item_options_old_backup`
--
ALTER TABLE `item_options_old_backup`
  ADD CONSTRAINT `item_options_old_backup_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `item_option_main`
--
ALTER TABLE `item_option_main`
  ADD CONSTRAINT `item_option_main_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `item_option_sub`
--
ALTER TABLE `item_option_sub`
  ADD CONSTRAINT `item_option_sub_ibfk_1` FOREIGN KEY (`option_id`) REFERENCES `item_option_main` (`id`);

--
-- Constraints for table `item_variety`
--
ALTER TABLE `item_variety`
  ADD CONSTRAINT `item_variety_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `kitchens`
--
ALTER TABLE `kitchens`
  ADD CONSTRAINT `kitchens_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `order_complete`
--
ALTER TABLE `order_complete`
  ADD CONSTRAINT `order_complete_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_complete_ibfk_2` FOREIGN KEY (`order_detail_id`) REFERENCES `order_details` (`id`),
  ADD CONSTRAINT `order_complete_ibfk_3` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `stores`
--
ALTER TABLE `stores`
  ADD CONSTRAINT `stores_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`);

--
-- Constraints for table `table_beacon`
--
ALTER TABLE `table_beacon`
  ADD CONSTRAINT `table_beacon_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

--
-- Constraints for table `waiter`
--
ALTER TABLE `waiter`
  ADD CONSTRAINT `waiter_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
