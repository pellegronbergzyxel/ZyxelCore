Codeunit 50081 "Delete Change Log entries"
{

    Permissions = tabledata 405 = rmdi;

    trigger OnRun()
    begin
        DeliveryDocumentLines();
        commit();
        DeliveryDocumentHeader();
        Commit();
        Items();
        commit();
        PurchaseOrderLines();
        commit();
        SalesDocuments();
        commit();
        Customers();
        commit();
        PriceList();
        Commit();
        CurrencyRate();
        Commit();
        PostedDocuments();
        Commit();
        JobQueueEntry();
        Commit();
        RemovedTables();
        Commit();
        ByName();

    end;

    var
        recCngLogEntry: Record "Change Log Entry";

    local procedure DeliveryDocumentLines()
    begin
        // Thise lines are only to make sure that changes will not be registered on creation date.
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"VCK Delivery Document Line");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Insertion);
        //recCngLogEntry.SetFilter("Field No.", '1|2');
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(Today - 1, 235900T));
        recCngLogEntry.DeleteAll();

        // After one month we don't need these any more
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"VCK Delivery Document Line");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1M>'), 235900T));
        recCngLogEntry.DeleteAll();

        // After one month we don't need these any more
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"VCK Delivery Document Line");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Deletion);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1M>'), 235900T));
        recCngLogEntry.DeleteAll();
    end;

    local procedure DeliveryDocumentHeader()
    var
        DDHeader: Record "VCK Delivery Document Header";
        DocType: Integer;
    begin
        DDHeader.SetRange(DDHeader."Document Status", DDHeader."Document Status"::Posted);
        DDHeader.setrange(DDHeader."Warehouse Status", DDHeader."Warehouse Status"::Delivered);
        DDHeader.SetFilter(SystemCreatedAt, '..%1', CreateDatetime(CalcDate('<-6M>'), 235900T));
        IF DDHeader.FindSet() then
            repeat
                recCngLogEntry.Reset();
                recCngLogEntry.SetCurrentkey("Table No.", "Primary Key Field 1 Value");
                recCngLogEntry.SetRange("Table No.", Database::"VCK Delivery Document Header");
                recCngLogEntry.SetRange("Primary Key Field 1 Value", DDHeader."No.");
                recCngLogEntry.DeleteAll();
            until DDHeader.Next() = 0;
    End;

    local procedure Items()
    begin
        // We don't need to see Cost is adjusted
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::Item);
        recCngLogEntry.SetRange("Field No.", 29);  // Cost is adjusted
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1D>'), 235900T));
        recCngLogEntry.DeleteAll();
    end;

    local procedure PurchaseOrderLines()
    begin
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Purchase Line");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Field No.", '15|22');  // Quantity or Unit Price
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1D>'), 235900T));
        recCngLogEntry.SetRange("Old Value", '0');
        recCngLogEntry.DeleteAll();
    end;

    local procedure SalesDocuments()
    var
        recSalesHead: Record "Sales Header";
        DocType: Integer;
    begin
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Sales Header");
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1D>'), 235900T));
        recCngLogEntry.SetFilter("Old Value", '%1', '');
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Sales Header", Database::"Sales Line");
        if recCngLogEntry.FindSet(true) then
            repeat
                // All lines execpt sales order is deleted.
                if recCngLogEntry."Primary Key Field 1 Value" <> '1' then
                    recCngLogEntry.Delete()
                else begin
                    // If it sales order, we delete them when they are completely invoiced.
                    Evaluate(DocType, recCngLogEntry."Primary Key Field 1 Value");
                    if recSalesHead.Get(DocType, recCngLogEntry."Primary Key Field 2 No.") then begin
                        if recSalesHead."Completely Invoiced" then
                            recCngLogEntry.Delete()
                    end else
                        recCngLogEntry.Delete();  //SO is deleted
                end;
            until recCngLogEntry.Next() = 0;
    end;

    local procedure Customers()
    begin
        // We don't need to see "Last Statement No."
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::Customer);
        recCngLogEntry.SetRange("Field No.", 41);  // Cost is adjusted
        recCngLogEntry.SetRange("Type of Change", recCngLogEntry."type of change"::Modification);
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-1D>'), 235900T));
        recCngLogEntry.DeleteAll();
    end;

    local procedure PriceList()
    begin
        // We don't need to see "Last Statement No."
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Price List Line");
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-6M>'), 235900T));
        recCngLogEntry.DeleteAll();
    end;

    local procedure CurrencyRate()
    begin
        // Job Queue Entry removed - old Data
        // We don't need to see "Last Statement No."
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Currency Exchange Rate");
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-6M>'), 235900T));
        recCngLogEntry.DeleteAll();
    end;


    local procedure ByName()
    begin
        // We don't need to see "Last Statement No."
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("User ID", "Date and Time");
        recCngLogEntry.SetRange("User ID", 'ZYEU\BCSERVICE');
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-14D>'), 235900T));
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("User ID", "Date and Time");
        recCngLogEntry.SetRange("User ID", 'ZYEU\BIRGITTE.KLAPROTH');
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-6M>'), 235900T));
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("User ID", "Date and Time");
        recCngLogEntry.SetRange("User ID", 'ZYEU\PELLE.GRONBERG');
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-6M>'), 235900T));
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("User ID", "Date and Time");
        recCngLogEntry.SetRange("User ID", 'ZYEU\LARS.DYRING');
        recCngLogEntry.SetFilter("Date and Time", '..%1', CreateDatetime(CalcDate('<-6M>'), 235900T));
        recCngLogEntry.DeleteAll();


    end;

    local procedure JobQueueEntry()
    begin
        // Job Queue Entry removed - old Data
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Job Queue Entry");
        recCngLogEntry.DeleteAll();
    end;

    local procedure RemovedTables()
    begin
        // VAT Entry removed - old Data
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"VAT Entry");
        recCngLogEntry.DeleteAll();

        // VAT Entry removed - old Data
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Automation Setup");
        recCngLogEntry.DeleteAll();
    end;

    local procedure PostedDocuments()
    begin
        // Changelog removed - old data
        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Sales Invoice Header");
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Sales Invoice Line");
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Sales Cr.Memo Header");
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Sales Cr.Memo Line");
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Purch. Inv. Header");
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Purch. Inv. Line");
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Purch. Cr. Memo Hdr.");
        recCngLogEntry.DeleteAll();

        recCngLogEntry.Reset();
        recCngLogEntry.SetCurrentkey("Table No.", "Date and Time");
        recCngLogEntry.SetRange("Table No.", Database::"Purch. Cr. Memo Line");
        recCngLogEntry.DeleteAll();
    end;

}
