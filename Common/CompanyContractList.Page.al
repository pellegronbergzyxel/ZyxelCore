Page 50247 "Company Contract List"
{
    Caption = 'Company Contract List';
    Editable = false;
    PageType = List;
    SourceTable = Contact;
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Visible = PageVisible;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            part(Control17; "Company Contract FactBox")
            {
                Caption = 'Contracts';
                SubPageLink = "Customer No." = field("No.");
            }
            part(Control18; "Company Contract Tag FactBox")
            {
                Provider = Control17;
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Contracts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contracts';
                    Image = ContactReference;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Company Contracts";
                    RunPageLink = "Customer No." = field("No.");
                }
            }
        }
        area(processing)
        {
            action("Show Contacts With Contracts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Contacts With Contracts';
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowCustomerWithContractVisible;

                trigger OnAction()
                begin
                    Rec.SetRange(Rec."Company Contract", true);
                    ShowCustomerWithContractVisible := not ShowCustomerWithContractVisible;
                    ShowAllCustomersVisible := not ShowAllCustomersVisible;
                end;
            }
            action("Show All Contacts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show All Contacts';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAllCustomersVisible;

                trigger OnAction()
                begin
                    Rec.SetRange(Rec."Company Contract");
                    ShowCustomerWithContractVisible := not ShowCustomerWithContractVisible;
                    ShowAllCustomersVisible := not ShowAllCustomersVisible;
                end;
            }
            action("Search Contracts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Search Contracts';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Company Contracts";
            }

            group(Create)
            {
                Caption = 'Create';
                action("Create Contact from Vendor")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Contact from Vendor';
                    Image = AddContacts;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Create Conts. from Vendors";
                }
                action("Create Contact from Customer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Contact from Customer';
                    Image = AddContacts;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Create Conts. from Customers";
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        ShowCustomerWithContractVisible := Rec.GetFilter(Rec."Company Contract") = '';
        ShowAllCustomersVisible := not ShowCustomerWithContractVisible;
        PageVisible := UserSetup.Get(UserId) and UserSetup."Show Customer Contracts";
        Rec.SetFilter(Name, '<>%1', '');
    end;

    var
        ShowCustomerWithContractVisible: Boolean;
        ShowAllCustomersVisible: Boolean;
        PageVisible: Boolean;
}
