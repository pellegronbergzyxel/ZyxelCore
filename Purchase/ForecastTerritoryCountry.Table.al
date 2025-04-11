Table 50070 "Forecast Territory Country"
{
    // 001. 20-08-18 ZY-LD 2018081610000289 - New field.
    // 002. 23-03-20 ZY-LD 2020032310000065 - Update forecast territory on the customer.

    Caption = 'Forecast Territory Country';
    Description = 'Territory Countries';
    DrillDownPageID = "Forecast Territory Countries";
    LookupPageID = "Forecast Territory Countries";
    Permissions = TableData "Forecast Territory Country" = rimd;

    fields
    {
        field(1; "Forecast Territory Code"; Code[20])
        {
            Caption = 'Forecast Territory Code';
            Description = 'PAB 1.0';
            TableRelation = "Forecast Territory".Code;

            trigger OnValidate()
            begin
                //>> 23-03-20 ZY-LD 002
                recCust.SetRange("Territory Code", "Territory Code");
                GlobalFilter := "Division Code" + '*';
                recCust.SetFilter("Global Dimension 1 Code", GlobalFilter);
                if recCust.FindSet then
                    if Confirm(Text001, true, recCust.Count) then
                        repeat
                            recCust."Forecast Territory" := "Forecast Territory Code";
                            recCust.Modify(true);
                        until recCust.Next() = 0;
                //<< 23-03-20 ZY-LD 002
            end;
        }
        field(2; "Territory Code"; Code[20])
        {
            Caption = 'Territory Code';
            Description = 'PAB 1.0';
            TableRelation = Territory;
        }
        field(3; "Territory Name"; Text[50])
        {
            CalcFormula = lookup("Country/Region".Name where(Code = field("Territory Code")));
            Caption = 'Territory Name';
            Description = '20-08-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Division Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Division Code';
            Description = '20-08-18 ZY-LD 001';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
    }

    keys
    {
        key(Key1; "Territory Code", "Division Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recCust: Record Customer;
        GlobalFilter: Code[10];
        Text001: label 'Do you want to update "Forecast Territory" on %1 customer(s)?';
}
