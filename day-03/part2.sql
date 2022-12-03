SELECT SUM(priority)
FROM (
    SELECT DISTINCT rucksac_no, ASCII(r1.letter) - IF(ASCII(r1.letter) >= 97, 96, 38) AS priority
    FROM rucksac_chars r1
    WHERE ASCII(letter) IN (
        SELECT ASCII(letter) FROM rucksac_chars
        WHERE rucksac_no = (r1.rucksac_no + 1)
    )
    AND ASCII(letter) IN (
        SELECT ASCII(letter) FROM rucksac_chars
        WHERE rucksac_no = (r1.rucksac_no + 2)
    )
    AND MOD(rucksac_no, 3) = 1
    ORDER BY rucksac_no
) as sub;
