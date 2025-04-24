Page 50322 "Automation Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Automation Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Automation Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Control50)
            {
                Visible = EndOfMonthVisible;
                field(AutomationBlockedByEOM; Rec.AutomationBlockedByEOM)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = true;
                }
            }
            group(General)
            {
                Caption = 'General';
                field("Run Automations"; Rec."Run Automations")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Register Use of Report"; Rec."Register Use of Report")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Control19)
                {
                    ShowCaption = false;
                    field("Stop Communication EOM"; Rec."Stop Communication EOM")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Date Time Test"; Rec."Date Time Test")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                }
                field("Default Job Queue User"; Rec."Default Job Queue User")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    ToolTip = 'Specifies the user name that is used when general job queue jobs are running.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                group(Documents)
                {
                    Caption = 'Documents';
                    field("Send Sales Doc. by E-mail Auto"; Rec."Send Sales Doc. by E-mail Auto")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Delay Btw. Post and Send Email"; Rec."Delay Btw. Post and Send Email")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("On Hold for Sales Document"; Rec."On Hold for Sales Document")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("E-mail")
                {
                    Caption = 'E-mail';
                    field("E-mail Body Filename"; Rec."E-mail Body Filename")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("EiCard Links")
                {
                    Caption = 'EiCard Links';
                    field(Control26; Rec."Send E-mail with EiCard Links")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Download and Attach Eicards"; Rec."Download and Attach Eicards")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'A similar field exists on the customer. If one of the fields is true, a download will be executed.';
                    }
                    field("Download if Qty. is Less than"; Rec."Download if Qty. is Less than")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'If the value is set to zero, no downloads will be attached to the e-mail.';
                    }
                    field("E-mail Body Filename - Eicard"; Rec."E-mail Body Filename - Eicard")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Disclaimer Filename"; Rec."E-mail Disclaimer Filename")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Spacer Filename"; Rec."E-mail Spacer Filename")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Zyxel Logo Filename"; Rec."E-mail Zyxel Logo Filename")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Marketing Banner Filen."; Rec."E-mail Marketing Banner Filen.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Zyxel Man Filename"; Rec."E-mail Zyxel Man Filename")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("E-mail Download Gif Filename"; Rec."E-mail Download Gif Filename")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                group(Post)
                {
                    Caption = 'Post';
                    field("Post Sales Order EiCard"; Rec."Post Sales Order EiCard")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Create Sales Invoice"; Rec."Create Sales Invoice")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Post Sales Invoice"; Rec."Post Sales Invoice")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Create Invoice on Whse. Status"; Rec."Create Invoice on Whse. Status")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    group(Control48)
                    {
                        Caption = 'End of Year';
                        field("Create Inv. on Whse. St. EOY"; Rec."Create Inv. on Whse. St. EOY")
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field("Date for EOY Warehouse Status"; Rec."Date for EOY Warehouse Status")
                        {
                            ApplicationArea = Basic, Suite;
                        }
                    }
                }
                group(Delete)
                {
                    Caption = 'Delete';
                    field("Delete Arch. Quotes Older than"; Rec."Delete Arch. Quotes Older than")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Delete Inv. Orders Older than"; Rec."Delete Inv. Orders Older than")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Delete Arch. Orders Older than"; Rec."Delete Arch. Orders Older than")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Del. Inv. Return Ord. Older th"; Rec."Del. Inv. Return Ord. Older th")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Del. Arch. Return Ord. Older t"; Rec."Del. Arch. Return Ord. Older t")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group(Purchase)
            {
                Caption = 'Purchase';
                group(Upload)
                {
                    Caption = 'Upload';
                    field("Send Eicard to eShop"; Rec."Send Eicard to eShop")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Delay Between Create and eShop"; Rec."Delay Between Create and eShop")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Update)
                {
                    Caption = 'Update';
                    field("Upd. Unit Price on Purch.Order"; Rec."Upd. Unit Price on Purch.Order")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Control27)
                {
                    Caption = 'Post';
                    field("Post Purchase Order EiCard"; Rec."Post Purchase Order EiCard")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Create Purchase Invoice"; Rec."Create Purchase Invoice")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Post Purchase Invoice"; Rec."Post Purchase Invoice")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Reminder)
                {
                    Caption = 'Reminder';
                    field("Purchase Inv. Eicard Reminder"; Rec."Purchase Inv. Eicard Reminder")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Days between creation and reminder.';
                    }
                }

                group(Control94)
                {
                    Caption = 'Delete';
                    field("Delete Invoiced Purch. Orders"; Rec."Delete Invoiced Purch. Orders")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                field("Rcpt. Post Transf Whse. Status"; Rec."Rcpt. Post Transf Whse. Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship. Post Transf Whse. Status"; Rec."Ship. Post Transf Whse. Status")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Download)
            {
                Caption = 'Download';
                field("Received HQ Sales Invoice Mail"; Rec."Received HQ Sales Invoice Mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Send Only One Received Mail"; Rec."Send Only One Received Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'There is an issue in the code, so it breaks if there it send more that one mail per loop. By ticking this field, only one mail will be sent per loop.';
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                group("Process VCK")
                {
                    Caption = 'Process VCK';
                    field("Post Warehouse Response"; Rec."Post Warehouse Response")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    group(Control58)
                    {
                        ShowCaption = false;
                        field("Post Inbound Response"; Rec."Post Inbound Response")
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field("Post Outbound Response"; Rec."Post Outbound Response")
                        {
                            ApplicationArea = Basic, Suite;
                        }
                    }
                    field("Post Warehouse Last Run"; Rec."Post Warehouse Last Run")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Post Warehouse Next Run"; Rec."Post Warehouse Next Run")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Post Warehouse Job Que Entry"; Rec."Post Warehouse Job Que Entry")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                }
                field(Control29; Rec."Warehouse Inventory")
                {
                    ApplicationArea = Basic, Suite;
                }
                group("Outbound Release")
                {
                    Caption = 'Outbound Release';
                    field("Release Deliver Document"; Rec."Release Deliver Document")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Inbound Release")
                {
                    Caption = 'Inbound Release';
                    field("Create and Release Whse. Inb."; Rec."Create and Release Whse. Inb.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    group(Control64)
                    {
                        field("Release HQ Warehouse Inbound"; Rec."Release HQ Warehouse Inbound")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'HQ Warehouse Inbound';
                        }
                        field("Release HQ Whse. Indb. DateF."; Rec."Release HQ Whse. Indb. DateF.")
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Enter the number of days before "ETA Date" you want to send the inbound order to the warehouse';
                        }
                        field(SkipPOMainWareHouseZero; Rec.SkipPOMainWareHouseZero)
                        {
                            ApplicationArea = Basic, Suite;

                        }
                        field("Release EMEA Whse. Inbound"; Rec."Release EMEA Whse. Inbound")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'EMEA Whse. Inbound';
                        }
                        field("Release Return Order Whse Inb."; Rec."Release Return Order Whse Inb.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Return Order Whse. Inbound';
                        }
                        field("Release Transf Order Whse Inb."; Rec."Release Transf Order Whse Inb.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Transfer Order Whse. Inbound';
                        }
                    }
                }
            }
            group(RMA)
            {
                Caption = 'RMA';
                Visible = eCommerceVisible;
                Group(Together)
                {
                    ShowCaption = false;
                    field("Import and Post LMR"; Rec."Import and Post LMR") { }
                    field("Import and Post Whse. RMA"; Rec."Import and Post Whse. RMA") { }
                }
                field("Last Imported Inventory Date"; Rec."Last Imported Inventory Date")
                {
                    ToolTip = 'Specifies the last imported inventory date. The inventory date will always be the day before the data is received. Ex. if the data is received 26-09-24 will the inventory date be 25-09-24.';
                }
                field("Last LMR Date"; Rec."Last LMR Date") { }
            }
            group(eCommerce)
            {
                Caption = 'eCommerce';
                Visible = eCommerceVisible;
                field("Import eCommerce Orders"; Rec."Import eCommerce Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Import will run if "Import eCommerce Orders" and "Run Automations" are true.';
                }
                field("Post Prev. Created Sales Doc."; Rec."Post Prev. Created Sales Doc.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If eCommerce sales invoice and sales credit memos previous has been created, but not posted they will be posted in the automation run if this field is ticked off.';
                }
                field("Create Sales Document (eCommerce)"; Rec."Create Sales Document (eCom)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Create sales document will run if "Create Sales Doc. on eCommerce Order", "Run Automations" are true, and it is not "End of Month".';
                }
                field("Post eCommerce Orders"; Rec."Post eCommerce Orders")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Sales Document will post if "Post eCommerce Orders", "Run Automations" are true, and it is not "End of Month".';
                }
                field(RcptPostTransfWhseStatusAmz; Rec."Rcpt. Post Transf Whse. Status")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Works only from January until November both months included.';
                }
            }
            group(Concur)
            {
                Caption = 'Concur';
                field("Export Concur Vendors"; Rec."Export Concur Vendors")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Export Concur vendors from NAV to Concur';
                }
                field("Export Concur Vendors After"; Rec."Export Concur Vendors After")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Concur can only import one file per day, so the automation will export changed Concur vendors once after this time.';
                }
                field("Travel Expense Process"; Rec."Travel Expense Process")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice Capture Process"; Rec."Invoice Capture Process")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            // #490711 >>
            group(container)
            {
                caption = 'Container';


                field(ContainerEtaProdMode; Rec.ContainerEtaProdMode)
                {
                    ApplicationArea = Basic, Suite;
                }


            }
            // #490711 <<
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {
            group(Validation)
            {
                Caption = 'Validation';
                action("Warehouse Posting Allowed")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Posting Allowed';
                    Image = ValidateEmailLoggingSetup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        WarehousePostingAllow;
                    end;
                }
                action("Warehouse Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Inventory';

                    trigger OnAction()
                    begin
                        WarehouseInventoryAllow;
                    end;
                }
                action("Post Purchase Order EiCard Allowed")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Purchase Order EiCard Allowed';
                    Image = ValidateEmailLoggingSetup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        PostPurchaseOrderEiCardAllow;
                    end;
                }
                action("Send Sales Doc. by E-mail Automatic Allowed")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Sales Doc. by E-mail Automatic Allowed';
                    Image = ValidateEmailLoggingSetup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SendSalesDocByEmailAutoAllow;
                    end;
                }
                action("Send E-mail with EiCard Links")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send E-mail with EiCard Links';
                    Image = ValidateEmailLoggingSetup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SendEmailWithEiCardLinksAllow;
                    end;
                }
            }
        }
        area(navigation)
        {
            action("Job Queue Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Queue Entries';
                Image = JobTimeSheet;
                RunObject = Page "Job Queue Entries";
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(50086));
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then
            Rec.Insert;

        if Rec.AutomationBlockedByEOM <> '' then
            EndOfMonthVisible := true;

        eCommerceVisible := ZGT.IsRhq and ZGT.IsZNetCompany;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        Rec."Date Time Test" := 0DT;
        if Rec.WritePermission then
            Rec.Modify;
    end;

    var
        Text001: label '%1: %2\%3: %4\%5: %6\\%7: %8';
        Text002: label '%1: %2\%3: %4\\%5: %6';
        Text003: label 'Warehouse Posting Allowed';
        Text004: label 'Communication at "End of Month" Allowed';
        Text005: label 'Post Purchase Order EiCard Allowed';
        Text006: label 'Send Sales Doc. by E-mail Automatic Allowed';
        Text007: label 'Send E-mail With EiCard Links Allowed';
        ZGT: Codeunit "ZyXEL General Tools";
        EndOfMonthVisible: Boolean;
        eCommerceVisible: Boolean;

    local procedure WarehousePostingAllow()
    begin
        Message(
          Text001,
          Rec.FieldCaption(Rec."Run Automations"),
          Rec."Run Automations",
          Rec.FieldCaption(Rec."Post Warehouse Response"),
          Rec."Post Warehouse Response",
          Text004,
          Rec.EndOfMonthAllowed,
          Text003,
          Rec.WhsePostingAllowed);
    end;

    local procedure WarehouseInventoryAllow()
    begin
        Message(
          Text002,
          Rec.FieldCaption(Rec."Run Automations"),
          Rec."Run Automations",
          Rec.FieldCaption(Rec."Warehouse Inventory"),
          Rec."Warehouse Inventory");
    end;


    procedure PostPurchaseOrderEiCardAllow()
    begin
        Message(
          Text001,
          Rec.FieldCaption(Rec."Run Automations"),
          Rec."Run Automations",
          Rec.FieldCaption(Rec."Post Purchase Order EiCard"),
          Rec."Post Purchase Order EiCard",
          Text004,
          Rec.EndOfMonthAllowed,
          Text005,
          Rec.PostPurchaseOrderEiCardAllowed);
    end;

    local procedure SendEmailWithEiCardLinksAllow()
    begin
        Message(
          Text002,
          Rec.FieldCaption(Rec."Run Automations"),
          Rec."Run Automations",
          Rec.FieldCaption(Rec."Send E-mail with EiCard Links"),
          Rec."Send E-mail with EiCard Links",
          Text007,
          Rec.SendEmailWithEicardLinksAlowed);
    end;

    local procedure SendSalesDocByEmailAutoAllow()
    begin
        Message(
          Text002,
          Rec.FieldCaption(Rec."Run Automations"),
          Rec."Run Automations",
          Rec.FieldCaption(Rec."Send Sales Doc. by E-mail Auto"),
          Rec."Send Sales Doc. by E-mail Auto",
          Text006,
          Rec.SendSalesDocByEmailAutoAllowed);
    end;
}
