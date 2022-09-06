/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4


-- Select data to start with
Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

-- Look at total case vs total deaths
-- Shows likelihood of dying if you contract covid in a specific country, in this case the United States

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1,2 desc


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid in the United States

Select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
FROM PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as InfectionPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
group by location, population
order by 4 desc

-- Countries with Highest Death Count per Population

Select location, Max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
group by location
order by HighestDeathCount desc

-- Countries with Highest Death Rate compared to Population. 
-- Since some countries are missing data for new_deaths, summing new_deaths or using max(total_deaths) gives slightly different values 

Select location, population, sum(cast(new_deaths as int)) as TotalDeaths, 
sum((new_deaths/population))*100 as DeathRate
FROM PortfolioProject..CovidDeaths$
group by location, population
order by DeathRate desc

Select location, population, max(cast(total_deaths as int)) as TotalDeaths, 
max(total_deaths/population)*100 as DeathRate
FROM PortfolioProject..CovidDeaths$
group by location, population
order by DeathRate desc


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

Select continent, Max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
group by continent
order by HighestDeathCount desc

-- Shows continents with highest deathcounts per population with income groupings removed

Select location, Max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
where (continent is null
	AND iso_code not like 'OWID_UMC'
	AND iso_code not like 'OWID_UMC'
	AND iso_code not like 'OWID_LIC'
	AND iso_code not like 'OWID_HIC'
	AND iso_code not like 'OWID_LMC')
group by location
order by HighestDeathCount desc

-- Another way to break down by continent without income grouping

Select location, Max(cast(total_deaths as int)) as highest_infection_count
From PortfolioProject..CovidDeaths$
Where continent is  null 
	and location like 'Asia' 
	or location like 'Africa'
	or location like 'North America' 
	or location like 'South America' 
	or location like 'Europe'
	or location like 'Oceania'
Group by location
Order by highest_infection_count desc

-- Global numbers

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
Where continent is not null
group by date
order by 1,2 desc

-- Total Deaths in World vs Total Cases

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
Where continent is not null
order by 1,2 desc

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by  dea.location order by dea.location, 
	dea.date) as RollingTotalVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingTotalVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by  dea.location order by dea.location, 
	dea.date) as RollingTotalVaccinated
--	, (RollingTotalVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingTotalVaccinated/Population)*100 as RollingPercentVacc
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVacc as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *
From PercentPopulationVacc

Create View HighestDeathCount as
Select continent, Max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
group by continent

Create View InfectionPercentage as
Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as InfectionPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
group by location, population

Create View DeathRate as
Select location, population, max(cast(total_deaths as int)) as TotalDeaths, max((total_deaths/population))*100 as DeathRate
FROM PortfolioProject..CovidDeaths$
group by location, population

