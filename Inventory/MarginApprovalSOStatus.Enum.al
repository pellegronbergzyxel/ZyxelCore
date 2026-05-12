namespace ZyxelCore.ZyxelCore;

enum 50007 MarginApprovalSOStatus
{
    Extensible = true;
    
    value(0; Inactive)
    {
        Caption = 'Inactive';
    }
    value(1; WaitingRequest)
    {
        Caption = 'WaitingRequest';
    }
    value(2; WaitingApproval)
    {
        Caption = 'WaitingApproval';
    }
    value(3; Approved)
    {
        Caption = 'Approved';
    }
    value(4; Rejected)
    {
        Caption = 'Rejected';
    }
}
