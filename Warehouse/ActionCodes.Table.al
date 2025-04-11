Table 66005 "Action Codes"
{
    LookupPageID = "Action Codes";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            Description = 'PAB 1.0';
        }
        field(3; Description; Text[150])
        {
            Caption = 'Description';
            Description = 'PAB 1.0';

            trigger OnValidate()
            var
                i: Integer;
                CountEmail: Integer;
            begin
                if (("Default Comment Type" >= "default comment type"::"E-mail Confirmation") and ("Default Comment Type" <= "default comment type"::"E-mail Slot-Request")) and
                   (StrPos(Description, '@') <> 0)
                then begin
                    /*  FOR i := 1 TO STRLEN(Description) DO
                        IF Description[i] = '@' THEN
                          CountEmail += 1;
                      IF CountEmail > 1 THEN
                        ERROR(Text003);

                      recActionCode.SETRANGE(Description,Description);
                      recActionCode.SETFILTER(Code,'<>%1',Code);
                      IF recActionCode.FINDFIRST THEN
                        MESSAGE(Text004,recActionCode.Code);*/

                    Description := ZGT.ValidateEmailAdd(Description);
                end;

            end;
        }
        field(4; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            OptionCaption = ' ,,,,,Spec. Order';
            OptionMembers = " ",,,,,"Spec. Order";

            trigger OnValidate()
            var
                LEMSG000: label 'Sales Order Type can not be change!';
                LocationRec: Record Location;
                LEMSG001: label 'Sales Order Type %1 can not match with Location %2!';
                LEMSG002: label 'Location %1 not exist!';
                LEMSG003: label 'Can not find default location for Sales Order Type %1!';
                SOLine: Record "Sales Line";
                Item: Record Item;
                LEMSG004: label 'Item %1 is not match %2!';
                LEMSG005: label 'Document Type should be Order or Invoice!';
            begin
            end;
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(9; "Default Comment Type"; Option)
        {
            Caption = 'Default Comment Type';
            OptionCaption = 'General,Picking,Packing,Transport,Export,Customer,,,E-mail Notification (Pre-Adv),,,,E-mail Slot-Request,Value99';
            OptionMembers = General,Picking,Packing,Transport,Export,Customer,SAP,"E-mail Confirmation","E-mail Notification (Pre-Adv)","E-mail Exceptation","E-mail Pre-Alert","E-mail Ready for Pickup","E-mail Slot-Request",Value99;

            trigger OnValidate()
            begin
                Validate(Description);

                CalcFields("Used on Def. Action Code Head", "Used on Del. Doc. Action Code");
                if "Used on Def. Action Code Head" <> 0 then begin
                    recDefaultAction.SetRange("Action Code", Code);
                    if recDefaultAction.FindSet(true) then
                        repeat
                            if (recDefaultAction."Comment Type" = recDefaultAction."comment type"::General) or
                               (recDefaultAction."Comment Type" = xRec."Default Comment Type")
                            then begin
                                recDefaultAction.Validate("Comment Type", "Default Comment Type");
                                recDefaultAction.Modify(true);
                            end;
                        until recDefaultAction.Next() = 0;
                end;

                CalcFields("Used on Del. Doc. Action Code");
                if "Used on Del. Doc. Action Code" then begin
                    recDelDocAction.SetRange("Action Code", Code);
                    if recDelDocAction.FindSet(true) then
                        repeat
                            if (recDelDocAction."Comment Type" = recDelDocAction."comment type"::General) or
                               (recDelDocAction."Comment Type" = xRec."Default Comment Type")
                            then begin
                                recDelDocAction.Validate("Comment Type", "Default Comment Type");
                                recDelDocAction.Modify(true);
                            end;
                        until recDelDocAction.Next() = 0;
                end;

                Modify(true);
            end;
        }
        field(10; "Used on Def. Action Code Head"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Default Action" where("Action Code" = field(Code),
                                                        "Header / Line" = const(Header)));
            Caption = 'Used on Def. Action Code (Header)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Used on Del. Doc. Action Code"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("Delivery Document Action Code" where("Action Code" = field(Code),
                                                                       "Warehouse Status" = filter(< Delivered)));
            Caption = 'Used on Del. Doc. Action Code';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                recDelDocAction.SetRange("Action Code", Code);
                recDelDocAction.SetFilter("Warehouse Status", '<%1', recDelDocAction."warehouse status"::Delivered);
                if recDelDocAction.FindSet then begin
                    recDelDocHeadTmp.DeleteAll;
                    repeat
                        if recDelDocHead.Get(recDelDocAction."Delivery Document No.") then begin
                            recDelDocHeadTmp := recDelDocHead;
                            if not recDelDocHeadTmp.Insert(true) then;
                        end;
                    until recDelDocAction.Next() = 0;

                    Page.Run(Page::"VCK Delivery Document List", recDelDocHeadTmp);
                end;
            end;
        }
        field(12; "Original Description"; Text[150])
        {
            Caption = 'Original Description';
        }
        field(13; "Header / Line Filter"; Option)
        {
            Caption = 'Header / Line';
            FieldClass = FlowFilter;
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(14; "Used on Def. Action Code Line"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Default Action" where("Action Code" = field(Code),
                                                        "Header / Line" = const(Line)));
            Caption = 'Used on Def. Action Code (Line)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "End Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Default Comment Type", Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CalcFields("Used on Def. Action Code Head", "Used on Del. Doc. Action Code");
        if "Used on Def. Action Code Head" <> 0 then begin
            recDefaultAction.SetRange("Action Code", Code);
            if Confirm(Text001, false, Code, recDefaultAction.Count) then
                recDefaultAction.DeleteAll(true)
            else
                Error('');
        end;

        if "Used on Del. Doc. Action Code" then begin  // Description is shown on Delivery Document Action Code, so we can´t delete the record.
            Blocked := true;
            Modify;
            Commit;
            Error('');
        end;
    end;

    trigger OnInsert()
    begin
        recWhseSetup.Get;
        if Code = '' then
            Code := NoSeriesMgt.GetNextNo(recWhseSetup."Action Code Nos.", Today, true)
        else
            NoSeriesMgt.TestManual(recWhseSetup."Action Code Nos.");
    end;

    var
        recWhseSetup: Record "Warehouse Setup";
        recActionCode: Record "Action Codes";
        recDefaultAction: Record "Default Action";
        recDelDocAction: Record "Delivery Document Action Code";
        recDelDocHead: Record "VCK Delivery Document Header";
        recDelDocHeadTmp: Record "VCK Delivery Document Header" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label '"%1" us used %2 times on Default Action.\If you accept to delete, the default action code(s) will be removed.\\Do you want to continue?';
        Text002: label 'E-mails is automatic send when warehouse status is:\Confirmation: "Delivered / Proff of Delivery"\Notification: "In Transit"\Pre-Alert: "Ready to Ship".';
        ZGT: Codeunit "ZyXEL General Tools";
        Text003: label 'You are only allowed to enter one e-mail address per action code.';
        Text004: label 'An action code with the same description is created on action code %1.';
}
