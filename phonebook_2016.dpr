program phonebook_2016;

uses
  Forms,
  uMain in 'uMain.pas' {FrMain},
  uAddContact in 'uAddContact.pas' {FrAddContact},
  uEditContact in 'uEditContact.pas' {FrEditContact};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrMain, FrMain);
  Application.Run;
end.
