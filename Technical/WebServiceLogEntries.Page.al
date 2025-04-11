Page 50314 "Web Service Log Entries"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Web Service Log Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Web Service Log Entry";
    SourceTableView = order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Web Service Name"; Rec."Web Service Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Web Service Function"; Rec."Web Service Function")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Filter"; Rec.Filter)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Deleted"; Rec."Quantity Deleted")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Inserted"; Rec."Quantity Inserted")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Modified"; Rec."Quantity Modified")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Sent"; Rec."Quantity Sent")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;
    end;
}
