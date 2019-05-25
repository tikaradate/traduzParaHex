program paperToAssembly;
uses
	Sysutils;
const
	C_FNAME = 'nome.txt';
var
	res : char;
	temFuncao : boolean;
	i, linhas : integer;
	tfOut : textfile;

procedure separaInstrucao(instru : string;
			 var fun, c, a, b, cte : string);
var
	i, j, qualParte : integer;
begin
	i := 1;
	j := 1;
	qualParte := 1;
	{le a string da instrucao toda e separa em pedacos}
	for i := 1 to length(instru) do
	begin
		if instru[i] <> ' ' then
			{case para cada uma das 5 partes}
			case qualParte of
				1: insert(copy(instru,i,1),fun,j);
				2: insert(copy(instru,i,1),c,j);
				3: insert(copy(instru,i,1),a,j);
				4: insert(copy(instru,i,1),b,j);
				5: insert(copy(instru,i,1),cte,j);
			end;
		j := j + 1;
		if instru[i] = ' ' then
		begin
			j := 1;
			qualParte := qualParte + 1;
		end;
	end;
end;


procedure traduz(fun, c, a, b, cte : string; linha : integer);
var
	aNew, bNew, cNew, cteNew : integer;
	linhaStr : string;
begin
	{converte as strings separadas em inteiros}
	cNew := strToInt(c);
	aNew := strToInt(a);
	bNew := strToInt(b);
	cteNew := strToInt(cte);
	{converte todos para hex, e coloca em minusculo
	porque intToHex deixa em maiusculo; reuso de variavel pq sim}
	c := lowerCase(intToHex(cNew, 1));
	a := lowerCase(intToHex(aNew, 1));
	b := lowerCase(intToHex(bNew, 1));
	cte := lowerCase(intToHex(cteNew, 4));
	linhaStr := lowerCase(intToHex(linha, 1));
	if fun = 'add' then
		writeln(tfOut, '0', a, b, c, cte, ' ', linhaStr,
			' add r', c, ' r', a, ' r', b)
	else if fun = 'sub' then
		writeln(tfOut, '1', a, b, c, cte, ' ', linhaStr,
			' sub r', c, ' r', a, ' r', b)
	else if fun = 'mul' then
		writeln(tfOut, '2', a, b, c, cte, ' ', linhaStr,
			' mul r', c, ' r', a, ' r', b)
	else if fun = 'and' then
		writeln(tfOut, '3', a, b, c, cte, ' ', linhaStr,
			' and r', c, ' r', a, ' r', b)
	else if fun = 'or' then
		writeln(tfOut, '4', a, b, c, cte, ' ', linhaStr,
			' or r', c, ' r', a, ' r', b)
	else if fun = 'xor' then
		writeln(tfOut, '5', a, b, c, cte, ' ', linhaStr,
			' xor r', c, ' r', a, ' r', b)
	else if	fun = 'slt' then
		writeln(tfOut, '6', a, b, c, cte, ' ', linhaStr,
			' slt r', c, ' r', a, ' r', b)
	else if	fun = 'not' then
		writeln(tfOut, '7', a, b, c, cte, ' ', linhaStr,
			' not r', c, ' r', a)
	else if	fun = 'addi' then
		writeln(tfOut, '8', a, b, c, cte, ' ', linhaStr,
			' addi r', c, ' r', a, ' ', cte)
	else if	fun = 'ld' then
		writeln(tfOut, '9', a, b, c, cte, ' ', linhaStr,
			' ld r', c, ' ', cte, '(r', a, ')')
	else if	fun = 'st' then
		writeln(tfOut, 'a', a, b, c, cte, ' ', linhaStr,
			' st ', cte, '(r', a, ') ', 'r', b)
	else if	fun = 'show' then
		writeln(tfOut, 'b', a, b, c, cte, ' ', linhaStr,
			' show r', a)
	else if	fun = 'jal' then
		writeln(tfOut, 'c', a, b, c, cte, ' ', linhaStr,
			' jal ', cte, ' r', c)
	else if	fun = 'jr' then
		writeln(tfOut, 'd', a, b, c, cte, ' ', linhaStr,
			' jr r', a)
	else if	fun = 'beq' then
		writeln(tfOut, 'e', a, b, c, cte, ' ', linhaStr,
			' beq r', a, ' r', b, ' ', cte)
	else if	fun = 'halt' then
		writeln(tfOut, 'f', a, b, c, cte, ' ', linhaStr,
			' halt'); 
end;

procedure escreveHex(i : integer);
var
	instru, fun, c, a, b, cte : string;
begin
	readln(instru);
	separaInstrucao(instru, fun, c ,a, b, cte);
	traduz(fun, c, a, b, cte, i);
end;

begin
	assignFile(tfOut, C_FNAME);
	writeln('Comece com a funcao principal, entao, se necessario, outras funcoes');
	rewrite(tfOut);
	writeln('Quantas linhas tem a f. principal?');
	readln(linhas);
	writeln('Escreva os comandos no (quase) formato do papel, em base 10:');
	writeln('Se nao houver o registrador, coloque 0');
	writeln('funcao c a b cte');
	for i := 0 to linhas do
	begin
		writeln('Linha atual: ', i);
		escreveHex(i);
	end;
	writeln('Tem funcao?(S/N)');
	readln(res);
	temFuncao := (res = 's') or (res = 'S');
	while temFuncao do
	begin
		writeln('Comeca em qual linha?');
		readln(linhaFun);
		writeln('Quantas linhas tem?')
		readln(linhas)
		for i := linhaFun to linhas+linhaFun do
		begin
			writeln('Linha atual: ', i);
			escreveHex(i);
		end;
		writeln('Tem outra funcao?(S/N)');
		readln(res)
		temFuncao := (res = 's') or (res = 'S');
	end;
	closeFile(tfOut);
	writeln('Escrita completa.');
end.
