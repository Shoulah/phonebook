unit uEditContact;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uUpperCaseFirst, StdCtrls, unumEdit, FMTBcd, DB, SqlExpr;

type
  TFrEditContact = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button1: TButton;
    NumEdit1: TNumEdit;
    NumEdit2: TNumEdit;
    NumEdit3: TNumEdit;
    NumEdit4: TNumEdit;
    NumEdit5: TNumEdit;
    Edit1: TUpperCaseEdit;
    Edit2: TUpperCaseEdit;
    SQLQuery1: TSQLQuery;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

    { Private declarations }
  public
     procedure execute;
     procedure DeleteContact(Contact_Id : string);
     procedure UpdateContact(Contact_Id : string);
     function isRequiredFieldsEmpty : Boolean;
      var
       myContact_id : string;
    { Public declarations }
  end;

var
  FrEditContact: TFrEditContact;

implementation

uses uMain;

{$R *.dfm}

procedure TFrEditContact.Button1Click(Sender: TObject);
begin
 if not isRequiredFieldsEmpty then
 
if MessageDlg('Do you want save changes?',mtConfirmation,mbYesNo,0) = mrYes then
begin
UpdateContact(myContact_id);
ShowMessage('Contact update successfully');
self.Close;
end;
end;

procedure TFrEditContact.Button2Click(Sender: TObject);
begin
if MessageDlg('Do you want delete '+Edit1.Text+' '+Edit2.Text,
                                mtConfirmation,mbYesNo,0) = mrYes then
begin
  DeleteContact(myContact_id);
  FrMain.ClientDataSet1.Refresh;
  Self.Close;
end;
end;

procedure TFrEditContact.DeleteContact(Contact_Id: string);
var
 myQuery : TSQLQuery;
begin
 myQuery := TSQLQuery.Create(nil);
 try
   myQuery.SQLConnection := FrMain.SQLConnection1;
   myQuery.SQL.Text := 'delete from contacts';
   myQuery.SQL.Add('where id ='+QuotedStr(Contact_Id));
   myQuery.ExecSQL(True);
   myQuery.SQL.Clear;
   myQuery.SQL.Text := 'delete from phone_no';
   myQuery.SQL.Add('where id ='+QuotedStr(Contact_Id));
   myQuery.ExecSQL(True);
 finally
    myQuery.Free;
 end;
end;

procedure TFrEditContact.Execute;
var
 I : Integer;
 X : Integer;
begin
SQLQuery1.Close;
SQLQuery1.SQL.Text := 'select * from contacts';
SQLQuery1.SQL.Add('where id ='+QuotedStr(myContact_id));
SQLQuery1.Open;
Edit1.Text := Trim(SQLQuery1.FieldByName('f_name').AsString);
Edit2.Text := Trim(SQLQuery1.FieldByName('l_name').AsString);
SQLQuery1.Close;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Text := 'select  * from phone_no';
SQLQuery1.SQL.Add('where id = '+QuotedStr(myContact_id));
SQLQuery1.Open;
x := 1;
while not SQLQuery1.eof do
begin
for I := 0 to ComponentCount - 1 do
  if (Components[I] as TComponent).Name = 'NumEdit'+IntToStr(X) then
     (Components[i] as TEdit).Text := Trim(SQLQuery1.FieldByName('phone_number').AsString);
    Inc(x);
    SQLQuery1.Next;
end;
ShowModal;
end;

procedure TFrEditContact.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrMain.Edit1.OnChange(Self);
end;

function TFrEditContact.isRequiredFieldsEmpty: Boolean;
begin

if Trim(Edit1.Text) = '' then
begin
  ShowMessage('Please enter contact name');
  Result := True;
  Exit;
end;
if trim(NumEdit1.Text) = '' then
begin
  ShowMessage('please enter phone number');
  Result := True;
  Exit;
end;
Result := False;
end;

procedure TFrEditContact.UpdateContact(Contact_Id: string);
var
 myQuery : TSQLQuery;
 I : Integer;
begin
  myQuery := TSQLQuery.Create(nil);
 try
   myQuery.SQLConnection := FrMain.SQLConnection1;
   myQuery.SQL.Text := 'update contacts set f_name='+QuotedStr(Edit1.Text)+
                                               ',l_name='+QuotedStr(Edit2.Text);
   myQuery.SQL.Add('where id ='+QuotedStr(Contact_Id));
   myQuery.ExecSQL(True);
   myQuery.SQL.Clear;
   myQuery.SQL.Text := 'delete from phone_no';
   myQuery.SQL.Add('where id ='+QuotedStr(Contact_Id));
   myQuery.ExecSQL(True);
   for I := 0 to ComponentCount -1 do
  begin
   if Components[i].ClassType = TNumEdit then
        if Trim((Components[i] as TNumEdit).Text) <> '' then
        begin
         SQLQuery1.Close;
         SQLQuery1.SQL.Clear;
         SQLQuery1.SQL.Text:='insert into phone_no (id, phone_number) values ('+
         Contact_Id +','+QuotedStr((Components[i] as TNumEdit).Text)+')';
         SQLQuery1.ExecSQL(true);
        end;
  end;
 finally
    myQuery.Free;
 end;
end;

end.
