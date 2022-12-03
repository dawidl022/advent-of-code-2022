-- MySQL flavour

CREATE DATABASE advent;

USE advent;

CREATE TABLE rucksac (
    contents TEXT
);

LOAD DATA INFILE '/var/lib/mysql-files/input.txt'
INTO TABLE rucksac
LINES TERMINATED BY '\n';

CREATE VIEW comparmentised AS
SELECT
    SUBSTRING(contents, 1, CHAR_LENGTH(contents) DIV 2) AS first_compartment,
    SUBSTRING(contents, CHAR_LENGTH(contents) DIV 2 + 1) as second_compartment
FROM rucksac;

CREATE TABLE rucksac_chars(
    rucksac_no INT,
    letter TEXT,
    compartment INT
);

delimiter #
drop procedure if exists normalise_chars #
create procedure normalise_chars(IN id INT, IN compartment TEXT, IN comparment_size INT, IN num INT)
begin
declare x int unsigned default 0;
declare letter TEXT DEFAULT NULL;
  while x < comparment_size do
    set letter = SUBSTRING(compartment, x + 1, 1);
    insert into rucksac_chars VALUES (id, letter, num);
    set x=x+1;
  end while;
end #

DELIMITER ;

CREATE VIEW normalise_input AS
SELECT 
    ROW_NUMBER() OVER(),
    first_compartment,
    CHAR_LENGTH(first_compartment),
    1
FROM comparmentised
UNION
SELECT 
    ROW_NUMBER() OVER(),
    second_compartment,
    CHAR_LENGTH(second_compartment),
    2
FROM comparmentised;

-- `insert_normalised_chars` defined in util.sql
CALL `insert_normalised_chars`();
