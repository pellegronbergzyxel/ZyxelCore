Table 50029 "IC Reconciliation Line"
{
    Caption = 'IC Reconciliation Line';

    fields
    {
        field(1; "Reconciliation Template Name"; Code[10])
        {
            Caption = 'Reconciliation Template Name';
            TableRelation = "IC Reconciliation Template";
        }
        field(2; "Reconciliation Name"; Code[10])
        {
            Caption = 'Reconciliation Name';
            TableRelation = "IC Reconciliation Name".Name where("Reconciliation Template Name" = field("Reconciliation Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Row No."; Code[10])
        {
            Caption = 'Row No.';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Account,,Total, ,Customer,Vendor';
            OptionMembers = "Account Totaling",,"Row Totaling",Description,"Customer Totaling","Vendor Totaling";

            trigger OnValidate()
            begin
                if Type <> xRec.Type then begin
                    TempType := Type;
                    Init;
                    "Reconciliation Template Name" := xRec."Reconciliation Template Name";
                    "Reconciliation Name" := xRec."Reconciliation Name";
                    "Line No." := xRec."Line No.";
                    "Row No." := xRec."Row No.";
                    Description := xRec.Description;
                    Type := TempType;
                end;

                case Type of
                    Type::Description:
                        begin
                            "Blank Zero" := true;
                            Strong := true;
                        end;
                    Type::"Row Totaling":
                        begin
                            "Blank Zero" := false;
                            Strong := true;
                        end;
                end;
            end;
        }
        field(7; Totaling; Text[30])
        {
            Caption = 'Totaling';
            TableRelation = if (Type = const("Account Totaling")) "G/L Account"
            else
            if (Type = const("Customer Totaling")) Customer
            else
            if (Type = const("Vendor Totaling")) Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if (Totaling <> '') and (Type = Type::"Account Totaling") then begin
                    GLAcc.SetFilter("No.", Totaling);
                    GLAcc.SetFilter("Account Type", '<> 0');
                    if GLAcc.FindFirst then
                        GLAcc.TestField("Account Type", GLAcc."account type"::Posting);
                end;
            end;
        }
        field(8; "Gen. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(9; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(10; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(11; "Row Totaling"; Text[250])
        {
            Caption = 'Row Totaling';
        }
        field(12; "Amount Type"; Option)
        {
            Caption = 'Amount Type';
            OptionCaption = ' ,Amount,Base,Unrealized Amount,Unrealized Base';
            OptionMembers = " ",Amount,Base,"Unrealized Amount","Unrealized Base";
        }
        field(13; "Calculate with"; Option)
        {
            Caption = 'Calculate with';
            OptionCaption = 'Sign,Opposite Sign';
            OptionMembers = Sign,"Opposite Sign";

            trigger OnValidate()
            begin
                if ("Calculate with" = "calculate with"::"Opposite Sign") and (Type = Type::"Row Totaling") then
                    FieldError(Type, StrSubstNo(Text000, Type));
            end;
        }
        field(14; Print; Boolean)
        {
            Caption = 'Print';
            InitValue = true;
        }
        field(15; "Print with"; Option)
        {
            Caption = 'Print with';
            OptionCaption = 'Sign,Opposite Sign';
            OptionMembers = Sign,"Opposite Sign";
        }
        field(16; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(17; "New Page"; Boolean)
        {
            Caption = 'New Page';
        }
        field(18; "Tax Jurisdiction Code"; Code[10])
        {
            Caption = 'Tax Jurisdiction Code';
            TableRelation = "Tax Jurisdiction";
        }
        field(19; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(20; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(21; "Blank Zero"; Boolean)
        {
            Caption = 'Blank Zero';
            InitValue = true;

            trigger OnValidate()
            begin
                if Type = Type::Description then
                    "Blank Zero" := true;
            end;
        }
        field(22; Strong; Boolean)
        {
            Caption = 'Strong';
        }
    }

    keys
    {
        key(Key1; "Reconciliation Template Name", "Reconciliation Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: label 'must not be %1';
        GLAcc: Record "G/L Account";
        TempType: Integer;
}
