/*Consider P1 (a,b) and P2 (c,d) to be two points on a 2D plane.
a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.*/
select format(abs(min(LAT_N)-max(LAT_N))+abs(min(LONG_W)-max(LONG_W)),'F4') 
from STATION;

/*Consider P1 (a,c) and P2 (b,d) to be two points on a 2D plane where (a,b) are the respective minimum and maximum values of Northern Latitude (LAT_N) 
and (c,d) are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.
Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits.*/
select format(sqrt(
    power(min(LAT_N)-max(LAT_N), 2) + 
    power(min(LONG_W)-max(LONG_W), 2)), 
              'F4') 
from STATION;

/*A median is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern Latitudes (LAT_N) from 
STATION and round your answer to 4 decimal places.*/
select top (1) cast(percentile_cont(0.5) within group (order by LAT_N) over () as decimal (10, 4))
from STATION;

/*Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.
Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age. 
Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. 
If more than one wand has same power, sort the result in order of descending age.*/
SELECT ID, AGE, COINS_NEEDED, POWER 
FROM (WANDS w JOIN WANDS_PROPERTY p ON w.Code = p.Code) 
WHERE p.is_evil = 0 AND w.coins_needed = (
                                           SELECT MIN(coins_needed) 
                                           FROM Wands w1 JOIN WANDS_PROPERTY p1 ON (w1.code = 
                                           p1.code) 
                                           WHERE w1.power = w.power AND p1.age = p.age ) 
                                           ORDER BY POWER DESC, AGE DESC;

/*Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, and the total number of challenges 
created by each student. Sort your results by the total number of challenges in descending order. If more than one student created the same number 
of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the 
maximum number of challenges created, then exclude those students from the result.*/
select a.hacker_id, a.name, c.cnt
from Hackers as a
        join (select cnt.hacker_id, cnt.cnt as cnt, count(cnt.cnt) over(partition by cnt.cnt) as Repeated, max(cnt.cnt) over() as Max_cnt from (select hacker_id, count(challenge_id) as cnt 
              from Challenges group by hacker_id) as cnt) as c
         on a.hacker_id = c.hacker_id
where c.cnt = c.max_cnt or c.Repeated = 1
order by c.cnt desc, a.hacker_id asc;

/*You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!
The total score of a hacker is the sum of their maximum scores for all of the challenges. Write a query to print the hacker_id, name, and 
total score of the hackers ordered by the descending score. If more than one hacker achieved the same total score, then sort the result by 
ascending hacker_id. Exclude all hackers with a total score of 0 from your result.*/
select h.hacker_id, name, sum(score) 
from hackers as h inner join (select hacker_id, max(score) as score from submissions 
                              group by challenge_id, hacker_id) max_score on
                              h.hacker_id=max_score.hacker_id group by h.hacker_id, name 
                              having sum(score) > 1 
                              order by sum(score) desc, h.hacker_id;

/*Generate the following two result sets:
Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical 
(i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:
There are a total of [occupation_count] [occupation]s.
where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. 
If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.
Note: There will be at least two entries in the table for each type of occupation.*/
select concat(NAME, 
              case 
              when occupation = "Doctor" then "(D)" 
              when occupation = "Professor" then "(P)" 
              when occupation = "Singer" then "(S)" 
              when occupation = "Actor" then "(A)" end ) 
from OCCUPATIONS 
order by NAME,OCCUPATION;

select "There are a total of", count(OCCUPATION), concat(lower(OCCUPATION),"s.") 
from OCCUPATIONS 
group by OCCUPATION 
order by count(OCCUPATION) ASC, OCCUPATION ASC;

/*Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. 
The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
Note: Print NULL when there are no more names corresponding to an occupation.*/
select min(Doctor), min(Professor),min(Singer), min(Actor) 
from(select ROW_NUMBER() OVER(PARTITION By Doctor,Actor,Singer,Professor order by name asc) AS Rownum, 
         case when Doctor>0 then name 
              else Null 
              end as Doctor, 
     
         case when Actor>0 then name         
              else Null 
              end as Actor, 
     
         case when Singer>0 then name 
              else Null 
              end as Singer, 
        
         case when Professor>0 then name 
         else Null 
         end as Professor 
     
     from occupations pivot ( count(occupation) for occupation in(Doctor, Actor, Singer, Professor)) as p) pivotvalue
group by Rownum ;

/*You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.*/
select N, 
    case 
    when P is null then 'Root' 
    else (case 
          when (select count(*) 
                from BST 
                where P = B.N) > 0 then 'Inner' 
          else 'Leaf' 
          end) 
    end 
from BST AS B 
order by N;

/*Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy: 
Founder -> Lead Manager -> Senior Manager -> Manager -> Employee
Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, 
total number of managers, and total number of employees. Order your output by ascending company_code.
Note:
The tables may contain duplicate records.
The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending 
company_codes will be C_1, C_10, and C_2.*/
select comp.company_code,comp.founder,count(distinct leadman.lead_manager_code), count(distinct senman.senior_manager_code),count(distinct man.manager_code),count(distinct emp.employee_code)
from company comp,lead_manager leadman,senior_manager senman,manager man,employee emp 
where comp.company_code=leadman.company_code and leadman.lead_manager_code=senman.lead_manager_code and man.senior_manager_code=senman.senior_manager_code and 
emp.manager_code=man.manager_code 
group by comp.company_code,comp.founder 
order by comp.company_code;

/*You are given a table, Functions, containing two columns: X and Y.
Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.
Write a query to output all such symmetric pairs in ascending order by the value of X.*/
select p.x, p.y
from FUNCTIONS p join FUNCTIONS q on
    p.x = q.y and p.y = q.x
group by p.x, p.y
having count(p.x) > 1 or p.x < p.y
order by p.x

/*You are given three tables: Students, Friends and Packages. Students contains two columns: ID and Name. 
Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). 
Packages contains two columns: ID and Salary (offered salary in $ thousands per month).
Write a query to output the names of those students whose best friends got offered a higher salary than them. 
Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students got same salary offer.*/
select name from 
        (select name,stsal,p2.salary as frndsal 
         from
          (select st.id,st.name as name,salary as stsal,frnd.friend_id as fid 
           from students st inner join packages p on st.id=p.id inner join friends frnd on st.id=frnd.id)temp inner join packages p2 on temp.fid=p2.id)
         temp2 where frndsal > stsal order by frndsal;

/*You are given two tables: Students and Grades. Students contains three columns ID, Name and Marks.
Grades contains the following data: Grade, Min_Marks, Max_Marks
Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who 
received a grade lower than 8. The report must be in descending order by grade -- i.e. higher grades are entered first. 
If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. 
Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order. 
If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.
Write a query to help Eve.
Note
Print "NULL"  as the name if the grade is less than 8.*/
select case
        when gr.GRADE<8 then NULL
        else st.NAME
        end as Name, gr.GRADE, st.MARKS
from STUDENTS st
inner join GRADES gr
on st.MARKS between gr.MIN_MARK and gr.MAX_MARK
order by gr.GRADE desc, NAME, MARKS;

/*Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! Write a query to print the respective 
hacker_id and name of hackers who achieved full scores for more than one challenge. 
Order your output in descending order by the total number of challenges in which the hacker earned a full score. 
If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.*/
select hck.hacker_id, hck.name 
FROM submissions sub 
JOIN challenges chlng 
ON sub.challenge_id = chlng.challenge_id JOIN difficulty diff 
ON chlng.difficulty_level = diff.difficulty_level JOIN hackers hck 
ON sub.hacker_id = hck.hacker_id 
WHERE sub.score = diff.score 
AND chlng.difficulty_level = diff.difficulty_level 
GROUP BY hck.hacker_id,hck.name 
HAVING COUNT(sub.hacker_id) > 1 
ORDER BY COUNT(sub.hacker_id) DESC, hck.hacker_id ASC;

/*You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. 
It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.
If the End_Date of the tasks are consecutive, then they are part of the same project. 
Samantha is interested in finding the total number of different projects completed.
Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. 
If there is more than one project that have the same number of completion days, then order by the start date of the project.*/
select start_date, MIN(end_date)
from 
    (select start_date from PROJECTS where start_date not in (select end_date from PROJECTS)) a,
    (select end_date from PROJECTS where end_date not in (select start_date from PROJECTS)) b
where start_date < end_date
group by start_date
order by datediff(day, start_date, MIN(end_date)), start_date

/*Write a query to print all prime numbers less than or equal to . Print your result on a single line, and use the ampersand (&) character as 
your separator (instead of a space).
For example, the output for all prime numbers <=10 would be:*/
declare @a int=2;
declare @pr int = 0;
declare @r nvarchar(1000) = ''; --CAN BE ADJUSTED
while (@a<=1000)
begin
   declare @b int = @a-1;
   set @pr = 1;
   while(@b > 1)
   begin
      if @a % @b = 0
      begin 
         set @PR = 0;
      end
    set @b = @b - 1;
   end
   
   IF @PR = 1
   begin
      set @r+= cast(@a as nvarchar(1000)) + '&';
   end
set @a = @a + 1;
end
set @r = SUBSTRING(@r, 1, LEN(@r) - 1)
select @r

