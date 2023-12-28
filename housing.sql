select * from Housing..housingdetails$;
--cleaning data
--1standardize Date Format

select * from Housing..housingdetails$
select SaleDateconverted, convert(Date, saledate)
from Housing..housingdetails$

Update Housing..housingdetails$
set saledate= convert(date,saledate)

select saledate from Housing..housingdetails$

alter table housing..housingdetails$
add saledateconverted date;

Update Housing..housingdetails$
set saledateconverted= convert(date,saledate)

--populate property address data

select *from 
Housing..housingdetails$
--where Propertyaddress iS NULL
order by ParcelID;

select  a.ParcelID,a.Propertyaddress , b.ParcelID, b.Propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress) from
Housing..housingdetails$ a
JOIN Housing..housingdetails$ b
on a.ParcelID=b.ParcelID
AND a.[UnqueID] <> b.[UniqueID]
where  a.propertyaddress is null;

update a 
set propertyaddress=ISNULL(a.propertyaddress,b.propertyaddress) from
Housing..housingdetails$ a
JOIN Housing..housingdetails$ b
on a.ParcelID=b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
where  a.propertyaddress is null;

select * from Housing.dbo.housingdetails$



--Breaking out address into individual columns(address, city, state)
 select 
parsename(replace(propertyaddress,',', '.'),2) as street,
parsename(replace(propertyaddress,',', '.'),1) as city

from Housing..housingdetails$;

select owneraddress from Housing..housingdetails$;

select
parsename(replace(owneraddress,',','.'),3)as streetaddress,
parsename(replace(owneraddress,',','.'),2)as cityaddress,
parsename(replace(owneraddress,',','.'),1)as state
from housing..housingdetails$;

--updating soldasvacant column;
select soldasvacant from Housing..housingdetails$;
select soldasvacant 
,case when soldasvacant= 'N' then 'No'
      when soldasvacant= 'Y' then 'Yes'
	  else soldasvacant
	  end
from housing..housingdetails$;

update housing..housingdetails$
set soldasvacant=case when soldasvacant= 'N' then 'No'
      when soldasvacant= 'Y' then 'Yes'
	  else soldasvacant
	  end
from housing..housingdetails$;

--removing duplicated data

select *, ROW_NUMBER() over(
partition by ParcelID,
PropertyAddress,
Saleprice,
saledate,
legalreference
order by 
uniqueID
)row_num
from housing..housingdetails$
order by ParcelID

WITH rownumcte as(
select *, ROW_NUMBER() over(
partition by ParcelID,
PropertyAddress,
Saleprice,
saledate,
legalreference
order by 
uniqueID
)row_num
from housing..housingdetails$
)
select * from rownumcte
where row_num >1
--order by property address;
 --deleting unused columns

 Alter table housing..housingdetails$
 drop column owneraddress, propertyaddress,
 saledate;