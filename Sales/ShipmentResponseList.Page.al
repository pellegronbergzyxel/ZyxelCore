Page 50050 "Shipment Response List"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 20-03-23 ZY-LD 000 - Moved to the table.

    ApplicationArea = Basic, Suite;
    Caption = 'Shipment Response List';
    CardPageID = "Shipment Response Card";
    Description = 'Shipment Response List';
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Ship Response Header";
    SourceTableView = sorting("Customer Reference", "Warehouse Status");
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
                field("Import Date"; Rec."Import Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Reference"; Rec."Customer Reference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delivery Document Type"; Rec."Delivery Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Receiver Reference"; Rec."Receiver Reference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Message No."; Rec."Customer Message No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Picking Date Time"; Rec."Picking Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Loading Date Time"; Rec."Loading Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Planned Shipment Date Time"; Rec."Planned Shipment Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Terms"; Rec."Delivery Terms")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Connote; Rec.Connote)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Colli; Rec.Colli)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Volume; Rec.Volume)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Incoterm; Rec.Incoterm)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Actual Shipment Date Time"; Rec."Actual Shipment Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Date Time"; Rec."Delivery Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("System Date Time"; Rec."System Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Posting Date Time"; Rec."Posting Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Mode of Transport 2"; Rec."Mode of Transport 2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Mode Of Transport';
                    Visible = false;
                }
                field("Signed By"; Rec."Signed By")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Remark"; Rec."Delivery Remark")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 7"; Rec."Value 7")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 8"; Rec."Value 8")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 9"; Rec."Value 9")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Carrier Service"; Rec."Carrier Service")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Pallets; Rec.Pallets)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Cartons; Rec.Cartons)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Nett Weight"; Rec."Nett Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container ID"; Rec."Container ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container Type"; Rec."Container Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container Height"; Rec."Container Height")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container Width"; Rec."Container Width")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container Depth"; Rec."Container Depth")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container Volume"; Rec."Container Volume")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container Gross Weight"; Rec."Container Gross Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container New Weight"; Rec."Container New Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Container Customer Reference"; Rec."Container Customer Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoicing Logistic Handling"; Rec."Invoicing Logistic Handling")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoicing Handling Charges"; Rec."Invoicing Handling Charges")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoicing Transport Cost"; Rec."Invoicing Transport Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invocing Fuel Surcharge"; Rec."Invocing Fuel Surcharge")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoicing Air freight"; Rec."Invoicing Air freight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoicing Third Party Cost"; Rec."Invoicing Third Party Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoicing Miscellaneous Cost"; Rec."Invoicing Miscellaneous Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Lines With Error"; Rec."Lines With Error")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. Response Lines"; Rec."Qty. Response Lines")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. Delivery Doc. Lines"; Rec."Qty. Delivery Doc. Lines")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("After Post Description"; Rec."After Post Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Forecast Territory"; Rec."Forecast Territory")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship Posted"; Rec."Ship Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Receipt Posted"; Rec."Receipt Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control4; "VCK Ship Resp. SNos FaxtBox")
            {
                Caption = 'Serial No.';
                SubPageLink = "Response No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Download and Import")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download and Import';
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm(Text003, true) then begin
                        PostRespMgt.DownloadVCK(2, true);
                        CurrPage.Update();
                    end;
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
                        PostRespMgt.PostShippingOrderResponse(Rec."No.");
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
                        PostRespMgt.PostShippingOrderResponse('');
                end;
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
            group("Report")
            {
                Caption = 'Report';
                action("Serial No. Difference List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Serial No. Difference List';
                    Image = "Report";

                    trigger OnAction()
                    var
                        recShipRespHead: Record "Ship Response Header";
                    begin
                        recShipRespHead.SetRange("No.", Rec."No.");
                        Report.Run(Report::"Identify Identical Serial No.", true, true, recShipRespHead);
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
                    Rec.ShowResponseFile;
                    // IF recZyFileMgt.GET("File Management Entry No.") THEN
                    //  HYPERLINK(recZyFileMgt.Filename);
                end;
            }
            action("Show Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Delivery Document';
                Image = Document;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Customer Reference");
            }
        }
    }

    var
        recZyFileMgt: Record "Zyxel File Management";
        VCKXML: Codeunit "VCK Communication Management";
        Text001: label 'Do you want to post all incoming responces?';
        Text002: label 'Do you want to post response no. %1? ';
        Text003: label 'Do you want to download VCK Outbound?';
        PostRespMgt: Codeunit "Post Ship Response Mgt.";
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure DeleteSelected()
    var
        recRespHead: Record "Ship Response Header";
        lText001: label 'Do you want to delete %1 lines?';
    begin
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count) then
            if recRespHead.FindSet(true) then begin
                ZGT.OpenProgressWindow('', recRespHead.Count);
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);
                    recRespHead.Delete(true);
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
    end;

    local procedure CloseSelected()
    var
        recRespHead: Record "Ship Response Header";
        lText001: label 'Do you want to close %1 line(s)?';
        recRespLine: Record "Ship Response Line";
    begin
        //>> 24-05-19 ZY-LD 002
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count) then
            if recRespHead.FindSet then begin
                ZGT.OpenProgressWindow('', recRespHead.Count);
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);

                    //>> 20-03-23 ZY-LD 002
                    /*recRespLine.SETRANGE("Response No.",recRespHead."No.");
                    IF recRespLine.FINDSET(TRUE) THEN
                      REPEAT
                        recRespLine.Open := FALSE;
                        recRespLine.MODIFY(TRUE);
                      UNTIL recRespLine.Next() = 0;*/
                    recRespHead.CloseResponse;
                //<< 20-03-23 ZY-LD 002
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        //<< 24-05-19 ZY-LD 002

    end;
}
