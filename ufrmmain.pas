unit ufrmmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, ExtDlgs, Spin, IniFiles;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnGenerateSerialNumber: TButton;
    btnGenerateUID: TButton;
    Button1: TButton;
    cbBold: TCheckBox;
    cbItalic: TCheckBox;
    cbFontName: TComboBox;
    gbIcon: TGroupBox;
    gbLanguages: TGroupBox;
    gbName: TGroupBox;
    gbSerialNumber: TGroupBox;
    gbStatusPrompt: TGroupBox;
    gbSymbol: TGroupBox;
    gbUID: TGroupBox;
    gbSTable: TGroupBox;
    gbValidChars: TGroupBox;
    GroupBox1: TGroupBox;
    gbFont: TGroupBox;
    imgIcon: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SaveDialog1: TSaveDialog;
    sgSTable: TStringGrid;
    sgOtherValues: TStringGrid;
    txtFontSize: TSpinEdit;
    txtLanguages: TEdit;
    txtName: TEdit;
    txtSerialNumber: TEdit;
    txtStatusPrompt: TEdit;
    txtSymbol: TEdit;
    txtUID: TEdit;
    txtValidChars: TMemo;
    procedure btnGenerateSerialNumberClick(Sender: TObject);
    procedure btnGenerateUIDClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbBoldChange(Sender: TObject);
    procedure cbFontNameChange(Sender: TObject);
    procedure cbItalicChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgIconClick(Sender: TObject);
    procedure sgOtherValuesEditingDone(Sender: TObject);
    procedure sgSTableEditingDone(Sender: TObject);
    procedure txtFontSizeChange(Sender: TObject);
    procedure txtLanguagesChange(Sender: TObject);
    procedure txtNameChange(Sender: TObject);
    procedure txtSerialNumberChange(Sender: TObject);
    procedure txtStatusPromptChange(Sender: TObject);
    procedure txtSymbolChange(Sender: TObject);
    procedure txtUIDChange(Sender: TObject);
    procedure txtValidCharsChange(Sender: TObject);
    procedure updategridfont;
    procedure savefont;
    procedure readconfig;
    procedure writeconfig;
  private

  public

  end;

var
  frmMain: TfrmMain;
  iconfilename:string;
  config:TINIFile;
  isreadingconfig:boolean;

implementation

{$R *.lfm}
function isNumeric(const potentialNumeric: string): boolean;
var
	potentialInteger: integer;
	potentialReal: real;
	integerError: integer;
	realError: integer;
begin
	integerError := 0;
	realError := 0;

	// system.val attempts to convert numerical value representations.
	// It accepts all notations as they are accepted by the language,
	// as well as the '0x' (or '0X') prefix for hexadecimal values.
	val(potentialNumeric, potentialInteger, integerError);
	val(potentialNumeric, potentialReal, realError);

	isNumeric := (integerError = 0) or (realError = 0);
end;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
screen.Cursor:=crHourGlass;
gbSTable.align:=alClient;
readconfig;
screen.cursor:=crDefault;
if (FileExists(iconfilename)) then begin
   OpenPictureDialog1.FileName:=iconfilename;
   imgIcon.Picture.LoadFromFile(iconfilename);
   end;
end;

procedure TfrmMain.imgIconClick(Sender: TObject);
begin
if (OpenPictureDialog1.Execute) then begin
  iconfilename:=OpenPictureDialog1.FileName;
  imgIcon.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  writeconfig;
  end;
end;

procedure TfrmMain.sgOtherValuesEditingDone(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.sgSTableEditingDone(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.txtFontSizeChange(Sender: TObject);
begin
updategridfont;
end;

procedure TfrmMain.txtLanguagesChange(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.txtNameChange(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.txtSerialNumberChange(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.txtStatusPromptChange(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.txtSymbolChange(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.txtUIDChange(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.txtValidCharsChange(Sender: TObject);
begin
writeconfig;
end;

procedure TfrmMain.updategridfont;
begin
if (not(isreadingconfig)) then begin
  if ((cbFontName.items.count>0)and(cbFontName.itemindex>-1)) then begin
     sgSTable.font.name:=cbFontName.items[cbFontName.itemindex];
     sgSTable.font.Size:=txtFontSize.Value;
     if (cbBold.checked) then begin
       sgSTable.font.Style:=sgSTable.font.Style + [fsBold];
       end else begin
       sgSTable.font.Style:=sgSTable.font.Style - [fsBold];
       end;
     if (cbItalic.checked) then begin
       sgSTable.font.Style:=sgSTable.font.Style + [fsItalic];
       end else begin
       sgSTable.font.Style:=sgSTable.font.Style - [fsItalic];
       end;
     end;
  savefont;
  end;
end;

procedure TfrmMain.savefont;
begin
if ((cbFontName.items.count>0)and(cbFontName.itemindex>-1)) then begin
   config.writestring('APP', 'GRIDFONTNAME', cbFontName.Items[cbFontName.ItemINDEX]);
   config.WriteInteger('APP', 'GRIDFONTSIZE', txtFontSize.Value);
   config.writeBool('APP', 'GRIDFONTBOLD', cbBold.Checked);
   config.writeBool('APP', 'GRIDFONTITALIC', cbItalic.Checked);
   end;
end;

procedure TfrmMain.readconfig;
var
        i:integer;
        fname:string;
        s:TStringList;

begin
isreadingconfig:=true;
config:=TINIFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'pangbkedit.dat');
SaveDialog1.InitialDir:=config.ReadString('APP', 'WORKINGDIR', IncludeTrailingPathDelimiter(GetUserDir) + 'keyboards');
if (DirectoryExists(SaveDialog1.InitialDir)) then begin
  SaveDialog1.InitialDir:=SaveDialog1.InitialDir;
  end;
cbFontName.items:=Screen.Fonts;
txtFontSize.Value:=config.ReadInteger('APP', 'GRIDFONTSIZE', 14);
cbBold.Checked:=config.ReadBool('APP', 'GRIDFONTBOLD', false);
cbItalic.Checked:=config.ReadBool('APP', 'GRIDFONTITALIC', false);
fName:=LowerCase(config.ReadString('APP', 'GRIDFONTNAME', sgSTable.Font.Name));
for i:=0 to cbFontName.items.count-1 do begin
    if (LowerCase(cbFontName.items[i])=fname) then begin
      cbFontName.ItemIndex:=i;
      end;
    end;
txtName.text:=config.readstring('DEFINITION', 'NAME', '');
txtUID.text:=config.readstring('DEFINITION', 'UUID', '');
txtSerialNumber.text:=config.readstring('DEFINITION', 'SERIAL_NUMBER', '');
txtSymbol.text:=config.readstring('DEFINITION', 'SYMBOL', '');
txtStatusPrompt.text:=config.readstring('DEFINITION', 'STATUS_PROMPT', '');
txtLanguages.text:=config.readstring('DEFINITION', 'LANGUAGES', '');
txtValidChars.text:=config.readstring('DEFINITION', 'VALID_INPUT_CHARS', '''"1!??2@??3#??4$??5%??6????7&8*9(0)-_=+??qQwWeE???rRtTyYuUiIoOpP`[{??aAsSdDfFgGhHjJkKlL????~^]}??\|zZxXcCvVbBnNmM,<.>;:/???');
iconfilename:=config.readstring('DEFINITION', 'ICON', '');
for i:=0 to sgOtherValues.RowCount-1 do begin
    sgOtherValues.Cells[1, i]:=config.readstring('DEFINITION', sgOtherValues.Cells[0, i], sgOtherValues.Cells[1, i]);
    end;
s:=TStringList.create;
config.ReadSection('TABLE', s);
sgSTable.RowCount:=1;
sgSTable.RowCount:=s.count+2;
if (s.count>0) then begin
   for i:=0 to s.count-1 do begin
       sgSTable.Cells[0, i+1]:=s[i];
       sgSTable.Cells[1, i+1]:=config.readstring('TABLE', s[i], '');;
       end;
   end;
isreadingconfig:=false;
updategridfont;
end;

procedure TfrmMain.writeconfig;
var
        i:integer;

begin
if (not(isreadingconfig)) then begin
  config.writestring('DEFINITION', 'NAME', txtName.text);
  config.writestring('DEFINITION', 'UUID', txtUID.text);
  config.writestring('DEFINITION', 'SERIAL_NUMBER', txtSerialNumber.text);
  config.writestring('DEFINITION', 'SYMBOL', txtSymbol.text);
  config.writestring('DEFINITION', 'STATUS_PROMPT', txtStatusPrompt.text);
  config.writestring('DEFINITION', 'LANGUAGES', txtLanguages.text);
  config.writestring('DEFINITION', 'VALID_INPUT_CHARS', txtValidChars.text);
  config.writestring('DEFINITION', 'ICON', iconfilename);
  for i:=0 to sgOtherValues.RowCount-1 do begin
      config.writestring('DEFINITION', sgOtherValues.Cells[0, i], sgOtherValues.Cells[1, i]);
      end;
  config.EraseSection('TABLE');
  for i:=1 to sgSTable.RowCount-1 do begin
      config.writestring('TABLE', sgSTable.Cells[0, i], sgSTable.Cells[1, i]);
      end;

  end;
end;

procedure TfrmMain.btnGenerateUIDClick(Sender: TObject);
var
  g:TGuid;
begin
CreateGUID(g);
txtUID.text:=StringReplace(StringReplace(GUIDToString(g), '}', '', []), '{', '', []);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  s:TStringList;
  r, rc:integer;
  char, subst:string;

begin
if (SaveDialog1.Execute) then begin
  config.writeString('APP', 'WORKINGDIR', SaveDialog1.InitialDir);
  s:=TStringList.create;
  s.add('### File header must not be modified');
  s.add('### This file must be encoded in UTF-8.');
  s.add('###');
  s.add('###');
  s.add('SCIM_Generic_Table_Phrase_Library_TEXT');
  s.add('VERSION_1_0');
  s.add('BEGIN_DEFINITION');
  s.add('UUID = ' + txtUID.text);
  s.add('SERIAL_NUMBER = ' + txtSerialNumber.text);
  s.add('ICON = ' + iconfilename);
  s.add('SYMBOL = ' + txtSymbol.text);
  s.add('STATUS_PROMPT = ' + txtStatusPrompt.text);
  s.add('NAME = ' + txtName.text);
  s.add('LANGUAGES = ' + txtLanguages.text);
  s.add('VALID_INPUT_CHARS ==' + txtValidChars.Text);
  for r:=0 to sgOtherValues.RowCount-1 do begin
      sgOtherValues.Cells[0, r]:=trim(sgOtherValues.Cells[0, r]);
      sgOtherValues.Cells[1, r]:=trim(sgOtherValues.Cells[1, r]);
      if ((sgOtherValues.Cells[0, r]<>'')and(sgOtherValues.Cells[1, r]<>'')) then begin
        s.add(sgOtherValues.Cells[0, r] + ' = ' + sgOtherValues.Cells[1, r]);
        end;
      end;
  {
    s.add('AUTHOR = oderalon <sld@oderalon.net>');
    s.add('PAGE_UP_KEYS = Page_Up');
    s.add('PAGE_DOWN_KEYS = Page_Down');
    s.add('SELECT_KEYS = F1,F2,F3,F4,F5,F6,F7,F8,F9');
    s.add('LICENSE = LGPL');
    s.add('MAX_KEY_LENGTH = 6');
    s.add('AUTO_COMMIT = TRUE');
    s.add('AUTO_SELECT = TRUE');
    s.add('DEF_FULL_WIDTH_PUNCT = FALSE');
    s.add('DEF_FULL_WIDTH_LETTER = FALSE');
    s.add('USER_CAN_DEFINE_PHRASE = FALSE');
    s.add('PINYIN_MODE = FALSE');
    s.add('DYNAMIC_ADJUST = TRUE');
    s.add('ORIENTATION=FALSE');
    s.add('LAYOUT = br_nodeadkeys');
    s.add('AUTO_WILDCARD = TRUE');
    s.add('SINGLE_WILDCARD_CHAR =');
    s.add('MULTI_WILDCARD_CHAR =');
    s.add('AUTO_SPLIT = TRUE');
    s.add('AUTO_FILL = FALSE');
    s.add('ALWAYS_SHOW_LOOKUP = TRUE');
    s.add('USE_FULL_WIDTH_PUNCT = FALSE');
    s.add('USE_FULL_WIDTH_LETTER = FALSE');
    s.add('COMMIT_KEYS = space,Return');
  }
  s.add('END_DEFINITION');
  s.add('');
  s.add('BEGIN_TABLE');
  for r:=1 to sgSTable.RowCount-1 do begin
      char:=trim(sgSTable.Cells[0, r]);
      subst:=trim(sgSTable.Cells[1, r]);
      if ((char<>'')and(subst<>'')) then begin
         s.add(char + '	' + subst + '	0');
         end;
      end;
  s.add('END_TABLE');
  s.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TfrmMain.cbBoldChange(Sender: TObject);
begin
updategridfont;
end;

procedure TfrmMain.cbFontNameChange(Sender: TObject);
begin
updategridfont;
end;

procedure TfrmMain.cbItalicChange(Sender: TObject);
begin
updategridfont;
end;

procedure TfrmMain.btnGenerateSerialNumberClick(Sender: TObject);
begin
txtSerialNumber.text:=formatdatetime('yyyymmddhhnnsszzz', now);
end;

end.

