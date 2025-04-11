Page 50216 "Posted VCK Delivery Documents"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Posted Delivery Documents';
    Editable = false;
    PageType = List;
    SourceTable = "VCK Delivery Document Header";
    SourceTableView = order(descending)
                      where("Document Status" = const(Released),
                            "Warehouse Status" = const(Posted));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = true;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    DrillDown = true;
                    DrillDownPageID = "VCK Delivery Document";
                    Editable = false;
                    Lookup = true;
                    LookupPageID = "VCK Delivery Document";
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Requested Ship Date"; Rec."Requested Ship Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Create User ID"; Rec."Create User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Create Date"; Rec."Create Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Create Time"; Rec."Create Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Picking Date Time"; Rec."Picking Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Loading Date Time"; Rec."Loading Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Date Time"; Rec."Delivery Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Remark"; Rec."Delivery Remark")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Receiver Reference"; Rec."Receiver Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Release Date"; Rec."Release Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Release Time"; Rec."Release Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Signed By"; Rec."Signed By")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(View)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "VCK Delivery Document";
                RunPageOnRec = true;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;
    end;
}
