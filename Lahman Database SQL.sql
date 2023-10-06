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


