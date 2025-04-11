table 50114 "eCommerce Payment Matrix"
{
    Caption = 'eCommerce Payment Matrix';

    fields
    {
        field(1; "Payment Detail"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'Commission,Cost of Advertising,FBA fulfilment fee per unit,FBA Return Fee,FBA storage fee,Label fee,Previous Reserve Amount Balance,Product Tax,Refund commission,Shipping,Shipping chargeback,Shipping tax,Other,Current Reserve Amount,Blank,Subscription,Failed disbursement,Taping Fee,Tax,Lightning Deal Fee,Other concession,FBA Disposal Fee,Unplanned Service Fee - Barcode label missing,FBA Long-Term Storage Fee,Shipping holdback,FBA transportation fee,Non-subscription Fee Adjustment,Manual Processing Fee,Variable closing fee,Inbound Transportation Fee,Inbound Transportation Program Fee,Gift wrap chargeback,Gift wrap tax,Gift rap,Total Inbound Transportation Fees,Vine enrolment fee';
            OptionMembers = Commission,"Cost of Advertising","FBA fulfilment fee per unit","FBA Return Fee","FBA storage fee","Label fee","Previous Reserve Amount Balance","Product Tax","Refund commission",Shipping,"Shipping chargeback","Shipping tax",Other,"Current Reserve Amount",Blank,Subscription,"Failed disbursement","Taping Fee",Tax,"Lightning Deal Fee","Other concession","FBA Disposal Fee","Unplanned Service Fee - Barcode label missing","FBA Long-Term Storage Fee","Shipping holdback","FBA transportation fee","Non-subscription Fee Adjustment","Manual Processing Fee","Variable closing fee","Inbound Transportation Fee","Inbound Transportation Program Fee","Gift wrap chargeback","Gift wrap tax","Gift rap","Total Inbound Transportation Fees","Vine enrolment fee";
        }
        field(2; "Payment Type"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = ',eCommerce fees,Other,Product charges,Promo rebates,Transaction Details,Blank,FBA Inventory Reimbursement - Damaged:Warehouse,FBA Inventory Reimbursement - Lost:Inbound,FBA Inventory Reimbursement - Fee Correction,FBA Inventory Reimbursement - Customer Return,FBA Inventory Reimbursement - Lost:Warehouse,Order Fee,Payment Fee';
            OptionMembers = ,"eCommerce fees",Other,"Product charges","Promo rebates","Transaction Details",Blank,"FBA Inventory Reimbursement - Damaged:Warehouse","FBA Inventory Reimbursement - Lost:Inbound","FBA Inventory Reimbursement - Fee Correction","FBA Inventory Reimbursement - Customer Return","FBA Inventory Reimbursement - Lost:Warehouse","Order Fee","Payment Fee";
        }
        field(3; "Posting Type"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = ' ,Charge,Fee,None,Payment,Sale';
            OptionMembers = " ",Charge,Fee,"None",Payment,Sale;
        }
    }

    keys
    {
        key(Key1; "Payment Detail", "Payment Type")
        {
            Clustered = true;
        }
    }
}
