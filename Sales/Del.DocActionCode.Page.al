Page 50347 "Del. Doc Action Code"
{
    // 001. 06-04-22 ZY-LD 000 - We don´t use the lines anymore.

    Caption = 'Delivery Document Action Codes';
    DataCaptionFields = "Delivery Document No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Delivery Document Action Code";

    layout
    {
        area(content)
        {
            part(DACHeader; "Del. Doc. Action Code 2")
            {
                Caption = 'Action Codes on Delivery Document Header';
                ShowFilter = false;
                SubPageLink = "Delivery Document No." = field("Delivery Document No."),
                              "Header / Line" = const(Header);
                SubPageView = sorting("Comment Type", Sequence);
            }
            part(DACLine; "Del. Doc. Action Code 2")
            {
                Caption = 'Action Codes on Delivery Document Line';
                ShowFilter = false;
                SubPageLink = "Delivery Document No." = field("Delivery Document No."),
                              "Header / Line" = const(Line);
                SubPageView = sorting("Comment Type", Sequence);
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DACHeader.Page.InitPage(Rec."Delivery Document No.", 0);
        CurrPage.DACLine.Page.InitPage(Rec."Delivery Document No.", 1);
    end;

    trigger OnInit()
    begin
        CurrPage.DACHeader.Page.InitPage(Rec."Delivery Document No.", 0);
        //CurrPage.DACLine.PAGE.InitPage("Delivery Document No.",1);  // 06-04-22 ZY-LD 001
    end;
}
