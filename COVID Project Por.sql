--#1 Select the data that we going to use 


Select location, date , total_cases, new_cases , total_deaths , population
from dbo.CovidDeaths
Order by 1,2



--#2See Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS  DeathPercantage
from dbo.CovidDeaths
Order by 1,2


--#3See Total Cases vs Population
-- Precentage of Population got Covid
Select location, date, total_cases, population, (total_cases/population)*100 AS  Precentage_of_Population_Infected
from dbo.CovidDeaths
Order by 1,2





--4 See Highest Infection Rate vs Population
-- 
Select location, Population,  MAX(total_cases) AS Highest_Infection, MAX((total_cases/population))*100 AS  Precentage_of_Population_Infected
from dbo.CovidDeaths
Group by location , Population
Order by Precentage_of_Population_Infected Desc



--5 See Highest Highest Deaths per population
-- 
Select location, MAX(CAST(total_deaths AS int)) AS total_Deaths
from dbo.CovidDeaths
where continent is not null --to just show countries 
Group by location 
Order by total_Deaths Desc




--6 See Highest Highest Deaths per population
--
Select continent, MAX(CAST(total_deaths AS int)) AS total_Deaths
from dbo.CovidDeaths
where continent is not null --to just show continent 
Group by continent 
Order by total_Deaths Desc



--7 See Highest Highest Deaths per population
--
Select location, MAX(CAST(total_deaths AS int)) AS total_Deaths
from dbo.CovidDeaths
where continent is null --to show continent + world and other 
Group by location 
Order by total_Deaths Desc






--Golbal




Select SUM(new_cases) AS total_cases , SUM(CAST(new_deaths AS int)) AS total_deaths , SUM(CAST(new_deaths AS int))/SUM(new_cases) *100 AS F
from dbo.CovidDeaths
where continent is not null
--group by date
Order by 1,2




--#JOINS


--Total population vs VAccinations


select dea.continent , dea.location, dea.date , dea.population , vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations AS int)) over (Partition by dea.location order by dea.location , dea.date) AS RPV
from dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

      




-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RVP numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent , dea.location, dea.date , dea.population , vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations AS int)) over (Partition by dea.location order by dea.location , dea.date) AS RPV
from dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RVP/Population)*100
From #PercentPopulationVaccinated









-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent , dea.location, dea.date , dea.population , vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations AS int)) over (Partition by dea.location order by dea.location , dea.date) AS RPV
from dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null





Select *
from PercentPopulationVaccinated