codeunit 50058 "Zyxel VCK Download Management"
{
    trigger OnRun()
    var
        ServerEnvironment: Record "Server Environment";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ServerEnvironment.ProductionEnvironment and (ZGT.IsRhq) then
            ProcessWarehouse();
    end;

    local procedure ProcessWarehouse(): Boolean
    var
        PostRcptRespMgt: Codeunit "Post Rcpt. Response Mgt.";
        PostShipRespMgt: Codeunit "Post Ship Response Mgt.";
    begin
        PostRcptRespMgt.DownloadVCK(1, true);
        Commit;
        PostShipRespMgt.DownloadVCK(2, true);
        Commit;
        exit(true);
    end;

}
