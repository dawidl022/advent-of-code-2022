SELECT SUM(priority)
FROM (
    SELECT DISTINCT r1.rucksac_no, r1.letter, ASCII(r1.letter) - IF(ASCII(r1.letter) >= 97, 96, 38) AS priority
    FROM rucksac_chars r1, rucksac_chars r2
    WHERE r1.rucksac_no = r2.rucksac_no
    AND ASCII(r1.letter) = ASCII(r2.letter)
    AND r1.compartment = 1
    AND r2.compartment = 2
) AS sub;
