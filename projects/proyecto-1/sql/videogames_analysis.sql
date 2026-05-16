-- @label check
SELECT *
FROM videogames_final
LIMIT 100
;

-- Part 1: Market Context
-- Question 1: How many games does this dataset contain (after the cleaning)? What is the total volume of sales, both globally and by region?
-- @label total_info
SELECT
    COUNT(*) AS Total_Games,
    SUM(NA_Sales) AS Total_NA_Sales,
    SUM(EU_Sales) AS Total_EU_Sales,
    SUM(JP_Sales) AS Total_JP_Sales,
    SUM(Other_Sales) AS Total_Other_Sales,
    SUM(Global_Sales) AS Total_Global_Sales
FROM videogames_final
;

-- Results: "Total_Games","Total_NA_Sales","Total_EU_Sales","Total_JP_Sales","Total_Other_Sales","Total_Global_Sales"
-- 16712,4400.57,2424.13,1297.34,791.24,8917.52

-- Question 2: How has the industry evolved over time?
-- @label evolution_over_time
SELECT Year_of_Release, COUNT(*) AS Games_Released, SUM(Global_Sales) AS Total_Global_Sales
FROM videogames_final
WHERE Year_of_Release IS NOT NULL
GROUP BY Year_of_Release
ORDER BY Year_of_Release
;

-- The industry peaked in 2008 with the highest number of games released and the highest global sales. Up to then there was a steady growth in both the number of games released and global sales. After 2008, there was a decline in both metrics, with a significant drop in the number of games released in 2012 (the number of games was around half of the number released in 2011). It could be a thing of the dataset, but it could also be a real trend in the industry. It must be taken into account that the dataset only goes up to 2016, so games after 2008 may not have had enough time to accumulate sales, which could explain the decline in global sales after 2008. 

-- Question 3: Which are the most sold games in the dataset (adding up the sales of all platforms of each game)?
-- @label most_sold_games
SELECT Name, SUM(Global_Sales) AS Total_Global_Sales, RANK() OVER (ORDER BY SUM(Global_Sales) DESC) AS Sales_Rank
FROM videogames_final
GROUP BY Name
ORDER BY Total_Global_Sales DESC
LIMIT 20
;

-- Results: "Name","Total_Global_Sales"
--"Wii Sports",82.53
--"Grand Theft Auto V",56.57
--"Super Mario Bros.",45.31
--"Tetris",35.84
--"Mario Kart Wii",35.52
--"Wii Sports Resort",32.77
--"Pokemon Red/Pokemon Blue",31.37
--"Call of Duty: Black Ops",30.82
--"Call of Duty: Modern Warfare 3",30.59
--"New Super Mario Bros.",29.8
--Nintendo games, such as Wii Sports, Super Mario Bros., Mario Kart Wii and Wii Sports Resort, dominate the list of best-selling games, Pokemon Red/Pokemon Blue is also a Nintendo game, though Pokemon is less for family audiences than the others, and for more nerdy audiences. 
-- Tetris is an old game that was very popular in the past, but it is not an interesting game anymore.
-- Grand Theft Auto V is one of the most popular games in recent years. 
-- We also have two Call of Duty games in the top 10, which is a popular franchise among more mature audiences, though actually a lot of teenagers also play Call of Duty games.
-- Minecraft is the 20th best-selling game.

-- Question 4: Which is the most sold game each year?
-- @label top1_game_each_year
SELECT
    Year_of_Release,
    Name AS Most_sold_game
FROM (
    SELECT
        Year_of_Release,
        Name,
        Global_Sales,
        ROW_NUMBER() OVER (PARTITION BY Year_of_Release ORDER BY Global_Sales DESC) AS Rank_Within_Year
    FROM videogames_final
    WHERE Year_of_Release IS NOT NULL
)
WHERE Rank_Within_Year = 1
ORDER BY Year_of_Release
;

--1980-1995 — Nintendo's absolute dominance. Atari ushered in the era, then Nintendo took over. 
--1996-2000 — The Pokémon era. Pokémon won four out of five years, with Gran Turismo as the only exception. 
--2001-2004 — The PS2 bursts onto the scene with GTA and Gran Turismo, dethroning Nintendo. 
--2005-2010 — Nintendo returns with the Wii revolution: Wii Sports, Wii Fit, Mario Kart, Nintendogs. 
--2011-2016 — The era of shooters and established franchises. Call of Duty and GTA dominate.



-- Part 2: Structural factors of success

-- Question 1: Which genres are the most successful in terms of total sales, number of games and average sales per game?
-- @label genre_success
SELECT Genre, SUM(Global_Sales) AS Total_Global_Sales, COUNT(*) AS Number_of_Games, ROUND(AVG(Global_Sales), 3) AS Average_Global_Sales
FROM videogames_final
GROUP BY Genre
ORDER BY Average_Global_Sales DESC
;

-- The most successful genre in terms of average global sales are Platform, Shooter, Role-Playing, Racing, Spots, Fighting and Action, in that order. 
-- The genres with the most games are Action, Sports, Misc, Role-Playing, Shooter, Adventure, Racing and Platform, in that order.
-- The most successful genres in terms of total global sales are Action, Sports, Shooter, Role-Playing, Platform, Misc and Racing, in that order.
-- The conclusion is that the most successful genres in terms of average global sales are not the most successful genres in terms of total global sales, which means that the most successful genres in terms of average global sales are more niche genres, while the most successful genres in terms of total global sales are more mainstream genres. There might be a greater market opportunity in the more niche genres, as they have a higher average global sales, but we have to take into account that they also have a smaller market size, as they have a smaller number of games, so it might be more profitable to make a game in a more mainstream genre, as they have a larger market size. In the end, it depends on the size of the videogames company and the resources it has, as well as the specific game it wants to make, as some games might fit better in a more niche genre than in a more mainstream genre. A small company with limited resources might be better off making a game in a more niche genre, as it has a higher average global sales, therefore having a higher potential return on investment, while a big company with more resources might be better off making a game in a more mainstream genre, as it has a larger market size, therefore having a higher potential total global sales.

-- Question 2: Which platforms are the most successful in terms of total sales, number of games and average sales per game?
-- @label platform_success
SELECT Platform, SUM(Global_Sales) AS Total_Global_Sales, COUNT(*) AS Number_of_Games, ROUND(AVG(Global_Sales), 3) AS Average_Global_Sales
FROM videogames_final
GROUP BY Platform
ORDER BY Average_Global_Sales DESC
;
-- The most successful platform in terms of average global sales is GB, followed by NES, GEN, SNES, PS4, X360, 2600 and PS3, in that order. However, most of these platforms, except PS3 and X360, don't have a lot of games, so the average global sales of these platforms might be less reliable. Some of those platforms with a smaller number of games (GB, NES, GEN, SNES, 2600) are also older platforms. They developed in a time when the industry was smaller and there were less games, so it is not surprising that they have a higher average global sales, as they had less competition. PS4, on the other hand, is a more recent platform, so it also makes sense that it has a smaller number of games, since it has been in the market for less time. Its success in terms of average global sales, however, is impressive, and could be due to the exclusive games it has, as well as the fact that it is a more powerful platform than the previous generation of consoles, which allows for more ambitious and higher quality games, which in turn can lead to higher sales. 
-- The platforms with the most games are PS2, DS, PS3, Wii, X360, PSP, PS and PC, in that order. Among those, X360, PS3, Wii have the highest average global sales, PS and PS2 are in the middle, and DS, PSP and PC have the lowest average global sales.
-- The most successful platforms in terms of total global sales are PS2, X360, PS3, Wii, DS, PS and GBA, in that order.
-- The platforms with the highest average global sales are not the platforms with the highest total global sales. The platforms with the highest average global sales are older or newer platforms with a smaller number of games, at either a time when the industry was smaller or at a time when the platform has been in the market for less time but is innovative enough to have a high average global sales, while the platforms with the highest total global sales are neither too old nor too new, and therefore have a larger number of games, which allows them to have a higher total global sales. Among these more middle-aged platforms, which in general have more games, some are more successful than others in terms of average global sales, such as X360, PS3 and Wii, while others are less successful, such as the DS or PSP.
-- It seems that for a videogame company the more secure bet would be to make a game for a more middle-aged and home console platform (like PS3 and X360), rather than older platforms or handhelds lke the DS or PSP. Newer and succesful platforms like the PS4 could also be a good bet, since usually newer platforms end up replacing older platforms, specially if they are initially successful. They also have less competition in the early years, which can lead to higher average global sales. Overall, PS4 seems the most solid bet, as it is a newer platform with a high average global sales, but it is not too new, so it has already been in the market for some time and therefore we already know that it is not a one-hit-wonder platform, but a platform that has been able to maintain a high average global sales over time. 


-- Question 3: Which publishers are the most successful in terms of total sales, number of games and average sales per game?
-- @label publisher_success
SELECT Publisher, SUM(Global_Sales) AS Total_Global_Sales, COUNT(*) AS Number_of_Games, ROUND(AVG(Global_Sales), 3) AS Average_Global_Sales
FROM videogames_final
GROUP BY Publisher
ORDER BY Average_Global_Sales DESC
;
-- The most successful publisher in terms of average global sales is Palcom, followed by Red Orb, Nintendo, Arena Entertainment and other less known publishers, but these results might be less reliable, as these publishers have a smaller number of games. Among the more well-known publishers, Nintendo is the most successful in terms of average global sales, followed by Sony Computer Entertainment and Microsoft Game Studios, in that order. 
-- The publishers with the most games are Electronic Arts, Activision, Namco Bandai Games, Ubisoft, Konami Digital Entertainment, Nintendo and Sony Computer Entertainment, in that order. Among these publishers with a larger number of games, Nintendo is the most successful in terms of average global sales. Electronic Arts, Activision and Sony Computer Entertainment have a similar average global sales, while Namco Bandai Games, Ubisoft, Konami Digital Entertainment and THQ have the smallest average global sales among the publishers with a larger number of games.
-- The most successful publishers in terms of total global sales are Nintendo, Electronic Arts, Activision, Sony Computer Entertainment, Ubisoft, Take-Two Interactive and THQ, in that order.
-- Nintendo is clearly the most successful publisher taking into account both total global sales and average global sales, while the rest of the publishers have a lower average global sales or a greatly inferior number of games. Electronic Arts, Activision and Sony Computer Entertainment are also successful publishers, with a good balance between average global sales and number of games, while the rest of the publishers have a lower average global sales or a greatly inferior number of games. For a videogame company, it would be interesting to analyze the strategies of Nintendo, as it is the most successful publisher by far, and try to learn from them, as well as to analyze the strategies of other successful publishers such as Electronic Arts, Activision and Sony Computer Entertainment. It would also be interesting to analyze the strategies of less successful publishers to see what they are doing wrong and how they could improve.

-- Question 4: Is there a relationship between the critic score of a game and its sales?

-- @label critic_score_sales
SELECT
    Critic_Score,
    SUM(Global_Sales) AS Total_Global_Sales,
    COUNT(*) AS Number_of_Games,
    ROUND(AVG(Global_Sales), 3) AS Average_Global_Sales
FROM videogames_final
WHERE Critic_Score IS NOT NULL
GROUP BY Critic_Score
ORDER BY Critic_Score DESC
;

-- There is a positive relationship between the critic score of a game and its sales. The higher the critic score, the higher the total global sales and the average global sales. However, there are some exceptions to this trend, as some games with a high critic score have low sales and some games with a low critic score have high sales. The category with the greatest number of games is 70, followed by 70, 71, 75, 78 and 73 (it would be interesting to group the critic scores in ranges of 10 points to see if the relationship is clearer). The category with the highest total global sales is 80, followed by 76, 83, 84, 82 and 88. Seems like the range 70-80 is the one with the greatest number of games, 80-90 is the one with the highest total global sales and 90-100 is the one with the highest average global sales, but it would be interesting to group the critic scores in ranges of 10 points to see if this relationship is clearer.

-- Question 5: Is there a relationship between the critic score of a game and its sales? Now in ranges of 10 points.
-- @label critic_score_sales_ranges
SELECT
    CASE
        WHEN Critic_Score >= 90 THEN '90-100'
        WHEN Critic_Score >= 80 THEN '80-89'
        WHEN Critic_Score >= 70 THEN '70-79'
        WHEN Critic_Score >= 60 THEN '60-69'
        WHEN Critic_Score >= 50 THEN '50-59'
        ELSE '0-49'
    END AS Critic_Score_Range,
    SUM(Global_Sales) AS Total_Global_Sales,
    COUNT(*) AS Number_of_Games,
    ROUND(AVG(Global_Sales), 3) AS Average_Global_Sales
FROM videogames_final
WHERE Critic_Score IS NOT NULL
GROUP BY Critic_Score_Range
ORDER BY AVG(Global_Sales) DESC
;

-- Now the relationship between the critic score of a game and its sales is clearer. The higher the critic score range, the higher the average global sales. There is a great jump in average global sales from the 90-100 range to the 80-89 range, and from the 80-89 range to the 70-79 range, and from the 70-79 range to the 60-69 range, but there is a smaller jump from the 60-69 range to the 50-59 range and from the 50-59 range to the 0-49 range. 
-- The category with the greatest number of games is 70-79, followed by 60-69, 80-89, 50-59, 0-49 and 90-100. Therefore, it is rare to make a game with a critic score above 90, and it is more common to make a game with a critic score between 70 and 79 or between 60 and 69, or between 80 and 89.
-- Finally, the category with the highest total global sales is 80-89, followed by 70-79 and then 90-100. The three worst categories in terms of total global sales are 60-69, then 50-59 and then 0-49.
-- We can conclude that it is not profitable to make a game with a critic score below 70, and that it is very profitable to make a game with a critic score above 80, and especially above 90. However, being realistic, it is very difficult to make a game with a critic score above 90, and it is more common to make a game with a critic score between 70 and 79 or between 80 and 89, which are also profitable ranges. Therefore, the best strategy would be to try to make a game with a critic score above 80, but if that is not possible, it would be better to try to make a game with a critic score between 70 and 79 than to try to make a game with a critic score below 70. Quality matters.


-- Question 5: Is there a relationship between the user score of a game and its sales? In ranges of 0.5 points.
-- @label user_score_sales_ranges
SELECT
    CASE
        WHEN User_Score >= 9.6 THEN '9.6-10'
        WHEN User_Score >= 9.1 THEN '9.1-9.5'
        WHEN User_Score >= 8.6 THEN '8.6-9.0'
        WHEN User_Score >= 8.1 THEN '8.1-8.5'
        WHEN User_Score >= 7.6 THEN '7.6-8.0'
        WHEN User_Score >= 7.1 THEN '7.1-7.5'
        WHEN User_Score >= 6.6 THEN '6.6-7.0'
        WHEN User_Score >= 6.1 THEN '6.1-6.5'
        WHEN User_Score >= 5.6 THEN '5.6-6.0'
        WHEN User_Score >= 5.1 THEN '5.1-5.5'
    ELSE '0-5.0'
    END AS User_Score_Range,
    SUM(Global_Sales) AS Total_Global_Sales,
    COUNT(*) AS Number_of_Games,
    ROUND(AVG(Global_Sales), 3) AS Average_Global_Sales
FROM videogames_final
WHERE User_Score IS NOT NULL
GROUP BY User_Score_Range
ORDER BY Average_Global_Sales DESC
;

-- The results show something different from the critic score. The user score range with the highest average global sales is 8.6-9.0, followed by 9.1-9.5 and then 7.6-8.0, 8.2-8.5, 6.1-6.5... The 9.6-10 range is the last one in terms of average global sales, which is surprising, but it must be taken into account that there are only 3 games in that range, so the average global sales of that range is not very reliable. The average global sales in the 8.6-9.0 range is 1.051, while the average global sales in the 9.1-9.5 range is 1.044, so both are very close, but the 8.6-9.0 has far more games (858 games) than the 9.1-9.5 range (188). In gneral, taking into account the effect of having less games in the 9.1-10 games, we can say that there is a positive relationship between the user score of a game and its sales, but it is not as clear as the relationship between the critic score and sales. 

-- The category with the greatest number of games is 7.6-8.0, followed by 8.1-8.5, 7.1-7.5, 8.6-9.0, 6.6-7.0 and then 0-5.0. Therefore, it is more common to make a game with a user score between 7.6 and 8.0, or the ranges around that, with the closest ranges around that having more games than the more distant ranges. It is rare to make a game with a user score above 9.0, and it is also rare to make a game with a user score below 6.5.

-- Finally, the category with the highest total global sales is 7.6-8.0, followed by 8.1-8.5 and then 8.6-9.0. After that, we have 7.1-7.5, 6.6-7.0 and then 6.1-6.5. The three worst categories in terms of total global sales are 0-5.0, then 5.6-6.0 and the worst is 9.6-10. It seems that the optimal value here is somewhere between 7.6 and 9.0, we can say around 8.3, where the greater average global sales meets the higher probability of making a game with a user score around 7.6-8.5. However, it is important to note that the user score is more volatile and less reliable than the critic score, as it can be influenced by many factors such as marketing, hype, fanbase, etc. Therefore, it would be better to focus on making a game with a high critic score than to focus on making a game with a high user score, though of course both are important.

-- In general, the patterns observed with the user score resemble the patterns observed with the critic score, but they are not exactly the same. For one, the 9.6-10 range is the last one in terms of average global sales, and while the 9.1-9.5 range is the second one in terms of average global sales, the 8.6-9.0 range is the first one in terms of average global sales, which is different from the critic score where the 90-100 range was the first one in terms of average global sales and the 80-89 range was the second one in terms of average global sales. In both of them, we have that the ranges with the highest total sales are slightly lower than the ranges with the highest average sales, which the first having a sales distribution centered around the optimal range, and the second having a sales distribution more skewed towards the highest score ranges (but less clear cut in the case of the user score).


-- Part 3: Regional analysis
-- Question 1: Which genres produce the most sales? Are there any genres that are particularly successful in certain regions?
-- @label genre_sales
SELECT Genre,
    SUM(NA_Sales) AS Total_NA_Sales,
    SUM(EU_Sales) AS Total_EU_Sales,
    SUM(JP_Sales) AS Total_JP_Sales,
    SUM(Other_Sales) AS Total_Other_Sales,
    SUM(Global_Sales) AS Total_Global_Sales
FROM videogames_final
GROUP BY Genre
ORDER BY Total_Global_Sales DESC
;

-- Action and Sports are the most successful genres in terms of global sales, followed by Shooter and Role-Playing. The fifth most successful genre is Platform.
-- Action is the most successful genre in North America and Europe, while Role-Playing is the most successful genre in Japan.
-- Sports is the second most successful genre in North America and Europe, but in Japan action is the second most successful genre. 
-- The third most successful genre in North America and Europe is Shooter, while in Japan it is Sports.
-- The fourth most successful genre in North America and Japan is Platform and in Europe it is Racing.


-- Question 2: Which platforms produce the most sales? Are there any platforms that are particularly successful in certain regions?
-- @label platform_sales
SELECT Platform,
    SUM(NA_Sales) AS Total_NA_Sales,
    SUM(EU_Sales) AS Total_EU_Sales,
    SUM(JP_Sales) AS Total_JP_Sales,
    SUM(Other_Sales) AS Total_Other_Sales,
    SUM(Global_Sales) AS Total_Global_Sales
FROM videogames_final
GROUP BY Platform
ORDER BY Total_Global_Sales DESC
;

-- The top 6 platforms in terms of global sales are PS2, X360, PS3, Wii, DS and PS (in that order)
-- In North America, the top 6 platforms are X360, PS2, Wii, PS3, DS and PS (in that order)
-- In Europe, the top 6 platforms are PS2, PS3, X360, Wii, PS and DS (in that order)
-- In Japan, the top 6 platforms are DS, PS, PS2, SNES, 3DS and NES (in that order). Clearly different from the other two in that the top 3 platforms are in the top 6 in the other two regions, but the rest of the platforms (SNES, 3DS and NES) are not in the top 6 of the other two regions. Also, in Japan the DS is the most successful platform, while in North America it is the fifth most successful platform and in Europe it is the sixth most successful platform. The PS2 is the most successful platform in Europe and the second most successful platform in North America and Japan, while the X360 is the most successful platform in North America and the third most successful platform in Europe, but it is not in the top 6 platforms in Japan. 


-- Question 3: Which publishers produce the most sales? Are there any publishers that are particularly successful in certain regions?
-- @label publisher_sales
SELECT Publisher,
    SUM(NA_Sales) AS Total_NA_Sales,
    SUM(EU_Sales) AS Total_EU_Sales,
    SUM(JP_Sales) AS Total_JP_Sales,
    SUM(Other_Sales) AS Total_Other_Sales,
    SUM(Global_Sales) AS Total_Global_Sales,
    RANK() OVER (ORDER BY SUM(Global_Sales) DESC) AS Sales_Rank
FROM videogames_final
GROUP BY Publisher
ORDER BY Total_Global_Sales DESC
LIMIT 20
;

-- The top 5 publishers in terms of global sales are Nintendo, Electronic Arts, Activision, Sony Computer Entertainment and Ubisoft (in that order).
-- In North America, the top 5 publishers are Nintendo, Electronic Arts, Activision, Sony Computer Entertainment and Ubisoft (in that order).
-- In Europe, it is the same as in North America.
-- In Japan, the top 5 publishers are Nintendo, Namco Bandai Games, Konami Digital Entertainment, Sony Computer Entertainment and Capcom (in that order). Nintendo is the most successful publisher in all regions, but the rest of the top 5 publishers are different in Japan compared to North America and Europe. 

-- Question 4: Which regions produce the most sales? Both in total number and by percentage of global sales.
-- @label regional_sales
SELECT SUM(NA_Sales) AS Total_NA_Sales,
    SUM(EU_Sales) AS Total_EU_Sales,
    SUM(JP_Sales) AS Total_JP_Sales,
    SUM(Other_Sales) AS Total_Other_Sales,
    SUM(Global_Sales) AS Total_Global_Sales,
    round(SUM(NA_Sales)/SUM(Global_Sales)*100, 2) AS NA_Sales_Percentage,
    round(SUM(EU_Sales)/SUM(Global_Sales)*100, 2) AS EU_Sales_Percentage,
    round(SUM(JP_Sales)/SUM(Global_Sales)*100, 2) AS JP_Sales_Percentage,
    round(SUM(Other_Sales)/SUM(Global_Sales)*100, 2) AS Other_Sales_Percentage
FROM videogames_final
;

-- Clearly, the most important region in terms of sales is North America, having 49.35% of global sales, followed by Europe with 27.18% of global sales, then Japan with 14.55% of global sales and finally the rest of the world with 8.88% of global sales. Therefore, for a video game company, it is crucial to focus on the North American market, as it is the largest market in terms of sales, but also not to forget about the European and Japanese markets, as they also represent a significant portion of global sales. The rest of the world is less important in terms of sales, but it can still be a good market to target for some games, especially if they have a more global appeal.


-- Question 5: Which are the most succesful games in each region? Are there any games that are particularly successful in certain regions?
-- @label most_successful_games_by_region
SELECT Name, 
    RANK() OVER (ORDER BY SUM(NA_Sales) DESC) AS NA_Sales_Rank,
    RANK() OVER (ORDER BY SUM(EU_Sales) DESC) AS EU_Sales_Rank,
    RANK() OVER (ORDER BY SUM(JP_Sales) DESC) AS JP_Sales_Rank,
    RANK() OVER (ORDER BY SUM(Global_Sales) DESC) AS Global_Sales_Rank
FROM videogames_final
GROUP BY Name
ORDER BY Global_Sales_Rank
;

-- The top 6 games in North America are Wii Sports, Super Mario Bros., Duck Hunt, tetris, Grand Theft Auto V and Call of Duty: Black Ops (in that order). 
-- The top 6 games in Europe are Wii Sports, Grand Theft Auto V, Mario Kart Wii, FIFA 15, Call of Duty: Modern Warfare 3 and FIFA 16 (in that order).
-- The top 6 games in Japan are Pokemon Red/Pokemon Blue, Pokemon Gold/Pokemon Silver, Super Mario Bros, New Super Mario Bros., Tetris and Pokemon Diamond/Pokemon Pearl (in that order).
-- The top 6 games in global sales are Wii Sports, Grand Theft Auto V, Super Mario Bros., Tetris, Mario Kart Wii and Wii Sports Resort (in that order).
-- Japan seems to prefer Nintendo games, especially Pokemon and Mario games, while North America and Europe have a more diverse top 6, with some Nintendo games, mainly Wii Sports, but also games from other publishers such as Grand Theft Auto V, Call of Duty: Black Ops, FIFA 15 and FIFA 16. Call of Duty and GTA games have a strong presence in North America and Europe, but not in Japan. FIFA games have a strong presence in Europe, but not in North America or Japan. Old games sucha as Tetris or Super Mario Bros. have a strong presence in in North America and Japan, but not in Europe, where the top 6 games are more recent games. This might be due to the fact that the market in Europe devoloped later than in North America and Japan, so the games that were successful in the early years of the industry are not as popular in Europe as they are in North America and Japan.


-- Part 4: Temporal analysis


--@label temporal_analysis
SELECT Year_of_Release, COUNT(*) AS Games_Released, ROUND(SUM(Global_Sales), 2) AS Total_Sales
FROM videogames_final
WHERE Year_of_Release IS NOT NULL
GROUP BY Year_of_Release
ORDER BY Year_of_Release
;

--Before 1994, each year we have too few games and (<100) and small total sales

-- Question 1: Which genres have grown or declined over time?
-- @label genre_evolution
SELECT 
    Year_of_Release,
    Genre,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales,
    ROUND(SUM(Global_Sales) * 100.0 / SUM(SUM(Global_Sales)) OVER (PARTITION BY Year_of_Release), 2) AS Pct_of_Year_Sales
FROM videogames_final
WHERE Year_of_Release IS NOT NULL
GROUP BY Year_of_Release, Genre
ORDER BY Year_of_Release, Total_Sales DESC
;

-- It would be better to graph these results

-- Question 2: Which platforms dominated in each era?
-- @label platform_dominance_by_era
SELECT
    CASE
        WHEN Year_of_Release BETWEEN 1980 AND 1989 THEN '1980s'
        WHEN Year_of_Release BETWEEN 1990 AND 1999 THEN '1990s'
        WHEN Year_of_Release BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN Year_of_Release BETWEEN 2010 AND 2016 THEN '2010s'
    END AS Era,
    Platform,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales,
    ROUND(SUM(Global_Sales) * 100.0 / SUM(SUM(Global_Sales)) OVER (PARTITION BY 
        CASE
            WHEN Year_of_Release BETWEEN 1980 AND 1989 THEN '1980s' --NES clearly dominates, then 2600 and GB   
            WHEN Year_of_Release BETWEEN 1990 AND 1999 THEN '1990s' --PS, then SNES, N64 and GB
            WHEN Year_of_Release BETWEEN 2000 AND 2009 THEN '2000s' --PS2, then DS abs Wii
            WHEN Year_of_Release BETWEEN 2010 AND 2016 THEN '2010s' --PS3 ans X360 (tie), then PS4 and 3DS
        END), 2) AS Pct_of_Era_Sales
FROM videogames_final
WHERE Year_of_Release IS NOT NULL
GROUP BY Era, Platform
ORDER BY Era, Total_Sales DESC
;


-- Part 5: Advanced Analysis

-- Question 1: Are there genres with high average sales but low total volume (or vice versa)?
-- @label genre_avg_vs_total
SELECT
    Genre,
    COUNT(*) AS Total_Games,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales,
    RANK() OVER (ORDER BY SUM(Global_Sales) DESC) AS Rank_By_Total,
    RANK() OVER (ORDER BY AVG(Global_Sales) DESC) AS Rank_By_Avg,
    RANK() OVER (ORDER BY SUM(Global_Sales) DESC) - 
    RANK() OVER (ORDER BY AVG(Global_Sales) DESC) AS Rank_Difference
FROM videogames_final
GROUP BY Genre
ORDER BY Rank_Difference DESC
;

-- Platform, Racing and Fighting have a far position in the average sales rank than in the total sales rank, with a rank difference of 4, 3 and 2 respectively.
-- These genre have a greater quality but a more concentrated market.
-- On the other hand, action, sports, Misc and Adventure; with a rank difference of -6, -3, -2 and -1 respectively, are the genres with a clearly better position in the total sales ranking than in the average sales ranking. Overcrowded genres with more mediocre games.
-- Lastly, Shooter, Role-Playingm Startegy, Simulation and Puzzle are the most balanced genres in this respect, having a rank difference of only +1 or 0.


-- Question 2: Do games with more critic reviews tend to sell more?
-- @label critic_count_vs_sales
SELECT
    CASE
        WHEN Critic_Count >= 40 THEN '40+ reviews'
        WHEN Critic_Count >= 20 THEN '20-39 reviews'
        WHEN Critic_Count >= 10 THEN '10-19 reviews'
        ELSE 'Under 10 reviews'
    END AS Critic_Count_Range,
    COUNT(*) AS Total_Games,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales,
    ROUND(AVG(Critic_Score), 1) AS Avg_Critic_Score
FROM videogames_final
WHERE Critic_Count IS NOT NULL
GROUP BY Critic_Count_Range
ORDER BY Avg_Sales DESC
;

-- Games with 40+ critic reviews average 1.548M in sales, nearly 6x more than games
-- with under 10 reviews (0.267M). Two explanations: (1) media coverage directly drives
-- sales, or (2) Critic_Count is a proxy for publisher size and marketing budget, which
-- are the real drivers. Both effects likely coexist. Note that Avg_Critic_Score also
-- increases with coverage, suggesting bigger publishers produce higher-quality games.


-- Question 3: Are there relevant discrepancies between critic and user scores, and do they affect sales?
-- @label critic_vs_user_discrepancy
SELECT
    CASE
        WHEN (Critic_Score - (User_Score * 10)) > 15 THEN 'Critics much higher'
        WHEN (Critic_Score - (User_Score * 10)) > 5  THEN 'Critics slightly higher'
        WHEN (Critic_Score - (User_Score * 10)) < -15 THEN 'Users much higher'
        WHEN (Critic_Score - (User_Score * 10)) < -5  THEN 'Users slightly higher'
        ELSE 'Agreement'
    END AS Discrepancy_Type,
    COUNT(*) AS Total_Games,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales,
    ROUND(SUM(Global_Sales), 3) Total_sales,
    ROUND(AVG(Critic_Score), 1) AS Avg_Critic_Score,
    ROUND(AVG(User_Score), 2) AS Avg_User_Score
FROM videogames_final
WHERE Critic_Score IS NOT NULL AND User_Score IS NOT NULL
GROUP BY Discrepancy_Type
ORDER BY Avg_Sales DESC
;

-- Critic scores are a stronger predictor of sales than user scores.
-- When critics rate higher than users, avg sales peak at 1.278M.
-- When users rate higher than critics, avg sales drop to 0.313M.
-- This is largely explained by Avg_Critic_Score, which drops from 76.8
-- to 55.9 as user enthusiasm exceeds critic enthusiasm — meaning "Users 
-- much higher" mostly captures games that critics disliked, which the
-- market then ignored regardless of user opinion.
-- Takeaway: for commercial success, critic reception matters more than
-- user reception.

-- INTERPRETATION NOTE: It may seem counterintuitive that critic scores predict sales
-- better than user scores, given that it is users who actually buy the games. However,
-- there are several plausible explanations:
--
-- (1) Temporal causality: critic reviews are published before or at launch, when most
--     sales occur. User scores come after, when the purchase decision has already been made.
--     Critics influence the buying decision; users evaluate it retrospectively.
--
-- (2) Selection bias: users who rate games on Metacritic tend to be the most dedicated
--     fans, who often defend their favourite games regardless of quality. This artificially
--     inflates User_Score for some titles, breaking the correlation with sales.
--
-- (3) Audience reach: a review on IGN or GameSpot reaches millions of undecided buyers.
--     A user rating on Metacritic mainly influences other fans of the genre, an already
--     committed audience.
--
-- (4) Publisher influence: big publishers send press copies, organise preview events and
--     maintain relationships with media outlets. User scores are much harder to influence
--     at scale.
--
-- This does not mean user opinion is irrelevant — it means users buy based on what critics
-- say, and then form their own opinion. They are two distinct moments in the process.

-- Question 4: Which publishers produce the highest quality games on average?
-- (Minimum 10 games with critic score to avoid small sample distortion)
-- @label publisher_quality
SELECT
    Publisher,
    COUNT(*) AS Total_Games,
    ROUND(AVG(Critic_Score), 1) AS Avg_Critic_Score,
    ROUND(AVG(User_Score), 2) AS Avg_User_Score,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales
FROM videogames_final
WHERE Critic_Score IS NOT NULL
GROUP BY Publisher
HAVING COUNT(*) >= 10
ORDER BY Avg_Critic_Score DESC
LIMIT 20
;

-- Nintendo stands out: not the highest critic score (75.5, rank 8) but by far
-- the highest avg sales per game (2.769M), suggesting brand loyalty and 
-- accessibility outweigh pure critical reception.
-- EA shows the opposite strategy: 1028 games (volume) but avg sales of 0.886M.
-- Bethesda is the outlier: low critic score (72.0) and lowest user score in
-- the top 20 (6.74), yet high avg sales (1.386M) — a loyal fanbase that buys
-- regardless of reviews.
-- MTV Games' position is surprising. Only 19 games, almost exclusively Guitar Hero and Rock Band, which back in its days were cultural phenomenons. High score but very niche markets.


-- Same query as before, but now with a minimum of 50 games by publisher:
-- @label publisher_quality2
SELECT
    Publisher,
    COUNT(*) AS Total_Games,
    ROUND(AVG(Critic_Score), 1) AS Avg_Critic_Score,
    ROUND(AVG(User_Score), 2) AS Avg_User_Score,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales
FROM videogames_final
WHERE Critic_Score IS NOT NULL
GROUP BY Publisher
HAVING COUNT(*) >= 50
ORDER BY Avg_Critic_Score DESC
LIMIT 20
;

-- The top three for consistent quality are Microsoft Game Studios, Nintendo, and Take-Two (Rockstar, 2K)—all three scoring above 75. Interestingly, all three also have average sales above 1 million, confirming the correlation between quality and sales at the publisher level. 
-- The big absentee is Activision — 569 games, 556M in total sales, but only a 69.7 average critics' score and the second lowest User_Score (6.88). Call of Duty sells hugely but drags the average down with many mediocre titles.
-- Ubisoft is the most interesting case at the bottom — 558 games, 68.5 critics' scores, low average sales (0.63M). A pure volume strategy that doesn't work in terms of either quality or average sales

-- Question 5: Which publishers achieve the best balance between quality and sales volume?
-- @label publisher_efficiency
SELECT
    Publisher,
    Total_Games,
    Avg_Critic_Score,
    Avg_Sales,
    ROUND(Avg_Critic_Score * Avg_Sales, 2) AS Quality_Sales_Index
FROM (
    SELECT
        Publisher,
        COUNT(*) AS Total_Games,
        ROUND(AVG(Critic_Score), 1) AS Avg_Critic_Score,
        ROUND(AVG(Global_Sales), 3) AS Avg_Sales
    FROM videogames_final
    WHERE Critic_Score IS NOT NULL
    GROUP BY Publisher
    HAVING COUNT(*) >= 50
)
ORDER BY Quality_Sales_Index DESC
LIMIT 10
;

-- Nintendo, Microsoft Game Studios, Bethesda, Take-Two Interactive and Sony Computer Entertainment have the best index.
-- Among those, Nintendo has the best sales by far. Bethesda Softworks has a better index than Take-Two Interactive and Sony Computer Entertainment despite having a lower critic score due to the higher sales.
-- LucasArts and Activision don't stand out in critic score (around 70 in both cases) but they compensate that withe average sales
-- EA and Square Enix have a relatively good critic score (around 75), but their index are dragged down by the sales.


-- Question 6: Which is the average sales per genre considering only the top 30 best-selling games of each genre?
-- @label genre_top30_avg
SELECT
    Genre,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales_Top30
FROM (
    SELECT
        Genre,
        Global_Sales,
        ROW_NUMBER() OVER (PARTITION BY Genre ORDER BY Global_Sales DESC) AS Rank_Within_Genre
    FROM videogames_final
)
WHERE Rank_Within_Genre <= 30
GROUP BY Genre
ORDER BY Avg_Sales_Top30 DESC
;

-- Compared to overall avg sales (all games), Platform rises from 4th to 1st,
-- and Action falls from 1st to 5th. This confirms that Action dominates by volume
-- but Platform has the highest ceiling — its best games (Mario, Donkey Kong)
-- outsell the best games of any other genre.
-- Strategy and Adventure have both low overall averages and low top-30 averages,
-- confirming they are structurally niche genres with limited commercial upside.
-- Popular shooter and sports games sell a lot, so the risk of investing in these genres could be worthy for great companies which can afford it.

-- Part 6: Rating Analysis

-- Question 1: How are games distributed across ratings?
-- @label rating_distribution
SELECT
    Rating,
    COUNT(*) AS Total_Games,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS Pct_of_Total
FROM videogames_final
WHERE Rating IS NOT NULL
GROUP BY Rating
ORDER BY Total_Games DESC
;

--Result: E dominates with 40%, then T (30%), M (16%), E10+ (14%). RP and AO negligible.

-- Question 2: Which ratings generate the most sales?
-- @label rating_vs_sales
SELECT
    Rating,
    COUNT(*) AS Total_Games,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales,
    ROUND(AVG(Global_Sales), 3) AS Avg_Sales
FROM videogames_final
WHERE Rating IS NOT NULL
GROUP BY Rating
ORDER BY Avg_Sales DESC
;

-- M-rated games have the highest avg sales (0.943M) despite being fewer in number,
-- driven by blockbuster franchises like GTA and Call of Duty.
-- E-rated games dominate total volume (2442M, 4000 games) combining mass-market
-- Nintendo titles with large amounts of lower-selling casual games, which pulls
-- the average down to 0.611M.
-- AO (1 game) and RP (3 games) are statistically irrelevant.
-- T and E10+ are neither the ratings with the best sales nor the rating withe best average sales. In fact, not taking into account the irrelevant data of AO and RP, they have both worst average sales. T total sales are better than M total sales, E10+ have the worst total sales (excluding RP).
-- Takeaway: mature content does not hurt commercial performance — in fact the
-- most commercially aggressive franchises are M-rated.

-- Question 3: Which genres are most associated with each rating?
-- @label genre_by_rating
SELECT
    Rating,
    Genre,
    COUNT(*) AS Total_Games,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales
FROM videogames_final
WHERE Rating IS NOT NULL
GROUP BY Rating, Genre
ORDER BY Rating, Total_Sales DESC
;

--E — Sports, Racing, Platform. The quintessential family catalog. 
--E10+ — Action dominates, which makes sense as an intermediate segment between E and T.
--T — The most diverse: Action, Role-Playing, Fighting, Shooter. The teen segment encompasses more genres. 
--M — Action and Shooter dominate almost everything. These genres feed off the mature ratings. 

-- Of the 4 rating categories, in 3 of them Action is the predominant genre, with E being the exception.

-- Note: Rating has a significant number of NULL values (~40% of total games), mostly older titles from platforms where ESRB classification was not yet widespread. All rating-based analysis excludes these records and should be interpreted with this limitation in mind.

-- Question 4: Which rating are most associated with each genre?
-- @label genre_by_rating
SELECT
    Genre,
    Rating,
    COUNT(*) AS Total_Games,
    ROUND(SUM(Global_Sales), 2) AS Total_Sales
FROM videogames_final
WHERE Rating IS NOT NULL
GROUP BY Genre, Rating
ORDER BY Genre, Total_Sales DESC
;