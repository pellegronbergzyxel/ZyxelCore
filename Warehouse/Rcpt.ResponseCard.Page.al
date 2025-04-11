Page 50298 "Rcpt. Response Card"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 04-04-24 ZY-LD 000 - Update Warehouse Status.

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
                    Editable = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Reference"; Rec."Customer Reference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Message No."; Rec."Customer Message No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Order Type Option"; Rec."Order Type Option")
                {
                    ApplicationArea = Basic, Suite;
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
                    Editable = false;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("System Date Time"; Rec."System Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Receipt Date Time"; Rec."Receipt Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Posting Date Time"; Rec."Posting Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Terms"; Rec."Delivery Terms")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Connote; Rec.Connote)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Incoterm; Rec.Incoterm)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Colli; Rec.Colli)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Volume; Rec.Volume)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Receipt Posted"; Rec."Receipt Posted")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Values)
            {
                Caption = 'Values';
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Value 7"; Rec."Value 7")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Value 8"; Rec."Value 8")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Value 9"; Rec."Value 9")
                {
                    ApplicationArea = Basic, Suite;
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
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    if Confirm(Text001, true, Rec."No.") then
                        PostRespMgt.PostPurchaseOrderResponse(Rec."No.");
                end;
            }
            action("Update Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Warehouse Status';
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Rec.UpdateWarehouseStatus();  // 04-04-24 ZY-LD 002
                end;
            }
            group(Print)
            {
                Caption = 'Print';
                action("Print Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Document';
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
                Image = FiledOverview;
                RunObject = Page "Zyxel File Management Entries";
            }
            action("Show Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Document';
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
                Image = "Order";
                RunObject = Page "Warehouse Inbound Card";
                RunPageLink = "No." = field("Customer Reference");
            }
        }
    }

    var
        recZyFileMgt: Record "Zyxel File Management";
        recRcptRespHead: Record "Rcpt. Response Header";
        VCKXML: Codeunit "VCK Communication Management";
        PostRespMgt: Codeunit "Post Rcpt. Response Mgt.";
        Text001: label 'Do you want to post response no. %1? ';
}
