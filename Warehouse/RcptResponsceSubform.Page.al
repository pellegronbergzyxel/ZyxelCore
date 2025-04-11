Page 50299 "Rcpt Responsce Subform"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML

    Caption = 'Lines';
    DeleteAllowed = false;
    Description = 'Rcpt Responsce Subform';
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Rcpt. Response Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Product No."; Rec."Product No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Warehouse; Rec.Warehouse)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Ordered Qty"; Rec."Ordered Qty")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Source Order No."; Rec."Source Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Source Order Line No."; Rec."Source Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Real Source Order No."; Rec."Real Source Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Real Source Order Line No."; Rec."Real Source Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = editDeveloper;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 7"; Rec."Value 7")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 8"; Rec."Value 8")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 9"; Rec."Value 9")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Purchase Order Qty. Received"; Rec."Purchase Order Qty. Received")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Purchase Order Qty. Invoiced"; Rec."Purchase Order Qty. Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Order';
                Image = ViewOrder;

                trigger OnAction()
                begin
                    ShowOrder;
                end;
            }
            action("Delete line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete line';
                Image = Delete;

                trigger OnAction()
                begin
                    if rec."Invoice No." = '' then
                        if Confirm('Do want to delete line', true) then
                            rec.delete;
                end;
            }
        }
    }

    var
        VCKXML: Codeunit "VCK Communication Management";

    local procedure ShowOrder()
    var
        recRcptRespHead: Record "Rcpt. Response Header";
        recPurchHead: Record "Purchase Header";
        recSalesHead: Record "Sales Header";
        recTransHead: Record "Transfer Header";
    begin
        Rec.CalcFields(Rec."Real Source Order No.");
        recRcptRespHead.Get(Rec."Response No.");
        case recRcptRespHead."Order Type Option" of
            recRcptRespHead."order type option"::"Purchase Order":
                begin
                    recPurchHead.Get(recPurchHead."document type"::Order, Rec."Real Source Order No.");
                    Page.Run(Page::"Purchase Order", recPurchHead);
                end;
            recRcptRespHead."order type option"::"Sales Return Order":
                begin
                    recSalesHead.Get(recSalesHead."document type"::"Return Order", Rec."Real Source Order No.");
                    Page.Run(Page::"Sales Return Order", recSalesHead);
                end;
            recRcptRespHead."order type option"::"Transfer Order":
                begin
                    recTransHead.Get(Rec."Real Source Order No.");
                    Page.Run(Page::"Transfer Order", recTransHead);
                end;
        end;
    end;

    var
        zyxeltool: codeunit "ZyXEL General Tools";
        editDeveloper: boolean;

    trigger OnInit()
    begin
        editDeveloper := zyxeltool.UserIsDeveloper();
    end;
}
