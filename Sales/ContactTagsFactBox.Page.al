Page 50225 "Contact Tags FactBox"
{
    Caption = 'Available Tags';
    InsertAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Contract Tag";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tag; Rec.Tag)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = ' ';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.InsertContractTag(Rec.Tag);
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(New)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'New';
                Image = New;

                trigger OnAction()
                begin
                    Rec.NewTag;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Rec."Document No. Filter", SI.GetDocumentNo);
        Rec.SetRange(Rec."Tag Created on Document", false);
    end;

    var
        SI: Codeunit "Single Instance";
}
