DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `_RPName` longtext NOT NULL,
  `_Key` int(11) NOT NULL,
  `_Name` longtext NOT NULL,
  `_Clan` longtext NOT NULL,
  `_Description` longtext NOT NULL,
  `_SteamID` longtext NOT NULL,
  `_UniqueID` longtext NOT NULL,
  `_Money` longtext NOT NULL,
  `_Access` longtext NOT NULL,
  `_Donator` longtext NOT NULL,
  `_Arrested` longtext NOT NULL,
  `_Inventory` longtext NOT NULL,
  `_Blacklist` longtext NOT NULL,
  `_Misc` longtext NOT NULL,
  PRIMARY KEY (`_Key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;