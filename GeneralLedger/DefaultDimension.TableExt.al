tableextension 50165 DefaultDimensionZX extends "Default Dimension"
{
    fields
    {
        modify("Table ID")
        {
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(50000; "Force Update in Subsidary"; Boolean)
        {
            Caption = 'Force Update in Subsidary';
            Description = '18-09-18 ZY-LD 001';
        }
        field(50001; "Mandatory Concur Dimension"; Code[10])
        {
            Caption = 'Mandatory Concur Dimension';
            Description = '27-10-20 ZY-LD 002';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"));
        }
    }
}
