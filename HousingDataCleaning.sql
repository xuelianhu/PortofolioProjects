
-- cleaning data in sql queries
select * 
from Housing.`housing.data_cleaning`;

-- populate property address data
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from Housing.`housing.data_cleaning` a
join Housing.`housing.data_cleaning` b
	on a.ParcelID = B.ParcelID
    and a.UniqueId <> b.UniqueId
where a.PropertyAddress is null;

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from Housing.`housing.data_cleaning` a
join Housing.`housing.data_cleaning` b
	on a.ParcelID = B.ParcelID
    and a.UniqueId <> b.UniqueId
where a.PropertyAddress is null;

-- Breaking out address into individual colums(address, city)
select PropertyAddress
from Housing.`housing.data_cleaning`;

select
substring(PropertyAddress,1,locate(',',PropertyAddress)-1) as Address
,substring(PropertyAddress,locate(',',PropertyAddress)+1, length(PropertyAddress))as City
from Housing.`housing.data_cleaning`;

alter table Housing.`housing.data_cleaning`
add PropertySplitAddress nvarchar(255);

update Housing.`housing.data_cleaning`
set PropertySplitAddress = substring(PropertyAddress,1,locate(',',PropertyAddress)-1);

alter table Housing.`housing.data_cleaning`
add PropertySplitCity nvarchar(255);

update Housing.`housing.data_cleaning`
set PropertySplitCity = substring(PropertyAddress,locate(',',PropertyAddress)+1, length(PropertyAddress));

select *
from Housing.`housing.data_cleaning`;

-- change Y and N to Yes and No in " Sold as Vacant" field
select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
       else SoldAsVacant
       end
from Housing.`housing.data_cleaning`;

update Housing.`housing.data_cleaning`
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
       else SoldAsVacant
       end;
-- remove duplicates
with RowNumCTE AS(
select *,
	row_number() over (
    partition by ParcelID, 
				 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 order by
					UniqueID
                    ) row_num
from Housing.`housing.data_cleaning`
)
delete 
from RowNumCTE
where row_num >1;

-- delete unused columns
alter table Housing.`housing.data_cleaning`
drop column OwnerAddress;


