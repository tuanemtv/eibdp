CREATE TABLE  `athena`.`Customer` (
  `CustomerID` int(11) NOT NULL auto_increment,
  `CompanyID` int(11) NOT NULL,
  `FirstName` varchar(45) default NULL,
  `LastName` varchar(45) default NULL,
  `Address` varchar(500) default NULL,
  `City` varchar(45) default NULL,
  `State` varchar(45) default NULL,
  `ZipCode` int(5) default NULL,
  `ContactNumber` int(10) default NULL,
  PRIMARY KEY  (`CustomerID`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1