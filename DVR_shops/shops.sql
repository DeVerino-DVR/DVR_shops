CREATE TABLE IF NOT EXISTS `shops` (
  `MarketTable` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`MarketTable`)),
  `MarketPlace` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
