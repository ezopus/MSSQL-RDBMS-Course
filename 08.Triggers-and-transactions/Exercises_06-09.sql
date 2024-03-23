USE [Diablo]

GO

SELECT *
  FROM [Users] AS [u]
  JOIN [UserGameItems] AS [ugi] ON [ugi].UserGameId = [u].Id
 WHERE [Username] = 'Stamat'


 SELECT * FROM [UserGameItems]

 SELECT * FROM [UsersGames]

 SELECT * FROM [Games]