Report 50095 "Zyxel Employee Reminder E-mail"
{
    // 001. 15-01-19 ZY-LD 2018111310000046 - E-mailing reminders for probation review meeting and leaving Zyxel.
    // 002. 18-09-19 ZY-LD 2019082810000121 - Long Service Anniversary.
    // 003. 17-08-20 ZY-LD 2020052210000027 - Filter on "Long Service Anniversary".

    Caption = 'Zyxel Employee Reminder E-mail';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Loop; "Integer")
        {
            DataItemTableView = where(Number = filter(1 ..));
            MaxIteration = 3;
            dataitem("ZyXEL Employee"; "ZyXEL Employee")
            {
                DataItemTableView = where("Active employee" = const(true));
                RequestFilterFields = "No.";

                trigger OnAfterGetRecord()
                begin
                    Clear("ZyXEL Employee"."Manager No.");
                    recHrHistory.SetRange("Employee No.", "ZyXEL Employee"."No.");
                    recHrHistory.SetFilter("Start Date", '..%1', Today);
                    if recHrHistory.FindLast then
                        "ZyXEL Employee"."Manager No." := recHrHistory."Line Manager";

                    if not recEmpManager.Get("ZyXEL Employee"."Manager No.") then
                        Clear(recEmpManager);
                    SI.SetMergefield(100, "ZyXEL Employee".FullName);
                    SI.SetMergefield(102, recEmpManager."Full Name");

                    case Loop.Number of
                        1:
                            begin
                                SI.SetMergefield(101, Format("ZyXEL Employee"."Probation Review Meeting"));
                                EmailAddMgt.CreateSimpleEmail(recHrSetup."Probation E-mail Code", '', recEmpManager."ZyXEL Email Address");
                                //      EmailAddMgt.CreateSimpleEmail(recHrSetup."Probation E-mail Code",'','');
                                EmailAddMgt.Send;
                            end;
                        2:
                            begin
                                SI.SetMergefield(101, Format("ZyXEL Employee"."Leaving Date"));
                                EmailAddMgt.CreateSimpleEmail(recHrSetup."Leaving E-mail Code", '', recEmpManager."ZyXEL Email Address");
                                //      EmailAddMgt.CreateSimpleEmail(recHrSetup."Leaving E-mail Code",'','');
                                EmailAddMgt.Send;
                            end;
                        3:
                            begin
                                //>> 18-09-19 ZY-LD 002
                                if "ZyXEL Employee"."Employment Date" <> 0D then
                                    if (CalcDate('<10Y-1M>', "ZyXEL Employee"."Employment Date") = Today) or
                                       (CalcDate('<15Y-1M>', "ZyXEL Employee"."Employment Date") = Today) or
                                       (CalcDate('<20Y-1M>', "ZyXEL Employee"."Employment Date") = Today) or
                                       (CalcDate('<25Y-1M>', "ZyXEL Employee"."Employment Date") = Today) or
                                       (CalcDate('<30Y-1M>', "ZyXEL Employee"."Employment Date") = Today)
                                    then begin
                                        SI.SetMergefield(101, Format("ZyXEL Employee"."Employment Date"));
                                        AnniversaryDate := CalcDate('<1M>', Today);
                                        SI.SetMergefield(103, Format(AnniversaryDate));
                                        SI.SetMergefield(104, Format(Date2dmy(Today, 3) - Date2dmy("ZyXEL Employee"."Employment Date", 3)));
                                        EmailAddMgt.CreateSimpleEmail(recHrSetup."Long Service Ann. E-mail Code", '', '');
                                        EmailAddMgt.Send;
                                    end;
                                //<< 18-09-19 ZY-LD 002
                            end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    recHrSetup.Get;

                    "ZyXEL Employee".Reset;
                    case Loop.Number of
                        1:
                            begin
                                "ZyXEL Employee".SetFilter("ZyXEL Employee"."Probation Review Meeting", '%1|%2', CalcDate(recHrSetup."Probation Reminder", Today), CalcDate(recHrSetup."Probation Reminder 2", Today));
                                "ZyXEL Employee".SetRange("ZyXEL Employee"."Probation Passed", false);
                            end;
                        2:
                            "ZyXEL Employee".SetFilter("ZyXEL Employee"."Leaving Date", '%1|%2', CalcDate(recHrSetup."Leaving Reminder", Today), CalcDate(recHrSetup."Leaving Reminder 2", Today));
                        3:
                            "ZyXEL Employee".SetFilter("ZyXEL Employee"."Leaving Date", '%1..|%2', Today, 0D);  // 17-08-20 ZY-LD 003
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50095, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        recEmpManager: Record "ZyXEL Employee";
        recHrSetup: Record "Zyxel HR Setup";
        recHrHistory: Record "HR Role History";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        ZyHrMgt: Codeunit "ZyXEL HR Module";
        EmailText: Text;
        AnniversaryDate: Date;
}
