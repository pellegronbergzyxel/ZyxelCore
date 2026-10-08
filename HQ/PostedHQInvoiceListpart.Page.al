page 50326 "Posted HQ Invoice ListPart"
{//25-09-2026 BK #596378
    PageType = ListPart;
    SourceTable = "HQ Invoice Header";
    ApplicationArea = Basic, Suite;
    Caption = 'HQ Invoices';

    SourceTableView = sorting("Document Type", "No.") order(descending) where("Document Type" = const(Invoice), Status = const("Document is Posted"));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the No.';

                    trigger OnDrillDown()
                    begin
                        Rec.DownloadBlobToFile('');
                    end;
                }

                field(Filename; Rec.Filename)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Filename';

                    trigger OnDrillDown()
                    begin
                        Rec.DownloadBlobToFile('');
                    end;
                }

                field(FileAttached; Rec.FileAttached)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify that there are a File attached';
                }

                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify Total Amount';
                }
            }
        }
    }
}