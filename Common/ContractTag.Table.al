table 50064 "Contract Tag"
{
    Caption = 'Contract Tag';

    fields
    {
        field(1; Tag; Code[20])
        {
            Caption = 'Tag';
            NotBlank = true;
        }
        field(2; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Customer Contract";
        }
        field(3; "Tag Created on Document"; Boolean)
        {
            CalcFormula = exist("Customer Contract Tag" where("Document No." = field("Document No. Filter"), Tag = field(Tag)));
            Caption = 'Tag Created on Document';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Tag)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Tag)
        {
        }
    }

    var
        SI: Codeunit "Single Instance";

    procedure NewTag()
    var
        lText001: Label 'New Tag';
        lText002: Label 'Tag Name';
        lContractTag: Record "Contract Tag";
        GenericInputPage: Page "Generic Input Page";
        lText003: Label '%1 "%2" is already created.';
        NewValue: Code[20];
    begin
        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(lText002);
        GenericInputPage.SetVisibleField(3);  // Code
        if GenericInputPage.RunModal = Action::OK then begin
            NewValue := GenericInputPage.GetCode20;
            if NewValue <> '' then begin
                lContractTag.Tag := GenericInputPage.GetCode20;
                if not lContractTag.Insert() then
                    Error(lText003, lContractTag.FieldCaption(Tag), GenericInputPage.GetCode20);
            end;
        end;
    end;

    procedure InsertContractTag(pTag: Code[20])
    var
        lCustContractTag: Record "Customer Contract Tag";
        lText001: Label '%1 "%2" is already created on document no. %3.';
    begin
        lCustContractTag.Validate("Document No.", SI.GetDocumentNo);
        lCustContractTag.Validate(Tag, pTag);
        if not lCustContractTag.Insert() then
            Error(lText001, lCustContractTag.FieldCaption(Tag), Tag, SI.GetDocumentNo);
    end;
}
