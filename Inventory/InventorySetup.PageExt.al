pageextension 50187 InventorySetupZX extends "Inventory Setup"
{
    layout
    {
        addafter("Prevent Negative Inventory")
        {
            field("Prevent Empty Volume"; Rec."Prevent Empty Volume")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Default Item Disc. Group"; Rec."Default Item Disc. Group")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Numbering)
        {
            group("All-In Logistics")
            {
                group(Batches)
                {
                    field("AIT Batch Name"; Rec."AIT Batch Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("AIT Batch Description"; Rec."AIT Batch Description")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Journals)
                {
                    field("AIT Journal Template Name"; Rec."AIT Journal Template Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("AIT Journal Description"; Rec."AIT Journal Description")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("AIT Location Code"; Rec."AIT Location Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("AIT Inventory Posting Group"; Rec."AIT Inventory Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("AIT Gen. Prod. Posting Group"; Rec."AIT Gen. Prod. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("AIT Last Journal Document No"; Rec."AIT Last Journal Document No")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(GoodsInTransit)
                {
                    Caption = 'Goods in Transit';
                    field(InTransitLocationCode; Rec.GoodsInTransitLocationCode)
                    {
                        Caption = 'Location Code';
                        ApplicationArea = Basic, Suite;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the location code that the original will be replaced with on the purchase order lines upon receipt of "Good in Transit" from HQ.';
                    }
                    field(GoodsInTransitInTransitCode; Rec.GoodsInTransitInTransitCode)
                    {
                        Caption = 'In-Transit Code';
                        ApplicationArea = Basic, Suite;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the in-transit code that will be used on the automatically generated transfer order that is posted along with the posting of the purchase order.';
                    }
                }
            }
        }
    }

    actions
    {
        addfirst(navigation)
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("Primary Key");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(313));
                }
            }
        }
    }
}
