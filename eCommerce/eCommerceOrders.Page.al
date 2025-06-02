page 50238 "eCommerce Orders"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Orders';
    CardPageID = "eCommerce Order Card";
    PageType = List;
    SourceTable = "eCommerce Order Header";
    SourceTableView = sorting("RHQ Creation Date", "Marketplace ID", "Transaction Type", Open, "Completely Imported")
                      order(descending)
                      where(Open = const(true),
                            "Completely Imported" = const(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RHQ Creation Date"; Rec."RHQ Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies RHQ Creation Date';
                }
                field("Marketplace ID"; Rec."Marketplace ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies MarketPlace ID';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Transaction Type';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Customer No.';
                    Visible = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Order Date';
                }
                field("eCommerce Order Id"; Rec."eCommerce Order Id")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies eCommerce Order ID';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Invoice No.';
                    Visible = false;
                }
                field("Invoice Download"; Rec."Invoice Download")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoice Download';
                    ToolTip = 'Specifies Invoice Download';
                    Editable = false;
                    ExtendedDatatype = URL;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Location Code';
                }
                field("Ship From Country"; Rec."Ship From Country")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Ship From Country';
                    Visible = false;
                }
                field("Ship To Country"; Rec."Ship To Country")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Ship To Country';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Currency Code';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies VAT Bus. Posting Group';
                }
                field("Country Dimension"; Rec."Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Country Dimension';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Open';
                }
                field("Unexpected Item"; Rec."Unexpected Item")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Unexpected Item';
                    Visible = false;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Error Description';
                }
                field("Sell-to Type"; Rec."Sell-to Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Sell-to Type';
                    Visible = false;
                }
                field("Export Outside EU"; Rec."Export Outside EU")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Export Outside EU';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Amount';
                    Visible = false;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Amount';
                    Visible = false;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Amount Including VAT';
                    Visible = false;
                }
                field("Total (Exc. Tax)"; Rec."Total (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total (Exc. Tax)';
                    Visible = false;
                }
                field("Total Tax Amount"; Rec."Total Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total Tax Amount';
                    Visible = false;
                }
                field("Total (Inc. Tax)"; Rec."Total (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total (inc. Tax)';
                    Visible = false;
                }
                field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies VAT Registration No. Zyxel';
                    Visible = false;
                }
                field("Give Away Order"; Rec."Give Away Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Give Away Order';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control31; "eCommerce Order FactBox2")
            {
                SubPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
            part(Control30; "eCommerce Ship Details FactBox")
            {
                SubPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
            part(Control25; "eComm. Order Archive FactBox")
            {
                SubPageLink = "eCommerce Order Id" = field("eCommerce Order Id");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post &Batch")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post &Batch';
                ToolTip = 'Post and Batch eCommerce Orders ';
                Ellipsis = true;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Batch Post eCommerce Orders", true, true, Rec);
                    CurrPage.Update(false);
                end;
            }
            action("Delete Batch")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete Batch';
                ToolTip = 'Delete Batch Lines';
                Image = Delete;

                trigger OnAction()
                begin
                    DeleteLines();
                end;
            }
            action("Open Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Line';
                ToolTip = 'Open Lines ';
                Image = OpenJournal;
                Visible = false;

                trigger OnAction()
                begin
                    OpenEntry();
                end;
            }
            action("Validate Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Validate Document';
                ToolTip = 'Validate Document';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.ValidateDocument();
                    IF Rec.Modify() then;
                end;
            }
            action("Force Validate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Force Validate';
                ToolTip = 'Blank the Error Description';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction() //05-05-2025 BK #485255
                begin
                    Rec.ForceValidationDocument();
                    IF Rec.Modify() then;
                end;
            }
            action("Archive Manually")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Archive Manually';
                ToolTip = 'Archive Manually';
                Image = Archive;
                Visible = DeveloperVisible;

                trigger OnAction()
                begin
                    Rec.ArchiveDocumentManually();
                end;
            }
            action("Count")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Count';
                ToolTip = 'Count No. of eCommerce Orders';
                Image = Calculate;

                trigger OnAction()
                begin
                    Message('eCommerce Orders: %1', Rec.Count());
                end;
            }
            group(Import)
            {
                Caption = 'Import';
                group("Tax Library Document")
                {
                    Caption = 'Tax Library Document';
                    ToolTip = 'Specifies Tax Library Document';
                    Image = Import;
                    action("Import Tax Library Doc.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Tax Library Doc.';
                        ToolTip = 'Specifies Import Tax Library Document';
                        Image = Import;
                        RunObject = XmlPort "eCommerce Tax Doc. Import";
                    }
                    action("Import Batch")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Batch';
                        ToolTip = 'Import Batch';
                        Image = Import;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;

                        trigger OnAction()
                        var
                            APIMgt: Codeunit "API Management";
                        begin
                            APIMgt.ImportTaxLibDocument();
                        end;
                    }
                }
                group("eCommerce Fulfilled Shipment")
                {
                    Caption = 'eCommerce Fulfilled Shipment';
                    ToolTip = 'eCommerce Fulfilled Shipment';
                    Image = Import;
                    action("Import Fulfilled by eCommerce")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Fulfilled by eCommerce';
                        ToolTip = 'Import Fulfilled by eCommerce';
                        Image = Import;
                        RunObject = XmlPort "eComm. Fulfilled Ship. Import";
                    }
                    action("Import Fulfilled Batch")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Fulfilled Batch';
                        Image = ImportLog;
                        ToolTip = 'Import Fulfilled Batch';

                        trigger OnAction()
                        var
                            APIMgt: Codeunit "API Management";
                        begin
                            APIMgt.ImportFulfilledOrders();
                        end;
                    }
                }
                group("eCommerce FBA Customer Returns")
                {
                    Caption = 'eCommerce FBA Customer Returns';
                    ToolTip = 'eCommerce FBA Customer Returns';
                    Image = Import;
                    action("Import FBA Cust. Return eCommerce")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import FBA Cust. Return eCommerce';
                        ToolTip = 'Import FBA Cust. Return eCommerce';
                        Image = Import;
                        RunObject = XmlPort "eComm. Fulfilled Return Imp.";
                    }
                    action("Import FBA Cust. Return Batch")
                    {
                        ApplicationArea = Basic, Suite;
                        Image = ImportLog;
                        Caption = 'Import FBA Cust. Return Batch';
                        ToolTip = 'Import FBA Cust. Return Batch';

                        trigger OnAction()
                        var
                            APIMgt: Codeunit "API Management";
                        begin
                            APIMgt.ImportFbaCustReturns();
                        end;
                    }
                }
            }
            group(Process)
            {
                Caption = 'Process';
                Visible = DeveloperVisible;
                action("Process eCommerce (Test Purpose)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Process eCommerce (Test Purpose)';
                    ToolTip = 'Process eCommerce (Test Purpose)';
                    Image = Process;
                    RunObject = Codeunit "Process eCommerce";
                }
            }
        }
        area(Navigation)
        {
            action(ShowNotCompletedImport)
            {
                Caption = 'Show not Completed Import';
                ToolTip = 'Show not Completed Import';
                Visible = DeveloperVisible;
                Image = ImportDatabase;
                trigger OnAction()
                begin
                    Rec.SetRange(Open, false);
                    Rec.SetRange("Completely Imported", false);
                end;
            }
            action(ShowOpenOrders)
            {
                Caption = 'Show Open Orders';
                ToolTip = 'Show not Completed Import';
                Visible = DeveloperVisible;
                Image = OrderList;
                trigger OnAction()
                begin
                    Rec.SetRange(Open, true);
                    Rec.SetRange("Completely Imported", true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst() then;
        DeveloperVisible := ZGT.UserIsDeveloper();
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        CreateeCommerceInvoices: Codeunit "eCommerce Create Invoices";
        DeveloperVisible: Boolean;

    local procedure CreateeCommerceSalesDocuments()
    var
        lText001: Label 'Do you want to create eCommerce sales invoices and credit memos?';
    begin
        if Confirm(lText001) then
            CreateeCommerceInvoices.RunWithConfirm();
    end;

    local procedure CreateSingle(pCreateWithError: Boolean)
    var
        lText001: Label 'Do you want to create eCommerce sales invoice on %1?';
        lText002: Label 'Do you want to create eCommerce credit memo on %1?';
    begin
        if Rec."Transaction Type" = Rec."transaction type"::Order then begin
            if Confirm(lText001, false, Rec."eCommerce Order Id") then
                CreateeCommerceInvoices.RunCreateInSpiteOfError(Rec."eCommerce Order Id", Rec."Invoice No.", pCreateWithError);
        end else
            if Confirm(lText002, false, Rec."eCommerce Order Id") then
                CreateeCommerceInvoices.RunCreateInSpiteOfError(Rec."eCommerce Order Id", Rec."Invoice No.", pCreateWithError);
    end;

    local procedure OpenEntry()
    var
        lSaleInvHead: Record "Sales Invoice Header";
        lSaleCrMemoHead: Record "Sales Cr.Memo Header";
        lText001: Label '%1 is invoiced on %2 %3.';
        lText002: Label '%1 is credited %2 %3.';
        lText003: Label 'Do you want to open %1: "%2"; %3: "%4"?';
        lText004: Label '\\Do you want to continue?';
        lText005: Label 'The quantity is 0, so you canÍt open.';
    begin
        //>> 06-12-17 ZY-LD 001
        Rec.CalcFields(Rec.Quantity);
        if Rec.Quantity = 0 then
            Error(lText005);

        lSaleInvHead.SetRange("External Document No.", Rec."eCommerce Order Id");
        if lSaleInvHead.FindFirst() then
            if not Confirm(lText001 + lText004, false, Rec."eCommerce Order Id", lSaleInvHead.TableCaption(), lSaleInvHead."No.") then
                Error(lText001, Rec."eCommerce Order Id", lSaleInvHead.TableCaption(), lSaleInvHead."No.");

        lSaleInvHead.SetRange("External Document No.", Rec."Invoice No.");
        if lSaleInvHead.FindFirst() then
            if not Confirm(lText001 + lText004, false, Rec."Invoice No.", lSaleInvHead.TableCaption(), lSaleInvHead."No.") then
                Error(lText001, Rec."Invoice No.", lSaleInvHead.TableCaption(), lSaleInvHead."No.");

        lSaleCrMemoHead.SetRange("External Document No.", Rec."eCommerce Order Id");
        if lSaleCrMemoHead.FindFirst() then
            if Confirm(lText002 + lText004, false, Rec."eCommerce Order Id", lSaleCrMemoHead.TableCaption(), lSaleCrMemoHead."No.") then
                Error(lText002, Rec."eCommerce Order Id", lSaleCrMemoHead.TableCaption(), lSaleCrMemoHead."No.");

        lSaleCrMemoHead.SetRange("External Document No.", Rec."Invoice No.");
        if lSaleCrMemoHead.FindFirst() then
            if not Confirm(lText002 + lText004, false, Rec."Invoice No.", lSaleCrMemoHead.TableCaption(), lSaleCrMemoHead."No.") then
                Error(lText002, Rec."Invoice No.", lSaleCrMemoHead.TableCaption(), lSaleCrMemoHead."No.");

        if Confirm(lText003, false, Rec.FieldCaption(Rec."eCommerce Order Id"), Rec."eCommerce Order Id", Rec.FieldCaption(Rec."Invoice No."), Rec."Invoice No.") then begin
            Rec.Open := true;
            Rec."Sent To Intercompany" := false;
            Rec.Modify();
            CurrPage.Update();
        end;
        //<< 06-12-17 ZY-LD 001
    end;

    local procedure DeleteLines()
    var
        recAznSaleHead: Record "eCommerce Order Header";
        lText001: Label 'Do you want to delete %1 eCommerce Sales Order(s)?';

    begin
        CurrPage.SetSelectionFilter(recAznSaleHead);
        recAznSaleHead.SetRange(Open, true);
        if recAznSaleHead.FindSet(true) then
            if Confirm(lText001, false, recAznSaleHead.Count()) then begin
                ZGT.OpenProgressWindow('', recAznSaleHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(recAznSaleHead."eCommerce Order Id", 0, true);
                    recAznSaleHead.Delete(true);
                until recAznSaleHead.Next() = 0;
                ZGT.CloseProgressWindow();
            end;
    end;
}
