SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio_projects].[dbo].[NatashileHousing]
  /*

Cleaning Data in SQL Queries

*/
  SELECT *
  FROM Portfolio_projects.dbo.NatashileHousing;

  -- Standardize Date Format

  SELECT SalesDates
  FROM   Portfolio_projects.dbo.NatashileHousing;

  SELECT SaleDate, CONVERT(Date, SaleDate) AS SalesDate
  FROM   Portfolio_projects.dbo.NatashileHousing;

  UPDATE Portfolio_projects.dbo.NatashileHousing
  SET SaleDate =  CONVERT(Date, SaleDate);

 -- If this doesnt work properly

ALTER TABLE Portfolio_projects.dbo.NatashileHousing
ADD SalesDates Date;

UPDATE Portfolio_projects.dbo.NatashileHousing
SET SalesDates = CONVERT(Date, SaleDate);

SELECT *
FROM Portfolio_projects.dbo.NatashileHousing;


-- Populate Property Address data

SELECT *
FROM Portfolio_projects.dbo.NatashileHousing
WHERE PropertyAddress IS NULL;

---CHECK A PATTERN IN THE PARCELID
SELECT *
FROM Portfolio_projects.dbo.NatashileHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

---- We see that properties with same Parcel ID has same Property address, thus we can use that to fill the NULL values
 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM Portfolio_projects.dbo.NatashileHousing as a
 JOIN Portfolio_projects.dbo.NatashileHousing as b
 ON a.ParcelID =b.ParcelID
 AND a.UNIQUEID <>b.UNIQUEID
 WHERE a.PropertyAddress IS NULL;

 ----UPDATE THE TABLE
 UPDATE a
 SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM Portfolio_projects.dbo.NatashileHousing as a
 JOIN Portfolio_projects.dbo.NatashileHousing as b
 ON a.ParcelID =b.ParcelID
 AND a.UNIQUEID <>b.UNIQUEID
 WHERE a.PropertyAddress IS NULL;

 ----CHECK TO SEE if it worked
 SELECT *
 FROM Portfolio_projects.dbo.NatashileHousing
 WHERE PropertyAddress IS NULL


 -- Breaking out Address into Individual Columns (Address, City, St
 SELECT PropertyAddress
 FROM Portfolio_projects.dbo.NatashileHousing;

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Area
FROM Portfolio_projects.dbo.NatashileHousing;

ALTER TABLE Portfolio_projects.dbo.NatashileHousing
ADD PropertySplitAddress nVARCHAR(255);

UPDATE NatashileHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE Portfolio_projects.dbo.NatashileHousing
ADD PropertyCity nVARCHAR(255);

UPDATE NatashileHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM Portfolio_projects.dbo.NatashileHousing;

---MOVING ON

--SPLIT OWNER address with Parse Method

SELECT PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1),PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)
FROM Portfolio_projects.dbo.NatashileHousing;

ALTER TABLE Portfolio_projects.dbo.NatashileHousing
ADD OwnerSplitAddress nVARCHAR(255);

UPDATE NatashileHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)


ALTER TABLE Portfolio_projects.dbo.NatashileHousing
ADD OwnerCity nVARCHAR(255);

UPDATE NatashileHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)


ALTER TABLE Portfolio_projects.dbo.NatashileHousing
ADD OwnerState nVARCHAR(255);

UPDATE NatashileHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

SELECT *
FROM Portfolio_projects.dbo.NatashileHousing;

-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant)
FROM Portfolio_projects.dbo.NatashileHousing;


SELECT DISTINCT(SoldAsVacant), COUNT(SoldASVacant)
FROM Portfolio_projects.dbo.NatashileHousing
GROUP BY SoldAsVacant
ORDER BY 2 DESC;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant END
FROM Portfolio_projects.dbo.NatashileHousing;



UPDATE Portfolio_projects.dbo.NatashileHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' THEN 'Yes'
                        When  SoldAsVacant = 'N' THEN 'No'
	                    Else  SoldAsVacant END;

-- Remove Duplicates ( not best practice to delete duplicates in a database)
SELECT*
FROM Portfolio_projects.dbo.NatashileHousing;

WITH rownumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalesDates,
			 SalePrice,
			 LegalReference
			 ORDER BY UniqueID)AS
			 row_num
FROM Portfolio_projects.dbo.NatashileHousing)

SELECT *
FROM rownumCTE
Where row_num >1;
--ORDER BY PropertyAddress;


--- DELETE UNUSED COLUMNS

SELECT *
FROM Portfolio_projects.dbo.NatashileHousing;

ALTER TABLE Portfolio_projects.dbo.NatashileHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress,TaxDistrict




