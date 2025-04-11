/*pageextension 50178 IntrastatReportZX extends "Intrastat Report"
{
    // actions
    // {
    //     addfirst(navigation)
    //     {
    //         group(Setup)
    //         {
    //             Caption = 'Setup';
    //         }
    //         action("Country/Region")
    //         {
    //             ApplicationArea = Basic, Suite;
    //             Caption = 'Country/Region';
    //             Image = Setup;
    //             RunObject = Page "Intrastat Setup - Country";
    //         }
    //         action(Location)
    //         {
    //             ApplicationArea = Basic, Suite;
    //             Caption = 'Location';
    //             Image = Setup;
    //             RunObject = Page "Intrastat Setup - Location";
    //         }
    //         action(Customer)
    //         {
    //             ApplicationArea = Basic, Suite;
    //             Caption = 'Customer';
    //             Image = Setup;
    //             RunObject = Page "Intrastat Setup - Customer";
    //         }
    //     }
    //     addfirst(processing)
    //     {
    //         action(Suggest)
    //         {
    //             ApplicationArea = Basic, Suite;
    //             Caption = 'Suggest Lines Zyxel';

    //             trigger OnAction()
    //             var
    //                 IntrastatReportGetLines: Report "Intrastat Report Get Lines ZX";
    //             begin
    //                 IntrastatReportGetLines.SetIntrastatReportHeader(Rec);
    //                 IntrastatReportGetLines.RunModal();
    //             end;

    //         }
    //     }
    // }
}
*/