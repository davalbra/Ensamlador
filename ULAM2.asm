                name "ULAM" ;explicar objetivos del programa 
                                                                                              
                                 
mov ax, 9   ;Asignamos nuestro valor incial de la secuencia en el resistro AX

jmp identificar_tiponum ; Salto a la etiqueta para identificar el tipo 

identificar_tiponum: ;explicar que hace el codigo asociado a c/etiqueta 
cmp ax, 1          ;Comparamos el valor guardado en AX con 1 y modificamos la banderilla ZF  a 0 si es positivo y distinto si es negativo         
je  salir          ;Verificamos la si los argumentos seteados ax y 1 son iguales para realizar el salto de ser positivo
mov dx, ax         ;Ya que el valor no es 1 copiamos el valor de AX a DX
mov bl, 2          ;Asignamos el valor de 2 al registro bl
div bl             ;Dividimos AX para BL guardando el residuo en AH y el cociente en AL
cmp ah, 0          ;Comparamos el valor de AH en este momento el residuo de la division con 0 y modificamos la banderilla ZF
jz  par            ;Si la banderilla ZF es 0 saltamos a la etiqueta par de lo contrario continuamos
jnz impar          ;Si la banderilla es distinta a 0 saltamo a la etiqueta impar    

; BLOQUE IDENTIFICAR_TIPONUM basicamente identificamos si un valor es par o impar para ser procesado de la manera correspondiente



par:
mov ax, dx          ;Asignamos el valor de DX a AX para procesarlo
mov bl, 2           ;Asignamos el valor de 2 al registro bl 
div bl              ;Dividimos AX para BL guardando el residuo en AH y el cociente en AL
mov cx, 0000h       ;Asignamos el valor de 0 a CX lo que es resetear el tamano de la pila
mov ds, ax          ;Saltamos a la etiqueta convertir para guardarlo en una pila los valores decimales
jmp convertir

;BLOQUE PAR luego de identificar si un numero es par lo dividimos para 2los preparamos para ser convertido en decimal y ser mostrado

impar:              
mov ax, dx          ;Devolvemos el valor inicial de DX a AX para procesarlo
mov bl, 3           ;Asignamos el valor de 3 al registro BL
mul bl              ;Multiplicamos AX y Bl asignando el resultado a AX
add ax, 1           ;Incrementamos en 1 el valor de AX
mov cx, 0000h       ;Asignamos el valor de 0 a CX lo que es resetear el tamano de la pila
mov ds, ax          ;Asignamos el valor de AX a DS
jmp convertir       ;Saltamos a la etiqueta convertir para guardarlo en una pila los valores decimales

;BLOQUE IMPAR luego de identificar si un numero es impar lo multiplicamos por 3 y le sumamos 1 y los preparamos para ser convertido en decimal y ser mostrado


convertir:
mov bl, 10          ;Asignamos el valor de 10 al registro bl
div bl              ;Dividimos AX para BL guardando el residuo en AH y el cociente en AL 
mov dh, ah          ;Asignamos el valor de AH a DH
mov dl, al          ;Asignamos el valor de Al a Dl
mov ah, 00h         ;Seteamos el valor de AH a 0
mov al, dh          ;Asignamos el valor de DH a AL
push ax             ;Agregamos el valor de AX en este caso el residuo de la division a la pila
mov ax, 0000h       ;Setemos el valor de AX en 0
mov al, dl          ;Devolvemos el valor de dl a AL
add cx, 1           ;Sumamos en 1 el contador de la pila
cmp dl, 0           ;Comparamos si dl en este caso el cociente de la division es 0 y modificamos la banderilla ZF
jnz convertir       ;En el caso de que el cociente no sea 0 se vuelve a convertir
mov ah, 02h         ;Asignamos el valor de 02h a AH como parametro de la futura interrupcion
mov dl, 0h          ;Asignamos el valor de 0 al registro AH
int 21h             ;Se interrumpe inciciando la consola e imprimiendo un espacio 
jz  mostrar         ;Se salta a la etiqueta mostrar para en consola e imprimir los valores de la cola

;BLOQUE CONVERTIR utilizando divisiones susesivas se arma una pila con los residuos de dichas divisiones para conseguir un numero en base 10                               
mostrar:
sub cx, 1           ;Le restamos el contador de la pila
pop ax              ;Sustraemos el valor de la pila proximo a salir
mov ah, 02h         ;Asignamos el valor de 02h a ah para prepararlo para la interrupcion
mov dl, al          ;Asignamos el valor de al a DL
add dl, 30h         ;Sumamos el valor de 30h para convertirlo en un codigo ascci dicho valor decimal
int 21h             ;Interrumpimos presentando por pantalla el ultimo valor de la pila en codigo ascci
cmp cx, 0           ;Comparamos el valor del contador de la pila para saber si esta vacia
jnz mostrar         ;Si no esta vacia se vuelve a mostrar el siguiente valor de la pila
mov ax, ds          ;Asignamos el valor de ds que era el valor procesado por el algoritmo de la conjetura de ULAM a AX para volverlo a procesar
jz  identificar_tiponum ; Saltamos a procesar el siguiente numero de la secuencia de ULAM identificando el tipo de numero par o par

;BLOQUE MOSTRAR utilizando los valores de los residuos almacenados en la pila en la consola gracias a las interrupciones   
salir:      ;Terminamos el proceso
int 21h     ;Devolvemos el control al usuario