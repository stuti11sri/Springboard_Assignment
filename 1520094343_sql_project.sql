/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can 
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */

/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT DISTINCT name FROM `Facilities` WHERE membercost > 0.0

name
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q2: How many facilities do not charge a fee to members? */

SELECT DISTINCT name FROM `Facilities` WHERE membercost = 0.0

name
Badminton Court
Table Tennis
Snooker Table
Pool Table

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name , membercost, monthlymaintenance
FROM `Facilities`  
WHERE membercost > 0.0  
and membercost < (0.2 *  monthlymaintenance )


facid	name	membercost	monthlymaintenance
0	Tennis Court 1	5	200
1	Tennis Court 2	5	200
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80
Powered by


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * FROM `Facilities` 
WHERE facid IN (1,5)

facid	name	membercost	guestcost	initialoutlay	monthlymaintenance
1	Tennis Court 2	5	25	8000	200
5	Massage Room 2	9.9	80	4000	3000


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

select name , monthlymaintenance , if(monthlymaintenance < 100 , "cheap" , "expensive") AS Type
from Facilities

name	monthlymaintenance	Type
Tennis Court 1	200	expensive
Tennis Court 2	200	expensive
Badminton Court	50	cheap
Table Tennis	10	cheap
Massage Room 1	3000	expensive
Massage Room 2	3000	expensive
Squash Court	80	cheap
Snooker Table	15	cheap
Pool Table	15	cheap


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT surname , firstname FROM `Members`
where joindate = (select max(joindate) from Members)

surname	firstname
Smith	Darren


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select DISTINCT (concat (m.firstname ," " , f.name))
from Members m join Bookings b 
on m.memid=b.memid 
join Facilities f ON 
b.facid = f.facid
where f.name Like 'Tennis Court%'
Order by m.firstname

(concat (m.firstname ," " , f.name))
Anne Tennis Court 2
Anne Tennis Court 1
Burton Tennis Court 1
Burton Tennis Court 2
Charles Tennis Court 2
Charles Tennis Court 1
Darren Tennis Court 2
David Tennis Court 2
David Tennis Court 1
Douglas Tennis Court 1
Erica Tennis Court 1
Florence Tennis Court 2
Florence Tennis Court 1
Gerald Tennis Court 2
Gerald Tennis Court 1
GUEST Tennis Court 2
GUEST Tennis Court 1
Henrietta Tennis Court 2
Jack Tennis Court 1
Jack Tennis Court 2
Janice Tennis Court 2
Janice Tennis Court 1
Jemima Tennis Court 2
Jemima Tennis Court 1
Joan Tennis Court 1
John Tennis Court 1
John Tennis Court 2
Matthew Tennis Court 1
Millicent Tennis Court 2
Nancy Tennis Court 2


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select concat(f.name," ",m.firstname," ",m.surname) as ListOfBooking,(if(m.memid=0, 2 * f.guestcost,2 * f.membercost)*b.slots) as Cost
from Members m join Bookings b 
on m.memid=b.memid 
join Facilities f ON 
b.facid = f.facid
where left(starttime,10) ='2012-09-14'
and (if(m.memid=0, 2 * f.guestcost,2 * f.membercost) * b.slots) >30
order by Cost

ListOfBooking	Cost
Massage Room 1 Burton Tracy	39.6
Massage Room 1 Jack Smith	39.6
Massage Room 2 Florence Bader	39.6
Massage Room 1 Jemima Farrell	39.6
Massage Room 1 Matthew Genting	39.6
Massage Room 1 Ponder Stibbons	39.6
Tennis Court 2 Tim Boothe	60
Tennis Court 2 David Jones	60
Squash Court GUEST GUEST	70
Squash Court GUEST GUEST	70
Massage Room 1 Jemima Farrell	79.2
Squash Court GUEST GUEST	140
Tennis Court 2 GUEST GUEST	150
Tennis Court 1 GUEST GUEST	150
Tennis Court 1 GUEST GUEST	150
Tennis Court 2 GUEST GUEST	300
Massage Room 1 GUEST GUEST	320
Massage Room 1 GUEST GUEST	320
Massage Room 1 GUEST GUEST	320
Massage Room 2 GUEST GUEST	640


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

select sub.ListOfBooking ,sub.Cost
from
(select concat(f.name," ",m.firstname," ",m.surname) as ListOfBooking,(if(m.memid=0, 2 * f.guestcost,2 * f.membercost)*b.slots) as Cost
from Members m join Bookings b 
on m.memid=b.memid 
join Facilities f ON 
b.facid = f.facid
where left(starttime,10) ='2012-09-14'
and (if(m.memid=0, 2 * f.guestcost,2 * f.membercost) * b.slots) >30)sub
order by sub.Cost

ListOfBooking	Cost
Massage Room 1 Jack Smith	39.6
Massage Room 2 Florence Bader	39.6
Massage Room 1 Jemima Farrell	39.6
Massage Room 1 Matthew Genting	39.6
Massage Room 1 Ponder Stibbons	39.6
Massage Room 1 Burton Tracy	39.6
Tennis Court 2 Tim Boothe	60
Tennis Court 2 David Jones	60
Squash Court GUEST GUEST	70
Squash Court GUEST GUEST	70
Massage Room 1 Jemima Farrell	79.2
Squash Court GUEST GUEST	140
Tennis Court 1 GUEST GUEST	150
Tennis Court 1 GUEST GUEST	150
Tennis Court 2 GUEST GUEST	150
Tennis Court 2 GUEST GUEST	300
Massage Room 1 GUEST GUEST	320
Massage Room 1 GUEST GUEST	320
Massage Room 1 GUEST GUEST	320
Massage Room 2 GUEST GUEST	640



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT b.facid ,
    ((SUM(CASE WHEN memid =0 THEN 1 ELSE 0 END) * f.guestcost) +(SUM(CASE WHEN memid!=0 THEN 1 ELSE 0 END) * f.membercost)) as revenue
FROM Bookings b join Facilities f
where b.facid=f.facid
group by b.facid
having revenue < 1000

facid	revenue
2	604.5
3	90
7	115
8	265
