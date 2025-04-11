XmlPort 50052 "HQ Purchase Order"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(Root)
        {
            tableelement("Purchase Header"; "Purchase Header")
            {
                MinOccurs = Zero;
                RequestFilterFields = "No.";
                XmlName = 'PurchaseHeader';
                SourceTableView = where("Document Type" = const("Purchase Document Type"::Order));
                UseTemporary = true;
                fieldelement(OrderNo; "Purchase Header"."No.")
                {
                }
                textelement(TransportMethod)
                {

                    trigger OnBeforePassVariable()
                    begin
                        if "Purchase Header".IsEICard then
                            TransportMethod := recPurchSetup."EiCar Default Transport Method"
                        else
                            TransportMethod := "Purchase Header"."Transport Method";
                    end;
                }
                textelement(ShippingMark)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ShippingMark := StrSubstNo('%1 SO#%2 / %3, %4', "Purchase Header"."Shipping Request Notes", "Purchase Header"."From SO No.", "Purchase Header"."SO Sell-to Customer Name", recConvChar.ConvertCharacters("Purchase Header"."Dist. Purch. Order No."));
                    end;
                }
                textelement(SpecialInstruction)
                {

                    trigger OnBeforePassVariable()
                    begin
                        if "Purchase Header".IsEICard then begin
                            recEicardQueue.SetRange("Purchase Order No.", "Purchase Header"."No.");
                            recEicardQueue.FindFirst;
                            case recEicardQueue."Eicard Type" of
                                recEicardQueue."eicard type"::Consignment:
                                    case recEicardQueue."Customer No." of
                                        '200001':
                                            SpecialInstruction := Text001;
                                    end;
                                recEicardQueue."eicard type"::eCommerce:
                                    case recEicardQueue."Customer No." of
                                        '200001':
                                            SpecialInstruction := Text002;
                                    end;
                                else
                                    SpecialInstruction := recEicardQueue."Customer Name";
                            end;
                        end else
                            SpecialInstruction := StrSubstNo('%1 %2', "Purchase Header"."SO Sell-to Customer No", "Purchase Header"."SO Sell-to Customer Name");
                    end;
                }
                textelement(DistributorPurchOrderNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DistributorPurchOrderNo := recConvChar.ConvertCharacters("Purchase Header"."Dist. Purch. Order No.");
                    end;
                }
                tableelement("Purchase Line"; "Purchase Line")
                {
                    LinkFields = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    LinkTable = "Purchase Header";
                    MinOccurs = Zero;
                    XmlName = 'PurchaseLine';
                    SourceTableView = where(Type = const("Purchase Line Type"::Item));
                    UseTemporary = true;
                    fieldelement(PurchaseOrderNo; "Purchase Line"."Document No.")
                    {
                    }
                    fieldelement(LineNo; "Purchase Line"."Line No.")
                    {
                    }
                    fieldelement(PartNo; "Purchase Line"."No.")
                    {
                    }
                    fieldelement(Quantity; "Purchase Line".Quantity)
                    {
                    }
                    fieldelement(RequestDate; "Purchase Line"."Requested Date From Factory")
                    {
                    }
                    fieldelement(EMSMachineCode; "Purchase Line"."EMS Machine Code")
                    {
                    }
                    fieldelement(GLCSerialNo; "Purchase Line"."GLC Serial No.")
                    {
                    }
                    fieldelement(GLCMacAddress; "Purchase Line"."GLC Mac Address")
                    {
                    }
                }
            }
            textelement(AllRecordsSent)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        recPurchSetup.Get;
    end;

    var
        recPurchSetup: Record "Purchases & Payables Setup";
        recConvChar: Record "Convert Characters";
        recEicardQueue: Record "EiCard Queue";
        Text001: label 'Studerus AG (licenses)';
        Text002: label 'Studerus EC order';


    procedure GetData(SourceType: Code[10]; SourceNo: Code[20])
    begin
    end;
}
