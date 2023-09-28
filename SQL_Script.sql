SQL SCRIPT 
**********************************************************
-- Anonymous block
* Cannot be saved and are usually used to display statements on console
* have output and input parameters with arrows => to indicate if we pass values or ? to output to console
**********************************************************
Example 1:

do(in iv_status int => 1,
   out ot_tasks table (id int, title nvarchar(40)) => ?) 
begin
	ot_tasks = select id, title from tasks where status = :iv_status;
end;

-- Procedures
* Are reusable and stored in the catalog. Can be written either on SQLSCRIPT or R.
**********************************************************
Example 1:
create procedure parameter_test(
	in iv_project int,
	out ot_tasks tasks,
	out ot_status_text id_text,
	out ot_remaining_effort table(task int, remaining_effort int))
as begin
	ot_tasks = select * from tasks where project = :iv_project;
	ot_status_text = select id, status_text as text from status_text;
	ot_remaining_effort = select id as task, planned_effort - effort as remaining_effort
	                      from :ot_tasks;
end;

call parameter_test(2,?,?,?);

drop procedure parameter_test;

Example 2: with default values

create procedure default_values(
	in iv_max_id int default 486,
	in it_table tasks default tasks)
as begin
	select id, title from :it_table
	           where id between 480 and :iv_max_id;
end;

call default_values();

drop procedure default_values;

-- Generic parameters
* Only work with direct calls to console. Not within any other subroutines

Example 1:
**********************************************************
-- Generic parameters - Only works in SQLSCRIPT
create procedure add_column(
	in it_any TABLE(...),
	out ot_any TABLE(...))
as begin
	ot_any = select *, 'New' || id as new_col from :it_any as it;
end;

-- Only works to call for console, not within other subroutines
call add_column(tasks, ?);

Example 2:
**********************************************************
-- Calling procedures from another schema
-- Create procedure on schema MRG
create procedure task_selection(
	in iv_max_id int default 486,
	out ot_task_text table(id int, title nvarchar(40)))
as begin
	ot_task_text = select id, title from tasks where id between 480 and :iv_max_id;
end;

call task_selection(486,?);

-- Calling on schema DBADMIN
call mrg.task_selection(486, ?);

-- Calling by parameter (order independent)
call mrg.task_selection(
	iv_max_id => 486,
	ot_task_text => ?
);