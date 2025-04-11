Codeunit 50030 "Warehouse Inventory Request"
{
    // 001. 05-04-22 ZY-LD 000 - VCK does not need a request anymore. They automatic send the inventory count at 01:00 every day.


    trigger OnRun()
    begin
        recAutoSetup.Get;
        if recAutoSetup."Warehouse Inventory" or GuiAllowed then begin
            //>> 05-04-22 ZY-LD 001
            /*recWhseSetup.GET;
            IF recWhseSetup."Latest Inventory Request" < TODAY THEN
              SendRequest;*/
            //<< 05-04-22 ZY-LD 001
            ReadRequest;
        end;

    end;

    var
        recAutoSetup: Record "Automation Setup";

    local procedure SendRequest()
    var
        VckXmlMgt: Codeunit "VCK Communication Management";
    begin
        //>> 05-04-22 ZY-LD 001
        /*VckXmlMgt.SendStockLevelRequest;
        recWhseSetup."Latest Inventory Request" := TODAY;
        recWhseSetup.MODIFY;*/
        //<< 05-04-22 ZY-LD 001

    end;

    local procedure ReadRequest()
    var
        WhseInvRequest: Codeunit "VCK Download and  Import Doc.";
    begin
        WhseInvRequest.DownloadVCK(3, true);
    end;
}
