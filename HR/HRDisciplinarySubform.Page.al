Page 50180 "HR Disciplinary Subform"
{
    Caption = 'Disciplinary';
    CardPageID = "HR Disciplinary Line Card";
    DataCaptionFields = "Employee No.";
    Editable = true;
    LinksAllowed = false;
    PageType = ListPart;
    PopulateAllFields = true;
    SaveValues = true;
    SourceTable = "HR Disciplinary Line";
    SourceTableView = sorting("Employee No.", "Date of Warning")
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date of Warning"; Rec."Date of Warning")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50181, Rec);
                    end;
                }
                field("Date of Warning Expiration"; Rec."Date of Warning Expiration")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50181, Rec);
                    end;
                }
                field("Warning Code"; Rec."Warning Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50181, Rec);
                    end;
                }
                field("Warning Description"; Rec."Warning Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50181, Rec);
                    end;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50181, Rec);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Co&mments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Human Resource Comment Sheet";
                RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"HR Disciplinary Line"),
                              "Table Line No." = field(UID);
            }
        }
    }
}
