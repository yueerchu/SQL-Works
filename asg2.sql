/****** List the title of the book(s) whose price is greater than
     the price of all books of type 'FIC'  ******/
select title
 from book
  where price > (
   select MAX(price)
     from book
       where type='FIC');


/****** For each type of book, list the the book type, the number of books of that type, 
and the total number of OnHand value for all books of that type.  ******/
SELECT Book.Type, count(distinct Book.BookCode)BookCount, sum(Inventory.onHand)TotalQty
  FROM Book, Inventory
  Where Book.BookCode = Inventory.BookCode
  Group By Book.Type;

/****** List the name of authors who wrote any book of type 'MYS' and the book is available at the branch 'Henry Brentwood  ******/
SELECT Author.AuthorFirst, Author.AuthorLast
  FROM Wrote, Author, Book, Inventory, Branch
  Where (Wrote.AuthorNum = Author.AuthorNum) AND (Book.BookCode = Wrote.BookCode) AND (Type = 'MYS') 
  AND (Inventory.BookCode = Book.BookCode) AND (Branch.BranchNum = Inventory.BranchNum) AND (Branch.BranchName = 'Henry Brentwood')
  And (Inventory.OnHand > 0)
  Group By Author.AuthorFirst, Author.AuthorLast;

  /****** List the customer name, balance, and credit limit of customers whose balance exceed half of their credit limit  ******/
SELECT CustomerName, Balance, CreditLimit
  FROM Customer
  Where Balance > (CreditLimit/2);

/****** List the name of customer(s) who has (have) the highest available credit.  ******/
SELECT CustomerName
  FROM Customer E
  Where not exists
    (select *
	 from Customer S
	 where (S.CreditLimit -S.Balance) > (E.CreditLimit - E.Balance));

/****** List the last name of each rep and the description of the part
       that was ordered by all customers associated with that rep.  ******/
select Rep.LastName, Part.Description
from Rep, Part, Customer
where Customer.RepNum = Rep.RepNum and Customer.CustomerNum 
IN (select Orders.CustomerNum
    from Orders, OrderLine, Part
	where Orders.OrderNum = OrderLine.OrderNum and OrderLine.PartNum = Part.PartNum) and
Not Exists (select *
			from Customer
			where CustomerNum IN (select CustomerNum 
								  from Orders
								  where OrderNum IN (select OrderNum
													 from OrderLine
													 where PartNum IN (select PartNum
																	   from Part))))

