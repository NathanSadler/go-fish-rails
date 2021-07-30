SELECT
	users.id,
	users.name,
    COUNT(game_users) as played_games,
	COUNT(CASE WHEN game_users.is_game_winner THEN 1 END) as won_games,
    COUNT(game_users) - COUNT(CASE WHEN game_users.is_game_winner THEN 1 END) AS lost_games,
    SUM(games.finished_at - games.started_at) as game_time
    
FROM users
INNER JOIN game_users
	ON game_users.user_id = users.id
 INNER JOIN games
 	ON games.id = game_users.game_id
 GROUP BY users.name, users.id
ORDER BY won_games DESC