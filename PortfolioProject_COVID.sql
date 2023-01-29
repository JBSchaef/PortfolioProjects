SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject_COVID..Covid_Deaths
ORDER BY 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract COVID in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage 
FROM PortfolioProject_COVID..Covid_Deaths
WHERE location like '%states%'
ORDER BY 1,2


-- Looking at Total Cases vs. Populatin
-- Shows what percentage of population contracted COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 AS Death_Percentage 
FROM PortfolioProject_COVID..Covid_Deaths
WHERE location like '%states%'
ORDER BY 1,2

-- Looking at which countries have highest infection rate in relation to population

SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population))*100 AS Percent_Population_Infected
FROM PortfolioProject_COVID..Covid_Deaths
GROUP BY Location, Population
ORDER BY Percent_Population_Infected desc

-- Showing countries with highest death count per population
-- Data listed some continents Null so location pulled continent and not country

SELECT location, MAX(cast(total_deaths as int)) as Total_Death_Count
FROM PortfolioProject_COVID..Covid_Deaths
WHERE continent is not null
GROUP BY Location
ORDER BY Total_Death_Count desc

-- Breakdown by continent
-- ***Continent data did not show all countries within a continent so location is more accurate***

SELECT continent, MAX(cast(total_deaths as int)) as Total_Death_Count
FROM PortfolioProject_COVID..Covid_Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY Total_Death_Count desc

-- Showing contintents with the highest death count

SELECT continent, MAX(cast(total_deaths as int)) as Total_Death_Count
FROM PortfolioProject_COVID..Covid_Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY Total_Death_Count desc


-- Global Numbers

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject_COVID..Covid_Deaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- Global Numbers, excludes date

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject_COVID..Covid_Deaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as Rolling_People_Vaccinated
, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject_COVID..Covid_Deaths dea
JOIN PortfolioProject_COVID..Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- USE CTE

WITH Pop_Vs_Vac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject_COVID..Covid_Deaths dea
JOIN PortfolioProject_COVID..Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
Select*, (Rolling_People_Vaccinated/population)*100 as Rolling_By_Population
FROM Pop_Vs_Vac

-- TEMP TABLE

DROP TABLE IF exists #Percent_Population_Vaccinated
CREATE TABLE #Percent_Population_Vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

INSERT INTO #Percent_Population_Vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject_COVID..Covid_Deaths dea
JOIN PortfolioProject_COVID..Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

Select*, (Rolling_People_Vaccinated/population)*100 as Rolling_By_Population
FROM #Percent_Population_Vaccinated


-- Creating View to store data for later visualizations

CREATE VIEW Percent_Population_Vaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject_COVID..Covid_Deaths dea
JOIN PortfolioProject_COVID..Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3


CREATE VIEW Global_Death_Percentage as
SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject_COVID..Covid_Deaths
WHERE continent is not null
GROUP BY date
--ORDER BY 1,2

CREATE VIEW Infection_Rate_By_Population as
SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population))*100 AS Percent_Population_Infected
FROM PortfolioProject_COVID..Covid_Deaths
GROUP BY Location, Population
--ORDER BY Percent_Population_Infected desc
