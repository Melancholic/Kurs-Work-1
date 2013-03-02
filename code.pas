     1	program KursWork_Nagorny;
     2	(*объявление констант*)
     3	const
     4	    maxnumber=70000;
     5	(*Объявление пользовательских типов*)
     6	type
     7	    arr= array of longint;
     8	
     9	    menu1=(BINTREE,QSORT);
    10	    menu2=(t250,t500,t1000,t2000,t4000,t8000,t16000);
    11	    menu3=(SORTED,ASORTED,CHILD,RAND);
    12	    tdirs =(left,right,up);
    13	
    14	    table=record
    15	        size:longint;
    16	        Time: array[menu3] of extended;
    17	    end;
    18	
    19	    TableType=array [menu2] of table;
    20	    
    21	    PTreeType=^rectree;     
    22	
    23	     rectree=record
    24	        data:longint;
    25	        left, right,up:PTreeType;
    26	    end;
    27	(*Объявление глобальных переменных*)
    28	var
    29	   IndPrintTree :longint;
    30	
    31	(*Подключение библиотеки, для работы с сис. таймером*)
    32	
    33	{$L timer.o}
    34	Procedure init_timer; cdecl; external;
    35	Function get_timer: longint; cdecl; external;
    36	{$LinkLib c}
    37	
    38	(*Проверка на сортировку*)
    39	function TestSort(a:arr):boolean;
    40	var
    41	    i:longint;
    42	    sorttest:boolean;
    43	begin
    44	    sorttest:=true;
    45	    for i:=0 to high(a)-1 do
    46	        if a[i] < a[i+1] then begin
    47	        sorttest:=false;
    48	        break;
    49	    end;
    50	    TestSort:=sorttest;
    51	    
    52	end;
    53	
    54	(*Копирование массива*)
    55	procedure CopyArr(a,b:arr);
    56	var 
    57	    i:longint;
    58	begin
    59	    for i:=low(a) to high(a) do
    60	        b[i]:=a[i];
    61	    i:=random(high(a)-1)+1;
    62	    if a[i]<> b[i] then writeln('ERR COPY');
    63	
    64	    end;
    65	
    66	(*процедура смены 2х эл-тов массива*)
    67	procedure exch(var ar:arr;a,b:longint);
    68	var
    69	    tmp:longint;
    70	begin
    71	    tmp:=ar[a];
    72	    ar[a]:=ar[b];
    73	    ar[b]:=tmp;
    74	end;
    75	
    76	(*Быстрая сортировка, метод Хоара*)
    77	procedure SortQuick(var a:arr;l,u:longint);
    78	var
    79	    i,j:longint;
    80	begin;
    81	    i:=l;
    82	     j:=u;
    83	    repeat
    84	        while i<>j do begin
    85	            if a[i]>=a[j] then
    86	                dec(j)
    87	            else begin
    88	                exch(a,i,j);
    89	                break
    90	            end;
    91	        end;
    92	        while i<>j do begin
    93	            if a[i]>=a[j] then
    94	                inc(i)
    95	            else begin
    96	                exch(a,i,j);
    97	                break
    98	            end;
    99	        end;
   100	    until i=j;
   101	    if i-1>l then 
   102	                    SortQuick(a,l,i-1);
   103	    if j+1<u then
   104	                    SortQuick(a,j+1,u);
   105	end;
   106	
   107	(*Сортировка бинарным деревом*)
   108	(*Обход дерева*)
   109	procedure SurTree(node:PTreeType; var  a:arr; i:longint);
   110	begin
   111	       if node<>nil then begin
   112	       SurTree(node^.right,a,i);
   113	       a[IndPrintTree]:=node^.data;
   114	       inc(IndPrintTree);
   115	       SurTree(node^.left,a,i);
   116	       end;
   117	end;
   118	
   119	(*Поиск со вставкой эл-та*)
   120	procedure SearchInsert(root:PTreeType; val:longint);
   121	var
   122	    current:PTreeType;
   123	    prev:PTreeType;
   124	    pnew:PTreeType;
   125	begin
   126	    current:=root;
   127	   while(current<>nil)do begin
   128	        prev:=current;
   129	        if val< current^.data then current:=current^.left
   130	        else current:=current^.right;
   131	    end;
   132	    new(pnew);
   133	    pnew^.data:=val;
   134	    pnew^.left:=nil;
   135	    pnew^.right:=nil;
   136	    if val<prev^.data then begin
   137	             prev^.left:=pnew;
   138	             pnew^.up:=prev^.left;
   139		end
   140	        else begin
   141		    prev^.right:=pnew;
   142	            pnew^.up:=prev^.right;
   143	       end;
   144	end;
   145	   
   146	
   147	    
   148	(*Сортировка бинарным деревом*)
   149	procedure SortTree(var  a:arr);
   150	var
   151	i:longint;
   152	root: PTreeType;
   153	begin
   154	IndPrintTree:=0;
   155	    new(root);
   156	    root^.data:=a[0];
   157	    root^.left:=nil;
   158	    root^.right:=nil;
   159	    root^.up:=nil;
   160	    for i:=1 to high(a) do
   161	        SearchInsert(root, a[i]);	
   162	    SurTree(root,a,0);
   163	end;
   164	
   165	
   166	
   167	(*Процедура печати таблицы*)
   168	procedure print(a:TableType;b:TableType );
   169	var
   170	    i:menu2;
   171	begin
   172	    writeln();
   173	    writeln(' ':15, 'Сортировка бинарным деревом / Быстрая сортировка (мс)');
   174	    write('Размер' :15,'        Упорядоченные':15, '       Обратный порядок        ');
   175	    writeln('Вырожденные            Случайные');
   176	    for i:=t250 to t16000 do begin
   177	    	write(a[i].size :7,'    ',  a[i].Time[SORTED]:10:4 ,' / ', b[i].Time[SORTED]:5:4,'    ');
   178	        write( a[i].Time[ASORTED]:10:4 ,' / ', b[i].Time[ASORTED]:5:4,'    ');
   179	        write( a[i].Time[CHILD]:10:4 ,' / ', b[i].Time[CHILD]:5:4,'    ');
   180	        writeln( a[i].Time[RAND]:10:4 ,' / ', b[i].Time[RAND]:5:4,'    ');
   181	
   182	
   183	
   184	    end;
   185	end;
   186	
   187	(*Главноая часть программы*)
   188	var
   189	    mas1,mas2:arr;
   190	    i,max :longint;
   191	    t2:menu2;
   192	    t3:menu3;
   193	    TableBinTreeSort:TableType;
   194	    TableQSort: TableType;
   195	begin
   196	    randomize;
   197	    for t3:=SORTED to RAND do  
   198	         for t2:=t250 to t16000 do begin
   199	            case t2 of(*Определение размера массива*)
   200	                t250:max:=250;
   201	                t500: max:=500;
   202	                t1000: max:=1000;
   203	                t2000: max:=2000;
   204	                t4000: max:=4000;
   205	                t8000: max:=8000;
   206	                t16000: max:=16000;
   207	            end;
   208	            setlength(mas1,max);
   209	            setlength(mas2,max);
   210	            TableBinTreeSort[t2].size:=max;
   211	            TableQSort[t2].size:=max;
   212	            dec(max);
   213	            case t3 of(*Определение типа заполнения массива*)
   214	                SORTED: begin
   215	                    mas1[0]:=maxnumber;
   216	                    for i:=1 to high(mas1) do
   217	                        mas1[i]:=mas1[i-1]-random(maxnumber div (max+1))-1;
   218	                end;
   219	                ASORTED: begin
   220	                    mas1[0]:=1;
   221	                    for i:=1 to high(mas1) do
   222	                        mas1[i]:=mas1[i-1]+random(maxnumber div (max+1))-1;
   223	                end;
   224	                CHILD: for i:=0 to high(mas1) do
   225	                    mas1[i]:=random(12)+1;
   226	                RAND: for i:=low(mas1) to high(mas1) do
   227	                    mas1[i]:=random(maxnumber)+1;
   228	            end;
   229	
   230	            CopyArr(mas1,mas2);(*копирование массива*)
   231	            init_timer();(*инициализация таймера*)
   232	                SortTree(mas1);(*сортировка по алгоритму 1*)
   233	                TableBinTreeSort[t2].Time[t3]:=get_timer()/1000;(*сохранение результата времени сортировки*)
   234	                if(testsort(mas1)=false) then writeln ('Ошибка: массив не был отсортирован');(*проверка на корректность сортировки*);
   235	            CopyArr(mas2,mas1);(*восстановление массива из копии*)
   236	                init_timer();
   237	                SortQuick(mas1,0,high(mas1)+1);
   238	                TableQSort[t2].Time[t3]:=get_timer()/1000;
   239	                if(testsort(mas1)=false) then writeln ('Ошибка: массив не был отсортирован');
   240		end;
   241	    print(TableBinTreeSort,TableQSort);(*печать таблицы с результатами*)
   242	end.
