report 50101 "Update Magento Payment"
{
    Caption = 'Update Magento Payment - Delete again.';
    ProcessingOnly = true;
    UsageCategory = Administration;

    dataset
    {
        dataitem("eCommerce Payment Header"; "eCommerce Payment Header")
        {
            RequestFilterFields = "Market Place ID";
            dataitem("eCommerce Payment"; "eCommerce Payment")
            {
                DataItemLink = "Journal Batch No." = field("No.");

                trigger OnAfterGetRecord()
                begin
                    ZGT.CloseProgressWindow;

                    LineNo += 1;

                    if "eCommerce Payment Header"."Currency Code" = '' then begin
                        "eCommerce Payment Header"."Currency Code" := "eCommerce Payment"."Currency Code";
                        "eCommerce Payment Header".Modify();
                    end;
                    if "eCommerce Payment Header"."Transaction Summary" = '' then begin
                        "eCommerce Payment Header"."Transaction Summary" := "eCommerce Payment"."Order ID";
                        "eCommerce Payment Header".Period := "eCommerce Payment"."Order ID";
                        "eCommerce Payment Header".Modify();
                    end;

                    case CopyStr("eCommerce Payment"."eCommerce Invoice No.", 1, 1) of
                        'O':
                            "eCommerce Payment".Validate("eCommerce Payment"."New Transaction Type", 'ORDER');
                        'R':
                            "eCommerce Payment".Validate("eCommerce Payment"."New Transaction Type", 'REFUND');
                    end;

                    case LineNo of
                        1:
                            begin
                                "eCommerce Payment".Validate("eCommerce Payment"."Amount Type", 'PRODUCT CHARGE');
                                "eCommerce Payment".Validate("eCommerce Payment"."Amount Description", 'BLANK');
                            end;
                        2:
                            begin
                                "eCommerce Payment".Validate("eCommerce Payment"."Amount Type", 'PAYMENT FEE');
                                "eCommerce Payment".Validate("eCommerce Payment"."Amount Description", 'BLANK');
                            end;
                    end;
                    "eCommerce Payment".Modify();
                end;

                trigger OnPreDataItem()
                begin
                    LineNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow('', 0, true);
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "eCommerce Payment Header".Count());
            end;
        }
    }

    var
        LineNo: Integer;
        ZGT: Codeunit "ZyXEL General Tools";
}
