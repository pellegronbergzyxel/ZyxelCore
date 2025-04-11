page 50280 "Update Item Category (MDM)"
{
    // 001. 08-11-18 ZY-LD 2018110710000138 - Small updates.
    // 002. 21-11-18 ZY-LD 2018112110000049 - Change Log is added.
    // 003. 11-02-19 ZY-LD 2019021110000136 - New field added "PP-Product CAT".
    // 004. 09-08-19 ZY-LD 2019080810000097 - New field.
    // 005. 18-10-19 ZY-LD 000 - HQ Dimensions has moved to the same table.

    ApplicationArea = Basic, Suite;
    Caption = 'Update Item Category (MDM)';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = where(Inactive = const(false));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("NOT ""No PLMS Update"""; not Rec."No PLMS Update")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Updated by HQ';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(blockedReason; Rec."Block Reason")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Blocked Reason';
                    Editable = false;
                    Visible = false;
                }
                field(Control6; Rec."Category 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = PLMSUpdateEnable;
                    StyleExpr = PLMSUpdateStyle;
                }
                field(Control7; Rec."Category 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = PLMSUpdateEnable;
                }
                field(Control8; Rec."Category 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = PLMSUpdateEnable;
                }
                field(Control33; Rec."Category 4 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Control9; Rec."Business Center")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = PLMSUpdateEnable;
                }
                field(Control10; Rec.SBU)
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = PLMSUpdateEnable;
                }
                field("PP-Product CAT"; Rec."PP-Product CAT")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EAC Ready"; Rec."EAC Ready")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchases (Qty.)"; Rec."Purchases (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Purchases (LCY)"; Rec."Purchases (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sales (Qty.)"; Rec."Sales (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales (Qty.) Year';
                }
                field("Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales (LCY) Year';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control12; Notes)
            {
            }
            systempart(Control13; MyNotes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Update)
            {
                Caption = 'Update';
                Action("Category 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 1 Code';
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        UpdateFields(Rec.FieldNo(Rec."Category 1 Code"), Rec.FieldCaption(Rec."Category 1 Code"));
                    end;
                }
                Action("Category 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 2 Code';
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        UpdateFields(Rec.FieldNo(Rec."Category 2 Code"), Rec.FieldCaption(Rec."Category 2 Code"));
                    end;
                }
                Action("Category 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 3 Code';
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        UpdateFields(Rec.FieldNo(Rec."Category 3 Code"), Rec.FieldCaption(Rec."Category 3 Code"));
                    end;
                }
                Action("Category 4 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 4 Code';
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        UpdateFields(Rec.FieldNo(Rec."Category 4 Code"), Rec.FieldCaption(Rec."Category 4 Code"));  // 08-11-18 ZY-LD 001
                    end;
                }
                Action("Business Center")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Business Center';
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        UpdateFields(Rec.FieldNo(Rec."Business Center"), Rec.FieldCaption(Rec."Business Center"));
                    end;
                }
                Action(SBU)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'SBU';
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        UpdateFields(Rec.FieldNo(Rec.SBU), Rec.FieldCaption(Rec.SBU));
                    end;
                }
            }
            group("Filter")
            {
                Caption = 'Filter';
                Action("All Three Categories are Blank")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Three Categories are Blank';
                    Image = FilterLines;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Rec."Category 1 Code", '');
                        Rec.SetRange(Rec."Category 2 Code", '');
                        Rec.SetRange(Rec."Category 3 Code", '');
                    end;
                }
                Action("One Category is Blank")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'One Category is Blank';
                    Image = FilterLines;

                    trigger OnAction()
                    begin
                        if Rec.FindFirst() then begin
                            ZGT.OpenProgressWindow('', Rec.Count());
                            repeat
                                ZGT.UpdateProgressWindow(Rec."No.", 0, true);

                                if Rec."Category 1 Code" = '' then
                                    Rec.Mark(true)
                                else
                                    if Rec."Category 2 Code" = '' then
                                        Rec.Mark(true)
                                    else
                                        if Rec."Category 3 Code" = '' then
                                            Rec.Mark(true);
                            until Rec.Next() = 0;
                            Rec.MarkedOnly(true);
                            ZGT.CloseProgressWindow;
                        end;
                    end;
                }
                Action("Amount Different from Zero")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount Different from Zero';
                    Image = FilterLines;

                    trigger OnAction()
                    begin
                        Rec.SetFilter(Rec."Sales (LCY)", '>0');
                    end;
                }
                Action("Show all")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show all';
                    Image = RemoveFilterLines;

                    trigger OnAction()
                    begin
                        Rec.MarkedOnly(false);
                        Rec.ClearMarks;
                        Rec.SetRange(Rec."Category 1 Code");
                        Rec.SetRange(Rec."Category 2 Code");
                        Rec.SetRange(Rec."Category 3 Code");
                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                Action(Action39)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(27));
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Rec."Date Filter", CalcDate('<-1Y>', Today), Today);
    end;

    var
        GenericInputPage: Page "Generic Input Page";
        ZGT: Codeunit "ZyXEL General Tools";
        PLMSUpdateEnable: Boolean;
        PLMSUpdateStyle: Text;

    local procedure UpdateFields(pFieldNo: Integer; pFieldCaption: Text)
    var
        recItem: Record Item;
        lText001: Label 'Update %1';
        recHqDim: Record SBU;
        lText002: Label 'Do you want to blank %1 on %2 line(s)?';
        lText003: Label 'Do you want to update %1 on %2 line(s)?\Fields updated by HQ will not be updated in this run.';
        lText004: Label 'The %1 does not exist. Identification fields and values: Code="%2".';
    begin
        CurrPage.SetSelectionFilter(recItem);
        if recItem.FindFirst() then begin
            Clear(GenericInputPage);
            GenericInputPage.SetPageCaption(StrSubstNo(lText001, pFieldCaption));
            GenericInputPage.SetFieldCaption(pFieldCaption);
            GenericInputPage.SetVisibleField(3);
            if GenericInputPage.RunModal = Action::OK then begin
                if GenericInputPage.GetCode20 = '' then begin
                    if not Confirm(lText002, false, pFieldCaption, recItem.Count()) then
                        exit;
                end else
                    //>> 08-11-18 ZY-LD 001
                    if not Confirm(lText003, false, pFieldCaption, recItem.Count()) then
                        exit;
                //<< 08-11-18 ZY-LD 001
                repeat
                    case pFieldNo of
                        recItem.FieldNo("Category 1 Code"):
                            begin
                                if recItem."No PLMS Update" then  // 08-11-18 ZY-LD 001
                                    if GenericInputPage.GetCode20 <> '' then begin
                                        //>> 18-10-19 ZY-LD 005
                                        //recCat1.GET(GenericInputPage.GetCode20);
                                        if not recHqDim.Get(recHqDim.Type::"Category 1", GenericInputPage.GetCode20) then
                                            Error(lText004, recHqDim.Type::"Category 1", GenericInputPage.GetCode20);
                                        //<< 18-10-19 ZY-LD 005
                                        recItem.Validate("Category 1 Code", GenericInputPage.GetCode20);
                                    end else
                                        recItem.Validate("Category 1 Code", '');
                            end;
                        recItem.FieldNo("Category 2 Code"):
                            begin
                                if recItem."No PLMS Update" then  // 08-11-18 ZY-LD 001
                                    if GenericInputPage.GetCode20 <> '' then begin
                                        //>> 18-10-19 ZY-LD 005
                                        //recCat2.GET(GenericInputPage.GetCode20);
                                        if not recHqDim.Get(recHqDim.Type::"Category 2", GenericInputPage.GetCode20) then
                                            Error(lText004, recHqDim.Type::"Category 2", GenericInputPage.GetCode20);
                                        //<< 18-10-19 ZY-LD 005
                                        recItem.Validate("Category 2 Code", GenericInputPage.GetCode20);
                                    end else
                                        recItem.Validate("Category 2 Code", '');
                            end;
                        recItem.FieldNo("Category 3 Code"):
                            begin
                                if recItem."No PLMS Update" then  // 08-11-18 ZY-LD 001
                                    if GenericInputPage.GetCode20 <> '' then begin
                                        //>> 18-10-19 ZY-LD 005
                                        //recCat3.GET(GenericInputPage.GetCode20);
                                        if recHqDim.Get(recHqDim.Type::"Category 3", GenericInputPage.GetCode20) then
                                            Error(lText004, recHqDim.Type::"Category 3", GenericInputPage.GetCode20);
                                        //<< 18-10-19 ZY-LD 005
                                        recItem.Validate("Category 3 Code", GenericInputPage.GetCode20);
                                    end else
                                        recItem.Validate("Category 3 Code", '');
                            end;
                        //>> 08-11-18 ZY-LD 001
                        recItem.FieldNo("Category 4 Code"):
                            begin
                                if GenericInputPage.GetCode20 <> '' then begin
                                    //>> 18-10-19 ZY-LD 005
                                    //recCat3.GET(GenericInputPage.GetCode20);
                                    if recHqDim.Get(recHqDim.Type::"Category 4", GenericInputPage.GetCode20) then
                                        Error(lText004, recHqDim.Type::"Category 4", GenericInputPage.GetCode20);
                                    //<< 18-10-19 ZY-LD 005
                                    recItem.Validate("Category 4 Code", GenericInputPage.GetCode20);
                                end else
                                    recItem.Validate("Category 4 Code", '');
                            end;
                        //<< 08-11-18 ZY-LD 001
                        recItem.FieldNo("Business Center"):
                            begin
                                if recItem."No PLMS Update" then  // 08-11-18 ZY-LD 001
                                    if GenericInputPage.GetCode20 <> '' then begin
                                        //>> 18-10-19 ZY-LD 005
                                        //recBusCenter.GET(GenericInputPage.GetCode20);
                                        if not recHqDim.Get(recHqDim.Type::"Business Center", GenericInputPage.GetCode20) then
                                            Error(lText004, recHqDim.Type::"Business Center", GenericInputPage.GetCode20);
                                        //<< 18-10-19 ZY-LD 005
                                        recItem.Validate("Business Center", GenericInputPage.GetCode20);
                                    end else
                                        recItem.Validate("Business Center", '');
                            end;
                        recItem.FieldNo(SBU):
                            begin
                                if recItem."No PLMS Update" then  // 08-11-18 ZY-LD 001
                                    if GenericInputPage.GetCode20 <> '' then begin
                                        //>> 18-10-19 ZY-LD 005
                                        //recSBU.GET(GenericInputPage.GetCode20);
                                        if not recHqDim.Get(recHqDim.Type::SBU, GenericInputPage.GetCode20) then
                                            Error(lText004, recHqDim.Type::SBU, GenericInputPage.GetCode20);
                                        //<< 18-10-19 ZY-LD 005
                                        recItem.Validate(SBU, GenericInputPage.GetCode20);
                                    end else
                                        recItem.Validate(SBU, '');
                            end;
                    end;
                    recItem.Modify(true);
                until recItem.Next() = 0;
            end;
        end;
    end;

    local procedure SetActions()
    begin
        //>> 08-11-18 ZY-LD 001
        if ZGT.IsRhq then
            PLMSUpdateEnable := Rec."No PLMS Update"
        else
            PLMSUpdateEnable := false;

        if not PLMSUpdateEnable then
            PLMSUpdateStyle := 'Attention'
        else
            PLMSUpdateStyle := 'Standard';
        //<< 08-11-18 ZY-LD 001
    end;
}
