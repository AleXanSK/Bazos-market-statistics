unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, TAGraph, Forms, Controls,
  Graphics, Dialogs, Menus, StdCtrls, ExtCtrls;

type

  { TForm1 }
  nazvy_stat = record
    typ:string;
    id:integer;
    //TU SI SKONČIL
  end;

  TForm1 = class(TForm)
    Filter: TButton;
    Memo1: TMemo;
    MenuItem2: TMenuItem;
    Podlamena: TMenuItem;
    Podlakodu: TMenuItem;
    Vytvaranie_TOP: TTimer;
    Zobrazujem: TLabel;
    Reload: TButton;
    Chart1: TChart;
    Ine: TCheckBox;
    Priemercena: TLabel;
    Label2: TLabel;
    Pecivo: TCheckBox;
    Ovocie: TCheckBox;
    Kontrola_suborov: TTimer;
    Zelenina: TCheckBox;
    Oddatum: TDateTimePicker;
    PoDatum: TDateTimePicker;
    trzby: TLabel;
    naklady: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    Top10: TMenuItem;
    poT10: TMenuItem;
    MenuItem4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PodlakoduClick(Sender: TObject);
    procedure PodlamenaClick(Sender: TObject);
    procedure poT10Click(Sender: TObject);
    procedure Top10Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
memo1.clear;


end;

procedure TForm1.PodlakoduClick(Sender: TObject);
begin

end;

procedure TForm1.PodlamenaClick(Sender: TObject);
begin

end;

procedure TForm1.Top10Click(Sender: TObject);
begin

end;

procedure TForm1.poT10Click(Sender: TObject);
begin

end;



end.

