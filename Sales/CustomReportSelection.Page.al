page 50111 "Custom Report Selection"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Custom Report Selection';
    PageType = List;
    SourceTable = "Custom Report Selection";
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Custom Report Description"; Rec."Custom Report Description")
                {
                    ToolTip = 'Specifies a description of the custom report layout.';
                }
                field("Custom Report Layout Code"; Rec."Custom Report Layout Code")
                {
                    ToolTip = 'Specifies the value of the Custom Report Layout Code field.', Comment = '%';
                }
                field("Email Body Layout Code"; Rec."Email Body Layout Code")
                {
                    ToolTip = 'Specifies the ID of the email body layout that is used.';
                }
                field("Email Body Layout Description"; Rec."Email Body Layout Description")
                {
                    ToolTip = 'Specifies a description of the email body layout that is used.';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ToolTip = 'Specifies the name of the report.';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ToolTip = 'Specifies the ID of the report.';
                }
                field("Selected Contacts Filter"; Rec."Selected Contacts Filter")
                {
                    ToolTip = 'Specifies the value of the Selected Contacts Filter field.', Comment = '%';
                }
                field("Send To Email"; Rec."Send To Email")
                {
                    ToolTip = 'Specifies that the report is used when sending emails.';
                }
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Specifies the value of the Sequence field.', Comment = '%';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the value of the Source Type field.', Comment = '%';
                }
                field(Usage; Rec.Usage)
                {
                    ToolTip = 'Specifies the value of the Usage field.', Comment = '%';
                }
                field("Use Email from Contact"; Rec."Use Email from Contact")
                {
                    ToolTip = 'Specifies the value of the Use Email from Contacts field.', Comment = '%';
                }
                field("Use for Email Attachment"; Rec."Use for Email Attachment")
                {
                    ToolTip = 'Specifies the value of the Use for Email Attachment field.', Comment = '%';
                }
                field("Use for Email Body"; Rec."Use for Email Body")
                {
                    ToolTip = 'Specifies that summarized information, such as invoice number, due date, and payment service link, will be inserted in the body of the email that you send.';
                }
            }
        }
    }
}
