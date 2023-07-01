--Selecting All my data

Select *
From PortfolioProjectA..[dbo.CovidDeaths]
Where continent is not null
Order By 3, 4

--Select *
--From PortfolioProjectA..CovidVaccination
--Order By 3, 4

--Now I am going to Select the Datas that am going to be using

Select location, date, total_cases, new_cases,total_deaths, population
From PortfolioProjectA..[dbo.CovidDeaths]
Where continent is not null

-- Now looking at total cases VS total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
From PortfolioProjectA..[dbo.CovidDeaths]
Where Location Like '%state%'
and continent is not null


-- Looking at total caeses VS population
-- How many people had gotten sick

Select location, date, total_cases, population, (population/total_cases)* 100as PercentPopulationInfected
From PortfolioProjectA..[dbo.CovidDeaths]
Where Location Like '%state%'
and continent is not null



-- Looking at countries with highest infection rate compare to population 

Select Location, Population, MAX(total_cases) as HighestInfection, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjectA..[dbo.CovidDeaths]
Group By Continent, Population
Order By PercentPopulationInfected desc


--Showing countries with highest death count per countries (very sad)

Select Location, Max(cast(total_deaths as Int)) as Totaldeaths
From PortfolioProjectA..[dbo.CovidDeaths]
Where continent is not null
Group By Continent
Order By Totaldeaths desc


--Let's break things down by Continent

Select continent, Max(cast(total_deaths as Int)) as Totaldeaths
From PortfolioProjectA..[dbo.CovidDeaths]
Where continent is not null
Group By continent
Order By Totaldeaths desc

--Let's break things down by Continent
--Showing continents with the highest deaths count per population


Select continent, Max(cast(total_deaths as Int)) as Totaldeaths
From PortfolioProjectA..[dbo.CovidDeaths]
Where continent is not null
Group By continent
Order By Totaldeaths desc


-- Global Numbers

Select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as Int)) as Total_Deaths, sum(cast(new_deaths as Int))/sum(new_cases)
*100 as DeathPercentage
From PortfolioProjectA..[dbo.CovidDeaths]
--Where Location Like '%state%'
Where continent is not null
Group by date
order by 1, 2


-- Global Total Number


Select sum(new_cases) as Total_Cases, sum(cast(new_deaths as Int)) as Total_Deaths, sum(cast(new_deaths as Int))/sum(new_cases)
*100 as DeathPercentage
From PortfolioProjectA..[dbo.CovidDeaths]
--Where Location Like '%state%'
Where continent is not null
--Group by date
order by 1, 2

-- Looking at tootal population vs vaccination


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProjectA..[dbo.CovidDeaths] dea
Join PortfolioProjectA..CovidVaccination vac
     on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by  2, 3

-- Using CTE

With PopvsVac (continent, location, date, population, New_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProjectA..[dbo.CovidDeaths] dea
Join PortfolioProjectA..CovidVaccination vac
     on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order 2, 3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac




-- Looking at Temp Table
-- And Drop Table

Drop Table if Exists #PercentPopulationVaccinatedd
Create Table #PercentPopulationVaccinatedd
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinatedd numeric
)

Insert Into #PercentPopulationVaccinatedd
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinatedd
From PortfolioProjectA..[dbo.CovidDeaths] dea
Join PortfolioProjectA..CovidVaccination vac
     on dea.location = vac.location
	 and dea.date = vac.date
--Where dea.continent is not null
--order 2, 3

Select *, (RollingPeopleVaccinatedd/population)*100
From #PercentPopulationVaccinatedd



-- Creating view to store Data for later visualizations


Create View PercentPopulationVaccinatedd  as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinatedd
From PortfolioProjectA..[dbo.CovidDeaths] dea
Join PortfolioProjectA..CovidVaccination vac
     on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order 2, 3



-- View Created


Select *
From PercentPopulationVaccinatedd