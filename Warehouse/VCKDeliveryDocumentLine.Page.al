Page 50100 "VCK Delivery Document Line"
{
    ApplicationArea = Basic, Suite;
    Caption = 'VCK Delivery Document Line';
    Editable = false;
    PageType = List;
    SourceTable = "VCK Delivery Document Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    DrillDown = false;
                    Editable = false;
                    Lookup = false;

                    trigger OnAssistEdit()
                    var
                        recItem: Record Item;
                    begin

                        recItem.SetFilter("No.", Rec."Item No.");
                        Page.RunModal(30, recItem)
                    end;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ignore In Posting"; Rec."Ignore In Posting")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        recSalesHeader: Record "Sales Header";
                    begin

                        recSalesHeader.SetFilter("No.", Rec."Sales Order No.");
                        if not recSalesHeader.FindFirst then Error(Text0001);
                        Page.RunModal(42, recSalesHeader)
                    end;
                }
                field("Customer Order No."; Rec."Customer Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Action Code"; Rec."Action Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Has Serial No"; Rec."Has Serial No")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Picking Date Time"; Rec."Picking Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Loading Date Time"; Rec."Loading Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Date Time"; Rec."Delivery Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Remark"; Rec."Delivery Remark")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Receiver Reference"; Rec."Receiver Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Signed By"; Rec."Signed By")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Deliv. Doc. No. on Sales Line"; Rec."Deliv. Doc. No. on Sales Line")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Card)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Card';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Document No.");
            }
            action(moveline)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Move to another delivery document';
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    movedeliverydocline: page "Move delivery document line";
                begin
                    if not isDeveloper then
                        error('Only admininistrator');
                    movedeliverydocline.SetRecord(rec);
                    movedeliverydocline.RunModal();
                    CurrPage.Update(false);


                end;

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DocumentNoOnFormat;
        ItemNoOnFormat;
        DescriptionOnFormat;
        QuantityOnFormat;
        UnitPriceOnFormat;
        LocationOnFormat;
        SalesOrderNoOnFormat;
        CustomerOrderNoOnFormat;
        WarehouseStatusOnFormat;
        ActionCodeOnFormat;
        TransferOrderNoOnFormat;
        CurrencyCodeOnFormat;
        PickingDateTimeOnFormat;
        LoadingDateTimeOnFormat;
        DeliveryDateTimeOnFormat;
        DeliveryRemarkOnFormat;
        DeliveryStatusOnFormat;
        ReceiverReferenceOnFormat;
        ShipperReferenceOnFormat;
        SignedByOnFormat;
    end;

    trigger OnOpenPage()
    begin
        if UserId() = 'pbowden' then
            PostSingleShipbyDeliveryVisibl := true;

        if UserId() = 'rdomany' then
            PostSingleShipbyDeliveryVisibl := true;
    end;

    var
        MakeBold: Boolean;
        Color: Integer;
        [InDataSet]
        PostSingleShipbyDeliveryVisibl: Boolean;
        [InDataSet]
        "Document No.Emphasize": Boolean;
        [InDataSet]
        "Item No.Emphasize": Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        QuantityEmphasize: Boolean;
        [InDataSet]
        "Unit PriceEmphasize": Boolean;
        [InDataSet]
        LocationEmphasize: Boolean;
        [InDataSet]
        "Sales Order No.Emphasize": Boolean;
        [InDataSet]
        "Customer Order No.Emphasize": Boolean;
        [InDataSet]
        "Warehouse StatusEmphasize": Boolean;
        [InDataSet]
        "Action CodeEmphasize": Boolean;
        [InDataSet]
        "Transfer Order No.Emphasize": Boolean;
        [InDataSet]
        "Currency CodeEmphasize": Boolean;
        [InDataSet]
        "Picking Date TimeEmphasize": Boolean;
        [InDataSet]
        "Loading Date TimeEmphasize": Boolean;
        [InDataSet]
        "Delivery Date TimeEmphasize": Boolean;
        [InDataSet]
        "Delivery RemarkEmphasize": Boolean;
        [InDataSet]
        "Delivery StatusEmphasize": Boolean;
        [InDataSet]
        "Receiver ReferenceEmphasize": Boolean;
        [InDataSet]
        "Shipper ReferenceEmphasize": Boolean;
        [InDataSet]
        "Signed ByEmphasize": Boolean;
        Text0001: label 'The Sales Order can no longer be viewed.';

        isDeveloper: Boolean;

        zyxeltool: Codeunit "ZyXEL General Tools";

    trigger OnInit()
    var

    begin
        isDeveloper := zyxeltool.UserIsDeveloper();

    end;



    procedure CheckStatus()
    begin
        MakeBold := false;
        Color := 0;
        if Rec."Warehouse Status" = Rec."warehouse status"::Error then begin
            MakeBold := true;
            Color := 255;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Backorder then begin
            MakeBold := true;
            Color := 16711680;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Ready to Pick" then begin
            MakeBold := true;
            Color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Picking then begin
            MakeBold := true;
            Color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Packed then begin
            MakeBold := true;
            Color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Waiting for invoice" then begin
            MakeBold := true;
            Color := 255;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Invoice Received" then begin
            MakeBold := true;
            Color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Posted then begin
            MakeBold := true;
            Color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"In Transit" then begin
            MakeBold := true;
            Color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Delivered then begin
            MakeBold := true;
            Color := 32768;
        end;
    end;

    local procedure DocumentNoOnFormat()
    begin
        CheckStatus;
        "Document No.Emphasize" := MakeBold;
    end;

    local procedure ItemNoOnFormat()
    begin
        CheckStatus;
        "Item No.Emphasize" := MakeBold;
    end;

    local procedure DescriptionOnFormat()
    begin
        CheckStatus;
        DescriptionEmphasize := MakeBold;
    end;

    local procedure QuantityOnFormat()
    begin
        CheckStatus;
        QuantityEmphasize := MakeBold;
    end;

    local procedure UnitPriceOnFormat()
    begin
        CheckStatus;
        "Unit PriceEmphasize" := MakeBold;
    end;

    local procedure LocationOnFormat()
    begin
        CheckStatus;
        LocationEmphasize := MakeBold;
    end;

    local procedure SalesOrderNoOnFormat()
    begin
        CheckStatus;
        "Sales Order No.Emphasize" := MakeBold;
    end;

    local procedure CustomerOrderNoOnFormat()
    begin
        CheckStatus;
        "Customer Order No.Emphasize" := MakeBold;
    end;

    local procedure WarehouseStatusOnFormat()
    begin
        CheckStatus;
        "Warehouse StatusEmphasize" := MakeBold;
    end;

    local procedure ActionCodeOnFormat()
    begin
        CheckStatus;
        "Action CodeEmphasize" := MakeBold;
    end;

    local procedure TransferOrderNoOnFormat()
    begin
        CheckStatus;
        "Transfer Order No.Emphasize" := MakeBold;
    end;

    local procedure CurrencyCodeOnFormat()
    begin
        CheckStatus;
        "Currency CodeEmphasize" := MakeBold;
    end;

    local procedure PickingDateTimeOnFormat()
    begin
        CheckStatus;
        "Picking Date TimeEmphasize" := MakeBold;
    end;

    local procedure LoadingDateTimeOnFormat()
    begin
        CheckStatus;
        "Loading Date TimeEmphasize" := MakeBold;
    end;

    local procedure DeliveryDateTimeOnFormat()
    begin
        CheckStatus;
        "Delivery Date TimeEmphasize" := MakeBold;
    end;

    local procedure DeliveryRemarkOnFormat()
    begin
        CheckStatus;
        "Delivery RemarkEmphasize" := MakeBold;
    end;

    local procedure DeliveryStatusOnFormat()
    begin
        CheckStatus;
        "Delivery StatusEmphasize" := MakeBold;
    end;

    local procedure ReceiverReferenceOnFormat()
    begin
        CheckStatus;
        "Receiver ReferenceEmphasize" := MakeBold;
    end;

    local procedure ShipperReferenceOnFormat()
    begin
        CheckStatus;
        "Shipper ReferenceEmphasize" := MakeBold;
    end;

    local procedure SignedByOnFormat()
    begin
        CheckStatus;
        "Signed ByEmphasize" := MakeBold;
    end;
}
