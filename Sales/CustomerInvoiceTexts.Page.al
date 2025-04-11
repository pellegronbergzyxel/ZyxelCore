Page 50003 "Customer Invoice Texts"
{
    // 001.  DT1.06  14-07-2010  SH
    //  .Object created

    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "Customer Invoice Texts";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Text ID"; Rec."Text ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order Confimation"; Rec."Order Confimation")
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
