unit uAddContact;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, DB, SqlExpr, StdCtrls, unumEdit, uUpperCaseFirst, //acPNG,
  ExtCtrls;

type
  TFrAddContact = class(TForm)
    SQLQuery1: TSQLQuery;
    NumEdit1: TNumEdit;
    Button1: TButton;
    NumEdit2: TNumEdit;
    NumEdit3: TNumEdit;
    NumEdit4: TNumEdit;
    NumEdit5: TNumEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TUpperCaseEdit;
    Edit2: TUpperCaseEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
  function getMaxID : Integer;
  procedure SaveContact;
  function isRequiredFieldsEmpty : Boolean;
  procedure ClearAllFields;
 
    { Public declarations }
  end;

var
  FrAddContact: TFrAddContact;

implementation

uses uMain;

{$R *.dfm}


//******************************************************************************
procedure TFrAddContact.Button1Click(Sender: TObject);
begin
if not isRequiredFieldsEmpty then
begin
   SaveContact;
   if MessageDlg('Contact saved successfully do you want add anther one?',
                                        mtConfirmation,mbYesNo,0) = mrYes then
begin
   ClearAllFields;
   Edit1.SetFocus;
end
   else
   begin
   FrAddContact.Close;
   FrMain.Edit1.OnChange(Self);
   end;
end;
end;

procedure TFrAddContact.ClearAllFields;
var
 I : Integer;
begin
 for I := 0 to ComponentCount - 1 do
   if (Components[i] is TEdit)  then
   (Components[i] as TEdit).Text := '';
end;

procedure TFrAddContact.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   FrMain.Edit1.OnChange(Self);
end;

function TFrAddContact.getMaxID: Integer;
var
 myQuery : TSQLQuery;
begin
 myQuery := TSQLQuery.Create(nil);
 try
  with myQuery do
  begin
    SQLConnection := FrMain.SQLConnection1;
    sql.Text := 'select max(id) as myMax from contacts';
    Open;
    Result := FieldByName('myMax').AsInteger;
  end;
 finally
   myQuery.Free;
 end;
end;
 function TFrAddContact.isRequiredFieldsEmpty : Boolean;
begin
if Trim(Edit1.Text) = '' then
begin
  ShowMessage('Please enter contact name');
  Result := True;
  Exit;
end;
if Trim(NumEdit1.Text) = '' then
begin
  ShowMessage('please enter phone number');
  Result := True;
  Exit;
end;
Result := False;
end;

procedure TFrAddContact.SaveContact;
var
 i : Integer;
begin
try
with SQLQuery1 do
begin
  Close;
  SQL.Clear;
  SQL.Text := 'insert into contacts (F_NAME, L_NAME) values (' +
              QuotedStr(Edit1.Text)+','+
              QuotedStr(Edit2.Text)+')';
  ExecSQL(True);
end;
 //--- this loop for phone numbers
  for I := 0 to ComponentCount -1 do
  begin
   if Components[i].ClassType = TNumEdit then
        if Trim((Components[i] as TNumEdit).Text) <> '' then
        begin
         SQLQuery1.Close;
         SQLQuery1.SQL.Clear;
         SQLQuery1.SQL.Text:='insert into phone_no (id, phone_number) values ('+
         IntToStr(getMaxID)+','+QuotedStr((Components[i] as TNumEdit).Text)+')';
         SQLQuery1.ExecSQL(true);
        end;
      end;
      //--- end of loop ..

Except
 on E : Exception do
ShowMessage(E.Message);
end;

end;

end.
