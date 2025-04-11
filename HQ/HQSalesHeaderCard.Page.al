Page 50070 "HQ Sales Header Card"
{
    Caption = 'HQ Sales Header Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "HQ Invoice Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            part(Control6; "HQ Sales Header Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }
}
