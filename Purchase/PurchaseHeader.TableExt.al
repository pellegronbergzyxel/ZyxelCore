tableextension 50118 PurchaseHeaderZX extends "Purchase Header"
{
    //17-06-2025 BK #Clean up   
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(13650; "Giro Acc. No."; Code[10])
        {
            Caption = 'Giro Acc. No.';

            trigger OnValidate()
            begin
                if Rec."Giro Acc. No." <> '' then
                    Rec."Giro Acc. No." := PadStr('', MaxStrLen(Rec."Giro Acc. No.") - StrLen(Rec."Giro Acc. No."), '0') + Rec."Giro Acc. No.";
            end;
        }
        field(50000; "Related Company"; Boolean)
        {
            CalcFormula = lookup(Vendor."Related Company" where("No." = field("Buy-from Vendor No.")));
            Description = '03-11-17 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Requested Date From Factory"; Date)
        {
            Description = 'DT1.00';
        }
        field(50003; "Ship-from Country/Region Code"; Code[10])
        {
            Caption = 'Ship-from Country/Region Code';
            Description = '04-12-20 ZY-LD 018';
            TableRelation = "Country/Region";
        }
        field(50005; "CZ Sales Order No."; Code[20])
        {
            Description = 'ZY2.0 Used in Auto Routine when sales order is created in RHQ Live from CZ';
        }
        field(50006; "VAT Registration No. Zyxel"; Code[20])
        {
            Caption = 'VAT Registration No. Zyxel';
            Description = '30-05-19 ZY-LD 018';
        }
        field(50007; "From User"; Code[50])
        {
            Description = 'PAB 1.0';
            TableRelation = "User Setup"."User ID";
        }
        field(50008; "From E-Mail Address"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50009; "From E-Mail Signature"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50010; "EiCard Email Subject"; Text[100])
        {
            Description = 'PAB 1.0';
        }
        field(50015; "EiCard Sales Order"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Sales Header"."No.";
        }
        field(50018; "EiCard Distributor Reference"; Text[20])
        {
            Description = 'PAB 1.0';
        }
        field(50019; "EiCard Status"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'Created,EiCard Order Sent to HQ,EiCard Order Accepted,EiCard Order Rejected,Fully Matched,Partially Matched,Posted,Posting Error';
            OptionMembers = Created,"EiCard Order Sent to HQ","EiCard Order Accepted","EiCard Order Rejected","Fully Matched","Partially Matched",Posted,"Posting Error";
        }
        field(50020; "EiCard Send HTML Email"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50021; "EiCard To Email 4"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50022; "EiCard To Email 5"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50023; UpdateAllIn; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50024; "Buy-from Phone"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50025; "Buy-from Email"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50026; "Ship-to Phone"; Text[20])
        {
            Description = 'PAB 1.0';
        }
        field(50027; "Ship-to Email"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50028; "Vendor Status"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'None,Order Created,Order Sent,Order Received,Order Rejected,Partialy Dispatched,Dispatched';
            OptionMembers = "None","Order Created","Order Sent","Order Received","Order Rejected","Partialy Dispatched",Dispatched;
        }
        field(50029; "Warehouse Status"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'None,Order Sent,Goods Partially Received,Goods Reveived,Putting Away,Partially Putting Away,Partially On Stock,On Stock';
            OptionMembers = "None","Order Sent","Goods Partially Received","Goods Reveived","Putting Away","Partially Putting Away","Partially On Stock","On Stock";
        }
        field(50030; "EShop Order Sent"; Boolean)
        {
            Caption = 'Order Sent to Vendor';
            Description = 'PAB 1.0';
        }
        field(50031; "EShop Message"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50033; "Project Code"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(50034; "Sent to HQ"; Boolean)
        {
            Caption = 'DonÍt send to Vendor';
            Description = 'PAB 1.0';
        }
        field(50035; SentToAllIn; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50036; "Order Acknowledged"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50039; "Ship-to E-Mail"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50040; "Ship-to VAT"; Text[40])
        {
            Description = 'eCommerce';
        }
        field(50041; "EiCard Ready to Post"; Boolean)
        {
            CalcFormula = exist("EiCard Queue" where("Purchase Order No." = field("No."),
                                                     Active = const(true),
                                                     "Purchase Order Status" = filter("EiCard Order Accepted" | "Fully Matched"),
                                                     "HQ Invoice Received" = const(true)));
            Caption = 'EiCard Ready to Post';
            Description = '24-09-19 ZY-LD 013';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50042; "Post Order Without HQ Document"; Boolean)
        {
            Caption = 'Post Order Without Electronic Document';
            Description = '24-10-19 ZY-LD 014';
        }
        field(50043; "FTP Code"; Code[20])
        {
            Caption = 'FTP Code';
            Description = '04-11-19 ZY-LD 004';
            TableRelation = "FTP Folder";
        }
        field(50044; "SBU Company"; Option)
        {
            CalcFormula = lookup(Vendor."SBU Company" where("No." = field("Buy-from Vendor No.")));
            Caption = 'SBU Company';
            Description = '04-11-19 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Zyxel,ZNet';
            OptionMembers = " ",Zyxel,ZNet;
        }
        field(50045; "Special Order Sales No."; Code[20])
        {
            CalcFormula = lookup("Purchase Line"."Special Order Sales No." where("Document Type" = field("Document Type"),
                                                                                 "Document No." = field("No."),
                                                                                 Type = const(Item),
                                                                                 "Special Order" = const(true)));
            Caption = 'Special Order Sales No.';
            Description = '26-02-20 ZY-LD 016';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50056; "NL to DK Reverse Chg. Doc No."; Code[20])  // 13-03-24 ZY-LD 000
        {
            Caption = 'NL to DK Rev. Charge Document No.';
        }
        field(50061; "eCommerce Order"; Boolean)
        {
            Description = 'eCommerce';
        }
        field(50062; "Reference 2"; Text[30])
        {
            Description = 'eCommerce';
        }
        field(50063; Arhived; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(62015; IsEICard; Boolean)
        {
            Caption = 'Is EICard';
            Description = 'Tectura Taiwan';
        }
        field(62016; "OutBound Status"; Code[10])
        {
            Description = 'Zyxel Taiwan';
        }
        field(62033; "Dist. Purch. Order No."; Text[30])
        {
            Description = 'Tectura Taiwan';
        }
        field(62034; "Dist. E-mail"; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
        field(62035; "Create User ID"; Code[30])
        {
            Description = 'ZyXEL HQ Support Team_20120222';
        }
        field(62036; "From SO No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(62037; "SO Sell-to Customer No"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(62038; "SO Sell-to Customer Name"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(66001; "DSV Status"; Option)
        {
            OptionMembers = " ",New,Sent,Recieved;
        }
        field(67001; "End Customer"; Code[20])
        {
            TableRelation = Customer;
        }
        field(67002; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Purchase Line".Amount where("Document No." = field("No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(67003; "Last Status Change"; DateTime)
        {
            Description = 'PAB 1.0';
        }
        field(67004; "Shipping Request Notes"; Text[96])
        {
            Description = 'PAB 1.0';
        }
        field(67005; "Not Insert Visible Fee"; Boolean)
        {
            Description = 'PAB 1.0';
        }
    }

    trigger OnInsert()
    begin
        //005. Added By Craig on 20120222 for adding creation user id
        "Create User ID" := copystr(UserId(), 1, 30);
        "Transport Method" := AllIn.GetTransportMethod(IsEICard);
    end;

    var
        AllIn: Codeunit "ZyXEL VCK";




    // 494391
    procedure CreatecontainerfromPurchaseInv(PurchaseHeader: Record "Purchase Header")
    var
        WhseInbLine: Record "VCK Shipping Detail";
        WhseInbHead: Record "Warehouse Inbound Header";
        POL: Record "Purchase Line";
        Location: Record Location; //13-06-25 BK #511511
        ZGT: Codeunit "ZyXEL General Tools";
        ZNetLabel1: Label 'ZNET-INTERNAL';
        ZNetLabel2: Label 'ZNET-';
        ZComLabel1: Label 'ZYXEL-INTERNAL';
        ZComLabel2: Label 'ZCOM-';
        First: Boolean;
        EntryNo: Integer;
        WarehouseLineNo: Integer;

    begin
        WhseInbHead.SetCurrentkey("Shipper Reference");
        WhseInbHead.SetRange("Shipper Reference", 'INV' + PurchaseHeader."No.");
        WhseInbHead.SetRange("Location Code", PurchaseHeader."Location Code");

        if Not WhseInbHead.FindSet() then begin
            POL.Setrange("Document Type", PurchaseHeader."Document Type");
            POL.setrange("Document No.", PurchaseHeader."No.");
            Pol.Setrange(Type, Pol.Type::item);
            Pol.setfilter(Quantity, '<>%1', 0);
            if Pol.findset() then begin
                WhseInbHead.init();
                WhseInbHead.insert(true);
                IF PurchaseHeader."Expected Receipt Date" = 0D THEN
                    PurchaseHeader."Expected Receipt Date" := PurchaseHeader."Document Date";

                if ZGT.IsZNetCompany() then //18-07-2025 BK #511511
                    WhseInbHead."Shipper Reference" := ZNetLabel2 + Pol."Picking List No."
                else
                    WhseInbHead."Shipper Reference" := ZComLabel2 + Pol."Picking List No.";

                //WhseInbHead."Shipper Reference" := 'INV' + PurchaseHeader."No.";
                WhseInbHead."Location Code" := PurchaseHeader."Location Code";
                WhseInbHead."Sender No." := PurchaseHeader."Buy-from Vendor No.";
                WhseInbHead."Sender Name" := PurchaseHeader."Buy-from Vendor Name";
                WhseInbHead."Sender Name 2" := PurchaseHeader."Buy-from Vendor Name 2";
                WhseInbHead."Sender Address" := PurchaseHeader."Buy-from Address";
                WhseInbHead."Sender Address 2" := PurchaseHeader."Buy-from Address 2";
                WhseInbHead."Sender Post Code" := PurchaseHeader."Buy-from Post Code";
                WhseInbHead."Sender City" := PurchaseHeader."Buy-from City";
                WhseInbHead."Sender Country/Region Code" := PurchaseHeader."Buy-from Country/Region Code";
                WhseInbHead."Sender County" := copystr(PurchaseHeader."Buy-from County", 1, 10);
                WhseInbHead."Sender Contact" := copystr(PurchaseHeader."Buy-from Contact", 1, 50);
                WhseInbHead."Estimated Date of Departure" := PurchaseHeader."Expected Receipt Date";
                WhseInbHead."Estimated Date of Arrival" := PurchaseHeader."Expected Receipt Date";
                WhseInbHead."Expected Receipt Date" := PurchaseHeader."Expected Receipt Date";
                WhseInbHead."Shipment No." := PurchaseHeader."No.";
                WhseInbHead."Creation Date" := CurrentDatetime;
                WhseInbHead."Order Type" := WhseInbHead."Order Type"::"Purchase Invoice";
                WhseInbHead."Automatic Created" := true;
                WhseInbHead.Modify(true);
                First := true;
                WarehouseLineNo := 10000;
                repeat
                    WhseInbLine.init();
                    WhseInbLine."Order Type" := WhseInbLine."Order Type"::"Purchase Invoice";
                    WhseInbLine."Purchase Order No." := Pol."Document No.";
                    WhseInbLine."Purchase Order Line No." := Pol."Line No.";
                    IF First then begin //13-06-025 BK #511511
                        WhseInbLine.insert(true);
                        EntryNo := WhseInbLine."Entry No.";
                        First := false;
                    end else begin
                        WhseInbLine."Entry No." := EntryNo + 1;
                        WhseInbLine.insert(true);
                    end;
                    WhseInbLine.Location := PurchaseHeader."Location Code";
                    if Location.get(PurchaseHeader."Location Code") then
                        WhseInbLine."Main Warehouse" := Location."Main Warehouse"; //13-06-025 BK #511511
                    WhseInbLine."Item No." := Pol."No.";
                    WhseInbLine.Quantity := Pol.Quantity;
                    WhseInbLine.ETA := Pol."Expected Receipt Date";
                    WhseInbLine.ETD := Pol."Expected Receipt Date";
                    WhseInbLine."Expected Receipt Date" := Pol."Expected Receipt Date";

                    //16-10-2025 BK #533597
                    if WhseInbLine.ETD <> 0D then
                        if zgt.IsZComCompany() then
                            WhseInbLine.Validate(ETD);

                    //01-07-025 BK #511511
                    if ZGT.IsZNetCompany() then begin
                        WhseInbLine."Bill of Lading No." := ZNetLabel1;
                        WhseInbLine."Order No." := ZNetLabel2 + WhseInbHead."No.";
                    End else begin
                        WhseInbLine."Bill of Lading No." := zComLabel1;
                        WhseInbLine."Order No." := ZcomLabel2 + WhseInbHead."No.";
                    end;

                    WhseInbLine."Invoice No." := copystr(PurchaseHeader."Vendor Invoice No.", 1, 30);
                    WhseInbLine."Container No." := Pol."Picking List No.";
                    WhseInbLine."Document No." := WhseInbHead."No.";
                    WhseInbLine."Line No." := WarehouseLineNo; //08-08-2025 BK #511511
                    WarehouseLineNo += 10000;
                    WhseInbLine.modify(false);

                until Pol.next() = 0;
            end;
        end;
    end;
}
