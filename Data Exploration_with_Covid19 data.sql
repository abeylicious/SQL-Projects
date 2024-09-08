SELECT *
FROM Portfolio_projects.dbo.CovidDeaths
ORDER BY 3,4 DESC;

SELECT *
FROM Portfolio_projects.dbo.CovidVaccinations
ORDER BY 3,4 DESC;

SELECT location, date,total_cases,total_deaths, population
FROM Portfolio_projects.dbo.CovidDeaths
ORDER BY 1,2

--- Review the number of cases vs number of deaths for each county
SELECT location, total_cases, total_deaths, (total_deaths/total_cases)*100  AS Deathpercentage
FROM Portfolio_projects.dbo.CovidDeaths
WHERE location LIKE '%States'
ORDER BY location DESC;

--- Review the number of cases vs number of deaths for each county
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100  AS Deathpercentage
FROM Portfolio_projects.dbo.CovidDeaths
WHERE location = 'Nigeria'
ORDER BY Deathpercentage DESC;

---Total cases VS Population

Shows what % of population has got infected

SELECT location,population, date, total_cases,(total_cases/population)*100  AS infectedpercentage
FROM Portfolio_projects.dbo.CovidDeaths
WHERE location LIKE '%States'
ORDER BY 1,2;

---Looking at countries with highest infection rate in relation of population

SELECT location, population, MAX(total_cases) AS Higestrates,MAX(total_cases/population)*100  AS maxinfectedpercentage
FROM Portfolio_projects.dbo.CovidDeaths
GROUP BY location,population
ORDER BY 4 DESC;

SELECT location, population, SUM(total_cases)AS Highestcases
FROM Portfolio_projects.dbo.CovidDeaths
GROUP BY location,population
ORDER BY 2 DESC;

--SHowing countries with highest death rate
SELECT location, MAX(cast(total_deaths as int))AS Deathrate
FROM Portfolio_projects.dbo.CovidDeaths
GROUP BY location
ORDER BY 2 DESC;

SELECT location, population, SUM(total_cases) AS Allcases,SUM(cast(total_deaths as int)) AS Alldeaths
FROM Portfolio_projects.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY 4 DESC;

SELECT *
FROM Portfolio_projects.dbo.CovidDeaths
WHERE continent IS NOT NULL;

-- Breaking it down by continent
SELECT continent, SUM(total_cases) AS Allcases, MAX(cast(total_deaths as int)) AS Alldeaths
FROM Portfolio_projects.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 3 DESC;

---- Here are the correct_fugures
SELECT location, SUM(total_cases) AS Allcases, MAX(cast(total_deaths as int)) AS Alldeaths
FROM Portfolio_projects.dbo.CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY 3 DESC;

---Showing continents with the highest death rates
SELECT continent,MAX(cast(total_deaths as int)) AS Alldeaths
FROM Portfolio_projects.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC;

----- GLOBAL Numbers
SELECT date, SUM (new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM (new_cases) AS death_percentage
FROM Portfolio_projects.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;

SELECT SUM (new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM (new_cases) AS death_percentage
FROM Portfolio_projects.dbo.CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2;


