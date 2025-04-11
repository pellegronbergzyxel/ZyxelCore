report 50081 "Update eCommerce Amounts"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("eCommerce Order Header"; "eCommerce Order Header")
        {
            RequestFilterFields = Correction;
            dataitem("eCommerce Order Line"; "eCommerce Order Line")
            {
                DataItemLink = "Transaction Type" = field("Transaction Type"), "eCommerce Order Id" = field("eCommerce Order Id"), "Invoice No." = field("Invoice No.");
                DataItemTableView = sorting("Transaction Type", "eCommerce Order Id", "Invoice No.", "Line No.");
                RequestFilterFields = "eCommerce Order Id";

                trigger OnAfterGetRecord()
                var
                    AOL: Record "eCommerce Order Line";
                begin
                    "eCommerce Order Line".Validate("eCommerce Order Line".Amount);
                    "eCommerce Order Line".Modify();

                    //ZGT.UpdateProgressWindow("eCommerce Order Id",0,TRUE);
                    /*AOL := "eCommerce Order Line";
                    AOL."Transaction Type" := "eCommerce Order Header"."Transaction Type";
                    AOL.VALIDATE(Amount);
                    
                    "eCommerce Order Line".DELETE;
                    AOL.INSERT;*/
                end;

                trigger OnPostDataItem()
                begin
                    //ZGT.CloseProgressWindow;
                end;

                trigger OnPreDataItem()
                begin
                    //ZGT.OpenProgressWindow('',COUNT);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow('eCommerce Header', 0, true);
                //VALIDATE("VAT Bus. Posting Group");
                //MODIFY;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "eCommerce Order Header".Count());
            end;
        }
        dataitem("eCommerce Order Line Archive"; "eCommerce Order Line Archive")
        {
            trigger OnAfterGetRecord()
            var
                recAmzOrdArch: Record "eCommerce Order Archive";
                AOLA: Record "eCommerce Order Line Archive";
            begin
                ZGT.UpdateProgressWindow('eCommerce Archive', 0, true);

                AOLA := "eCommerce Order Line Archive";
                recAmzOrdArch.SetRange("eCommerce Order Id", "eCommerce Order Line Archive"."eCommerce Order Id");
                recAmzOrdArch.SetRange("Invoice No.", "eCommerce Order Line Archive"."Invoice No.");
                recAmzOrdArch.FindFirst();
                AOLA."Transaction Type" := recAmzOrdArch."Transaction Type";

                AOLA.Amount :=
                  "eCommerce Order Line Archive"."Total (Exc. Tax)" +
                  "eCommerce Order Line Archive"."Total Shipping (Exc. Tax)" + "eCommerce Order Line Archive"."Shipping Promo (Exc. Tax)" +
                  "eCommerce Order Line Archive"."Total Promo (Exc. Tax)" +
                  "eCommerce Order Line Archive"."Gift Wrap (Exc. Tax)" + "eCommerce Order Line Archive"."Gift Wrap Promo (Exc. Tax)" +
                  "eCommerce Order Line Archive"."Line Discount Excl. Tax";

                AOLA."Tax Amount" :=
                  "eCommerce Order Line Archive"."Total Tax Amount" +
                  "eCommerce Order Line Archive"."Total Shipping Tax Amount" + "eCommerce Order Line Archive"."Shipping Promo Tax Amount" +
                  "eCommerce Order Line Archive"."Total Promo Tax Amount" +
                  "eCommerce Order Line Archive"."Gift Wrap Tax Amount" + "eCommerce Order Line Archive"."Gift Wrap Promo Tax Amount" +
                  "eCommerce Order Line Archive"."Line Discount Tax Amount";

                AOLA."Amount Including VAT" :=
                  "eCommerce Order Line Archive"."Total (Inc. Tax)" +
                  "eCommerce Order Line Archive"."Total Shipping (Inc. Tax)" + "eCommerce Order Line Archive"."Shipping Promo (Inc. Tax)" +
                  "eCommerce Order Line Archive"."Total Promo (Inc. Tax)" +
                  "eCommerce Order Line Archive"."Gift Wrap (Inc. Tax)" + "eCommerce Order Line Archive"."Gift Wrap Promo (Inc. Tax)" +
                  "eCommerce Order Line Archive"."Line Discount Incl. Tax";
                //MODIFY;

                "eCommerce Order Line Archive".Delete();
                AOLA.Insert();
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.Break();

                ZGT.OpenProgressWindow('', "eCommerce Order Line Archive".Count());
            end;
        }
    }

    var
        ZGT: Codeunit "ZyXEL General Tools";
}
