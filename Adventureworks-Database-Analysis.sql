--Requirements on AdventureWorksDW2012
--1-Display all data from DimCustomer
SELECT * 
FROM DimCustomer

--2-Display customers first name ,birthdate ,marrital status And gender from DimCustomer
SELECT FirstName, BirthDate, MaritalStatus, Gender
FROM DimCustomer

--3-Get customers whose yearly income is more than 60000
SELECT * 
FROM DimCustomer
WHERE YearlyIncome > 60000

--4-Get all customers who have totalchildern <= 3
SELECT * 
FROM DimCustomer 
WHERE TotalChildren <= 3

--5-List of customers who are married and have yearly income > one lakh
SELECT * 
FROM DimCustomer 
WHERE MaritalStatus = 'M' AND YearlyIncome > 100000

--6-List all male customers whose birthdate is greater than 1st jan 1970
SELECT * 
FROM DimCustomer 
WHERE Gender = 'M' AND BirthDate > '1970-01-01'

--7-Get customers whose occupation is either professinal or management
SELECT * 
FROM DimCustomer 
WHERE EnglishOccupation = 'Profesional' OR EnglishOccupation = 'Management'

--8- Display accountkey , parentaccountkey  and account Discription from DimAccount 
--where parentaccountkey is not null
SELECT AccountKey, ParentAccountKey, AccountDescription 
FROM DimAccount 
WHERE ParentAccountKey IS NOT NULL

--9HA- Display product key and product name from DimProduct whose reorder point > 300 and color is black
SELECT ProductKey, EnglishProductName 
FROM DimProduct 
WHERE ReorderPoint > 300 AND Color = 'Black'

--10HA- Display all products who are silver in colour
SELECT * 
FROM DimProduct 
WHERE Color = 'Silver'

--11HA- Employees working in departments HumanResources And Sales.
SELECT * 
FROM DimEmployee 
WHERE DepartmentName = 'Human Resources' Or DepartmentName = 'Sales'

--12-All departments from DimEmployee
SELECT DISTINCT DepartmentName 
FROM DimEmployee

--13- Display SalesOrderNumber , Productkey and Freight From FactResellerSales 
--Whose Freight > 15 and <100
SELECT SalesOrderNumber, ProductKey, Freight 
FROM FactResellerSales 
WHERE Freight > 15 AND Freight < 100

--14-All employees working in HR ,SALES, PURCHASING AND MARKETING
SELECT * 
FROM DimEmployee 
WHERE DepartmentName IN ('Human Resources','Sales','Purchasing','Marketing')

--15-Display employeekey,parentEmployeeKey And DepartmentName of employees whose employee key is 
--1,19,276,105,73
SELECT EmployeeKey, ParentEmployeeKey, DepartmentName 
FROM DimEmployee 
WHERE EmployeeKey IN (1,19,276,105,73)

--16-All employees who are married and whose base rate is >10 and <25
SELECT * 
FROM DimEmployee 
WHERE MaritalStatus = 'M' AND BaseRate > 10 AND BaseRate < 25

--17-All Married Male employees whose base rate is between 10 and 25
SELECT * 
FROM DimEmployee 
WHERE MaritalStatus = 'M' AND Gender = 'M' AND BaseRate BETWEEN 10 AND 25

--18-Display all customers whose FirstName starts with J
SELECT * 
FROM DimCustomer 
WHERE FirstName LIKE 'J%'

--19-Display all customers whose FirstName starts with J , E, C
SELECT * 
FROM DimCustomer 
WHERE FirstName LIKE '[JEC]%'

--20-Display customersName ,birthdate ,gender from DimCustomer
SELECT FirstName +' '+ LastName CustomerName, BirthDate, Gender 
FROM DimCustomer

--21--Display all products with their 'SubcategoryName'
--SELECT EnglishProductName, EnglishProductSubcategoryName FROM DimProduct, DimProductSubcategory WHERE DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
SELECT DP.*, DPS.EnglishProductSubcategoryName
FROM DimProduct DP
LEFT JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey

--22- Display all products along with their categoryname and subcategoryname
SELECT DP.*, EnglishProductCategoryName, EnglishProductSubcategoryName 
FROM DimProduct DP
LEFT JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
LEFT JOIN DimProductCategory DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey

--23- Display Departmentwise employee count
SELECT DepartmentName, COUNT(EmployeeKey) AS EmployeeCount 
FROM DimEmployee
GROUP BY DepartmentName

--24-ProductSubcategoryWise number of products from table DimProduct
SELECT DPS.EnglishProductSubcategoryName, COUNT(DP.ProductKey) AS ProductCount
FROM DimProduct DP
LEFT JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
GROUP BY EnglishProductSubcategoryName

--25HA-ProductSubcategoryWise number of products from table DimProduct whose SubcategoryKey Is Not null
SELECT DPS.EnglishProductSubcategoryName, COUNT(DP.ProductKey) AS ProductCount
FROM DimProduct DP
JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
GROUP BY EnglishProductSubcategoryName

--26HA-Display count of married female employees
SELECT COUNT(EmployeeKey) AS MarriedFemaleEmployees
FROM DimEmployee
WHERE Gender = 'F' AND MaritalStatus = 'M'

--27HA-Display Departmentwise count of married female employees
SELECT DepartmentName, COUNT(EmployeeKey) AS EmployeeCount 
FROM DimEmployee
WHERE Gender = 'F' AND MaritalStatus = 'M'
GROUP BY DepartmentName

--28-CustomersNameWise TotalSale And TotalFreight From FactInternetsales
SELECT DC.FirstName +' '+ LastName CustomerName, SUM(FIS.SalesAmount) TotalSales, SUM(FIS.Freight) TotalFreight
FROM FactInternetSales FIS
JOIN DimCustomer DC ON FIS.CustomerKey = DC.CustomerKey
GROUP BY DC.FirstName +' '+ LastName

--29HA-ProductWise TotalSales From FactInternetSales
SELECT DP.EnglishProductName, SUM(FIS.SalesAmount) TotalSales
FROM FactInternetSales FIS
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
GROUP BY DP.EnglishProductName

--30HA-ProductSubcategoryWise AverageSale From FactInternetSales
SELECT DPS.EnglishProductSubcategoryName, AVG(SalesAmount) AS AverageSales
FROM FactInternetSales FIS
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
GROUP BY DPS.EnglishProductSubcategoryName

--31- CountryWise TotalSale In Descending  From FactResellerSales
SELECT DG.EnglishCountryRegionName, SUM(FRS.SalesAmount) TotalSales
FROM DimReseller DR
JOIN FactResellerSales FRS ON FRS.ResellerKey = DR.ResellerKey
JOIN DimGeography DG ON DR.GeographyKey = DG.GeographyKey
GROUP BY DG.EnglishCountryRegionName
ORDER BY 2 DESC

--32HA-CountryWise StateWise TotalSale From FactResellerSales (Hint Use Order by caluse)
SELECT DG.EnglishCountryRegionName, DG.StateProvinceName, SUM(FRS.SalesAmount) TotalSales
FROM DimReseller DR
JOIN FactResellerSales FRS ON FRS.ResellerKey = DR.ResellerKey
JOIN DimGeography DG ON DR.GeographyKey = DG.GeographyKey
GROUP BY DG.EnglishCountryRegionName, DG.StateProvinceName
ORDER BY 1 DESC, 3 DESC

--33HA-CountryWise Resellerwise TotalSale From FactResellerSales (Hint Use Order by caluse)
SELECT DG.EnglishCountryRegionName, DR.ResellerName, SUM(FRS.SalesAmount) TotalSales
FROM DimReseller DR
JOIN FactResellerSales FRS ON FRS.ResellerKey = DR.ResellerKey
JOIN DimGeography DG ON DR.GeographyKey = DG.GeographyKey
GROUP BY DG.EnglishCountryRegionName, DR.ResellerName
ORDER BY 1 DESC, 3 DESC

--34-FiscalYearWise EmployeesNameWise AverageSale From FactResellerSales
SELECT DD.FiscalYear, DE.FirstName + ' ' + LastName EmployeeName, AVG(FRS.SalesAmount) AverageSales
FROM FactResellerSales FRS
JOIN DimDate DD ON FRS.OrderDateKey = DD.DateKey
JOIN DimEmployee DE ON FRS.EmployeeKey = DE.EmployeeKey
GROUP BY DD.FiscalYear, DE.FirstName + ' ' + LastName
ORDER BY 1 DESC, 3 DESC

--35HA-SalesTerritoryGroupWise EmployeeWise CategoryWise Minimum And Maximum Sale From FactInternetSales
SELECT DST.SalesTerritoryGroup, DE.FirstName + ' ' + LastName EmployeeName, DPC.EnglishProductCategoryName, MIN(FIS.SalesAmount) MinimumSales, MAX(FIS.SalesAmount) MaximumSales
FROM FactInternetSales FIS
JOIN DimSalesTerritory DST ON FIS.SalesTerritoryKey = DST.SalesTerritoryKey
JOIN DimEmployee DE ON DST.SalesTerritoryKey = DE.SalesTerritoryKey
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
JOIN DimProductCategory DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey 
GROUP BY DST.SalesTerritoryGroup, DE.FirstName + ' ' + LastName, DPC.EnglishProductCategoryName

--36HA-Categorywise SubcategoryWise TotalSale for selected calender year FIS
SELECT DPC.EnglishProductCategoryName, DPS.EnglishProductSubcategoryName, DD.CalendarYear, SUM(FIS.SalesAmount) TotalSales
FROM FactInternetSales FIS
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
JOIN DimProductCategory DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey
JOIN DimDate DD ON FIS.OrderDateKey = DD.DateKey
--WHERE DD.CalendarYear = 2005
GROUP BY DPC.EnglishProductCategoryName, DPS.EnglishProductSubcategoryName, DD.CalendarYear
ORDER BY 4 DESC

--37-Display  SalesOrderNumber, SalesOrderLineNumber , AmountDue From FIS
SELECT SalesOrderNumber, SalesOrderLineNumber, SalesAmount + TaxAmt + Freight AmountDue 
FROM FactInternetSales

--38-Display EmployeeKey, Employee's FullName , DepartmentName and ManagerName From DimEmployee
SELECT DE.EmployeeKey, DE.FirstName + ' ' + DE.LastName EmployeeFullName, DE.DepartmentName, DEMP.FirstName + ' ' + DEMP.LastName ManagerName
FROM DimEmployee DE
LEFT JOIN DimEmployee DEMP ON DE.ParentEmployeeKey = DEMP.EmployeeKey

--39-Display ManagerName and TotalEmployees Reporting To That Manager 
SELECT DEMP.FirstName + ' ' + DEMP.LastName ManagerName, COUNT(DE.EmployeeKey) TotalEmployees
FROM DimEmployee DE
JOIN DimEmployee DEMP ON DE.ParentEmployeeKey = DEMP.EmployeeKey
GROUP BY DEMP.FirstName + ' ' + DEMP.LastName
ORDER BY 2 DESC

--40-Find the name  of  customers who has registered more than 25 orders From FIS
SELECT DC.FirstName + ' ' + DC.LastName CustomerName, COUNT(DISTINCT FIS.SalesOrderNumber) TotalOrders
FROM FactInternetSales FIS
JOIN DimCustomer DC ON FIS.CustomerKey = DC.CustomerKey
GROUP BY DC.FirstName + ' ' + DC.LastName
HAVING COUNT(DISTINCT FIS.SalesOrderNumber) > 25
ORDER BY 2 DESC

--41HA-Find name of customers who had placed orders more than one time From FIS
SELECT DC.FirstName + ' ' + DC.LastName CustomerName, COUNT(DISTINCT FIS.SalesOrderNumber) TotalOrders
FROM FactInternetSales FIS
JOIN DimCustomer DC ON FIS.CustomerKey = DC.CustomerKey
GROUP BY DC.FirstName + ' ' + DC.LastName
HAVING COUNT(DISTINCT FIS.SalesOrderNumber) > 1

--42HA- Display categorywise Employeewise Total Sales Having Totalsales > 200000 From FIS
SELECT DPC.EnglishProductCategoryName, DE.FirstName + ' ' + DE.LastName EmployeeName, SUM(FIS.SalesAmount) TotalSales
FROM FactInternetSales FIS
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
JOIN DimProductCategory DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey
JOIN DimSalesTerritory DST ON FIS.SalesTerritoryKey = DST.SalesTerritoryKey
JOIN DimEmployee DE ON DST.SalesTerritoryKey = DE.SalesTerritoryKey
GROUP BY DPC.EnglishProductCategoryName, DE.FirstName + ' ' + DE.LastName
HAVING SUM(FIS.SalesAmount) > 200000
ORDER BY 3 DESC

-- Common Table Expression/CTE
--43- Which are the top 10 selling products from FactInternetSales
WITH ProductList AS
(
SELECT DP.EnglishProductName, SUM(FIS.SalesAmount) TotalSales
FROM FactInternetSales FIS
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
GROUP BY DP.EnglishProductName
), SortedProductList AS
(
SELECT PL.EnglishProductName, PL.TotalSales,
ROW_NUMBER() OVER (ORDER BY PL.TotalSales DESC) SerialNumber
FROM ProductList PL
)
SELECT SPL.SerialNumber, SPL.EnglishProductName, SPL.TotalSales
FROM SortedProductList SPL
WHERE SPL.SerialNumber <= 10

--44HA-Which are the top 25 selling products in FactResellarSales
WITH ProductList2 AS
(
SELECT DP.EnglishProductName, SUM(FRS.SalesAmount) TotalSales
FROM FactResellerSales FRS
JOIN DimProduct DP ON FRS.ProductKey = DP.ProductKey
GROUP BY DP.EnglishProductName
), SortedList AS 
(
SELECT PL.EnglishProductName, PL.TotalSales, 
ROW_NUMBER() OVER (ORDER BY PL.TotalSales DESC) SerialNumber
FROM ProductList2 PL
)
SELECT SL.SerialNumber, SL.EnglishProductName, SL.TotalSales
FROM SortedList SL
WHERE SL.SerialNumber <= 25

--45-Create the output which will give me top 3 products by EmployeeFullName from
--FactResellerSales for fiscal year 2007
WITH EmployeeProductList AS
(
SELECT DEMP.FirstName + ' ' + DEMP.LastName EmployeeFullName, DP.EnglishProductName, 
SUM(FRS.SalesAmount) TotalSales
FROM FactResellerSales FRS
JOIN DimProduct DP ON FRS.ProductKey = DP.ProductKey
JOIN DimEmployee DEMP ON FRS.EmployeeKey = DEMP.EmployeeKey
JOIN DimDate DD ON FRS.OrderDateKey = DD.DateKey
WHERE DD.FiscalYear = 2007
GROUP BY DEMP.FirstName + ' ' + DEMP.LastName, DP.EnglishProductName
), SortedEmployeeProductList AS
(
SELECT EPL.EmployeeFullName, EPL.EnglishProductName, EPL.TotalSales,
DENSE_RANK() OVER (PARTITION BY EPL.EmployeeFullName ORDER BY EPL.TotalSales DESC) RowNumber
FROM EmployeeProductList EPL
)
SELECT *
FROM SortedEmployeeProductList 
WHERE RowNumber <= 3

--46HA-Subcategorywise top 2 Selling  products from FactInternetSales
WITH ProductList4 AS
(
SELECT DPS.EnglishProductSubcategoryName, DP.EnglishProductName, SUM(FIS.SalesAmount) TotalSales
FROM FactInternetSales FIS
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
GROUP BY DPS.EnglishProductSubcategoryName, DP.EnglishProductName
), SortedList AS
(
SELECT PL.EnglishProductSubcategoryName, PL.EnglishProductName, PL.TotalSales,
ROW_NUMBER() OVER (PARTITION BY PL.EnglishProductSubcategoryName ORDER BY PL.TotalSales DESC) RowNumber
FROM ProductList4 PL
)
SELECT *
FROM SortedList SL
WHERE SL.RowNumber <= 2

--OR
WITH ProductList4 AS
(
SELECT DPS.EnglishProductSubcategoryName, DP.EnglishProductName, SUM(FIS.SalesAmount) TotalSales
FROM FactInternetSales FIS
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
JOIN DimProductSubcategory DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
GROUP BY DPS.EnglishProductSubcategoryName, DP.EnglishProductName
), SortedList AS
(
SELECT PL.EnglishProductSubcategoryName, PL.EnglishProductName, PL.TotalSales,
DENSE_RANK() OVER (PARTITION BY PL.EnglishProductSubcategoryName ORDER BY PL.TotalSales DESC) RowNumber
FROM ProductList4 PL
)
SELECT *
FROM SortedList SL
WHERE SL.RowNumber <= 2

--47-create output from FRS to list the Products where Products TotalSale < average sale per product
WITH ProductList AS
(
SELECT DP.EnglishProductName, SUM(FRS.SalesAmount) TotalSales
FROM FactResellerSales FRS
JOIN DimProduct DP ON FRS.ProductKey = DP.ProductKey
GROUP BY DP.EnglishProductName
), AverageSalePerProduct As
(
SELECT AVG(PL.TotalSales) AverageSales
FROM ProductList PL
)
--SELECT PL.EnglishProductName, PL.TotalSales, ASP.AverageSales
--FROM ProductList PL
--CROSS JOIN AverageSalePerProduct ASP
--WHERE PL.TotalSales < ASP.AverageSales
--ORDER BY 2 DESC

--OR

SELECT PL.EnglishProductName, PL.TotalSales, ASP.AverageSales
FROM ProductList PL, AverageSalePerProduct ASP
WHERE PL.TotalSales < ASP.AverageSales
ORDER BY 2 DESC

--48HA-Give me the list of  countries whose sales is greater AverageSalepercountry from FactResellerSales
WITH SalesCountryList AS
(
SELECT DST.SalesTerritoryCountry, SUM(FRS.SalesAmount) TotalSales
FROM FactResellerSales FRS
JOIN DimSalesTerritory DST ON FRS.SalesTerritoryKey = DST.SalesTerritoryKey
GROUP BY DST.SalesTerritoryCountry
), AverageSalesPerCountry AS
(
SELECT AVG(SCL.TotalSales) AverageSales
FROM SalesCountryList SCL
)
SELECT SCL.SalesTerritoryCountry, SCL.TotalSales, ASPC.AverageSales
FROM SalesCountryList SCL, AverageSalesPerCountry ASPC
WHERE SCL.TotalSales > ASPC.AverageSales
ORDER BY 2 DESC

--49- From FactInternetSales Each Employees highest and lowest selling Product For Given Year
WITH EmployeeListDESC AS
(
SELECT DE.FirstName + ' ' + DE.LastName EmployeeName, DP.EnglishProductName,
SUM(FIS.SalesAmount) TotalSales,
ROW_NUMBER() OVER (PARTITION BY DE.FirstName + ' ' + DE.LastName ORDER BY SUM(FIS.SalesAmount) DESC)SerialNumber
FROM FactInternetSales FIS
JOIN DimSalesTerritory DST ON FIS.SalesTerritoryKey = DST.SalesTerritoryKey
JOIN DimEmployee DE ON DST.SalesTerritoryKey = DE.SalesTerritoryKey
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
JOIN DimDate DD ON FIS.OrderDateKey = DD.DateKey
WHERE DD.FiscalYear = 2007
GROUP BY DE.FirstName + ' ' + DE.LastName, DP.EnglishProductName
), EmployeeListASC AS
(
SELECT DE.FirstName + ' ' + DE.LastName EmployeeName, DP.EnglishProductName,
SUM(FIS.SalesAmount) TotalSales,
ROW_NUMBER() OVER (PARTITION BY DE.FirstName + ' ' + DE.LastName ORDER BY SUM(FIS.SalesAmount))SerialNumber
FROM FactInternetSales FIS
JOIN DimSalesTerritory DST ON FIS.SalesTerritoryKey = DST.SalesTerritoryKey
JOIN DimEmployee DE ON DST.SalesTerritoryKey = DE.SalesTerritoryKey
JOIN DimProduct DP ON FIS.ProductKey = DP.ProductKey
JOIN DimDate DD ON FIS.OrderDateKey = DD.DateKey
WHERE DD.FiscalYear = 2007
GROUP BY DE.FirstName + ' ' + DE.LastName, DP.EnglishProductName
)
SELECT ED.EmployeeName, ED.EnglishProductName HighestSellingProduct, ED.TotalSales HighestSale,
EA.EnglishProductName LowestSellingProduct, EA.TotalSales LowestSale
FROM EmployeeListDESC ED
JOIN EmployeeListASC EA ON ED.EmployeeName = EA.EmployeeName
WHERE ED.SerialNumber = 1 AND EA.SerialNumber = 1