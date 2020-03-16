/*Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, 
hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by 
contest_id. Exclude the contest from the result if all four sums are .
Note: A specific contest can be used to screen candidates at more than one college, but each college only holds  screening contest.*/
select cont.contest_id, cont.hacker_id, cont.name, sum(x.total_submissions), sum(x.total_accepted_submissions), sum(x.total_views), sum(x.total_unique_views)
from Contests cont, Colleges col, Challenges chal, (select challenge_id, total_submissions, total_accepted_submissions, 0 as total_views, 0 as total_unique_views from Submission_Stats union all select challenge_id, 0, 0, total_views, total_unique_views from View_Stats) x
where cont.contest_id = col.contest_id and col.college_id = chal.college_id and chal.challenge_id = x.challenge_id
group by cont.contest_id, cont.hacker_id, cont.name
having sum(x.total_submissions)!=0 and sum(x.total_accepted_submissions)!=0 and sum(x.total_views)!=0 and sum(x.total_unique_views)!=0
order by cont.contest_id;

/*Julia conducted a 15 days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.
Write a query to print total number of unique hackers who made at least 1 submission each day (starting on the first day of the contest), and 
find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum number of 
submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.*/
select x.submission_date, x.hacker_count, y.hacker_id, h.name
from(select submission_date, count(distinct hacker_id) as hacker_count
     from(select s.*, dense_rank() over(order by submission_date) as date_rank, 
          dense_rank() over(partition by hacker_id order by submission_date) as hacker_rank 
          from submissions s ) a 
          where date_rank = hacker_rank 
          group by submission_date) x 
join 
(select submission_date,hacker_id, 
 rank() over(partition by submission_date order by sub_cnt desc, hacker_id) as max_rank 
from (select submission_date, hacker_id, count(*) as sub_cnt 
      from submissions 
      group by submission_date, hacker_id) b ) y
on x.submission_date = y.submission_date and y.max_rank = 1 
join hackers h on h.hacker_id = y.hacker_id 
order by 1;

/**/