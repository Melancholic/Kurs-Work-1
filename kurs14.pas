program KursWork_Nagorny;
(*объявление констант*)
const
    maxnumber=70000;
(*Объявление пользовательских типов*)
type
    arr= array of longint;

    menu1=(BINTREE,QSORT);
    menu2=(t250,t500,t1000,t2000,t4000,t8000,t16000);
    menu3=(SORTED,ASORTED,CHILD,RAND);
    tdirs =(left,right,up);

    table=record
        size:longint;
        Time: array[menu3] of extended;
    end;

    TableType=array [menu2] of table;
    
    PTreeType=^rectree;     

     rectree=record
        data:longint;
        left, right,up:PTreeType;
    end;
(*Объявление глобальных переменных*)
var
   IndPrintTree :longint;

(*Подключение библиотеки, для работы с сис. таймером*)

{$L timer.o}
Procedure init_timer; cdecl; external;
Function get_timer: longint; cdecl; external;
{$LinkLib c}

(*Проверка на сортировку*)
function TestSort(a:arr):boolean;
var
    i:longint;
    sorttest:boolean;
begin
    sorttest:=true;
    for i:=0 to high(a)-1 do
        if a[i] < a[i+1] then begin
        sorttest:=false;
        break;
    end;
    TestSort:=sorttest;
    
end;

(*Копирование массива*)
procedure CopyArr(a,b:arr);
var 
    i:longint;
begin
    for i:=low(a) to high(a) do
        b[i]:=a[i];
    i:=random(high(a)-1)+1;
    if a[i]<> b[i] then writeln('ERR COPY');

    end;

(*процедура смены 2х эл-тов массива*)
procedure exch(var ar:arr;a,b:longint);
var
    tmp:longint;
begin
    tmp:=ar[a];
    ar[a]:=ar[b];
    ar[b]:=tmp;
end;

(*Быстрая сортировка, метод Хоара*)
procedure SortQuick(var a:arr;l,u:longint);
var
    i,j:longint;
begin;
    i:=l;
     j:=u;
    repeat
        while i<>j do begin
            if a[i]>=a[j] then
                dec(j)
            else begin
                exch(a,i,j);
                break
            end;
        end;
        while i<>j do begin
            if a[i]>=a[j] then
                inc(i)
            else begin
                exch(a,i,j);
                break
            end;
        end;
    until i=j;
    if i-1>l then 
                    SortQuick(a,l,i-1);
    if j+1<u then
                    SortQuick(a,j+1,u);
end;

(*Сортировка бинарным деревом*)
(*Обход дерева*)
procedure SurTree(node:PTreeType; var  a:arr; i:longint);
begin
       if node<>nil then begin
       SurTree(node^.right,a,i);
       a[IndPrintTree]:=node^.data;
       inc(IndPrintTree);
       SurTree(node^.left,a,i);
       end;
end;

(*Поиск со вставкой эл-та*)
procedure SearchInsert(root:PTreeType; val:longint);
var
    current:PTreeType;
    prev:PTreeType;
    pnew:PTreeType;
begin
    current:=root;
   while(current<>nil)do begin
        prev:=current;
        if val< current^.data then current:=current^.left
        else current:=current^.right;
    end;
    new(pnew);
    pnew^.data:=val;
    pnew^.left:=nil;
    pnew^.right:=nil;
    if val<prev^.data then begin
             prev^.left:=pnew;
             pnew^.up:=prev^.left;
	end
        else begin
	    prev^.right:=pnew;
            pnew^.up:=prev^.right;
       end;
end;
   

    
(*Сортировка бинарным деревом*)
procedure SortTree(var  a:arr);
var
i:longint;
root: PTreeType;
begin
IndPrintTree:=0;
    new(root);
    root^.data:=a[0];
    root^.left:=nil;
    root^.right:=nil;
    root^.up:=nil;
    for i:=1 to high(a) do
        SearchInsert(root, a[i]);	
    SurTree(root,a,0);
end;



(*Процедура печати таблицы*)
procedure print(a:TableType;b:TableType );
var
    i:menu2;
begin
    writeln();
    writeln(' ':15, 'Сортировка бинарным деревом / Быстрая сортировка (мс)');
    write('Размер' :15,'        Упорядоченные':15, '       Обратный порядок        ');
    writeln('Вырожденные            Случайные');
    for i:=t250 to t16000 do begin
    	write(a[i].size :7,'    ',  a[i].Time[SORTED]:10:4 ,' / ', b[i].Time[SORTED]:5:4,'    ');
        write( a[i].Time[ASORTED]:10:4 ,' / ', b[i].Time[ASORTED]:5:4,'    ');
        write( a[i].Time[CHILD]:10:4 ,' / ', b[i].Time[CHILD]:5:4,'    ');
        writeln( a[i].Time[RAND]:10:4 ,' / ', b[i].Time[RAND]:5:4,'    ');



    end;
end;

(*Главноая часть программы*)
var
    mas1,mas2:arr;
    i,max :longint;
    t2:menu2;
    t3:menu3;
    TableBinTreeSort:TableType;
    TableQSort: TableType;
begin
    randomize;
    for t3:=SORTED to RAND do  
         for t2:=t250 to t16000 do begin
            case t2 of(*Определение размера массива*)
                t250:max:=250;
                t500: max:=500;
                t1000: max:=1000;
                t2000: max:=2000;
                t4000: max:=4000;
                t8000: max:=8000;
                t16000: max:=16000;
            end;
            setlength(mas1,max);
            setlength(mas2,max);
            TableBinTreeSort[t2].size:=max;
            TableQSort[t2].size:=max;
            dec(max);
            case t3 of(*Определение типа заполнения массива*)
                SORTED: begin
                    mas1[0]:=maxnumber;
                    for i:=1 to high(mas1) do
                        mas1[i]:=mas1[i-1]-random(maxnumber div (max+1))-1;
                end;
                ASORTED: begin
                    mas1[0]:=1;
                    for i:=1 to high(mas1) do
                        mas1[i]:=mas1[i-1]+random(maxnumber div (max+1))-1;
                end;
                CHILD: for i:=0 to high(mas1) do
                    mas1[i]:=random(12)+1;
                RAND: for i:=low(mas1) to high(mas1) do
                    mas1[i]:=random(maxnumber)+1;
            end;

            CopyArr(mas1,mas2);(*копирование массива*)
            init_timer();(*инициализация таймера*)
                SortTree(mas1);(*сортировка по алгоритму 1*)
                TableBinTreeSort[t2].Time[t3]:=get_timer()/1000;(*сохранение результата времени сортировки*)
                if(testsort(mas1)=false) then writeln ('Ошибка: массив не был отсортирован');(*проверка на корректность сортировки*);
            CopyArr(mas2,mas1);(*восстановление массива из копии*)
                init_timer();
                SortQuick(mas1,0,high(mas1)+1);
                TableQSort[t2].Time[t3]:=get_timer()/1000;
                if(testsort(mas1)=false) then writeln ('Ошибка: массив не был отсортирован');
	end;
    print(TableBinTreeSort,TableQSort);(*печать таблицы с результатами*)
end.
