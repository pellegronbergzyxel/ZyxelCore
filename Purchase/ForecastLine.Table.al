Table 62006 "Forecast Line"
{
    // 001.  DT1.01  01-07-2010  SH
    //  .Documention for tectura customasation
    //  .Object created

    DataCaptionFields = "Customer No. 2";

    fields
    {
        field(1; "Reference No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Line Number"; Integer)
        {
            Editable = false;
        }
        field(3; "Customer No."; Code[20])
        {
        }
        field(4; "Customer No. 2"; Code[20])
        {
        }
        field(11; "Org. FCST Date"; Date)
        {

            trigger OnValidate()
            begin
                //"Reference Date":=ForecastMgt.ReferenceDate("Org. FCST Date");
            end;
        }
        field(12; "Reference Date"; Date)
        {
            Editable = false;
        }
        field(21; "Item No."; Code[20])
        {
        }
        field(22; "Org. FCST Qty"; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                Quantity := "Org. FCST Qty" - "Qty on Consuming";
                if (Quantity < 0) then Quantity := 0;
            end;
        }
        field(23; Quantity; Decimal)
        {
            Caption = 'Net Forecast Quantity';
            Description = 'ZL100507A';
            Editable = false;
        }
        field(24; "Qty on Consuming"; Decimal)
        {
            CalcFormula = sum("Consuming Log"."Consuming Qty" where("Consuming Reference No." = field("Reference No."),
                                                                     "Consuming Line" = field("Line Number")));
            FieldClass = FlowField;
        }
        field(25; Active; Boolean)
        {
            Editable = false;
        }
        field(26; "Update Date"; Date)
        {
        }
        field(27; "Import By ID"; Code[20])
        {
        }
        field(28; "Pre-Quantity"; Decimal)
        {
        }
        field(29; Message; Text[250])
        {
        }
        field(30; "Upadte Time"; Time)
        {
            Editable = false;
        }
        field(50; Change; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Reference No.", "Line Number")
        {
            Clustered = true;
        }
        key(Key2; "Update Date", "Upadte Time")
        {
        }
        key(Key3; "Reference Date", "Customer No.", "Item No.", Active)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ForeLine: Record "Forecast Line";
    begin
        DistoryLine(Rec);
    end;

    trigger OnInsert()
    var
        ForeLine: Record "Forecast Line";
    begin
        if ("Reference No." <> '') and ("Line Number" = 0) then begin
            Clear(ForeLine);
            ForeLine.SetFilter("Reference No.", '%1', "Reference No.");
            if ForeLine.FindLast then begin
                "Line Number" := ForeLine."Line Number" + 10000;
            end else begin
                "Line Number" := 10000;
            end;
        end;
        CreateLine(Rec);
        Active := true;
        "Update Date" := Today;
        //Tectura Taiwan ZL100512B+
        "Upadte Time" := Time;
        //Tectura Taiwan ZL100512B-
        "Import By ID" := UserId;
        Change := true;
    end;

    trigger OnModify()
    begin
        if ("Item No." <> xRec."Item No.") or
           ("Reference Date" <> xRec."Reference Date") or
           ("Org. FCST Qty" <> xRec."Org. FCST Qty") then begin
            DistoryLine(xRec);
            CreateLine(Rec);
            Active := true;
        end;
        "Update Date" := Today;
        //Tectura Taiwan ZL100512B+
        "Upadte Time" := Time;
        //Tectura Taiwan ZL100512B-
        "Import By ID" := UserId;
        Change := true;
    end;


    procedure DistoryLine(OldForeLine: Record "Forecast Line")
    var
        ForeLine: Record "Forecast Line";
    begin
        Clear(ForeLine);
        ForeLine.SetFilter("Reference No.", '%1', OldForeLine."Reference No.");
        ForeLine.SetFilter("Reference Date", '%1', OldForeLine."Reference Date");
        ForeLine.SetFilter("Item No.", '%1', OldForeLine."Item No.");
        ForeLine.SetFilter(Active, '%1', false);
        if ForeLine.FindLast then begin
            ForeLine.Active := true;
            ForeLine.Modify;
        end;
    end;


    procedure CreateLine(var NewForeLine: Record "Forecast Line")
    var
        ForeLine: Record "Forecast Line";
    begin
        Clear(ForeLine);
        ForeLine.SetFilter("Reference No.", '%1', NewForeLine."Reference No.");
        ForeLine.SetFilter("Reference Date", '%1', NewForeLine."Reference Date");
        ForeLine.SetFilter("Item No.", '%1', NewForeLine."Item No.");
        ForeLine.SetFilter(Active, '%1', true);
        ForeLine.SetFilter("Line Number", '<>%1', NewForeLine."Line Number");
        if ForeLine.FindLast then begin
            NewForeLine."Pre-Quantity" := ForeLine."Org. FCST Qty";
        end;
        Clear(ForeLine);
        ForeLine.SetFilter("Reference No.", '%1', NewForeLine."Reference No.");
        ForeLine.SetFilter("Reference Date", '%1', NewForeLine."Reference Date");
        ForeLine.SetFilter("Item No.", '%1', NewForeLine."Item No.");
        ForeLine.SetFilter(Active, '%1', true);
        ForeLine.SetFilter("Line Number", '<>%1', NewForeLine."Line Number");
        ForeLine.ModifyAll(Active, false);
    end;
}
