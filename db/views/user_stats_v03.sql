SELECT
	users.name,
	users.id AS user_id,
    COUNT(game_users) as played_games,
	COUNT(CASE WHEN game_users.is_game_winner THEN 1 END) as won_games,
    COUNT(game_users) - COUNT(CASE WHEN game_users.is_game_winner THEN 1 END) AS lost_games
FROM users
INNER JOIN game_users
	ON game_users.user_id = users.id
 GROUP BY users.name, users.id
ORDER BY won_games DESC