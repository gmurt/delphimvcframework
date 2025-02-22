unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, MVCFramework.RESTClient.Intf, MVCFramework.RESTClient,
  Vcl.DBCtrls, MVCFramework.DataSet.Utils;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    dsArticles: TFDMemTable;
    dsArticlesid: TIntegerField;
    dsArticlescode: TStringField;
    dsArticlesdescription: TStringField;
    dsArticlesprice: TCurrencyField;
    dsrcArticles: TDataSource;
    DBNavigator1: TDBNavigator;
    btnOpen: TButton;
    btnRefreshRecord: TButton;
    Button1: TButton;
    Panel2: TPanel;
    EditFilter: TEdit;
    Label1: TLabel;
    btnFilter: TButton;
    dsArticlescreated_at: TDateTimeField;
    dsArticlesupdated_at: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRefreshRecordClick(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
  private
    fFilter: string;
    fLoading: Boolean;
    fRESTClient: IMVCRESTClient;
    fAPIBinder: TMVCAPIBinder;
    { Private declarations }
    procedure ShowError(const AResponse: IMVCRESTResponse);
    procedure SetFilter(const Value: string);
  public
    property Filter: string read fFilter write SetFilter;
  end;

var
  MainForm: TMainForm;

implementation

uses
  System.UITypes;

{$R *.dfm}


procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  dsArticles.Close;
end;

procedure TMainForm.btnFilterClick(Sender: TObject);
begin
  dsArticles.Close;
  Filter := EditFilter.Text;;
  dsArticles.Open;
end;

procedure TMainForm.btnOpenClick(Sender: TObject);
begin
  dsArticles.Close;
  Filter := '';
  dsArticles.Open;
end;

procedure TMainForm.btnRefreshRecordClick(Sender: TObject);
begin
  dsArticles.RefreshRecord;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fAPIBinder.Free;
  fRESTClient := nil;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fRESTClient := TMVCRESTClient.New.BaseURL('localhost', 8080);
  fAPIBinder := TMVCAPIBinder.Create(fRESTClient);
  fAPIBinder.BindDataSetToAPI(dsArticles, '/articles', 'id');
end;

procedure TMainForm.SetFilter(const Value: string);
begin
  fFilter := Value;
  EditFilter.Text := Value;
end;

procedure TMainForm.ShowError(const AResponse: IMVCRESTResponse);
begin
  if not AResponse.Success then
    MessageDlg(
      AResponse.StatusCode.ToString + ': ' + AResponse.StatusText + sLineBreak +
      '[' + AResponse.Content + ']',
      mtError, [mbOK], 0)
  else
    MessageDlg(
      AResponse.StatusCode.ToString + ': ' + AResponse.StatusText + sLineBreak +
      AResponse.Content,
      mtError, [mbOK], 0);
end;

end.
