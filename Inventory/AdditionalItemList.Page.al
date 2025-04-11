Page 50273 "Additional Item List"
{
    // 001. 20-11-18 ZY-LD 2018111910000071 - New field.

    Caption = 'Additional Item List';
    PageType = List;
    SourceTable = "Additional Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Country/Region"; Rec."Ship-to Country/Region")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Forecast Territory"; Rec."Forecast Territory")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Additional Item No."; Rec."Additional Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Additional Item Description"; Rec."Additional Item Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Edit Additional Sales Line"; Rec."Edit Additional Sales Line")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Hide Line"; Rec."Hide Line")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Additional Items")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Additional Items';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Import Additional Items";
            }
        }
        area(navigation)
        {
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Primary Key Field 1 Value" = field("Item No."),
                              "Primary Key Field 2 Value" = field("Ship-to Country/Region"),
                              "Primary Key Field 3 Value" = field("Additional Item No.");
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(50121));
            }
        }
    }
}
