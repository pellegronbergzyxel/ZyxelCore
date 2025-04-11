Page 50162 "EiCard Queue Card"
{
    PageType = Card;
    SourceTable = "EiCard Queue";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sales Order Status"; Rec."Sales Order Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Purchase Order Status"; Rec."Purchase Order Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                group("E-mail Distribution")
                {
                    Caption = 'E-mail Distribution';
                    field("External Document No."; Rec."External Document No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Distributor E-mail"; Rec."Distributor E-mail")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("End User E-mail"; Rec."End User E-mail")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EiCard To E-mail 2"; Rec."EiCard To E-mail 2")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EiCard To E-mail 3"; Rec."EiCard To E-mail 3")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EiCard To E-mail 4"; Rec."EiCard To E-mail 4")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Order Details")
                {
                    Caption = 'Order Details';
                    field("Distributor Reference"; Rec."Distributor Reference")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("From E-Mail Address"; Rec."From E-Mail Address")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("From E-Mail Signature"; Rec."From E-Mail Signature")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            part(Control18; "EiCard Link Subform")
            {
                SubPageLink = "Purchase Order No." = field("Purchase Order No.");
            }
            group(Quantity)
            {
                Caption = 'Quantity';
                Editable = false;
                field("Quantity Sales Order"; Rec."Quantity Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Links"; Rec."Quantity Links")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No. of Sales Order Lines"; Rec."No. of Sales Order Lines")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No. of EiCard Link Lines"; Rec."No. of EiCard Link Lines")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        if not Rec."Comparision of Qty and Link Ok" then begin
            Rec.CalcFields(Rec."Quantity Links", Rec."Quantity Sales Order");
            if Rec."Quantity Links" = Rec."Quantity Sales Order" then begin
                Rec."Comparision of Qty and Link Ok" := true;
                Rec.Modify;
            end;
        end;
    end;
}
