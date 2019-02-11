USE [LIMS_PNHZ_PROD]
GO
/****** Object:  StoredProcedure [dbo].[RefreshTable_X_LAST_VALUE_OF_LAB_DENSITY]    Script Date: 03/06/2015 16:54:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[RefreshTable_X_LAST_VALUE_OF_LAB_DENSITY]
AS
BEGIN
	set nocount off
	
	declare @pc int
	
	IF OBJECT_ID(N'tempdb..#temp_table', N'U') IS NOT NULL 
	DROP TABLE #temp_table;

	create table #temp_table (
		pc int,
		kp nvarchar(2),
		kr nvarchar(10),
		dt datetime,
		value float
	)

	declare cursor1 cursor for 
		SELECT pc FROM X_ASSOCIATION 
		WHERE ANALYSIS LIKE 'ПЛОТ%' 
		GROUP BY pc
		order by pc

	open cursor1
	fetch next from cursor1 into @pc

	while @@FETCH_STATUS=0 
	begin

		insert into #temp_table select top 1 pc,null,null,SAMPLED_DATE,NUMERIC_ENTRY
		from LabParamValue
		where  pc=@pc
		order by SAMPLED_DATE DESC

		fetch next from cursor1 into @pc
	end 

	close cursor1
	deallocate cursor1
	print 'закончен шаг 1'
	
	declare @kp nvarchar(2), @kr nvarchar(10)
	
	declare cursor2 cursor for 	
		select ltrim(rtrim(X_CODE_STOCK)),ltrim(rtrim(X_CODE_VESSEL)) from SAMPLE 
		where ltrim(rtrim(X_CODE_STOCK)) like '%[0-9]%' and ltrim(rtrim(X_CODE_VESSEL)) like '%[0-9]%'
		group by ltrim(rtrim(X_CODE_STOCK)),ltrim(rtrim(X_CODE_VESSEL))
		order by ltrim(rtrim(X_CODE_STOCK)),ltrim(rtrim(X_CODE_VESSEL))

	open cursor2
	fetch next from cursor2 into @kp,@kr

	while @@FETCH_STATUS=0 
	begin

		insert into #temp_table select top 1 null,@kp,@kr,SAMPLED_DATE,NUMERIC_ENTRY
		from LabDensityValueInTank 
		where ANALYSIS like 'ПЛОТ%' and kp=@kp and kr=@kr
		order by SAMPLED_DATE DESC

		fetch next from cursor2 into @kp,@kr
	end 

	close cursor2
	deallocate cursor2
	print 'закончен шаг 2'
		
	begin transaction
	delete from X_LAST_VALUE_OF_LAB_DENSITY
	insert into X_LAST_VALUE_OF_LAB_DENSITY (pc,kp,kr,dt,value) select pc,kp,kr,dt,value from #temp_table
	commit transaction

	drop table #temp_table
	print 'закончен шаг 3'
END
