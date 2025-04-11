XmlPort 50039 "WS Replicate Cost Type Name"
{
    // 001. 01-05-20 ZY-LD P0417 - Transfer Concur fields between ZCom and ZNet.
    // 002. 07-08-20 ZY-LD 2020073110000042 - Replicate Dimension Value.

    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Cost Type Name"; "Cost Type Name")
            {
                MinOccurs = Zero;
                XmlName = 'CostType';
                UseTemporary = true;
                fieldelement(Code; "Cost Type Name".Code)
                {
                }
                fieldelement(Description; "Cost Type Name".Description)
                {
                }
                fieldelement(Name; "Cost Type Name".Name)
                {
                }
                fieldelement(Division; "Cost Type Name".Division)
                {
                }
                fieldelement(Department; "Cost Type Name".Department)
                {
                }
                fieldelement(Country; "Cost Type Name".Country)
                {
                }
                fieldelement(Manager; "Cost Type Name".Manager)
                {
                }
                fieldelement(VicePresident; "Cost Type Name".VP)
                {
                }
                fieldelement(Blocked; "Cost Type Name".Blocked)
                {
                }
                fieldelement(ManagerNo; "Cost Type Name"."Manager No.")
                {
                }
                fieldelement(VicePresidentNo; "Cost Type Name"."Vice President No.")
                {
                }
                fieldelement(HqExpenseCat; "Cost Type Name"."HQ Expense Category")
                {
                }
                fieldelement(CompanyName; "Cost Type Name"."Concur Company Name")
                {
                }
                fieldelement(CreditCardVendor; "Cost Type Name"."Concur Credit Card Vendor No.")
                {
                }
                fieldelement(PersonalVendor; "Cost Type Name"."Concur Personal Vendor No.")
                {
                }
                fieldelement(ConcurID; "Cost Type Name"."Concur Id")
                {
                }
                tableelement("Dimension Value"; "Dimension Value")
                {
                    LinkFields = Code = field(Code);
                    LinkTable = "Cost Type Name";
                    MinOccurs = Zero;
                    XmlName = 'DimensionValue';
                    UseTemporary = true;
                    fieldelement(DvDimensionCode; "Dimension Value"."Dimension Code")
                    {
                    }
                    fieldelement(DvCode; "Dimension Value".Code)
                    {
                    }
                    fieldelement(DvName; "Dimension Value".Name)
                    {
                    }
                    fieldelement(DvDimensionvalue; "Dimension Value"."Dimension Value Type")
                    {
                    }
                    fieldelement(DvTotaling; "Dimension Value".Totaling)
                    {
                    }
                    fieldelement(DvBlocked; "Dimension Value".Blocked)
                    {
                    }
                    fieldelement(DvConsolidation; "Dimension Value"."Consolidation Code")
                    {
                    }
                    fieldelement(DvIdentation; "Dimension Value".Indentation)
                    {
                    }
                    fieldelement(DvGlobalDimensionNo; "Dimension Value"."Global Dimension No.")
                    {
                    }
                    fieldelement(DvMapToIcDimCode; "Dimension Value"."Map-to IC Dimension Code")
                    {
                    }
                    fieldelement(DvMapToIcDimValueCode; "Dimension Value"."Map-to IC Dimension Value Code")
                    {
                    }
                }
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

    var
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SetData()
    var
        recCostType: Record "Cost Type Name";
        recGenSetup: Record "General Ledger Setup";
        recDimValue: Record "Dimension Value";
    begin
        recGenSetup.Get;  // 07-08-20 ZY-LD 002
        if recCostType.FindSet then
            repeat
                "Cost Type Name" := recCostType;
                "Cost Type Name".Insert;

                //>> 07-08-20 ZY-LD 002
                if recDimValue.Get(recGenSetup."Shortcut Dimension 4 Code", recCostType.Code) then begin
                    "Dimension Value" := recDimValue;
                    "Dimension Value".Insert;
                end;
            //<< 07-08-20 ZY-LD 002
            until recCostType.Next() = 0;
    end;


    procedure ReplicateData()
    var
        recCostType: Record "Cost Type Name";
        recDimValue: Record "Dimension Value";
    begin
        if "Cost Type Name".FindSet then
            repeat
                if not recCostType.Get("Cost Type Name".Code) then begin
                    recCostType := "Cost Type Name";
                    //>> 01-05-20 ZY-LD 001
                    if not ZGT.IsRhq then begin
                        recCostType."Concur Company Name" := '';
                        recCostType."Concur Credit Card Vendor No." := '';
                        recCostType."Concur Personal Vendor No." := '';
                    end;
                    //<< 01-05-20 ZY-LD 001
                    recCostType.Insert;
                end else begin
                    recCostType := "Cost Type Name";
                    //>> 01-05-20 ZY-LD 001
                    if not ZGT.IsRhq then begin
                        recCostType."Concur Company Name" := '';
                        recCostType."Concur Credit Card Vendor No." := '';
                        recCostType."Concur Personal Vendor No." := '';
                    end;
                    //<< 01-05-20 ZY-LD 001
                    recCostType.Modify;
                end;

                //>> 07-08-20 ZY-LD 002
                "Dimension Value".SetRange(Code, "Cost Type Name".Code);
                if "Dimension Value".FindFirst then
                    if not recDimValue.Get("Dimension Value"."Dimension Code", "Dimension Value".Code) then begin
                        recDimValue := "Dimension Value";
                        recDimValue.Insert(true);
                    end;
            //<< 07-08-20 ZY-LD 002
            until "Cost Type Name".Next() = 0;
    end;
}
