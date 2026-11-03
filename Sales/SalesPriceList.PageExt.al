pageextension 50018 "Sales Price List" extends "Sales Price List"
{
    layout
    {
        modify("StartingDate")
        {
            Editable = DatesEditable;
            ToolTip = 'Specifies the date until which the price list is valid.';
        }
        modify("EndingDate")
        {
            Editable = DatesEditable;
            ToolTip = 'Specifies the date until which the price list is valid.';
        }
    }
    actions
    {
        modify(VerifyLines)
        {
            Enabled = VeryfyLinesEnabled;
        }
        addafter(CopyLines)
        {
            Action(ImportexceltolineXml)
            {
                ApplicationArea = Basic, Suite;
                Ellipsis = true;
                Image = CreateXMLFile;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Import lines from Excel...';
                ToolTip = 'Import the lines from excel file, data = row 2, header: itemno,Currency code,starting date, ending date, unit price, Cust no, Cust. type';

                trigger OnAction()
                var
                    Amazonhelper: codeunit AmazonHelper;
                begin

                    Amazonhelper.PricelistupdatefromExcel(Rec);
                end;

            }
            Action(DeletedSalesPriceList)
            {
                ApplicationArea = Basic, Suite;
                Ellipsis = true;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
            }
            Action(EditableDates)
            {
                ApplicationArea = Basic, Suite;
                Ellipsis = true;
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Editable Dates';
                ToolTip = 'Make the starting and ending dates editable';

                trigger OnAction()
                var
                    Confirm: Label 'Are you sure you want to change the editability of the starting and ending dates?';
                    ReallySure: Label 'Are you really sure?';
                begin
                    if confirm(Confirm) then
                        if confirm(ReallySure) then begin
                            DatesEditable := true;
                            currPage.Update();
                        end;
                end;
            }
        }
    }


    var
        MarginApprovalVisible: Boolean;
        VeryfyLinesEnabled: Boolean;
        DatesEditable: Boolean;

    trigger OnOpenPage()
    var
        MarginApp: Record "Margin Approval";
        PriceListHead: Record "Price List Header";
    begin
        //30-10-2025 BK #MarginApproval
        MarginApprovalVisible := MarginApp.MarginApprovalActive();

        VeryfyLinesEnabled := true;
        if Rec."Amount Type" <> Rec."Amount Type"::Discount then
            VeryfyLinesEnabled := not MarginApp.MarginApprovalActive();

        DatesEditable := false;
    end;
}
