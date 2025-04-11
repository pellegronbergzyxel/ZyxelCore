Page 50042 "Zyxel File Management Entries"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Zyxel File Management Entries';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Zyxel File Management";
    SourceTableView = sorting("Creation Date", Open)
                      order(descending);
    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("On Hold"; Rec."On Hold")
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
        area(navigation)
        {
            action("Show Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Document';
                Image = ShowSelected;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    FileMgt: Codeunit "File Management";
                    lText001: Label 'Download Document';
                begin
                    FileMgt.DownloadHandler(Rec.Filename, lText001, '', 'PDF(*.pdf)|*.pdf|All files(*.*)|*.*', FileMgt.GetFileName(Rec.Filename));
                end;
            }
            action("VCK Purchase Order Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VCK Purchase Order Response';
                RunObject = Page "Rcpt. Response List";
            }
        }
        area(processing)
        {
            action(Download)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download';
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm(Text004, true) then
                        VckPostMgt.DownloadVCK(0, false);
                end;
            }
            group("Download and Import")
            {
                Caption = 'Download and Import';
                Image = Web;
                action("Purchase Response")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Response';
                    Image = WorkCenterLoad;

                    trigger OnAction()
                    begin
                        if Confirm(Text004, true) then
                            VckPostMgt.DownloadVCK(1, true);
                    end;
                }
                action("Shipping Response")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Shipping Response';
                    Image = WorkCenterLoad;

                    trigger OnAction()
                    begin
                        if Confirm(Text004, true) then
                            VckPostMgt.DownloadVCK(2, true);
                    end;
                }
                action(Inventory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory';
                    Image = WorkCenterLoad;

                    trigger OnAction()
                    begin
                        if Confirm(Text004, true) then
                            VckPostMgt.DownloadVCK(3, true);
                    end;
                }
                action(All)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All';
                    Image = WorkCenterLoad;

                    trigger OnAction()
                    begin
                        if Confirm(Text004, true) then
                            VckPostMgt.DownloadVCK(0, true);
                    end;
                }
            }
            action("Import Purchase Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Purchase Response';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                Visible = PurchOrderRespImportVisible;

                trigger OnAction()
                begin
                    if Confirm(Text002, false, Rec.Filename) then
                        PostRcptResp.PurchOrderRespImport(Rec."Entry No.");
                end;
            }
            action("Import Shipment Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Shipment Response';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShipOrderRespImportVisible;

                trigger OnAction()
                begin
                    if Confirm(Text002, false, Rec.Filename) then begin
                        PostShipResp.ShipOrderRespImport(Rec."Entry No.");
                        CurrPage.Update();
                    end;
                end;
            }
            action("Import Inventory")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Inventory';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                Visible = VCKInventoryVisible;

                trigger OnAction()
                begin
                    if Confirm(Text002, false, Rec.Filename) then
                        VckPostMgt.PostInventory(Rec."Entry No.");
                end;
            }
            action("Import Stock Movement")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Stock Movement';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                Visible = StockMovementImportVisible;

                trigger OnAction()
                begin
                    if Confirm(Text002, false, Rec.Filename) then
                        PostStockMove.StockMovementImport(Rec."Entry No.");
                end;
            }
            action("Open Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Line';

                trigger OnAction()
                begin
                    if Confirm(Text003) then begin
                        Rec.Open := true;
                        Rec.Modify;
                    end;
                end;
            }
            action("Get Response files for test")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Get Response files for test';

                trigger OnAction()
                begin
                    SetupTest;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetAction;
    end;

    trigger OnOpenPage()
    begin
        SetAction;
        Rec.SetRange(Rec.Open, true);
    end;

    var
        PostRcptResp: Codeunit "Post Rcpt. Response Mgt.";
        PostShipResp: Codeunit "Post Ship Response Mgt.";
        VckPostMgt: Codeunit "VCK Download and  Import Doc.";
        Text001: label 'Do you want to post "%1"?';
        Text002: label 'Do you want to import "%1"?';
        PostStockMove: Codeunit "Post Stock Movement Mgt.";
        PurchOrderRespImportVisible: Boolean;
        ShipOrderRespImportVisible: Boolean;
        VCKInventoryVisible: Boolean;
        Text003: label 'Do you want to open the line?';
        Text004: label 'Do you want to download from VCK?';
        StockMovementImportVisible: Boolean;

    local procedure SetAction()
    begin
        PurchOrderRespImportVisible := Rec.Type = Rec.Type::"VCK Purch. Response";
        ShipOrderRespImportVisible := Rec.Type = Rec.Type::"VCK Ship. Response";
        VCKInventoryVisible := Rec.Type = Rec.Type::"VCK Inventory";
        StockMovementImportVisible := Rec.Type = Rec.Type::"VCK Stock Correction";
    end;

    local procedure SetupTest()
    var
        recFile: Record File;
        FilterStr: Text;
    begin
        // recFile.SETRANGE(Path,'\\ZyEU-NAVSQL02\NAV Task Manager\AllIn\SavedReceivedFiles');
        // recFile.SETFILTER(Date,'%1..',20190102D);
        // FilterStr := STRSUBSTNO('*%1*.*','PurchaseOrderResponse');
        // recFile.SETFILTER(Name,FilterStr);
        recFile.SetRange(Path, 'H:\');
        Message('%1', recFile.Count);
    end;
}
