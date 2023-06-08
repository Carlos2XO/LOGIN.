unit Resset;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, RegularExpressions;

type
  TRessetU = class(TForm)
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditCorreoR: TEdit;
    Label3: TLabel;
    EditContrase�aR: TEdit;
    BtnGuardarR: TButton;
    check8R: TCheckBox;
    checkMinR: TCheckBox;
    checkMayR: TCheckBox;
    checkCER: TCheckBox;
    procedure Button3Click(Sender: TObject);
    procedure BtnGuardarRClick(Sender: TObject);
  private
    { Private declarations }
    function ValidatePassword(const Password: string): Boolean;
  public
    { Public declarations }
  end;

var
  RessetU: TRessetU;

implementation

{$R *.fmx}

uses UMain;

procedure TRessetU.BtnGuardarRClick(Sender: TObject);
var
  Password: string;
  Valid: Boolean;
begin
  if ((EditCorreoR.Text <> '') and (EditContrase�aR.Text <> '')) then
  begin
    if (EditContrase�aR.Text.Length < 8) then
    begin
      check8R.IsChecked := False;
      ShowMessage('La contrase�a debe ser mayor a 8 caracteres')
    end
    else
      check8R.IsChecked := True;
    Password := EditContrase�aR.Text;
    // Obtener la contrase�a ingresada por el usuario

    // Validar la contrase�a
    Valid := ValidatePassword(Password);

    if ((check8R.IsChecked = True) and (checkMinR.IsChecked = True) and
      (checkMayR.IsChecked = True) and (checkCER.IsChecked = True)) then

      if frmMain.tblUsuario.Locate('correoE', EditCorreoR.Text, []) then
      begin
        // Se encontr� el registro con el correo electr�nico

        // Actualizar la contrase�a
        frmMain.tblUsuario.Edit;
        frmMain.tblUsuario.FieldByName('contrasena').AsString := EditContrase�aR.Text;
        // Para guardar los cambios y actualizar la fuente de datos
        frmMain.tblUsuario.Post;

        ShowMessage('Contrase�a cambiada exitosamente');
        EditCorreoR.Text := '';
        EditContrase�aR.Text := '';

        check8R.IsChecked := False;
        checkMinR.IsChecked := False;
        checkMayR.IsChecked := False;
        checkCER.IsChecked := False;

        Close;
      end
      else
        ShowMessage('Correo electr�nico no registrado')
    else
      ShowMessage('Contrase�a invalida')
  end
  else
    ShowMessage('llena todos los campos')
end;

function TRessetU.ValidatePassword(const Password: string): Boolean;
var
  Min: TRegEx;
  Max: TRegEx;
  CE: TRegEx;
  Regex: TRegEx;
begin
  // Expresi�n regular para validar una letra may�scula y una letra min�scula
  // Regex := TRegEx.Create('^(?=.*[a-z])(?=.*[A-Z])(?=.*\W).*$');

  Min := TRegEx.Create('^(?=.*[a-z]).*$');
  Max := TRegEx.Create('^(?=.*[A-Z]).*$');
  CE := TRegEx.Create('^(?=.*\W).*$');

  // Result := Min.IsMatch(Password);

  if Min.IsMatch(Password) then
    checkMinR.IsChecked := True
  else
    checkMinR.IsChecked := False;
  if Max.IsMatch(Password) then
    checkMayR.IsChecked := True
  else
    checkMayR.IsChecked := False;
  if CE.IsMatch(Password) then
    checkCER.IsChecked := True
  else
    checkCER.IsChecked := False;
end;

procedure TRessetU.Button3Click(Sender: TObject);
begin
  EditCorreoR.Text := '';
  EditContrase�aR.Text := '';

  Close;
end;

end.
