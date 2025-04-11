pageextension 50402 "Review G/L Entries" extends "Review G/L Entries"
{
    // layout
    // {
    //     addafter(Amount)
    //     {
    //         field("Remaining Amount"; Rec."Remaining Amount")
    //         {
    //             ApplicationArea = Basic, Suite;
    //         }
    //     }
    // }
    // trigger OnAfterGetRecord()
    // begin
    //     if Rec."Reviewed Identifier" = 0 then
    //         Rec."Remaining Amount" := Rec.Amount;
    // end;
}
