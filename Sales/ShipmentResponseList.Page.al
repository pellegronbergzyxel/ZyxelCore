Page 50050 "Shipment Response List"
{

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
                    ToolTip = 'Specify the No';
                }
                field("Import Date"; Rec."Import Date")
                {
                    ToolTip = 'Specify the Import Date';
                    ApplicationArea = Basic, Suite;
                }
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specify the Order No.';
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Reference"; Rec."Customer Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Customer Reference';
                }
                field("Delivery Document Type"; Rec."Delivery Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Delivery Document Type';
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Warehouse Status';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Status';
                    Visible = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Open';
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Cost Center';
                    Visible = false;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Order Type';
                    Visible = false;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Shipment No.';
                    Visible = false;
                }
                field("Receiver Reference"; Rec."Receiver Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Receiver Reference';
                }
                field("Customer Message No."; Rec."Customer Message No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Customer Message No.';
                    Visible = false;
                }
                field("Picking Date Time"; Rec."Picking Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Picking Date Time';
                    Visible = false;
                }
                field("Loading Date Time"; Rec."Loading Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Loading Date Time';
                    Visible = false;
                }
                field("Planned Shipment Date Time"; Rec."Planned Shipment Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Planned Shipment Date Time';
                    Visible = false;
                }
                field("Delivery Terms"; Rec."Delivery Terms")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Delivery Terms';
                    Visible = false;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Mode of Transport';
                    Visible = false;
                }
                field(Connote; Rec.Connote)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Connote';
                    Visible = false;
                }
                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Carrier';
                }
                field(Colli; Rec.Colli)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Colli';
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Weight';
                }
                field(Volume; Rec.Volume)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Volume';
                }
                field(Incoterm; Rec.Incoterm)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Incoterm';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the City';
                }
                field("Actual Shipment Date Time"; Rec."Actual Shipment Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Actual Shipment Date Time';
                }
                field("Delivery Date Time"; Rec."Delivery Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Delivery Date Time';
                }
                field("System Date Time"; Rec."System Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the System Date Time';
                }
                field("Posting Date Time"; Rec."Posting Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Posting Date Time';
                }
                field("Mode of Transport 2"; Rec."Mode of Transport 2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Mode Of Transport';
                    Visible = false;
                    ToolTip = 'Specify the Mode Of Transport';
                }
                field("Signed By"; Rec."Signed By")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify who Signed By';
                }
                field("Delivery Remark"; Rec."Delivery Remark")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Delivery Remark';
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Delivery Status';
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 1';
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 2';
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 3';
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 4';
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 5';
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 6';
                }
                field("Value 7"; Rec."Value 7")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 7';
                }
                field("Value 8"; Rec."Value 8")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 8';
                }
                field("Value 9"; Rec."Value 9")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify Value 9';
                }
                field("Carrier Service"; Rec."Carrier Service")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Carrier Service';
                }
                field(Pallets; Rec.Pallets)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Pallets';
                }
                field(Cartons; Rec.Cartons)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Cartons';
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Gross Weight';
                }
                field("Nett Weight"; Rec."Nett Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Nett Weight';
                }
                field("Container ID"; Rec."Container ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container ID';
                }
                field("Container Type"; Rec."Container Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container Type';
                }
                field("Container Height"; Rec."Container Height")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container Height';
                }
                field("Container Width"; Rec."Container Width")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container Width';
                }
                field("Container Depth"; Rec."Container Depth")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container Depth';
                }
                field("Container Volume"; Rec."Container Volume")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container Volume';
                }
                field("Container Gross Weight"; Rec."Container Gross Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container Gross Weight';
                }
                field("Container New Weight"; Rec."Container New Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container New Weight';
                }
                field("Container Customer Reference"; Rec."Container Customer Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Container Customer Reference';
                }
                field("Invoicing Logistic Handling"; Rec."Invoicing Logistic Handling")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Invoicing Logistic Handling';
                }
                field("Invoicing Handling Charges"; Rec."Invoicing Handling Charges")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Invoicing Handling Charges';
                }
                field("Invoicing Transport Cost"; Rec."Invoicing Transport Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Invoicing Transport Cost';
                }
                field("Invocing Fuel Surcharge"; Rec."Invocing Fuel Surcharge")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Invoicing Fuel Surcharge';
                }
                field("Invoicing Air freight"; Rec."Invoicing Air freight")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Invoicing Air freight';
                }
                field("Invoicing Third Party Cost"; Rec."Invoicing Third Party Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Invoicing Third Party Cost';
                }
                field("Invoicing Miscellaneous Cost"; Rec."Invoicing Miscellaneous Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Invoicing Miscellaneous Cost';
                }
                field("Lines With Error"; Rec."Lines With Error")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Lines With Error';
                }
                field("Qty. Response Lines"; Rec."Qty. Response Lines")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Qty. Response Lines';
                }
                field("Qty. Delivery Doc. Lines"; Rec."Qty. Delivery Doc. Lines")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the Qty. Delivery Doc. Lines';
                }
                field("After Post Description"; Rec."After Post Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the After Post Description';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Sell-to Customer No.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Sell-to Customer Name';
                }
                field("Forecast Territory"; Rec."Forecast Territory")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Forecast Territory';
                }
                field("Ship Posted"; Rec."Ship Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Ship Posted';
                }
                field("Receipt Posted"; Rec."Receipt Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specify the Receipt Posted';
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
                ToolTip = 'Specify the Download and Import';
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

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
                ToolTip = 'Specify the Post VCK Response';
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
                                PostRespMgt.PostShippingOrderResponse(Rec."No.");
                    end else
                        if Confirm(Text002, true, Rec."No.") then
                            PostRespMgt.PostShippingOrderResponse(Rec."No.");
                end;
            }
            action("Post VCK Response - Batch")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post VCK Response - Batch';
                ToolTip = 'Specify the Post VCK Response - Batch';
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
                                PostRespMgt.PostShippingOrderResponse('');
                    end else
                        if Confirm(Text001, true) then
                            PostRespMgt.PostShippingOrderResponse('');
                end;
            }
            action("Delete Selected")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete Selected';
                ToolTip = 'Specify the Delete Selected';
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
                ToolTip = 'Specify the Close Response';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    CloseSelected();
                end;
            }
            group("Report")
            {
                Caption = 'Report';
                action("Serial No. Difference List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Serial No. Difference List';
                    ToolTip = 'Specify the Serial No. Difference List';
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
                    Rec.ShowResponseFile();

                end;
            }
            action("Show Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Delivery Document';
                ToolTip = 'Specify the Show Delivery Document';
                Image = Document;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Customer Reference");
            }
        }
    }

    var
        PostRespMgt: Codeunit "Post Ship Response Mgt.";
        ZGT: Codeunit "ZyXEL General Tools";

        Text001: label 'Do you want to post all incoming responces?';
        Text002: label 'Do you want to post response no. %1? ';
        Text003: label 'Do you want to download VCK Outbound?';

    local procedure DeleteSelected()
    var
        recRespHead: Record "Ship Response Header";
        lText001: label 'Do you want to delete %1 lines?';
    begin
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count()) then
            if recRespHead.FindSet(true) then begin
                ZGT.OpenProgressWindow('', recRespHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);
                    recRespHead.Delete(true);
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow();
            end;
    end;

    local procedure CloseSelected()
    var
        recRespHead: Record "Ship Response Header";
        lText001: label 'Do you want to close %1 line(s)?';

    begin
        CurrPage.SetSelectionFilter(recRespHead);
        if Confirm(lText001, false, recRespHead.Count()) then
            if recRespHead.FindSet() then begin
                ZGT.OpenProgressWindow('', recRespHead.Count());
                repeat
                    ZGT.UpdateProgressWindow(Rec."No.", 0, true);
                    recRespHead.CloseResponse();
                until recRespHead.Next() = 0;
                ZGT.CloseProgressWindow();
            end;
    end;
}
