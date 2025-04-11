Page 50235 "Company Contract Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Company Contract Setup';
    PageType = List;
    SourceTable = "Customer Contract Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Folder Name"; Rec."Folder Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Folder Name (Test)"; Rec."Folder Name (Test)")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
