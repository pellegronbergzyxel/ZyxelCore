Page 50301 "Excel Report Card"
{
    Caption = 'Excel Report Card';
    SourceTable = "Excel Report Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Number of Columns"; Rec."Number of Columns")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Control6; "Excel Report Line")
            {
                SubPageLink = "Excel Report Code" = field(Code);
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(reporting)
        {
            action("Personel Budget")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Personel Budget';
                Image = Excel;
                RunObject = Report "Personnel Budget Report";
            }
        }
    }
}
