name "ULAM_FACTORIAL" ;Generar la secuancia numerica ULAM a partir de una cifra predeterminada 
                                                                                              
                                 
mov ax, 9   ;Asigna el valor inicial a la secuencia del registro AX 

jmp identificar_tiponum ;Salta a la "Funcion" identificar_tiponum

identificar_tiponum: ;Esta "Funcion" identificar si el numero es par o impar y
                     ;hace el respectivo salgo condicional hacia par o impar 
cmp ax, 1      ;Realiza una comparacion de AX con el valor de 1      
je  salir      ;Salta a la "Funcion" Salir si AX = 1. Flag Zf = 1 <ES UN SALTO SIN CONDICION>
mov dx, ax     ;Copia el valor del registro acumulador AX a DX
mov bl, 2      ;Se asigna el valor de 2 al LOWER del registro BX
div bl         ;Divide BL para AX porque la funcion esta hecha para trabajar con el
               ;registro acumulador AX
cmp ah, 0      ;Se compara el registro ALTO (HIGH> del registro acumulador porque en
               ;la parte alta se guarda el residuo, se compara esto con 0 para
               ;determinar si es par o impar
jz  par        ;Hace el salto respectivo si el numero es par
jnz impar      ;Hace el salto respectivo si el numero es impar                                             

par:           ;Esta "Funcion" indentifica si el numero es par
mov ax, dx     ;Copia el registro DX al acumulador AX
mov bl, 2      ;Copia el valor de 2 al LOWER del registro BX
div bl         ;Divide el LOWER de BX con el valor que se encuentra en el acumulador AX
mov cx, 0000h  ;Copia el valor Hexadecimal 0000h en el registro CX
mov ds, ax     ;Copia el registro del acumulador en el registro DS
jmp convertir  ;Hace el salto a la "Funcion" convertir

impar:         ;Esta "Funcion" identifica si el numero es impar
mov ax, dx     ;Copia el registro DX al acumulador AX
mov bl, 3      ;Copia el valor de 3 al LOWER del registro BX
mul bl         ;Divide el LOWER de BX con el valor que se encuentra en el acumulador AX
add ax, 1      ;Suma el valor de 1 al acumulador AX
mov cx, 0000h  ;Copia el valor Hexadecimal 0000h en el registro CX
mov ds, ax     ;Copia el registro del acumulador en el registro DS
jmp convertir  ;Hace el salto a la "Funcion" convertir
               
convertir:     ;Esta "Funcion" llena la pila con los registros de los digitos que debe mostrar
mov bl, 10     ;Mover o copiar el valor de 10 al registro LOWER de BX
div bl         ;Dividir el valor de BL (10> para el guardado en
               ;el registro AX (ACUMULADOR)
mov dh, ah     ;Copia el registro AH en el DH
mov dl, al     ;Mueve el registro AL en el DL
               ;Para este punto ya se ha copiado todo el registro
               ;AX en el DX
mov ah, 00h    ;Seteamos el valor de 0 en AH
mov al, dh     ;Copiamos el registro DH en el registro AL
push ax        ;Pusheamos al STACK el registro AX para poder
               ;dividir el numero que se va a presentar por
               ;pantalla en sus digitos
mov ax, 0000h  ;Limpiamos el registro AX y lo seteamos de nuevo en 0
mov al, dl     ;Regresamos el valor LOW de DX a AL
add cx, 1      ;Sumamos uno al registro CX que nos sirve como contador
               ;para controlar el flujo (CONTAR) cuantas veces pasa por el ciclo
               ;y se mandan digitos al stack. Asi tenemos presente cuantos digitos
               ;se enviaron al stack
cmp dl, 0      ;Comparamos si el registro LOW de DX es igual a 0, si no lo es
               ;se hace un JUMP a la misma funcion. De esta forma logramos que la
               ;"Funcion" convertir sea recursiva.
jnz convertir  ;Hace el salto a la misma funcion, al inicio
mov ah, 02h    ;Setea el valor de 2 en el registro HIGH de AX
mov dl, 0h     ;Limpia el registro DL y lo setea en 0 (SIGNIFICA 0 EN ASCII)
int 21h        ;Esta interrupcion muestra por pantalla el caracter correspondiente
               ;codificacion ASCII (EL VALOR QUE SE HA GUARDADO EN DL>
jz  mostrar    ;Salta a la "Funcion" mostrar si el valor dentro del
               ;registro DL es igual a 0
                               
mostrar:       ;Esta "Funcion" imprime cada digito de los elementos que se encuentren en la pila
               ;(Y MUESTRA POR PANTALLA XD>
sub cx, 1      ;Resta el valor de 1 al contador CX ya que se va a mostrar un elemento de la pila
               ;por lo tanto es un digito menos para mostrar
pop ax         ;Extraemos el valor del STACK que este listo para salir 
               ;y lo coloca en el registro AX
mov ah, 02h    ;Asignamos el valor de 2 al registro AH
mov dl, al     ;Copiamos el registro AL en el registro DL
add dl, 30h    ;Le sumamos el valor de 30 al registro DL
int 21h        ;Usamos la interrupcion para imprimir el valor en ASCII del registro DL
cmp cx, 0      ;Comparamos si el registro CX <NUESTRO CONTADOR DE ELMENTOS DENTRO DEL STACK>
               ;Si es igual a 0, se vuelve a llamar a la
               ;"Funcion" identificar_tiponum y se repite todo e proceso de nuevo
jnz mostrar    ;Caso contrario se hace JUMP a la funcion mostrar para terminar de extraer todos los
               ;valores almacenados en el STACK
jmp mostrar_factorial

mov ax, ds     ;Copiamos el registro DS (AUXILIAR> al registro AX
jz  identificar_tiponum   ;Hacemos JUMP a la "Funcion" que inicia todo el ciclo

salir:         ;Esta "Funcion" termina el programa y le regresa el control al SO
int 21h        ;Esta interrupcion muestra el caracter de salida y termina el programa
                 

factorial:     ;FUNCION QUE ENCUENTRA EL FACTORIAL DE UN NUMERO

    
    
    
mostrar_factorial: ;FUNCION QUE MUESTRA EL FACTORIAL    
mov ch, dl         ;RESERVAMOS EL VALOR DE
mov dl, 10    
int 21h
mov dl, ch    
    
    
