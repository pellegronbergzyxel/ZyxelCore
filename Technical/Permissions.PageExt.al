// TODO: Not sure what to do...?
PageExtension 50314 PermissionsZX extends "Expanded Permissions"
{
    actions
    {
        addfirst(navigation)
        {
            action("All Permissions")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'All Permissions';
                Image = Permission;
                RunObject = Page "All Permissions";
            }
        }
    }


    //Unsupported feature: Code Modification on "AddCodeCoveragePermissions(PROCEDURE 2)".

    //procedure AddCodeCoveragePermissions();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CodeCoverage.SETRANGE("Object Type",CodeCoverage."Object Type"::Table);
    CodeCoverage.SETRANGE("Line Type",CodeCoverage."Line Type"::Object);
    IF CodeCoverage.FINDSET THEN
      REPEAT
        AddTableDataPermission(CurrentRoleID,"Object Type"::"Table Data",CodeCoverage."Object ID",FALSE,FALSE,FALSE);
      UNTIL CodeCoverage.Next() = 0;
    CodeCoverage.RESET;
    CodeCoverage.DELETEALL;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //CodeCoverage.SETRANGE("Object Type",CodeCoverage."Object Type"::Table);  // 26-09-17 ZY-LD 001
    #2..4
        //>> 26-09-17 ZY-LD 001
        AddTableDataPermission(CurrentRoleID,CodeCoverage."Object Type",CodeCoverage."Object ID",FALSE,FALSE,FALSE);
        IF CodeCoverage."Object Type" = CodeCoverage."Object Type"::Table THEN  //<< 26-09-17 ZY-LD 001
          AddTableDataPermission(CurrentRoleID,"Object Type"::"Table Data",CodeCoverage."Object ID",FALSE,FALSE,FALSE);
    #6..8
    */
    //end;


    //Unsupported feature: Code Modification on "AddTableDataPermission(PROCEDURE 12)".

    //procedure AddTableDataPermission();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT GET(RoleID,ObjectType,ObjectID) THEN BEGIN
      INIT;
      "Role ID" := RoleID;
    #4..10
      Permission.TRANSFERFIELDS(Rec,TRUE);
      Permission.INSERT;
    END;
    "Read Permission" := "Read Permission"::Yes;
    IF AddInsert THEN
      "Insert Permission" := "Insert Permission"::Yes;
    IF AddModify THEN
      "Modify Permission" := "Modify Permission"::Yes;
    IF AddDelete THEN
      "Delete Permission" := "Delete Permission"::Yes;
    SetObjectZeroName(Rec);
    MODIFY;
    Permission.LOCKTABLE;
    IF NOT Permission.GET(RoleID,ObjectType,ObjectID) THEN BEGIN
    #25..28
      Permission.MODIFY;
    END;
    EXIT(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..13
    //>> 26-05-17 ZY-LD 001
    CASE "Object Type" OF
      "Object Type"::"Table Data" :
        BEGIN  //<< 26-05-17 ZY-LD 001
          "Read Permission" := "Read Permission"::Yes;
          IF AddInsert THEN
            "Insert Permission" := "Insert Permission"::Yes;
          IF AddModify THEN
            "Modify Permission" := "Modify Permission"::Yes;
          IF AddDelete THEN
            "Delete Permission" := "Delete Permission"::Yes;
          SetObjectZeroName(Rec);
        END;
      //>> 26-05-17 ZY-LD 001
      //"Object Type"::Table,  // We don't want all tables, we set them manualy
      "Object Type"::Codeunit,
      "Object Type"::Report,
      "Object Type"::Page,
      "Object Type"::XMLport,
      "Object Type"::Query :
        BEGIN
          "Read Permission" := "Read Permission"::" ";
          "Execute Permission" := "Execute Permission"::Yes
        END;
    END;  //<< 26-05-17 ZY-LD 001

    #22..31
    */
    //end;
}
