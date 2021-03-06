SELECT b.title
FROM book b, wrote w1
WHERE (b.bookCode = w1.bookCode)
  AND (b.bookcode NOT IN
         (SELECT distinct bookCode -- book codes with authors having written < 4 books
          FROM wrote w2
          WHERE authorNum IN
              (SELECT authorNum -- authors with less than 4 books written
               FROM wrote w3
               GROUP BY authorNum
               HAVING count(*) < 4)
          )
        )
GROUP BY b.title
HAVING (count(*) > 0)
        