Select *
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations$
--order by 3,4

-- select data to use
Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

--look at total case vs total deaths
-- shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1,2 desc


--look at total cases vs pop
-- shows what percentage got covid

Select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
FROM PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1,2


-- looking at countries with highest infection rate 

Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as InfectionPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
group by location, population
order by 4 desc

-- looking at countries with highest death count 

Select location, Max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
group by location
order by HighestDeathCount desc

--look at countries with highest death rate. Since some countries are missing data for new_deaths, summing new_deaths or using max(total_deaths) gives slightly different values 

Select location, population, sum(cast(new_deaths as int)) as TotalDeaths, sum((new_deaths/population))*100 as DeathRate
FROM PortfolioProject..CovidDeaths$
group by location, population
order by DeathRate desc

-- Try to look at countries with highest rate of deaths vs cases? nope
Select location, max(cast(total_cases as int)) as TotalCases, max(cast(total_deaths as int)) as TotalDeaths, 
max(total_deaths/total_cases)*100 as DeathRate
FROM PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by TotalDeaths desc

-- Try to look at countries with highest rate of deaths vs cases? Still no
Select location, total_cases as TotalCases, max(cast(total_deaths as int)) as TotalDeaths, 
max(total_deaths/total_cases)*100 as DeathRate
FROM PortfolioProject..CovidDeaths$
where continent is not null
group by location, total_cases
order by TotalDeaths desc

-- Try to look at countries with highest rate of deaths vs cases? whyyyyyyy
Select location, max(cast(total_cases as int)) as TotalCases, max(cast(total_deaths as int)) as TotalDeaths, 
((max(cast(total_deaths as int)))/(max(cast(total_cases as int))))*100 as DeathRate
FROM PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by TotalDeaths desc

--Shows deathcount vs population as a rolling percentage for a specific country

Select continent, location, date, population, new_deaths, total_deaths,
sum(cast(new_deaths as int)) OVER (Partition by location order by location, date) as RollingDeathCount, 
((sum(cast(new_deaths as int)) OVER (Partition by location order by location, date))/population)*100 as RollingDeathRate
FROM PortfolioProject..CovidDeaths$
Where (location like '%states%' and location not like '%virgin%')
order by 3 desc

--Shows deathcount vs total cases as a rolling percentage for a specific country

Select continent, location, date, new_cases, new_deaths,
sum(cast(new_cases as int)) OVER (Partition by location order by location, date) as RollingCaseCount,
sum(cast(new_deaths as int)) OVER (Partition by location order by location, date) as RollingDeathCount, 
((sum(cast(new_deaths as int)) OVER (Partition by location order by location, date))/(sum(cast(new_cases as int)) OVER (Partition by location order by location, date)))*100 as RollingDeathRate
FROM PortfolioProject..CovidDeaths$
Where location like '%states%'
order by RollingDeathCount desc


-- lets break it down by continent

Select location, Max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is null
group by location
order by HighestDeathCount desc

-- lets break it down by continent and remove income groupings

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

--another way to break down by continent without income grouping
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

--another way to break down by continent without income grouping

Select Location, population, Max(cast (total_deaths as int)) as TotalDeath, Max((total_deaths/population))*100 as MaxDeathPercentage
From PortfolioProject..CovidDeaths$
--Where continent is not null
where location in ('Asia', 'Africa', 'North America', 'South America', 'Europe')
Group by Location, population
order by TotalDeath desc

-- showing continents with highest death count per population
Select continent, Max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
group by continent
order by HighestDeathCount desc

-- get the max total deaths per continent

SELECT continent, SUM(max_total_deaths) AS Total_death_count
FROM (SELECT continent, location, cast(MAX(total_deaths) as int) AS max_total_deaths
	     FROM CovidDeaths$
	     GROUP BY continent, location) AS max_death_count_per_country -- created table to hold maximum death per country information
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_death_count DESC

-- Global numbers

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
Where continent is not null
group by date
order by 1,2 desc


-- total deaths in world vs total cases
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
Where continent is not null
--group by date
order by 1,2 desc


-- look at total population vs vaccination

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


--look at max vaccination rate by country

With PopvsVac (Continent, Location, Population, New_Vaccinations, RollingTotalVaccinated)
as 
(
Select dea.continent, dea.location, dea.population, vac.new_vaccinations
, max(sum(convert(bigint,vac.new_vaccinations))) over (partition by  dea.location order by dea.location) as RollingTotalVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
where dea.continent is not null
group by dea.continent, dea.location, dea.population
)
Select *, max((RollingTotalVaccinated/dea.Population))*100 as RollingPercentVacc
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


-- Creating View to store pop.vaccinated data for later visualizations

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

-- Creating View to store deathcount by continent data for later visualizations
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

