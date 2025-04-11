Page 50360 "Cost Type Name List - Concur"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Cost Type Name List - Concur';
    CardPageID = "Cost Type Name Card - Concur";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Cost Type Name";
    SourceTableView = where(Blocked = const(false));
    UsageCategory = Administration;

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
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Company Name"; Rec."Concur Company Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Credit Card Vendor No."; Rec."Concur Credit Card Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Concur Personal Vendor No."; Rec."Concur Personal Vendor No.")
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
