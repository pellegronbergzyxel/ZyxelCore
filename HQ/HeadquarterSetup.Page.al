Page 76152 "Headquarter Setup"
{
    PageType = Card;
    SourceTable = "Headquarter Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                group("Dynamics NAV")
                {
                    Caption = 'Dynamics NAV';
                    field("NAV Server Name"; Rec."NAV Server Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'NAV Server Name';
                    }
                    field("NAV Database Name"; Rec."NAV Database Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'NAV Database Name';
                    }
                    field("NAV User Name"; Rec."NAV User Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'NAV User Name';
                    }
                    field("NAV Password"; Rec."NAV Password")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'NAV Password';
                        ExtendedDatatype = Masked;
                    }
                    field("NAV Company Name"; Rec."NAV Company Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'NAV Company Name';
                    }
                }
                group(Archive)
                {
                    Caption = 'Archive';
                    field("Archive Folder"; Rec."Archive Folder")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Folder';
                    }
                }
                group(Exchange)
                {
                    Caption = 'Exchange';
                    field("Exchange Account"; Rec."Exchange Account")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exchange Account';
                    }
                    field("Exchange Account Password"; Rec."Exchange Account Password")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exchange Account Password';
                        ExtendedDatatype = Masked;
                    }
                }
                group(EiCards)
                {
                    Caption = 'EiCards';
                    field("EiCard Archive Folder"; Rec."EiCard Archive Folder")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Folder';
                    }
                }
                group("Let Me Repair")
                {
                    Caption = 'Let Me Repair';
                    field("LMR Exchange Account"; Rec."LMR Exchange Account")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exchange Account';
                    }
                    field("LMR Exchange Password"; Rec."LMR Exchange Password")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exchange Password';
                        ExtendedDatatype = Masked;
                    }
                    field("LMR Archive Folder"; Rec."LMR Archive Folder")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Folder';
                    }
                    field("LMR Company Name"; Rec."LMR Company Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Company Name';
                    }
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                field("SBU Filter Channel"; Rec."SBU Filter Channel")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SBU Filter Service Provider"; Rec."SBU Filter Service Provider")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
