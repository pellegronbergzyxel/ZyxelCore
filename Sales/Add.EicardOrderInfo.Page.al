Page 50263 "Add. Eicard Order Info"
{
    AutoSplitKey = true;
    Caption = 'Add. Eicard Order Info';
    PageType = List;
    SourceTable = "Add. Eicard Order Info";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("EMS Machine Code"; Rec."EMS Machine Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = EMSVisible;
                }
                field("GLC Serial No."; Rec."GLC Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = GLCVisible;
                }
                field("GLC Mac Address"; Rec."GLC Mac Address")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = GLCVisible;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }

    var
        EMSVisible: Boolean;
        GLCVisible: Boolean;


    procedure Init(pType: Option EMS,GLC)
    begin
        EMSVisible := pType = Ptype::EMS;
        GLCVisible := pType = Ptype::GLC;
    end;
}
