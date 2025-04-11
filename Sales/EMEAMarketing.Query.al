Query 50006 "EMEA Marketing"
{
    Caption = 'EMEA Marketing';

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            DataItemTableFilter = "Document Type" = const(Invoice), "Source Type" = const(Vendor);
            filter(Postiing_Date_Filter; "Posting Date")
            {
            }
            filter(Global_Dimension_1_Code_Filter; "Global Dimension 1 Code")
            {
            }
            filter(GL_Account_No_Filter; "G/L Account No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Source_No; "Source No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Country; Country)
            {
            }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = G_L_Entry."Source No.";
                SqlJoinType = LeftOuterJoin;
                column(Name; Name)
                {
                }
            }
        }
    }
}
