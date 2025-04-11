Report 50092 "Identify Identical Serial No."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Identify Identical Serial No..rdlc';
    Caption = 'Identify Identical Serial No.';

    dataset
    {
        dataitem("Ship Response Header"; "Ship Response Header")
        {
            RequestFilterFields = "No.";
            dataitem("Ship Response Line"; "Ship Response Line")
            {
                CalcFields = "No. of Serial No.";
                DataItemLink = "Response No." = field("No.");
                DataItemTableView = sorting("Response No.", "Response Line No.");
                dataitem("Ship Responce Serial Nos."; "Ship Responce Serial Nos.")
                {
                    CalcFields = "Identical Serial Numbers";
                    DataItemLink = "Response No." = field("Response No."), "Response Line No." = field("Response Line No.");
                    DataItemTableView = sorting("Response No.", "Response Line No.", "Serial No.");
                    column(DocumentNo; "Ship Responce Serial Nos."."Sales Order No.")
                    {
                    }
                    column(LineNo; "Ship Responce Serial Nos."."Sales Order Line No.")
                    {
                    }
                    column(ItemNo; "Ship Response Line"."Product No.")
                    {
                    }
                    column(Quantity; "Ship Response Line".Quantity)
                    {
                    }
                    column(NoOfSerialNo; "Ship Response Line"."No. of Serial No.")
                    {
                    }
                    column(Type; DifferenceType)
                    {
                    }
                    column(SerialNo; SerialNo)
                    {
                    }
                    column(NoOfIdentSerialNo; "Ship Responce Serial Nos."."Identical Serial Numbers")
                    {
                    }
                    column(Caption_DocumentNo; Text006)
                    {
                    }
                    column(Caption_LineNo; Text007)
                    {
                    }
                    column(Caption_ItemNo; "Ship Responce Serial Nos.".FieldCaption("Ship Responce Serial Nos."."Item No."))
                    {
                    }
                    column(Caption_Quantity; "Ship Response Line".FieldCaption(Quantity))
                    {
                    }
                    column(Caption_NoOfSerialNo; "Ship Response Line".FieldCaption("No. of Serial No."))
                    {
                    }
                    column(Caption_Type; Text003)
                    {
                    }
                    column(Caption_SerialNo; Text004)
                    {
                    }
                    column(Caption_NoOfIdentSerialNo; Text005)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        SerialNo := '';
                        if (("Ship Response Line".Quantity <> "Ship Response Line"."No. of Serial No.") and ("Ship Response Line"."Line No." <> PrevLineNo)) or
                            ("Ship Responce Serial Nos."."Identical Serial Numbers" > 1) or
                            ("Ship Responce Serial Nos."."Serial No." = "Ship Responce Serial Nos."."Item No.") or
                            (CopyStr("Ship Responce Serial Nos."."Serial No.", 1, 1) <> 'S')
                        then begin
                            if ("Ship Response Line".Quantity <> "Ship Response Line"."No. of Serial No.") and ("Ship Responce Serial Nos."."Identical Serial Numbers" > 1) then begin
                                DifferenceType := StrSubstNo('%1; %2', Text001, Text002);
                                SerialNo := "Ship Responce Serial Nos."."Serial No.";
                                DiffLocated := true;
                            end else
                                if "Ship Response Line".Quantity <> "Ship Response Line"."No. of Serial No." then begin
                                    DifferenceType := Text001;
                                    "Ship Responce Serial Nos."."Identical Serial Numbers" := 0;
                                    DiffLocated := true;
                                end else
                                    if "Ship Responce Serial Nos."."Identical Serial Numbers" > 1 then begin
                                        DifferenceType := Text002;
                                        SerialNo := "Ship Responce Serial Nos."."Serial No.";
                                        "Ship Response Line".Quantity := 0;
                                        "Ship Response Line"."No. of Serial No." := 0;
                                        DiffLocated := true;
                                    end else
                                        if "Ship Responce Serial Nos."."Serial No." = "Ship Responce Serial Nos."."Item No." then begin
                                            DifferenceType := Text008;
                                            SerialNo := "Ship Responce Serial Nos."."Serial No.";
                                        end else
                                            if (CopyStr("Ship Responce Serial Nos."."Serial No.", 1, 1) <> 'S') then begin
                                                DifferenceType := Text009;
                                                SerialNo := "Ship Responce Serial Nos."."Serial No.";
                                            end;


                            PrevLineNo := "Ship Responce Serial Nos."."Response Line No.";
                        end else begin
                            PrevLineNo := "Ship Responce Serial Nos."."Response Line No.";
                            CurrReport.Skip;
                        end;
                    end;
                }
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

    var
        DifferenceType: Text;
        PrevLineNo: Integer;
        SerialNo: Code[30];
        DiffLocated: Boolean;
        Text001: label 'Wrong number of serial numbers';
        Text002: label 'Identical serial number';
        Text003: label 'Text';
        Text004: label 'Serial No.';
        Text005: label 'No. of Itentical Serial No.';
        Text006: label 'Delivery Document No.';
        Text007: label 'Delivery Document Line No.';
        Text008: label 'Identical Serial- and Product No.';
        Text009: label 'Serial No. must begin with letter "S".';


    procedure DifferenceLocated(): Boolean
    begin
        exit(DiffLocated);
    end;
}
