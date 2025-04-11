codeunit 50034 "Format Address Extension"
{
    procedure DeliveryInvBillTo(var AddrArray: ARRAY[8] of Text[50]; var DelDocHead: Record "VCK Delivery Document Header");
    var
        FormatAddr: Codeunit "Format Address";
    begin
        FormatAddr.FormatAddr(
            AddrArray, DelDocHead."Bill-to Name", DelDocHead."Bill-to Name 2", DelDocHead."Bill-to Contact", DelDocHead."Bill-to Address", DelDocHead."Bill-to Address 2",
            DelDocHead."Bill-to City", DelDocHead."Bill-to Post Code", DelDocHead."Bill-to County", DelDocHead."Bill-to Country/Region Code");
    end;

    procedure DeliveryInvSellTo(var AddrArray: ARRAY[8] of Text[50]; var DelDocHead: Record "VCK Delivery Document Header");
    var
        FormatAddr: Codeunit "Format Address";

    begin
        FormatAddr.FormatAddr(
            AddrArray, DelDocHead."Sell-to Customer Name", DelDocHead."Sell-to Customer Name 2", DelDocHead."Sell-to Contact", DelDocHead."Sell-to Address", DelDocHead."Sell-to Address 2",
            DelDocHead."Sell-to City", DelDocHead."Sell-to Post Code", DelDocHead."Sell-to County", DelDocHead."Sell-to Country/Region Code");
    end;

    procedure DeliveryInvShipTo(var AddrArray: ARRAY[8] of Text[50]; var DelDocHead: Record "VCK Delivery Document Header");
    var
        recCountryShipDay: Record "VCK Country Shipment Days";
        recShiptoAdd: Record "Ship-to Address";
        FormatAddr: Codeunit "Format Address";

    begin
        FormatAddr.FormatAddr(
            AddrArray, DelDocHead."Ship-to Name", DelDocHead."Ship-to Name 2", DelDocHead."Ship-to Contact", DelDocHead."Ship-to Address", DelDocHead."Ship-to Address 2",
            DelDocHead."Ship-to City", DelDocHead."Ship-to Post Code", DelDocHead."Ship-to County", DelDocHead."Ship-to Country/Region Code");
    end;

    procedure DeliveryInvCustomsTo(var AddrArray: ARRAY[8] of Text[50]; var CustomsCustNo: Code[20]);
    var
        recCust: Record Customer;
        recCompInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";

    begin
        recCust.Get(CustomsCustNo);
        FormatAddr.FormatAddr(
            AddrArray, recCust.Name, recCust."Name 2", recCust.Contact, recCust.Address, recCust."Address 2",
            recCust.City, recCust."Post Code", recCust.County, recCust."Country/Region Code");
    end;
}
