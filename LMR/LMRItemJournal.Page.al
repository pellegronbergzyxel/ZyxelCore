Page 50072 "LMR Item Journal"
{
    ApplicationArea = Basic, Suite;
    //Caption = 'LMR Item Journal';
    Caption = 'RMA Journal';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "LMR Stock";
    SourceTableView = sorting(Processed)
                      where(Open = const(true));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Bin; Rec.Bin)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Filename; Rec.Filename)
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
            action(ImportLMR)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import LMR';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Import LMR Sheet";
            }
            action(ImportVCK)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Logicall';
                Image = ImportDatabase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Import VCK RMA";
            }
            action(Post)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Post LMR Stock";
                ShortCutKey = 'F9';
            }
            action(Batch)
            {
                ApplicationArea = Basic, Suite;
                caption = 'Import and Post';
                Image = PostBatch;

                trigger OnAction()
                var
                    LmrMgt: Codeunit "Process RMA";
                begin
                    LmrMgt.RunManually();
                end;
            }
        }
    }
}
