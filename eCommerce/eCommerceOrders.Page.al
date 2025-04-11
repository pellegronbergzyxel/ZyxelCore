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
                }
                field("Marketplace ID"; Rec."Marketplace ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("eCommerce Order Id"; Rec."eCommerce Order Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoice Download"; Rec."Invoice Download")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoice Download';
                    Editable = false;
                    ExtendedDatatype = URL;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship From Country"; Rec."Ship From Country")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship To Country"; Rec."Ship To Country")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country Dimension"; Rec."Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unexpected Item"; Rec."Unexpected Item")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Type"; Rec."Sell-to Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Export Outside EU"; Rec."Export Outside EU")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Total (Exc. Tax)"; Rec."Total (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Total Tax Amount"; Rec."Total Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Total (Inc. Tax)"; Rec."Total (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Give Away Order"; Rec."Give Away Order")
                {
                    ApplicationArea = Basic, Suite;
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
                Image = Delete;

                trigger OnAction()
                begin
                    DeleteLines;
                end;
            }
            action("Open Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Line';
                Image = OpenJournal;
                Visible = false;

                trigger OnAction()
                begin
                    OpenEntry;
                end;
            }
            action("Validate Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Validate Document';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.ValidateDocument;
                    IF Rec.Modify() then;
                end;
            }
            action("Archive Manually")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Archive Manually';
                Image = Archive;
                Visible = DeveloperVisible;

                trigger OnAction()
                begin
                    Rec.ArchiveDocumentManually;
                end;
            }
            action("Count")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Count';
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
                    Image = Import;
                    action("Import Tax Library Doc.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Tax Library Doc.';
                        Image = Import;
                        RunObject = XmlPort "eCommerce Tax Doc. Import";
                    }
                    action("Import Batch")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Batch';
                        Image = Import;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;

                        trigger OnAction()
                        var
                            APIMgt: Codeunit "API Management";
                        begin
                            //CODEUNIT.RUN(CODEUNIT::"API Management");
                            APIMgt.ImportTaxLibDocument;
                        end;
                    }
                }
                group("eCommerce Fulfilled Shipment")
                {
                    Caption = 'eCommerce Fulfilled Shipment';
                    Image = Import;
                    action("Import Fulfilled by eCommerce")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Fulfilled by eCommerce';
                        Image = Import;
                        RunObject = XmlPort "eComm. Fulfilled Ship. Import";
                    }
                    action("Import Fulfilled Batch")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Fulfilled Batch';

                        trigger OnAction()
                        var
                            APIMgt: Codeunit "API Management";
                        begin
                            APIMgt.ImportFulfilledOrders;
                        end;
                    }
                }
                group("eCommerce FBA Customer Returns")
                {
                    Caption = 'eCommerce FBA Customer Returns';
                    Image = Import;
                    action("Import FBA Cust. Return eCommerce")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import FBA Cust. Return eCommerce';
                        Image = Import;
                        RunObject = XmlPort "eComm. Fulfilled Return Imp.";
                    }
                    action("Import FBA Cust. Return Batch")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import FBA Cust. Return Batch';

                        trigger OnAction()
                        var
                            APIMgt: Codeunit "API Management";
                        begin
                            APIMgt.ImportFbaCustReturns;
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
                Visible = DeveloperVisible;
                trigger OnAction()
                begin
                    Rec.SetRange(Open, false);
                    Rec.SetRange("Completely Imported", false);
                end;
            }
            action(ShowOpenOrders)
            {
                Caption = 'Show Open Orders';
                Visible = DeveloperVisible;
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
        DeveloperVisible := ZGT.UserIsDeveloper;
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
            CreateeCommerceInvoices.RunWithConfirm;
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
        xxx: page "Customer List";
    begin
        CurrPage.SetSelectionFilter(recAznSaleHead);
        recAznSaleHead.SetRange(Open, true);
        if recAznSaleHead.FindSet(true) then begin
            if Confirm(lText001, false, recAznSaleHead.Count()) then begin
                ZGT.OpenProgressWindow('', recAznSaleHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(recAznSaleHead."eCommerce Order Id", 0, true);
                    recAznSaleHead.Delete(true);
                until recAznSaleHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        end;
    end;
}
