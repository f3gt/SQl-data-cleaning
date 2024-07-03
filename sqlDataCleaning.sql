
select * from 
portfolio..NationalHousing

--Staderize the Date format

select SaleDateConverted ,convert(Date,SaleDate)
from
portfolio..NationalHousing

update NationalHousing
set SaleDate=convert(Date,SaleDate)

alter table NationalHousing
add SaleDateConverted Date;

update NationalHousing
set SaleDateConverted=convert(Date,SaleDate)

 
--populate property adress data

select *
from
portfolio..NationalHousing
--where PropertyAddress is null
order by ParcelID

select  a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from portfolio..NationalHousing a
join portfolio..NationalHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from portfolio..NationalHousing a
join portfolio..NationalHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]

--Breaking Out Address into individual columns(Address,City,State)


select PropertyAddress
from
portfolio..NationalHousing
--where PropertyAddress is null
order by ParcelID

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))as Address
from portfolio..NationalHousing

alter table NationalHousing
add PropertySplitAddress nvarchar(255);

update NationalHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NationalHousing
add PropertySplitCity nvarchar(255);

update NationalHousing
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select *from NationalHousing


--For Owner Address

select OwnerAddress from NationalHousing

select PARSENAME(replace(OwnerAddress,',','.'),3),
 PARSENAME(replace(OwnerAddress,',','.'),2),
 PARSENAME(replace(OwnerAddress,',','.'),1)
from NationalHousing

alter table NationalHousing
add OwnerSplitAddress nvarchar(255);

update NationalHousing
set OwnerSplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table NationalHousing
add OwnerSplitCity nvarchar(255);

update NationalHousing
set OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table NationalHousing
add OwnerSplitState nvarchar(255);

update NationalHousing
set OwnerSplitState=PARSENAME(replace(OwnerAddress,',','.'),1)

select * from NationalHousing

--Change Y and N to Yes and No in 'Sold as Vacant'

select Distinct(SoldAsVacant),count(SoldAsVacant)
from NationalHousing
group by SoldAsVacant

select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
	 when SoldAsVacant='N' then 'No'
	 else SoldAsVacant
 	 end  
from NationalHousing 


--Remove Duplicates

 with RowNumCTE as 
 (
 select *,
 ROW_NUMBER() over (partition by ParcelID,
 PropertyAddress,
 SalePrice,
 SaleDate,
 LegalReference
 order by UniqueID)row_num
 from NationalHousing
 --order by ParcelID
 )
 select*  from RowNumCTE
 where row_num>1

--Delete Unused Column

select *
from NationalHousing


alter table NationalHousing
drop column SaleDate





