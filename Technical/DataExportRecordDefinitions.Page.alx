Page 50039 "Data Export Record Definitions"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Data Export Record Definitions';
    DataCaptionFields = "Data Export Code";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Record Definition,DTD File';
    SourceTable = "Data Export Record Definition";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1140000)
            {
                field("Data Export Code"; Rec."Data Export Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Data Export Code';
                    Visible = false;
                }
                field("Data Exp. Rec. Type Code"; Rec."Data Exp. Rec. Type Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Data Export Record Type Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                }
                field("Export Path"; Rec."Export Path")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Export Path';
                }
                field("DTD File Name"; Rec."DTD File Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'DTD File Nam>';
                }
                field("Export Language"; Rec."Export Language")
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
            group("Record Definition")
            {
                Caption = 'Record Definition';
                Image = XMLFile;
                action("Data Export Record Source")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Record Source';
                    Image = EditLines;
                    RunObject = Page "Data Export Record Source";
                    RunPageLink = "Data Export Code" = field("Data Export Code"),
                                  "Data Exp. Rec. Type Code" = field("Data Exp. Rec. Type Code");
                    RunPageView = sorting("Data Export Code", "Data Exp. Rec. Type Code", "Line No.");
                }
            }
        }
        area(processing)
        {
            group(ActionGroup2)
            {
                Caption = 'Record Definition';
                Image = XMLFile;
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
                action(Action1140010)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Export';
                    Image = ExportFile;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        DataExportRecordDefinition: Record "Data Export Record Definition";
                        ExportBusinessData: Report "Export Business Data";
                    begin
                        DataExportRecordDefinition.Reset;
                        DataExportRecordDefinition.SetRange("Data Export Code", Rec."Data Export Code");
                        DataExportRecordDefinition.SetRange("Data Exp. Rec. Type Code", Rec."Data Exp. Rec. Type Code");
                        ExportBusinessData.SetTableview(DataExportRecordDefinition);
                        ExportBusinessData.Run;
                        Clear(ExportBusinessData);
                    end;
                }
            }
            group("DTD File")
            {
                Caption = 'DTD File';
                Image = XMLFile;
                action(Import)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import';
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.ImportFile(Rec);
                        CurrPage.Update;
                    end;
                }
                action(Export)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Export';
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.ExportFile(Rec, true);
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
