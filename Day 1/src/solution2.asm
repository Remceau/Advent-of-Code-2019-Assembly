section .text
    global _start

_start:

    mov ebx, DataStart
    mov ecx, DataEnd
    mov edx, 0

    .start:

        cmp ebx, ecx
        jge .end

        mov eax, [ebx]
        call GetRealFuelRequirements
        add edx, eax
        add ebx, 4

        jmp .start

    .end:

    ; Print result
    mov eax, edx
    call PrintInteger

    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 0x80



; Param EAX : Integer to print
PrintInteger:

    ; Change context
    push eax
    push ebx

    ; Setup registers
    mov ebx, eax
    mov eax, CharStorage

    ; Print prefix
    mov byte [CharStorage], '0'
    call PrintCharacter
    mov byte [CharStorage], 'x'
    call PrintCharacter

    ; Print first byte
    mov eax, ebx
    shr eax, 24
    call PrintByte

    ; Print second byte
    mov eax, ebx
    shr eax, 16
    call PrintByte

    ; Print third byte
    mov eax, ebx
    shr eax, 8
    call PrintByte

    ; Print fourth byte
    mov eax, ebx
    call PrintByte

    ; Return context
    pop ebx
    pop eax
    ret



; Param AL : Byte to print
PrintByte:

    ; Change context
    push eax
    push ebx

    ; Print higher nybble
    mov bh, al
    shr bh, 4
    call PrintNybble

    ; Print lower nybble
    mov bh, al
    and bh, 15
    call PrintNybble

    ; Return context
    pop ebx
    pop eax
    ret



PrintNybble:

    ; Change context
    push eax
    push ebx

    ; Decide if letter or digit
    cmp bh, 10
    jge .letter
    jmp .digit

    ; Get character to print
    .letter:
        mov al, bh
        sub al, 10
        add al, 'a'
        jmp .end
    .digit:
        mov al, bh
        add al, '0'
        jmp .end
    .end:

    mov [CharStorage], al
    mov eax, CharStorage
    call PrintCharacter

    ; Return context
    pop ebx
    pop eax
    ret



; Param eax : Character ptr
PrintCharacter:

    ; Change context
    push eax
    push ebx
    push ecx
    push edx

    ; Call sys_write
    mov ecx, eax    ; Character (pointer)
    mov eax, 4      ; Syscall code, sys_write
    mov ebx, 1      ; File descriptor, stdout
    mov edx, 1      ; Message length
    int 0x80        ; Execute syscall

    ; Return context
    pop edx
    pop edx
    pop ebx
    pop eax
    ret



; Param eax : module weight
; Return eax : fuel required
GetFuelRequirements:

    ; Change context
    push eax
    push ecx
    push edx

    ; Divide by 3, round down
    mov edx, 0
    mov ecx, 3
    div ecx

    ; Subtract two
    sub eax, 2      ; Subtract 2 from EAX

    ; Return context
    pop edx
    pop ecx
    pop eax
    ret



; Param eax : module weight
; Return eax : fuel required
GetRealFuelRequirements:

    ; Change context
    push eax
    push ebx

    ; Calculate original fuel requirements
    mov ebx, eax
    GetFuelRequirements


    ; Return context
    pop ebx
    pop eax
    ret




section .data


; Storage Data
CharStorage:

    db 0x00;

; Input Data
DataStart:

    dd 141923
    dd 145715
    dd 63157
    dd 142712
    dd 147191
    dd 96667
    dd 117032
    dd 98123
    dd 135120
    dd 90609
    dd 132022
    dd 61962
    dd 110315
    dd 78993
    dd 130183
    dd 102188
    dd 128800
    dd 140640
    dd 144402
    dd 133746
    dd 66157
    dd 136169
    dd 88585
    dd 82083
    dd 78884
    dd 66913
    dd 142607
    dd 62297
    dd 116267
    dd 92283
    dd 108383
    dd 142698
    dd 53334
    dd 139604
    dd 144184
    dd 89522
    dd 142032
    dd 68327
    dd 111034
    dd 58033
    dd 72836
    dd 90483
    dd 111008
    dd 91385
    dd 115528
    dd 66856
    dd 76318
    dd 63000
    dd 61721
    dd 86102
    dd 89367
    dd 91018
    dd 126390
    dd 135550
    dd 106711
    dd 118434
    dd 117698
    dd 108304
    dd 98998
    dd 82998
    dd 147998
    dd 83344
    dd 149309
    dd 53964
    dd 111042
    dd 112244
    dd 114337
    dd 134419
    dd 76114
    dd 147869
    dd 107076
    dd 78626
    dd 66552
    dd 133785
    dd 112234
    dd 52693
    dd 73606
    dd 116199
    dd 72505
    dd 137500
    dd 64873
    dd 147893
    dd 56938
    dd 87481
    dd 146006
    dd 82226
    dd 133657
    dd 84149
    dd 123742
    dd 137593
    dd 55372
    dd 64696
    dd 54386
    dd 83466
    dd 135058
    dd 133268
    dd 84234
    dd 119067
    dd 143566
    dd 134224

DataEnd: