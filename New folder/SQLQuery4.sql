select e.EmployeeID,
       e.FirstName,
       e.LastName,
       count(o.OrderID) 'NumOrders'
from Employees e
    join Orders o
        on e.EmployeeID = o.EmployeeID
group by e.EmployeeID,
        e.FirstName,
        e.LastName
having count(o.OrderID) = 67

begin transaction
    declare @empId int
    set @empId = (    select e.EmployeeID           
                    from Employees e
                        join Orders o
                            on e.EmployeeID = o.EmployeeID
                    group by e.EmployeeID,
                           e.FirstName,
                           e.LastName
                    having count(o.OrderID) = 67)
    update Employees
    set FirstName = 'Monica', LastName = 'Bouche '
    where EmployeeID = @empId



select e.EmployeeID,
       e.FirstName,
       e.LastName,
       count(o.OrderID) 'NumOrders'
from Employees e
    join Orders o
        on e.EmployeeID = o.EmployeeID
group by e.EmployeeID,
        e.FirstName,
        e.LastName
order by 4 desc



rollback



select e.EmployeeID,
       e.FirstName,
       e.LastName,
       count(o.OrderID) 'NumOrders'
from Employees e
    join Orders o
        on e.EmployeeID = o.EmployeeID
group by e.EmployeeID,
        e.FirstName,
        e.LastName
order by 4 desc
