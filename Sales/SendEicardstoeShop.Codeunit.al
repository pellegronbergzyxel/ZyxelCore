Codeunit 50043 "Send Eicards to eShop"
{
    // 001. 21-01-21 ZY-LD 000 - It happens that CU50039 gets an error when e-mailing Eicards, and that prevents automation to send Eicards to eShop. To prevent a stop this CU has been made.


    trigger OnRun()
    begin
        if not GuiAllowed then begin
            recAutoSetup.Get;
            if recAutoSetup.SendEicardToEshopAllowed then
                ProcessEiCardLinks.SendEicardToEshop;
        end;
    end;

    var
        recAutoSetup: Record "Automation Setup";
        ProcessEiCardLinks: Codeunit "Process EiCard Links";
}
