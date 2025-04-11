pageextension 50121 AssemblyBOMZX extends "Assembly BOM"
{
    layout
    {
        addafter(Control9)
        {
            part(Control20; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
            part("Item Picture FactBox"; "Item Picture FactBox")
            {
                Caption = 'Item Picture';
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
        }
    }
}
