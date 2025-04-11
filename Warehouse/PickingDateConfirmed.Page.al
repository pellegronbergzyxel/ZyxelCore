Page 50004 "Picking Date Confirmed"
{
    // 001. 05-10-21 ZY-LD 2021100510000057 - We have seen that "Picking Date" exist eventhough the sales order line has been deleted.

    Caption = 'Picking Date Confirmed';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Picking Date Confirmed";
    SourceTableView = sorting("Country Code", "Picking Date");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding Quantity (Base)"; Rec."Outstanding Quantity (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Picking Date"; Rec."Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Picking Date Confirmed"; Rec."Picking Date Confirmed")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comment; Rec.Comment)
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
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control14; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("Item No."),
                              "Location Filter" = field("Location Code");
            }
            part(Control17; "Sales Line FactBox")
            {
                SubPageLink = "Document Type" = const(Order),
                              "Document No." = field("Source No."),
                              "Line No." = field("Source Line No.");
                Visible = ShowSalesOrderFactBox;
            }
            part(Control18; "Transfer Line FactBox")
            {
                SubPageLink = "Document No." = field("Source No."),
                              "Line No." = field("Source Line No.");
                Visible = ShowTransOrderFactBox;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+Ctrl+E';

                trigger OnAction()
                begin
                    ShowDocument;
                end;
            }
        }
        area(processing)
        {
            action("Update Picking Date Confirmed")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Picking Date Confirmed';
                Image = UpdateShipment;
                Visible = VisibleForDevelopers;

                trigger OnAction()
                begin
                    UpdatePickingDateConfirmed;
                end;
            }
            action("Update Country Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Country Code';
                Image = UpdateDescription;
                Visible = VisibleForDevelopers;

                trigger OnAction()
                begin
                    UpdateCountryCode;
                end;
            }
            group(Mark)
            {
                Caption = 'Mark';
                action("Unmark Selected Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unmark Selected Entries';
                    Image = StepOut;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = UnMarkSelectedEntriesVisible;

                    trigger OnAction()
                    begin
                        MarkEntries(0);
                    end;
                }
                action("Mark Selected Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Mark Selected Entries';
                    Image = StepInto;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = MarkSelectedEntriesVisible;

                    trigger OnAction()
                    begin
                        MarkEntries(1);
                    end;
                }
            }
            group("Order")
            {
                Caption = 'Order';
                action(Autoconfirm)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Auto Confirm';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = AutoConfirmVisible;

                    trigger OnAction()
                    var
                        AutoConfirm: Codeunit "Pick. Date Confirm Management";
                        SI: Codeunit "Single Instance";
                        SaveValidateFromPage: Boolean;
                    begin
                        if AutoConfirm.PerformManuelConfirm(0, '') then begin
                            SaveValidateFromPage := SI.GetValidateFromPage;
                            SI.SetValidateFromPage(false);
                            AutoConfirm.Run(Rec);
                            SI.SetValidateFromPage(SaveValidateFromPage);
                        end;
                    end;
                }
                action("Set New Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set New Picking Date';
                    Image = PickLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = SetNewPickingDateVisible;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(recPickDateConf);
                        Rec.UpdatePickingDate(recPickDateConf);
                        CurrPage.Update(false);
                    end;
                }
                action("Delete Order Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delete Order Lines';
                    Image = DeleteQtyToHandle;
                    Visible = DeleteSalesOrderLineVisible;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(recPickDateConf);
                        Rec.DeleteSalesOrderLines(recPickDateConf);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Confirmation Backlog")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Confirmation Backlog';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Confirmation Backlog";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //>> 05-10-21 ZY-LD 001
        case Rec."Source Type" of
            Rec."source type"::"Sales Order":
                if recSalesLine.Get(recSalesLine."document type"::Order, Rec."Source No.", Rec."Source Line No.") then
                    Error(Text001, recSalesLine.TableCaption);
            Rec."source type"::"Transfer Order":
                if recTransferLine.Get(Rec."Source No.", Rec."Source Line No.") then
                    Error(Text001, recTransferLine.TableCaption);
        end;
        //<< 05-10-21 ZY-LD 001
    end;

    trigger OnOpenPage()
    begin
        VisibleForDevelopers := ZGT.UserIsDeveloper;

        UnMarkSelectedEntriesVisible := UpperCase(Rec.GetFilter(Rec."Marked Entry")) = 'YES';
        MarkSelectedEntriesVisible := not UnMarkSelectedEntriesVisible;
        AutoConfirmVisible := UpperCase(Rec.GetFilter(Rec."Picking Date Confirmed")) in ['', 'NO'];
        SetNewPickingDateVisible := (UpperCase(Rec.GetFilter(Rec."Marked Entry")) in ['', 'NO']) and (UpperCase(Rec.GetFilter(Rec."Picking Date Confirmed")) in ['', 'NO']);
        SetActions;
    end;

    var
        recPickDateConf: Record "Picking Date Confirmed";
        recSalesLine: Record "Sales Line";
        recTransferLine: Record "Transfer Line";
        recUserSetup: Record "User Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        ShowSalesOrderFactBox: Boolean;
        ShowTransOrderFactBox: Boolean;
        VisibleForDevelopers: Boolean;
        MarkSelectedEntriesVisible: Boolean;
        UnMarkSelectedEntriesVisible: Boolean;
        AutoConfirmVisible: Boolean;
        SetNewPickingDateVisible: Boolean;
        DeleteSalesOrderLineVisible: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        Text001: label 'You can not delete lines if "%1" exists.';

    local procedure ShowDocument()
    var
        recSalesHead: Record "Sales Header";
        recTransHead: Record "Transfer Header";
    begin
        case Rec."Source Type" of
            Rec."source type"::"Sales Order":
                begin
                    recSalesHead.Get(recSalesHead."document type"::Order, Rec."Source No.");
                    Page.Run(Page::"Sales Order", recSalesHead);
                end;
            Rec."source type"::"Transfer Order":
                begin
                    recTransHead.Get(Rec."Source No.");
                    Page.Run(Page::"Transfer Order", recTransHead);
                end;
        end;
    end;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        ShowSalesOrderFactBox := Rec."Source Type" = Rec."source type"::"Sales Order";
        ShowTransOrderFactBox := Rec."Source Type" = Rec."source type"::"Transfer Order";
        if recUserSetup.Get(UserId()) then
            DeleteSalesOrderLineVisible := recUserSetup.SCM or ZGT.UserIsDeveloper;
    end;

    local procedure MarkEntries(Type: Integer)
    var
        lText001: label 'Do you want to mark the selected (%1) entries?';
        recPickDateConf: Record "Picking Date Confirmed";
        SelectedQty: Integer;
        UpdateSelected: Boolean;
    begin
        CurrPage.SetSelectionFilter(recPickDateConf);
        SelectedQty := recPickDateConf.Count;
        if SelectedQty > 1 then
            UpdateSelected := Confirm(lText001, true, SelectedQty)
        else
            UpdateSelected := true;

        if UpdateSelected then begin
            if recPickDateConf.FindSet(true) then
                repeat
                    Evaluate(recPickDateConf."Marked Entry", Format(Type));
                    recPickDateConf.Modify(true);
                until recPickDateConf.Next() = 0;

            CurrPage.Update;
        end;
    end;

    local procedure UpdatePickingDateConfirmed()
    var
        recSalesLine: Record "Sales Line";
        recTransLine: Record "Transfer Line";
        recPickDateConf: Record "Picking Date Confirmed";
        lText001: label 'Do you want to update "Picking Date Confirmed"?';
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
    begin
        if Confirm(lText001, true) then begin
            recPickDateConf.DeleteAll;

            recSalesLine.SetCurrentkey("Document Type", "Document No.", "Qty. Shipped Not Invoiced");
            recSalesLine.SetRange("Document Type", recSalesLine."document type"::Order);
            recSalesLine.SetRange("Completely Shipped", false);
            recSalesLine.SetFilter("Outstanding Quantity", '<>0');
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            recSalesLine.SetFilter("No.", '<>%1', '');
            recSalesLine.SetRange("BOM Line No.", 0);
            recSalesLine.SetRange("Additional Item Line No.", 0);
            recSalesLine.SetFilter("Location Code", ItemLogisticEvents.GetRequireShipmentLocations);
            recSalesLine.SetAutocalcFields("Order Date");
            if recSalesLine.FindSet then begin
                ZGT.OpenProgressWindow('', recSalesLine.Count);
                repeat
                    ZGT.UpdateProgressWindow(recSalesLine."Document No.", 0, true);

                    recPickDateConf."Source No." := recSalesLine."Document No.";
                    recPickDateConf."Source Line No." := recSalesLine."Line No.";
                    recPickDateConf."Item No." := recSalesLine."No.";
                    recPickDateConf."Outstanding Quantity" := recSalesLine."Outstanding Quantity";
                    recPickDateConf."Outstanding Quantity (Base)" := recSalesLine."Outstanding Qty. (Base)";
                    recPickDateConf."Picking Date Confirmed" := recSalesLine."Shipment Date Confirmed";
                    recPickDateConf."Location Code" := recSalesLine."Location Code";
                    recPickDateConf."Picking Date" := recSalesLine."Shipment Date";
                    if recSalesLine."Order Date" = Today then
                        recPickDateConf."Marked Entry" := not recSalesLine."Shipment Date Confirmed"
                    else
                        recPickDateConf."Marked Entry" := false;
                    recPickDateConf.Insert;
                until recSalesLine.Next() = 0;
                ZGT.CloseProgressWindow;
            end;

            recTransLine.SetRange("Completely Shipped", false);
            recTransLine.SetFilter("Outstanding Quantity", '<>0');
            recTransLine.SetFilter("Item No.", '<>%1', '');
            recTransLine.SetRange("Additional Item Line No.", 0);
            recTransLine.SetFilter("Transfer-from Code", ItemLogisticEvents.GetRequireShipmentLocations);
            if recTransLine.FindSet then
                repeat
                    recPickDateConf."Source Type" := recPickDateConf."source type"::"Transfer Order";
                    recPickDateConf."Source No." := recTransLine."Document No.";
                    recPickDateConf."Source Line No." := recTransLine."Line No.";
                    recPickDateConf."Item No." := recTransLine."Item No.";
                    recPickDateConf."Outstanding Quantity" := recTransLine."Outstanding Quantity";
                    recPickDateConf."Outstanding Quantity (Base)" := recTransLine."Outstanding Qty. (Base)";
                    recPickDateConf."Picking Date Confirmed" := recTransLine."Shipment Date Confirmed";
                    recPickDateConf."Location Code" := recTransLine."Transfer-from Code";
                    recPickDateConf."Picking Date" := recTransLine."Shipment Date";
                    recPickDateConf."Marked Entry" := not recTransLine."Shipment Date Confirmed";
                    recPickDateConf.Insert;
                until recTransLine.Next() = 0;
        end;
    end;


    procedure UpdateCountryCode()
    var
        recPickDateConf: Record "Picking Date Confirmed";
        recSalesLine: Record "Sales Line";
        recTransferLine: Record "Transfer Line";
        lText001: label 'Do you want to update "Picking Date Confirmed"?';
    begin
        if Confirm(lText001, true) then begin
            recPickDateConf.SetFilter("Country Code", '%1', '');
            if recPickDateConf.FindSet(true) then
                repeat
                    case recPickDateConf."Source Type" of
                        recPickDateConf."source type"::"Sales Order":
                            if recSalesLine.Get(recSalesLine."document type"::Order, recPickDateConf."Source No.", recPickDateConf."Source Line No.") then begin
                                recSalesLine.ShowShortcutDimCode(ShortcutDimCode);
                                recPickDateConf."Country Code" := ShortcutDimCode[3];
                                recPickDateConf.Modify;
                            end;
                        recPickDateConf."source type"::"Transfer Order":
                            if recTransferLine.Get(recPickDateConf."Source No.", recPickDateConf."Source Line No.") then begin
                                recTransferLine.ShowShortcutDimCode(ShortcutDimCode);
                                recPickDateConf."Country Code" := ShortcutDimCode[3];
                                recPickDateConf.Modify;
                            end;
                    end;

                    recPickDateConf."Country Code" := ShortcutDimCode[3];
                    recPickDateConf.Modify;
                until recPickDateConf.Next() = 0;
        end;
    end;
}
