use covid;
select * 
from coviddeaths
order by 3,4;

-- select data what we're going to use
select location, date, total_cases, new_cases,total_deaths,population
from coviddeaths
order by 1,2;

-- looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
order by 1,2;

-- looking at total cases vs population
-- show what percentage of population got covid
select location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
from coviddeaths
order by 1,2;

-- looking at countries with highest infection rate compared to population
select location,population,max(total_cases)as HighestInfectionCount,max((total_cases/population))*100 as CasePercentage
from coviddeaths
group by location,population
order by CasePercentage desc;

-- showing continents with highest death count per population
select continent, max(total_deaths)as TotalDeathCount
from coviddeaths
group by continent
order by TotalDeathCount desc;

-- global numbers
select sum(new_cases),sum(new_deaths),(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from coviddeaths
order by 1,2;

-- use CTE
-- looking at total population vs vaccinations
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccainations vac
	on dea.location = vac.location
    and dea.date = vac.date
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac;

-- creating viewing to store data for later visualisation
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccainations vac
	on dea.location = vac.location
    and dea.date = vac.date;

SELECT * FROM Covid.percentpopulationvaccinated;