Report 50168 "Export Zyxel Employee"
{
    // 001. 08-03-18 ZY-LD 2018022310000213 - Created.
    // 002. 08-05-18 ZY-LD 2018050810000201 - Division and department is added to headcount list.
    // 003. 05-06-18 ZY-LD 2018060410000242 - New fields to head count.
    // 004. 21-08-18 ZY-LD 000 - Start date from history is changed to employment date.
    // 005. 23-08-18 ZY-LD 2018082210000133 - Education Level is added.
    // 006. 05-11-18 ZY-LD 2018102210000156 - Guaranteed Bonus is added.
    // 007. 26-02-19 ZY-LD 2019022610000055 - Employment Hours Type. is addes.
    // 008. 26-06-19 ZY-LD 2019062410000088 - Company Option.
    // 009. 13-09-19 ZY-LD 000 - Get Job Title and manager name
    // 010. 17-10-19 ZY-LD 2019101610000157 - Exclude from reports is added as a filter on Employee.
    // 011. 05-11-19 PAB 2019100410000036/2019110410000052 - Termination Dates
    // 012. 22-04-20 ZY-LD 2020042110000076 - Only calculate if filled.
    // 013. 28-09-20 ZY-LD 2020092810000045 - "Zyxel E-mail address" is added.

    ProcessingOnly = true;

    dataset
    {
        dataitem("ZyXEL Employee"; "ZyXEL Employee")
        {
            CalcFields = "Employment Hours Type";
            DataItemTableView = where("Exclude from Reports" = const(false));
            RequestFilterFields = "No.", "Company Option";
            dataitem(SalaryChange; "HR Salary Line")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Employee No.", "Valid From") order(descending);

                trigger OnAfterGetRecord()
                begin
                    recNextSalaryChange := SalaryChange;
                    if recNextSalaryChange.Next() = 0 then
                        Clear(recNextSalaryChange);

                    if Valid[1] <> 0D then
                        Valid[2] := Valid[1] - 1
                    else
                        Valid[2] := 0D;
                    Valid[1] := "Valid From";

                    Salary[1] := "Base Salary P.A.";
                    Salary[2] := recNextSalaryChange."Base Salary P.A.";

                    Commision[1] := "Commission Pay P.A.";
                    Commision[2] := recNextSalaryChange."Commission Pay P.A.";

                    Allowance[1] := "Car Allowance P.A.";
                    Allowance[2] := recNextSalaryChange."Car Allowance P.A.";

                    GuaranteedBonus[1] := SalaryChange."Gurantiedeed Bonus (Months)";  // 05-11-18 ZY-LD 006
                    GuaranteedBonus[2] := recNextSalaryChange."Gurantiedeed Bonus (Months)";  // 05-11-18 ZY-LD 006

                    MakeExcelLine_SalaryChange;
                end;

                trigger OnPreDataItem()
                var
                    VfStartDate: Date;
                begin
                    if ReportType < Reporttype::"Salary Change Period" then
                        CurrReport.Break();

                    SetFilter("Valid From", '..%1', "ZyXEL Employee".GetRangeMin("Date Filter") - 1);
                    if FindFirst then
                        VfStartDate := "Valid From";

                    SetRange("Valid From", VfStartDate, "ZyXEL Employee".GetRangemax("Date Filter"));

                    if (ReportType = Reporttype::"Salary Change Period") and (Count < 2) then
                        CurrReport.Break();

                    recNextSalaryChange.SetCurrentkey("Employee No.", "Valid From");
                    recNextSalaryChange.Ascending(false);
                    recNextSalaryChange.CopyFilters(SalaryChange);
                end;
            }
            dataitem(SalaryList; "HR Salary Line")
            {
                DataItemLink = "Employee No." = field("No."), "Valid From" = field("Date Filter");
                DataItemTableView = sorting("Employee No.", "Valid From") order(descending);
                MaxIteration = 1;

                trigger OnAfterGetRecord()
                begin
                    MakeExcelLine_SalaryList;
                end;

                trigger OnPreDataItem()
                begin
                    if ReportType <> Reporttype::"Salary List" then
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Salary);
                Clear(Valid);
                Clear(Allowance);
                Clear(Commision);

                GetJobTitle;  // 13-09-19 ZY-LD 009
                GetManager;  // 13-09-19 ZY-LD 009

                if ReportType = Reporttype::"Head Count" then begin
                    //>> 05-06-18 ZY-LD 003
                    Clear(recHROffices);
                    if Company <> '' then
                        recHROffices.Get(Company);

                    Clear(recCostType);
                    Clear(recHQEntExpRel);
                    if "Cost Type" <> '' then begin
                        if recCostType.Get("Cost Type") then
                            if not recHQEntExpRel.Get(recHROffices."HQ Entity", recCostType."HQ Expense Category") then;
                    end;
                    //<< 05-06-18 ZY-LD 003

                    MakeExcelLine_HeadCount;
                end;
            end;

            trigger OnPostDataItem()
            begin
                CreateExcelbook;
            end;

            trigger OnPreDataItem()
            begin
                case ReportType of
                    Reporttype::"Head Count":
                        MakeExcelHead_HeadCount;
                    Reporttype::"Salary List":
                        MakeExcelHead_SalaryList;
                    Reporttype::"Salary Change Period":
                        MakeExcelHead_SalaryChange;
                    Reporttype::"Salary Change Complete":
                        MakeExcelHead_SalaryChange;
                end;

                SetFilter("Date Filter History", '..%1', DateFilterHistoryEndDate);  // 26-02-19 ZY-LD 007
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ReportType; ReportType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Report Type';
                    }
                    field(DateFilterHistoryEndDate; DateFilterHistoryEndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Date Filter History End Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DateFilterHistoryEndDate = 0D then
                DateFilterHistoryEndDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50168, 3);  // 14-10-20 ZY-LD 000
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recNextSalaryChange: Record "HR Salary Line";
        recHROffices: Record "HR Offices";
        recCostType: Record "Cost Type Name";
        recHQEntExpRel: Record "HQ Entity Expense Relation";
        Salary: array[2] of Decimal;
        Valid: array[2] of Date;
        Commision: array[2] of Decimal;
        Allowance: array[2] of Decimal;
        Col: Integer;
        GuaranteedBonus: array[2] of Integer;
        ReportType: Option " ","Head Count","Salary List","Salary Change Period","Salary Change Complete";
        DateFilterHistoryEndDate: Date;
        Text002: label 'Months Since Leaving';
        Text003: label '6 Years From Leaving';
        SI: Codeunit "Single Instance";


    procedure MakeExcelHead_SalaryChange()
    var
        recSalesShipHead: Record "Sales Shipment Header";
        lText001: label 'Full Name';
        lText002: label ' To';
        lText003: label ' From';
        lText004: label 'Manager Full Name';
        lText005: label 'Employee ID';
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Cost Type"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Active employee"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText005, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText004, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Company Option"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 26-06-19 ZY-LD 008
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption(Company), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Employment Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Birth Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption(Gender), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption(Nationality), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Job Title"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Country/Region Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Valid From"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Valid To"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Base Salary P.A.") + lText002, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Base Salary P.A.") + lText003, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Commission Pay P.A.") + lText002, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Commission Pay P.A.") + lText003, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Car Allowance P.A.") + lText002, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Car Allowance P.A.") + lText003, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Gurantiedeed Bonus (Months)") + lText002, false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 05-11-18 ZY-LD 006
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Gurantiedeed Bonus (Months)") + lText003, false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 05-11-18 ZY-LD 006



        ExcelBuf.NewRow;
    end;


    procedure MakeExcelLine_SalaryChange()
    var
        recHrHist: Record "HR Role History";
    begin
        recHrHist.SetRange("Employee No.", "ZyXEL Employee"."No.");
        recHrHist.SetFilter("Start Date", '..%1', DateFilterHistoryEndDate);  // 13-09-19 ZY-LD 009
        recHrHist.SetAutocalcFields("Line Manager Name", "Vice President Name");
        if not recHrHist.FindLast then;

        ExcelBuf.AddColumn("ZyXEL Employee"."Cost Type", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Active employee", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."No.", false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("ZyXEL Employee".FullName, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Manager Fullname", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format("ZyXEL Employee"."Company Option"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 26-06-19 ZY-LD 008
        ExcelBuf.AddColumn("ZyXEL Employee".Company, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Employment Date", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Birth Date", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".Gender, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".Nationality, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Job Title", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Country/Region Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Valid[1], false, '', false, false, false, '', ExcelBuf."cell type"::Date);
        ExcelBuf.AddColumn(Valid[2], false, '', false, false, false, '', ExcelBuf."cell type"::Date);
        ExcelBuf.AddColumn(Salary[1], false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Salary[2], false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Commision[1], false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Commision[2], false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Allowance[1], false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Allowance[2], false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(GuaranteedBonus[1], false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(GuaranteedBonus[2], false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.NewRow;
    end;


    procedure MakeExcelHead_SalaryList()
    var
        recSalesShipHead: Record "Sales Shipment Header";
        recHrHist: Record "HR Role History";
        lText001: label 'Full Name';
        lText002: label ' To';
        lText003: label ' From';
        lText004: label 'Manager Full Name';
        lText005: label 'Employee ID';
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Cost Type"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Active employee"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText005, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText004, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recHrHist.FIELDCAPTION(Department), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  // 08-05-18 ZY-LD 002
        ExcelBuf.AddColumn(recHrHist.FIELDCAPTION(Division), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  // 08-05-18 ZY-LD 002
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Company Option"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 26-06-19 ZY-LD 008
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption(Company), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Employment Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Birth Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption(Gender), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption(Nationality), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Job Title"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Country/Region Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption(Currency), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Valid From"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Base Salary P.A."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Commission Pay P.A."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Car Allowance P.A."), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryChange.FieldCaption("Gurantiedeed Bonus (Months)"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 05-11-18 ZY-LD 006
        ExcelBuf.NewRow;
    end;


    procedure MakeExcelLine_SalaryList()
    var
        recHrHist: Record "HR Role History";
    begin
        recHrHist.SetRange("Employee No.", "ZyXEL Employee"."No.");
        recHrHist.SetFilter("Start Date", '..%1', DateFilterHistoryEndDate);  // 13-09-19 ZY-LD 009
        recHrHist.SetAutocalcFields("Line Manager Name", "Vice President Name");
        if not recHrHist.FindLast then;

        ExcelBuf.AddColumn("ZyXEL Employee"."Cost Type", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Active employee", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."No.", false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("ZyXEL Employee".FullName, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Manager Fullname", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recHrHist.Department, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  // 08-05-18 ZY-LD 002
        ExcelBuf.AddColumn(FORMAT(recHrHist.Division), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);  // 08-05-18 ZY-LD 002
        ExcelBuf.AddColumn(Format("ZyXEL Employee"."Company Option"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 26-06-19 ZY-LD 008
        ExcelBuf.AddColumn("ZyXEL Employee".Company, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Employment Date", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Birth Date", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".Gender, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".Nationality, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Job Title", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Country/Region Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryList.Currency, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(SalaryList."Valid From", false, '', false, false, false, '', ExcelBuf."cell type"::Date);
        ExcelBuf.AddColumn(SalaryList."Base Salary P.A.", false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(SalaryList."Commission Pay P.A.", false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(SalaryList."Car Allowance P.A.", false, '', false, false, false, '#,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(SalaryList."Gurantiedeed Bonus (Months)", false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 05-11-18 ZY-LD 006
        ExcelBuf.NewRow;
    end;


    procedure MakeExcelHead_HeadCount()
    var
        lText001: label 'Full Name';
        lText002: label 'Manager Name';
        recHrHist: Record "HR Role History";
        lText003: label 'Age';
        lText004: label 'Employee ID';
        lText005: label 'Start Date';
        lText006: label 'Birth Date';
        lText007: label 'Vicepresident Name';
        lText008: label 'Education Level';
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Cost Type"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText004, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText001, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Job Title"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Company Option"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 26-06-19 ZY-LD 008
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption(Company), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText002, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText007, false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recHrHist.FieldCaption(Department), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 08-05-18 ZY-LD 002
        ExcelBuf.AddColumn(recHrHist.FieldCaption(Division), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 08-05-18 ZY-LD 002
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Employment Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 21-08-18 ZY-LD 004
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Birth Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(lText003, false, '', true, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption(Gender), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Leaving Date"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Grounds for Term. Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Leaving Comments"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);


        ExcelBuf.AddColumn(Text002, false, '', true, false, false, '', ExcelBuf."cell type"::Text); // 05-11-19 PAB 010
        ExcelBuf.AddColumn(Text003, false, '', true, false, false, '', ExcelBuf."cell type"::Text); // 05-11-19 PAB 010


        //>> 05-06-18 ZY-LD 003
        ExcelBuf.AddColumn(recHROffices.FieldCaption("HQ Entity"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recHQEntExpRel.FieldCaption("HQ Department Code"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recCostType.FieldCaption("HQ Expense Category"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        //<< 05-06-18 ZY-LD 003
        ExcelBuf.AddColumn(lText008, false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 23-08-18 ZY-LD 005
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("Employment Hours Type"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 26-02-19 ZY-LD 007
        ExcelBuf.AddColumn("ZyXEL Employee".FieldCaption("ZyXEL Email Address"), false, '', true, false, false, '', ExcelBuf."cell type"::Text);  // 28-09-20 ZY-LD 013
        ExcelBuf.NewRow;
    end;


    procedure MakeExcelLine_HeadCount()
    var
        recHrHist: Record "HR Role History";
        ZyHrMgt: Codeunit "ZyXEL HR Module";
        LeavingDate: Date;
        MonthsSinceLeaving: Integer;
        SixYearsSinceLeaving: Date;
        Date: Record Date;
    begin
        recHrHist.SetCurrentkey("Employee No.", "Start Date");  // 08-05-18 ZY-LD 002
        recHrHist.SetRange("Employee No.", "ZyXEL Employee"."No.");
        recHrHist.SetFilter("Start Date", '..%1', DateFilterHistoryEndDate);  // 13-09-19 ZY-LD 009
        recHrHist.SetAutocalcFields("Line Manager Name", "Vice President Name");
        if not recHrHist.FindLast then;

        ExcelBuf.AddColumn("ZyXEL Employee"."Cost Type", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."No.", false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("ZyXEL Employee".FullName, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Job Title", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format("ZyXEL Employee"."Company Option"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 26-06-19 ZY-LD 008
        ExcelBuf.AddColumn("ZyXEL Employee".Company, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recHrHist."Line Manager Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recHrHist."Vice President Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recHrHist.Department, false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 08-05-18 ZY-LD 002
        ExcelBuf.AddColumn(Format(recHrHist.Division), false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 08-05-18 ZY-LD 002
        ExcelBuf.AddColumn("ZyXEL Employee"."Employment Date", false, '', false, false, false, '', ExcelBuf."cell type"::Date);  // 21-08-18 ZY-LD 004
        ExcelBuf.AddColumn("ZyXEL Employee"."Birth Date", false, '', false, false, false, '', ExcelBuf."cell type"::Date);
        ExcelBuf.AddColumn(ZyHrMgt.CalculateSinceToday("ZyXEL Employee"."Birth Date"), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("ZyXEL Employee".Gender, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Leaving Date", false, '', false, false, false, '', ExcelBuf."cell type"::Date);
        ExcelBuf.AddColumn("ZyXEL Employee"."Grounds for Term. Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("ZyXEL Employee"."Leaving Comments", false, '', false, false, false, '', ExcelBuf."cell type"::Text);

        // 05-11-19 PAB 010
        MonthsSinceLeaving := 0;
        SixYearsSinceLeaving := 0D;
        if not "ZyXEL Employee"."Active employee" then begin
            LeavingDate := "ZyXEL Employee"."Leaving Date";
            if (LeavingDate <> 0D) and (Today > LeavingDate) then begin
                Date.SetRange("Period Type", Date."period type"::Month);
                Date.SetRange("Period Start", LeavingDate, Today);
                MonthsSinceLeaving := Date.Count;
            end else
                MonthsSinceLeaving := 0;
            if LeavingDate <> 0D then  // 22-04-20 ZY-LD 012
                SixYearsSinceLeaving := CalcDate('<+6Y>', LeavingDate)
        end;
        ExcelBuf.AddColumn(MonthsSinceLeaving, false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(SixYearsSinceLeaving, false, '', false, false, false, '', ExcelBuf."cell type"::Date);

        //>> 05-06-18 ZY-LD 003
        ExcelBuf.AddColumn(recHROffices."HQ Entity", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recHQEntExpRel."HQ Department Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(recCostType."HQ Expense Category", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        //<< 05-06-18 ZY-LD 003
        ExcelBuf.AddColumn(GetEducationLevel("ZyXEL Employee"."No."), false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 23-08-18 ZY-LD 005
        ExcelBuf.AddColumn(Format("ZyXEL Employee"."Employment Hours Type"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 26-02-19 ZY-LD 007
        ExcelBuf.AddColumn("ZyXEL Employee"."ZyXEL Email Address", false, '', false, false, false, '', ExcelBuf."cell type"::Text);  // 28-09-20 ZY-LD 013
        ExcelBuf.NewRow;
    end;


    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBook('', "ZyXEL Employee".TableCaption);
        ExcelBuf.WriteSheet("ZyXEL Employee".TableCaption, CompanyName(), UserId());
        ExcelBuf.CloseBook;
        if GuiAllowed then begin
            ExcelBuf.OpenExcel;
        end;
    end;

    local procedure GetEducationLevel(pEmployeeNo: Code[20]) rValue: Text
    var
        recEmpQua: Record "Employee Qualification";
    begin
        //>> 23-08-18 ZY-LD 005
        recEmpQua.SetRange("Employee No.", pEmployeeNo);
        recEmpQua.SetFilter("Expiration Date", '%1|%2..', 0D, Today);
        if recEmpQua.FindSet then
            repeat
                if rValue = '' then
                    rValue := recEmpQua.Description
                else
                    rValue := rValue + '; ' + recEmpQua.Description;

                if recEmpQua.Type <> recEmpQua.Type::" " then
                    rValue := rValue + StrSubstNo(' (%1)', Format(recEmpQua.Type));
            until recEmpQua.Next() = 0;
        //<< 23-08-18 ZY-LD 005
    end;
}

