xmlport 50042 "HQ ETA Update"
{
    Caption = 'HQ ETA Update';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/eta';
    Direction = Import;
    Encoding = UTF8;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;



    schema
    {
        textelement(root)
        {
            tableelement(VCKShippingDetail; "VCK Shipping Detail")
            {
                XmlName = 'Line';
                UseTemporary = true;
                fieldelement(BillOfLadingNo; VCKShippingDetail."Bill of Lading No.") { }
                fieldelement(ETADate; VCKShippingDetail.tobeEta) { }

                trigger OnBeforeInsertRecord()
                begin
                    LiNo += 1;
                    VCKShippingDetail."Entry No." := LiNo;
                end;
            }
        }
    }

    var
        LiNo: Integer;

    procedure UpdateData()
    var
        ContDetail: Record "VCK Shipping Detail";
        AutomationSetup: Record "Automation Setup";
    begin
        AutomationSetup.get();
        if VCKShippingDetail.FindSet() then
            repeat
                if (VCKShippingDetail."Bill of Lading No." <> '') and (VCKShippingDetail.tobeEta <> 0D) then begin
                    ContDetail.SetRange("Bill of Lading No.", VCKShippingDetail."Bill of Lading No.");
                    if ContDetail.findset then
                        repeat
                            // #490711
                            IF not AutomationSetup.ContainerEtaProdMode then
                                ContDetail.validate(tobeEta, VCKShippingDetail.tobeEta)
                            else
                                // #490711
                                ContDetail.validate(ETA, VCKShippingDetail.tobeEta);
                            ContDetail.modify(true);
                        until ContDetail.next = 0;
                end;
            until VCKShippingDetail.Next() = 0;
    end;
}
