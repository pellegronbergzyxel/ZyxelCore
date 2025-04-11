Page 50234 "E-mail Address List"
{
    // 001. 06-11-18 ZY-LD 000 - New action.

    ApplicationArea = Basic, Suite;
    CardPageID = "E-mail Address Card";
    PageType = List;
    SourceTable = "E-mail address";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sender Name"; Rec."Sender Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sender Address"; Rec."Sender Address")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Recipients; Rec.Recipients)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Html Formatted"; Rec."Html Formatted")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Body Text"; Rec."Body Text")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Usage"; Rec."Document Usage")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail HTML file"; Rec."E-mail HTML file")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Color Scheme"; Rec."Color Scheme")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Possible Merge Fields")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Possible Merge Fields';
                Image = Link;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Hyperlink('http://helpcenter/NAV/Shelf/DynamicsNAV/DynamicsNAV.htm?b=Finance&r=E-mail%20address%20Setup');
                end;
            }
        }
    }
}
