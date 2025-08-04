page 50141 "Amazon Po Input"
{
    Caption = 'Amazon Doc Input';
    PageType = List;
    SourceTable = "Amazon Setup";
    RefreshOnActivate = true;
    Editable = true;


    layout
    {



        area(content)
        {
            group(General)
            {
                Caption = 'General';
                //  CueGroupLayout = Wide;
                ShowCaption = false;
                //Visible = true;

                field(amazDocno; amazDocno)
                {
                    caption = 'Enter amazon PO to get and close window';
                    ApplicationArea = all;
                    Editable = true;

                }


            }
        }
    }

    actions
    {
        area(processing)
        {


        }
    }

    var
        amazDocno: code[20];



    trigger OnOpenPage()
    var

    begin


    end;

    procedure getvalue(): code[20]
    begin
        exit(amazDocno);
    end;


}
