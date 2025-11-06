Page 50298 "Rcpt. Response Card"
{
    ApplicationArea = Basic, Suite;
    UsageCategory = None;
    Caption = 'Rcpt. Response Card';
    DeleteAllowed = false;
    Description = 'Rcpt. Response Card';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Rcpt. Response Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Order No';
                    Editable = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Warehouse Status';
                }
                field("Customer Reference"; Rec."Customer Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Customer Reference';
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the On Hold';
                }
                field("Customer Message No."; Rec."Customer Message No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Customer Message No';
                    Editable = false;
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Cost Center';
                    Editable = false;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Order Type';
                    Editable = false;
                    Importance = Additional;
                }
                field("Order Type Option"; Rec."Order Type Option")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Order Type Option';
                }
            }
            part(Control36; "Rcpt Responsce Subform")
            {
                Caption = 'Lines';
                Description = 'Lines';
                SubPageLink = "Response No." = field("No.");
            }
            group(Shipment)
            {
                Caption = 'Shipment';
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Shipment No';
                    Editable = false;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Shipper Reference';
                    Editable = false;
                }
                field("System Date Time"; Rec."System Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the System Date Time';
                    Editable = false;
                }
                field("Receipt Date Time"; Rec."Receipt Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Receipt Date Time';
                    Editable = false;
                }
                field("Posting Date Time"; Rec."Posting Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Posting Date Time';
                    Editable = false;
                }
                field("Delivery Terms"; Rec."Delivery Terms")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Delivery Terms';
                    Editable = false;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Mode of Transport';
                    Editable = false;
                }
                field(Connote; Rec.Connote)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Connote';
                    Editable = false;
                }
                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Carrier';
                    Editable = false;
                }
                field(Incoterm; Rec.Incoterm)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Incoterm';
                    Editable = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the City';
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Open';
                    Editable = false;
                }
                field(Colli; Rec.Colli)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Colli';
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Weight';
                    Editable = false;
                }
                field(Volume; Rec.Volume)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Volume';
                    Editable = false;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Receipt Posted"; Rec."Receipt Posted")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Receipt Posted';
                }
            }
            group(Values)
            {
                Caption = 'Values';
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 1';
                    Editable = false;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 2';
                    Editable = false;
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 3';
                    Editable = false;
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 4';
                    Editable = false;
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 5';
                    Editable = false;
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 6';
                    Editable = false;
                }
                field("Value 7"; Rec."Value 7")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 7';
                    Editable = false;
                }
                field("Value 8"; Rec."Value 8")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 8';
                    Editable = false;
                }
                field("Value 9"; Rec."Value 9")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Value 9';
                    Editable = false;
                }
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
                                PostRespMgt.PostPurchaseOrderResponse(Rec."No.");
                    end else
                        if Confirm(Text001, true, Rec."No.") then
                            PostRespMgt.PostPurchaseOrderResponse(Rec."No.");
                end;
            }
            action("Update Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Warehouse Status';
                ToolTip = 'Specify the Update Warehouse Status';
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Rec.UpdateWarehouseStatus();
                end;
            }
            group(Print)
            {
                Caption = 'Print';
                action("Print Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Document';
                    ToolTip = 'Specify the Print Document';
                    Image = PrintDocument;

                    trigger OnAction()
                    begin
                        recRcptRespHead.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Rcpt. Inbound Document", true, false, recRcptRespHead);
                    end;
                }
            }
        }
        area(navigation)
        {
            action("File Management")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'File Management';
                ToolTip = 'Specify the File Management';
                Image = FiledOverview;
                RunObject = Page "Zyxel File Management Entries";
            }
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
                    if recZyFileMgt.Get(Rec."File Management Entry No.") then
                        Hyperlink(recZyFileMgt.Filename);
                end;
            }
            action("Show Warehouse Inbound Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Warehouse Inbound Order';
                ToolTip = 'Specify the Show Warehouse Inbound Order';
                Image = "Order";
                RunObject = Page "Warehouse Inbound Card";
                RunPageLink = "No." = field("Customer Reference");
            }
        }
    }

    var
        recZyFileMgt: Record "Zyxel File Management";
        recRcptRespHead: Record "Rcpt. Response Header";
        PostRespMgt: Codeunit "Post Rcpt. Response Mgt.";
        Text001: label 'Do you want to post response no. %1? ';
}
