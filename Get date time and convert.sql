SELECT CONVERT(datetime, '2021-02-25 15:22:00');
--MY initial query, wrong because it's redundant, requests data that's already requested
SELECT CONVERT(varchar, GETDATE(), 23)
--Gets date for today 

SELECT CONVERT(varchar, GETDATE(), 21)
--Gets date/time

SELECT CONVERT(datetime, 'Feb 25 2021  3:22PM',21)
--Andrews correct query, 21 is identifier for date/time