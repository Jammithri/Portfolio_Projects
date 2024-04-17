Select *
From ProtfolioProject. .CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From ProtfolioProject. .CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From ProtfolioProject. .CovidDeaths
Where continent is not null
order by 1,2 


--Looking at Total Cases vs Total Deaths--
Select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage 
From ProtfolioProject. .CovidDeaths
Where location like '%India%'
and continent is not null
order by 1,2 


--Looking at Total cases vs Population--
--Percentage of population that got affected by covid--
Select location, date, total_cases, population, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
From ProtfolioProject. .CovidDeaths
--Where location like '%India%'--
order by 1,2 

--Looking at countries with highest infection rate compared to population--
Select location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS PercentPopulationInfected
From ProtfolioProject. .CovidDeaths
Group by location, population
order by PercentPopulationInfected desc


--Showing countries with highest death count per population--
Select Location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
From ProtfolioProject. .CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Understanding things by continent--

Select continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
From ProtfolioProject. .CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers--
Select  SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS int)) as total_deaths, SUM(CAST(new_deaths as int)) / SUM(new_cases) * 100 AS Deathpercentage 
From ProtfolioProject. .CovidDeaths
Where continent is not null
--Group by date--
order by 1,2 


--Vaccinations--

--Looking at Total Population vs Vaccinations--
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
From ProtfolioProject. .CovidDeaths dea
Join ProtfolioProject. .CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
where dea.continent is not null 
Order By 2, 3

--use cte--

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
From ProtfolioProject. .CovidDeaths dea
Join ProtfolioProject. .CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



--Temp Table--
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeoplevaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
From ProtfolioProject. .CovidDeaths dea
Join ProtfolioProject. .CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date 

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating view to store data for later visulaization--

Create view PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
From ProtfolioProject. .CovidDeaths dea
Join ProtfolioProject. .CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date 
Where dea.continent is not null

Select *
From PercentPopulationVaccinated
