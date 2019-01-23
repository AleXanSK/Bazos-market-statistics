unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker,  Forms, Controls,
  Graphics, Dialogs, Menus, StdCtrls, ExtCtrls;

type

  { TForm1 }
  nazvy_stat = record
    typ:string;
    id:integer;
    kod:integer;
    mnozstvo:integer;
    cena:integer;
    meno:string;
   end;
  nazvy_top = record
    meno:string;
    kod:integer;
    zisk:integer;
    naklad:integer;
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
    procedure nacitanie;
  private

  public

  end;

var
  Form1: TForm1;
  ver_stati:integer; //verzie databaz
  ver_tovar:integer; //

  stats:array[1..100] of nazvy_stat; //hlavne pole databaz
  stats_length:integer;              //dlžka pola (kolko riadkov)

  top:array[1..100] of nazvy_top;     //Zoradene produkty od naj po najmenej
  top_length:integer;                 //Počet produktov

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var pom_s:string;                   //pomocna pri nacitani
    i,j,temp:integer;
    test:boolean;
begin
memo1.clear;
nacitanie;



//Bubble sortik z netu (prosim funguj)
{
 For i := stats_length-1 DownTo 1 do
 		For j := 2 to i do
 			If (stats[j-1] > stats[j]) Then
 			Begin
 				temp := stats[j-1];
 				stats[j-1] := stats[j];
 				stats[j] := temp;
 			End;
}
end;

procedure TForm1.PodlakoduClick(Sender: TObject);
begin
memo1.clear;
end;

procedure TForm1.PodlamenaClick(Sender: TObject);
begin
memo1.clear;
end;

procedure TForm1.Top10Click(Sender: TObject);
var
    i:integer;
begin
memo1.clear;
for i:=stats_length downto 1 do begin
   // memo1.append(IntTostr(stats[i].mozstvo)+' '+

end;

end;

procedure TForm1.poT10Click(Sender: TObject);
begin
memo1.clear;
end;

procedure TForm1.nacitanie;
var subor:textfile;
    pom_s:string;                   //pomocna pri nacitani
    i,j,temp:integer;
begin
FileCreate('statistiky_lock.txt'); //zmakne databazu
Assignfile(subor,'statistiky.txt');
Reset(subor);
Readln(subor,pom_s);
stats_length:=strtoint(pom_s);

for i:=1 to stats_length do begin
      ReadLn(subor,pom_s); //N;12345678;111;12;100   -priklad


      stats[i].typ:=Copy                             (pom_s,1,1); //vždy len jeden znak
      Delete                                         (pom_s,1,1+1);

      stats[i].id:=StrToInt(Copy                     (pom_s,1,8)); //vždy 8 znakov
      Delete                                         (pom_s,1,8+1);

      stats[i].kod:=StrToInt(Copy                    (pom_s,1,3)); //vždy len tri znaky
      Delete                                         (pom_s,1,3+1);

 stats[i].mnozstvo:=StrToInt(Copy                    (pom_s,1,Pos(';',pom_s)-1));
      Delete                                         (pom_s,1,Pos(';',pom_s));

      stats[i].cena:=StrToInt(Copy                   (pom_s,1,Length(pom_s)));
      end; //KONIEC načítania statistik
CloseFile(subor);
DeleteFile('statistiky_lock.txt');

end;


end.

