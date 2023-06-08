unit Telef;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit,System.Math;

type
  TCodigo = class(TForm)
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditCorreoT: TEdit;
    Label3: TLabel;
    EditTelefonoR: TEdit;
    BtnEnviarR: TButton;
    Label4: TLabel;
    Label5: TLabel;
    EditCodigoT: TEdit;
    btnGuardarC: TButton;
    CheckCodigo: TCheckBox;
    procedure Button3Click(Sender: TObject);
    procedure BtnEnviarRClick(Sender: TObject);
    procedure btnGuardarCClick(Sender: TObject);
  private
    { Private declarations }
    function ValidatePassword(const Password: string): Boolean;
  public
    { Public declarations }
  end;

var
  Codigo: TCodigo;
  NumeroAleatorio: Integer;

implementation
uses UMain, Registro, Resset;

{$R *.fmx}

procedure TCodigo.BtnEnviarRClick(Sender: TObject);
begin
if frmMain.tblUsuario.Locate('correoE', EditCorreoT.Text, []) then
  begin
    // Se encontró el registro con el correo electrónico
    if frmMain.tblUsuario.Locate('correoE;telefono', VarArrayOf([EditCorreoT.Text, EditTelefonoR.Text]), []) then
    begin
      ShowMessage('¡Se ha enviado un SMS!');

      //Codigo para mandar SMS


      Label2.Visible:= False;
      Label3.Visible:= False;
      EditCorreoT.Visible:= False;
      EditTelefonoR.Visible:= False;
      Label5.Visible:= True;
      EditCodigoT.Visible:= True;
      BtnEnviarR.Visible:= False;
      btnGuardarC.Visible:= True;

      Randomize; // Inicializa la semilla aleatoria

    // Genera un número aleatorio en el rango de 1 a 100
      NumeroAleatorio := RandomRange(1000, 9999);

      ShowMessage('Número aleatorio: ' + IntToStr(NumeroAleatorio));
    end
    else
      ShowMessage('Los datos no coinciden')
  end
  else
      ShowMessage('El correo no existe');
      EditTelefonoR.Text:= '';
      //EditCorreoT.Text:= '';
end;

procedure TCodigo.btnGuardarCClick(Sender: TObject);
  var numA: string;
  var Valid: Boolean;
begin
  numA:= IntToStr(NumeroAleatorio);
  if (EditCodigoT.Text = numA) then
  begin
    //ShowMessage('Reset password');
    Valid:= ValidatePassword(numA);
    if CheckCodigo.IsChecked= True then
    begin
      btnGuardarC.Visible:= True;
        {$IF DEFINED(MSWINDOWS)}
          RessetU.ShowModal;
        {$ELSE}
          RessetU.Show;
        {$ENDIF}
    end
    else
      ShowMessage('Codigo incorrecto');
  end;
end;

function TCodigo.ValidatePassword(const Password: string): Boolean;
begin
  //ShowMessage('Codigo validado');
  Result := Password = Password;
  CheckCodigo.IsChecked:= True;
end;

procedure TCodigo.Button3Click(Sender: TObject);
begin
  Close;
end;

end.
