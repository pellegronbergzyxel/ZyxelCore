Page 50036 "Data Exports"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Data Exports';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Export';
    SourceTable = "Data Export";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1140000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Export)
            {
                Caption = 'Export';
                action("Data Export Record Definition")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Record Definitions';
                    Image = XMLFile;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Data Export Record Definitions";
                    RunPageLink = "Data Export Code" = field(Code);
                    RunPageView = sorting("Data Export Code", "Data Exp. Rec. Type Code");
                }
            }
        }
    }
}
