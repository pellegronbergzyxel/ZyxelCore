XmlPort 50061 "Read Stock Correction"
{
    Caption = 'Read Stock Correction';

    schema
    {
        tableelement("Whse. Stock Corr. Led. Entry"; "Whse. Stock Corr. Led. Entry")
        {
            XmlName = 'StockCorrectionNotification';
            fieldelement(MessageNo; "Whse. Stock Corr. Led. Entry"."Message No.")
            {
            }
            fieldelement(CustomerMessageNo; "Whse. Stock Corr. Led. Entry"."Customer Message No.")
            {
                MinOccurs = Zero;
            }
            fieldelement(Project; "Whse. Stock Corr. Led. Entry".Project)
            {
                MinOccurs = Zero;
            }
            fieldelement(CostCenter; "Whse. Stock Corr. Led. Entry"."Cost Center")
            {
                MinOccurs = Zero;
            }
            textelement(PostingType)
            {

                trigger OnAfterAssignVariable()
                begin
                    case UpperCase(PostingType) of
                        'CORRECTION':
                            "Whse. Stock Corr. Led. Entry"."Posting Type" := "Whse. Stock Corr. Led. Entry"."posting type"::Correction;
                        'MOVE':
                            "Whse. Stock Corr. Led. Entry"."Posting Type" := "Whse. Stock Corr. Led. Entry"."posting type"::Move;
                        else
                            Error(Text001);

                    end;
                end;
            }
            fieldelement(ReasonCode; "Whse. Stock Corr. Led. Entry"."Reason Code")
            {
                FieldValidate = no;

                trigger OnAfterAssignField()
                var
                    recWhseReason: Record "Warehouse Reason Code";
                begin
                    if recWhseReason.Get("Whse. Stock Corr. Led. Entry"."Reason Code") then begin
                        recWhseReason.Code := "Whse. Stock Corr. Led. Entry"."Reason Code";
                        recWhseReason.Description := "Whse. Stock Corr. Led. Entry"."Reason Code";
                        recWhseReason.Insert(true);
                    end;
                end;
            }
            textelement(SystemDateTime)
            {

                trigger OnAfterAssignVariable()
                begin
                    "Whse. Stock Corr. Led. Entry"."System Date" := VCKComMgt.ConvertTextToDateTime(SystemDateTime);
                end;
            }
            fieldelement(Customer; "Whse. Stock Corr. Led. Entry".Customer)
            {
            }
            fieldelement(ItemNo; "Whse. Stock Corr. Led. Entry"."Item No.")
            {
            }
            fieldelement(ProductNo; "Whse. Stock Corr. Led. Entry"."Product No.")
            {
            }
            fieldelement(Description; "Whse. Stock Corr. Led. Entry".Description)
            {
            }
            fieldelement(Warehouse; "Whse. Stock Corr. Led. Entry".Warehouse)
            {
            }
            fieldelement(NewWarehouse; "Whse. Stock Corr. Led. Entry"."New Warehouse")
            {
                MinOccurs = Zero;
            }
            fieldelement(Location; "Whse. Stock Corr. Led. Entry".Location)
            {
            }
            fieldelement(NewLocation; "Whse. Stock Corr. Led. Entry"."New Location")
            {
                MinOccurs = Zero;
            }
            fieldelement(StockType; "Whse. Stock Corr. Led. Entry"."Stock Type")
            {
                MinOccurs = Zero;
            }
            fieldelement(NewStockType; "Whse. Stock Corr. Led. Entry"."New Stock Type")
            {
                MinOccurs = Zero;
            }
            fieldelement(Grade; "Whse. Stock Corr. Led. Entry".Grade)
            {
                MinOccurs = Zero;
            }
            fieldelement(NewGrade; "Whse. Stock Corr. Led. Entry"."New Grade")
            {
                MinOccurs = Zero;
            }
            fieldelement(Quantity; "Whse. Stock Corr. Led. Entry".Quantity)
            {
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

    var
        VCKComMgt: Codeunit "VCK Communication Management";
        gFileMgtEntryNo: Integer;
        Text001: label 'Unknown "Posting Type".';


    procedure Init(FileMgtEntryNo: Integer)
    begin
        gFileMgtEntryNo := FileMgtEntryNo;
    end;
}
