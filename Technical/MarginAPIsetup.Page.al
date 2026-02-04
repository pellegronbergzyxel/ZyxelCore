namespace ZyxelCore.ZyxelCore;

page 50150 "Margin API setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Margin API setup';
    PageType = List;
    SourceTable = "Amazon Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(ApiCompanyname; Rec.ApiCompanyname)
                {

                }
                field("Token endpoint"; Rec."Token endpoint")
                {
                    ToolTip = 'Specifies the value of the Token endpoint field.', Comment = '%';
                }
                field(client_secret; Rec.client_secret)
                {
                    Caption = 'Token';
                    ToolTip = 'Specifies the value of the client_secret field.', Comment = '%';
                }
                field(testmode; Rec.testmode)
                {

                }
            }
        }
    }

    trigger OnOpenPage()
    var
        zyxelApitype: enum zyxelApitype;

    begin
        rec.setrange(Apitype, zyxelApitype::Margin);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec.Apitype := zyxelApitype::Margin;
    end;

}
