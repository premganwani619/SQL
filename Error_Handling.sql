Create Table tblProduct
(
 ProductId int NOT NULL primary key,
 Name nvarchar(50),
 UnitPrice int,
 QtyAvailable int
)


Insert into tblProduct values(1, 'Laptops', 2340, 100)
Insert into tblProduct values(2, 'Desktops', 3467, 50)

Create Table tblProductSales
(
 ProductSalesId int primary key,
 ProductId int,
 QuantitySold int
)
Create Procedure spSellProduct
@ProductId int,
@QuantityToSell int
as
Begin

 Declare @StockAvailable int
 Select @StockAvailable = QtyAvailable 
 from tblProduct where ProductId = @ProductId
 

 if(@StockAvailable < @QuantityToSell)
   Begin
  Raiserror('Not enough stock available',16,1)
   End

 Else
   Begin
    Begin Try
     Begin Transaction

  Update tblProduct set QtyAvailable = (QtyAvailable - @QuantityToSell)
  where ProductId = @ProductId
  
  Declare @MaxProductSalesId int

  Select @MaxProductSalesId = Case When 
          MAX(ProductSalesId) IS NULL 
          Then 0 else MAX(ProductSalesId) end 
         from tblProductSales

  Set @MaxProductSalesId = @MaxProductSalesId + 1
  Insert into tblProductSales values(@MaxProductSalesId, @ProductId, @QuantityToSell)
     Commit Transaction
    End Try
    Begin Catch 
  Rollback Transaction
  Select 
   ERROR_NUMBER() as ErrorNumber,
   ERROR_MESSAGE() as ErrorMessage,
   ERROR_PROCEDURE() as ErrorProcedure,
   ERROR_STATE() as ErrorState,
   ERROR_SEVERITY() as ErrorSeverity,
   ERROR_LINE() as ErrorLine
    End Catch 
   End
End
select * from tblProduct;
select *from tblProductSales;
exec spSellProduct 1,10
select * from tblProduct;
select *from tblProductSales;