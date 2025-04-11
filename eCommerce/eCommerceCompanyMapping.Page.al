page 50222 "eCommerce Company Mapping"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Market Place';
    CardPageID = "eCommerce Company Mapping Card";
    Editable = false;
    PageType = List;
    SourceTable = "eCommerce Market Place";
    UsageCategory = Administration;
    AdditionalSearchTerms = 'ecommerce setup';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Marketplace ID"; Rec."Marketplace ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Market Place Name"; Rec."Market Place Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Main Market Place ID"; Rec."Main Market Place ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Copy Company Mapping")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy Company Mapping';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CopyMapping;
                end;
            }
        }
    }

    local procedure CopyMapping()
    var
        lText001: Label 'Do you want to copy marketplace "%1" to "%2"?';
        recAznCompMap: Record "eCommerce Market Place";
        GenericInputPage: Page "Generic Input Page";
        lText002: Label 'Copy Marketplace';
        lText003: Label 'Copy To';
        lText004: Label '"%1" was not found.';
    begin
        GenericInputPage.SetPageCaption(lText002);
        GenericInputPage.SetFieldCaption(lText003);
        GenericInputPage.SetVisibleField(3);  // Code
        if GenericInputPage.RunModal = Action::OK then begin
            recAznCompMap.SetRange("Default Mapping", true);
            if recAznCompMap.FindFirst() then begin
                if Confirm(lText001, false, Rec."Marketplace ID", GenericInputPage.GetCode20) then begin
                    recAznCompMap.CopyDefaultMapping(GenericInputPage.GetCode20);
                    CurrPage.Update();
                end;
            end else
                Message(lText004, recAznCompMap.FieldCaption("Default Mapping"));
        end;
    end;
}
