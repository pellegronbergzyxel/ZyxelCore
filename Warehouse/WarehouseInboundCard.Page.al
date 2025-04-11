Page 50349 "Warehouse Inbound Card"
{
    Caption = 'Warehouse Inbound Card';
    SourceTable = "Warehouse Inbound Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Control14)
                {
                    field("Sender No."; Rec."Sender No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DocumentEditable;
                    }
                    field("Sender Name"; Rec."Sender Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Sender Name 2"; Rec."Sender Name 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Sender Address"; Rec."Sender Address")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Sender Address 2"; Rec."Sender Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Sender Post Code"; Rec."Sender Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Sender City"; Rec."Sender City")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Sender Country/Region Code"; Rec."Sender Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Control15)
                {
                    field("Location Code"; Rec."Location Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = LocationCodeEditable;
                    }
                    field(Warehouse; Rec.Warehouse)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Warehouse Name"; Rec."Warehouse Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Warehouse Address"; Rec."Warehouse Address")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Warehouse Country/Region Code"; Rec."Warehouse Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                }
                group(Control32)
                {
                    field("Container No."; Rec."Container No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DocumentEditable;
                    }
                    field("Bill of Lading No."; Rec."Bill of Lading No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DocumentEditable;
                    }
                    field("Estimated Date of Departure"; Rec."Estimated Date of Departure")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DatesEditable;
                    }
                    field("Estimated Date of Arrival"; Rec."Estimated Date of Arrival")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DatesEditable;
                    }
                    field("Expected Receipt Date"; Rec."Expected Receipt Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DatesEditable;
                    }
                    field("Shipping Method"; Rec."Shipping Method")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DocumentEditable;
                    }
                    field("Shipper Reference"; Rec."Shipper Reference")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Shipment No."; Rec."Shipment No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DocumentEditable;
                    }
                    field("Vessel Code"; Rec."Vessel Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Sent to Warehouse Date"; Rec."Sent to Warehouse Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Last Status Update Date"; Rec."Last Status Update Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
            }
            part(Control28; "Whse. Inbound Order Subpage")
            {
                Caption = 'Lines';
                Editable = DocumentEditable;
                SubPageLink = "Document No." = field("No.");
                SubPageView = sorting("Document No.", "Line No.");
            }
            group(Comment)
            {
                Caption = 'Comment';
                field(Control47; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            part(Control29; "Item Warehouse FactBox")
            {
                Caption = 'Item Details - Warehouse';
                Provider = Control28;
                SubPageLink = "No." = field("Item No."),
                              "Location Filter" = field(Location);
            }
            part(Control31; "VCK Ship. Detail Received")
            {
                Caption = 'Received Details';
                Provider = Control28;
                SubPageLink = "Container No." = field("Container No."),
                              "Invoice No." = field("Invoice No."),
                              "Purchase Order No." = field("Purchase Order No."),
                              "Purchase Order Line No." = field("Purchase Order Line No."),
                              "Pallet No." = field("Pallet No."),
                              "Item No." = field("Item No."),
                              Quantity = field(Quantity),
                              "Shipping Method" = field("Shipping Method"),
                              "Order No." = field("Order No.");
            }
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
            group(ActionGroup39)
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
            group("Function")
            {
                Caption = 'Function';
                action("Create Sales Cr. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Sales Cr. Memo';
                    Image = CreditMemo;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = CreateCreditMemoVisible;

                    trigger OnAction()
                    begin
                        Rec.CreateSalesCreditMemo(false);
                    end;
                }
                action("New Line")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Line';
                    Image = New;
                    Visible = DocumentEditable;

                    trigger OnAction()
                    begin
                        Rec.NewLine;
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

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        CreateandReleaseMgt: Codeunit "Create and Release Whse. Inbou";
        recWhseIndbHead: Record "Warehouse Inbound Header";
        CngWhseStatusInbound: Report "Cng. Whse. Status - Inbound";
        DocumentEditable: Boolean;
        DatesEditable: Boolean;
        CreateCreditMemoVisible: Boolean;
        Text001: label 'Do you want to release all open documents?';
        Text002: label 'Do you want to re-send container details?';
        Text003: label 'Container Details for %1 is re-sent.';
        LocationCodeEditable: Boolean;
        Text004: label 'Do you want to re-send warehounse inbound?';

    local procedure SetActions()
    begin
        DocumentEditable := (not Rec."Automatic Created") and (Rec."Warehouse Status" = Rec."warehouse status"::" ");
        LocationCodeEditable := Rec."Warehouse Status" = Rec."warehouse status"::" ";
        DatesEditable := Rec."Warehouse Status" < Rec."warehouse status"::"Goods Received";
        CreateCreditMemoVisible :=
          (Rec."Warehouse Status" = Rec."warehouse status"::"On Stock") and
          (Rec."Document Status" = Rec."document status"::Released) and
          (Rec."Order Type" = Rec."order type"::"Sales Return Order") and
          (not Rec."Sales Credit Memo is Created");
    end;
}
