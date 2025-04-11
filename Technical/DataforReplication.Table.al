Table 50084 "Data for Replication"
{
    Caption = 'Data for Replication';
    DataCaptionFields = "Table No.", "Source No.", "Company Name";
    DrillDownPageID = "Data for Replication List";
    LookupPageID = "Data for Replication List";

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            NotBlank = true;
        }
        field(2; "Field No."; Integer)
        {
            TableRelation = Field."No.";

            trigger OnLookup()
            begin
                recField.SetRange(TableNo, "Table No.");
                if Page.RunModal(Page::"Fields Lookup", recField) = Action::LookupOK then
                    Validate("Field No.", recField."No.");
            end;

            trigger OnValidate()
            begin
                CalcFields("Field Name");
            end;
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(4; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
            TableRelation = Company;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5; Value; Text[100])
        {
            Caption = 'Value';
        }
        field(11; "Field Name"; Text[30])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."),
                                                        "No." = field("Field No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.", "Source No.", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recField: Record "Field";


    procedure FormatValue(Value: Text; var FieldRef: FieldRef)
    var
        Bool: Boolean;
        Date: Date;
        DateFormula: DateFormula;
        DateTime: DateTime;
        Decimal: Decimal;
        Duration: Duration;
        "Integer": Integer;
        Option: Option;
        Time: Time;
        BigInteger: BigInteger;
    begin
        case Format(FieldRef.Type) of
            'Date':
                begin
                    Evaluate(Date, Value, 9);
                    FieldRef.Value := Date;
                end;
            'Boolean':
                begin
                    Evaluate(Bool, Value, 9);
                    FieldRef.Value := Bool;
                end;
            'DateFormula':
                begin
                    Evaluate(DateFormula, Value, 9);
                    FieldRef.Value := DateFormula;
                end;
            'DateTime':
                begin
                    Evaluate(DateTime, Value, 9);
                    FieldRef.Value := DateTime;
                end;
            'BigInteger':
                begin
                    Evaluate(BigInteger, Value, 9);
                    FieldRef.Value := BigInteger;
                end;
            'Time':
                begin
                    Evaluate(Time, Value, 9);
                    FieldRef.Value := Time;
                end;
            'Option':
                begin
                    Evaluate(Option, Value, 9);
                    FieldRef.Value := Option;
                end;
            'Integer':
                begin
                    Evaluate(Integer, Value, 9);
                    FieldRef.Value := Integer;
                end;
            'Duration':
                begin
                    Evaluate(Duration, Value, 9);
                    FieldRef.Value := Duration;
                end;
            'Decimal':
                begin
                    Evaluate(Decimal, Value, 9);
                    FieldRef.Value := Decimal;
                end;
            else
                FieldRef.Value := Value;
        end;
    end;
}
