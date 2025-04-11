Page 50002 "Invoice Line Text Subform"
{
    // 001.  DT1.06  14-07-2010  SH
    //  .Object created

    AutoSplitKey = true;
    Caption = 'Invoice Line Text Subform';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Invoice Line Text";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Line text"; Rec."Line text")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
