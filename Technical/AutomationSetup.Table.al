Table 50086 "Automation Setup"
{
    // 001. 07-01-20 ZY-LD P0368 - Send to eShop with delay.
    // 002. 03-06-20 ZY-LD 000 - Send e-mail at EOM.
    // 003. 11-09-20 ZY-LD 000 - New field.
    // 004. 14-01-21 ZY-LD 2021011410000075 - New field.
    // 005. 01-07-21 ZY-LD 000 - The EOM must not be forgotten. Therefore we set it automatic, if the field is blanked.
    // 006. 16-02-22 ZY-LD P0747 - Delete Invoiced Purchase Orders.

    Caption = 'Automation Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Run Automations"; Boolean)
        {
            Caption = 'Run Automations';
        }
        field(3; "Stop Communication EOM"; DateTime)
        {
            Caption = 'Stop Communication at End of Month';

            trigger OnLookup()
            begin
                Validate("Stop Communication EOM", LookupDateTime("Stop Communication EOM"));
            end;

            trigger OnValidate()
            begin
                //>> 01-07-21 ZY-LD 005
                if ("Stop Communication EOM" = 0DT) and (xRec."Stop Communication EOM" < CurrentDatetime) then begin
                    NewStopDate := CalcDate('<CM>', WorkDate);
                    if Date2dwy(NewStopDate, 1) > 5 then
                        repeat
                            NewStopDate := CalcDate('-1D', NewStopDate);
                        until Date2dwy(NewStopDate, 1) <= 5;
                    "Stop Communication EOM" := CreateDatetime(NewStopDate, 120000T);
                end;
                //<< 01-07-21 ZY-LD 005
                //>> 03-06-20 ZY-LD 002
                if (("Stop Communication EOM" = 0DT) or ("Stop Communication EOM" > CurrentDatetime)) and (xRec."Stop Communication EOM" < CurrentDatetime) then
                    if recEmailAdd.Get('LOGENDOM') and (recEmailAdd."Last E-mail Send Date Time" <> 0DT) then begin
                        recEmailAdd."Last E-mail Send Date Time" := 0DT;
                        recEmailAdd.Modify;

                        EmailAddMgt.CreateSimpleEmail('LOGENDOM2', '', '');
                        EmailAddMgt.Send;
                    end;
                //<< 03-06-20 ZY-LD 002
            end;
        }
        field(4; "Date Time Test"; DateTime)
        {
            Caption = 'Date Time Test';
        }
        field(10; "Register Use of Report"; Boolean)
        {
            Caption = 'Register Use of Report';
        }
        field(11; "Post Sales Order EiCard"; Boolean)
        {
            Caption = 'Post Sales Order EiCard';
        }
        field(12; "Create Sales Invoice"; Boolean)
        {
            Caption = 'Create Sales Invoice';
        }
        field(13; "Post Sales Invoice"; Boolean)
        {
            Caption = 'Post Sales Invoice';
        }
        field(14; "Send Sales Doc. by E-mail Auto"; Boolean)
        {
            Caption = 'Send Sales Document by E-mail Automatic';
        }
        field(15; "Send E-mail with EiCard Links"; Boolean)
        {
            Caption = 'Send E-mail with EiCard Links';
        }
        field(16; "Delay Btw. Post and Send Email"; Integer)
        {
            Caption = 'Delay Between Post to Send E-mail (Min.)';
            MaxValue = 1440;
            MinValue = 0;
        }
        field(17; "On Hold for Sales Document"; Code[3])
        {
            Caption = 'On Hold for Sales Document';
        }
        field(18; "Create Invoice on Whse. Status"; Option)
        {
            Caption = 'Create Invoice on Warehouse Status';
            OptionCaption = ',,,,,,,,In Transit,Delivered';
            OptionMembers = ,,,,,,,,"In Transit",Delivered;
        }
        field(19; "Create Inv. on Whse. St. EOY"; Option)
        {
            Caption = 'Create Inv. on Whse. Status (End Of Year)';
            OptionCaption = ',,,,,,,,In Transit,Delivered';
            OptionMembers = ,,,,,,,,"In Transit",Delivered;
        }
        field(20; "Date for EOY Warehouse Status"; Integer)
        {
            Caption = 'Date for (End of Year) Warehouse Status (DD)';
            MaxValue = 31;
            MinValue = 0;
        }
        field(21; "Purchase Inv. Eicard Reminder"; Integer)
        {
            BlankZero = true;
            Caption = 'Purchase Inv. Eicard Reminder (days)';
            MaxValue = 7;
            MinValue = 0;
        }
        field(22; "Download and Attach Eicards"; Boolean)
        {
            Caption = 'Download and Attach Eicard Link Files';
            Description = '11-09-20 ZY-LD 003';

            trigger OnValidate()
            begin
                //>> 14-01-21 ZY-LD 004
                if not "Download and Attach Eicards" then
                    Message(FieldCaption("Download and Attach Eicards"), recCust.FieldCaption("Download and Attach Eicards"), FieldCaption("Download if Qty. is Less than"));
                //<< 14-01-21 ZY-LD 004
            end;
        }
        field(23; "Create Whse. Outbound Sales"; Boolean)
        {
            Caption = 'Create Whse. Outbound Sales (Delivery Document)';
        }
        field(24; "Warehouse Outbound Transfer"; Option)
        {
            Caption = 'Whse. Outbound Transfer (Delivery Document)';
            OptionMembers = " ",Create,"Create & Release";
        }
        field(25; "Download if Qty. is Less than"; Integer)
        {
            Caption = 'Download if Quantity is Less than';
            Description = '14-01-21 ZY-LD 004';
            MaxValue = 100;
            MinValue = 0;
        }
        field(26; "Travel Expense Process"; Option)
        {
            Caption = 'Travel Expense Process';
            OptionCaption = ' ,Import,Import & Transfer,Import & Transfer & Post';
            OptionMembers = " ",Import,"Import & Transfer","Import & Transfer & Post";
        }
        field(27; "Invoice Capture Process"; Option)
        {
            Caption = 'Import Invoice Capture';
            OptionCaption = ' ,Import,Import & Transfer,Import & Transfer & Post';
            OptionMembers = " ",Import,"Import & Transfer","Import & Transfer & Post";
        }
        field(28; "Export Concur Vendors"; Boolean)
        {
            Caption = 'Export Concur Vendors';
        }
        field(29; "Export Concur Vendors After"; Time)
        {
            Caption = 'Export Concur Vendors After';
        }
        field(30; "Delete Invoiced Purch. Orders"; Boolean)
        {
            Caption = 'Delete Invoiced Purch. Orders';
            Description = '16-02-22 ZY-LD 006';
        }
        field(31; "Release Deliver Document"; Boolean)
        {
            Caption = 'Release Deliver Document';
        }
        field(32; "Warehouse Import Error Date"; Date)
        {
            Caption = 'Warehouse Import Error Date';
        }
        field(33; "Rcpt. Post Transf Whse. Status"; Option)
        {
            Caption = 'Rcpt. Post Transf. Order on Whse. Status';
            OptionMembers = ,,,,,,,,"In Transit",Delivered;
            OptionCaption = ',,,,,,,,In Transit,Delivered';
        }
        field(34; "Ship. Post Transf Whse. Status"; Option)
        {
            Caption = 'Ship. Post Transf. Order on Whse. Status';
            OptionMembers = ,,,"Goods Received","Putting Away","On Stock";
            OptionCaption = ',,,Goods Received,Putting Away,On Stock';
        }
        field(35; "Received HQ Sales Invoice Mail"; Code[20])
        {
            Caption = 'Received HQ Sales Invoice Mail';
            TableRelation = "E-mail address";
        }
        field(36; "Send Only One Received Mail"; Boolean)
        {
            Caption = 'Send Only One Received HQ Sales Invoice Mail at a time';
        }
        field(37; "Default Job Queue User"; Code[50])  // 05-04-24 ZY-LD 000
        {
            Caption = 'Default Job Queue User';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(38; "Import and Post LMR"; Boolean)  // 09-09-24 ZY-LD 000
        {
            Caption = 'Post and Import LMR';
        }
        field(39; "Import and Post Whse. RMA"; Boolean)  // 09-09-24 ZY-LD 000
        {
            Caption = 'Import and Post Whse. RMA';
        }
        field(51; "Post Purchase Order EiCard"; Boolean)
        {
            Caption = 'Post Purchase Order EiCard';
        }
        field(52; "Create Purchase Invoice"; Boolean)
        {
            Caption = 'Create Purchase Invoice';
        }
        field(53; "Post Purchase Invoice"; Boolean)
        {
            Caption = 'Post Purchase Invoice';
        }
        field(54; "Upd. Unit Price on Purch.Order"; Boolean)
        {
            Caption = 'Update Unit Price on Purch Order from Unshipped Quantity';
        }
        field(55; "Send Eicard to eShop"; Boolean)
        {
            Description = '07-01-20 ZY-LD 001';
        }
        field(56; "Delay Between Create and eShop"; Integer)
        {
            Caption = 'Delay Between Creation and eShop (min.)';
            Description = '07-01-20 ZY-LD 001';
            MaxValue = 1440;
            MinValue = 0;
        }
        field(57; "Import eCommerce Orders"; Boolean)
        {
            Caption = 'Import Orders';
        }
        field(58; "Post eCommerce Orders"; Boolean)
        {
            Caption = 'Post Orders';
        }
        field(59; "Create Sales Document (eCom)"; Boolean)
        {
            Caption = 'Create Sales Doc. on eCommerce Order';
        }
        field(60; "Post Prev. Created Sales Doc."; Boolean)
        {
            Caption = 'Post Prev. Created Sales Documents';
        }
        field(61; "Last LMR Date"; Date)
        {
            Caption = 'Last LMR Date';
            Description = 'Contain the last date of the file that has been imported. It will be checked that we don´t post data with dates before that date.';
        }
        field(62; "Last Imported Inventory Date"; Date)  // 06-09-24 ZY-LD 000
        {
            Caption = 'Last Imported Inventory Date';
        }
        field(101; "Post Warehouse Response"; Boolean)
        {
            Caption = 'Post Warehouse Response';
        }
        field(102; "Warehouse Inventory"; Boolean)
        {
            Caption = 'Warehouse Inventory';
        }
        field(103; "Post Warehouse Job Que Entry"; Integer)
        {
            Caption = 'Job Que Entry';
        }
        field(104; "Post Warehouse Last Run"; DateTime)
        {
            CalcFormula = max("Job Queue Log Entry"."End Date/Time" where("Object ID to Run" = field("Post Warehouse Job Que Entry")));
            Caption = 'Last Run';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Post Warehouse Next Run"; DateTime)
        {
            CalcFormula = lookup("Job Queue Entry"."Earliest Start Date/Time" where("Object Type to Run" = const(Codeunit),
                                                                                     "Object ID to Run" = field("Post Warehouse Job Que Entry")));
            Caption = 'Next Run';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Post Inbound Response"; Boolean)
        {
            Caption = 'Post Inbound Response';
        }
        field(107; "Post Outbound Response"; Boolean)
        {
            Caption = 'Post Outbound Response';
        }
        field(108; "Release HQ Warehouse Inbound"; Boolean)
        {
            Caption = 'Release HQ Warehouse Inbound';
        }
        field(109; "Release EMEA Whse. Inbound"; Boolean)
        {
            Caption = 'Release EMEA Whse. Inbound';
        }
        field(110; "Release Return Order Whse Inb."; Boolean)
        {
            Caption = 'Release Return Order Whse. Inbound';
        }
        field(111; "Create and Release Whse. Inb."; Boolean)
        {
            Caption = 'Create and Release Whse. Inbound';
        }
        field(112; "Release HQ Whse. Indb. DateF."; DateFormula)
        {
            Caption = 'Release HQ Whse. Indb. before ETA';
        }
        field(113; "Release Transf Order Whse Inb."; Boolean)
        {
            Caption = 'Release Transfer Order Whse. Inbound';
        }
        field(150; "Delete Arch. Quotes Older than"; DateFormula)
        {
            Caption = 'Delete Archived Quotes Older than';
        }
        field(151; "Delete Inv. Orders Older than"; DateFormula)
        {
            Caption = 'Delete Invoiced Orders Older than';
        }
        field(152; "Delete Arch. Orders Older than"; DateFormula)
        {
            Caption = 'Delete Archived Orders Older than';
        }
        field(153; "Del. Inv. Return Ord. Older th"; DateFormula)
        {
            Caption = 'Delete Invoiced Return Orders Older than';
        }
        field(154; "Del. Arch. Return Ord. Older t"; DateFormula)
        {
            Caption = 'Delete Archived Return Orders Older than';
        }
        field(200; "E-mail Body Filename"; Text[60])
        {
            Caption = 'E-mail Body Filename';
        }
        field(201; "E-mail Body Filename - Eicard"; Text[60])
        {
            Caption = 'E-mail Body Filename - Eicard';
        }
        field(202; "E-mail Disclaimer Filename"; Text[60])
        {
            Caption = 'E-mail Disclaimer Filename';
        }
        field(203; "E-mail Spacer Filename"; Text[60])
        {
            Caption = 'E-mail Spacer Filename';
        }
        field(204; "E-mail Zyxel Logo Filename"; Text[60])
        {
            Caption = 'E-mail Zyxel Logo Filename';
        }
        field(205; "E-mail Marketing Banner Filen."; Text[60])
        {
            Caption = 'E-mail Marketing Banner Filename';
        }
        field(206; "E-mail Zyxel Man Filename"; Text[60])
        {
            Caption = 'E-mail Zyxel Man Filename';
        }
        field(207; "E-mail Download Gif Filename"; Text[60])
        {
            Caption = 'E-mail Download Gif Filename';
        }
        // 490711
        field(208; ContainerEtaProdMode; Boolean)
        {

            Caption = 'Container ETA Update production mode';

        }
        // #490711
        // Main warehouse = 0 from TW >>
        field(209; SkipPOMainWareHouseZero; Boolean)
        {

            Caption = 'Skip warehause inbound to VCK on PO with mainwarehause zero on all lines.';

        }
        // Main warehouse = 0 from TW <<
        field(210; CreateContanieInternal; Boolean)  //494391
        {
            Caption = 'Create Contanier on internal sales';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recEmailAdd: Record "E-mail address";
        recCust: Record Customer;
        EmailAddMgt: Codeunit "E-mail Address Management";
        Text001: label 'When you remove the tick from "%1", the automation will still keep sending eicards to customers who has a tick in the field "%2".\If you want to prevent attachment of eicards at all, you have to set "%3" to zero.';
        NewStopDate: Date;


    procedure SendEmailWithEicardLinksAlowed(): Boolean
    begin
        exit("Run Automations" and "Send E-mail with EiCard Links");
    end;


    procedure SendSalesDocByEmailAutoAllowed(): Boolean
    begin
        exit("Run Automations" and "Send Sales Doc. by E-mail Auto");
    end;


    procedure SendEicardToEshopAllowed(): Boolean
    begin
        exit("Run Automations" and "Send Eicard to eShop");
    end;


    procedure PostPurchaseOrderEiCardAllowed(): Boolean
    begin
        exit("Run Automations" and "Post Purchase Order EiCard" and EndOfMonthAllowed);
    end;


    procedure PostSalesOrderEiCardAllowed(): Boolean
    begin
        exit("Run Automations" and "Post Sales Order EiCard" and EndOfMonthAllowed);
    end;


    procedure CreateSalesInvoiceNormalAllowed(): Boolean
    begin
        exit("Run Automations" and "Create Sales Invoice" and EndOfMonthAllowed);
    end;


    procedure CreatePurchaseInvoiceNormalAllowed(): Boolean
    begin
        exit("Run Automations" and "Create Purchase Invoice" and EndOfMonthAllowed);
    end;


    procedure WhsePostingAllowed() rValue: Boolean
    begin
        exit("Run Automations" and "Post Warehouse Response" and EndOfMonthAllowed);
    end;


    procedure WhseIndbPostingAllowed(): Boolean
    begin
        exit("Run Automations" and "Post Inbound Response" and EndOfMonthAllowed);
    end;


    procedure WhseOutbPostingAllowed(): Boolean
    begin
        exit("Run Automations" and "Post Outbound Response" and EndOfMonthAllowed);
    end;


    procedure WhseInventoryAllowed() rValue: Boolean
    begin
        exit("Run Automations" and "Warehouse Inventory");
    end;


    procedure WhseCreateAndReleaseInbound(): Boolean
    begin
        exit("Run Automations" and "Create and Release Whse. Inb." and EndOfMonthAllowed);
    end;


    procedure WhseCreateOutboundSales(): Boolean
    begin
        exit("Run Automations" and "Create Whse. Outbound Sales");
    end;


    procedure WhseCreateOutboundTransfer(): Boolean
    begin
        exit("Run Automations" and ("Warehouse Outbound Transfer" >= "warehouse outbound transfer"::Create));
    end;


    procedure WhseReleaseOutboundTransfer(): Boolean
    begin
        exit("Run Automations" and ("Warehouse Outbound Transfer" = "warehouse outbound transfer"::"Create & Release") and EndOfMonthAllowed);
    end;


    procedure EndOfMonthAllowed() rValue: Boolean
    var
        recEmailAdd: Record "E-mail address";
        CurrDT: DateTime;
        LastSendDate: Date;
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
    begin
        if "Stop Communication EOM" <> 0DT then begin
            CurrDT := CurrentDatetime;
            if GuiAllowed and ("Date Time Test" <> 0DT) then
                CurrDT := "Date Time Test";
            rValue := not (CurrDT > "Stop Communication EOM");

            //>> 03-06-20 ZY-LD 002
            if not rValue then
                if (not GuiAllowed) and recEmailAdd.Get('LOGENDOM') and (recEmailAdd."Last E-mail Send Date Time" = 0DT) then begin
                    SI.SetMergefield(100, Format("Stop Communication EOM"));
                    EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
                    EmailAddMgt.Send;

                    recEmailAdd."Last E-mail Send Date Time" := CurrentDatetime;
                    recEmailAdd.Modify;
                end;
            //<< 03-06-20 ZY-LD 002
        end else
            rValue := true;
    end;


    procedure AutomationAllowed(): Boolean
    begin
        exit("Run Automations");
    end;

    local procedure LookupDateTime(InitDateTime: DateTime) NewDateTime: DateTime
    var
        DateTimeDialog: Page "Date-Time Dialog";
    begin
        NewDateTime := InitDateTime;
        DateTimeDialog.SetDateTime(RoundDatetime(InitDateTime, 1000));

        if DateTimeDialog.RunModal = Action::OK then
            NewDateTime := DateTimeDialog.GetDateTime;
    end;


    procedure AutomationBlockedByEOM(): Text
    var
        lText001: label 'Automation is blocked by "End of Month".';
    begin
        if ("Stop Communication EOM" <> 0DT) and
           ("Stop Communication EOM" < CurrentDatetime)
        then
            exit(lText001);
    end;


    procedure ImporteCommerceOrders(): Boolean
    begin
        exit("Run Automations" and "Import eCommerce Orders");
    end;


    procedure CreateSalesDocOneCommerceOrder(): Boolean
    begin
        exit("Run Automations" and "Create Sales Document (eCom)" and EndOfMonthAllowed);
    end;


    procedure PosteCommerceOrders(): Boolean
    begin
        exit("Run Automations" and "Post eCommerce Orders" and EndOfMonthAllowed);
    end;
}
