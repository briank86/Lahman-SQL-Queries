/*players who were on the 2015 Pirates*/
SELECT People.nameFirst AS "First Name", People.nameLast AS "Last Name", b.yearID, b.H, b.AB
FROM Batting AS b
INNER JOIN People ON b.playerID = People.playerID
WHERE yearID = 2015 AND teamID = 'PIT'

	
/*Top 10 home run hitters in 2018*/
SELECT TOP 10 b.yearID, CONCAT(p.nameFirst, ' ' , p.nameLast) AS "Full Name", b.teamID AS Team, b.HR
FROM Batting AS b
JOIN People AS p
ON b.playerID = p.playerID
WHERE b.yearID = 2018
ORDER BY HR DESC

	
/*top 10 average hitters in 2018*/
ALTER TABLE dbo.Batting ALTER COLUMN H FLOAT
SELECT TOP 10 b.yearID, CONCAT(p.nameFirst, ' ' , p.nameLast) AS "Full Name", b.teamID AS Team, b.H, b.AB, round(b.H/b.AB, 3) AS Average
FROM Batting AS b
JOIN People AS p
ON b.playerID = p.playerID 
WHERE b.yearID = 2018 AND b.AB > 450 AND b.AB <> 0 
ORDER BY Average DESC


/*Top home run hitters by position in 2008*/
SELECT posHR."Full Name", posHR.teamID, posHR.yearID, maxHR.POS, maxHR.HR
FROM(SELECT CONCAT(p.nameFirst, ' ' , p.nameLast) AS "Full Name", f.yearID, f.teamID, b.HR, f.POS, p.playerID
	 FROM Fielding as f
	 JOIN Batting as b ON b.playerID = f.playerID AND b.yearID = f.yearID
	 JOIN People as p ON p.playerID = b.playerID
	 WHERE b.yearID = 2008) posHR
JOIN(SELECT MAX(posHR1.HR) as HR, posHR1.POS
	 FROM(SELECT CONCAT(p.nameFirst, ' ' , p.nameLast) AS "Full Name", f.yearID, f.teamID, b.HR, f.POS, p.playerID
		FROM Fielding as f
		JOIN Batting as b ON b.playerID = f.playerID AND b.yearID = f.yearID
		JOIN People as p ON p.playerID = b.playerID
		WHERE b.yearID = 2008) posHR1 
	 GROUP BY posHR1.POS) maxHR
ON posHR.HR = maxHR.HR AND posHR.POS = maxHR.POS

	
/*Lahman data from 2019*/
/*Who has the most home runs who is not in the hall of fame and not currently playing in 2019 excluding Barry Bonds and Alex Rodriguez?

This would be David Ortiz at 541. 
To go one step further who has the most home runs that is Hall of Fame eligible.
Oritz wasn't eligible yet and same with Adrian Beltre who had 477.

So the player after the 2019 season who has the most home runs who isn't in the hall of fame and is eligible would be Adam Dunn with 462 (also failed to get the 5% needed to stay on ballot in 2020)*/
SELECT Nhr.fullName, MAX(Nhr.sumHR) AS HR
FROM(SELECT NotHall.fullName, SUM(NotHall.HR) as sumHR
	FROM(SELECT h.inducted, p.playerID, CONCAT(p.nameFirst, ' ' , p.nameLast) as fullName, p.finalGame, b.HR
		FROM People AS p
		JOIN Batting AS b ON p.playerID = b.playerID
		LEFT JOIN HallOfFame AS h ON p.playerID = h.playerID
		WHERE h.playerID is NULL AND CAST(SUBSTRING(p.finalGame, 0, 5) AS INT) < 2019) NotHall
	GROUP BY NotHall.fullName) Nhr
GROUP BY Nhr.fullName
ORDER BY HR DESC

