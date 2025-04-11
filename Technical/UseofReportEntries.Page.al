Page 50063 "Use of Report Entries"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Use of Report Entries';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Use of Report Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Object Id"; Rec."Object Id")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Object Description 2"; Rec."Object Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Report Type"; Rec."Report Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Real Object Name"; Rec."Real Object Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {
            action(d)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Run';

                trigger OnAction()
                var
                    vDate: Date;
                    recCompany: Record Company;
                begin
                    begin
                        recUseOfReport2.SetCurrentkey("Company Name", "Object Type", "Object Id", "User Id", Month, Year);
                        recUseOfReport.SetAutocalcFields(recUseOfReport."Object Description");
                        recUseOfReport.FindLast;
                        recUseOfReport.SetRange(recUseOfReport."Entry No.", 0, recUseOfReport."Entry No.");
                        ZGT.OpenProgressWindow('', recUseOfReport.Count);
                        if recUseOfReport.FindSet then
                            repeat
                                ZGT.UpdateProgressWindow(Format(recUseOfReport."Entry No."), 0, true);

                                vDate := Dt2Date(recUseOfReport.Date);

                                recUseOfReport2.SetRange("Company Name", recUseOfReport."Company Name");
                                recUseOfReport2.SetRange("Object Type", recUseOfReport."Object Type");
                                recUseOfReport2.SetRange("Object Id", recUseOfReport."Object Id");
                                recUseOfReport2.SetRange("User Id", recUseOfReport."User Id");
                                recUseOfReport2.SetRange(Month, Date2dmy(vDate, 2));
                                recUseOfReport2.SetRange(Year, Date2dmy(vDate, 3));
                                if recUseOfReport2.FindFirst then begin
                                    recUseOfReport2.Quantity += 1;
                                    recUseOfReport2.Modify;
                                end else begin
                                    Clear(recUseOfReport2);
                                    recUseOfReport2.Reset;
                                    recUseOfReport2."Entry No." := 0;
                                    recUseOfReport2."Company Name" := recUseOfReport."Company Name";
                                    recUseOfReport2."Object Type" := recUseOfReport."Object Type";
                                    recUseOfReport2."Object Id" := recUseOfReport."Object Id";
                                    if recCompany.Get(recUseOfReport."Company Name") then
                                        recUseOfReport2."Object Description 2" := recUseOfReport."Object Description";
                                    recUseOfReport2."User Id" := recUseOfReport."User Id";
                                    recUseOfReport2."Report Type" := recUseOfReport."Report Type";
                                    recUseOfReport2.Month := Date2dmy(vDate, 2);
                                    recUseOfReport2.Year := Date2dmy(vDate, 3);
                                    recUseOfReport2.Quantity := 1;
                                    recUseOfReport2.Insert;
                                end;
                            until recUseOfReport.Next() = 0;
                    end;
                    ZGT.CloseProgressWindow;
                end;
            }
        }
    }

    var
        recUseOfReport: Record "Use of Report Entry";
        recUseOfReport2: Record "Use of Report Entry";
        ZGT: Codeunit "ZyXEL General Tools";
}
