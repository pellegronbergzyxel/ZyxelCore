Codeunit 76125 "Language Conversion Tools"
{

    trigger OnRun()
    begin
    end;


    procedure Dos2WinCzech(lteInput: Text[1024]) lteOutput: Text[1024]
    var
        lchChar: Char;
        linI: Integer;
    begin
        lteOutput := '';
        for linI := 1 to StrLen(lteInput) do begin
            case lteInput[linI] of
                'á':
                    lchChar := 225;
                'ƒ':
                    lchChar := 232;
                'È':
                    lchChar := 239;
                'é':
                    lchChar := 233;
                'Ï':
                    lchChar := 236;
                'í':
                    lchChar := 237;
                'Õ':
                    lchChar := 242;
                'ó':
                    lchChar := 243;
                '²':
                    lchChar := 248;
                'þ':
                    lchChar := 154;
                '£':
                    lchChar := 157;
                'ú':
                    lchChar := 250;
                'à':
                    lchChar := 249;
                'ý':
                    lchChar := 253;
                'º':
                    lchChar := 158;
                'Á':
                    lchChar := 193;
                '¼':
                    lchChar := 200;
                'Ê':
                    lchChar := 207;
                'É':
                    lchChar := 201;
                'À':
                    lchChar := 204;
                'Í':
                    lchChar := 205;
                'ı':
                    lchChar := 210;
                'Ó':
                    lchChar := 211;
                '³':
                    lchChar := 216;
                'µ':
                    lchChar := 138;
                'ø':
                    lchChar := 141;
                'Ú':
                    lchChar := 218;
                'Ì':
                    lchChar := 217;
                'Ý':
                    lchChar := 221;
                'ª':
                    lchChar := 142;

                'ä':
                    lchChar := 228;
                'ë':
                    lchChar := 235;
                'ô':
                    lchChar := 244;
                'ö':
                    lchChar := 246;
                'ü':
                    lchChar := 252;
                'Ä':
                    lchChar := 196;
                'Ë':
                    lchChar := 203;
                'Ô':
                    lchChar := 212;
                'Ö':
                    lchChar := 214;
                'Ü':
                    lchChar := 220;
                'û':
                    lchChar := 190;
                'Æ':
                    lchChar := 229;
                'ò':
                    lchChar := 188;
                'æ':
                    lchChar := 197;

                else
                    lchChar := lteInput[linI];
            end;
            lteOutput += Format(lchChar);
        end;
    end;


    procedure Win2DosCzech(lteInput: Text[1024]) lteOutput: Text[1024]
    var
        linI: Integer;
        lchChar: Char;
    begin
        lteOutput := '';
        for linI := 1 to StrLen(lteInput) do begin
            case lteInput[linI] of
                225:
                    lchChar := 'á';
                232:
                    lchChar := 'ƒ';
                239:
                    lchChar := 'È';
                233:
                    lchChar := 'é';
                236:
                    lchChar := 'Ï';
                237:
                    lchChar := 'í';
                242:
                    lchChar := 'Õ';
                243:
                    lchChar := 'ó';
                248:
                    lchChar := '²';
                154:
                    lchChar := 'þ';
                157:
                    lchChar := '£';
                250:
                    lchChar := 'ú';
                249:
                    lchChar := 'à';
                253:
                    lchChar := 'ý';
                158:
                    lchChar := 'º';
                193:
                    lchChar := 'Á';
                200:
                    lchChar := '¼';
                207:
                    lchChar := 'Ê';
                201:
                    lchChar := 'É';
                204:
                    lchChar := 'À';
                205:
                    lchChar := 'Í';
                210:
                    lchChar := 'ı';
                211:
                    lchChar := 'Ó';
                216:
                    lchChar := '³';
                138:
                    lchChar := 'µ';
                141:
                    lchChar := 'ø';
                218:
                    lchChar := 'Ú';
                217:
                    lchChar := 'Ì';
                221:
                    lchChar := 'Ý';
                142:
                    lchChar := 'ª';
                else
                    lchChar := lteInput[linI];
            end;
            lteOutput += Format(lchChar);
        end;
    end;


    procedure RemoveCzechDiacritic(lteText: Text[1024]) lteRet: Text[1024]
    begin
        lteRet := ConvertStr(lteText, 'áƒÈéÏíÕó²þ£úàýºÁ¼ÊÉÀÍıÓ³µøÚÌÝª',
                                     'acdeeinorstuuyzACDEEINORSTUUYZ');
    end;


    procedure ConvertTextFromIE(lteText: Text[1024]) lteRet: Text[1024]
    var
        linPosition: Integer;
        lchChar: Char;
    begin
        SwapText(lteText, '%C3%A1', 'á');
        SwapText(lteText, '%C4%8D', 'ƒ');
        SwapText(lteText, '%C4%8F', 'È');
        SwapText(lteText, '%C3%A9', 'é');
        SwapText(lteText, '%C4%9B', 'Ï');
        SwapText(lteText, '%C3%AD', 'í');
        SwapText(lteText, '%C5%88', 'Õ');
        SwapText(lteText, '%C3%B3', 'ó');
        SwapText(lteText, '%C5%99', '²');
        SwapText(lteText, '%C5%A1', 'þ');
        SwapText(lteText, '%C5%A5', '£');
        SwapText(lteText, '%C3%BA', 'ú');
        SwapText(lteText, '%C5%AF', 'à');
        SwapText(lteText, '%C3%BD', 'ý');
        SwapText(lteText, '%C5%BE', 'º');
        SwapText(lteText, '%C3%81', 'Á');
        SwapText(lteText, '%C4%8C', '¼');
        SwapText(lteText, '%C4%8E', 'Ê');
        SwapText(lteText, '%C3%89', 'É');
        SwapText(lteText, '%C4%9A', 'À');
        SwapText(lteText, '%C3%8D', 'Í');
        SwapText(lteText, '%C5%87', 'ı');
        SwapText(lteText, '%C3%93', 'Ó');
        SwapText(lteText, '%C5%98', '³');
        SwapText(lteText, '%C5%A0', 'µ');
        SwapText(lteText, '%C5%A4', 'ø');
        SwapText(lteText, '%C3%9A', 'Ú');
        SwapText(lteText, '%C5%AE', 'Ì');
        SwapText(lteText, '%C3%9D', 'Ý');
        SwapText(lteText, '%C5%BD', 'ª');
        SwapText(lteText, '%20', ' ');
        SwapText(lteText, '%2B', '+');
        lteRet := lteText;
    end;


    procedure ConvertTextToIE(lteText: Text[1024]) lteRet: Text[1024]
    var
        linPosition: Integer;
        lchChar: Char;
    begin
        SwapText(lteText, 'á', '%C3%A1');
        SwapText(lteText, 'ƒ', '%C4%8D');
        SwapText(lteText, 'È', '%C4%8F');
        SwapText(lteText, 'é', '%C3%A9');
        SwapText(lteText, 'Ï', '%C4%9B');
        SwapText(lteText, 'í', '%C3%AD');
        SwapText(lteText, 'Õ', '%C5%88');
        SwapText(lteText, 'ó', '%C3%B3');
        SwapText(lteText, '²', '%C5%99');
        SwapText(lteText, 'þ', '%C5%A1');
        SwapText(lteText, '£', '%C5%A5');
        SwapText(lteText, 'ú', '%C3%BA');
        SwapText(lteText, 'à', '%C5%AF');
        SwapText(lteText, 'ý', '%C3%BD');
        SwapText(lteText, 'º', '%C5%BE');
        SwapText(lteText, 'Á', '%C3%81');
        SwapText(lteText, '¼', '%C4%8C');
        SwapText(lteText, 'Ê', '%C4%8E');
        SwapText(lteText, 'É', '%C3%89');
        SwapText(lteText, 'À', '%C4%9A');
        SwapText(lteText, 'Í', '%C3%8D');
        SwapText(lteText, 'ı', '%C5%87');
        SwapText(lteText, 'Ó', '%C3%93');
        SwapText(lteText, '³', '%C5%98');
        SwapText(lteText, 'µ', '%C5%A0');
        SwapText(lteText, 'ø', '%C5%A4');
        SwapText(lteText, 'Ú', '%C3%9A');
        SwapText(lteText, 'Ì', '%C5%AE');
        SwapText(lteText, 'Ý', '%C3%9D');
        SwapText(lteText, 'ª', '%C5%BD');
        SwapText(lteText, ' ', '%20');
        SwapText(lteText, '+', '%2B');
        lteRet := lteText;
    end;

    local procedure SwapText(var lteSource: Text[1024]; lteOld: Text[250]; lteNew: Text[250])
    var
        linPosition: Integer;
    begin
        linPosition := StrPos(lteSource, lteOld);
        while linPosition <> 0 do begin
            lteSource := CopyStr(lteSource, 1, linPosition - 1) + lteNew + CopyStr(lteSource, linPosition + StrLen(lteOld));
            linPosition := StrPos(lteSource, lteOld);
        end;
    end;


    procedure Dos2WinSlovak(lteInput: Text[1024]) lteOutput: Text[1024]
    var
        linI: Integer;
        lchChar: Char;
    begin
        lteOutput := '';
        for linI := 1 to StrLen(lteInput) do begin
            case lteInput[linI] of
                'á':
                    lchChar := 225;
                'ä':
                    lchChar := 228;
                'ƒ':
                    lchChar := 232;
                'È':
                    lchChar := 239;
                'é':
                    lchChar := 233;
                'Ï':
                    lchChar := 236;
                'í':
                    lchChar := 237;
                'Õ':
                    lchChar := 242;
                'ó':
                    lchChar := 243;
                'ô':
                    lchChar := 244;
                'ö':
                    lchChar := 246;
                '²':
                    lchChar := 248;
                'þ':
                    lchChar := 154;
                '£':
                    lchChar := 157;
                'ú':
                    lchChar := 250;
                'à':
                    lchChar := 249;
                'ü':
                    lchChar := 252;
                'ý':
                    lchChar := 253;
                'º':
                    lchChar := 158;
                'Á':
                    lchChar := 193;
                'Ä':
                    lchChar := 196;
                '¼':
                    lchChar := 200;
                'Ê':
                    lchChar := 207;
                'É':
                    lchChar := 201;
                'À':
                    lchChar := 204;
                'Í':
                    lchChar := 205;
                'ı':
                    lchChar := 210;
                'Ó':
                    lchChar := 211;
                'Ö':
                    lchChar := 214;
                '³':
                    lchChar := 216;
                'µ':
                    lchChar := 138;
                'ø':
                    lchChar := 141;
                'Ú':
                    lchChar := 218;
                'Ì':
                    lchChar := 217;
                'Ü':
                    lchChar := 220;
                'Ý':
                    lchChar := 221;
                'ª':
                    lchChar := 142;
                'û':
                    lchChar := 190;
                'Æ':
                    lchChar := 229;
                'ò':
                    lchChar := 188;
                'æ':
                    lchChar := 197;

                else
                    lchChar := lteInput[linI];
            end;
            lteOutput += Format(lchChar);
        end;
    end;


    procedure Win2DosSlovak(lteInput: Text[1024]) lteOutput: Text[1024]
    var
        linI: Integer;
        lchChar: Char;
    begin
        lteOutput := '';
        for linI := 1 to StrLen(lteInput) do begin
            case lteInput[linI] of
                225:
                    lchChar := 'á';
                228:
                    lchChar := 'ä';
                232:
                    lchChar := 'ƒ';
                239:
                    lchChar := 'È';
                233:
                    lchChar := 'é';
                236:
                    lchChar := 'Ï';
                237:
                    lchChar := 'í';
                242:
                    lchChar := 'Õ';
                243:
                    lchChar := 'ó';
                244:
                    lchChar := 'ô';
                246:
                    lchChar := 'ö';
                248:
                    lchChar := '²';
                154:
                    lchChar := 'þ';
                157:
                    lchChar := '£';
                250:
                    lchChar := 'ú';
                249:
                    lchChar := 'à';
                252:
                    lchChar := 'ü';
                253:
                    lchChar := 'ý';
                158:
                    lchChar := 'º';
                193:
                    lchChar := 'Á';
                196:
                    lchChar := 'Ä';
                200:
                    lchChar := '¼';
                207:
                    lchChar := 'Ê';
                201:
                    lchChar := 'É';
                204:
                    lchChar := 'À';
                205:
                    lchChar := 'Í';
                210:
                    lchChar := 'ı';
                211:
                    lchChar := 'Ó';
                214:
                    lchChar := 'Ö';
                216:
                    lchChar := '³';
                138:
                    lchChar := 'µ';
                141:
                    lchChar := 'ø';
                218:
                    lchChar := 'Ú';
                217:
                    lchChar := 'Ì';
                220:
                    lchChar := 'Ü';
                221:
                    lchChar := 'Ý';
                142:
                    lchChar := 'ª';
                190:
                    lchChar := 'û';
                229:
                    lchChar := 'Æ';
                188:
                    lchChar := 'ò';
                197:
                    lchChar := 'æ';
                else
                    lchChar := lteInput[linI];
            end;
            lteOutput += Format(lchChar);
        end;
    end;
}
