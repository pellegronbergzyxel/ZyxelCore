page 50224 "Company Contracts"
{
    Caption = 'Company Contracts';
    CardPageID = "Company Contract Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Customer Contract";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(SearchText; SearchText)
                {
                    ToolTip = 'Specify the Enter Search String';
                    ApplicationArea = Basic, Suite;
                    Caption = 'Enter Search String';

                    trigger OnValidate()
                    var
                        SearchStr: Code[10];
                    begin
                        TagSearch := ConvertStr(SearchText, ' ', '|');
                        TagSearch := ConvertStr(TagSearch, ',', '|');
                        TagSearch := ConvertStr(TagSearch, ';', '|');
                        TagSearch := ConvertStr(TagSearch, ':', '|');
                        TagSearch := ConvertStr(TagSearch, '.', '|');
                        SearchText := '*@' + SearchText + '*';

                        CustContractTmp.DeleteAll();
                        CustContract.Reset();
                        CustContract.SetFilter("Tag Filter", TagSearch);
                        if TagSearch <> '' then
                            CustContract.SetRange("Tag is Found", true)
                        else
                            CustContract.SetRange("Tag is Found");
                        if CustContract.FindSet() then
                            repeat
                                CustContractTmp := CustContract;
                                CustContractTmp.Insert();
                            until CustContract.Next() = 0;

                        CustContract.Reset();
                        CustContract.SetFilter(Comment, SearchText);
                        if CustContract.FindSet() then
                            repeat
                                CustContractTmp := CustContract;
                                if not CustContractTmp.Insert() then;
                            until CustContract.Next() = 0;

                        CustContract.Reset();
                        CustContract.SetFilter(Filename, SearchText);
                        if CustContract.FindSet() then
                            repeat
                                CustContractTmp := CustContract;
                                if not CustContractTmp.Insert() then;
                            until CustContract.Next() = 0;

                        Page.RunModal(Page::"Company Contracts", CustContractTmp);
                        SearchText := DelChr(SearchText, '=', '*@');
                    end;
                }
            }
            repeater(Group)
            {
                Editable = false;
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specify the Status';
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specify the Customer No';
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specify the Customer Name';
                    ApplicationArea = Basic, Suite;
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ToolTip = 'Specify the Contact Person';
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Country Code"; Rec."Customer Country Code")
                {
                    ToolTip = 'Specify the Customer Country Code';
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specify the Document No';
                    ApplicationArea = Basic, Suite;
                }
                field(Filename; Rec.Filename)
                {
                    ToolTip = 'Specify the Filename';
                    ApplicationArea = Basic, Suite;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specify the Comment';
                    ApplicationArea = Basic, Suite;
                }
                field("Valid From"; Rec."Valid From")
                {
                    ToolTip = 'Specify the Valid From';
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Valid To"; Rec."Valid To")
                {
                    ToolTip = 'Specify the Valid To';
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control12; "Company Contract Tag FactBox")
            {
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Export)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;

                trigger OnAction()
                begin
                    Rec.ShowFile;
                end;
            }
            action("Upload Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Upload Document';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.CalcFields(Rec."Customer Name");
                    Rec.UploadFile(Rec."Customer No.", Rec."Customer Name");
                end;
            }
            action("Download Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download Document';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.downloadcontractFile();
                end;
            }
        }
    }

    var
        CustContract: Record "Customer Contract";
        CustContractTmp: Record "Customer Contract" temporary;
        Tags: Text;
        TagSearch: Code[250];
        SearchText: Code[250];
}
