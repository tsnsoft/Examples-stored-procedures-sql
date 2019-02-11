USE [LIMS_PNHZ_PROD]
GO
/****** Object:  StoredProcedure [dbo].[LastLabDensityValueByKP_KR]    Script Date: 03/06/2015 16:53:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[LastLabDensityValueByKP_KR] (@kp varchar(2), @kr varchar(2),@dateTime datetime=null, @isVeryAccuratelyByTime bit=0)
as
begin
	
	if @dateTime is null 
	begin
		set @dateTime=GETDATE()
	end

	if @isVeryAccuratelyByTime=0
	begin
		select top 1 dt,value 
		from X_LAST_VALUE_OF_LAB_DENSITY 
		where kp=@kp and kr=@kr
	end
	else
	begin	
		select top 1 SAMPLED_DATE as dt,NUMERIC_ENTRY 
		from LabDensityValueInTank 
		where kp=@kp and kr=@kr and SAMPLED_DATE<=@dateTime
		order by SAMPLED_DATE desc
	end
end