{ ***********************
   CHRISTIAN ADRIANO
********************** }

unit uProg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  PointOpiniaoFilmes = ^TOpiniaoFilmes;
  TOpiniaoFilmes = record
    Opiniao: Integer; { (1) �timo, (2) bom, (3) regular, (4) ruim, (5) p�ssimo.}
    Filme: String[100];
    Proximo: PointOpiniaoFilmes;
  end;

  TEstruturaFilmes = class
  private
    primeiro: PointOpiniaoFilmes;
    ultimo: PointOpiniaoFilmes;
    Nodo: PointOpiniaoFilmes;
    function carregarDados(aux: PointOpiniaoFilmes): TStrings; overload;
  public
    constructor Create();
    destructor Destroy();

    function IncluiOpinicao(Filme: String; Opiniao: Integer): Boolean;
    function RemoveOpinicao(Opiniao: Integer; Filme: String): Boolean;
    function RemoveTodos(): Boolean;
    function carregarDados: TStrings; overload;
    function GetDescricaoOpnicao(Opinicao: Integer): String;

    function PesquisaQuantidade(Opiniao: Integer): Integer;overload;
    function PesquisaQuantidade(): Integer; overload;
    function CalculaPercentual(Opiniao: Integer): Real;
  end;

  TfrmApp = class(TForm)
    edNomeFilme: TEdit;
    Label3: TLabel;
    rgOpiniao: TRadioGroup;
    Panel1: TPanel;
    btAdd: TBitBtn;
    btResultado: TBitBtn;
    btSair: TBitBtn;
    mmLista: TMemo;
    Label1: TLabel;
    mmOpiniao: TMemo;
    Label2: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btResultadoClick(Sender: TObject);
  private
    Controle: TEstruturaFilmes;

    procedure LimpaCampos();
    function ValidarDados:Boolean;
  public
    { Public declarations }
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.dfm}

{ TEstruturaFilmes }

function TEstruturaFilmes.carregarDados(aux: PointOpiniaoFilmes): TStrings;
begin
   Result := TStringList.Create;
   Result.Add('Opini�o: ' + IntToStr(aux^.Opiniao) + ' -  ' + GetDescricaoOpnicao(aux^.Opiniao));
   Result.Add('Filmes: ' + aux^.Filme);
   Result.Add('------------------------------------------');
end;

function TEstruturaFilmes.CalculaPercentual(Opiniao: Integer): Real;
var
  QtdeGeral: Integer;
begin
  Result := 0;
  QtdeGeral := PesquisaQuantidade();
  if QtdeGeral > 0 then
    Result := (PesquisaQuantidade(Opiniao) * 100) / PesquisaQuantidade();
end;

function TEstruturaFilmes.carregarDados: TStrings;
var
   aux: PointOpiniaoFilmes;
begin
  Result := TStringList.Create;
  if (primeiro <> nil) then
  begin
    aux := primeiro;
    while (aux <> nil) do
    begin
        Result.AddStrings(carregarDados(aux));
        aux:= aux^.Proximo;
    end;
  end;
end;

constructor TEstruturaFilmes.Create;
begin
  primeiro := nil;
  ultimo   := nil;
  Nodo     := nil;
end;

destructor TEstruturaFilmes.Destroy;
begin
  RemoveTodos();
end;

function TEstruturaFilmes.GetDescricaoOpnicao(Opinicao: Integer): String;
begin
  case Opinicao of
    1: Result := '�timo';
    2: Result := 'bom';
    3: Result := 'regular';
    4: Result := 'ruim';
    5: Result := 'p�ssimo';
  else
    Result := 'N�o identificado';
  end;
end;

function TEstruturaFilmes.IncluiOpinicao(Filme: String; Opiniao: Integer): Boolean;
begin
  try
    new(Nodo);
    Nodo^.Opiniao := Opiniao;
    Nodo^.Filme := Filme;
    Nodo^.Proximo  := nil;

    if primeiro = nil then
    begin
      primeiro := Nodo;
    end
    else
      ultimo^.Proximo := Nodo;

    ultimo := Nodo;
    Result := true;
  except
    Result := false;
  end;
end;

function TEstruturaFilmes.PesquisaQuantidade: Integer;
Var
  aux : PointOpiniaoFilmes;
Begin
  Result := 0;
  Aux := primeiro;
  While aux <> nil do
  begin
    Result := Result + 1;
    aux := aux^.Proximo;
  end;
end;

function TEstruturaFilmes.PesquisaQuantidade(Opiniao: Integer): Integer;
Var
  aux : PointOpiniaoFilmes;
Begin
  Result := 0;
  Aux := primeiro;
  While aux <> nil do
  begin
    if (aux^.Opiniao = Opiniao) then
      Result := Result + 1;

    aux := aux^.Proximo;
  end;
end;

function TEstruturaFilmes.RemoveOpinicao(Opiniao: Integer; Filme: String): Boolean;
var
  aux, ant: PointOpiniaoFilmes;
begin
  Result := False;
  aux := primeiro;
  while (aux <> nil) and (aux^.Filme <> Filme) and (aux^.Opiniao <> Opiniao) do
  Begin
    ant := aux;
    aux := aux^.Proximo;
  end;
  if Aux = nil then
    exit;
  if Aux = Primeiro then
    Primeiro := Primeiro^.Proximo
  else
    if Aux = Ultimo then
    begin
      Ultimo := Ant;
      Ultimo^.Proximo := nil;
    end
    else
      Ant^.Proximo := Aux^.Proximo;
  Result := True;
  dispose(aux);
end;

function TEstruturaFilmes.RemoveTodos: Boolean;
var
  aux: PointOpiniaoFilmes;
Begin
  Result := False;
  try
    while primeiro <> nil do
    begin
      aux := primeiro;
      primeiro := primeiro^.Proximo;
      dispose(aux);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TfrmApp.btAddClick(Sender: TObject);
begin
  if (not ValidarDados) then
    exit;

  Controle.IncluiOpinicao(edNomeFilme.Text, rgOpiniao.ItemIndex+1);
  mmLista.Clear;
  mmLista.Lines.AddStrings(Controle.carregarDados);
  LimpaCampos();
  edNomeFilme.SetFocus;
end;

procedure TfrmApp.btResultadoClick(Sender: TObject);
var
  i: Integer;
begin
  mmOpiniao.Clear;
  for I := 1 to 5 do
    mmOpiniao.Lines.Add(Controle.GetDescricaoOpnicao(i) + ' - ' + FormatFloat('#,##0.00', Controle.CalculaPercentual(i))+ ' %');
end;

procedure TfrmApp.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmApp.FormCreate(Sender: TObject);
begin
  Controle := TEstruturaFilmes.Create();
  LimpaCampos();
  mmLista.Clear;
  mmOpiniao.Clear;
end;

procedure TfrmApp.FormDestroy(Sender: TObject);
begin
  Controle.RemoveTodos();
end;

procedure TfrmApp.LimpaCampos;
begin
  edNomeFilme.Clear;
  rgOpiniao.ItemIndex := -1;
end;

function TfrmApp.ValidarDados: Boolean;
begin
  result := true;

  if (edNomeFilme.Text = '') then
   begin
        ShowMessage('Informe o nome do Filme!');
        edNomeFilme.SetFocus;
        result := false;
        exit;
   end;

   if rgOpiniao.ItemIndex = -1 then
   begin
        ShowMessage('Selecione uma opini�o para o filme!');
        rgOpiniao.SetFocus;
        result := false;
        exit;
   end;
end;

end.
