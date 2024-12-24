SELECT * FROM projectsql.coviddeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4;

-- Total Cases vs Total Deaths
-- Shows like-lihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From projectsql.coviddeaths
Where location like '%states%'
and continent is not null 
order by 1,2;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From projectsql.Coviddeaths
order by 1,2;


-- Countries with Highest Infection Rate compared to Population

Select location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From projectsql.Coviddeaths
Group by Location, Population
order by PercentPopulationInfected desc ;


-- Countries with Highest Death Count per Population

Select location,  MAX(cast(Total_deaths as UNSIGNED)) as TotalDeathCount
From projectsql.Coviddeaths
Group by Location
ORDER BY TotalDeathCount desc ;




-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as UNSIGNED)) as TotalDeathCount
From projectsql.CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc;


-- GLOBAL NUMBERS

Select sum(new_cases),sum(cast(new_deaths as UNSIGNED)) as total_deaths, sum(cast(new_deaths as UNSIGNED))/sum(new_cases)*100 as DeathPercentage
From projectsql.coviddeaths
WHERE continent is not null 
order by 1,2 ;


-- Join two table

SELECT * FROM projectsql.coviddeaths dea
JOIN projectsql.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date;



-- Looking at total population vs new vaccinations

SELECT dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
FROM projectsql.coviddeaths dea
JOIN projectsql.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3;

-- Creating view to store data for later visualizarions

CREATE VIEW PercpopulationVacc AS
SELECT dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations, 
sum(cast( vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RPplVaccinated
FROM projectsql.coviddeaths dea
JOIN projectsql.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


SELECT * FROM PercpopulationVacc;

-- End




