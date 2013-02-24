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
    12	    
    13	    tdirs =(left,right,up);
    14	
    15	    table=record
    16	        size:longint;
    17	        Time: array[menu3] of extended;
    18	    end;
    19	    
    20	    TableType=array [menu2] of table;
    21	    
    22	    rectree=record
    23	        data:longint;
    24	        dirs: array [tdirs] of word
    25	    end;
    26	
    27	(*Подключение библиотеки, для работы с сис. таймером*)
    28	
    29	{$L timer.o}
    30	Procedure init_timer; cdecl; external;
    31	Function get_timer: longint; cdecl; external;
    32	{$LinkLib c}
    33	
    34	(*Проверка на сортировку*)
    35	function TestSort(a:arr):boolean;
    36	var
    37	    i:longint;
    38	    sorttest:boolean;
    39	begin
    40	    sorttest:=true;
    41	    for i:=0 to high(a)-1 do
    42	        if a[i] < a[i+1] then begin
    43	        sorttest:=false;
    44	        break;
    45	    end;
    46	    TestSort:=sorttest;
    47	    
    48	end;
    49	
    50	(*Копирование массива*)
    51	procedure CopyArr(a,b:arr);
    52	var 
    53	    i:longint;
    54	begin
    55	    for i:=low(a) to high(a) do
    56	        b[i]:=a[i];
    57	    i:=random(high(a)-1)+1;
    58	    if a[i]<> b[i] then writeln('ERR COPY');
    59	
    60	    end;
    61	
    62	(*процедура смены 2х эл-тов массива*)
    63	procedure exch(var ar:arr;a,b:longint);
    64	var
    65	    tmp:longint;
    66	begin
    67	    tmp:=ar[a];
    68	    ar[a]:=ar[b];
    69	    ar[b]:=tmp;
    70	end;
    71	
    72	(*Быстрая сортировка, метод Хоара*)
    73	procedure SortQuick(var a:arr;l,u:longint);
    74	var
    75	    i,j:longint;
    76	begin;
    77	    i:=l;
    78	     j:=u;
    79	    repeat
    80	        while i<>j do begin
    81	            if a[i]>=a[j] then
    82	                dec(j)
    83	            else begin
    84	                exch(a,i,j);
    85	                break
    86	            end;
    87	        end;
    88	        while i<>j do begin
    89	            if a[i]>=a[j] then
    90	                inc(i)
    91	            else begin
    92	                exch(a,i,j);
    93	                break
    94	            end;
    95	        end;
    96	    until i=j;
    97	    if i-1>l then 
    98	                    SortQuick(a,l,i-1);
    99	    if j+1<u then
   100	                    SortQuick(a,j+1,u);
   101	end;
   102	
   103	(*Сортировка бинарным деревом*)
   104	procedure SortTree(a:arr);
   105	var
   106	    tree:array of rectree;
   107	    dir:tdirs;
   108	    i,j,k:longint;
   109	begin
   110	    setlength(tree,high(a)+1);
   111	    for i:= 1 to high(a)+1 do
   112	        for dir :=left to right do
   113	            tree[i].dirs[dir]:=0;
   114	    tree[1].data:=a[1-1];
   115	    tree[1].dirs[up]:=1;
   116	    for i:=2 to high(a)+1 do begin
   117	        j:=1;
   118	        repeat
   119	            k:=j;
   120	            if tree[j].data<a[i-1] then
   121	                dir:=left
   122	            else
   123	                dir:=right;
   124	            j:= tree[j].dirs[dir]
   125	        until j=0;
   126	        tree[i].data:=a[i-1];
   127	        tree[i].dirs[up]:=k;
   128	        tree[k].dirs[dir]:=i;
   129	    end;
   130	    dir:= up;
   131	    i:=1;
   132	    j:=1;
   133	    repeat
   134	        case dir of
   135	            up:begin
   136	                while tree[j].dirs[left] <>0 do
   137	                    j:=tree[j].dirs[left];
   138	                a[i-1]:=tree[j].data;
   139	                inc(i);
   140	                if tree[j].dirs[right]<>0 then
   141	                    j:=tree[j].dirs[right]
   142	                else begin
   143	                    if tree[tree[j].dirs[up]].dirs[left]=j then
   144	                        dir:=left
   145	                    else
   146	                        dir:=right;
   147	                    j:=tree[j].dirs[up]
   148	                end
   149	            end;
   150	            left:begin
   151	                a[i-1]:=tree[j].data;
   152	                inc(i);
   153	                if tree[j].dirs[right] = 0 then begin
   154	                    if tree[tree[j].dirs[up]].dirs[left]<>j then
   155	                        dir :=right;
   156	                    j:= tree[j].dirs[up];
   157	                end else begin
   158	                    j:= tree[j].dirs[right];
   159	                    dir:=up
   160	                end
   161	            end;
   162	            right:begin
   163	                if tree[tree[j].dirs[up]].dirs[left]=j then
   164	                    dir:=left;
   165	                j:=tree[j].dirs[up];
   166	                end
   167	            end;
   168	    until i> high(a)+1;
   169	end;
   170	
   171	(*Процедура печати таблицы*)
   172	procedure print(a:TableType;b:TableType );
   173	var
   174	    i:menu2;
   175	begin
   176	    writeln();
   177	    writeln(' ':15, 'Сортировка бинарным деревом / Быстрая сортировка (мс)');
   178	    write('Размер' :15,'        Упорядоченные':15, '       Обратный порядок        ');
   179	    writeln('Вырожденные            Случайные');
   180	    for i:=t250 to t16000 do begin
   181	    	write(a[i].size :7,'    ',  a[i].Time[SORTED]:10:4 ,' / ', b[i].Time[SORTED]:5:4,'    ');
   182	        write( a[i].Time[ASORTED]:10:4 ,' / ', b[i].Time[ASORTED]:5:4,'    ');
   183	        write( a[i].Time[CHILD]:10:4 ,' / ', b[i].Time[CHILD]:5:4,'    ');
   184	        writeln( a[i].Time[RAND]:10:4 ,' / ', b[i].Time[RAND]:5:4,'    ');
   185	
   186	
   187	
   188	    end;
   189	end;
   190	
   191	(*Главная часть программы*)
   192	var
   193	    mas1,mas2:arr;
   194	    i,max :longint;
   195	    t2:menu2;
   196	    t3:menu3;
   197	    TableBinTreeSort:TableType;
   198	    TableQSort: TableType;
   199	begin
   200	    randomize;
   201	    for t3:=SORTED to RAND do  
   202	         for t2:=t250 to t16000 do begin
   203	            case t2 of
   204	                t250:max:=250;
   205	                t500: max:=500;
   206	                t1000: max:=1000;
   207	                t2000: max:=2000;
   208	                t4000: max:=4000;
   209	                t8000: max:=8000;
   210	                t16000: max:=16000;
   211	            end;
   212	        
   213	            setlength(mas1,max);
   214	            setlength(mas2,max);
   215	            TableBinTreeSort[t2].size:=max;
   216	            TableQSort[t2].size:=max;
   217	            dec(max);
   218	            case t3 of
   219	                SORTED: begin
   220	                    mas1[0]:=maxnumber;
   221	                    for i:=1 to high(mas1) do
   222	                        mas1[i]:=mas1[i-1]-random(maxnumber div (max+1))-1;
   223	                end;
   224	                ASORTED: begin
   225	                    mas1[0]:=1;
   226	                    for i:=1 to high(mas1) do
   227	                        mas1[i]:=mas1[i-1]+random(maxnumber div (max+1))-1;
   228	                end;
   229	                CHILD: for i:=0 to high(mas1) do
   230	                    mas1[i]:=random(12)+1;
   231	                RAND: for i:=low(mas1) to high(mas1) do
   232	                    mas1[i]:=random(maxnumber)+1;
   233	            end;
   234	
   235	            CopyArr(mas1,mas2);
   236	
   237	            init_timer();
   238	                SortTree(mas1);
   239	                TableBinTreeSort[t2].Time[t3]:=get_timer()/1000;
   240	                if(testsort(mas1)=false) then begin 
   241			    writeln ('Ошибка: массив не был отсортирован');
   242	       		    exit;
   243			end;
   244	            CopyArr(mas2,mas1);
   245	                init_timer();
   246	                SortQuick(mas1,0,high(mas1)+1);
   247	                TableQSort[t2].Time[t3]:=get_timer()/1000;
   248	                if(testsort(mas1)=false) then begin
   249			    writeln ('Ошибка: массив не был отсортирован');
   250			    exit;
   251			end;
   252	        end;
   253	
   254	    print(TableBinTreeSort,TableQSort);
   255	end.
