pageextension 50124 ItemJournalZX extends "Item Journal"
{
    layout
    {
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.TestField("Gen. Prod. Posting Group");
    end;
}
