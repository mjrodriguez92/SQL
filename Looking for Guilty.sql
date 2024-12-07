/*
select op.Category, op.[time], op.Operation, e.UserID, e.Firstname + ' ' + e.Lastname
  from fsOperationHistory op
  join ffemployee e on op.EmployeeID = e.ID
 where category = 'DataManager\BOMManager\ffProductStructure'
   and [Time] >= '2019-10-11 16:16:18.000'
 order by [Time] desc
*/

select op.Category, op.[time], op.Operation, e.UserID, e.Firstname + ' ' + e.Lastname
  from fsOperationHistory op
  join ffemployee e on op.EmployeeID = e.ID
 where [Time] >= '2019-10-17 10:00:00.000'
 order by [Time] desc

select *
  from ffActionLog 
 where [Time] >= '2019-10-17 10:00:00.000'
 order by [Time] desc


    

