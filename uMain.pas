unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WideStrings, DBXFirebird, FMTBcd, DB, Provider, DBClient, SqlExpr,
  Grids, DBGrids, StdCtrls, Menus, ExtCtrls, ComCtrls, ImgList;

type
  TFrMain = class(TForm)
    SQLConnection1: TSQLConnection;
    SQLQuery1: TSQLQuery;
    ClientDataSet1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    DataSource1: TDataSource;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    AddContact1: TMenuItem;
    EditContact1: TMenuItem;
    File2: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    panel2: TPanel;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    GroupBox2: TGroupBox;
    phone1: TLabel;
    phone2: TLabel;
    phone3: TLabel;
    phone4: TLabel;
    phone5: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    Editorremovethiscontact1: TMenuItem;
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure AddContact1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ClientDataSet1AfterScroll(DataSet: TDataSet);
    procedure DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure EditContact1Click(Sender: TObject);
    procedure Editorremovethiscontact1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
   procedure ClearPhoneLabels;
   procedure LoadEditContact;
    { Private declarations }
  public
         { Public declarations }
  end;

  type TmyCustomDBbgrid = class (TDBGrid);

  //end;

var
  FrMain: TFrMain;

implementation

uses uAddContact, uEditContact;

{$R *.dfm}

procedure TFrMain.About1Click(Sender: TObject);
begin
 MessageDlg('Phonebook by dr Ahmed Shoulah',mtInformation,[mbOK],0);
end;

procedure TFrMain.AddContact1Click(Sender: TObject);
begin
FrAddContact := TFrAddContact.Create(nil);
try
  FrAddContact.ShowModal;
finally
  FrAddContact.Release;
end;
end;

procedure TFrMain.Button1Click(Sender: TObject);
begin
 LoadEditContact;
end;

procedure TFrMain.ClearPhoneLabels;
var
 I : Integer;
 X : Integer;
begin
X := 1;
try
 for I := 0 to ComponentCount - 1 do
       if ((Components[i] as TComponent).Name = 'phone'+ IntToStr(X)) then
        begin
        (Components[i] as TLabel).Caption := '';
         Inc(x);
        end;
        Label2.Caption := '';
Except
 on E : Exception do
 ShowMessage(E.Message);
end;
end;

procedure TFrMain.ClientDataSet1AfterScroll(DataSet: TDataSet);
var
 myQuery : TSQLQuery;
 myID : string;
 I : Integer;
 X : Integer;
begin
ClearPhoneLabels;
//-
Label2.Caption := Trim(ClientDataSet1.FieldByName('f_name').AsString) + ' ' +
                    Trim(ClientDataSet1.FieldByName('l_name').AsString);
//-----------
myQuery := TSQLQuery.Create(nil);
myID := ClientDataSet1.FieldByName('id').AsString;
try
  myQuery.SQLConnection := SQLConnection1;
  myQuery.SQL.Text := 'select * from phone_no';
  myQuery.SQL.Add('where id = '+ QuotedStr(myID));
  myQuery.Open;
  x := 1;
  while not myQuery.Eof do
  begin
     //--
     for I := 0 to ComponentCount - 1 do
       if ((Components[i] as TComponent).Name = 'phone'+ IntToStr(X)) then
        (Components[i] as TLabel).Caption := myQuery.FieldByName('phone_number').AsString;
    //--
    Inc(X);
    myQuery.Next;
  end;
finally
  myQuery.Free;
end;
end;
//------------------------------------------------------------------------------
procedure TFrMain.DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var
   Cell : TGridCoord;
   ActiveRecordBok : Integer;
  begin
   Cell := DBGrid1.MouseCoord(X, Y);
   if dgTitles in DBGrid1.Options then
   Dec(Cell.Y);
   if dgIndicator in DBGrid1.Options then
   Dec(Cell.X);
if (TmyCustomDBbgrid(DBGrid1).DataLink.Active) and (Cell.X >= 0) and (cell.Y >= 0) then
begin
  ActiveRecordBok := TmyCustomDBbgrid(DBGrid1).DataLink.ActiveRecord;
  try
   TmyCustomDBbgrid(DBGrid1).DataLink.ActiveRecord := Cell.Y;
   DBGrid1.Hint := Trim(DBGrid1.Fields[Cell.x].AsString);
   Application.ActivateHint(DBGrid1.ClientToScreen(point(x, y)));
  finally
   TmyCustomDBbgrid(DBGrid1).DataLink.ActiveRecord := ActiveRecordBok;
  end;
end;

end;



procedure TFrMain.Edit1Change(Sender: TObject);
begin
try
ClearPhoneLabels;
with SQLQuery1 do
begin
  ClientDataSet1.Active := False;
  Close;
  SQL.Clear;
  SQL.Text := 'select DISTINCT f_name,l_name, contacts.id from contacts left join phone_no on contacts.id = phone_no.id';
  SQL.Add('where f_name like '+QuotedStr('%'+Edit1.Text+'%')+' or l_name like '+
                                                     QuotedStr(Edit1.Text+'%'));
  SQL.Add(' or phone_no.phone_number like '+QuotedStr('%'+Edit1.Text+'%'));
  SQL.Add('order by f_name');
  Open;
  ClientDataSet1.Active := True;
end;
Except
 on E: Exception do
 ShowMessage(E.Message);

end;
end;

procedure TFrMain.EditContact1Click(Sender: TObject);
begin
LoadEditContact;
end;

procedure TFrMain.Editorremovethiscontact1Click(Sender: TObject);
begin
LoadEditContact;
end;

procedure TFrMain.Exit1Click(Sender: TObject);
begin
FrMain.Close;
end;

procedure TFrMain.FormCreate(Sender: TObject);
begin
SQLConnection1.VendorLib := ExtractFilePath(Application.ExeName) + 'fbclient.dll';
try
  SQLConnection1.Connected := True;
  ClientDataSet1.Active := True;
except
 on E:Exception do
 ShowMessage(E.Message);
end;
end;

procedure TFrMain.LoadEditContact;
begin
FrEditContact := TFrEditContact.Create(nil);
try
 FrEditContact.myContact_id := ClientDataSet1.FieldByName('id').AsString;
 FrEditContact.execute;
finally
  FrEditContact.Release;
end;
end;

end.
