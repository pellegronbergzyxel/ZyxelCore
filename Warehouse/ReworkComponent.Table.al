Table 50006 "Rework Component"
{
    Caption = 'Rework Component';
    DrillDownPageID = "Rework BOM";
    LookupPageID = "Rework BOM";

    fields
    {
        field(1; "Parent Item No."; Code[20])
        {
            Caption = 'Parent Item No.';
            NotBlank = true;
            TableRelation = Item where(Type = const(Inventory));
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Resource';
            OptionMembers = " ",Item,Resource;

            trigger OnValidate()
            begin
                "No." := '';
            end;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Item)) Item where(Type = const(Inventory))
            else
            if (Type = const(Resource)) Resource;

            trigger OnValidate()
            begin
                TestField(Type);
                if "No." = '' then
                    exit;

                case Type of
                    Type::Item:
                        begin
                            Item.Get("No.");
                            ValidateAgainstRecursion("No.");
                            Item.CalcFields("Rework BOM");
                            "Rework BOM" := Item."Rework BOM";
                            Description := Item.Description;
                            "Unit of Measure Code" := Item."Base Unit of Measure";
                            ParentItem.Get("Parent Item No.");
                            //CalcLowLevelCode.SetRecursiveLevelsOnItem(Item,ParentItem."Low-Level Code" + 1,TRUE);
                            Item.Find;
                            ParentItem.Find;
                            //IF ParentItem."Low-Level Code" >= Item."Low-Level Code" THEN
                            //  ERROR(Text001,"No.");
                        end;
                    Type::Resource:
                        begin
                            Res.Get("No.");
                            "Rework BOM" := false;
                            Description := Res.Name;
                            "Unit of Measure Code" := Res."Base Unit of Measure";
                        end;
                end;
            end;
        }
        field(5; "Rework BOM"; Boolean)
        {
            CalcFormula = exist("Rework Component" where(Type = const(Item),
                                                          "Parent Item No." = field("No.")));
            Caption = 'Rework BOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if (Type = const(Resource)) "Resource Unit of Measure".Code where("Resource No." = field("No."));
        }
        field(8; "Quantity per"; Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(9; Position; Code[10])
        {
            Caption = 'Position';
        }
        field(10; "Position 2"; Code[10])
        {
            Caption = 'Position 2';
        }
        field(11; "Position 3"; Code[10])
        {
            Caption = 'Position 3';
        }
        field(14; "BOM Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Parent Item No.")));
            Caption = 'BOM Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Resource Usage Type"; Option)
        {
            Caption = 'Resource Usage Type';
            OptionCaption = 'Direct,Fixed';
            OptionMembers = Direct,"Fixed";

            trigger OnValidate()
            begin
                if "Resource Usage Type" = xRec."Resource Usage Type" then
                    exit;

                TestField(Type, Type::Resource);
            end;
        }
        field(50000; "Part Number Type"; Code[20])
        {
            CalcFormula = lookup(Item."Part Number Type" where("No." = field("No.")));
            Caption = 'Part Number Type';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "VCK Part Number Types";
        }
        field(50001; Substitution; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("Item Substitution" where("No." = field("No.")));
            Caption = 'Substitution';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Parent Item No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Type, "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Item.Get("Parent Item No.");
        if Type = Type::Item then
            ValidateAgainstRecursion("No.")
    end;

    trigger OnModify()
    begin
        Item.Get("Parent Item No.");
        if Type = Type::Item then
            ValidateAgainstRecursion("No.")
    end;

    trigger OnRename()
    begin
        Item.Get("Parent Item No.");
        if Type = Type::Item then
            ValidateAgainstRecursion("No.")
    end;

    var
        Text000: label '%1 cannot be component of itself.';
        Text001: label 'You cannot insert item %1 as an assembly component of itself.';
        Item: Record Item;
        ParentItem: Record Item;
        Res: Record Resource;
        ItemVariant: Record "Item Variant";
        BOMComp: Record "BOM Component";
        CalcLowLevelCode: Codeunit "Calculate Low-Level Code";
        AssemblyBOM: Page "Assembly BOM";


    procedure ValidateAgainstRecursion(ItemNo: Code[20])
    var
        BOMComp: Record "Rework Component";
    begin
        if "Parent Item No." = ItemNo then
            Error(Text001, ItemNo);
        if Type = Type::Item then begin
            BOMComp.SetCurrentkey(Type, "No.");
            BOMComp.SetRange(Type, Type::Item);
            BOMComp.SetRange("No.", "Parent Item No.");
            if BOMComp.FindSet then
                repeat
                    BOMComp.ValidateAgainstRecursion(ItemNo);
                until BOMComp.Next() = 0
        end
    end;
}
