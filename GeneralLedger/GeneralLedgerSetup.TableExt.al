tableextension 50126 GeneralLedgerSetupZX extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Supress Currency warning"; Boolean)
        {
        }
        field(50001; "HQ Company Name"; Text[10])
        {
            Caption = 'HQ Company Name';
            Description = '17-12-20 ZY-LD 005';
        }
        field(50007; "Travel Expense Nos."; Code[10])
        {
            Caption = 'Travel Expense Nos.';
            TableRelation = "No. Series";
        }
        field(50008; "Travel Exp. Gen. Jnl. Template"; Code[10])
        {
            Caption = 'Travel Exp. Gen. Jnl. Template';
            TableRelation = "Gen. Journal Template";
        }
        field(50009; "Travel Exp. Gen. Jnl. Batch"; Code[10])
        {
            Caption = 'Travel Exp. Gen. Jnl. Batch';
        }
        //TODO: LD Skal den beholdes? Linker til Lessor
        // field(50010;"Travel Exp. Pay Type Code";Code[10])
        // {
        //     Caption = 'Travel Exp. Pay Type Code';
        //     TableRelation = "Pay Type";
        // }
        field(50011; "Travel Exp. Pay Type Mail Add."; Code[10])
        {
            Caption = 'Travel Exp. Pay Type Mail Add.';
            TableRelation = "E-mail address";
        }
        field(50012; "Travel Exp. Concur Id Nos"; Code[10])
        {
            Caption = 'Travel Exp. Concur Id Nos';
            TableRelation = "No. Series";
        }
        field(50013; "Power Pivot Start Date"; Date)
        {
            Caption = 'Power Pivot Report Start Date';
        }
        field(50014; "Power Pivot End Date"; Date)
        {
            Caption = 'Power Pivot Report End Date';
        }
        field(50015; "Allow VAT Posting From"; Date)  // 18-03-24 ZY-LD 000
        {
            Caption = 'Allow VAT Posting From';
        }
        field(50016; "Allow VAT Posting To"; Date)  // 18-03-24 ZY-LD 000
        {
            Caption = 'Allow VAT Posting To';
        }
    }
}
