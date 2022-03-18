unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  StdCtrls, VirtualTrees, LConvEncoding, DateTimePicker, Windows;

type

  PCSVGoogle = ^TCSVGoogle;
  TCSVGoogle = record
    FirstName: string;
    SecondName: string;
    LastName: string;
    EMail: string;
    Status: string;
    LastSignIn: string;
    EmailUsage: string;
    TotalStorage: string;
  end;

  PCSVYandex = ^TCSVYandex;
  TCSVYandex = record
    source_login: string;
    source_password: string;
    yandexmail_login: string;
    yandexmail_password: string;
    name: string;
    surname: string;
    middlename: string;
    gender: string;
    birthday: string;
    language: string;
  end;

  PCSVMail = ^TCSVMail;
  TCSVMail = record
    login: string;
    password: string;
    name: string;
    surname: string;
    groups: string;
    source_login: string;
    source_password: string;
    delete: string;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btToYandex: TButton;
    Button2: TButton;
    btToMailRu: TButton;
    Button4: TButton;
    cbDefGender: TComboBox;
    cbGender: TComboBox;
    cbDefLanguage: TComboBox;
    cbLanguage: TComboBox;
    cbDelete: TCheckBox;
    cbDefDelete: TCheckBox;
    dtpDate: TDateTimePicker;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    mailDefGroups: TLabeledEdit;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    N3: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem5: TMenuItem;
    N1: TMenuItem;
    SaveDialog1: TSaveDialog;
    SourceLogin: TLabeledEdit;
    dtpDefDate: TDateTimePicker;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DefPassGoogle: TLabeledEdit;
    defPassYandex: TLabeledEdit;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    MailSourceLogin: TLabeledEdit;
    SourcePassword: TLabeledEdit;
    MailSourcePassword: TLabeledEdit;
    YandexLogin: TLabeledEdit;
    VST: TVirtualStringTree;
    MailLogin: TLabeledEdit;
    YandexMiddleName: TLabeledEdit;
    MailGroups: TLabeledEdit;
    MailName: TLabeledEdit;
    MailPassword: TLabeledEdit;
    YandexSurname: TLabeledEdit;
    YandexPassword: TLabeledEdit;
    YandexName: TLabeledEdit;
    MailSurname: TLabeledEdit;
    procedure btToYandexClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btToMailRuClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure VSTAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTCompareNodesYandex(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTCompareNodesMail(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTGetNodeDataSizeYandex(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTGetNodeDataSizeMail(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure VSTGetTextYandex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure VSTGetTextMail(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure VSTHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure VSTKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure VSTNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
  private
    CurrentService: word;
    ImportList: TList;
    SelectedNode: PVirtualNode;
    procedure LoadCSVGoogleFile(Filename: string);
    procedure SaveCSVYandexFile(Filename: string);
    procedure LoadCSVYandexFile(Filename: string);
    procedure SaveCSVMailFile(Filename: string);
    procedure LoadCSVMailFile(Filename: string);
    function UsageStrToInt(Usage: string): extended;
    function GetAccountFromMail(EMail: string): string;
    function GetYandexCSVLine(Data: PCSVYandex): string;
    function GetMailCSVLine(Data: PCSVMail): string;
    procedure UpdateNodeInputsYandex(Node: PVirtualNode);
    procedure UpdateNodeInputsMail(Node: PVirtualNode);
  public

  end;

const
  CS_GOOGLE = 0;
  CS_YANDEX = 1;
  CS_MAILRU = 2;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function MyBoolToStr(Val: boolean): string;
begin
  if Val then Result := 'true' else Result := 'false';
end;

function MyStrToBool(Val: string): boolean;
begin
  if strlower(PChar(Val)) = 'true' then Result := true else Result := false;
end;

{ TForm1 }

procedure TForm1.VSTGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TCSVGoogle);
end;

procedure TForm1.VSTGetNodeDataSizeYandex(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TCSVYandex);
end;

procedure TForm1.VSTGetNodeDataSizeMail(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TCSVMail)
end;

procedure TForm1.VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  NodeData: PCSVGoogle;
begin
  NodeData := VST.GetNodeData(Node);
  case Column of
    0:
      begin
        CellText := NodeData^.LastName;
      end;
    1:
      begin
        CellText := NodeData^.FirstName;
      end;
    2:
      begin
        CellText := NodeData^.SecondName;
      end;
    3:
      begin
        CellText := NodeData^.EMail;
      end;
    4:
      begin
        CellText := NodeData^.Status;
      end;
    5:
      begin
        CellText := NodeData^.LastSignIn;
      end;
    6:
      begin
        CellText := NodeData^.EmailUsage;
      end;
    7:
      begin
        CellText := NodeData^.TotalStorage;
      end;
  end;
end;

procedure TForm1.VSTGetTextYandex(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  NodeData: PCSVYandex;
begin
  NodeData := VST.GetNodeData(Node);
  case Column of
    0: CellText := NodeData^.source_login;
    1: CellText := NodeData^.source_password;
    2: CellText := NodeData^.yandexmail_login;
    3: CellText := NodeData^.yandexmail_password;
    4: CellText := NodeData^.name;
    5: CellText := NodeData^.surname;
    6: CellText := NodeData^.middlename;
    7: CellText := NodeData^.gender;
    8: CellText := NodeData^.birthday;
    9: CellText := NodeData^.language;
  end;
end;

procedure TForm1.VSTGetTextMail(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  NodeData: PCSVMail;
begin
  NodeData := VST.GetNodeData(Node);
  case Column of
    0: CellText := NodeData^.login;
    1: CellText := NodeData^.password;
    2: CellText := NodeData^.name;
    3: CellText := NodeData^.surname;
    4: CellText := NodeData^.groups;
    5: CellText := NodeData^.source_login;
    6: CellText := NodeData^.source_password;
    7: CellText := NodeData^.delete;
  end;
end;

procedure TForm1.VSTHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  if TVTHeader(Sender).SortDirection = sdAscending then
     begin
       TVTHeader(Sender).SortDirection := sdDescending;
       VST.SortTree(HitInfo.Column, sdDescending);
     end
  else
     begin
       TVTHeader(Sender).SortDirection := sdAscending;
       VST.SortTree(HitInfo.Column, sdAscending);
     end;
end;

procedure TForm1.VSTKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 46 then
     if Application.MessageBox('Действительно удалить запись?', 'Внимание', MB_YESNO) = IDYES then
       begin
         VST.DeleteNode(VST.FocusedNode);
         SelectedNode := nil;
       end;
end;

procedure TForm1.VSTNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo
  );
begin
  if Assigned(HitInfo.HitNode) then SelectedNode:=HitInfo.HitNode;
  case CurrentService of
    0:;
    1: UpdateNodeInputsYandex(SelectedNode);
    2: UpdateNodeInputsMail(SelectedNode);
  end;
end;

procedure TForm1.LoadCSVGoogleFile(Filename: string);
var
  Loader, Delimited: TStringList;
  NodeData: PCSVGoogle;
  Node: PVirtualNode;
  i: integer;
  temp: TStringArray;
begin
  Loader := TStringList.Create;
  Delimited := TStringList.Create;

  VST.Clear;
  VST.Header.Columns.Clear;
  VST.OnGetNodeDataSize := @VSTGetNodeDataSize;
  VST.OnGetText := @VSTGetText;
  VST.OnCompareNodes:=@VSTCompareNodes;

  VST.BeginUpdate;

  for i := 0 to 7 do
    begin
      VST.Header.Columns.Add;
      with VST.Header.Columns[i] do
        begin
          case i of
            0: begin Text:='Фамилия'; MinWidth:=150; Width:=150; end;
            1: begin Text:='Имя'; MinWidth:=100; Width:=100; end;
            2: begin Text:='Отчество'; MinWidth:=100; Width:=100; end;
            3: begin Text:='Почта'; MinWidth:=150; Width:=150; end;
            4: begin Text:='Статус'; MinWidth:=100; Width:=100; end;
            5: begin Text:='Последний вход'; MinWidth:=100; Width:=100; end;
            6: begin Text:='Занято на почте'; MinWidth:=100; Width:=100; end;
            7: begin Text:='Ограничения'; MinWidth:=75; Width:=75; end;
          end;
        end;
    end;


  try
    Loader.LoadFromFile(Filename);
    Delimited.Delimiter := ',';
    Delimited.StrictDelimiter:=true;
    Loader.Delimiter := ',';

    for i := 1 to Loader.Count - 1 do
      begin
        Delimited.DelimitedText := Loader[i];
        Node := VST.AddChild(nil);
        NodeData := VST.GetNodeData(Node);
        temp := Delimited[0].Split(' ');
        NodeData^.FirstName := temp[0];
        NodeData^.SecondName := temp[1];
        NodeData^.LastName := Delimited[1];
        NodeData^.EMail := Delimited[2];
        NodeData^.Status := Delimited[3];
        NodeData^.LastSignIn := Delimited[4];
        NodeData^.EmailUsage := Delimited[5];
        NodeData^.TotalStorage := Delimited[6];
      end;
  finally
    Loader.Free;
    Delimited.Free;
    VST.EndUpdate;
    GroupBox1.Visible:=true;
    GroupBox2.Visible:=false;
    GroupBox3.Visible:=false;
    MenuItem3.Enabled:=false;
    MenuItem4.Enabled:=true;
    MenuItem5.Enabled:=true;
    MenuItem6.Enabled:=false;

    CurrentService := CS_GOOGLE;
  end;
end;

procedure TForm1.SaveCSVYandexFile(Filename: string);
var
  SaveList: TStringList;
  NodeData: PCSVYandex;
  Node: PVirtualNode;
begin
  SaveList := TStringList.Create;

  SaveList.Add(Format('"%s";"%s";"%s";"%s";"%s";"%s";"%s";"%s";"%s";"%s"',
                   ['source_login',
                    'source_password',
                    'yandexmail_login',
                    'yandexmail_password',
                    'name',
                    'surname',
                    'middlename',
                    'gender',
                    'birthday',
                    'language'
                   ]));
  Node := VST.GetFirst();
  while Assigned(Node) do
    begin
      NodeData := VST.GetNodeData(Node);
      SaveList.Add(GetYandexCSVLine(NodeData));
      Node := VST.GetNextSibling(Node);
    end;
  SaveList.SaveToFile(Filename);
  SaveList.Free;
end;

procedure TForm1.LoadCSVYandexFile(Filename: string);
var
  i: integer;
  NodeData: PCSVYandex;
  Node: PVirtualNode;
  Loader, Delimited: TStringList;
begin
  VST.Clear;
  VST.Header.Columns.Clear;
  VST.OnGetNodeDataSize := @VSTGetNodeDataSizeYandex;
  VST.OnGetText := @VSTGetTextYandex;
  VST.OnCompareNodes:=@VSTCompareNodesYandex;

  VST.BeginUpdate;

  for i := 0 to 9 do
    begin
      VST.Header.Columns.Add;
      with VST.Header.Columns[i] do
        begin
          case i of
            0: begin Text:='source_login'; MinWidth:=150; Width:=150; end;
            1: begin Text:='source_password'; MinWidth:=100; Width:=100; end;
            2: begin Text:='yandexmail_login'; MinWidth:=100; Width:=100; end;
            3: begin Text:='yandexmail_password'; MinWidth:=150; Width:=150; end;
            4: begin Text:='name'; MinWidth:=100; Width:=100; end;
            5: begin Text:='surname'; MinWidth:=100; Width:=100; end;
            6: begin Text:='middlename'; MinWidth:=100; Width:=100; end;
            7: begin Text:='gender'; MinWidth:=75; Width:=75; end;
            8: begin Text:='birthday'; MinWidth:=100; Width:=100; end;
            9: begin Text:='language'; MinWidth:=75; Width:=75; end;
          end;
        end;
    end;

  Loader := TStringList.Create;
  Delimited := TStringList.Create;
  try
    Loader.LoadFromFile(Filename);
    Delimited.Delimiter := ';';
    Delimited.StrictDelimiter:=true;
    for i := 1 to Loader.Count - 1 do
      begin
        Delimited.DelimitedText := Loader[i];
        Node := VST.AddChild(nil);
        NodeData := VST.GetNodeData(Node);
        NodeData^.source_login := Delimited[0];
        NodeData^.source_password := Delimited[1];
        NodeData^.yandexmail_login := Delimited[2];
        NodeData^.yandexmail_password := Delimited[3];
        NodeData^.name := Delimited[4];
        NodeData^.surname := Delimited[5];
        NodeData^.middlename := Delimited[6];
        NodeData^.gender := Delimited[7];
        NodeData^.birthday := Delimited[8];
        NodeData^.language := Delimited[9];
      end;
  finally
    VST.EndUpdate;
    Loader.Free;
    Delimited.Free;
    GroupBox1.Visible:=false;
    GroupBox2.Visible:=true;
    GroupBox3.Visible:=false;
    MenuItem3.Enabled:=true;
    MenuItem6.Enabled:=false;

    CurrentService:=CS_YANDEX;
  end;
end;

procedure TForm1.SaveCSVMailFile(Filename: string);
var
  SaveList: TStringList;
  NodeData: PCSVMail;
  Node: PVirtualNode;
begin
  SaveList := TStringList.Create;
  Node := VST.GetFirst();
  while Assigned(Node) do
    begin
      NodeData := VST.GetNodeData(Node);
      SaveList.Add(GetMailCSVLine(NodeData));
      Node := VST.GetNextSibling(Node);
    end;
  SaveList.SaveToFile(Filename);
  SaveList.Free;
end;

procedure TForm1.LoadCSVMailFile(Filename: string);
var
  i: integer;
  NodeData: PCSVMail;
  Node: PVirtualNode;
  Loader, Delimited: TStringList;
begin
  VST.Clear;
  VST.Header.Columns.Clear;
  VST.OnGetNodeDataSize := @VSTGetNodeDataSizeMail;
  VST.OnGetText := @VSTGetTextMail;
  VST.OnCompareNodes:=@VSTCompareNodesMail;

  VST.BeginUpdate;

  for i := 0 to 7 do
    begin
      VST.Header.Columns.Add;
      with VST.Header.Columns[i] do
        begin
          case i of
            0: begin Text:='login'; MinWidth:=150; Width:=150; end;
            1: begin Text:='password'; MinWidth:=100; Width:=100; end;
            2: begin Text:='name'; MinWidth:=100; Width:=100; end;
            3: begin Text:='surname'; MinWidth:=150; Width:=150; end;
            4: begin Text:='groups'; MinWidth:=100; Width:=100; end;
            5: begin Text:='source_login'; MinWidth:=100; Width:=100; end;
            6: begin Text:='source_password'; MinWidth:=100; Width:=100; end;
            7: begin Text:='delete'; MinWidth:=75; Width:=75; end;
          end;
        end;
    end;

  Loader := TStringList.Create;
  Delimited := TStringList.Create;
  try
    Loader.LoadFromFile(Filename);
    Delimited.Delimiter := ';';
    Delimited.StrictDelimiter:=true;
    for i := 0 to Loader.Count - 1 do
      begin
        Delimited.DelimitedText := Loader[i];
        Node := VST.AddChild(nil);
        NodeData := VST.GetNodeData(Node);
        NodeData^.login := Delimited[0];
        NodeData^.password := Delimited[1];
        NodeData^.name := Delimited[2];
        NodeData^.surname := Delimited[3];
        NodeData^.groups := Delimited[4];
        NodeData^.source_password := Delimited[5];
        NodeData^.source_login := Delimited[6];
        NodeData^.delete := Delimited[7];
      end;
  finally
    VST.EndUpdate;
    Loader.Free;
    Delimited.Free;
    GroupBox1.Visible:=false;
    GroupBox2.Visible:=false;
    GroupBox3.Visible:=true;
    MenuItem3.Enabled:=false;
    MenuItem6.Enabled:=true;
    CurrentService:=CS_MAILRU;
  end;
end;

function TForm1.UsageStrToInt(Usage: string): extended;
var
  tmp: string;
begin
  tmp := Copy(Usage, 1, Pos(PChar(Usage), 'GB'));
  TryStrToFloat(tmp, Result);
end;

function TForm1.GetAccountFromMail(EMail: string): string;
var
 tmp: TStringArray;
begin
  tmp := EMail.Split('@');
  Result := tmp[0];
end;

function TForm1.GetYandexCSVLine(Data: PCSVYandex): string;
begin
  Result := Format('%s;%s;%s;%s;%s;%s;%s;%s;%s;%s',
                   [Data^.source_login,
                    Data^.source_password,
                    Data^.yandexmail_login,
                    Data^.yandexmail_password,
                    Data^.name,
                    Data^.surname,
                    Data^.middlename,
                    Data^.gender,
                    Data^.birthday,
                    Data^.language
                   ]);
end;

function TForm1.GetMailCSVLine(Data: PCSVMail): string;
begin
  Result := Format('%s;%s;%s;%s;%s;%s;%s;%s',
                   [Data^.login,
                    Data^.password,
                    Data^.name,
                    Data^.surname,
                    Data^.groups,
                    Data^.source_password,
                    Data^.source_login,
                    Data^.delete
                   ]);
end;

procedure TForm1.UpdateNodeInputsYandex(Node: PVirtualNode);
var
  NodeData: PCSVYandex;
  dt: TDateTime;
begin
  if Assigned(Node) then NodeData:=VST.GetNodeData(Node) else exit;

  SourceLogin.Text:=NodeData^.source_login;
  SourcePassword.Text:=NodeData^.source_password;
  YandexLogin.Text:=NodeData^.yandexmail_login;
  YandexPassword.Text:=NodeData^.yandexmail_password;
  YandexName.Text:=NodeData^.name;
  YandexMiddleName.Text:=NodeData^.middlename;
  YandexSurname.Text:=NodeData^.surname;
  cbGender.Text:=NodeData^.gender;
  TryStrToDate(NodeData^.birthday, dt);
  dtpDate.Date := dt;
  cbLanguage.Text:=NodeData^.language;
end;

procedure TForm1.UpdateNodeInputsMail(Node: PVirtualNode);
var
  NodeData: PCSVMail;
begin
  if Assigned(Node) then NodeData:=VST.GetNodeData(Node) else exit;

  MailLogin.Text:=NodeData^.login;
  MailPassword.Text:=NodeData^.password;
  MailName.Text:=NodeData^.name;
  MailSurname.Text:=NodeData^.surname;
  MailGroups.Text:=NodeData^.groups;
  MailSourceLogin.Text:=NodeData^.source_login;
  MailSourcePassword.Text:=NodeData^.source_password;
  cbDelete.Checked:=StrToBool(NodeData^.delete);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      LoadCSVGoogleFile(OpenDialog1.FileName);
    end;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveCSVYandexFile(SaveDialog1.FileName);
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  If OpenDialog1.Execute then
    begin
      LoadCSVYandexFile(OpenDialog1.FileName);
    end;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  If OpenDialog1.Execute then
    begin
      LoadCSVMailFile(OpenDialog1.FileName);
    end;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
 if SaveDialog1.Execute then
  SaveCSVMailFile(SaveDialog1.FileName);
end;

procedure TForm1.VSTAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode
  );
begin
  if Assigned(Node) then SelectedNode:=Node;
  case CurrentService of
    0:;
    1: UpdateNodeInputsYandex(SelectedNode);
    2: UpdateNodeInputsMail(SelectedNode);
  end;
end;

procedure TForm1.btToYandexClick(Sender: TObject);
var
  i: integer;
  GoogleData: PCSVGoogle;
  YandexData, NodeData: PCSVYandex;
  Node: PVirtualNode;
begin
  ImportList := TList.Create;

  Node := VST.GetFirst;
  while Assigned(Node) do
  begin
    New(YandexData);
    GoogleData := VST.GetNodeData(Node);
    YandexData^.source_login := GoogleData^.EMail;
    YandexData^.source_password := DefPassGoogle.Text;
    YandexData^.yandexmail_login := GetAccountFromMail(GoogleData^.EMail);
    YandexData^.yandexmail_password := defPassYandex.Text;
    YandexData^.name := GoogleData^.FirstName;
    YandexData^.surname := GoogleData^.LastName;
    YandexData^.middlename := GoogleData^.SecondName;
    YandexData^.gender := cbDefGender.Text;
    YandexData^.birthday := DateToStr(dtpDefDate.Date);
    YandexData^.language := cbDefLanguage.Text;
    ImportList.Add(YandexData);
    Node := VST.GetNextSibling(Node);
  end;

  VST.Clear;
  VST.Header.Columns.Clear;
  VST.OnGetNodeDataSize := @VSTGetNodeDataSizeYandex;
  VST.OnGetText := @VSTGetTextYandex;
  VST.OnCompareNodes:=@VSTCompareNodesYandex;

  VSt.BeginUpdate;

  for i := 0 to 9 do
    begin
      VST.Header.Columns.Add;
      with VST.Header.Columns[i] do
        begin
          case i of
            0: begin Text:='source_login'; MinWidth:=150; Width:=150; end;
            1: begin Text:='source_password'; MinWidth:=100; Width:=100; end;
            2: begin Text:='yandexmail_login'; MinWidth:=100; Width:=100; end;
            3: begin Text:='yandexmail_password'; MinWidth:=150; Width:=150; end;
            4: begin Text:='name'; MinWidth:=100; Width:=100; end;
            5: begin Text:='surname'; MinWidth:=100; Width:=100; end;
            6: begin Text:='middlename'; MinWidth:=100; Width:=100; end;
            7: begin Text:='gender'; MinWidth:=75; Width:=75; end;
            8: begin Text:='birthday'; MinWidth:=100; Width:=100; end;
            9: begin Text:='language'; MinWidth:=75; Width:=75; end;
          end;
        end;
    end;

  for i := 0 to ImportList.Count - 1 do
    begin
      Node := VST.AddChild(nil);
      NodeData := VST.GetNodeData(Node);
      NodeData^ := PCSVYandex(ImportList.Items[i])^;
    end;

  VST.EndUpdate;
  ImportList.Free;

  GroupBox1.Visible:=false;
  GroupBox2.Visible:=true;

  MenuItem3.Enabled:=true;
  MenuItem6.Enabled:=false;

  CurrentService:=CS_YANDEX;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  NodeData: PCSVYandex;
begin
  if Assigned(SelectedNode) then NodeData:=VST.GetNodeData(SelectedNode) else exit;

  VST.BeginUpdate;
  NodeData^.source_login := SourceLogin.Text;
  NodeData^.source_password := SourcePassword.Text;
  NodeData^.yandexmail_login := YandexLogin.Text;
  NodeData^.yandexmail_password := YandexPassword.Text;
  NodeData^.name := YandexName.Text;
  NodeData^.middlename := YandexMiddleName.Text;
  NodeData^.surname := YandexSurname.Text;
  NodeData^.gender := cbGender.Text;
  NodeData^.birthday := DateToStr(dtpDate.Date);
  NodeData^.language := cbLanguage.Text;
  VST.EndUpdate;
end;

procedure TForm1.btToMailRuClick(Sender: TObject);
var
  i: integer;
  GoogleData: PCSVGoogle;
  MailData, NodeData: PCSVMail;
  Node: PVirtualNode;
  bUseSeconName: boolean;
begin
  ImportList := TList.Create;

  bUseSeconName :=  Application.MessageBox('Подставить Отчество к Имени?', 'Вопрос', MB_YESNO) = IDYES;

  Node := VST.GetFirst;
  while Assigned(Node) do
  begin
    New(MailData);
    GoogleData := VST.GetNodeData(Node);
    MailData^.source_login := GoogleData^.EMail;
    MailData^.source_password := DefPassGoogle.Text;
    MailData^.login := GetAccountFromMail(GoogleData^.EMail);
    MailData^.password := defPassYandex.Text;
    MailData^.name := GoogleData^.FirstName;
    MailData^.surname := GoogleData^.LastName;
    MailData^.groups := mailDefGroups.Text;
    MailData^.delete := MyBoolToStr(cbDefDelete.Checked);

    if bUseSeconName then MailData^.name := MailData^.name + ' ' + GoogleData^.SecondName;

    ImportList.Add(MailData);
    Node := VST.GetNextSibling(Node);
  end;

  VST.Clear;
  VST.Header.Columns.Clear;
  VST.OnGetNodeDataSize := @VSTGetNodeDataSizeMail;
  VST.OnGetText := @VSTGetTextMail;
  VST.OnCompareNodes:=@VSTCompareNodesMail;

  VSt.BeginUpdate;

  for i := 0 to 7 do
    begin
      VST.Header.Columns.Add;
      with VST.Header.Columns[i] do
        begin
          case i of
            0: begin Text:='login'; MinWidth:=150; Width:=150; end;
            1: begin Text:='password'; MinWidth:=100; Width:=100; end;
            2: begin Text:='name'; MinWidth:=100; Width:=100; end;
            3: begin Text:='surname'; MinWidth:=150; Width:=150; end;
            4: begin Text:='groups'; MinWidth:=100; Width:=100; end;
            5: begin Text:='source_login'; MinWidth:=100; Width:=100; end;
            6: begin Text:='source_password'; MinWidth:=100; Width:=100; end;
            7: begin Text:='delete'; MinWidth:=75; Width:=75; end;
          end;
        end;
    end;

  for i := 0 to ImportList.Count - 1 do
    begin
      Node := VST.AddChild(nil);
      NodeData := VST.GetNodeData(Node);
      NodeData^ := PCSVMail(ImportList.Items[i])^;
    end;

  VST.EndUpdate;
  ImportList.Free;

  GroupBox1.Visible:=false;
  GroupBox3.Visible:=true;

  MenuItem3.Enabled:=false;
  MenuItem6.Enabled:=true;

  CurrentService:=CS_MAILRU;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  NodeData: PCSVMail;
begin
  if Assigned(SelectedNode) then NodeData:=VST.GetNodeData(SelectedNode) else exit;

  VST.BeginUpdate;
  NodeData^.login := MailLogin.Text;
  NodeData^.password := MailPassword.Text;
  NodeData^.name := MailName.Text;
  NodeData^.surname := MailSurname.Text;
  NodeData^.groups := MailGroups.Text;
  NodeData^.source_login := MailSourceLogin.Text;
  NodeData^.source_password := MailSourcePassword.Text;
  NodeData^.delete := MyBoolToStr(cbDelete.Checked);
  VST.EndUpdate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GroupBox1.Height:=540;
  GroupBox2.Height:=600;
  GroupBox3.Height:=464;

  MenuItem3.Enabled:=false;
  MenuItem4.Enabled:=true;
  MenuItem5.Enabled:=true;
  MenuItem6.Enabled:=false;

  CurrentService:=CS_GOOGLE;
end;

procedure TForm1.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2: PCSVGoogle;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  case Column of
    0: Result := Result + CompareText(Data1^.LastName, Data2^.LastName);
    1: Result := Result + CompareText(Data1^.FirstName, Data2^.FirstName);
    2: Result := Result + CompareText(Data1^.SecondName, Data2^.SecondName);
    3: Result := Result + CompareText(Data1^.EMail, Data2^.EMail);
    4: Result := Result + CompareText(Data1^.Status, Data2^.Status);
    5: Result := Result + CompareText(Data1^.LastSignIn, Data2^.LastSignIn);
    6: Result := Result + CompareText(Data1^.EmailUsage, Data2^.EmailUsage);
    7: Result := Result + CompareText(Data1^.TotalStorage, Data2^.TotalStorage);
  end;
end;

procedure TForm1.VSTCompareNodesYandex(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2: PCSVYandex;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  case Column of
    0: Result := Result + CompareText(Data1^.source_login, Data2^.source_login);
    1: Result := Result + CompareText(Data1^.source_password, Data2^.source_password);
    2: Result := Result + CompareText(Data1^.yandexmail_login, Data2^.yandexmail_login);
    3: Result := Result + CompareText(Data1^.yandexmail_password, Data2^.yandexmail_password);
    4: Result := Result + CompareText(Data1^.name, Data2^.name);
    5: Result := Result + CompareText(Data1^.surname, Data2^.surname);
    6: Result := Result + CompareText(Data1^.middlename, Data2^.middlename);
    7: Result := Result + CompareText(Data1^.gender, Data2^.gender);
    8: Result := Result + CompareText(Data1^.birthday, Data2^.birthday);
    9: Result := Result + CompareText(Data1^.language, Data2^.language);
  end;
end;

procedure TForm1.VSTCompareNodesMail(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2: PCSVMail;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  case Column of
    0: Result := Result + CompareText(Data1^.login, Data2^.login);
    1: Result := Result + CompareText(Data1^.password, Data2^.password);
    2: Result := Result + CompareText(Data1^.name, Data2^.name);
    3: Result := Result + CompareText(Data1^.surname, Data2^.surname);
    4: Result := Result + CompareText(Data1^.groups, Data2^.groups);
    5: Result := Result + CompareText(Data1^.source_login, Data2^.source_login);
    6: Result := Result + CompareText(Data1^.source_password, Data2^.source_password);
    7: Result := Result + CompareText(Data1^.delete, Data2^.delete);
  end;
end;

end.

