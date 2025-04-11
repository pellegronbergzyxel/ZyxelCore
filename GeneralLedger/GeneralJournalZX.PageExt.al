pageextension 50003 GeneralJournalZX extends "General Journal"
{
    actions
    {
        addafter("B&ank")
        {
            group(Import)
            {
                Caption = 'Import';
                action("Import From Excel")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import From Excel';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Import Journal Lines From Excel';

                    trigger OnAction()
                    var
                        Import: Report "Import Geneal Journal Lines";
                    begin
                        Import.SetInitialValues(Rec."Journal Template Name", Rec."Journal Batch Name");
                        Import.RunModal();
                        CurrPage.Update(true);
                    end;
                }
            }
        }
    }
}
