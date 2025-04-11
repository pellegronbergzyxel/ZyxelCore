table 50075 "Server Environment"
{
    Caption = 'Server Environment';
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Environment; Option)
        {
            Caption = 'Environment';
            OptionCaption = ' ,Development,Test,Production';
            OptionMembers = " ",Development,Test,Production;
        }
        field(3; Server; Option)
        {
            OptionMembers = " ",Main,Italian,Turkish;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure DevelopmentEnvironment(): Boolean
    begin
        if FindFirst() then
            exit(Environment = Environment::Development)
        else
            exit(false);
    end;

    procedure TestEnvironment(): Boolean
    begin
        if FindFirst() then
            exit(Environment = Environment::Test)
        else
            exit(true);
    end;

    procedure ProductionEnvironment(): Boolean
    begin
        if FindFirst() then
            exit(Environment = Environment::Production)
        else
            exit(false);
    end;

    procedure MainServer(): Boolean
    begin
        if FindFirst() then
            exit(Server = Server::Main)
        else
            exit(false);
    end;

    procedure ItalianServer(): Boolean
    begin
        if FindFirst() then
            exit(Server = Server::Italian)
        else
            exit(false);
    end;

    procedure TurkishServer(): Boolean
    begin
        if FindFirst() then
            exit(Server = Server::Turkish)
        else
            exit(false);
    end;
}
