--Preview dataset after upload

SELECT *
FROM Foster_Totals

--View children in foster care in entire United States ordered by year

SELECT Location, TimeFrame, Data
FROM Foster_Totals
WHERE Location = 'United States'
ORDER BY TimeFrame

--View children in foster care in entire United States ordered by number of children in care

SELECT Location, TimeFrame, Data
FROM Foster_Totals
WHERE Location = 'United States'
ORDER BY Data desc

--View children in foster care in Kansas ordered by year.

SELECT Location, TimeFrame, Data
FROM Foster_Totals
WHERE Location = 'Kansas'
ORDER BY TimeFrame

--Find highest and lowest number of children in care for Kansas in dataset

SELECT MAX(Data) AS MostChildrenInCare, MIN(Data) AS LeastChildreninCare
FROM Foster_Totals
WHERE Location = 'Kansas'

--Which year had the highest children in care in Kansas?

SELECT TOP 1 TimeFrame, Data
FROM Foster_Totals
WHERE Location = 'Kansas'
ORDER BY Data DESC

--Which year had the least children in care in Kansas?

SELECT TOP 1 TimeFrame, Data
FROM Foster_Totals
WHERE Location = 'Kansas'
ORDER BY Data

--What is the maximum # of children in care by state, excluding national totals?

SELECT Location, TimeFrame, Data as NumInCare
FROM Foster_Totals
WHERE Location <> 'United States' AND Data <> 'N.A.'
ORDER BY Data desc

--Join Datasets to include 2019 children in care by state and 2019 Population
SELECT *
	FROM Foster_Totals as Totals
LEFT JOIN
	[Foster_Care].[dbo].[2019_Population] as PopulationData
ON Totals.Location = PopulationData.Location
WHERE LocationType <> 'Nation' and TimeFrame = '2019'







