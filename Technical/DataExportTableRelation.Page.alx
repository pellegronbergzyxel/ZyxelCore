Page 50142 "Data Export Table Relation"
{
    Caption = 'Data Export Table Relationship';
    DataCaptionExpression = GetCaption;
    DataCaptionFields = "Data Exp. Rec. Type Code";
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Data Export Record Source";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Relation To Table No."; Rec."Relation To Table No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'From Table No.';
                    Editable = false;
                    Lookup = false;
                }
                field("Relation To Table Name"; Rec."Relation To Table Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'From Table Name';
                    DrillDown = false;
                    Editable = false;
                }
                field(ToTableID; Rec."Table No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Table No.';
                    Editable = false;
                    Lookup = false;
                    LookupPageID = Objects;
                    TableRelation = Object.ID where(Type = const(Table));
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To Table Name';
                    DrillDown = false;
                    Editable = false;
                }
            }
            part(Relationships; "Data Export Table Relation Sub")
            {
                Caption = 'Relationships';
                SubPageLink = "Data Export Code" = field("Data Export Code"),
                              "Data Exp. Rec. Type Code" = field("Data Exp. Rec. Type Code"),
                              "From Table No." = field("Relation To Table No."),
                              "To Table No." = field("Table No.");
                SubPageView = sorting("Data Export Code", "Data Exp. Rec. Type Code", "From Table No.", "From Field No.", "To Table No.", "To Field No.");
            }
        }
    }

    actions
    {
    }

    local procedure GetCaption(): Text[250]
    var
        DataExportRecordType: Record "Data Export Record Type";
    begin
        if DataExportRecordType.Get(Rec."Data Exp. Rec. Type Code") then
            exit(DataExportRecordType.Code + ' ' + DataExportRecordType.Description);
    end;
}
