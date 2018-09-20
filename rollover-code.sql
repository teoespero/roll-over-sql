-- Process PayrollRun
Declare @PrevFiscalYear INT
Declare @NewFiscalYear INT

SET @PrevFiscalYear = 2018
SET @NewFiscalYear = 2019

select
	null as PayrollID,
	PayrollRunTypeId,
	(replace([Description], cast(substring([Description], PatIndex('%[0-9]%', [Description]), 4) as int), cast(substring([Description], PatIndex('%[0-9]%', [Description]), 4) as int) + 1)) as [Description],
	dateadd(year,1,DateToBePrinted) as DateToBePrinted,
	null as DateRun,
	null as DateClosed,
	dateadd(year,1,StartDate) as StartDate,
	dateadd(year,1,EndDate) as EndDate,
	CompFilterID as CompFilterID,
    TimeSheetFilterID as TimeSheetFilterID,
    DeductionFilterID as DeductionFilterID,
    TemplateDeductionFilterID as TemplateDeductionFilterID,
    Null as GenerateBegin,
    Null as GenerateEnd,
    PayrollProfileId as PayrollProfileId
into #temp
from PayrollRun
where
	PayrollId in (
		select
			PayrollID
		from tblPayroll
		where
			FiscalYear = @PrevFiscalYear
	)


-- Process PayrollRun
Declare @newFY INT

SET @newFY = 2019

update #temp
	set
		PayrollID = pr.PayrollID
from #temp tmp
inner join
	tblPayroll pr
	on tmp.[Description] like '%'+pr.PayPeriod+'%'
	and pr.FiscalYear = @newFY



Declare @PrevFiscalYear INT
Declare @NewFiscalYear INT

SET @PrevFiscalYear = 2018
SET @NewFiscalYear = 2019

Insert into PayrollRun(
        PayrollID,
        PayrollRunTypeID,
        [Description],
        DateTobePrinted,
        DateRun,
        DateClosed,
        StartDate,
        EndDate,
        CompFilterID,
        TimeSheetFilterID,
        DeductionFilterID,
        TemplateDeductionFilterID,
        GenerateBegin,
        GenerateEnd,
        PayrollProfileId
    )
select
        te.PayrollID,
        te.PayrollRunTypeID,
        te.[Description],
        te.DateTobePrinted,
        te.DateRun,
        te.DateClosed,
        te.StartDate,
        te.EndDate,
        te.CompFilterID,
        te.TimeSheetFilterID,
        te.DeductionFilterID,
        te.TemplateDeductionFilterID,
        te.GenerateBegin,
        te.GenerateEnd,
        te.PayrollProfileId
from #TEMP te

drop table #temp
