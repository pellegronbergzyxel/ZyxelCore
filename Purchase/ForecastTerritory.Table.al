Table 50004 "Forecast Territory"
{
    // 001. 20-08-18 ZY-LD 2018082010000182 - New field.
    // 002. 19-11-19 ZY-LD P0332 - New field.

    Caption = 'Forecast Territory';
    DrillDownPageID = "Forecast Territory List";
    LookupPageID = "Forecast Territory List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            Description = 'PAB 1.0';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            Description = 'PAB 1.0';
        }
        field(11; "Show on Forecast List"; Boolean)
        {
            Caption = 'Show on Forecast List';
            Description = '20-08-18 ZY-LD 001';
        }
        field(12; "Calc. CH Forecast on Cust. No."; Boolean)
        {
            Caption = 'Calculate CH Forecast on Customer No.';
            Description = '20-08-18 ZY-LD 001';
        }
        field(13; "Automatic Invoice Handling"; Option)
        {
            Caption = 'Automatic Invoice Handling';
            Description = '19-11-19 ZY-LD 002';
            OptionMembers = " ","Create Invoice","Create and Post Invoice";

            trigger OnValidate()
            begin
                // 19-11-19 ZY-LD 002
                recCust.SetRange("Forecast Territory", Code);
                if Confirm(Text001, false, recCust.Count) then
                    if recCust.FindSet(true) then begin
                        ZGT.OpenProgressWindow('', recCust.Count);
                        repeat
                            ZGT.UpdateProgressWindow(recCust."No.", 0, true);

                            recCust."Automatic Invoice Handling" := "Automatic Invoice Handling";
                            recCust.Modify;
                        until recCust.Next() = 0;
                        ZGT.CloseProgressWindow;
                    end;
                // 19-11-19 ZY-LD 002
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recCust: Record Customer;
        Text001: label 'Do you want to update %1 customer(s)?';
        ZGT: Codeunit "ZyXEL General Tools";
}
