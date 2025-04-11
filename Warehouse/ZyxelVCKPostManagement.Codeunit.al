Codeunit 50022 "Zyxel VCK Post Management"
{
    // 001. 05-06-18 ZY-LD 000 - This codeunit is made to handle errors comming from "Process VCK".
    // 002. 03-08-18 ZY-LD 2018080310000081 - We don't want a ticket on all the errors.
    // 003. 01-10-18 ZY-LD 2018100110000169 - Gives a more correct message to the user.
    // 004. 23-11-18 ZY-LD 000 - GUIALLOWED is added to the CU.
    // 005. 02-01-19 ZY-LD 2019010210000075 - We don't want all errors created as a ticket.
    // 006. 21-01-19 ZY-LD 2019010210000075 - We don't want all errors created as a ticket.
    // 007. 30-04-19 ZY-LD 000 - The warehouse manager can stop the posting.
    // 008. 26-09-19 ZY-LD P0310 - Changed to Automation Setup.
    // 009. 29-11-19 ZY-LD 2019112810000052 - Set status to ready.
    // 010. 26-12-19 ZY-LD 2019122310000078 - We don't want all errors created as a ticket.
    // 011. 22-04-20 ZY-LD 000 - Moved logic to sub codeunits by force posting.
    // 012. 29-05-20 ZY-LD 2020052810000034 - We don't want all errors created as a ticket.
    // 013. 20-04-22 ZY-LD 000 - Run only if read permission.

    Permissions = TableData "Automation Setup" = rm;

    trigger OnRun()
    var
        RunPostLine: Boolean;
        ForcePosting: Boolean;
    begin
        //>> 05-06-18 ZY-LD 001
        if recServerEnvironment.ProductionEnvironment and (ZGT.IsRhq) then begin  // 1 = RHQ
            recAutoSetup.Get;
            if GuiAllowed then begin
                //>> 30-04-19 ZY-LD 007
                //>> 26-09-19 ZY-LD 008
                //IF NOT recWhseSetup.WhsePostingAllowed THEN BEGIN
                if not recAutoSetup.WhsePostingAllowed then begin  //<< 26-09-19 ZY-LD 008
                    if Confirm(Text004) then
                        if Confirm(Text005) then begin
                            RunPostLine := true;
                            ForcePosting := true;
                        end;
                end else
                    //<< 30-04-19 ZY-LD 007
                    RunPostLine := Confirm(Text003, true);
            end else
                RunPostLine := recAutoSetup.WhsePostingAllowed;  // 30-04-19 ZY-LD 007  // 26-09-19 ZY-LD 008

            if RunPostLine then
                if not ProcessWarehouse(ForcePosting) then  // 30-04-19 ZY-LD 007
                    if (StrPos(UpperCase(GetLastErrorText), 'ANOTHER USER HAS MODIFIED') <> 0) or  // 03-08-18 ZY-LD 002
                        (StrPos(UpperCase(GetLastErrorText), 'YOU ARE NOT ALLOWED TO POST') <> 0) or  // 02-01-19 ZY-LD 005
                        (StrPos(UpperCase(GetLastErrorText), UpperCase('The activity was deadlocked with another user')) <> 0) or  // 21-01-19 ZY-LD 006
                        (StrPos(UpperCase(GetLastErrorText), UpperCase('Failed to connect to')) <> 0) or  // 26-12-19 ZY-LD 010
                        (StrPos(UpperCase(GetLastErrorText), UpperCase('Please retry the activity')) <> 0)  // 29-05-20 ZY-LD 012
                    then begin
                        if GuiAllowed then
                            Message(GetLastErrorText);
                    end else begin
                        EmailAddMgt.CreateEmailWithBodytext('VCKPOSTLIN', CopyStr(GetLastErrorText, 1, 250), '');
                        EmailAddMgt.Send;
                        if GuiAllowed then
                            Message(Text001, GetLastErrorText);  // 01-10-18 ZY-LD 003
                    end;
        end else
            Error(Text002);
        //<< 05-06-18 ZY-LD 001
    end;

    var
        recServerEnvironment: Record "Server Environment";
        recAutoSetup: Record "Automation Setup";
        EmailAddMgt: Codeunit "E-mail Address Management";
        Text001: label '%1.\ There has been send a ticket to NAV Support.';
        Text002: label 'You can only run "Process VCK" in RHQ production environment.';
        Text003: label 'Do you want to run "Process Warehouse"?';
        ZGT: Codeunit "ZyXEL General Tools";
        Text004: label 'Warehouse is closed for month end management.\Are you sure that you want to process warehouse?';
        Text005: label 'You are absolutely sure?';

    local procedure ProcessWarehouse(ForcePosting: Boolean): Boolean
    var
        recJobQue: Record "Job Queue Entry";
        recRcptRespHead: Record "Rcpt. Response Header";
        recShipRespHead: Record "Ship Response Header";
        PostRcptRespMgt: Codeunit "Post Rcpt. Response Mgt.";
        PostShipRespMgt: Codeunit "Post Ship Response Mgt.";
    begin
        if recRcptRespHead.WritePermission then begin  // 20-04-22 ZY-LD 013
            PostRcptRespMgt.DownloadAndPostPurchaseOrderResponse(ForcePosting);
            Commit;
        end;
        if recShipRespHead.WritePermission then begin  // 20-04-22 ZY-LD 013
            PostShipRespMgt.DownloadAndPostShippingResponse('', ForcePosting);
            Commit;
        end;

        //>> 29-11-19 ZY-LD 009
        if GuiAllowed then begin
            recJobQue.SetRange("Object Type to Run", recJobQue."object type to run"::Codeunit);
            recJobQue.SetRange("Object ID to Run", Codeunit::"Zyxel VCK Post Management");
            if recJobQue.FindFirst and (recJobQue.Status in [recJobQue.Status::Error, recJobQue.Status::"In Process", recJobQue.Status::Finished]) then
                recJobQue.SetStatus(recJobQue.Status::Ready);
        end;
        //<< 29-11-19 ZY-LD 009

        exit(true);
    end;
}
