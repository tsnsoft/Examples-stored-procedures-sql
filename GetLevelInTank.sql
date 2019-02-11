USE [DISP]
GO
/****** Object:  StoredProcedure [dbo].[GetLevelInTank]    Script Date: 03/06/2015 16:56:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[GetLevelInTank] (@parkCode char(2), @tankCode char(2), @dateTime DateTime = null)
as
begin
	if @dateTime is null 
	set @dateTime=dbo.GetDateOnly(getdate())
	 
	select a.level from PetrochemicalRemains a inner join SamplingPoint b on b.id=a.SamplingPointID
	where b.ParkCode=@parkCode and b.TankCode=@tankCode and a.Datetime=@dateTime
end