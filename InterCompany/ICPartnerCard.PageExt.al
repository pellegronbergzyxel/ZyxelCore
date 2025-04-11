pageextension 50219 ICPartnerCardZX extends "IC Partner Card"
{
    layout
    {
        addafter("Cost Distribution in LCY")
        {
            field("Set Posting Date to Today"; Rec."Set Posting Date to Today")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Set Document Date to Today"; Rec."Set Document Date to Today")
            {
                ApplicationArea = Basic, Suite;
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Purchase Order Comm. Type"; Rec."Purchase Order Comm. Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Read Company Infor from Sub"; Rec."Read Company Infor from Sub")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'For some customers we need to read the company information from the company name in the "Inbox Details"';
                }
                field(Skip_sellCustomer; Rec.Skip_sellCustomer)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            Action(selectcustomer)
            {
                caption = 'Set customer no.';
                Image = Customer;
                ApplicationArea = all;
                trigger OnAction()
                var
                    customer: record Customer;
                    Customerlist: page "Customer List";
                begin
                    Customerlist.LookupMode(true);
                    if Customerlist.RunModal() = Action::LookupOK then begin
                        Customerlist.GetRecord(customer);
                        if customer."No." <> '' then begin
                            rec."Customer No." := customer."No.";
                            rec.modify(false);
                            customer."IC Partner Code" := rec.Code;
                            customer.modify(false);
                        end;
                    end



                end;
            }
        }
    }
}
