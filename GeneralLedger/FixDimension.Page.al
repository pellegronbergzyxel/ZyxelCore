Page 50023 "Fix Dimension"
{

    PageType = StandardDialog;
    Permissions = TableData "G/L Entry" = rm;
    SourceTable = "G/L Entry";

    layout
    {
        area(content)
        {
            field(DivisionCode; DivisionCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Division:';
                Tooltip = 'Select the division dimension value to be applied to the G/L entry.';
                TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DIVISION'));
            }
            field(DepartmentCode; DepartmentCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Department:';
                tooltip = 'Select the department dimension value to be applied to the G/L entry.';
                TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DEPARTMENT'));
            }
            field(CountryCode; CountryCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Country:';
                tooltip = 'Select the country dimension value to be applied to the G/L entry.';
                TableRelation = "Dimension Value".Code where("Dimension Code" = filter('COUNTRY'));
            }
            field(CostTypeCode; CostTypeCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cost Type:';
                tooltip = 'Select the cost type dimension value to be applied to the G/L entry.';
                TableRelation = "Dimension Value".Code where("Dimension Code" = filter('COSTTYPE'));
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        DivisionCode := Rec."Global Dimension 1 Code";
        DepartmentCode := Rec."Global Dimension 2 Code";
        //06-08-2026 BK performance issue.
        CountryCode := Rec."Shortcut Dimension 3 Code";
        CostTypeCode := Rec."Shortcut Dimension 4 Code";
    end;

    var
        DivisionCode: Code[20];
        DepartmentCode: Code[20];
        CountryCode: Code[20];
        CostTypeCode: Code[20];

}
