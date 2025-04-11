Table 50120 SBU
{
    // 001. 19-10-20 ZY-LD 2020101610000225 - New field.
    // 002. 24-11-20 ZY-LD 2020101610000225 - Update "Business to".
    // 003. 16-04-24 ZY-LD 000 - Type has changed from Option to Enum.

    DrillDownPageID = "HQ Dimension";
    LookupPageID = "HQ Dimension";

    fields
    {
        //>> 16-04-24 ZY-LD 003
        /*field(1; Type; Option)
        {
            Caption = 'Type';
            Description = '16-10-19 ZY-LD 018';
            OptionCaption = ' ,Category 1,Category 2,Category 3,Category 4,Category 5,Business Center,SBU,Forecast Category 2,Statistics Category,WEEE Category';
            OptionMembers = " ","Category 1","Category 2","Category 3","Category 4","Category 5","Business Center",SBU,"Forecast Category 2","Statistics Category","WEEE Category";
        }*/
        field(1; Type; Enum "HQ Dimension")
        {
            Caption = 'Type';
        }
        //<< 16-04-24 ZY-LD 003
        field(2; "Code"; Code[50])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
            Description = '16-10-19 ZY-LD 018';
        }
        field(5; "Business to"; Option)
        {
            Caption = 'Business to';
            Description = '19-10-20 ZY-LD 001';
            OptionCaption = ' ,Business,Consumer';
            OptionMembers = " ",Business,Consumer;

            trigger OnValidate()
            begin
                UpdateItem;
            end;
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    local procedure UpdateItem()
    var
        recItem: Record Item;
        lText001: label 'Do you want to update %1 item(s) to "%2 %3"?\\Filter "%4".';
    begin
        //>> 24-11-20 ZY-LD 002
        case Type of
            Type::"Category 1":
                recItem.SetRange("Category 1 Code", Code);
            Type::"Category 2":
                recItem.SetRange("Category 2 Code", Code);
            Type::"Category 3":
                recItem.SetRange("Category 3 Code", Code);
            Type::"Category 4":
                recItem.SetRange("Category 4 Code", Code);
            Type::"Business Center":
                recItem.SetRange("Business Center", Code);
            Type::SBU:
                recItem.SetRange(SBU, Code);
        end;
        recItem.SetRange(Inactive, false);
        if Confirm(lText001, false, recItem.Count, recItem.FieldCaption("Business to"), "Business to", recItem.GetFilters) then begin
            if recItem.FindSet(true) then
                repeat
                    recItem.Validate("Business to", "Business to");
                    recItem.Modify(true);
                until recItem.Next() = 0;
        end;
        //<< 24-11-20 ZY-LD 002
    end;
}
