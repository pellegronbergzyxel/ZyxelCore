Page 50040 "Intercompany Purchase"
{
    PageType = List;
    SourceTable = "Intercompany Purchase Code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Read Comp. Info from Company"; Rec."Read Comp. Info from Company")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Calc. Local VAT for Currency"; Rec."Calc. Local VAT for Currency")
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
