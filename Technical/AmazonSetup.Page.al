page 50133 "Amazon setup list"
{
    ApplicationArea = All;
    Caption = 'Amazon setup list';
    PageType = List;
    SourceTable = "Amazon Setup";
    UsageCategory = Administration;
    Editable = true;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Customerno; Rec.Customerno)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                //field(Bill2Customer; Rec.Bill2Customer)
                //{
                //   ApplicationArea = All;
                //}
                field(UpdateCustOnStatus; Rec.UpdateCustOnStatus)
                {
                    ApplicationArea = All;
                }
                field(lastimport; rec.lastimport)
                {
                    ApplicationArea = All;
                }
                field(ActiveClient; Rec.ActiveClient)
                {
                    ApplicationArea = All;
                }
                field(NordiskPartyid; Rec.ZyxelPartyid)
                {
                    ApplicationArea = All;
                }
                field("Token endpoint"; Rec."Token endpoint")
                {
                    ApplicationArea = All;
                }
                field(URL_PO_GET; Rec.URL_PO_GET)
                {
                    ApplicationArea = All;
                }
                field(URL_PO_GET_status; Rec.URL_PO_GET_status)
                {
                    ApplicationArea = All;
                }
                field(URL_Set_AKN; Rec.URL_Set_AKN)
                {
                    ApplicationArea = All;
                }
                field(client_id; Rec.client_id)
                {
                    ApplicationArea = All;
                }
                field(client_secret; Rec.client_secret)
                {
                    ApplicationArea = All;
                }
                field(grant_type; Rec.grant_type)
                {
                    ApplicationArea = All;
                }
                field(Refresh_token; Rec.Refresh_token)
                {
                    ApplicationArea = All;
                }
                field(URL_PO_GET_order; rec.URL_PO_GET_order)
                {
                    ApplicationArea = All;
                }
                field(URL_packingSlips_order; Rec.URL_packingSlips_order)
                {
                    ApplicationArea = All;
                }
                field(URL_GET_status_Purchase; rec.URL_GET_status_Purchase)
                {
                    ApplicationArea = All;
                }
                field(testmode; Rec.testmode)
                {
                    ApplicationArea = All;
                }
                field(NoSendfilonPost; Rec.NoSendfilonPost)
                {
                    ApplicationArea = All;
                }
                field(AutorejectedFutureSOOver; Rec.AutorejectedFutureSOOver)
                {
                    ApplicationArea = All;
                }
                field(OnlyReleaseafterStatus; Rec.OnlyReleaseafterStatus)
                {
                    ApplicationArea = All;
                }
                field(OnlyReleaseafterStatusvalue; Rec.OnlyReleaseafterStatusvalue)
                {
                    ApplicationArea = All;
                }

                field(AutoRejectOrderbelowlcy; Rec.AutoRejectOrderbelowlcy)
                {
                    ApplicationArea = All;
                }
                field(Locationcode; Rec.Locationcode)
                {
                    ApplicationArea = All;
                }


            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ShowCustomer)
            {
                caption = 'Amazon Bill/Sell-to customer';
                Image = CustomerList;
                ApplicationArea = all;

                trigger OnAction()
                var
                    Customer: record Customer;
                    CustomerList: Page "Customer List";
                begin
                    Customer.setfilter(AMAZONID, '<>%1', '');
                    CustomerList.SetTableView(Customer);
                    CustomerList.run();
                end;
            }
            action(showSO)
            {
                caption = 'Open Amazon Sales orders';
                Image = OrderList;
                ApplicationArea = all;

                trigger OnAction()
                var
                    Salesheader: record "Sales Header";
                    LookupPageId: page "Sales Order List";
                begin
                    Salesheader.setrange("Document Type", Salesheader."Document Type"::Order);
                    Salesheader.setfilter(AmazonePoNo, '<>%1', '');
                    LookupPageId.SetTableView(Salesheader);
                    LookupPageId.run();
                end;
            }
        }

        area(Processing)
        {
            action(run)
            {
                caption = 'Resesh new token';
                Image = GetSourceDoc;
                ApplicationArea = all;
                trigger OnAction()
                var
                    amazhelper: codeunit amazonHelper;
                    token: text;
                begin

                    if amazhelper.GetnewToken(token, rec.ZyxelPartyid) Then
                        message('OK: %1', token)
                    else
                        message('error');
                end;
            }
            action(Order)
            {
                caption = 'Processes orders';
                Image = GetSourceDoc;
                ApplicationArea = all;
                trigger OnAction()
                var
                    amazhelper: codeunit amazonHelper;
                    order: text;
                begin

                    amazhelper.MainProcessOrders('', true, '');


                end;
            }
            action(OrderEach)
            {
                caption = 'Processes order by number';
                Image = GetSourceDoc;
                ApplicationArea = all;

                trigger OnAction()
                var
                    amazhelper: codeunit amazonHelper;
                    //amazonunput: page "Amazon PO input";
                    order: code[20];
                begin
                    //if amazonunput.RunModal() = Action::OK then begin
                    //    order := amazonunput.getvalue();
                    //    amazhelper.MainProcessOrders(rec.Code, false, order);
                    //end;


                end;
            }
            action(delelte11maj)
            {
                caption = 'slet test ordre';
                Image = GetSourceDoc;
                ApplicationArea = all;

                trigger OnAction()
                var

                begin
                    if rec.testmode then
                        rec.cleanSO
                    //if amazonunput.RunModal() = Action::OK then begin
                    //    order := amazonunput.getvalue();
                    //    amazhelper.MainProcessOrders(rec.Code, false, order);
                    //end;


                end;
            }
            action(CleanSA)
            {
                caption = 'slet test ship addresser';
                Image = GetSourceDoc;
                ApplicationArea = all;

                trigger OnAction()
                var

                begin
                    if rec.testmode then
                        rec.deleteshiptoaddress();
                    //if amazonunput.RunModal() = Action::OK then begin
                    //    order := amazonunput.getvalue();
                    //    amazhelper.MainProcessOrders(rec.Code, false, order);
                    //end;


                end;
            }


            // action(Onetime1)
            // {
            //     caption = 'Onetime: update shippingtime';
            //     Image = GetSourceDoc;
            //     ApplicationArea = all;

            //     trigger OnAction()
            //     var
            //         amazhelper: codeunit amazonHelper;

            //     begin
            //         amazhelper.OnetimeUpdateshipping();



            //     end;
            // }

        }
    }

}
