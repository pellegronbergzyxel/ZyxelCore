page 50152 "Customer All"
{ //27-10-2026 BK #61070
    PageType = List;
    SourceTable = Customer;
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    Caption = 'Customer All';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Customers)
            {
                field("Std No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No..';
                }
                field("Std Name"; Rec."Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Name.';
                }
                field("Std Search Name"; Rec."Search Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Search Name.';
                }
                field("Std Name 2"; Rec."Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Name 2.';
                }
                field("Std Address"; Rec."Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Address.';
                }
                field("Std Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Address 2.';
                }
                field("Std City"; Rec."City")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field City.';
                }
                field("Std Contact"; Rec."Contact")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Contact.';
                }
                field("Std Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Phone No..';
                }
                field("Std Telex No."; Rec."Telex No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Telex No..';
                }
                field("Std Document Sending Profile"; Rec."Document Sending Profile")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Document Sending Profile.';
                }
                field("Std Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Ship-to Code.';
                }
                field("Std Our Account No."; Rec."Our Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Our Account No..';
                }
                field("Std Territory Code"; Rec."Territory Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Territory Code.';
                }
                field("Std Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Global Dimension 1 Code.';
                }
                field("Std Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Global Dimension 2 Code.';
                }
                field("Std Chain Name"; Rec."Chain Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Chain Name.';
                }
                field("Std Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Budgeted Amount.';
                }
                field("Std Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Credit Limit (LCY).';
                }
                field("Std Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Customer Posting Group.';
                }
                field("Std Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Currency Code.';
                }
                field("Std Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Customer Price Group.';
                }
                field("Std Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Language Code.';
                }
                field("Std Registration Number"; Rec."Registration Number")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Registration Number.';
                }
                field("Std Statistics Group"; Rec."Statistics Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Statistics Group.';
                }
                field("Std Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Payment Terms Code.';
                }
                field("Std Fin. Charge Terms Code"; Rec."Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Fin. Charge Terms Code.';
                }
                field("Std Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Salesperson Code.';
                }
                field("Std Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Shipment Method Code.';
                }
                field("Std Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Shipping Agent Code.';
                }
                field("Std Place of Export"; Rec."Place of Export")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Place of Export.';
                }
                field("Std Invoice Disc. Code"; Rec."Invoice Disc. Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Invoice Disc. Code.';
                }
                field("Std Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Customer Disc. Group.';
                }
                field("Std Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Country/Region Code.';
                }
                field("Std Collection Method"; Rec."Collection Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Collection Method.';
                }
                field("Std Amount"; Rec."Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Amount.';
                }
                field("Std Comment"; Rec."Comment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Comment.';
                }
                field("Std Blocked"; Rec."Blocked")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Blocked.';
                }
                field("Std Invoice Copies"; Rec."Invoice Copies")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Invoice Copies.';
                }
                field("Std Last Statement No."; Rec."Last Statement No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Last Statement No..';
                }
                field("Std Print Statements"; Rec."Print Statements")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Print Statements.';
                }
                field("Std Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-to Customer No..';
                }
                field("Std Priority"; Rec."Priority")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Priority.';
                }
                field("Std Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Payment Method Code.';
                }
                field("Std Format Region"; Rec."Format Region")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Format Region.';
                }
                field("Std Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Last Modified Date Time.';
                }
                field("Std Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Last Date Modified.';
                }

                field("Std Balance"; Rec."Balance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Balance.';
                }
                field("Std Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Balance (LCY).';
                }
                field("Std Net Change"; Rec."Net Change")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Net Change.';
                }
                field("Std Net Change (LCY)"; Rec."Net Change (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Net Change (LCY).';
                }
                field("Std Sales (LCY)"; Rec."Sales (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Sales (LCY).';
                }
                field("Std Profit (LCY)"; Rec."Profit (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Profit (LCY).';
                }
                field("Std Inv. Discounts (LCY)"; Rec."Inv. Discounts (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Inv. Discounts (LCY).';
                }
                field("Std Pmt. Discounts (LCY)"; Rec."Pmt. Discounts (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Pmt. Discounts (LCY).';
                }
                field("Std Balance Due"; Rec."Balance Due")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Balance Due.';
                }
                field("Std Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Balance Due (LCY).';
                }
                field("Std Payments"; Rec."Payments")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Payments.';
                }
                field("Std Invoice Amounts"; Rec."Invoice Amounts")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Invoice Amounts.';
                }
                field("Std Cr. Memo Amounts"; Rec."Cr. Memo Amounts")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Cr. Memo Amounts.';
                }
                field("Std Finance Charge Memo Amounts"; Rec."Finance Charge Memo Amounts")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Finance Charge Memo Amounts.';
                }
                field("Std Payments (LCY)"; Rec."Payments (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Payments (LCY).';
                }
                field("Std Inv. Amounts (LCY)"; Rec."Inv. Amounts (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Inv. Amounts (LCY).';
                }
                field("Std Cr. Memo Amounts (LCY)"; Rec."Cr. Memo Amounts (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Cr. Memo Amounts (LCY).';
                }
                field("Std Fin. Charge Memo Amounts (LCY)"; Rec."Fin. Charge Memo Amounts (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Fin. Charge Memo Amounts (LCY).';
                }
                field("Std Outstanding Orders"; Rec."Outstanding Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Outstanding Orders.';
                }
                field("Std Shipped Not Invoiced"; Rec."Shipped Not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Shipped Not Invoiced.';
                }
                field("Std Application Method"; Rec."Application Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Application Method.';
                }
                field("Std Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Prices Including VAT.';
                }
                field("Std Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Location Code.';
                }
                field("Std Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Fax No..';
                }
                field("Std Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Telex Answer Back.';
                }
                field("Std VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field VAT Registration No..';
                }
                field("Std Combine Shipments"; Rec."Combine Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Combine Shipments.';
                }
                field("Std Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Gen. Bus. Posting Group.';
                }
                field("Std GLN"; Rec."GLN")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field GLN.';
                }
                field("Std Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Post Code.';
                }
                field("Std County"; Rec."County")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field County.';
                }
                field("Std EORI Number"; Rec."EORI Number")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field EORI Number.';
                }
                field("Std Use GLN in Electronic Document"; Rec."Use GLN in Electronic Document")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Use GLN in Electronic Document.';
                }
                field("Std Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Debit Amount.';
                }
                field("Std Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Credit Amount.';
                }
                field("Std Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Debit Amount (LCY).';
                }
                field("Std Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Credit Amount (LCY).';
                }
                field("Std E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field E-Mail.';
                }
                field("Std Reminder Terms Code"; Rec."Reminder Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Reminder Terms Code.';
                }
                field("Std Reminder Amounts"; Rec."Reminder Amounts")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Reminder Amounts.';
                }
                field("Std Reminder Amounts (LCY)"; Rec."Reminder Amounts (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Reminder Amounts (LCY).';
                }
                field("Std No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. Series.';
                }
                field("Std Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Tax Area Code.';
                }
                field("Std Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Tax Liable.';
                }
                field("Std VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field VAT Bus. Posting Group.';
                }
                field("Std Outstanding Orders (LCY)"; Rec."Outstanding Orders (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Outstanding Orders (LCY).';
                }
                field("Std Shipped Not Invoiced (LCY)"; Rec."Shipped Not Invoiced (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Shipped Not Invoiced (LCY).';
                }
                field("Std Reserve"; Rec."Reserve")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Reserve.';
                }
                field("Std Block Payment Tolerance"; Rec."Block Payment Tolerance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Block Payment Tolerance.';
                }
                field("Std Pmt. Disc. Tolerance (LCY)"; Rec."Pmt. Disc. Tolerance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Pmt. Disc. Tolerance (LCY).';
                }
                field("Std Pmt. Tolerance (LCY)"; Rec."Pmt. Tolerance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Pmt. Tolerance (LCY).';
                }
                field("Std IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field IC Partner Code.';
                }
                field("Std Refunds"; Rec."Refunds")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Refunds.';
                }
                field("Std Refunds (LCY)"; Rec."Refunds (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Refunds (LCY).';
                }
                field("Std Other Amounts"; Rec."Other Amounts")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Other Amounts.';
                }
                field("Std Other Amounts (LCY)"; Rec."Other Amounts (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Other Amounts (LCY).';
                }
                field("Std Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Prepayment %.';
                }
                field("Std Outstanding Invoices (LCY)"; Rec."Outstanding Invoices (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Outstanding Invoices (LCY).';
                }
                field("Std Outstanding Invoices"; Rec."Outstanding Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Outstanding Invoices.';
                }
                field("Std Bill-to No. Of Archived Doc."; Rec."Bill-to No. Of Archived Doc.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-to No. Of Archived Doc..';
                }
                field("Std Sell-to No. Of Archived Doc."; Rec."Sell-to No. Of Archived Doc.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Sell-to No. Of Archived Doc..';
                }
                field("Std Partner Type"; Rec."Partner Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Partner Type.';
                }
                field("Std Intrastat Partner Type"; Rec."Intrastat Partner Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Intrastat Partner Type.';
                }
                field("Std Exclude from Pmt. Practices"; Rec."Exclude from Pmt. Practices")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Exclude from Pmt. Practices.';
                }
                field("Std Image"; Rec."Image")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Image.';
                }
                field("Std Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Privacy Blocked.';
                }
                field("Std Disable Search by Name"; Rec."Disable Search by Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Disable Search by Name.';
                }
                field("Std Allow Multiple Posting Groups"; Rec."Allow Multiple Posting Groups")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Allow Multiple Posting Groups.';
                }
                field("Std Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Preferred Bank Account Code.';
                }
                field("Std Coupled to Dataverse"; Rec."Coupled to Dataverse")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Coupled to Dataverse.';
                }
                field("Std Cash Flow Payment Terms Code"; Rec."Cash Flow Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Cash Flow Payment Terms Code.';
                }
                field("Std Primary Contact No."; Rec."Primary Contact No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Primary Contact No..';
                }
                field("Std Contact Type"; Rec."Contact Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Contact Type.';
                }
                field("Std Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Mobile Phone No..';
                }
                field("Std Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Responsibility Center.';
                }
                field("Std Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Shipping Advice.';
                }
                field("Std Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Shipping Time.';
                }
                field("Std Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Shipping Agent Service Code.';
                }
                field("Std Price Calculation Method"; Rec."Price Calculation Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Price Calculation Method.';
                }
                field("Std Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Allow Line Disc..';
                }
                field("Std No. of Quotes"; Rec."No. of Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Quotes.';
                }
                field("Std No. of Blanket Orders"; Rec."No. of Blanket Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Blanket Orders.';
                }
                field("Std No. of Orders"; Rec."No. of Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Orders.';
                }
                field("Std No. of Invoices"; Rec."No. of Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Invoices.';
                }
                field("Std No. of Return Orders"; Rec."No. of Return Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Return Orders.';
                }
                field("Std No. of Credit Memos"; Rec."No. of Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Credit Memos.';
                }
                field("Std No. of Pstd. Shipments"; Rec."No. of Pstd. Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Pstd. Shipments.';
                }
                field("Std No. of Pstd. Invoices"; Rec."No. of Pstd. Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Pstd. Invoices.';
                }
                field("Std No. of Pstd. Return Receipts"; Rec."No. of Pstd. Return Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Pstd. Return Receipts.';
                }
                field("Std No. of Pstd. Credit Memos"; Rec."No. of Pstd. Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Pstd. Credit Memos.';
                }
                field("Std No. of Ship-to Addresses"; Rec."No. of Ship-to Addresses")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field No. of Ship-to Addresses.';
                }
                field("Std Bill-To No. of Quotes"; Rec."Bill-To No. of Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Quotes.';
                }
                field("Std Bill-To No. of Blanket Orders"; Rec."Bill-To No. of Blanket Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Blanket Orders.';
                }
                field("Std Bill-To No. of Orders"; Rec."Bill-To No. of Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Orders.';
                }
                field("Std Bill-To No. of Invoices"; Rec."Bill-To No. of Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Invoices.';
                }
                field("Std Bill-To No. of Return Orders"; Rec."Bill-To No. of Return Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Return Orders.';
                }
                field("Std Bill-To No. of Credit Memos"; Rec."Bill-To No. of Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Credit Memos.';
                }
                field("Std Bill-To No. of Pstd. Shipments"; Rec."Bill-To No. of Pstd. Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Pstd. Shipments.';
                }
                field("Std Bill-To No. of Pstd. Invoices"; Rec."Bill-To No. of Pstd. Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Pstd. Invoices.';
                }
                field("Std Bill-To No. of Pstd. Return R."; Rec."Bill-To No. of Pstd. Return R.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Pstd. Return R..';
                }
                field("Std Bill-To No. of Pstd. Cr. Memos"; Rec."Bill-To No. of Pstd. Cr. Memos")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Bill-To No. of Pstd. Cr. Memos.';
                }
                field("Std Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Base Calendar Code.';
                }
                field("Std Copy Sell-to Addr. to Qte From"; Rec."Copy Sell-to Addr. to Qte From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Copy Sell-to Addr. to Qte From.';
                }
                field("Std Validate EU Vat Reg. No."; Rec."Validate EU Vat Reg. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Validate EU Vat Reg. No..';
                }
                field("Std Currency Id"; Rec."Currency Id")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Currency Id.';
                }
                field("Std Payment Terms Id"; Rec."Payment Terms Id")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Payment Terms Id.';
                }
                field("Std Shipment Method Id"; Rec."Shipment Method Id")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Shipment Method Id.';
                }
                field("Std Payment Method Id"; Rec."Payment Method Id")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Payment Method Id.';
                }
                field("Std Tax Area ID"; Rec."Tax Area ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Tax Area ID.';
                }
                field("Std Contact ID"; Rec."Contact ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Contact ID.';
                }
                field("Std Contact Graph Id"; Rec."Contact Graph Id")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the standard Customer field Contact Graph Id.';
                }
                field("ZX Related Company"; Rec."Related Company")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Related Company.';
                }
                field("ZX Do Not Change Bill-to Cust No."; Rec."Do Not Change Bill-to Cust No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Do Not Change Bill-to Cust No..';
                }
                field("ZX Select Currency Code"; Rec."Select Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Select Currency Code.';
                }
                field("ZX Customer Contract"; Rec."Customer Contract")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Customer Contract.';
                }
                field("ZX Exclude Wee Report"; Rec."Exclude Wee Report")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Exclude Wee Report.';
                }
                field("ZX Statement Type"; Rec."Statement Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Statement Type.';
                }
                field("ZX Exclude from Intrastat"; Rec."Exclude from Intrastat")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Exclude from Intrastat.';
                }
                field("ZX VAT Registration Code"; Rec."VAT Registration Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field VAT Registration Code.';
                }
                field("ZX Enable Forecasting"; Rec."Enable Forecasting")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Enable Forecasting.';
                }
                field("ZX Automatic SP Items"; Rec."Automatic SP Items")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Automatic SP Items.';
                }
                field("ZX Incoterms"; Rec."Incoterms")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Incoterms.';
                }
                field("ZX Has Forecast Items"; Rec."Has Forecast Items")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Has Forecast Items.';
                }
                field("ZX EiCard Email Address"; Rec."EiCard Email Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Email Address.';
                }
                field("ZX EiCard Send HTML Email"; Rec."EiCard Send HTML Email")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Send HTML Email.';
                }
                field("ZX EiCard Add Dist Ref to Subject"; Rec."EiCard Add Dist Ref to Subject")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Add Dist Ref to Subject.';
                }
                field("ZX EiCard Add Customer to Subject"; Rec."EiCard Add Customer to Subject")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Add Customer to Subject.';
                }
                field("ZX EiCard Add Order No to Subject"; Rec."EiCard Add Order No to Subject")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Add Order No to Subject.';
                }
                field("ZX EiCard Email Address1"; Rec."EiCard Email Address1")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Email Address1.';
                }
                field("ZX EiCard Email Address2"; Rec."EiCard Email Address2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Email Address2.';
                }
                field("ZX EiCard Email Address3"; Rec."EiCard Email Address3")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Email Address3.';
                }
                field("ZX EiCard Email Address4"; Rec."EiCard Email Address4")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EiCard Email Address4.';
                }
                field("ZX Supervisor Password eShop"; Rec."Supervisor Password eShop")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Supervisor Password eShop.';
                }
                field("ZX Confirmation E-Mail"; Rec."Confirmation E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Confirmation E-Mail.';
                }
                field("ZX Action Code Source"; Rec."Action Code Source")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Action Code Source.';
                }
                field("ZX Delivery Zone"; Rec."Delivery Zone")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Delivery Zone.';
                }
                field("ZX Delivery Days"; Rec."Delivery Days")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Delivery Days.';
                }
                field("ZX Your Reference Translation"; Rec."Your Reference Translation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Your Reference Translation.';
                }
                field("ZX E-mail for Order Scanning"; Rec."E-mail for Order Scanning")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-mail for Order Scanning.';
                }
                field("ZX Download and Attach Eicards"; Rec."Download and Attach Eicards")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Download and Attach Eicards.';
                }
                field("ZX Minimum Order Value Enabled"; Rec."Minimum Order Value Enabled")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Minimum Order Value Enabled.';
                }
                field("ZX Minimum Order Value (LCY)"; Rec."Minimum Order Value (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Minimum Order Value (LCY).';
                }
                field("ZX Full Pallet Ordering Enabled"; Rec."Full Pallet Ordering Enabled")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Full Pallet Ordering Enabled.';
                }
                field("ZX Full Pallet Ordering Rounding"; Rec."Full Pallet Ordering Rounding")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Full Pallet Ordering Rounding.';
                }
                field("ZX Turkish Customer No."; Rec."Turkish Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Turkish Customer No..';
                }
                field("ZX Set Eicard Type on Sales Order"; Rec."Set Eicard Type on Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Set Eicard Type on Sales Order.';
                }
                field("ZX Skip Posting Group Validation"; Rec."Skip Posting Group Validation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Skip Posting Group Validation.';
                }
                field("ZX Forecast Territory"; Rec."Forecast Territory")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Forecast Territory.';
                }
                field("ZX Outst. Orders Sell-to (LCY)"; Rec."Outst. Orders Sell-to (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Outst. Orders Sell-to (LCY).';
                }
                field("ZX Unblock Pick.Date Restriction"; Rec."Unblock Pick.Date Restriction")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Unblock Pick.Date Restriction.';
                }
                field("ZX E-mail Sales Documents"; Rec."E-mail Sales Documents")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-mail Sales Documents.';
                }
                field("ZX Intercompany Purchase"; Rec."Intercompany Purchase")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Intercompany Purchase.';
                }
                field("ZX Post EiCard Invoice Automatic"; Rec."Post EiCard Invoice Automatic")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Post EiCard Invoice Automatic.';
                }
                field("ZX Mark Inv. and Cr.M as Printed"; Rec."Mark Inv. and Cr.M as Printed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Mark Inv. and Cr.M as Printed.';
                }
                field("ZX Delay Btw. Post and Send Email"; Rec."Delay Btw. Post and Send Email")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Delay Btw. Post and Send Email.';
                }
                field("ZX Automatic Invoice Handling"; Rec."Automatic Invoice Handling")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Automatic Invoice Handling.';
                }
                field("ZX Create Invoice pr. Order"; Rec."Create Invoice pr. Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Create Invoice pr. Order.';
                }
                field("ZX EORI No."; Rec."EORI No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field EORI No..';
                }
                field("ZX Customs Broker"; Rec."Customs Broker")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Customs Broker.';
                }
                field("ZX Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Registration No..';
                }
                field("ZX Additional Items"; Rec."Additional Items")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Additional Items.';
                }
                field("ZX SDI No."; Rec."SDI No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field SDI No..';
                }
                field("ZX SDI Recipient Code"; Rec."SDI Recipient Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field SDI Recipient Code.';
                }
                field("ZX PEC E-mail Address IT"; Rec."PEC E-mail Address IT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field PEC E-mail Address IT.';
                }
                field("ZX Approval No. must be Filled"; Rec."Approval No. must be Filled")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Approval No. must be Filled.';
                }
                field("ZX Create Delivery Doc. pr. Order"; Rec."Create Delivery Doc. pr. Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Create Delivery Doc. pr. Order.';
                }
                field("ZX Run Auto. Inv. Hand. on WaitFI"; Rec."Run Auto. Inv. Hand. on WaitFI")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Run Auto. Inv. Hand. on WaitFI.';
                }
                field("ZX E-mail Shipping Inv. to Whse."; Rec."E-mail Shipping Inv. to Whse.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-mail Shipping Inv. to Whse..';
                }
                field("ZX Attach Pallet No. to Serial No"; Rec."Attach Pallet No. to Serial No")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Attach Pallet No. to Serial No.';
                }
                field("ZX Exclude from Forecast"; Rec."Exclude from Forecast")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Exclude from Forecast.';
                }
                field("ZX E-mail Deliv. Note at Release"; Rec."E-mail Deliv. Note at Release")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-mail Deliv. Note at Release.';
                }
                field("ZX E-mail Chemical Report"; Rec."E-mail Chemical Report")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-mail Chemical Report.';
                }
                field("ZX E-mail for Chemical Report"; Rec."E-mail for Chemical Report")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-mail for Chemical Report.';
                }
                field("ZX Last Chemical Report Sent"; Rec."Last Chemical Report Sent")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Last Chemical Report Sent.';
                }
                field("ZX Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Order Desk Resposible Code.';
                }
                field("ZX Active"; Rec."Active")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Active.';
                }
                field("ZX Fiscal Code IT"; Rec."Fiscal Code IT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Fiscal Code IT.';
                }
                field("ZX NL to DK Rev. Charge"; Rec."NL to DK Rev. Charge")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field NL to DK Rev. Charge.';
                }
                field("ZX Sample Account"; Rec."Sample Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Sample Account.';
                }
                field("ZX End User Email Expected"; Rec."End User Email Expected")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field End User Email Expected.';
                }
                field("ZX KYC Last Checked"; Rec."KYC Last Checked")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field KYC Last Checked.';
                }
                field("ZX Warning on Not-delivery"; Rec."Warning on Not-delivery")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Warning on Not-delivery.';
                }
                field("ZX AMAZONID"; Rec."AMAZONID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field AMAZONID.';
                }
                field("ZX Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Creation Date.';
                }
                field("ZX Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Modified Date.';
                }
                field("ZX Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Created By.';
                }
                field("ZX Modified By"; Rec."Modified By")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Modified By.';
                }
                field("ZX E-Mail Statement Address"; Rec."E-Mail Statement Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-Mail Statement Address.';
                }
                field("ZX E-Mail Reminder Address"; Rec."E-Mail Reminder Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-Mail Reminder Address.';
                }
                field("ZX E-Mail Statement"; Rec."E-Mail Statement")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-Mail Statement.';
                }
                field("ZX E-Mail Reminder"; Rec."E-Mail Reminder")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-Mail Reminder.';
                }
                field("ZX Category"; Rec."Category")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Category.';
                }
                field("ZX Tier"; Rec."Tier")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Tier.';
                }
                field("ZX Parrent Name"; Rec."Parrent Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Parrent Name.';
                }
                field("ZX Administration Reference"; Rec."Administration Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Administration Reference.';
                }
                field("ZX Recipient Code"; Rec."Recipient Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Recipient Code.';
                }
                field("ZX Customer Tipology"; Rec."Customer Tipology")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Customer Tipology.';
                }
                field("ZX Recipient PEC E-Mail"; Rec."Recipient PEC E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Recipient PEC E-Mail.';
                }
                field("ZX Notification E-Mail"; Rec."Notification E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Notification E-Mail.';
                }
                field("ZX Mailing Group Code"; Rec."Mailing Group Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Mailing Group Code.';
                }
                field("ZX Monday"; Rec."Monday")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Monday.';
                }
                field("ZX Tuesday"; Rec."Tuesday")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Tuesday.';
                }
                field("ZX Wednesday"; Rec."Wednesday")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Wednesday.';
                }
                field("ZX Thursday"; Rec."Thursday")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Thursday.';
                }
                field("ZX Friday"; Rec."Friday")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Friday.';
                }
                field("ZX Avoid Creation of SI in SUB"; Rec."Avoid Creation of SI in SUB")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Avoid Creation of SI in SUB.';
                }
                field("ZX Sub company"; Rec."Sub company")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Sub company.';
                }
                field("ZX Batch Posting"; Rec."Batch Posting")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Batch Posting.';
                }
                field("ZX Abbreviation"; Rec."Abbreviation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Abbreviation.';
                }
                field("ZX FCST Region ID"; Rec."FCST Region ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field FCST Region ID.';
                }
                field("ZX Customer Business Type"; Rec."Customer Business Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Customer Business Type.';
                }
                field("ZX Is in FCST Separately"; Rec."Is in FCST Separately")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Is in FCST Separately.';
                }
                field("ZX Currency Code in Sales Order"; Rec."Currency Code in Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Currency Code in Sales Order.';
                }
                field("ZX Forecast visibility"; Rec."Forecast visibility")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Forecast visibility.';
                }
                field("ZX Sales FCST Consumption"; Rec."Sales FCST Consumption")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Sales FCST Consumption.';
                }
                field("ZX Express Picking"; Rec."Express Picking")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Express Picking.';
                }
                field("ZX Tax Office Code"; Rec."Tax Office Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Tax Office Code.';
                }
                field("ZX VAT ID"; Rec."VAT ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field VAT ID.';
                }
                field("ZX Use E-Invoice"; Rec."Use E-Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Use E-Invoice.';
                }
                field("ZX E-Invoice Profile ID"; Rec."E-Invoice Profile ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field E-Invoice Profile ID.';
                }
                field("ZX RHQ Customer No"; Rec."RHQ Customer No")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field RHQ Customer No.';
                }
                field("ZX BacklogEmailAddress"; Rec."BacklogEmailAddress")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field BacklogEmailAddress.';
                }
                field("ZX Last Customer credit Check"; Rec."Last Customer credit Check")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Last Customer credit Check.';
                }
                field("ZX Combine Eicard Shipments"; Rec."Combine Eicard Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the ZX customer field Combine Eicard Shipments.';
                }
            }
        }
    }
}
