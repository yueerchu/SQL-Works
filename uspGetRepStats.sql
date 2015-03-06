CREATE PROCEDURE uspGetRepStats
	@RepNumber char(2)
AS
BEGIN
	SET NOCOUNT ON;
	declare @currRep char(2)
	declare @firstN varchar(15)
	declare @lastN varchar(15)
	declare @totCus int
	declare @totBal Decimal(10,2)
	declare @totOrd	int
	declare @totRev Decimal(10,2)

	SELECT @currRep = RepNum
	From Rep
	where RepNum = @RepNumber;
	if (@currRep is NULL)
	begin
		print 'No rep exists with the repnumber "' + @RepNumber + '"'
		return(-1)
	end

	select @firstN = FirstName, @lastN = LastName
	From Rep
	where RepNum = @RepNumber;

	select @totCus = count(RepNum)
	From Customer
	where RepNum = @RepNumber;

	select @totBal = sum(Balance)
	From Customer
	where RepNum = @RepNumber;

	select @totOrd = count(Orders.CustomerNum)
	From Customer, Orders
	Where Orders.CustomerNum = Customer.CustomerNum AND Customer.RepNum = @RepNumber

	select @totRev = sum(OrderLine.QuotedPrice * OrderLine.NumOrdered)
	From Customer, Orders, OrderLine
	Where Orders.CustomerNum = Customer.CustomerNum AND Customer.RepNum = @RepNumber AND
	Orders.OrderNum = OrderLine.OrderNum

	print 'Statistics of the sales rep "' + @RepNumber + '"'
	print '   Name: ' + @firstN + @lastN
	print '   Number of Customers: ' + cast(@totCus as varchar(10))
	print '   Total balance of these customers: ' + cast(@totBal as varchar(10))
	print '   Number of Orders: ' + cast(@totOrd as varchar(10))
	print '   Total revenue: ' + cast(@totRev as varchar(10))
	return(0)
END