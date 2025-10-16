/*
cleaning data in SQL Queries
*/

-- showing the table
select *
from PortfolioProject3..NashvilleHousing

-- standarize Date Format 
select SaleDateConverted, CONVERT(Date, SaleDate)
from PortfolioProject3..NashvilleHousing

update PortfolioProject3..NashvilleHousing
set SaleDate= CONVERT (Date, SaleDate)

ALTER TABLE PortfolioProject3..NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE PortfolioProject3..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

-----------------------------------------------------------------------------------------------------------
--populate property Adress data 

select *
from PortfolioProject3..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject3..NashvilleHousing a
join PortfolioProject3..NashvilleHousing b
on a.ParcelID =b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject3..NashvilleHousing a
join PortfolioProject3..NashvilleHousing b
on a.ParcelID =b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

---------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from PortfolioProject3..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


select
SUBSTRING (PropertyAddress, 1 ,CHARINDEX (',', PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress,CHARINDEX (',', PropertyAddress)+1, LEN (PropertyAddress)) as City
 from PortfolioProject3..NashvilleHousing


ALTER TABLE PortfolioProject3..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE PortfolioProject3..NashvilleHousing
SET PropertySplitAddress= SUBSTRING (PropertyAddress, 1 ,CHARINDEX (',', PropertyAddress)-1)

ALTER TABLE PortfolioProject3..NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE PortfolioProject3..NashvilleHousing
SET PropertySplitCity= SUBSTRING (PropertyAddress,CHARINDEX (',', PropertyAddress)+1, LEN (PropertyAddress))

select *
from PortfolioProject3..NashvilleHousing
 /* OR
 ALTER TABLE PortfolioProject3..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255), PropertySplitCity Nvarchar(255);

UPDATE PortfolioProject3..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

*/


select OwnerAddress
from PortfolioProject3..NashvilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject3..NashvilleHousing

ALTER TABLE PortfolioProject3..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255),
OwnerSplitCity Nvarchar(255),
OwnerSplitState Nvarchar(255);

UPDATE PortfolioProject3..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3),
    OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2),
	OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


	select *
from PortfolioProject3..NashvilleHousing

-------------------------------------------------------------------------------------------------------
--change Y and N to yes and no in "Sold as Vacnt" filed

select Distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject3..NashvilleHousing
group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' then 'yes'
       when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End 
from PortfolioProject3..NashvilleHousing

Update PortfolioProject3..NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'yes'
       when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End 

	   ---------------------------------------------------------------------------------------------
-- Remove Duplicates

with RowNumCTE as (
select *,
  ROW_NUMBER() OVER(
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   LegalReference
			   ORDER BY 
			   UniqueID )row_num
         
from PortfolioProject3..NashvilleHousing)
select *
from RowNumCTE
where row_num >1
order by PropertyAddress


--------------------------------------------------------------------------
-- delete unused columns 


select *
from PortfolioProject3..NashvilleHousing

Alter table PortfolioProject3..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress 
Alter table PortfolioProject3..NashvilleHousing
drop column SaleDate