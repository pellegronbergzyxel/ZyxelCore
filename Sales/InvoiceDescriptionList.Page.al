Page 50001 "Invoice Description List"
{
    // 001.  DT1.06  14-07-2010  SH
    //  .Object created

    Caption = 'Invoice Description List';
    CardPageID = "Invoice Description Card";
    PageType = List;
    SourceTable = "Invoice Description";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Texts")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Texts';
                Image = Text;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Invoice Line Text Subform";
                RunPageLink = "Invoice Description Code" = field(Code);
            }
        }
    }
}
