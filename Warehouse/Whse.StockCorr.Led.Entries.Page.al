Page 50117 "Whse. Stock Corr. Led. Entries"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Whse. Stock Correction Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Whse. Stock Corr. Led. Entry";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Message No."; Rec."Message No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Message No."; Rec."Customer Message No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Project; Rec.Project)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("System Date"; Rec."System Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Product No."; Rec."Product No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Warehouse; Rec.Warehouse)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("New Warehouse"; Rec."New Warehouse")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("New Location"; Rec."New Location")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Stock Type"; Rec."Stock Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("New Stock Type"; Rec."New Stock Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("New Grade"; Rec."New Grade")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {
            action("Post Corrections")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Corrections';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F9';

                trigger OnAction()
                begin
                    PostWhseAdj.PostCorrectionWithConfirmation;
                end;
            }
            action("Post Movements")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Movements';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PostWhseAdj.PostMovementWithConfirmation;
                end;
            }
            action("Close Entry")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Close Entry';
                Image = Close;

                trigger OnAction()
                begin
                    if Confirm(Text001, true) then begin
                        Rec.Open := false;
                        Rec.Modify;
                    end;
                end;
            }
            action(Reopen)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reopen';
                Image = ReOpen;

                trigger OnAction()
                begin
                    Rec.Open := true;
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ReOpenVisible := ZGT.UserIsDeveloper;
    end;

    var
        PostWhseAdj: Codeunit "Post Whse. Adjustment";
        ReOpenVisible: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
        Text001: label 'Do you want to open entry?';
}
