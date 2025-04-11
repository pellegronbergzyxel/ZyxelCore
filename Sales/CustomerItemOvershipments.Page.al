Page 50062 "Customer/Item Overshipments"
{
    Caption = 'Customer/Item Overshipments';
    PageType = List;
    SourceTable = "Customer/Item Overshipment";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Overshipment %"; Rec."Overshipment %")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        if Rec."Item No." = '' then
                            Rec."Item Name" := Text001;
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Rounding Direction"; Rec."Rounding Direction")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Item No." = '' then
            Rec."Item Name" := Text001;
    end;

    var
        Text001: label '<All/other items>';
}
