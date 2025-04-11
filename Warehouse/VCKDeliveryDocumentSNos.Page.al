Page 50089 "VCK Delivery Document SNos"
{
    // 001. 10-04-18 ZY-LD - 2018041010000351 - New fields.
    // 002. 18-10-18 ZY-LD - 2018101710000121 - New fields.
    // 003. 16-04-19 ZY-LD - P0218 - Test GetSerialNo.
    // 004. 18-11-19 ZY-LD - 000 - Print Serial No.

    ApplicationArea = Basic, Suite;
    Editable = false;
    PageType = List;
    SourceTable = "VCK Delivery Document SNos";
    SourceTableView = order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Delivery Document No."; Rec."Delivery Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delivery Document Line No."; Rec."Delivery Document Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Order No."; Rec."Customer Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Country Code"; Rec."Customer Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Forecast Territory"; Rec."Forecast Territory")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("DD Document Date"; Rec."DD Document Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pallet No."; Rec."Pallet No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Delete Marked Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete Marked Lines';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    recDelDocSerialNo: Record "VCK Delivery Document SNos";
                begin
                    CurrPage.SetSelectionFilter(recDelDocSerialNo);
                    if recDelDocSerialNo.FindSet(true) then
                        if Confirm(Text002, false, recDelDocSerialNo.Count, Rec."Delivery Document No.", Rec."Delivery Document Line No.") then
                            if Confirm(Text003) then
                                recDelDocSerialNo.DeleteAll(true);
                end;
            }
            action("Import Serial No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Serial No.';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Import Serial No.";
            }
            action("Import Pallet No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Pallet No.';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Clear(repImportPalletNo);
                    repImportPalletNo.Init(Rec."Delivery Document No.");
                    repImportPalletNo.RunModal;
                end;
            }
            action("Print Serial No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Serial No.';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    recDelDocNo.PrintSerialNo(Rec."Delivery Document No.");  // 18-11-19 ZY-LD 004
                end;
            }
        }
    }

    var
        Text001: label 'Do you want to "GetSerialNo"?';
        recDelDocNo: Record "VCK Delivery Document Header";
        ZyWebServReq: Codeunit "Zyxel HQ Web Service Request";
        repImportPalletNo: Report "Import Pallet No.";
        Text002: label 'Do you want to delete %1 serial number(s)?';
        Text003: label 'Are you sure?';


    procedure FilterByDeliveryDocument(DDNo: Code[20])
    begin
        Rec.SetFilter("Delivery Document No.", DDNo);
    end;
}
