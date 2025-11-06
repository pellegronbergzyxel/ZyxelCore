Page 50053 "Shipment Response Card"
{

    Caption = 'Shipment Response Card';
    Description = 'Shipment Response Card';
    ApplicationArea = Basic, Suite;
    UsageCategory = None;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Ship Response Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specify the No';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specify the Order No';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ToolTip = 'Specify the Warehouse Status';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ToolTip = 'Specify the Cost Center';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ToolTip = 'Specify the Order Type';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ToolTip = 'Specify the Shipment No';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Receiver Reference"; Rec."Receiver Reference")
                {
                    ToolTip = 'Specify the Receiver Reference';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Customer Reference"; Rec."Customer Reference")
                {
                    ToolTip = 'Specify the Customer Reference';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Customer Message No."; Rec."Customer Message No.")
                {
                    ToolTip = 'Specify the Customer Message No';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Terms"; Rec."Delivery Terms")
                {
                    ToolTip = 'Specify the Delivery Terms';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    ToolTip = 'Specify the Mode of Transport';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Connote; Rec.Connote)
                {
                    ToolTip = 'Specify the Connote';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Carrier; Rec.Carrier)
                {
                    ToolTip = 'Specify the Carrier';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Colli; Rec.Colli)
                {
                    ToolTip = 'Specify the Colli';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specify the Weight';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Volume; Rec.Volume)
                {
                    ToolTip = 'Specify the Volume';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Incoterm; Rec.Incoterm)
                {
                    ToolTip = 'Specify the Incoterm';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specify the City';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Mode of Transport 2"; Rec."Mode of Transport 2")
                {
                    ToolTip = 'Specify the Mode Of Transport';
                    ApplicationArea = Basic, Suite;
                    Caption = 'Mode Of Transport';
                    Editable = false;
                }
                field("Signed By"; Rec."Signed By")
                {
                    ToolTip = 'Specify the Signed By';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Remark"; Rec."Delivery Remark")
                {
                    ToolTip = 'Specify the Delivery Remark';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ToolTip = 'Specify the Delivery Status';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Carrier Service"; Rec."Carrier Service")
                {
                    ToolTip = 'Specify the Carrier Service';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ToolTip = 'Specify the On Hold';
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Control21; "Shipment Response Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Response No." = field("No.");
            }
            group(Dates)
            {
                Caption = 'Dates';
                field("Picking Date Time"; Rec."Picking Date Time")
                {
                    ToolTip = 'Specify the Picking Date Time';
                    ApplicationArea = Basic, Suite;
                }
                field("Loading Date Time"; Rec."Loading Date Time")
                {
                    ToolTip = 'Specify the Loading Date Time';
                    ApplicationArea = Basic, Suite;
                }
                field("Planned Shipment Date Time"; Rec."Planned Shipment Date Time")
                {
                    ToolTip = 'Specify the Planned Shipment Date Time';
                    ApplicationArea = Basic, Suite;
                }
                field("Actual Shipment Date Time"; Rec."Actual Shipment Date Time")
                {
                    ToolTip = 'Specify the Actual Shipment Date Time';
                    ApplicationArea = Basic, Suite;
                }
                field("Delivery Date Time"; Rec."Delivery Date Time")
                {
                    ToolTip = 'Specify the Delivery Date Time';
                    ApplicationArea = Basic, Suite;
                }
                field("System Date Time"; Rec."System Date Time")
                {
                    ToolTip = 'Specify the System Date Time';
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date Time"; Rec."Posting Date Time")
                {
                    ToolTip = 'Specify the Posting Date Time';
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Values)
            {
                Caption = 'Values';
                field("Value 1"; Rec."Value 1")
                {
                    ToolTip = 'Specify the Value 1';
                    ApplicationArea = Basic, Suite;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ToolTip = 'Specify the Value 2';
                    ApplicationArea = Basic, Suite;
                }
                field("Value 3"; Rec."Value 3")
                {
                    ToolTip = 'Specify the Value 3';
                    ApplicationArea = Basic, Suite;
                }
                field("Value 4"; Rec."Value 4")
                {
                    ToolTip = 'Specify the Value 4';
                    ApplicationArea = Basic, Suite;
                }
                field("Value 5"; Rec."Value 5")
                {
                    ToolTip = 'Specify the Value 5';
                    ApplicationArea = Basic, Suite;
                }
                field("Value 6"; Rec."Value 6")
                {
                    ToolTip = 'Specify the Value 6';
                    ApplicationArea = Basic, Suite;
                }
                field("Value 7"; Rec."Value 7")
                {
                    ToolTip = 'Specify the Value 7';
                    ApplicationArea = Basic, Suite;
                }
                field("Value 8"; Rec."Value 8")
                {
                    ToolTip = 'Specify the Value 8';
                    ApplicationArea = Basic, Suite;
                }
                field("Value 9"; Rec."Value 9")
                {
                    ToolTip = 'Specify the Value 9';
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Container)
            {
                Caption = 'Container';
                field(Pallets; Rec.Pallets)
                {
                    ToolTip = 'Specify the Pallets';
                    ApplicationArea = Basic, Suite;
                }
                field(Cartons; Rec.Cartons)
                {
                    ToolTip = 'Specify the Cartons';
                    ApplicationArea = Basic, Suite;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ToolTip = 'Specify the Gross Weight';
                    ApplicationArea = Basic, Suite;
                }
                field("Nett Weight"; Rec."Nett Weight")
                {
                    ToolTip = 'Specify the Nett Weight';
                    ApplicationArea = Basic, Suite;
                }
                field("Container ID"; Rec."Container ID")
                {
                    ToolTip = 'Specify the Container ID';
                    ApplicationArea = Basic, Suite;
                }
                field("Container Type"; Rec."Container Type")
                {
                    ToolTip = 'Specify the Container Type';
                    ApplicationArea = Basic, Suite;
                }
                field("Container Height"; Rec."Container Height")
                {
                    ToolTip = 'Specify the Container Height';
                    ApplicationArea = Basic, Suite;
                }
                field("Container Width"; Rec."Container Width")
                {
                    ToolTip = 'Specify the Container Width';
                    ApplicationArea = Basic, Suite;
                }
                field("Container Depth"; Rec."Container Depth")
                {
                    ToolTip = 'Specify the Container Depth';
                    ApplicationArea = Basic, Suite;
                }
                field("Container Volume"; Rec."Container Volume")
                {
                    ToolTip = 'Specify the Container Volume';
                    ApplicationArea = Basic, Suite;
                }
                field("Container Gross Weight"; Rec."Container Gross Weight")
                {
                    ToolTip = 'Specify the Container Gross Weight';
                    ApplicationArea = Basic, Suite;
                }
                field("Container New Weight"; Rec."Container New Weight")
                {
                    ToolTip = 'Specify the Container New Weight';
                    ApplicationArea = Basic, Suite;
                }
                field("Container Customer Reference"; Rec."Container Customer Reference")
                {
                    ToolTip = 'Specify the Container Customer Reference';
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Invoicing Logistic Handling"; Rec."Invoicing Logistic Handling")
                {
                    ToolTip = 'Specify the Invoicing Logistic Handling';
                    ApplicationArea = Basic, Suite;
                }
                field("Invoicing Handling Charges"; Rec."Invoicing Handling Charges")
                {
                    ToolTip = 'Specify the Invoicing Handling Charges';
                    ApplicationArea = Basic, Suite;
                }
                field("Invoicing Transport Cost"; Rec."Invoicing Transport Cost")
                {
                    ToolTip = 'Specify the Invoicing Transport Cost';
                    ApplicationArea = Basic, Suite;
                }
                field("Invocing Fuel Surcharge"; Rec."Invocing Fuel Surcharge")
                {
                    ToolTip = 'Specify the Invocing Fuel Surcharge';
                    ApplicationArea = Basic, Suite;
                }
                field("Invoicing Air freight"; Rec."Invoicing Air freight")
                {
                    ToolTip = 'Specify the Invoicing Air freight';
                    ApplicationArea = Basic, Suite;
                }
                field("Invoicing Third Party Cost"; Rec."Invoicing Third Party Cost")
                {
                    ToolTip = 'Specify the Invoicing Third Party Cost';
                    ApplicationArea = Basic, Suite;
                }
                field("Invoicing Miscellaneous Cost"; Rec."Invoicing Miscellaneous Cost")
                {
                    ToolTip = 'Specify the Invoicing Miscellaneous Cost';
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            part(Control23; "VCK Ship Resp. SNos FaxtBox")
            {
                Caption = 'Serial No.';
                Provider = Control21;
                SubPageLink = "Response No." = field("Response No."),
                              "Response Line No." = field("Response Line No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post VCK Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post VCK Response';
                ToolTip = 'Specify the Post VCK Response';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F9';

                trigger OnAction()
                var
                    AutoSetup: Record "Automation Setup";
                    Text004: label 'Warehouse is closed for month end management.\Are you sure that you want to process warehouse?';
                    Text005: label 'You are absolutely sure?';

                begin
                    if not AutoSetup.WhsePostingAllowed() then begin  //03-11-2025 BK #537578
                        if Confirm(Text004) then
                            if Confirm(Text005) then
                                PostRespMgt.PostShippingOrderResponse(Rec."No.");
                    End else
                        if Confirm(Text002, true, Rec."No.") then
                            PostRespMgt.PostShippingOrderResponse(Rec."No.");
                end;
            }
            action("Set Warehouse Status to Posted")
            {
                ApplicationArea = Basic, Suite;
                Image = Status;
                Caption = 'Set Warehouse Status to Posted';
                ToolTip = 'Specify the Set Warehouse Status to Posted';

                trigger OnAction()
                begin
                    if not recServEnviron.ProductionEnvironment() then
                        if Confirm(Text001, false, Rec.FieldCaption(Rec."Warehouse Status")) then begin
                            Rec."Warehouse Status" := Rec."warehouse status"::Posted;
                            Rec.Modify();

                            recShipRespLine.SetRange("Response No.", Rec."No.");
                            if recShipRespLine.FindSet(true) then
                                repeat
                                    recShipRespLine.Quantity := recShipRespLine."Ordered Quantity";
                                    recShipRespLine.Modify();

                                    recDelDocLine.SetRange("Sales Order No.", recShipRespLine."Customer Order No.");
                                    recDelDocLine.SetRange("Sales Order Line No.", recShipRespLine."Customer Order Line No.");
                                    if recDelDocLine.FindFirst() then begin
                                        recDelDocLine.Posted := false;
                                        recDelDocLine.Modify();
                                    end;
                                until recShipRespLine.Next() = 0;
                        end;
                end;
            }

            Action(CopyfromlastpickedandOpen)
            {
                ApplicationArea = all;
                Image = Copy;
                caption = 'Recreate lines from last ready-to-pick and make open';
                ToolTip = 'Specify the Recreate lines from last ready-to-pick and make open';
                trigger OnAction()
                var
                    tempcorrection: codeunit TempCorrection;

                begin
                    tempcorrection.CopyfromlastpickedandOpen(rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(navigation)
        {
            action("Show Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Document';
                ToolTip = 'Specify the Show Document';
                Image = XMLFile;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.ShowResponseFile();
                end;
            }
            action("Show Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Delivery Document';
                ToolTip = 'Specify the Show Delivery Document';
                Image = Document;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Customer Reference");
            }
        }
    }

    var
        recServEnviron: Record "Server Environment";
        recShipRespLine: Record "Ship Response Line";
        recDelDocLine: Record "VCK Delivery Document Line";
        PostRespMgt: Codeunit "Post Ship Response Mgt.";
        Text001: label 'Do you want to change "%1"?';
        Text002: label 'Do you want to post response no. %1? ';

}
