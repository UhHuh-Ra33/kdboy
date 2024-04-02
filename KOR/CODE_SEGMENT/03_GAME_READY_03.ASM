; 게임 준비 작업(3)
; 기능 : 주 타이틀 화면이 나오며, 게임 시작과 기타 기능 선택
;        을 하게 한다.
; PAGE 64 ~ 73

; 타이틀 그림과 적(괴물) 데이터가 저장되어 있는 C.CWS 화일을 읽는다.

C_LOAD:
            MOV     AX,OFFSET C_FILE        ; C_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구해서
                                            ; FNOFF에 넣는다
            MOV     AX,64688
            MOV     FDLEN,AX                ; 화일 길이
            MOV     AX,6000H
            MOV     FDSEG,AX                ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D                  ; C.CWS를 읽는다

            CMP     ERROR,1                 ; ERROR가 1과
            JE      C_LOAD                  ; 에러가 생기면 C_LOAD로 돌아간다.

C_LOAD_1:
            MOV     GTSEG,4C00H             ; 화면의 그림을 저장한 버퍼 위치
            MOV     GX1,19
            MOV     GY1,60
            MOV     GX2,125
            MOV     GY2,149
            MOV     AH,1                    ; 화면의 그림을 그린다. 데이터로 저장
            CALL    GRASUB                  ; 그래픽 처리

            MOV     AX,4C00H
            MOV     ES,AX
            MOV     DI,0
            MOV     CX,1000H
            CLD
            MOV     AL,0
C_LOAD_1X:
            STOSB
            LOOP    C_LOAD_1X               ; 반복 루프

            MOV     ES,BP

; 게임 타이틀 처리
S1_JAK:
            MOV     DS,BP

            MOV     AH,C_H
            MOV     AL,C_L
            MOV     LVL_H, AH               ; C_H값을 LVL_H에 복사
            MOV     LVL_L, AL               ; C_L값을 LVL_L에 복사
K_LOAD:
            CMP     TITLE_SW,1
            JNE     K_LOAD_XX

            MOV     GX1,0
            MOV     GX2,79
            MOV     GY1,0
            MOV     GY2,399
            MOV     AH,6
            MOV     AL,0
            CALL    GRASUB
            JMP     M_LOAD

; 'KOREAN DUNGEON BOY' 문자열 그림 데이터가 저장되어 있는 K.CWS를 읽는다.
K_LOAD_XX:
            MOV     AX,OFFSET K_FILE        ; K_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구한다
            MOV     AX,2662
            MOV     FDLEN,AX        ; 화일 길이
            MOV     AX,7000H
            MOV     FDSEG,AX        ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D          ; K.CWS를 읽는다

            CMP     ERROR,1         ; ERROR가 1과
            JE      K_LOAD1        ; 같지 않으면 K_LOAD1으로 간다.
                                    ; 즉 에러가 생기지 않았으면 K_LOAD1
                                    ; 으로 간다.
            
            CALL    INSERT_MAIN     ; 메인 디스켓을 삽입하라는 메세지를
                                    ; 화면에 출력하고 삽일할 때까지
                                    ; 기다린다.
            CALL    PRESS_KEY       ; 키 입력을 기다린다.
            JMP     SHORT K_LOAD    ; K_LOAD로 간다.
K_LOAD1:
            CALL    INSERT_END      ; 화면 복구

; 화면 전체를 지운다.

            MOV     GX1,0
            MOV     GX2,79
            MOV     GY1,0
            MOV     GY2,399
            MOV     AH,6            ; 화면을 지우는 기능
            MOV     AL,0
            CALL    GRASUB          ; 그래픽 처리

; 'KOREAN DUNGEON BOY' 그림 문자열을 화면에 그린다.

            MOV     GX1,5
            MOV     GX2,73
            MOV     GY1,185
            MOV     GY2,222
            MOV     GSEG,7000H
            MOV     GOFF,0
            MOV     AH,0            ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB          ; 그래픽 처리

; 주인공이 뛰어다니는 글미 데이터가 저장되어 있는 J.CWS 화일을 읽는다.

J_LOAD1:
            MOV     AX,OFFSET J_FILE        ; J_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                
            MOV     AX,600H
            MOV     FDLEN,AX                ; 화일 길이
            MOV     AX,7200H
            MOV     FDSEG,AX                ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D                  ; J.CWS를 읽는다

            CMP     ERROR,1                 ; ERROR가 1과
            JE      J_LOAD1                 ; 에러가 생기면 J_LOAD1로 돌아간다.

            MOV     CS,2500                 ; 2,500mSec(2.5초 동안)
            CALL    DELAY                   ; 시간 지연

; 주인공이 뛰어다니는 그림을 화면에 그린다.
            MOV     GX1,74                  ; 처음에 그릴 X1값, 74
            MOV     GX2,81                  ; 처음에 그림 X2값, 81          
            MOV     GY1,136                 ; Y1=137
            MOV     GY2,184                 ; Y2=184
            MOV     GSEG,7200H              ; 그림이 저장되어 있는 버퍼의 위치
J_LOAD2:
            MOV     AX,GX1
            PUSH    AX                      ; GX1값을 AX로 옮겨 저장한다.
            MOV     AX,GX2
            PUSH    AX                      ; GX2값을 AX로 옮겨 저장한다.
            
            DEC     AX
            MOV     GX1,AX
            MOV     GX2,AX
            MOV     AH,6                    ; 화면을 지우는 기능
            MOV     AL,0
            CALL    GRASUB                  ; 그래픽 기능

            POP     AX
            MOV     GX2,AX                  ; GX2값을 도로 찾는다.
            POP     AX
            
            MOV     GX1,AX                  ; GX1값을 도로 찾는다.

            SUB     GX1,2                   ; GX1에서 2을 뺀다. TODO: 원본에는 1을 뺀다고 되어있다. TYPO?
            SUB     GX2,2                   ; GX2에서 2을 뺀다.
                                            ; 그림을 왼쪽으로 움직이기 위해 값을
                                            ; 2씩 감소한다.

            MOV     GOFF,0                  ; 0H, 0번 그림
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 처리
            
            CALL    SOUND007                ; 소리를 낸다.

            MOV     GOFF,180H               ; 180H, 1번 그림
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 처리

            MOV     CX,60                   ; 0,06초동안 
            CALL    DELAY                   ; 시간 지연

            MOV     GOFF,300H               ; 300H, 2번 그림
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 처리

            CALL    SOUND007                ; 소리를 낸다.

            MOV     GOFF,480H               ; 480H, 3번 그림
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 처리

            MOV     CX,60                   ; 0.06초동안 
            CALL    DELAY                   ; 시간 지연

            MOV     AH,1                    
            INT     16H                     ; 키 입력을 받는다.
            JZ      J_LOAD2_KEY1            ; 키입력이 없으면 J_LOAD2_KEY1으로
                                            ; 간다
            JMP     SHORT J_LOAD3           ; J_LOAD3로 간다.

J_LOAD2_KEY1:
            CMP     GX1,0
            JNE     J_LOAD2                 ; J_LOAD2로 돌아간다.
J_LOAD3:
            MOV     TITLE_SW,1

            MOV     CX,60                   ; 0.06초 동안 
            CALL    DELAY                   ; 시간 지연

            MOV     AH,6                    ; 화면을 지우는 기능
            MOV     AL,0
            CALL    GRASUB                  ; 그래픽 처리
; 타이틀 그림 데이터가 저장되어 있는 M.CWS 파일을 읽는다.

M_LOAD:
            MOV     AX,OFFSET M_FILE        ; M_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구해서
                                            ; FNOFF에 넣는다
            MOV     AX,459AH
            MOV     FDLEN,AX                ; 화일 길이
            MOV     AX,7000H
            MOV     FDSEG,AX                ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D                  ; M.CWS를 읽는다

            CMP     ERROR,1                 ; ERROR가 1과
            JE      M_LOAD                  ; 에러가 생기면 M_LOAD로 돌아간다.

TITLE_START0:
            MOV     CX,1000                 ; 1초 동안 지연
            CALL    DELAY                   ; 시간 지연

; 화면 상단에서 두루마리가 펼쳐지면 제목이 출력된다.

; 양쪽의 봉을 화면에 그린다.(두루마리가 펼쳐지기 전의 그림)
            
            MOV     GX1,34
            MOV     GX2,39
            MOV     GY1,0
            MOV     GY2,280
            MOV     GSEG,7000H
            MOV     GOFF,0
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 기능

            MOV     GX1,40                
            MOV     GX2,45
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 기능
            
            MOV     CX,444
            CALL    DELAY                   ; 시간 지연

TITLE_START1:
            MOV     TITLE_X1,40             ; 두루마리의 왼쪽 좌표
            MOV     TITLE_X2,39             ; 두루마리의 오른쪽 좌표
            CALL    TITLE_DIS1              ; 타이틀 메시지 출력
            MOV     CX,33                   ; 33번 반복하게 만든다.
                                            ; 화면의 반은 40바이트인데, 두루마리
                                            ; 봉의 크기가 7이므로 이를 뺀 값만큼
                                            ; 반복하게 한다.
TT_LOOPING:
            PUSH    CX                      ; CX값을 저장한다.

; 두루마리 내용의 왼쪽 그림을 그린다.
; 그림 데이터의 내용은 X축 폭 1바이트씩으로 저장되어 있다.
; 이것을 여러 번 반복하여 두루마리의 전체 그림이 화면에 그려지게 한다.

            MOV     AX,237
            MOV     BX,TITLE_X1
            MOV     GX1,BX
            MOV     GX2,BX
            SUB     BX,7
            MUL     BX
            ADD     AX,880H
            MOV     GOFF,AX
            MOV     GSEG,7000H
            MOV     GY1,22
            MOV     GY2,258
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 기능

; 두루마리 내용의 오른쪽 그림을 그린다.

            MOV     AX,237
            MOV     BX,TITLE_X2
            MOV     GX1,BX
            MOV     GX2,BX
            SUB     BX,7
            MUL     BX
            ADD     AX,880H
            MOV     GOFF,AX
            MOV     GSEG,7000H
            MOV     GY1,22
            MOV     GY2,258
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 기능       

            CALL    TITLE_DIS1              ; 두루마리의 양쪽 봉을 그린다.

            MOV     CX,20                   ; 0.02초 동안
            CALL    DELAY                   ; 시간 지연

            POP     CX                      ; CX값을 찾는다.
            LOOP    TT_LOOPING              ; 반복 루프
                                            ; LOOP를 한 번 실행할 때마다 CX값은
                                            ; 1씩 감소하며, CX값이 0이 되면
                                            ; 반복 루프 다른 행을 처리한다.

; '게임시작', '타임머신' 메뉴 그림이 저장되어 있는 F.CWS 화일을 읽는다.

F_LOAD1:
            MOV     AX,OFFSET F_FILE        ; F_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구해서
                                            ; FNOFF에 넣는다
            MOV     AX,1FB0H
            MOV     FDLEN,AX                ; 화일 길이
            MOV     AX,7800H
            MOV     FDSEG,AX                ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D                  ; F.CWS를 읽는다

            CMP     ERROR,1                 ; ERROR가 1과
            JE      F_LOAD1                 ; 에러가 생기면 F_LOAD1로 돌아간다.

; 제목 반짝거림 처리

            MOV     CX,1000                 ; 1초 동안
            CALL    DELAY                   ; 시간 지연          

            MOV     CX,40                   ; 40번 반복하도록 한다.
            MOV     AX,81                   ; 시간 지연값

TITLE_LOOP1:
            PUSH    CX                      ; CX값을 저장
            PUSH    AX                      ; AX값을 저장

            MOV     GX1,7
            MOV     GX2,72
            MOV     GY1,32
            MOV     GY2,248
            MOV     AH,9                    ; 화면의 그림을 반전 시킨다.
            CALL    GRASUB                  ; 그래픽 처리

            POP     AX                      ; AX값을 찾는다.

            SUB     AX,2                    ; AX값에서 2를 뺀다.
            MOV     CX,AX                   ; 계속 감소되는 AX값을 CX에 복사

            CALL    DELAY                   ; 시간 지연

            POP     CX                      ; CX값을 찾는다.

            LOOP    TITLE_LOOP1             ; 반복 루프
            MOV     CX,500                  ; 0.5초 동안
            CALL    DELAY                   ; 시간 지연

; 우선 '게임시작'이 선택된 그림을 화면에 그린다.

            MOV     GX1,22
            MOV     GX2,58
            MOV     GY1,300
            MOV     GY2,378
            MOV     GSEG,7000H
            MOV     GOFF,88D0H
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 기능

            MOV     START_VAL,0             ; 초기값, 게임 시작

            CALL    SOUND008                ; 소리를 낸다.

            CALL    DELKEY                  ; 키 버퍼의 내용을 지운다.
                                            ; 새로운 키 입력을 위해서이다.

F_LOAD2:
            MOV     AH,0                    
            INT     16H                     ; 키 입력을 받는다.

            CMP     AL,13                   ; AL과 ENTER 코드값이 
            JE      F_LOAD_X0               ; 같으면 F_LOAD_X0으로 간다.

            CMP     AL,17                   ; AL과 CTRL+Q 코드값이 
            JNE     F_LOADXXXX              ; 같지 않으면 F_LOADXXXX으로 간다. 

            JMP     GAMEEND_X               ; GAMEEND_X로 간다. 게임 끝
F_LOADXXXX:
            CMP     AH,72                   ; AH와 위쪽 화살표키 코드값이
            JNE     F_LOAD_X1               ; 같지 않으면 F_LOAD_X1으로 간다.

            MOV     START_VAL,0             ; 게임 시작

; '게임시작'이 선택된 그림을 화면에 그린다.

            MOV     GX1,22
            MOV     GX2,58
            MOV     GY1,300
            MOV     GY2,378
            MOV     GSEG,7000H
            MOV     GOFF,88D0H
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 기능
            CALL    SOUND008                ; 소리를 낸다.

            JMP     SHORT F_LOAD2           ; F_LOAD2로 돌아간다.

F_LOAD_X1:
            CMP     AH,80                   ; AH와 아래쪽 화살표키 코드값이
            JNE     F_LOAD2                 ; 같지 않으면 F_LOAD2로 간다.

            MOV     START_VAL,1             ; 타임머신

; '타임머신'이 선택된 그림을 화면에 그린다.

            MOV     GX1,22
            MOV     GX2,58
            MOV     GY1,300
            MOV     GY2,378
            MOV     GSEG,7000H
            MOV     GOFF,9440H
            MOV     AH,0                    ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB                  ; 그래픽 기능

            CALL    SOUND008                ; 소리를 낸다.

            JMP     F_LOAD2                 ; F_LOAD2로 돌아간다.
    
F_LOAD_X0:
            CMP     START_VAL,0             ; START_VAL값이 0과
            JE      D_LOAD                  ; 같으면 D_LOAD로 간다.
                                            ; (0=게임시작, 1=타임머신)

F_LOAD3:
            CALL    MODIFY                  ; 게임 레벨 조정
            CALL    DELKEY                  ; 키 버퍼의 내용을 지운다.
            JMP     F_LOAD2                 ; 다시 F_LOAD2로 돌아간다.

