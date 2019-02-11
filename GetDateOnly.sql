USE [DISP]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDateOnly]    Script Date: 03/06/2015 16:55:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[GetDateOnly]
(
	@date as datetime
)
RETURNS datetime
AS
BEGIN
	declare @year as nvarchar(4) 
	declare @month as nvarchar(2) 
	declare @day as nvarchar(2)

	set @year=ltrim(rtrim(str(datepart(year,@date))))
	set @month=ltrim(rtrim(str(datepart(month,@date))))
	set @day=ltrim(rtrim(str(datepart(day,@date))))

	return convert(datetime,@year +'-'+@month+'-'+@day+' 00:00:00',120)

END
