Page 50350 "Warehouse Inbound List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Warehouse Inbound List';
    CardPageID = "Warehouse Inbound Card";
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Inbound Header";
    SourceTableView = sorting("Expected Receipt Date");
    //where("Completely Received" = const(false));  // 28-02-24 ZY-LD
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control23)
            {
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sender No."; Rec."Sender No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sender Name"; Rec."Sender Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill of Lading No."; Rec."Bill of Lading No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Estimated Date of Departure"; Rec."Estimated Date of Departure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimated Date of Arrival"; Rec."Estimated Date of Arrival")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Method"; Rec."Shipping Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sent to Warehouse Date"; Rec."Sent to Warehouse Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Status Update Date"; Rec."Last Status Update Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Vessel Code"; Rec."Vessel Code")
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
        area(navigation)
        {
            action("Warehouse Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Response';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Rcpt. Response List";
                RunPageLink = "Customer Reference" = field("No.");
            }
            action("Container Details")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Container Details';
                Image = AllLines;
                RunObject = Page "VCK Container Details";
            }
            action("Posted Container Details")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Container Details';
                Image = Archive;
                RunObject = Page "VCK Archived Container Details";
            }
            action("Notice Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Notice Setup';
                Image = GetActionMessages;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Concur Setup";
                RunPageLink = "Import Error E-mail Code" = const('NO');
                RunPageView = where("Error Folder" = const('1'));
            }
        }
        area(processing)
        {
            action("Change Status")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Status';
                Image = ChangeStatus;

                trigger OnAction()
                begin
                    recWhseIndbHead.SetRange("No.", Rec."No.");
                    Clear(CngWhseStatusInbound);
                    CngWhseStatusInbound.InitReport(Rec."Warehouse Status", Rec."Document Status", Rec."Location Code");
                    CngWhseStatusInbound.SetTableview(recWhseIndbHead);
                    CngWhseStatusInbound.RunModal;
                end;
            }
            action("Create Whse. Inbound")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Whse. Inbound';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Create Whse. Inbound Order";
            }
            group(ActionGroup36)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseWarehouseInbound: Codeunit "Release Warehouse Inbound";
                    begin
                        ReleaseWarehouseInbound.PerformManuelRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseWarehouseInbound: Codeunit "Release Warehouse Inbound";
                    begin
                        ReleaseWarehouseInbound.PerformManuelReopen(Rec);
                    end;
                }
            }
            group(Send)
            {
                Caption = 'Send';
                action("Re-send Container Details")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re-send Container Details';
                    Image = SendTo;

                    trigger OnAction()
                    begin
                        if Confirm(Text002, true) then
                            if Rec.SendContainerDetails then
                                Message(Text003, Rec."No.");
                    end;
                }
                action("Re-Send Warehouse Inbound")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re-Send Warehouse Inbound';
                    Image = SendTo;

                    trigger OnAction()
                    var
                        ReleaseWarehouseInbound: Codeunit "Release Warehouse Inbound";
                    begin
                        if Confirm(Text004, true) then begin
                            Rec."Sent To Warehouse" := false;
                            Rec."Container Details is Sent" := false;
                            Rec.Modify(true);
                            ReleaseWarehouseInbound.Reopen(Rec);
                            ReleaseWarehouseInbound.Run(Rec);
                        end;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Print Container Details")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Container Details';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.PrintContainerDetails;
                end;
            }
            action("XML - Warehouse Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'XML - Warehouse Document';
                Image = XMLFile;
                RunObject = XMLport "Send Inbound Order Request";

                trigger OnAction()
                begin
                    Rec.ShowXMLdocument;
                end;
            }
        }
    }

    var
        CreateandReleaseMgt: Codeunit "Create and Release Whse. Inbou";
        recWhseIndbHead: Record "Warehouse Inbound Header";
        CngWhseStatusInbound: Report "Cng. Whse. Status - Inbound";
        Text001: label 'Do you want to release all open documents?';
        Text002: label 'Do you want to re-send container details?';
        Text003: label 'Container Details for %1 is re-sent.';
        Text004: label 'Do you want to re-send warehounse inbound?';
}
