table 50013 "Zyxel Company"
{
    Caption = 'Zyxel Company';
    DataCaptionFields = "HQ Company", Name;
    DataPerCompany = false;
    DrillDownPageID = "Zyxel Companies";
    LookupPageID = "Zyxel Companies";

    fields
    {
        field(1; "HQ Company"; Option)
        {
            Caption = 'HQ Company';
            NotBlank = true;
            OptionMembers = ,Zyxel,Networks;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
            NotBlank = true;
            TableRelation = Company;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(3; "Company Option"; Option)
        {
            Caption = 'Company Option';
            OptionCaption = ' ,RHQ,UK,SE,RU,NO,NL,ME,FI,ES,DK,DE,CZ,SP,IT,TR,HU,PL,FR,BE';
            OptionMembers = " ",RHQ,UK,SE,RU,NO,NL,ME,FI,ES,DK,DE,CZ,SP,IT,TR,HU,PL,FR,BE;
        }
    }

    keys
    {
        key(Key1; "HQ Company", Name)
        {
            Clustered = true;
        }
    }
}
