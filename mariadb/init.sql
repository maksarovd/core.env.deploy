CREATE DATABASE IF NOT EXISTS `database`;
CREATE USER 'maksarovd'@'%' IDENTIFIED BY '1';
GRANT ALL PRIVILEGES ON `database`.* TO 'maksarovd'@'%';
FLUSH PRIVILEGES;