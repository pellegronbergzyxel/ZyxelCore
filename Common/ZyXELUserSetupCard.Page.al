page 50021 "ZyXEL User Setup Card"
{
    // 001. 26-10-17 ZY-LD New field.
    // 002. 06-12-18 ZY-LD New field.
    // 003. 19-02-20 ZY-LD New field.

    PageType = Card;
    SourceTable = "User Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Substitute; Rec.Substitute)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = EmployeeIdVisible;
                }
                field(MDM; Rec.MDM)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(SCM; Rec.SCM)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User Type"; Rec."User Type")
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Show Concur ID"; Rec."Show Concur ID")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Use User E-mail on Documents"; Rec."Use User E-mail on Documents")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Control44)
                {
                    field("E-Mail Footer Name"; Rec."E-Mail Footer Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Footer Address"; Rec."E-mail Footer Address")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Footer Address 2"; Rec."E-mail Footer Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Footer Address 3"; Rec."E-mail Footer Address 3")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Footer Mobile Phone No."; Rec."E-mail Footer Mobile Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Footer Phone No."; Rec."E-mail Footer Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Allow Posting From"; Rec."Allow Posting From")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Posting To"; Rec."Allow Posting To")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Register Time"; Rec."Register Time")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Items)
            {
                Caption = 'Items';
                field("Can Block Items"; Rec."Can Block Items")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Show Goods in Transit as"; Rec."Show Goods in Transit as")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                field("Approval Administrator"; Rec."Approval Administrator")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Amount Approval Limit"; Rec."Sales Amount Approval Limit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Amount Approval Limit"; Rec."Purchase Amount Approval Limit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unlimited Sales Approval"; Rec."Unlimited Sales Approval")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unlimited Purchase Approval"; Rec."Unlimited Purchase Approval")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Request Amount Approval Limit"; Rec."Request Amount Approval Limit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unlimited Request Approval"; Rec."Unlimited Request Approval")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Sales Order")
            {
                Caption = 'Sales Order';
                field("Confirm Shipment Date on SL"; Rec."Confirm Shipment Date on SL")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sort Sales Order by Prim. Key"; Rec."Sort Sales Order by Prim. Key")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(EiCards)
            {
                Caption = 'EiCards';
                field("EMail Signature"; Rec."EMail Signature")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EMail Signature';
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                field("Allow FA Posting From"; Rec."Allow FA Posting From")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow FA Posting To"; Rec."Allow FA Posting To")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Company Contracts")
            {
                Caption = 'Company Contracts';
                field("Show Customer Contracts"; Rec."Show Customer Contracts")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = ShowCompanyContractEditable;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    local procedure SetActions()
    var
        UserSetup: Record "User Setup";
    begin
        EmployeeIdVisible := Rec.WritePermission;
        ShowCompanyContractEditable := not (UserSetup."User Type" IN [UserSetup."User Type"::"Accounting Manager", UserSetup."User Type"::"Human Resource"]);
    end;

    var
        EmployeeIdVisible: Boolean;
        ShowCompanyContractEditable: Boolean;
}
