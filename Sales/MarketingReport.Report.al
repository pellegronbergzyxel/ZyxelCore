Report 50088 "Marketing Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Marketing Report.rdlc';
    Caption = 'Marketing Report';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
            column(Posting_Date; qryEMEAMarketing.Posting_Date)
            {
            }
            column(Document_Type; qryEMEAMarketing.Document_Type)
            {
            }
            column(Document_No; qryEMEAMarketing.Document_No)
            {
            }
            column(Description; qryEMEAMarketing.Description)
            {
            }
            column(Source_No; qryEMEAMarketing.Source_No)
            {
            }
            column(Name; qryEMEAMarketing.Name)
            {
            }
            column(Amount; qryEMEAMarketing.Amount)
            {
            }
            column(Country; qryEMEAMarketing.Country)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not qryEMEAMarketing.Read then
                    CurrReport.Break();
            end;

            trigger OnPostDataItem()
            begin
                qryEMEAMarketing.Close;
            end;

            trigger OnPreDataItem()
            begin
                qryEMEAMarketing.SetRange(Posting_Date, StartDate, EndDate);
                qryEMEAMarketing.SetRange(Global_Dimension_1_Code_Filter, GlobalDim1Code);
                qryEMEAMarketing.SetFilter(GL_Account_No_Filter, GlAccountNoFilter);
                qryEMEAMarketing.Open;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';
                    }
                    field(GlobalDim1Code; GlobalDim1Code)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Division Code';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Vendor_No = 'Vendor No.';
        Vendor_Name = 'Vendor Name';
    }

    var
        qryEMEAMarketing: Query "EMEA Marketing";
        StartDate: Date;
        EndDate: Date;
        GlobalDim1Code: Code[20];
        GlAccountNoFilter: Code[250];


    procedure InitReport(NewStartDate: Date; NewEndDate: Date; NewGlobalDim1Code: Code[20]; NewGlAccountNoFilter: Code[250])
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        GlobalDim1Code := NewGlobalDim1Code;
        GlAccountNoFilter := NewGlAccountNoFilter;
    end;
}
