dotnet
{
    assembly("System")
    {

        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        Version = '4.0.0.0';

        type("System.Net.WebClient"; "WebClient") { }
        type("System.Net.ServicePointManager"; "ServicePointManager") { }
        type("System.Net.SecurityProtocolType"; "SecurityProtocolType") { }
        type("System.Net.WriteStreamClosedEventArgs"; "WriteStreamClosedEventArgs") { }
        type("System.Net.OpenReadCompletedEventArgs"; "OpenReadCompletedEventArgs") { }
        type("System.Net.OpenWriteCompletedEventArgs"; "OpenWriteCompletedEventArgs") { }
        type("System.Net.DownloadStringCompletedEventArgs"; "DownloadStringCompletedEventArgs") { }
        type("System.Net.DownloadDataCompletedEventArgs"; "DownloadDataCompletedEventArgs") { }
        type("System.ComponentModel.AsyncCompletedEventArgs"; "AsyncCompletedEventArgs") { }
        type("System.Net.UploadStringCompletedEventArgs"; "UploadStringCompletedEventArgs") { }
        type("System.Net.UploadDataCompletedEventArgs"; "UploadDataCompletedEventArgs") { }
        type("System.Net.UploadFileCompletedEventArgs"; "UploadFileCompletedEventArgs") { }
        type("System.Net.UploadValuesCompletedEventArgs"; "UploadValuesCompletedEventArgs") { }
        type("System.Net.DownloadProgressChangedEventArgs"; "DownloadProgressChangedEventArgs") { }
        type("System.Net.UploadProgressChangedEventArgs"; "UploadProgressChangedEventArgs") { }
    }
    assembly("System.Xml")
    {

        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        Version = '4.0.0.0';

        type("System.Xml.XmlDocument"; "XmlDocument") { }
        type("System.Xml.XmlNamespaceManager"; "XmlNamespaceManager") { }
        type("System.Xml.XmlNodeList"; "XmlNodeList") { }
        type("System.Xml.XmlNode"; "XmlNode") { }
    }
    assembly("System.IO.Compression.FileSystem")
    {

        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        Version = '4.0.0.0';

        type("System.IO.Compression.ZipFile"; "ZipFile") { }
        type("System.IO.Compression.ZipFileExtensions"; "Zip") { }
    }
    assembly("VisionPeople.Net.Ftp")
    {

        Culture = 'neutral';
        PublicKeyToken = '412850cb332a1da5';
        Version = '1.0.0.0';

        type("VisionPeople.Net.Ftp.ComFtpClient"; "ComFtpClient") { }
    }
    assembly("VisionPeople.Net.FtpSecure")
    {

        Culture = 'neutral';
        PublicKeyToken = '412850cb332a1da5';
        Version = '1.0.0.0';

        type("VisionPeople.Net.Ftp.ComFtpSecure"; "ComFtpSecure") { }
    }
    assembly("Microsoft.VisualBasic")
    {

        Culture = 'neutral';
        PublicKeyToken = 'b03f5f7f11d50a3a';
        Version = '10.0.0.0';

        type("Microsoft.VisualBasic.Interaction"; "Interaction") { }
    }
}
