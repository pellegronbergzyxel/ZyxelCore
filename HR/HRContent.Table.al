Table 73010 "HR Content"
{
    // 001. 13-04-18 ZY-LD 2018040310000195 - Table relation added to Employee No.


    fields
    {
        field(1; UID; Integer)
        {
            AutoIncrement = true;
            Description = 'PAB 1.0';
        }
        field(2; Content; Blob)
        {
            Description = 'PAB 1.0';
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Description = 'PAB 1.0';
            TableRelation = "ZyXEL Employee";
        }
        field(4; "Created Date"; Date)
        {
            Caption = 'Created Date-Time';
            Description = 'PAB 1.0';
        }
        field(5; "Created By User Name"; Code[50])
        {
            Caption = 'Created By User Name';
            Description = 'PAB 1.0';
        }
        field(6; Name; Text[50])
        {
            Caption = 'Name';
            Description = 'PAB 1.0';
        }
        field(7; Extension; Text[30])
        {
            Caption = 'File Extension';
            Description = 'PAB 1.0';

            trigger OnValidate()
            var
                exttxt: Text[20];
            begin
                case Lowercase(Extension) of
                    'jpg', 'jpeg', 'bmp', 'png', 'tiff', 'tif', 'gif':
                        Type := Type::Image;
                    'pdf':
                        Type := Type::Pdf;
                    'docx', 'doc':
                        Type := Type::Word;
                    'xlsx', 'xls':
                        Type := Type::Excel;
                    'pptx', 'ppt':
                        Type := Type::PowerPoint;
                    'msg':
                        Type := Type::Email;
                    'xml':
                        Type := Type::Xml;
                    else
                        Type := Type::Other;
                end;
            end;
        }
        field(8; Type; Option)
        {
            Caption = 'Type';
            Description = 'PAB 1.0';
            OptionCaption = ' ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other';
            OptionMembers = " ",Image,PDF,Word,Excel,PowerPoint,Email,XML,Other;
        }
        field(9; TableID; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(10; RecordID; Text[30])
        {
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key1; UID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
