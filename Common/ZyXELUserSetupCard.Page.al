page 50021 "ZyXEL User Setup Card"
{
    // 001. 26-10-17 ZY-LD New field.
    // 002. 06-12-18 ZY-LD New field.
    // 003. 19-02-20 ZY-LD New field.

    PageType = Card;
    SourceTable = "User Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    toolTip = 'Specifies the User ID';
                }
                field(Substitute; Rec.Substitute)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Substitute User ID';
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Salesperson/Purchaser Code';
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = EmployeeIdVisible;
                    ToolTip = 'Specifies the Employee ID';
                }
                field(MDM; Rec.MDM)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies MDM';
                }
                field(SCM; Rec.SCM)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies SCM';
                }
                field("User Type"; Rec."User Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the User Type';
                }

                field("Show Concur ID"; Rec."Show Concur ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Concur ID';
                }
                field("Allow Force Margin Approval"; Rec."Allow Force Margin Approval")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Allow Force Margin Approval';
                }
                field("Allow Change Incoterms on DD"; Rec."Allow Change Incoterms on DD") //01-06-2026 BK #573882
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Allow Change Incoterms on Document Delivery';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the E-Mail address';
                }
                field("Use User E-mail on Documents"; Rec."Use User E-mail on Documents")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to use the user e-mail on documents';
                }
                group(Control44)
                {
                    field("E-Mail Footer Name"; Rec."E-Mail Footer Name")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the E-Mail Footer Name';
                    }
                    field("E-mail Footer Address"; Rec."E-mail Footer Address")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the E-Mail Footer Address';
                    }
                    field("E-mail Footer Address 2"; Rec."E-mail Footer Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the E-Mail Footer Address 2';
                    }
                    field("E-mail Footer Address 3"; Rec."E-mail Footer Address 3")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the E-Mail Footer Address 3';
                    }
                    field("E-mail Footer Mobile Phone No."; Rec."E-mail Footer Mobile Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the E-Mail Footer Mobile Phone No.';
                    }
                    field("E-mail Footer Phone No."; Rec."E-mail Footer Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the E-Mail Footer Phone No.';
                    }
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Allow Posting From"; Rec."Allow Posting From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Allow Posting From';
                }
                field("Allow Posting To"; Rec."Allow Posting To")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Allow Posting To';
                }
                field("Register Time"; Rec."Register Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Register Time';
                }
            }
            group(Items)
            {
                Caption = 'Items';
                field("Can Block Items"; Rec."Can Block Items")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the user can block items';
                }
                field("Show Goods in Transit as"; Rec."Show Goods in Transit as")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how to display goods in transit';
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                field("Approval Administrator"; Rec."Approval Administrator")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the user is an approval administrator';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Approver ID';
                }
                field("Sales Amount Approval Limit"; Rec."Sales Amount Approval Limit")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sales Amount Approval Limit';
                }
                field("Purchase Amount Approval Limit"; Rec."Purchase Amount Approval Limit")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Purchase Amount Approval Limit';
                }
                field("Unlimited Sales Approval"; Rec."Unlimited Sales Approval")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the user has unlimited sales approval';
                }
                field("Unlimited Purchase Approval"; Rec."Unlimited Purchase Approval")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the user has unlimited purchase approval';
                }
                field("Request Amount Approval Limit"; Rec."Request Amount Approval Limit")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the request amount approval limit';
                }
                field("Unlimited Request Approval"; Rec."Unlimited Request Approval")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the user has unlimited request approval';
                }
            }
            group("Sales Order")
            {
                Caption = 'Sales Order';
                field("Confirm Shipment Date on SL"; Rec."Confirm Shipment Date on SL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to confirm the shipment date on sales lines';

                }
                field("Sort Sales Order by Prim. Key"; Rec."Sort Sales Order by Prim. Key")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to sort sales orders by primary key';

                }
            }
            group(EiCards)
            {
                Caption = 'EiCards';
                field("EMail Signature"; Rec."EMail Signature")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EMail Signature';
                    ToolTip = 'Specifies the E-Mail signature';
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                field("Allow FA Posting From"; Rec."Allow FA Posting From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Allow Posting From';
                }
                field("Allow FA Posting To"; Rec."Allow FA Posting To")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Allow Posting To';
                }
            }
            group("Company Contracts")
            {
                Caption = 'Company Contracts';
                field("Show Customer Contracts"; Rec."Show Customer Contracts")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to show customer contracts';
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
        EmployeeIdVisible := Rec.WritePermission();
        ShowCompanyContractEditable := not (UserSetup."User Type" IN [UserSetup."User Type"::"Accounting Manager", UserSetup."User Type"::"Human Resource"]);
    end;

    var
        EmployeeIdVisible: Boolean;
        ShowCompanyContractEditable: Boolean;
}
