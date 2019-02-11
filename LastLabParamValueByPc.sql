USE [LIMS_PNHZ_PROD]
GO
/****** Object:  StoredProcedure [dbo].[LastLabParamValueByPc]    Script Date: 03/06/2015 16:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LastLabParamValueByPc] (@pc int,@dateTime dateTime=null, @isVeryAccuratelyByTime bit=0)
AS
BEGIN	
	if @dateTime is null 
	begin
		set @dateTime=GETDATE()
	end
	
	if @isVeryAccuratelyByTime=0
	begin
		select top 1 dt,value 
		from X_LAST_VALUE_OF_LAB_DENSITY 
		where pc=@pc
	end
	else
	begin
		select top 1 SAMPLED_DATE as dt,NUMERIC_ENTRY as value
		from LabParamValue
		where pc=@pc and SAMPLED_DATE <=@dateTime
		order by SAMPLED_DATE DESC
	end
END
