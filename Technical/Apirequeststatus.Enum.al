namespace ZyxelCore.ZyxelCore;

enum 50005 Apirequeststatus
{
    Extensible = true;
    
    value(0; new)
    {
        Caption = 'new';
    }
    value(1; send)
    {
        Caption = 'send';
    }
    value(2; received)
    {
        Caption = 'received';
    }
    value(3; updated)
    {
        Caption = 'updated';
    }
    value(4; closed)
    {
        Caption = 'closed';
    }
}
