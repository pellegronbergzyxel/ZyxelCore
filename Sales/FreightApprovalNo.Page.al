Page 50068 "Freight Approval No."
{
    Caption = 'Dimension Values';
    DataCaptionFields = "Dimension Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Dimension Value";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;

                    trigger OnValidate()
                    begin
                        Rec.Name := Rec.Code;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Map-to IC Dimension Value Code"; Rec."Map-to IC Dimension Value Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLine;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Clear(recIcDimValue);
        recIcDimValue.Init;
        recIcDimValue.Validate("Dimension Code", Rec."Dimension Code");
        recIcDimValue.Validate(Code, Rec.Code);
        recIcDimValue.Validate(Name, Rec.Name);
        recIcDimValue.Validate("Map-to Dimension Code", Rec."Dimension Code");
        recIcDimValue."Map-to Dimension Value Code" := Rec.Code;
        recIcDimValue.Insert(true);

        Rec.Validate(Rec."Map-to IC Dimension Code", recIcDimValue."Dimension Code");
        Rec.Validate(Rec."Map-to IC Dimension Value Code", recIcDimValue.Code);
    end;

    trigger OnOpenPage()
    var
        DimensionCode: Code[20];
    begin
        recGenLedgSetup.Get;
        Rec.FilterGroup(2);
        Rec.SetRange(Rec."Dimension Code", recGenLedgSetup."Shortcut Dimension 7 Code");
        Rec.FilterGroup(0);
        Rec.SetRange(Rec.Blocked, false);
    end;

    var
        recGenLedgSetup: Record "General Ledger Setup";
        recIcDimValue: Record "IC Dimension Value";
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure FormatLine()
    begin
        Emphasize := Rec."Dimension Value Type" <> Rec."dimension value type"::Standard;
        NameIndent := Rec.Indentation;
    end;
}
