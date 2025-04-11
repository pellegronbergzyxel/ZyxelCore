Codeunit 50081 "Delete Change Log entries"
{
    // 001. 22-06-18 ZY-LD 000 Items.
    // 002. 12-02-19 ZY-LD 000 Purchase Order Lines
    // 003. 13-02-19 ZY-LD 2019013110000038 - Sales documents.
    // 005. 05-02-21 ZY-LD 000 - Customers.
    Permissions = tabledata 405 = rmdi;

    trigger OnRun()
    begin
        DeliveryDocumentLines;
        commit;
        Items;
        commit;
        PurchaseOrderLines;  // 12-02-19 ZY-LD 002
        commit;
        SalesDocuments;
        commit;
        Customers;
    end;

    var
        recCngLogEntry: Record "Change Log Entry";

    local procedure DeliveryDocumentLines()
    begin
        // Thise lines are only to make sure that changes will not be registered on creation date.
        recCngLogEntry.Reset;
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"VCK Delivery Document Line");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Insertion);
        recCngLogEntry.SetFilter("Field No.", '1|2');
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(Today - 1, 235900T));
        recCngLogEntry.DeleteAll;

        // After one month we don't need these any more
        recCngLogEntry.Reset;
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"VCK Delivery Document Line");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1M>'), 235900T));
        recCngLogEntry.DeleteAll;

        // After one month we don't need these any more
        recCngLogEntry.Reset;
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"VCK Delivery Document Line");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Deletion);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1M>'), 235900T));
        recCngLogEntry.DeleteAll;
    end;

    local procedure Items()
    begin
        // We don't need to see Cost is adjusted
        //>> 22-06-18 ZY-LD 001
        recCngLogEntry.Reset;
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::Item);
        recCngLogEntry.SetRange("Field No.", 29);  // Cost is adjusted
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1D>'), 235900T));
        recCngLogEntry.DeleteAll;
        //<< 22-06-18 ZY-LD 001
    end;

    local procedure PurchaseOrderLines()
    begin
        //>> 12-02-19 ZY-LD 002
        recCngLogEntry.Reset;
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Purchase Line");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Field No.", '15|22');  // Quantity or Unit Price
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1D>'), 235900T));
        recCngLogEntry.SetRange("Old Value", '0');
        recCngLogEntry.DeleteAll;
        //<< 12-02-19 ZY-LD 002
    end;

    local procedure SalesDocuments()
    var
        recSalesHead: Record "Sales Header";
        DocType: Integer;
    begin
        //>> 13-02-19 ZY-LD 003
        recCngLogEntry.Reset;
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Sales Header");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1D>'), 235900T));
        recCngLogEntry.SetFilter("Old Value", '%1', '');
        recCngLogEntry.DeleteAll;

        recCngLogEntry.Reset;
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Sales Header", Database::"Sales Line");
        if recCngLogEntry.FindSet(true) then
            repeat
                // All lines execpt sales order is deleted.
                if recCngLogEntry."Primary Key Field 1 Value" <> '1' then
                    recCngLogEntry.Delete
                else begin
                    // If it sales order, we delete them when they are completely invoiced.
                    Evaluate(DocType, recCngLogEntry."Primary Key Field 1 Value");
                    if recSalesHead.Get(DocType, recCngLogEntry."Primary Key Field 2 No.") then begin
                        if recSalesHead."Completely Invoiced" then
                            recCngLogEntry.Delete
                    end else
                        recCngLogEntry.Delete;  //SO is deleted
                end;
            until recCngLogEntry.Next() = 0;
        //<< 13-02-19 ZY-LD 003
    end;

    local procedure Customers()
    begin
        // We don't need to see "Last Statement No."
        //>> 05-02-21 ZY-LD 005
        recCngLogEntry.Reset;
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::Customer);
        recCngLogEntry.SetRange("Field No.", 41);  // Cost is adjusted
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1D>'), 235900T));
        recCngLogEntry.DeleteAll;
        //<< 05-02-21 ZY-LD 005
    end;
}
