Page 50297 "Rcpt. Response List"
{


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
                    ToolTip = 'Specifies the unique number of the receipt response document.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the order number that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the warehouse status of the receipt response document.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Indicates whether the receipt response document is open.';
                    Editable = false;
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the cost center that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of order that is associated with the receipt response document.';
                    Editable = false;
                    Visible = false;
                }
                field("Order Type Option"; Rec."Order Type Option")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the order type option that is associated with the receipt response document.';
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the shipment number that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the shipper reference that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Customer Reference"; Rec."Customer Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer reference that is associated with the receipt response document.';
                    Editable = false;
                }
                field("After Post Description"; Rec."After Post Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description after posting that is associated with the receipt response document.';
                }
                field("Customer Message No."; Rec."Customer Message No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer message number that is associated with the receipt response document.';
                    Editable = false;
                }
                field("System Date Time"; Rec."System Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the system date and time of the receipt response document.';
                    Editable = false;
                }
                field("Receipt Date Time"; Rec."Receipt Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the receipt date and time of the receipt response document.';
                    Editable = false;
                }
                field("Posting Date Time"; Rec."Posting Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting date and time of the receipt response document.';
                    Editable = false;
                }
                field("Delivery Terms"; Rec."Delivery Terms")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the delivery terms that are associated with the receipt response document.';
                    Editable = false;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the mode of transport that is associated with the receipt response document.';
                    Editable = false;
                }
                field(Incoterm; Rec.Incoterm)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the incoterm that is associated with the receipt response document.';
                    Editable = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city that is associated with the receipt response document.';
                    Editable = false;
                }
                field(Connote; Rec.Connote)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the consignment note that is associated with the receipt response document.';
                    Editable = false;
                }
                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the carrier that is associated with the receipt response document.';
                    Editable = false;
                }
                field(Colli; Rec.Colli)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of colli that is associated with the receipt response document.';
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the weight that is associated with the receipt response document.';
                    Editable = false;
                }
                field(Volume; Rec.Volume)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the volume that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 1 that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 2 that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 3 that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 4 that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 5 that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 6 that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 7"; Rec."Value 7")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 7 that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 8"; Rec."Value 8")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 8 that is associated with the receipt response document.';
                    Editable = false;
                }
                field("Value 9"; Rec."Value 9")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies value 9 that is associated with the receipt response document.';
                    Editable = false;
                }
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the path and filename of the receipt response document.';
                    Caption = 'Path and Filename';
                    Visible = false;
                }
                field("FileMgt.GetFileName(Filename)"; FileMgt.GetFileName(Rec.Filename))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Filename';
                    ToolTip = 'Specifies the filename of the receipt response document.';
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
                    ToolTip = 'Downloads the VCK Outbound XML file and imports the receipt responses.';
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
                    ToolTip = 'Posts the selected receipt response document.';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
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
                            if Confirm(Text002, true, Rec."No.") then
                                PostRespMgt.PostPurchaseOrderResponse(Rec."No.");
                    end;
                }
                action("Post VCK Response - Batch")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post VCK Response - Batch';
                    ToolTip = 'Posts all incoming receipt response documents.';
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        AutoSetup: Record "Automation Setup";
                        Text004: label 'Warehouse is closed for month end management.\Are you sure that you want to process warehouse?';
                        Text005: label 'You are absolutely sure?';

                    begin
                        if not AutoSetup.WhsePostingAllowed() then begin  //03-11-2025 BK #537578
                            if Confirm(Text004) then
                                if Confirm(Text005) then
                                    PostRespMgt.PostPurchaseOrderResponse('');
                        end else
                            if Confirm(Text001, true) then
                                PostRespMgt.PostPurchaseOrderResponse('');
                    end;
                }
            }
            action("Delete Selected")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete Selected';
                ToolTip = 'Deletes the selected receipt response documents.';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    DeleteSelected();
                end;
            }
            action("Close Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Close Response';
                ToolTip = 'Closes the selected receipt response documents.';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    CloseSelected();
                end;
            }
            // #493208 >>
            action("Open Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Response';
                ToolTip = 'Opens the selected receipt response documents.';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Openselected();
                end;
            }
            // #493208 >>

            action("Update Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Warehouse Status';
                ToolTip = 'Updates the warehouse status of the selected receipt response document.';
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Rec.UpdateWarehouseStatus();
                end;
            }

            group("Physical Document")
            {
                Caption = 'Physical Document';
                action("Download Physical Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Download Physical Document';
                    ToolTip = 'Downloads the physical document associated with the receipt response document.';
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.DownloadPhysicalDocument();
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
                    ToolTip = 'Prints the receipt inbound document associated with the receipt response document.';
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
                ToolTip = 'Opens the File Management Entries page for the file associated with the receipt response document.';
                Image = FiledOverview;
                RunObject = Page "Zyxel File Management Entries";
            }
            action("Show Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Document';
                ToolTip = 'Downloads and opens the receipt response document.';
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
                ToolTip = 'Opens the Warehouse Inbound Card page for the order associated with the receipt response document.';
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
        ZGT: Codeunit "ZyXEL General Tools";
        FileMgt: Codeunit "File Management";

        PostRespMgt: Codeunit "Post Rcpt. Response Mgt.";

        Text001: label 'Do you want to post all incomming responces?';
        Text002: label 'Do you want to post response no. %1? ';
        Text003: label 'Do you want to download VCK Outbound?';

    local procedure DeleteSelected()
    var
        recRespHead: Record "Rcpt. Response Header";
        lText001: label 'Do you want to delete %1 line(s)?';
    begin
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count()) then begin
            recRespHead.SetAutocalcFields(Open);
            if recRespHead.FindSet(true) then begin
                ZGT.OpenProgressWindow('', recRespHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);
                    recRespHead.Delete(true);
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow();
            end;
        end;
    end;

    local procedure CloseSelected()
    var
        recRespHead: Record "Rcpt. Response Header";
        recRespLine: Record "Rcpt. Response Line";
        lText001: label 'Do you want to close %1 line(s)?';
    begin
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count()) then
            if recRespHead.FindSet() then begin
                ZGT.OpenProgressWindow('', recRespHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);

                    recRespLine.SetRange("Response No.", recRespHead."No.");
                    if recRespLine.FindSet(true) then
                        repeat
                            recRespLine.Open := false;
                            recRespLine.Modify(true);
                        until recRespLine.Next() = 0;
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow();
            end;
    end;

    // 493208 >>    
    local procedure OpenSelected()
    var
        recRespHead: Record "Rcpt. Response Header";
        recRespLine: Record "Rcpt. Response Line";
        lText001: label 'Do you want to open %1 line(s)?';

    begin
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count()) then
            if recRespHead.FindSet() then begin
                ZGT.OpenProgressWindow('', recRespHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);

                    recRespLine.SetRange("Response No.", recRespHead."No.");
                    if recRespLine.FindSet(true) then
                        repeat
                            recRespLine.Open := true;
                            recRespLine.Modify(true);
                        until recRespLine.Next() = 0;
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow();
            end;
    end;

    // 493208 >>
}
