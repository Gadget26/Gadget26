USE [BillingRequest]
GO
/****** Object:  StoredProcedure [dbo].[usp_DataRequest_Log_Master]    Script Date: 6/10/2016 1:24:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
===================================================================================================
 Template by:      Matthew Erdmann
 Author:		Tarsheika West
 Description:   Dynamic Paging and Sorting Stored Procedure for generating Report Results

Steps
    1. Change Name of Stored Procedure
    2. Update Filter Parameters
    3. Update the @sort value to a valid field name in your query.
    4. Update the @sSelect statement
    5. 
===================================================================================================
*/

ALTER PROCEDURE [dbo].[usp_DataRequest_Log_Master]
(   @debug                  bit             = 0
-- filter parameters (Step 2)  //replace with filters
--,   @sysm               varchar(25)         = null
--,   @ad_id              varchar(25)         = null
--,   @emp_id             varchar(25)         = null
--,   @department         varchar(50)         = null
--,   @joblevel           varchar(50)         = null
--,   @phone              varchar(50)         = null
,	  @Size               varchar(50)          = null
,	  @Status             varchar(50)          = null
--,   @isActive           varchar(2)          = 'Y'

-- paging required parameters, do not touch!
,   @start                  int             = 1
,   @limit                  int             = 25
,   @sort                   varchar(max)    = 'Requested_ETA'
) AS
BEGIN
SET NOCOUNT ON;

-- ===========================================================================================================
-- Internal Variable Declarations and Variable Scrubbing (Shouldn't need to modify!)
-- ===========================================================================================================
declare 
    @sSQL varchar(max), @sCTETop varchar(max), @sCTEBottom varchar(max), @sPager varchar(max), 
    @sSelect varchar(max), @sFrom varchar(max), @sWhere varchar(max), @sGroupBy varchar(max),
    @sGrandTotal varchar(max), @ColumnCount int, @NullList varchar(max), @counter int,
    @dateColumn varchar(max)

set @sort = ltrim(rtrim(@sort));
set @counter = 0;

-- ===========================================================================================================
-- Variable Initialization and Config
-- ===========================================================================================================

if(@sort is null or @sort = '') 
begin
       print 'This query must have a valid @sort value.'
       return -1
end

-- ===========================================================================================================
-- Top of Query Section
-- ===========================================================================================================

set @sSelect = '
select
	[RequestID]
   ,[Date_Request_Recieved]
   ,[Requested_ETA]
   ,[BIA_Provided_ETA]
   ,[Size]
   ,[Completion_Date]
   ,[Status]
   ,[% Complete] AS P_Complete
   ,[BIA_Resource]
   ,[Requestor]
   ,[Requesting Group] AS Requesting_Group
   ,[Description]
   ,[On_Time]
   ,[Data_Source]
   ,[Division_Manager]
   ,[Activity]
   
'

-- ===========================================================================================================
-- FROM Section
-- ===========================================================================================================

set @sFrom = 'from
	(
		select *
		from [dbo].[DataRequest_Log_Master]
		WHERE [% Complete] < 100 OR [% Complete] IS NULL
	) AS DataRequest_Log_Master
     '

-- ===========================================================================================================
-- WHERE Section (aka Paramaters)
-- Examples:

-- ALL SUPPORT LISTS
-- fnColumnFilter
-- fnColumnFilter2 (with delimiter)
-- fnColumnStartWith
-- fnColumnContains

-- set @sWhere = @sWhere + biacore.fnColumnFilter('column_name', @param1) -- Add column filter, either single or list.
-- ===========================================================================================================
--replace with filter values
set @sWhere = 'Activity IS NULL AND
where 1=1 '

--set @sWhere = @sWhere + biacore.fnColumnFilter('isActive', @isActive)
--set @sWhere = @sWhere + biacore.fnColumnFilter('sysm', @sysm)
--set @sWhere = @sWhere + biacore.fnColumnFilter('ad_id', @ad_id)
--set @sWhere = @sWhere + biacore.fnColumnFilter('emp_id', @emp_id)
--set @sWhere = @sWhere + biacore.fnColumnFilter('department', @department)
--set @sWhere = @sWhere + biacore.fnColumnFilter('joblevel', @joblevel)
set @sWhere = @sWhere + biacore.fnColumnFilter('DataSize', @Size)
set @sWhere = @sWhere + biacore.fnColumnFilter('Status', @Status)
--set @sWhere = @sWhere + biacore.fnColumnFilter('phone', @phone)
--set @sWhere = @sWhere + biacore.fnColumnFilter('phone', @phone)
--set @sWhere = @sWhere + biacore.fnColumnFilter('phone', @phone)

-- ===========================================================================================================
-- GROUP BY Section (Leave empty/blank for no grouping!)
-- ===========================================================================================================

set @sGroupBy = '
'

-- ===========================================================================================================
-- Grand Total Section (Leave empty for no grand total!)
-- Make sure the number of columns matches the top query, use NULL's where aggregates do not apply.
-- ===========================================================================================================

set @sGrandTotal = 'NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL,
    NULL, Null, Null, Null
'

-- ===========================================================================================================
-- Provide the number of columns in the main query.
-- ===========================================================================================================

set @ColumnCount = 16;

-- ###########################################################################################################
-- Paging Section (Please do not modify below this section) Matthew Erdmann
-- ###########################################################################################################

set @sCTETop = 'with pager as (select row_number() over (order by ' + @sort + ') ROWNUMBER, x.* from ( '

set @sCTEBottom = '
) x )'

-- Over-ride @ColumnCoun when @sGrandTotal is provided.
set @sGrandTotal = ltrim(rtrim(@sGrandTotal));
if (@sGrandTotal != '') set @ColumnCount = 0;
set @NullList = '';

if (@start is null AND @limit is null)
    SET @sPager = '
select * from pager order by ROWNUMBER'
else
begin

    -- NullList is used in the dynamic query below to create the correct number of rows for a grand total line (after the union).
    -- In an aggregate query you may replace this section with sum to create a subtotal line.
    while (@counter < @ColumnCount)
    begin
        set @counter = @counter + 1;
        set @NullList = @NullList + 'NULL';
        if (@counter < @ColumnCount) set @NullList = @NullList + ',';
    end

    SET @sPager = '
select * from pager where ROWNUMBER > ' + cast(@start as varchar(6)) + ' and ROWNUMBER <= ' + cast(@start + @limit as varchar(6)) + '
union all
select count(ROWNUMBER) ROWNUMBER,' + @NullList + @sGrandTotal

    set @sPager = @sPager + ' from pager '
end

-- ###########################################################################################################
-- Build the complete SQL Statement
-- ###########################################################################################################

set @sSQL = @sCTETop + @sSelect + @sFrom + @sWhere + @sGroupBy + @sCTEBottom + @sPager

-- ###########################################################################################################
-- Debug Section - This will display the final SQL in the message section.
-- ###########################################################################################################

if (@debug = 1) print @sSQL

-- ###########################################################################################################
-- Final Execute
-- ###########################################################################################################

EXEC (@sSQL)

END