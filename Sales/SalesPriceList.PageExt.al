pageextension 50018 "Sales Price List" extends "Sales Price List"
{
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
                // Caption = 'Copy to lines...';
                //image = Copy;
                ApplicationArea = Basic, Suite;
                // Enabled = PriceListIsEditable and CopyLinesEnabled;
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
        }
    }


    var
        MarginApprovalVisible: Boolean;
        VeryfyLinesEnabled: Boolean;

    trigger OnOpenPage()
    var
        MarginApp: Record "Margin Approval";
        PriceListHead: Record "Price List Header";
    begin
        //30-10-2025 BK #MarginApproval
        MarginApprovalVisible := MarginApp.MarginApprovalActive();

        VeryfyLinesEnabled := true;
        if Rec."Amount Type" <> Rec."Amount Type"::Discount then
            VeryfyLinesEnabled := not MarginApp.MarginApprovalActive()
    end;
}
