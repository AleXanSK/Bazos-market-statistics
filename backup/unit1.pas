unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker,  Forms, Controls,
  Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, LazFileUtils;

type

  { TForm1 }
  nazvy_stat = record
    typ:string;
    id:integer;
    kod:integer;
    mnozstvo:integer;
    cena:integer;
    meno:string;
    datum:integer;
   end;
  nazvy_top = record
    meno:string;
    kod:integer;
    prijmy:integer;
    naklad:integer;
    zisk:integer;
  end;

  TForm1 = class(TForm)
    Filter: TButton;
    zisk: TLabel;
    Memo1: TMemo;
    MenuItem2: TMenuItem;
    Podlamena: TMenuItem;
    Podlakodu: TMenuItem;
    Vytvaranie_TOP: TTimer;
    Zobrazujem: TLabel;
    Reload: TButton;
    filter4: TCheckBox;
    Priemercena: TLabel;
    priemerkvantita: TLabel;
    filter3: TCheckBox;
    filter1: TCheckBox;
    Kontrola_suborov: TTimer;
    filter2: TCheckBox;
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
    procedure ReloadClick(Sender: TObject);
    procedure Top10Click(Sender: TObject);
    procedure nacitanie;
    procedure sort;
    procedure top;
  private

  public

  end;

var
  Form1: TForm1;
  ver_stati:integer; //verzie databaz
  ver_tovar:integer; //

  stats:array[1..100] of nazvy_stat; //hlavne pole databaz
  stats_length:integer;              //dlžka pola (kolko riadkov)

  topp:array[1..100] of nazvy_top;     //Zoradene produkty od naj po najmenej
  top_length:integer;                 //Počet produktov

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
begin
memo1.clear;
//Vyčistenie polí

 for i:=1 to 100 do begin
       stats[i].id:=0;
       stats[i].kod:=0;
       stats[i].mnozstvo:=0;
       stats[i].cena:=0;
       topp[i].kod:=0;
       topp[i].prijmy:=0;
       topp[i].naklad:=0;
       topp[i].zisk:=0;
 end;

NACITANIE;
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
for i:=1 to 10 do begin
  memo1.append(inttostr(i)+'.  '+topp[i].meno+' má aktualne prijmy: '+IntToStr(topp[i].prijmy)+' má naklady '+IntToStr(topp[i].naklad)+' s celkovym ziskom: '+IntToStr(topp[i].zisk));
end;
zobrazujem.caption:='Zobrazujem: Top 10 najpredavánejších produktov';

end;

procedure TForm1.poT10Click(Sender: TObject);
var i:integer;
begin
memo1.clear;
for i:=top_length downto top_length-10 do begin
  memo1.append(inttostr(i)+'.  '+topp[i].meno+' má aktualne prijmy: '+IntToStr(topp[i].prijmy)+' má naklady '+IntToStr(topp[i].naklad)+' s celkovym ziskom: '+IntToStr(topp[i].zisk));
end;
zobrazujem.caption:='Zobrazujem: Top 10 najmenej predávaných produktov';
end;

procedure TForm1.ReloadClick(Sender: TObject);
begin
memo1.clear;
  nacitanie;
end;

procedure TForm1.nacitanie;
var subor:textfile;
    pom_s,meno:string;                   //pomocna pri nacitani
    i,j,dlzka,kod:integer;
    F:longint;                           //potrebuje to funkcia filedelete()
    dokoncenenacitanie:boolean;
begin
dokoncenenacitanie:=false;


{STATISTIKY}

while not dokoncenenacitanie do begin
   if not FileExists('statistiky_lock.txt') then begin
     F:=FileCreate('statistiky_lock.txt'); //zmakne databazu
     Assignfile(subor,'statistiky.txt');
     Reset(subor);
     Readln(subor,pom_s);
     stats_length:=strtoint(pom_s);

     for i:=1 to stats_length do begin
           ReadLn(subor,pom_s); //N;12345678;111;12;100;991231   -priklad


           stats[i].typ:=Copy                             (pom_s,1,1); //vždy len jeden znak
           Delete                                         (pom_s,1,1+1);

           stats[i].id:=StrToInt(Copy                     (pom_s,1,8)); //vždy 8 znakov
           Delete                                         (pom_s,1,8+1);

           stats[i].kod:=StrToInt(Copy                    (pom_s,1,3)); //vždy len tri znaky
           Delete                                         (pom_s,1,3+1);

           stats[i].mnozstvo:=StrToInt(Copy               (pom_s,1,Pos(';',pom_s)-1));
           Delete                                         (pom_s,1,Pos(';',pom_s));

           stats[i].cena:=StrToInt(Copy                   (pom_s,1,Pos(';',pom_s)-1));
           Delete                                         (pom_s,1,Pos(';',pom_s));

           stats[i].datum:=StrToInt(Copy                  (pom_s,1,Length(pom_s)));
           end;
     CloseFile(subor);
     FileClose(F);
     DeleteFile('statistiky_lock.txt');
     dokoncenenacitanie:=true;
   end;
end; //KONIEC načítania statistik


dokoncenenacitanie:=false;
{TOVAR}

while not dokoncenenacitanie do begin
   if not FileExists('tovar_lock.txt') then begin
     Assignfile(subor,'tovar.txt'); //ZACIATOK nacitania tovar (meno)
     F:=FileCreate('tovar_lock.txt'); //zamkne tovar
     Reset(subor);
     Readln(subor,pom_s);
     dlzka:=strtoint(pom_s); //zisti velkost tovar.txt
     top_length:=dlzka;      //da tu hodnotu aj do arraju top
     for i:=1 to dlzka do begin
           ReadLn(subor,pom_s); //nacita prvy riadok do pomocnych kod a meno
           kod:=StrtoInt(Copy(pom_s,1,3));
           Delete(pom_s,1,4);
           meno:=Copy(pom_s,1,Length(pom_s));
           for j:=1 to stats_length do begin    //prehlada pole stats a prida meno ku kodu
                    if (kod = stats[i].kod) then stats[i].meno:=meno;
                 end;

           topp[i].meno:=meno;
           topp[i].kod:=kod;

           end; //KONIEC načítania statistik
     CloseFile(subor);
     FileClose(F);
     DeleteFile('tovar_lock.txt');
     dokoncenenacitanie:=true;
   end;
end;
sort;


dokoncenenacitanie:=false;
  {KATEGORIE}

while not dokoncenenacitanie do begin
   if not FileExists('kategorie_lock.txt') then begin
     AssignFile(subor,'kategorie.txt'); //Nacitanie KATEGORIE
     F:=FileCreate('kategorie_lock.txt');
     Reset(subor);

     ReadLn(subor,pom_s);
     filter1.caption:=Copy(pom_s,3,Length(pom_s)-2); //Filter 1
     ReadLn(subor,pom_s);
     filter2.caption:=Copy(pom_s,3,Length(pom_s)-2); //Filter 2
     ReadLn(subor,pom_s);
     filter3.caption:=Copy(pom_s,3,Length(pom_s)-2); //Filter 3
     ReadLn(subor,pom_s);
     filter4.caption:=Copy(pom_s,3,Length(pom_s)-2); //Filter 4

     CloseFile(subor);
     FileClose(F);
     DeleteFile('kategorie_lock.txt');
     dokoncenenacitanie:=true;
   end;
end;
end;


procedure TForm1.sort;
var i,j,temp_kod,temp_prijmy,temp_naklad,temp_zisk:integer;
    temp_meno:string;
begin
top;
//Bubble sortik z netu (prosim funguj)
  For i:=1 to top_length do topp[i].zisk:=(topp[i].prijmy-topp[i].naklad); //spraví zisk pre každy tovar

  For i := top_length-1 DownTo 1 do
  		For j := 2 to i do
  			If (topp[j-1].zisk > topp[j].zisk) Then
  			Begin
                                temp_kod   := topp[j-1].kod;
                                temp_prijmy:= topp[j-1].prijmy;
                                temp_naklad:= topp[j-1].naklad;
                                temp_zisk  := topp[j-1].zisk;
                                temp_meno  := topp[j-1].meno;

  				topp[j-1].kod   := topp[j].kod;
                                topp[j-1].prijmy:= topp[j].prijmy;
                                topp[j-1].naklad:= topp[j].naklad;
                                topp[j-1].zisk  := topp[j].zisk;
                                topp[j-1].meno  := topp[j].meno;



  				topp[j].kod     := temp_kod;
                                topp[j].prijmy  := temp_prijmy;
                                topp[j].naklad  := temp_naklad;
                                topp[j].zisk    := temp_zisk;
                                topp[j].meno    := temp_meno;


  			End;


end;


procedure TForm1.top; {Pridava celkove naklady a celkove prijmy do top[i]}
var i,j:integer;
    naklady_p,trzby_p,zisk_p,priemerna_cena,priemerna_kvantita:integer;
    suma_nakupov,pocet_nakupov,id_nakupu,pocet_v_nakupe:integer;
    priemer_predaj, priemer_kvantita:real;
begin
  for i:=1 to stats_length do begin
     for j:=1 to top_length do begin
        if stats[i].typ = 'N' then
        begin
          if (stats[i].kod = topp[j].kod) then begin
             topp[j].naklad:=stats[i].mnozstvo*stats[i].cena;
          end;

        end;

        if stats[i].typ = 'P' then
           begin
          if (stats[i].kod = topp[j].kod) then begin
             topp[j].prijmy:=stats[i].mnozstvo*stats[i].cena;
           end;
        end;
     end;
  end;


  //Dava celkove naklady a nakup a zisk
  naklady_p:=0;trzby_p:=0;zisk_p:=0;priemerna_cena:=0;priemerna_kvantita:=0; //inicializacia premennych
  for i:=1 to top_length do begin
     naklady_p:=naklady_p+topp[i].naklad;
     trzby_p:=trzby_p+topp[i].prijmy;

  end;
     trzby.caption:=         'Tržby: '+InttoStr(trzby_p);
     naklady.caption:=       'Náklady: '+IntToStr(naklady_p);
     zisk.caption:=          'Zisk: '+IntToStr(trzby_p-naklady_p);



  //Priemer
  suma_nakupov:=0;
  pocet_nakupov:=0;
  priemer_predaj:=0;
  priemer_kvantita:=0;
  pocet_v_nakupe:=0;
  for i:=1 to stats_length do begin //Priemer celkovy
     if stats[i].typ = 'P' then begin
       suma_nakupov:=suma_nakupov+stats[i].cena*stats[i].mnozstvo;
       inc(pocet_nakupov);
     end;
  end;
  priemer_predaj:=suma_nakupov div pocet_nakupov;
  priemercena.caption:='Priemerna cena nakupu: '+FloattoStr(priemer_predaj);

   i:=1;
   while i < stats_length do begin //priemer nakupov
      if stats[i].typ = 'P' then begin
         id_nakupu:=stats[i].id;
         inc(pocet_nakupov);
         while id_nakupu <> stats[i].id do begin
            pocet_v_nakupe:=pocet_v_nakupe+stats[i].mnozstvo;
            inc(i);
         end;
      end;
      inc(i);
   end;

   priemer_kvantita:=pocet_v_nakupe div pocet_nakupov;
   priemerkvantita.caption:='Priemerna kvantita nakupu: '+FloatToStr(priemer_kvantita);


end;

end.

