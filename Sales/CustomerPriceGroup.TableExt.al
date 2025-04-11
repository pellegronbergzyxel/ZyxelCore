tableextension 50103 CustomerPriceGroupZX extends "Customer Price Group"
{
    fields
    {
        field(50000; Division; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
        }
        field(50001; Blocked; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50002; "Customer No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Customer."No.";
        }
        field(50003; "Country Code"; Code[20])
        {
            Description = 'PAB 1.0';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Country/Region Code" where("No." = field("Customer No.")));
        }
        field(50004; "Price File"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50005; Territory; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "Forecast Territory".Code;
        }
        field(50006; "Lookup Country"; Code[10])
        {
            Description = 'PAB 1.0';
        }
        field(50007; "Automatically Added"; Boolean)
        {
            Description = 'PAB 1.0';
            InitValue = false;
        }
    }
}
