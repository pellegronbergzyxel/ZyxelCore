pageextension 50182 TerritoriesZX extends Territories
{
    actions
    {
        addfirst(navigation)
        {
            action("Territory Countries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Territory Countries';
                Description = 'Territory Countries';
                Image = ItemAvailbyLoc;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Forecast Territory Countries";
                RunPageLink = "Territory Code" = field(Code);
            }
        }
    }
}
