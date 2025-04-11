tableextension 50122 CompanyInformationZX extends "Company Information"
{
    fields
    {
        field(13600; "Bank Creditor No."; Code[8])
        {
            Caption = 'Bank Creditor No.';
            Numeric = true;

            trigger OnValidate()
            begin
                if Rec."Bank Creditor No." = '' then
                    exit;
                if StrLen(Rec."Bank Creditor No.") <> MaxStrLen(Rec."Bank Creditor No.") then
                    Error(StrSubstNo(BankCreditorNumberLengthErr, Rec.FieldCaption(Rec."Bank Creditor No.")));
            end;
        }
        field(50000; "Logo Screen"; Blob)
        {
            Caption = 'Picture';
            Description = 'PAB 1.0';
            SubType = Bitmap;
        }
        field(50002; "VAT Registration No. Domestic"; Text[20])
        {
            Caption = 'VAT Registration No. Domestic';
            Description = '22-01-20 ZY-LD 008';
        }
        field(50003; "EORI No."; Code[15])
        {
            Caption = 'EORI No.';
            Description = '25-01-21 ZY-LD';
        }
        field(50004; "HQ Company Name"; Text[20])
        {
            Caption = 'HQ Company Name';
            Description = '16-04-21 ZY-LD 009';
        }
        field(50010; "Finance E-Mail"; Text[30])
        {
            Caption = 'Finance E-Mail';
            Description = '23-05-18 ZY-LD 005';
        }
        field(50011; "Finance Phone No."; Text[30])
        {
            Caption = 'Finance Phone No.';
            Description = '23-05-18 ZY-LD 005';
        }
        field(53001; "General Manager Title"; Text[50])
        {
            Caption = 'General Manager Title';
        }
        field(53002; "General Manager Name"; Text[80])
        {
            Caption = 'General Manager Name';
        }
        field(53003; "General Manager Address"; Text[30])
        {
            Caption = 'General Manager Address';
        }
        field(53004; "General Manager City"; Text[50])
        {
            Caption = 'General Manager City';
        }
        field(53005; Steuername; Text[30])
        {
            Caption = 'TAX Number Caption';
        }
        field(53006; Steuernumber; Text[30])
        {
            Caption = 'TAX Number';
        }
        field(53007; "Invoice Email From Address"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(53008; "Invoice Email From Password"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(53009; "Invoice From Email Enabled"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(54000; "Registered Name"; Text[50])
        {
            Caption = 'Registered Name';
            Description = 'DT-UK';
        }
        field(54001; "Registered Name 2"; Text[50])
        {
            Description = 'DT-UK';
        }
        field(54002; "Registered Adress"; Text[50])
        {
            Description = 'DT-UK';
        }
        field(54003; "Registered Adress 2"; Text[50])
        {
            Description = 'DT-UK';
        }
        field(54004; "Registered City"; Text[30])
        {
            Description = 'DT-UK';
        }
        field(54005; "Registered County"; Text[30])
        {
            Description = 'DT-UK';
        }
        field(54006; "Registered Post Code"; Code[20])
        {
            Description = 'DT-UK';

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                // >> DT2.10 UK
                //15-51643
                PostCode.ValidatePostCode(Rec.City, Rec."Post Code", Rec.County, Rec."Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed());
                // << DT2.1.0 UK
            end;
        }
        field(54007; "Branch Number"; Text[3])
        {
            Description = 'DT-UK';
        }
        field(54008; "Contact Name"; Text[35])
        {
            Description = 'DT-UK';
        }
        field(54009; "Wee Registration No."; Code[30])
        {
            Caption = 'WEEE Registration No.';
            Description = 'DT-UK';
        }
        field(62000; "Bank Account No. 2"; Text[20])
        {
            Caption = 'Bank Account No. 2';
            Description = 'Tectura Taiwan';
        }
        field(62001; "Bank Account No. 3"; Text[20])
        {
            Caption = 'Bank Account No. 3';
            Description = 'Tectura Taiwan';
        }
        field(62003; "Bank Account No. 4"; Text[20])
        {
            Caption = 'Bank Account No. 4';
            Description = 'Tectura Taiwan';
        }
        field(62005; "IBAN 2"; Text[30])
        {
            Description = 'Tectura Taiwan';
        }
        field(62006; "IBAN 3"; Text[30])
        {
            Description = 'Tectura Taiwan';
        }
        field(62007; "IBAN 4"; Text[30])
        {
            Description = 'Tectura Taiwan';
        }
        field(62100; "Bank Address"; Text[50])
        {
            Caption = 'Bank Address';
        }
        field(62101; "Bank Address 2"; Text[50])
        {
            Caption = 'Bank Address 2';
        }
        field(62102; "Bank City"; Text[30])
        {
            Caption = 'Bank City';
        }
        field(62103; "Bank Post Code"; Code[20])
        {
            Caption = 'Bank Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
                BankCounty: Text[50];
            begin
                //ZL111007D+
                //15-51643  PostCode.ValidatePostCode("Bank City","Bank Post Code");
                PostCode.ValidatePostCode(Rec."Bank City",
                                          Rec."Bank Post Code",
                                          BankCounty, Rec."Bank Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed());//15-51643
                //ZL111007D-
            end;
        }
        field(62104; "Bank Country/Region Code"; Code[10])
        {
            Caption = 'Bank Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(62110; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(62111; "Currency Code 2"; Code[10])
        {
            Caption = 'Currency Code 2';
            TableRelation = Currency;
        }
        field(62112; "Currency Code 3"; Code[10])
        {
            Caption = 'Currency Code 3';
            TableRelation = Currency;
        }
        field(62113; "Currency Code 4"; Code[10])
        {
            Caption = 'Currency Code 4';
            TableRelation = Currency;
        }
        field(62115; "Business Mandatory"; Text[100])
        {
            Description = 'CO4.20';
        }
        field(67001; "Main Company"; Boolean)
        {
        }
    }

    procedure GetSIREN() Result: Integer
    begin
        Evaluate(Result, CopyStr(DelChr(Rec."Registration No."), 1, 9));  // 27-11-20 ZY-LD 007
    end;

    var
        BankCreditorNumberLengthErr: Label '%1 must be an 8-digit number.';
        MissingOIOUBMInfoQst: Label 'You need to provide information in %1 to support OIOUBL. Do you want to update it now?';
        MissingOIOUBMInfoErr: Label 'The needed information to support OIOUBL is not provided in %1.';
}
