Codeunit 62015 "Create and Release Whse. Inbou"
{
    // 001. 27-10-20 ZY-LD 2020101610000298 - Release only automatic created inbound headers.
    // 002. 09-03-21 ZY-LD 2021030910000223 - Release has moved to a codeunit.


    trigger OnRun()
    begin
        recAutoSetup.Get;
        if recAutoSetup.WhseCreateAndReleaseInbound then begin
            CreateWhseInboundOrder;
            ReleaseWhseInboundOrder;
        end;
    end;

    var
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure CreateWhseInboundOrder(): Boolean
    begin
        Report.RunModal(Report::"Create Whse. Inbound Order", false);
    end;


    procedure ReleaseWhseInboundOrder()
    var
        recWhseInbHead: Record "Warehouse Inbound Header";
        recAutoSetup: Record "Automation Setup";
        recVend: Record Vendor;
    begin
        begin
            recAutoSetup.Get;
            if recAutoSetup.WhseCreateAndReleaseInbound then begin
                recWhseInbHead.SetRange(recWhseInbHead."Sent To Warehouse", false);
                recWhseInbHead.SetRange(recWhseInbHead."Automatic Created", true);  // 27-10-20 ZY-LD 001
                if recWhseInbHead.FindSet(true) then begin
                    ZGT.OpenProgressWindow('', recWhseInbHead.Count);
                    repeat
                        ZGT.UpdateProgressWindow(recWhseInbHead."No.", 0, true);
                        case recWhseInbHead."Order Type" of
                            recWhseInbHead."order type"::"Purchase Order":
                                begin
                                    recVend.Get(recWhseInbHead."Sender No.");
                                    if recAutoSetup."Release HQ Warehouse Inbound" and (recWhseInbHead."Estimated Date of Arrival" <> 0D) then
                                        if (recVend."SBU Company" in [recVend."sbu company"::"ZCom HQ", recVend."sbu company"::"ZNet HQ"]) and
                                           (CalcDate(recAutoSetup."Release HQ Whse. Indb. DateF.", recWhseInbHead."Estimated Date of Arrival") <= Today)
                                        then
                                            Codeunit.Run(Codeunit::"Release Warehouse Inbound", recWhseInbHead);  // 09-03-21 ZY-LD 002
                                                                                                                  //OLDRelease(TRUE);  // 09-03-21 ZY-LD 002

                                    if recAutoSetup."Release EMEA Whse. Inbound" and
                                        (recVend."SBU Company" in [recVend."sbu company"::" ", recVend."sbu company"::"ZCom EMEA", recVend."sbu company"::"ZNet EMEA"])
                                    then
                                        Codeunit.Run(Codeunit::"Release Warehouse Inbound", recWhseInbHead);  // 09-03-21 ZY-LD 002
                                                                                                              //OLDRelease(TRUE);  // 09-03-21 ZY-LD 002
                                end;
                            recWhseInbHead."order type"::"Sales Return Order":
                                if recAutoSetup."Release Return Order Whse Inb." then
                                    Codeunit.Run(Codeunit::"Release Warehouse Inbound", recWhseInbHead);  // 09-03-21 ZY-LD 002
                                                                                                          //OLDRelease(TRUE);  // 09-03-21 ZY-LD 002
                            recWhseInbHead."order type"::"Transfer Order":
                                if recAutoSetup."Release Transf Order Whse Inb." then
                                    Codeunit.Run(Codeunit::"Release Warehouse Inbound", recWhseInbHead);
                        end;
                    until recWhseInbHead.Next() = 0;
                    ZGT.CloseProgressWindow;
                end;
            end;
        end;
    end;
}
