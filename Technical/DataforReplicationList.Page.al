Page 50289 "Data for Replication List"
{
    // 001. 02-11-18 ZY-LD 2018103110000111 - Replicate customer.
    // 002. 27-05-19 ZY-LD P0213 - Force replication on customers.

    Caption = 'Data for Replication List';
    PageType = List;
    SourceTable = "Data for Replication";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = Basic, Suite;
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

    trigger OnClosePage()
    begin
        //>> 02-11-18 ZY-LD 001
        if ChangeHasBeenMade then
            case Rec."Table No." of
                Database::Customer:
                    ZyWebSrvMgt.ReplicateCustomers(Rec."Company Name", Rec."Source No.", false);
            end;
        //<< 02-11-18 ZY-LD 001
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 02-11-18 ZY-LD 001
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangeHasBeenMade := true;  // 02-11-18 ZY-LD 001
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 02-11-18 ZY-LD 001
    end;

    var
        ChangeHasBeenMade: Boolean;
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
}
