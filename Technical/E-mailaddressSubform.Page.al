Page 50254 "E-mail address Subform"
{
    // 001. 16-03-22 ZY-LD 2022031610000057 - Sell-to Customer Filter.

    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "E-mail address Body";

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(LanguageFilter; LanguageFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Language Filter';
                    TableRelation = Language;

                    trigger OnValidate()
                    begin
                        Rec.SetRange(Rec."Language Code", LanguageFilter);
                        CurrPage.Update;
                    end;
                }
                field(SellToCustomerFilter; SellToCustFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sell-to Customer Filter';
                    TableRelation = Customer;

                    trigger OnValidate()
                    begin
                        //>> 16-03-22 ZY-LD 001
                        Rec.SetRange(Rec."Sell-to Customer No.", SellToCustFilter);
                        CurrPage.Update;
                        //<< 16-03-22 ZY-LD 001
                    end;
                }
            }
            repeater(Group)
            {
                field("Body Text"; Rec."Body Text")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Rec."Language Code", '%1', '');
    end;

    var
        LanguageFilter: Code[10];
        SellToCustFilter: Code[20];
        PageEditable: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure SetActions()
    var
        recEmailAdd: Record "E-mail address";
    begin
        if recEmailAdd.Get(Rec.GetFilter(Rec."E-mail Address Code")) then
            PageEditable := not recEmailAdd.Replicated
        else
            PageEditable := ZGT.IsRhq;
        PageEditable := true;
    end;
}
