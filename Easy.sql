/*Query all columns for all American cities in CITY with populations larger than 100000. The CountryCode for America is USA.*/
select * from CITY 
where COUNTRYCODE='USA'
and POPULATION>100000;

/*Query the names of all American cities in CITY with populations larger than 120000. The CountryCode for America is USA.*/
select NAME from CITY 
where COUNTRYCODE='USA'
and POPULATION>120000;

/*Query all columns (attributes) for every row in the CITY table.*/
select * from CITY

/*Query all columns for a city in CITY with the ID 1661.*/
select * from CITY
where ID=1661

/*Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.*/
select * from CITY
where COUNTRYCODE='JPN';

/*Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.*/
select NAME from CITY
where COUNTRYCODE='JPN';

/*Query a list of CITY and STATE from the STATION table.*/
select CITY,STATE 
from STATION;

/*Query a list of CITY names from STATION with even ID numbers only. */
/*You may print the results in any order, but must exclude duplicates from your answer.*/
select distinct CITY 
from STATION
where ID%2=0;

/*Let N be the number of CITY entries in STATION, and let N' be the number of distinct CITY names in STATION; */
/*query the value of N-N' from STATION. In other words, find the difference between the total number of CITY entries*/ 
/*in the table and the number of distinct CITY entries in the table.*/
SELECT COUNT(CITY)-COUNT(DISTINCT CITY) 
FROM STATION ;

/*Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths */
/*(i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first */
/*when ordered alphabetically.*/
select city,length_city 
from (select a.*, rownum r 
      from (select length(city) length_city,city 
	        from station 
			order by length_city, city) a) 
			where r in (1,(select count(*) 
			               from station));

/*Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.*/
select distinct CITY 
from STATION
where CITY like '[AEIUOaeiou]%';

/*Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.*/
select distinct CITY
from STATION
where CITY like '%[AEIOUaeiou]';

/*Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. */
/*Your result cannot contain duplicates.*/
select distinct CITY 
from STATION
where CITY like '[AEIOUaeiou]%[AEIOUaeiou]'

/*Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.*/
select distinct CITY
from STATION
where CITY not like '[AEIOUaeiou]%';

/*Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.*/
select distinct CITY
from STATION
where CITY not like '%[AEIOUaeiou]';

/*Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. */
/*Your result cannot contain duplicates.*/
select distinct CITY
from STATION
where CITY not like '[AEIOUaeiou]%' 
or
CITY not like '%[AEIOUaeiou]'

/*Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.*/
select distinct CITY
from STATION
where CITY not like '[AEIOUaeiou]%'
and
CITY not like '%[AEIOUaeiou]'

/*Query the Name of any student in STUDENTS who scored higher than 75 Marks. Order your output by the last three characters of each name. */
/*If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.*/
Select NAME from STUDENTS 
where MARKS > 75 
order by right(NAME, 3), ID asc;

/*Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.*/
select NAME 
from EMPLOYEE
order by NAME asc;

/*Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than $200 per month */
/*who have been employees for less than 10 months. Sort your result by ascending employee_id.*/
select NAME 
from EMPLOYEE
where SALARY>2000
and MONTHS<10
order by EMPLOYEE_ID;

/*Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.*/
select sum(POPULATION) as JapPop
from CITY
where COUNTRYCODE='JPN';

/*Query the difference between the maximum and minimum populations in CITY.*/
select (max(POPULATION)-min(POPULATION))
from CITY

/*Query the following two values from the STATION table:
1. The sum of all values in LAT_N rounded to a scale of 2 decimal places.
2. The sum of all values in LONG_W rounded to a scale of 2 decimal places.*/
select format(sum(LAT_N) , '.##'), format(sum(LONG_W) , '.##') 
from STATION;

/*Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345. 
Truncate your answer to 4 decimal places.*/
select format(round(sum(LAT_N),4,1),'#.0000')
from STATION
where LAT_N>38.7880 and LAT_N<137.2345;

/*Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.*/
select CAST(max(LAT_N) as decimal (10,4)) 
from STATION
where LAT_N < 137.2345;

/*Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345. 
Round your answer to 4 decimal places.*/
select format(LONG_W,'N4') 
from STATION 
where LAT_N = (select MAX(LAT_N) 
               from STATION 
               where LAT_N<137.2345);

/*Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. Round your answer to 4 decimal places.*/
select convert(decimal(20,4),min(LAT_N)) 
from STATION 
where LAT_N > 38.7780;

/*Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. 
Output one of the following statements for each record in the table:
Equilateral: It's a triangle with 3 sides of equal length.
Isosceles: It's a triangle with 2 sides of equal length.
Scalene: It's a triangle with 3 sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.
*/
select case
        when A+B>C and B+C>A and A+C>B then
            case
                when A=B and B=C then "Equilateral"
                when A=B or B=C or A=C then "Isosceles"
                else "Scalene"
                end
        else "Not A Triangle"
      end
as TriangleType      
from TRIANGLES;

/*Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.
Note: CITY.CountryCode and COUNTRY.Code are matching key columns.*/
select CITY.NAME
from CITY
    join COUNTRY
    on CITY.COUNTRYCODE = COUNTRY.CODE
where CONTINENT = 'Africa';

/*Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations 
(CITY.Population) rounded down to the nearest integer.
Note: CITY.CountryCode and COUNTRY.Code are matching key columns.*/
select cntry.continent, cast(round(avg(cty.Population)-0.5,0) as int) as 'AvgPop'
from city cty
inner join country cntry
ON cty.countrycode = cntry.code
group by cntry.continent;

/*P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
*****
****
***
**
*
Write a query to print the pattern P(20).*/
select REPLICATE('* ',p+q) from (values (5),(4),(3),(2),(1)) a(p) cross join (values (15),(10),(5),(0)) b(q);

/*P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
*
**
***
****
*****
Write a query to print the pattern P(20).*/
select REPLICATE('* ',p+q) from (values (1),(2),(3),(4),(5)) a(p) cross join (values (0),(5),(10),(15)) b(q);

/*Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.
Note: CITY.CountryCode and COUNTRY.Code are matching key columns.*/
select sum(CITY.POPULATION) 
from CITY 
where CITY.COUNTRYCODE IN (select CODE 
                           from COUNTRY 
                           where CONTINENT = 'ASIA');