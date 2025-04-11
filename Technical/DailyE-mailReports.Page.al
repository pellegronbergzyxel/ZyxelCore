Page 50037 "Daily E-mail Reports"
{
    ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "Daily E-mail Report";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail Address Code"; Rec."E-mail Address Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Forecast Territory Filter"; Rec."Forecast Territory Filter")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
