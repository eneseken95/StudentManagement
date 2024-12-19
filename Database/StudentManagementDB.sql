-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost
-- Üretim Zamanı: 19 Ara 2024, 17:39:01
-- Sunucu sürümü: 10.4.28-MariaDB
-- PHP Sürümü: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `StudentManagementDB`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Lessons`
--

CREATE TABLE `Lessons` (
  `id` int(11) NOT NULL,
  `lessonName` varchar(100) NOT NULL,
  `isMandatory` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Tablo döküm verisi `Lessons`
--

INSERT INTO `Lessons` (`id`, `lessonName`, `isMandatory`) VALUES
(1, 'Veri Yapıları ve Algoritmalar', 1),
(2, 'Yazılım Mühendisliğine Giriş', 1),
(3, 'Veri Tabanı Yönetim Sistemleri', 1),
(4, 'İşletim Sistemleri', 1),
(5, 'Yapay Zeka', 0),
(6, 'Web Programlama', 0),
(7, 'Mobil Uygulama Geliştirme', 0),
(8, 'Bulut Bilişim', 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Students`
--

CREATE TABLE `Students` (
  `id` int(11) NOT NULL,
  `userName` varchar(100) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `isMandatory` tinyint(1) DEFAULT 0,
  `lesson` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Tablo döküm verisi `Students`
--

INSERT INTO `Students` (`id`, `userName`, `lesson_id`, `isMandatory`, `lesson`) VALUES
(1, 'AhmetYilmaz', 1, 1, 'Veri Yapıları ve Algoritmalar'),
(1, 'AhmetYilmaz', 2, 0, 'Yazılım Mühendisliğine Giriş'),
(1, 'AhmetYilmaz', 4, 1, 'İşletim Sistemleri'),
(1, 'AhmetYilmaz', 5, 0, 'Yapay Zeka'),
(1, 'AhmetYilmaz', 8, 1, 'Veri Tabanı ve Yönetim Sistemleri'),
(4, 'FatmaOzdemir', 1, 1, 'Veri Yapıları ve Algoritmalar'),
(4, 'FatmaOzdemir', 4, 1, 'İşletim Sistemleri'),
(4, 'FatmaOzdemir', 6, 0, 'Web Programlama'),
(4, 'FatmaOzdemir', 7, 0, 'Mobil Uygulama Geliştirme'),
(4, 'FatmaOzdemir', 8, 1, 'Veri Tabanı ve Yönetim Sistemleri');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Teachers`
--

CREATE TABLE `Teachers` (
  `id` int(11) NOT NULL,
  `userName` varchar(100) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `lesson` varchar(100) DEFAULT NULL,
  `isMandatory` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Tablo döküm verisi `Teachers`
--

INSERT INTO `Teachers` (`id`, `userName`, `lesson_id`, `lesson`, `isMandatory`) VALUES
(2, 'MehmetKara', 1, 'Veri Yapıları ve Algoritmalar', 1),
(2, 'MehmetKara', 2, 'Yazılım Mühendisliğine Giriş', 1),
(2, 'MehmetKara', 4, 'İşletim Sistemleri', 1),
(2, 'MehmetKara', 7, 'Mobil Uygulama Geliştirme', 0),
(5, 'AliCan', 3, 'Veri Tabanı Yönetim Sistemleri', 1),
(5, 'AliCan', 5, 'Yapay Zeka', 0),
(5, 'AliCan', 6, 'Web Programlama', 0),
(5, 'AliCan', 8, 'Bulut Bilişim', 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Users`
--

CREATE TABLE `Users` (
  `id` int(11) NOT NULL,
  `userName` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','teacher','admin') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Tablo döküm verisi `Users`
--

INSERT INTO `Users` (`id`, `userName`, `password`, `role`) VALUES
(1, 'AhmetYilmaz', 'sifre123', 'student'),
(2, 'MehmetKara', 'sifre456', 'teacher'),
(3, 'AyseDemir', 'sifre789', 'admin'),
(4, 'FatmaOzdemir', 'sifre101', 'student'),
(5, 'AliCan', 'sifre202', 'teacher');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `Lessons`
--
ALTER TABLE `Lessons`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `Students`
--
ALTER TABLE `Students`
  ADD PRIMARY KEY (`id`,`lesson_id`),
  ADD KEY `fk_lesson_id` (`lesson_id`);

--
-- Tablo için indeksler `Teachers`
--
ALTER TABLE `Teachers`
  ADD PRIMARY KEY (`id`,`lesson_id`),
  ADD KEY `lesson_id` (`lesson_id`);

--
-- Tablo için indeksler `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `Lessons`
--
ALTER TABLE `Lessons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Tablo için AUTO_INCREMENT değeri `Users`
--
ALTER TABLE `Users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `Students`
--
ALTER TABLE `Students`
  ADD CONSTRAINT `fk_lesson_id` FOREIGN KEY (`lesson_id`) REFERENCES `Lessons` (`id`);

--
-- Tablo kısıtlamaları `Teachers`
--
ALTER TABLE `Teachers`
  ADD CONSTRAINT `teachers_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Users` (`id`),
  ADD CONSTRAINT `teachers_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `Lessons` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
