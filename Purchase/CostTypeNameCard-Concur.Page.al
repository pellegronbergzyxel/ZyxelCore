Page 50359 "Cost Type Name Card - Concur"
{
    Caption = 'Cost Type Name Card - Concur';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Cost Type Name";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Concur)
            {
                group("Travel Expense")
                {
                    Caption = 'Travel Expense';
                    field("Concur Company Name"; Rec."Concur Company Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Company Name';
                    }
                    group(Control12)
                    {
                        field("Bal. Account Type"; Rec."Bal. Account Type")
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field("Concur Credit Card Vendor No."; Rec."Concur Credit Card Vendor No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Credit Card Vendor No';
                        }
                        field("Concur Personal Vendor No."; Rec."Concur Personal Vendor No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Personal Vendor No.';
                        }
                    }
                }
                group("Invoice Capture")
                {
                    Caption = 'Invoice Capture';
                    field("Concur Approval Limit"; Rec."Concur Approval Limit")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approval Limit';
                    }
                }
            }
        }
    }

    actions
    {
    }
}
