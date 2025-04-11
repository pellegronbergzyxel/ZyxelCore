Page 50026 "Rework BOM"
{
    AutoSplitKey = true;
    Caption = 'Rework BOM';
    DataCaptionFields = "Parent Item No.";
    PageType = List;
    SourceTable = "Rework Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Parent Item No."; Rec."Parent Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        IsResource := Rec.Type = Rec.Type::Resource
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Rework BOM"; Rec."Rework BOM")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Substitution; Rec.Substitution)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Position 2"; Rec."Position 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Position 3"; Rec."Position 3")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Resource Usage Type"; Rec."Resource Usage Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = IsResource;
                    HideValue = not IsResource;
                    Visible = false;
                }
                field("Part Number Type"; Rec."Part Number Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control18; "Assembly Item - Details")
            {
                Caption = 'Rework Item - Details';
                SubPageLink = "No." = field("Parent Item No.");
            }
            systempart(Control17; Links)
            {
                Visible = false;
            }
            systempart(Control11; Notes)
            {
                Visible = false;
            }
            part(Control13; "Component - Item Details")
            {
                SubPageLink = "No." = field("No.");
            }
            part(Control9; "Component - Resource Details")
            {
                SubPageLink = "No." = field("No.");
                Visible = false;
            }
            part(Control20; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
            part("<Item Picture FactBox>"; "Item Picture FactBox")
            {
                Caption = 'Item Picture';
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Substituti&ons")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Substituti&ons';
                Image = ItemSubstitution;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Substitution Entry";
                RunPageLink = Type = const(Item),
                              "No." = field("No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsResource := Rec.Type = Rec.Type::Resource
    end;

    var
        [InDataSet]
        IsResource: Boolean;
}
