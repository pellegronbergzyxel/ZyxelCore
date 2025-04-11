table 50068 "eCommerce Pay. Matrix"
{
    Caption = 'eCommerce Pay. Matrix';
    DataCaptionFields = "Amount Type", "Amount Description";
    DrillDownPageID = "eCommerce Pay. Matrix List";
    LookupPageID = "eCommerce Pay. Matrix List";

    fields
    {
        field(1; "Amount Type"; Code[30])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "eCommerce Payment Amount Type";
        }
        field(2; "Amount Description"; Code[50])
        {
            Caption = 'Description';
            TableRelation = "eComm. Pay. Amount Descript.";
        }
        field(3; "Posting Type"; Option)
        {
            Caption = 'Posting Type';
            OptionCaption = ' ,Charge,Fee,None,Payment,Sale,Tax,Advertising';
            OptionMembers = " ",Charge,Fee,"None",Payment,Sale,Tax,Advertising;

            trigger OnValidate()
            begin
                if recAmzMktPlace.Get('DE') then
                    case "Posting Type" of
                        "posting type"::Charge:
                            Validate("G/L Account No.", recAmzMktPlace."Charge Account No.");
                        "posting type"::Fee:
                            Validate("G/L Account No.", recAmzMktPlace."Fee Account No.");
                        "posting type"::Tax:
                            Validate("G/L Account No.", recAmzMktPlace."Tax G/L Account No.");
                        "posting type"::Advertising:
                            Validate("G/L Account No.", recAmzMktPlace."Advertising G/L Account No.");
                    end;
            end;
        }
        field(4; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(5; "Payment Statement Type"; Option)
        {
            Caption = 'Payment Statement Type';
            OptionCaption = ' ,Sales,Refunds,Expense,Cash';
            OptionMembers = " ",Sales,Refunds,Expense,Cash;
        }
        field(6; "Payment Statement Description"; Option)
        {
            Caption = 'Payment Statement Description';
            OptionCaption = ' ,eCommerce Fees,Cost of Advertising,FBA Fees,Other,Product Charge,Promo Rebates,Refunded Expenses,Refunded Sales,Shipping,Tax,Beginning Balance,Account Level Reserve';
            OptionMembers = " ","eCommerce Fees","Cost of Advertising","FBA Fees",Other,"Product Charge","Promo Rebates","Refunded Expenses","Refunded Sales",Shipping,Tax,"Beginning Balance","Account Level Reserve";
        }
        field(7; "Amount Incl. VAT"; Option)
        {
            Caption = 'Amount Incl. VAT';
            InitValue = " ";
            OptionMembers = No,Yes," ";
        }
        field(8; "Transaction Type"; Code[30])
        {
            TableRelation = "eCommerce Transaction Type";
        }
        field(9; "No of Payments"; Integer)
        {
            CalcFormula = Count("eCommerce Payment" where("New Transaction Type" = field("Transaction Type"),
                                                          "Amount Type" = field("Amount Type"),
                                                          "Amount Description" = field("Amount Description")));
            Caption = 'No of Payments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Sales Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Sales Document Type';
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Amount Type", "Amount Description")
        {
            Clustered = true;
        }
    }

    var
        recAmzMktPlace: Record "eCommerce Market Place";
}
