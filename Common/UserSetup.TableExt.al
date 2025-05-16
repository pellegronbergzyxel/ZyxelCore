tableextension 50125 UserSetupZX extends "User Setup"
{
    fields
    {
        field(50000; "Confirm Shipment Date on SL"; Boolean)
        {
            Caption = 'Confirm Picking Date on Sales Order';
            Description = '26-10-17 ZY-LD 001';
        }
        field(50001; "Do Not Show Selected Fields"; Boolean)
        {
            Caption = 'DonÍt Show Selected Fields on Sales Header';
            Description = '26-10-17 ZY-LD 001';
        }
        field(50002; "Use User E-mail on Documents"; Boolean)
        {
            Caption = 'Use User E-mail on Documents';
            Description = '06-12-18 ZY-LD 002';
        }
        field(50003; "E-Mail Footer Name"; Text[50])
        {
            Caption = 'E-Mail Footer Name';
            Description = '02-01-19 ZY-LD 003';
        }
        field(50004; "E-mail Footer Address"; Text[50])
        {
            Caption = 'E-mail Footer Address';
            Description = '02-01-19 ZY-LD 003';
        }
        field(50005; "E-mail Footer Address 2"; Text[50])
        {
            Caption = 'E-mail Footer Address 2';
            Description = '02-01-19 ZY-LD 003';
        }
        field(50006; "E-mail Footer Address 3"; Text[50])
        {
            Caption = 'E-mail Footer Address 3';
            Description = '02-01-19 ZY-LD 003';
        }
        field(50007; "E-mail Footer Phone No."; Text[20])
        {
            Caption = 'E-mail Footer Phone No.';
            Description = '02-01-19 ZY-LD 003';
        }
        field(50008; "E-mail Footer Mobile Phone No."; Text[20])
        {
            Caption = 'E-mail Footer Mobile Phone No.';
            Description = '02-01-19 ZY-LD 003';
        }
        field(50009; "E-mail Footer Skype"; Text[50])
        {
            Caption = 'E-mail Footer Skype';
            Description = '02-01-19 ZY-LD 003';
        }
        field(50010; "Sort Sales Order by Prim. Key"; Boolean)
        {
            Caption = 'Sort Sales Order by Primary Key';
            Description = '19-02-20 ZY-LD 005';
        }
        field(50011; MDM; Boolean)
        {
            Caption = 'MDM';
            Description = '06-10-21 ZY-LD 006';
        }
        field(50012; SCM; Boolean)
        {
            Caption = 'SCM';
            Description = '06-10-21 ZY-LD 006';
        }
        field(50013; "Show Goods in Transit as"; Option)
        {
            Caption = 'Show Goods in Transit as';
            Description = '10-06-22 ZY-LD 007';
            InitValue = Merged;
            OptionCaption = 'Raw Data,Merged';
            OptionMembers = "Raw Data",Merged;
        }
        field(50014; "User Type"; Option)  // 01-03-24 ZY-LD Used to prevent access to certan fields in the customer card.
        {
            Caption = 'User Type';
            OptionCaption = ' ,Accounting Manager,Accounting Service Center,Human Resource';
            OptionMembers = " ","Accounting Manager","Accounting Service Center","Human Resource";

            trigger OnValidate()
            begin
                "Show Customer Contracts" := "User Type" IN ["User Type"::"Accounting Manager", "User Type"::"Human Resource"]
            end;
        }
        field(50020; "Head Quarter"; Boolean)
        {
            Caption = 'Head Quarter';
            DataClassification = CustomerContent;
        }
        field(50025; "Show Picking Date"; Boolean)
        {
            Caption = 'Show Picking Date';
            DataClassification = CustomerContent;
        }
        field(50026; "Show Concur ID"; Boolean)
        {
            Caption = 'Show Concur ID';
            DataClassification = CustomerContent;
        }
        field(50057; "EMail Signature"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(50058; "EICard User"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50063; AllInPurchaseOrders; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50064; AllInSalesOrders; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50065; "Can Block Items"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50066; Department; Code[10])
        {
            Description = 'PAB 1.0';
        }
        field(50067; "Show Customer Contracts"; Boolean)
        {
            Caption = 'Show Company Contracts';
            Description = '02-12-19 ZY-LD 004';
        }
        field(50068; "Block Change of Line Discount"; Boolean)
        {
            Caption = 'Block Change of Line Discount';
        }
        field(50069; "Employee ID"; Code[10])
        {
            Caption = 'Employee ID';
        }
        field(50071; "Allow Force Validation"; Boolean)
        {
            Caption = 'Allow Force Validation'; //05-05-2025 BK #485255
        }
    }
}
