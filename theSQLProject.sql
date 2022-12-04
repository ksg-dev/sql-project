SELECT
	ar.ArtistId,
	ar.Name,
	COUNT(t.TrackId) AS Songs
FROM
	Artist ar
	JOIN Album al ON ar.ArtistId = al.ArtistId
	JOIN Track t ON al.AlbumId = t.AlbumId
	JOIN Genre g ON t.GenreId = g.GenreId
WHERE
	g.Name = 'Rock'
GROUP BY
	ar.ArtistId,
	ar.Name
ORDER BY
	3 DESC
LIMIT
	10;

SELECT
	Name,
	SUM(Quantity) AS sold,
	SUM(UnitPrice) AS total_usd,
FROM
	(
		SELECT
			i.InvoiceLineId,
			ar.Name,
			i.UnitPrice,
			i.Quantity
		FROM
			InvoiceLine i
			JOIN Track t ON i.TrackId = t.TrackId
			JOIN Album al ON al.AlbumId = t.AlbumId
			JOIN Artist ar ON ar.ArtistId = al.ArtistId
		GROUP BY
			2
	) sub
GROUP BY
	1
ORDER BY
	4 DESC;

SELECT
	Name,
	SUM(UnitPrice) * SUM(Quantity) AS AmountSpent
FROM
	(
		SELECT
			i.InvoiceLineId AS ID,
			ar.Name AS Name,
			i.UnitPrice AS UnitPrice,
			i.Quantity AS Quantity
		FROM
			InvoiceLine i
			JOIN Track t ON i.TrackId = t.TrackId
			JOIN Album al ON al.AlbumId = t.AlbumId
			JOIN Artist ar ON ar.ArtistId = al.ArtistId
	)
GROUP BY
	1
ORDER BY
	2 DESC;

SELECT
	art_name,
	SUM(total_qty) * SUM(total_usd) AS AmountSpent
FROM
	(
		SELECT
			ar.name AS art_name,
			t.name AS track_name,
			il.TrackId,
			SUM(il.Quantity) AS total_qty,
			SUM(il.UnitPrice) AS total_usd
		FROM
			InvoiceLine il
			JOIN Track t ON il.TrackId = t.TrackId
			JOIN Album al ON al.AlbumId = t.AlbumId
			JOIN Artist ar ON ar.ArtistId = al.ArtistId
		GROUP BY
			1,
			2,
			3
	) sub
GROUP BY
	1
ORDER BY
	2 DESC;

/ / / Brings up TrackId
and income total / / /
SELECT
	TrackId,
	(total_usd * qty) AS income
FROM
	(
		SELECT
			TrackId,
			COUNT(TrackId) AS num_sold,
			SUM(UnitPrice) AS total_usd,
			SUM(Quantity) AS qty
		FROM
			InvoiceLine
		GROUP BY
			1
		ORDER BY
			4 DESC
	) sub
GROUP BY
	1
ORDER BY
	2 DESC;

/ / / Correct way WOOOOO / / / /
SELECT
	ar.Name,
	SUM(il.UnitPrice) AS total_usd
FROM
	InvoiceLine il
	JOIN Track t ON t.TrackId = il.TrackId
	JOIN Album al ON al.AlbumId = t.AlbumId
	JOIN Artist ar ON ar.ArtistId = al.ArtistId
GROUP BY
	1
ORDER BY
	2 DESC;

/ / / Not quite right - AmountSpent gathering all receipts,
not just those for Iron Maiden / / /
SELECT
	ar.Name,
	SUM(i.total) AS AmountSpent,
	i.CustomerId,
	c.FirstName,
	c.LastName
FROM
	Artist ar
	JOIN Album al ON ar.ArtistId = al.ArtistId
	JOIN Track t ON t.AlbumId = al.AlbumId
	JOIN InvoiceLine il ON t.TrackId = il.TrackId
	JOIN Invoice i ON il.InvoiceId = i.InvoiceId
	JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY
	1,
	3,
	4,
	5
HAVING
	ar.name = 'Iron Maiden'
ORDER BY
	2 DESC;

* using
WHERE
	did not work either Right Answer ! Which Customer spent the most on Iron Maiden (top artist found in above solution)
SELECT
	ar.Name,
	SUM(il.UnitPrice) AS AmountSpent,
	i.CustomerID,
	c.FirstName,
	c.LastName
FROM
	Artist ar
	JOIN Album al ON ar.ArtistId = al.ArtistId
	JOIN Track t ON al.AlbumId = t.AlbumId
	JOIN InvoiceLine il ON t.TrackId = il.TrackId
	JOIN Invoice i ON il.InvoiceId = i.InvoiceId
	JOIN Customer c ON c.CustomerId = i.CustomerId
WHERE
	ar.Name = 'Iron Maiden'
GROUP BY
	1,
	3,
	4,
	5
ORDER BY
	2 DESC;

Q3 - Which Media Type has the most tracks ?
SELECT
	m.Name,
	COUNT(t.TrackID)
FROM
	MediaType m
	JOIN Track t ON t.MediaTypeId = m.MediaTypeId
GROUP BY
	1
ORDER BY
	2 DESC;

Q1 - How many Artists appear on each Playlist ?
SELECT
	t1.Playlist,
	COUNT(t1.Artist) AS num_Artist
FROM
	(
		SELECT
			DISTINCT ar.Name AS Artist,
			p.Name AS Playlist
		FROM
			Artist ar
			JOIN Album al ON ar.ArtistId = al.ArtistId
			JOIN Track t ON al.AlbumId = t.AlbumId
			JOIN PlaylistTrack pt ON t.TrackId = pt.TrackId
			JOIN Playlist p ON pt.PlaylistId = p.PlaylistId
		ORDER BY
			1
	) t1
GROUP BY
	1
ORDER BY
	2 DESC;

Q2 - On average,
how many tracks have artists sold in the Rock genre ?
SELECT
	AVG(t1.Track_Count) AS Average
FROM
	(
		SELECT
			ar.Name AS Artist,
			COUNT(il.TrackId) AS Track_Count
		FROM
			Artist ar
			JOIN Album al ON ar.ArtistId = al.ArtistId
			JOIN Track t ON al.AlbumId = t.AlbumId
			JOIN InvoiceLine il ON t.TrackId = il.TrackId
			JOIN Genre g ON t.GenreId = g.GenreId
		WHERE
			g.name = 'Rock'
		GROUP BY
			1
		ORDER BY
			2 DESC
	) t1;

Q4 - Which top 5 customers have spent the most total,
and how many tracks did they purchase ?
SELECT
	c.CustomerId,
	c.FirstName,
	c.LastName,
	COUNT(il.TrackId) AS TotalPurchased,
	SUM(i.Total) AS TotalSpent
FROM
	Customer c
	JOIN Invoice i ON c.CustomerId = i.CustomerId
	JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY
	1,
	2,
	3
ORDER BY
	5 DESC
LIMIT
	5;

SELECT
	DISTINCT p.Name AS Playlist,
	COUNT(ar.Name),
	COUNT(pt.TrackId) AS num_tracks
FROM
	Artist ar
	JOIN Album al ON ar.ArtistId = al.ArtistId
	JOIN Track t ON al.AlbumId = t.AlbumId
	JOIN PlaylistTrack pt ON t.TrackId = pt.TrackId
	JOIN Playlist p ON pt.PlaylistId = p.PlaylistId
GROUP BY
	1
ORDER BY
	2 DESC;

SELECT
	t1.CustId,
	t1.FullName,
	SUM(t1.Items) AS TotalPurchased,
	SUM(t1.Total) AS TotalSpent
FROM
	(
		SELECT
			DISTINCT c.CustomerId AS CustId,
			c.FirstName AS FName,
			c.LastName AS LName,
			i.InvoiceId AS InId,
			i.Total AS Total,
			c.LastName || ', ' || c.FirstName AS FullName,
			COUNT(il.Quantity) AS Items
		FROM
			Customer c
			JOIN Invoice i ON c.CustomerId = i.CustomerId
			JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
		GROUP BY
			1,
			2,
			3,
			4,
			5,
			6
		ORDER BY
			1
	) t1
GROUP BY
	1,
	2
ORDER BY
	4 DESC;