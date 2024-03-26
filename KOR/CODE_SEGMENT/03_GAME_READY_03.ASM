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
            
            