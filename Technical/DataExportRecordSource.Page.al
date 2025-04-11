Page 50125 "Data Export Record Source"
{
    AutoSplitKey = true;
    Caption = 'Data Export Record Source';
    DataCaptionFields = "Data Exp. Rec. Type Code";
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    PromotedActionCategories = 'New,Process,Report,Indentation';
    SourceTable = "Data Export Record Source";

    layout
    {
        area(content)
        {
            repeater(Control1140000)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = "Table Name";
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = Objects;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    Enabled = false;
                }
                field("Export Table Name"; Rec."Export Table Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Period Field No."; Rec."Period Field No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Period Field Name"; Rec."Period Field Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Table Filter"; Rec."Table Filter")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        TableFilter: Record "Table Filter";
                        TableFilterPage: Page "Table Filter";
                        TableFilterText: Text;
                    begin
                        TableFilter.FilterGroup(2);
                        TableFilter.SetRange("Table Number", Rec."Table No.");
                        TableFilter.FilterGroup(0);
                        TableFilterPage.SetTableview(TableFilter);
                        TableFilterPage.SetSourceTable(Format(Rec."Table Filter"), Rec."Table No.", Rec."Table Name");
                        if Action::OK = TableFilterPage.RunModal then begin
                            TableFilterText := TableFilterPage.CreateTextTableFilterWithoutTableName(false);
                            if TableFilterText = '' then
                                Evaluate(Rec."Table Filter", '')
                            else
                                Evaluate(Rec."Table Filter", TableFilterPage.CreateTextTableFilter(false));
                            Rec.Validate(Rec."Table Filter");
                        end;
                    end;
                }
                field("Date Filter Field No."; Rec."Date Filter Field No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date Filter Handling"; Rec."Date Filter Handling")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Key No."; Rec."Key No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Export File Name"; Rec."Export File Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Table Relation Defined"; Rec."Table Relation Defined")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    var
                        DataExportManagement: Codeunit "Data Export Management";
                    begin
                        CurrPage.Update(true);
                        Commit;
                        DataExportManagement.UpdateTableRelation(Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
            part("Fields"; "Data Export Record Fields")
            {
                Caption = 'Fields';
                SubPageLink = "Data Export Code" = field("Data Export Code"),
                              "Data Exp. Rec. Type Code" = field("Data Exp. Rec. Type Code"),
                              "Source Line No." = field("Line No."),
                              "Table No." = field("Table No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1140006; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                Image = Setup;
                action(Validate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Validate';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        DataExportRecordDefinition: Record "Data Export Record Definition";
                    begin
                        DataExportRecordDefinition.Get(Rec."Data Export Code", Rec."Data Exp. Rec. Type Code");
                        DataExportRecordDefinition.ValidateExportSources;
                    end;
                }
            }
            group(Indentation)
            {
                Caption = 'Indentation';
                action(Indent)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Indent';
                    Image = Indent;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Indent';

                    trigger OnAction()
                    begin
                        Rec.Validate(Rec.Indentation, Rec.Indentation + 1);
                        CurrPage.Update;
                    end;
                }
                action(Unindent)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unindent';
                    Image = CancelIndent;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Unindent';

                    trigger OnAction()
                    begin
                        Rec.Validate(Rec.Indentation, Rec.Indentation - 1);
                        CurrPage.Update;
                    end;
                }
                action(Relationships)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Relationships';
                    Image = Relationship;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        DataExportManagement: Codeunit "Data Export Management";
                    begin
                        DataExportManagement.UpdateTableRelation(Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        MoveFiltersToFilterGroup(2);
    end;


    procedure MoveFiltersToFilterGroup(FilterGroupNo: Integer)
    var
        Filters: Text;
    begin
        Rec.FilterGroup(0);
        Filters := Rec.GetView;
        Rec.FilterGroup(FilterGroupNo);
        Rec.SetView(Filters);
        Rec.FilterGroup(0);
        Rec.SetView('');
    end;
}
