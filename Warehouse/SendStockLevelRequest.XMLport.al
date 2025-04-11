XmlPort 50056 "Send Stock Level Request"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 22-02-22 ZY-LD P0767 - Namespace is changed.

    Caption = 'Send Stock Level Request';
    DefaultNamespace = 'http://schemas.allincontrol.com/BizTalk/2013';
    Direction = Export;
    Encoding = UTF8;
    FileName = 'C:\tmp\test.xml';
    Format = Xml;
    FormatEvaluate = Legacy;
    UseDefaultNamespace = true;
    UseRequestPage = false;

    schema
    {
        textelement(IncomingRequest)
        {
            textelement(CustomerID)
            {
            }
            textelement(MessageNo)
            {
            }
            textelement(CustomerMessageNo)
            {
            }
            textelement(ProjectID)
            {
            }
            textelement(CostCenter)
            {
            }
            textelement(Requests)
            {
                textelement(Stock)
                {
                    textelement(ItemNo)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            ItemNo := '*';
                        end;
                    }
                    textelement(Location)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            Location := '*';
                        end;
                    }
                    textelement(Warehouse)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            Warehouse := '*';
                        end;
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    var
        recItem: Record Item;
    begin
    end;


    procedure SetParameters(Customer: Code[20]; Project: Code[20]; Message: Code[20])
    begin
        CustomerID := Customer;
        ProjectID := Project;
        CustomerMessageNo := Message;
    end;
}
