unit Registro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.DialogService, // Para los Dialogos.
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, RegularExpressions, FMX.Objects;

type
  TRegistroU = class(TForm)
    Label1: TLabel;
    BtnAtras: TButton;
    ENombres: TEdit;
    EApellidoP: TEdit;
    EApellidoM: TEdit;
    ECorreo: TEdit;
    EPassword: TEdit;
    BtnRegistrarme: TButton;
    check8: TCheckBox;
    checkMin: TCheckBox;
    checkMay: TCheckBox;
    checkCE: TCheckBox;
    ToolBar1: TToolBar;
    Panel1: TPanel;
    Label8: TLabel;
    Panel2: TPanel;
    ENoCelular: TEdit;
    MostrarPassword: TCheckBox;
    EConfiPassword: TEdit;
    procedure BtnRegistrarmeClick(Sender: TObject);
    // procedure BtnAtrasClick(Sender: TObject);
    procedure MostrarPasswordChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnAtrasClick(Sender: TObject);
    procedure EPasswordKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ToolBar1Click(Sender: TObject);

  private
    { Private declarations }
    procedure ValidarPassword(const Password: string);
  public
    { Public declarations }
  end;

var
  RegistroU: TRegistroU;
  varDialogo: Boolean;

implementation

uses UMain;

{$R *.fmx}

// Inisializar las variables que se necesitan al crear el frm.
procedure TRegistroU.BtnAtrasClick(Sender: TObject);
begin
  varDialogo := false;
  close;
end;

procedure TRegistroU.BtnRegistrarmeClick(Sender: TObject);
var
  varPassword: string;
begin
  if ((ENombres.Text <> '') and (EApellidoP.Text <> '') and
    (EApellidoM.Text <> '') and (ECorreo.Text <> '') and (EPassword.Text <> '')
    and (EConfiPassword.Text <> '') and (ENoCelular.Text <> '')) then
  begin
    if EPassword.Text = EConfiPassword.Text then
    begin
      // Las contrase�as coinciden
      varPassword := EPassword.Text; // Obtener contrase�a ingresada.

      if ((check8.IsChecked = true) and (checkMin.IsChecked = true) and
        (checkMay.IsChecked = true) and (checkCE.IsChecked = true)) then
      begin
        try
          frmMain.tblUsuario.Append;
          frmMain.tblUsuario.FieldByName('nombre').Value := ENombres.Text;
          frmMain.tblUsuario.FieldByName('apellidoP').Value := EApellidoP.Text;
          frmMain.tblUsuario.FieldByName('apellidoM').Value := EApellidoM.Text;
          frmMain.tblUsuario.FieldByName('correoE').Value := ECorreo.Text;
          frmMain.tblUsuario.FieldByName('contrasena').Value := EPassword.Text;
          frmMain.tblUsuario.FieldByName('telefono').Value := ENoCelular.Text;
          frmMain.tblUsuario.Post;

          ShowMessage
            ('�Felicidades! El registro se ha realizado con �xito. �Bienvenido/a a nuestro sistema! Ahora puedes disfrutar los servicios disponibles.');
          ENombres.Text := '';
          EApellidoP.Text := '';
          EApellidoM.Text := '';
          ECorreo.Text := '';
          EPassword.Text := '';
          EConfiPassword.Text := '';
          ENoCelular.Text := '';

          check8.IsChecked := false;
          checkMin.IsChecked := false;
          checkMay.IsChecked := false;
          checkCE.IsChecked := false;
          close;
        except
          on E: EDatabaseError do
          begin
            ShowMessage
              ('Lo siento, pero el Correo que has ingresado ya est� en uso. Por favor, elige un correo diferente para continuar.');
            ECorreo.Text := '';
            frmMain.tblUsuario.Cancel;
          end
        end;
      end
      else
      begin
        ShowMessage
          ('La contrase�a ingresada es incorrecta. Por favor, verifica y vuelve a intentarlo.')
      end;
    end
    else
    begin
      // Las contrase�as no coinciden
      ShowMessage
        ('Las contrase�as no coinciden. Por favor, int�ntalo de nuevo');
    end;
  end
  else
  begin
    ShowMessage
      ('No has introducido los datos necesarios. Por favor, proporciona la informaci�n solicitada')
  end;
end;

// Validar la contrase�a:
// Valida el password constantemente que se presiona una tecla en el edit.
procedure TRegistroU.EPasswordKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin

  ValidarPassword(EPassword.Text);
end;

procedure TRegistroU.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (ENombres.Text = '') and (EApellidoP.Text = '') and (EApellidoM.Text = '')
    and (ECorreo.Text = '') and (EPassword.Text = '') and
    (EConfiPassword.Text = '') and (ENoCelular.Text = '') then
  begin
    varDialogo := true;
  end
  else
  begin
    TDialogService.MessageDialog
      ('�Est�s seguro/a de que deseas salir sin guardar? Toda la informaci�n no guardada se perder�.',
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
      TMsgDlgBtn.mbNo, 0,
      procedure(const AResult: TModalResult)
      begin
        case AResult of
          mrYES:
            begin
              // Limpiar campos y salir.
              ENombres.Text := '';
              EApellidoP.Text := '';
              EApellidoM.Text := '';
              ENoCelular.Text := '';
              ECorreo.Text := '';
              EPassword.Text := '';
              EConfiPassword.Text := '';

              check8.IsChecked := false;
              checkMin.IsChecked := false;
              checkMay.IsChecked := false;
              checkCE.IsChecked := false;
              varDialogo := true; // Salir.
{$IF DEFINED(ANDROID)}
              close;
{$ENDIF}
            end;

          mrNo:
            begin
              varDialogo := false; // Permanece en la ventana.
            end;

        end; // Fin del case.

      end); // Fin del Dialogo.

  end; // Fin del if.

  CanClose := varDialogo;
end;

// Si el usuario preciona vkHardwareBack del movil.
procedure TRegistroU.FormKeyUp(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    varDialogo := false;
    // close;
  end;
end;

// Para mostrar la contrase�a escrita por el usuario.
procedure TRegistroU.MostrarPasswordChange(Sender: TObject);
begin
  EPassword.Password := not MostrarPassword.IsChecked;
  EConfiPassword.Password := not MostrarPassword.IsChecked;
end;

procedure TRegistroU.ToolBar1Click(Sender: TObject);
begin

end;

// Para verificar que la contrase�a cumpla con los requerimientos.
procedure TRegistroU.ValidarPassword(const Password: string);
var
  varLetraMinuscula: TRegEx;
  varLetraMayuscula: TRegEx;
  varCaracterEspecial: TRegEx;
begin

  // Expresi�n regular para validar una letra min�scula
  varLetraMinuscula := TRegEx.Create('^(?=.*[a-z]).*$');
  // Expresi�n regular para validar una letra may�scula
  varLetraMayuscula := TRegEx.Create('^(?=.*[A-Z]).*$');
  // Expresi�n regular para validar un caracter especial.
  varCaracterEspecial := TRegEx.Create('^(?=.*\W).*$');

  if varLetraMinuscula.IsMatch(Password) then
    checkMin.IsChecked := true
  else
    checkMin.IsChecked := false;
  if varLetraMayuscula.IsMatch(Password) then
    checkMay.IsChecked := true
  else
    checkMay.IsChecked := false;
  if varCaracterEspecial.IsMatch(Password) then
    checkCE.IsChecked := true
  else
    checkCE.IsChecked := false;
  if Password.Length >= 8 then
    check8.IsChecked := true
  else
    check8.IsChecked := false;
end;

end.
