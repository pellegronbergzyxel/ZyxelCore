Page 50297 "Rcpt. Response List"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 24-05-19 ZY-LD 000 - Close request.
    // 003. 04-04-24 ZY-LD 000 - Update Warehouse Status.

    ApplicationArea = Basic, Suite;
    Caption = 'Rcpt. Response List';
    CardPageID = "Rcpt. Response Card";
    DeleteAllowed = false;
    Description = 'Rcpt. Response List';
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Rcpt. Response Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Open; Rec.Open)
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
                    Visible = false;
                }
                field("Order Type Option"; Rec."Order Type Option")
                {
                    ApplicationArea = Basic, Suite;
                }
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
                field("Customer Reference"; Rec."Customer Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("After Post Description"; Rec."After Post Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Message No."; Rec."Customer Message No.")
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
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Path and Filename';
                    Visible = false;
                }
                field("FileMgt.GetFileName(Filename)"; FileMgt.GetFileName(Rec.Filename))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Filename';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Post)
            {
                Caption = 'Post';
                Image = Post;
                action("Download and Import")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Download and Import';
                    Image = Web;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if Confirm(Text003, true) then
                            PostRespMgt.DownloadVCK(1, true);
                    end;
                }
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
                        if Confirm(Text002, true, Rec."No.") then
                            PostRespMgt.PostPurchaseOrderResponse(Rec."No.");
                    end;
                }
                action("Post VCK Response - Batch")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post VCK Response - Batch';
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if Confirm(Text001, true) then
                            PostRespMgt.PostPurchaseOrderResponse('');
                    end;
                }
            }
            action("Delete Selected")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete Selected';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DeleteSelected;
                end;
            }
            action("Close Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Close Response';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CloseSelected;  // 24-05-19 ZY-LD 002
                end;
            }
            // #493208 >>
            action("Open Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Response';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Openselected;  // 24-05-19 ZY-LD 002
                end;
            }
            // #493208 >>

            action("Update Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Warehouse Status';
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Rec.UpdateWarehouseStatus();  // 04-04-24 ZY-LD 003
                end;
            }

            group("Physical Document")
            {
                Caption = 'Physical Document';
                action("Download Physical Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Download Physical Document';
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.DownloadPhysicalDocument;
                    end;
                }
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
                var
                    FileMgt: Codeunit "File Management";
                    lText001: Label 'Download Document';
                begin
                    if recZyFileMgt.Get(Rec."File Management Entry No.") then
                        FileMgt.DownloadHandler(Rec.Filename, lText001, '', 'PDF(*.pdf)|*.pdf|All files(*.*)|*.*', FileMgt.GetFileName(Rec.Filename));
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

    trigger OnOpenPage()
    begin
        //Rec.SetRange(Rec.Open, true);
    end;

    var
        recZyFileMgt: Record "Zyxel File Management";
        recRcptRespHead: Record "Rcpt. Response Header";
        VCKXML: Codeunit "VCK Communication Management";
        Text001: label 'Do you want to post all incomming responces?';
        Text002: label 'Do you want to post response no. %1? ';
        PostRespMgt: Codeunit "Post Rcpt. Response Mgt.";
        Text003: label 'Do you want to download VCK Outbound?';
        ZGT: Codeunit "ZyXEL General Tools";
        FileMgt: Codeunit "File Management";

    local procedure DeleteSelected()
    var
        recRespHead: Record "Rcpt. Response Header";
        lText001: label 'Do you want to delete %1 line(s)?';
    begin
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count) then begin
            recRespHead.SetAutocalcFields(Open);
            if recRespHead.FindSet(true) then begin
                ZGT.OpenProgressWindow('', recRespHead.Count);
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);
                    recRespHead.Delete(true);
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        end;
    end;

    local procedure CloseSelected()
    var
        recRespHead: Record "Rcpt. Response Header";
        lText001: label 'Do you want to close %1 line(s)?';
        recRespLine: Record "Rcpt. Response Line";
    begin
        //>> 24-05-19 ZY-LD 002
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count) then
            if recRespHead.FindSet then begin
                ZGT.OpenProgressWindow('', recRespHead.Count);
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);

                    recRespLine.SetRange("Response No.", recRespHead."No.");
                    if recRespLine.FindSet(true) then
                        repeat
                            recRespLine.Open := false;
                            recRespLine.Modify(true);
                        until recRespLine.Next() = 0;
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        //<< 24-05-19 ZY-LD 002
    end;

    // 493208 >>    
    local procedure OpenSelected()
    var
        recRespHead: Record "Rcpt. Response Header";
        lText001: label 'Do you want to open %1 line(s)?';
        recRespLine: Record "Rcpt. Response Line";
    begin
        //>> 24-05-19 ZY-LD 002
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count) then
            if recRespHead.FindSet then begin
                ZGT.OpenProgressWindow('', recRespHead.Count);
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);

                    recRespLine.SetRange("Response No.", recRespHead."No.");
                    if recRespLine.FindSet(true) then
                        repeat
                            recRespLine.Open := true;
                            recRespLine.Modify(true);
                        until recRespLine.Next() = 0;
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        //<< 24-05-19 ZY-LD 002
    end;

    // 493208 >>
}
