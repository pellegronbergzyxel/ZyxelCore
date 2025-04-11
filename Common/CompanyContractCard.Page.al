page 50226 "Company Contract Card"
{
    Caption = 'Company Contract Card';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Customer Contract";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Document No." = '' then begin
                            CustContrSetup.Get();
                            CustContrSetup.TestField("Serial No.");
                            Rec."Document No." := NoSeriesMgt.GetNextNo(CustContrSetup."Serial No.", Today, true);
                        end;
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        Rec.CalcFields(Rec."Customer Name");
                        Rec.UploadFile(Rec."Customer No.", Rec."Customer Name");
                    end;
                }
                group(Control11)
                {
                    field(Comment; Rec.Comment)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Control10)
                {
                    field("Valid From"; Rec."Valid From")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Valid To"; Rec."Valid To")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control13; "Company Contract Tag FactBox")
            {
                SubPageLink = "Document No." = field("Document No.");
            }
            part(Control14; "Contact Tags FactBox")
            {
                SubPageLink = "Document No. Filter" = field("Document No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
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
                    FileMgt.DownloadHandler(Rec.GetFilename, Text001, '', 'PDF(*.pdf)|*.pdf|All files(*.*)|*.*', FileMgt.GetFileName(Rec."Folder and Filename"));
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."Document No." = '' then begin
            CustContrSetup.Get();
            CustContrSetup.TestField("Serial No.");
            Rec."Document No." := NoSeriesMgt.GetNextNo(CustContrSetup."Serial No.", Today, true);
        end;

        if Rec."Customer No." = '' then
            Rec.Validate(Rec."Customer No.", Rec.GetFilter(Rec."Customer No."));
    end;

    trigger OnOpenPage()
    begin
        SI.SetDocumentNo(Rec."Document No.");
    end;

    var
        Tags: Text;
        Tag: Text[20];
        SI: Codeunit "Single Instance";
        CustContrSetup: Record "Customer Contract Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FileMgt: Codeunit "File Management";
        Text001: Label 'Download Document';
}
