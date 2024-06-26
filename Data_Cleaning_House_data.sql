/*
Data Cleaning in SQL 
*/

SELECT *
FROM ProtfolioProject.dbo.NashvilleHousing

--Standardize Date Format--

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM ProtfolioProject.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate;

AlTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populated Property Addresss Data--

SELECT *
FROM ProtfolioProject.dbo.NashvilleHousing
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM ProtfolioProject.dbo.NashvilleHousing a
JOIN ProtfolioProject.dbo.NashvilleHousing b
     ON a.ParcelId = b.ParcelID
	 AND a.[UniqueID] != b.[UniqueID]
WHERE a.Propertyaddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM ProtfolioProject.dbo.NashvilleHousing a
JOIN ProtfolioProject.dbo.NashvilleHousing b
     ON a.ParcelId = b.ParcelID
	 AND a.[UniqueID] != b.[UniqueID]
WHERE a.Propertyaddress is null

--Breaking Out Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM ProtfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)  +1, LEN(PropertyAddress)) as Address

FROM ProtfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)  +1, LEN(PropertyAddress)) 

SELECT *
FROM ProtfolioProject.dbo.NashvilleHousing



SELECT OwnerAddress
FROM ProtfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM ProtfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

SELECT *
FROM ProtfolioProject.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field--

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM ProtfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant 
	   END
FROM ProtfolioProject.dbo.NashvilleHousing   

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant 
	   END

--REMOVE DUPLICATES--
WITH RowNumCTE AS (
SELECT * ,
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY 
			    UniqueID
				 ) row_num
FROM ProtfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
FROM ProtfolioProject.dbo.NashvilleHousing  


--DELETE UNUSED COLUMNS--

SELECT *
FROM ProtfolioProject.dbo.NashvilleHousing

ALTER TABLE ProtfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE ProtfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate