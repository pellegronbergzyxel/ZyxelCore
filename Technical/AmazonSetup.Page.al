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
                field(testmode; Rec.testmode)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
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

            action(showSO)
            {
                caption = 'Amazon Sales orders';
                Image = GetSourceDoc;
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

            action(Onetime1)
            {
                caption = 'Onetime: update shippingtime';
                Image = GetSourceDoc;
                ApplicationArea = all;

                trigger OnAction()
                var
                    amazhelper: codeunit amazonHelper;

                begin
                    amazhelper.OnetimeUpdateshipping();



                end;
            }

        }
    }

}
