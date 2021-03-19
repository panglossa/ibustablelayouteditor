unit ufrmmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, ExtDlgs;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnGenerateSerialNumber: TButton;
    btnGenerateUID: TButton;
    Button1: TButton;
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
    imgIcon: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SaveDialog1: TSaveDialog;
    sgSTable: TStringGrid;
    sgOtherValues: TStringGrid;
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
    procedure FormCreate(Sender: TObject);
    procedure imgIconClick(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;
  iconfilename:string;

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
  gbSTable.align:=alClient;
  SaveDialog1.InitialDir:=GetUserDir;
  if (DirectoryExists(SaveDialog1.InitialDir + '/keyboards')) then begin
    SaveDialog1.InitialDir:=SaveDialog1.InitialDir + '/keyboards';
    end;
end;

procedure TfrmMain.imgIconClick(Sender: TObject);
begin
if (OpenPictureDialog1.Execute) then begin
  iconfilename:=OpenPictureDialog1.FileName;
  imgIcon.Picture.LoadFromFile(OpenPictureDialog1.FileName);
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
  char, subst, freq:string;

begin
if (SaveDialog1.Execute) then begin
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
      freq:=trim(sgSTable.Cells[2, r]);
      if((freq='')or(not(isNumeric(freq)))) then begin
        freq:='0';
        end;
      if ((char<>'')and(subst<>'')) then begin
         s.add(char + '	' + subst + '	' + freq);
         end;
      end;
  s.add('END_TABLE');
  s.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TfrmMain.btnGenerateSerialNumberClick(Sender: TObject);
begin
txtSerialNumber.text:=formatdatetime('yyyymmddhhnnsszzz', now);
end;

end.

