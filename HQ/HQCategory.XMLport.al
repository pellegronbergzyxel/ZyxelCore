XmlPort 50001 "HQ Category"
{
    // 001. 13-01-19 ZY-LD 000 - Created. Update categories from ZCom HQ into ZNet EMEA.

    Caption = 'HQ Category';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/category';
    Direction = Import;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                UseTemporary = true;
                fieldelement(No; Item."No.")
                {
                }
                fieldelement(Category1Code; Item."Category 1 Code")
                {
                }
                fieldelement(Category2Code; Item."Category 2 Code")
                {
                }
                fieldelement(Category3Code; Item."Category 3 Code")
                {
                }
                fieldelement(BusinessCenter; Item."Business Center")
                {
                }
                fieldelement(SBU; Item.SBU)
                {
                }
                textelement(SbuCompany)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    //>> 18-10-19 ZY-LD 002
                    case UpperCase(SbuCompany) of
                        'ZCOM':
                            Item."SBU Company" := Item."sbu company"::"ZCom HQ";
                        'ZNET':
                            Item."SBU Company" := Item."sbu company"::"ZNet HQ";
                    end;
                    //<< 18-10-19 ZY-LD 002
                end;
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


    procedure GetData(var pItem: Record Item temporary; var pHqDimension: Record SBU temporary)
    begin
        if Item.FindSet then
            repeat
                pItem := Item;
                pItem.Insert;

                if (Item."Category 1 Code" <> '') and
                   not pHqDimension.Get(pHqDimension.Type::"Category 1", Item."Category 1 Code")
                then begin
                    pHqDimension.Type := pHqDimension.Type::"Category 1";
                    pHqDimension.Code := Item."Category 1 Code";
                    pHqDimension.Description := Item."Category 1 Code";
                    pHqDimension.Insert;
                end;
                if (Item."Category 2 Code" <> '') and
                   not pHqDimension.Get(pHqDimension.Type::"Category 2", Item."Category 2 Code")
                then begin
                    pHqDimension.Type := pHqDimension.Type::"Category 2";
                    pHqDimension.Code := Item."Category 2 Code";
                    pHqDimension.Description := Item."Category 2 Code";
                    pHqDimension.Insert;
                end;
                if (Item."Category 3 Code" <> '') and
                   not pHqDimension.Get(pHqDimension.Type::"Category 3", Item."Category 3 Code")
                then begin
                    pHqDimension.Type := pHqDimension.Type::"Category 3";
                    pHqDimension.Code := Item."Category 3 Code";
                    pHqDimension.Description := Item."Category 3 Code";
                    pHqDimension.Insert;
                end;
                if (Item."Business Center" <> '') and
                   not pHqDimension.Get(pHqDimension.Type::"Business Center", Item."Business Center")
                then begin
                    pHqDimension.Type := pHqDimension.Type::"Business Center";
                    pHqDimension.Code := Item."Business Center";
                    pHqDimension.Description := Item."Business Center";
                    pHqDimension.Insert;
                end;
                if (Item.SBU <> '') and
                   not pHqDimension.Get(pHqDimension.Type::SBU, Item.SBU)
                then begin
                    pHqDimension.Type := pHqDimension.Type::SBU;
                    pHqDimension.Code := Item.SBU;
                    pHqDimension.Description := Item.SBU;
                    pHqDimension.Insert;
                end;
            until Item.Next() = 0;
    end;
}
