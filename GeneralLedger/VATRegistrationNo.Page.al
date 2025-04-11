Page 50007 "VAT Registration No"
{
    // 001.  DT2.11  25-10-2011  SH
    //  .Object created

    PageType = List;
    SourceTable = "IC Vendors";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Identification; Rec.Identification)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT registration No"; Rec."VAT registration No")
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
