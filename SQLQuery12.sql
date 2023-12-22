select * from Covid19..coviddeath1$
order by 3, 4;
select * from Covid19..covidvacination$
order by 3, 4;
select Location, date, total_cases, new_cases, total_deaths, population
from Covid19..coviddeath1$ order by 1,2;

select Location, date, total_cases, total_deaths, (CONVERT(FLOAT,total_deaths)/NULLIF(CONVERT(FLOAT,total_cases),0))*100 as DeathPercentage
from Covid19..coviddeath1$ order by 1, 2;

select Location, date, total_cases, population, (CONVERT(FLOAT,total_cases)/NULLIF(CONVERT(FLOAT,population),0))*100 as percentinfected
from Covid19..coviddeath1$ 
WHERE LOCATION LIKE 'Afghan%'
order by 1, 2;

select Location, max(total_cases) as highestinfection, population, max(CONVERT(FLOAT,total_cases)/NULLIF(CONVERT(FLOAT,population),0))*100 as percentinfected
from Covid19..coviddeath1$ 
--WHERE LOCATION LIKE 'Afghan%'
group by location, population
order by percentinfected desc;

select location, max(cast(total_deaths as int)) as deathrate
from Covid19..coviddeath1$
where continent is not null
group by location
order by deathrate desc;

select continent, max(cast(total_deaths as int)) as deathrate
from Covid19..coviddeath1$
where continent is not null
group by continent
order by deathrate desc;

select location, max(cast(total_deaths as int)) as deathrate
from Covid19..coviddeath1$
where continent is null
group by location
order by deathrate desc;

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(nullif(new_cases,0))*100 as deathpercentage
from Covid19..coviddeath1$
where continent is not null 
--group by date
order by 1,2;




select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(nullif(new_cases,0))*100 as deathpercentage
from Covid19..coviddeath1$
where continent is not null 
--group by date
order by 1,2;

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations) )
over (partition by dea.location order by dea.location, dea.date)as totalvaccinations
from Covid19..coviddeath1$ dea
join Covid19..covidvacination$ vac
on
dea.location=vac.location
and
dea.date=vac.date
where dea.continent is not null
order by  2, 3;

with popvsvac (continent, location, date, population, new_vaccinations, totalvaccinations)
as (
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations) )
over (partition by dea.location order by dea.location, dea.date)as totalvaccinations
from Covid19..coviddeath1$ dea
join Covid19..covidvacination$ vac
on
dea.location=vac.location
and
dea.date=vac.date
where dea.continent is not null
 )
select*, (totalvaccinations/population)*100
from popvsvac
--temporary table
drop table if exists #pupvaccinated
create table #pupvaccinated(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population float,
new_vaccination float,

totalvaccination float)

insert into #pupvaccinated
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations) )
over (partition by dea.location order by dea.location, dea.date)as totalvaccinations
from Covid19..coviddeath1$ dea
join Covid19..covidvacination$ vac
on
dea.location=vac.location
and
dea.date=vac.date
where dea.continent is not null

select*, (totalvaccination/population)*100
from #pupvaccinated
--creating view for later visiulaisation

create view percentagevaccinated as 
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations) )
over (partition by dea.location order by dea.location, dea.date)as totalvaccinations
from Covid19..coviddeath1$ dea
join Covid19..covidvacination$ vac
on
dea.location=vac.location
and
dea.date=vac.date
where dea.continent is not null