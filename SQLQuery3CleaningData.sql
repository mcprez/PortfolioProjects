-- Cleaning data in SQL Queries


Select *
From PortfolioProjectA..NashvilleHousing


-- Standardize date format



Select SaleDateConverted,Convert(Date,SaleDate)
From PortfolioProjectA..NashvilleHousing


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)



--------------------------------------------------------------------------------------------------------------------------------
-- Populate property address date


Select *
From PortfolioProjectA..NashvilleHousing
-- Where PropertyAddress is null
order by parcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjectA..NashvilleHousing a
Join PortfolioProjectA..NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


UPDATE a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjectA..NashvilleHousing a
Join PortfolioProjectA..NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



----------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N into Yes and No in "Sold As Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjectA..NashvilleHousing
Group By SoldAsVacant
Order By 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   End
From PortfolioProjectA..NashvilleHousing

UPDATE PortfolioProjectA..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   End



-----------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE As(
Select *,
     ROW_NUMBER() Over (
	 Partition by ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER By UniqueID
				  ) row_num
From PortfolioProjectA..NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order  By PropertyAddress

--------------------------------------------------------------------------------------------------------------------------

WITH RowNumCTE As(
Select *,
     ROW_NUMBER() Over (
	 Partition by ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER By UniqueID
				  ) row_num
From PortfolioProjectA..NashvilleHousing
--Order By ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order  By PropertyAddress




-----------------------------------------------------------------------------------------------------------------------
-- Delete the unused  colums


Select *
From PortfolioProjectA..NashvilleHousing

ALTER TABLE PortfolioProjectA..NashvilleHousing
DROP COLUM, OwnerAddress, TaxDistrict, PropertyAddress