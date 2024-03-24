; 초롱이의 모험 초기 작업
CODE        SEGMENT
            ASSUME CD:CODE, DS:DATA, ES:DATA

            MOV     AX,DATA         ; DATA Segment 값을 AX에 넣는다
            MOV     DS,AX           ; AX값을 DS에 넣는다
            MOV     ES,AX           ; AX값을 ES에 복사한다
            MOV     BP,AX           ; AX값을 BP에 복사한다

; 게임 준비 작업(1)
; 기능 : 사용중인, 사용할 드라이브를 알아내고, 그래픽 모드를
;        선택하게 한다

; 사용중인, 사용할 드라이브를 구한다
            MOV     AH,19H
            INT     21H             ; 현재 사용중인 드라이를 알아낸다
                                    ; AL에는 드라이브 코드값이 저장된다.
                                    ; (0=A,1=B 등)
            MOV     M_DRIVE,AL      ; AL값을 메인 드라이브 변수에 저장
            MOV     D_DRIVE,AL      ; AL값을 데이터 드라이브 변수에 저장
        
            JMP     SHORT GRAPHIC_MODE_B    ; GRAPHIC_MODE_B로 간다
                                            ; JUMP 명령에서 SHORT는 가까운
                                            ; 곳으로 갈 때 사용한다.
; 게임시 사용 되는 무기 및 마법의 개수 초기 데이터이다.
; 이값을 미리 바꾼 뒤 실행 해도 된다.
KS_BAT      DB      10              ; 건전지 개수
KS_BIRD     DB      16              ; 새총에 쓰이는 돌의 개수
KS_GUN      DB      8               ; 총알 개수
KS_WIZ      DB      4               ; 마법 개수

GRAPHIC_MODE_B:
; 그래픽 모드를 선택한다
            JMP     GRAPHIC_MODE    ; 그래픽 모드 선택을 위해
                                    ; GRAPHIC_MODE로 간다

GRAPHIC_MODE_A:
; 그래픽 화면을 지운다
            MOV     AX,0B000H       ; 그래픽 버퍼 시작 위치(세드먼트)
            MOV     ES,AX           ; 값을 ES에 넣는다
            MOV     DI,0            ; DI에 초기값 0을 넣는다
            MOV     CX,0FFFFH       ; 0FFFFH번 반복하게 한다.
            MOV     AL,0
            CLD                     ; 다음의 반복 루프에서 한번 반복할
                                    ; 때마다 DI값이 1씩 누적하게 된다.

SCREEN_CLEAR:
            STOSB                   ; ES:DI에 1바이트씩 AL값,
                                    ; 즉 0을 전송해서 화면을 지운다.
            LOOP    SCREEN_CLEAR    ; 반복루프
                                    ; LOOP을 한 번 실행할 때마다 CX값은
                                    ; 1씩 감소하며 CX값이 0이 되면
                                    ; 반복 루프 다음 행을 처리한다.

;허큘레레스 모드를 설정한다
GSETMODE:
            MOV     AX,OFFSET SCRDATA   ; 허큘리스 데이터의 시작 위치
            MOV     SI,AX               ; 값을 SI에 넣는다
            MOV     DX,3BFH
            MOV     AL,3
            OUT     DX,AL           ; 3BFH에 3을 넣는다.
            MOV     DX,3B8H
            MOV     AL,0
            OUT     DX,AL           ; 3B8H에 0을 넣는다.
            MOV     DX,3B4H
            MOV     AL,0            ; 반복처리를 위한 AL에 초기값 0을
                                    ; 넣는다. AL=INDEX
GSETMODE1:
            PUSH    AX              ; AX를 저장한다
            OUT     DX,AL           ; 3B4H에 AL값을 넣는다.
            INC     DX              ; 3B4H=3B4H+1 (1을 더한다.)
            LODSB                   ; DS:SI에서 1바이트를 AL에 얻어온다.
            OUT     DX,AL           ; 3B5H에 4L값을 넣는다.
            DEC     DX              ; 3B4H=3B5H-1(1을 뺀다.)
            POP     AX              ; AX를 찾는다.
            INC     AL              ; AL에 1을 누적한다
            CMP     AL,0CH
            JB      GSETMODE1       ; C 플래그가 1이면 GSETMODE1으로 간다
            ADD     DL,4            ; 3B8H=3B4H+4
            LODSB                   ; DS:SI에서 1바이트를 AL에 얻어온다
            OUT     DX,AL           ; 3B8H에 AL값을 넣는다
                                    ; HERCULES GRAPHIC MODE SET.
; 레이더용 폰트(패턴) 데이터를 옮긴다
; 5FA0H - 길(흰색)
            MOV     AX,5FA0H
            MOV     ES,AX           ; ES에 5FA0H를 넣는다
            MOV     DI,0            ; DI에 초기값 0를 넣는다
            MOV     AX,OFFSET RD_00
            MOV     SI,AX
            MOV     CX,6            ; 6번 반복하도록 한다
            MOV     BX,0            ; BX에 초기값 0을 넣는다
            CLD
R_DATA_1:
            MOV     AL,[BX+SI]      ; DS:[BX+SI]에서 1바이트를 읽어 AL에
                                    ; 저장한다
            STOSB                   ; ES:D1에 AL값을 저장한다.
            INC     BX              ; BX값을 1씩 누적한다
            LOOP    R_DATA_1        ; 반복루프
; 5FA1H-벽(회색)
            MOV     AX,5FA1H
            MOV     ES,AX           ; ES에 5FA1H를 넣는다
            MOV     DI,0            ; DI에 초기값 0을 넣는다
            MOV     AX,OFFSET RD_01
            MOV     SI,AX
            MOV     CX,6            ; 6번 반복하도록 한다.
            MOV     BX,0            ; BX에 초기값 0을 넣는다.
            CLD
R_DATA_2:
            MOV     AL,[BX+SI]      ; DS:[BX+SI]에서 1바이트를 읽어 AL에
                                    ; 저장한다
            STOSB                   ; ES:D1에 AL값을 저장한다.
            INC     BX              ; BX값을 1씩 누적한다
            LOOP    R_DATA_2        ; 반복루프       
; 5FA2H-적(검은점)
            MOV     AX,5FA2H
            MOV     ES,AX           ; ES에 5FA2H를 넣는다
            MOV     DI,0            ; DI에 초기값 0을 넣는다
            MOV     AX,OFFSET RD_FF
            MOV     SI,AX
            MOV     CX,6            ; 6번 반복하도록 한다.
            MOV     BX,0            ; BX에 초기값 0을 넣는다.
            CLD
R_DATA_3:
            MOV     AL,[BX+SI]      ; DS:[BX+SI]에서 1바이트를 읽어 AL에
                                    ; 저장한다
            STOSB                   ; ES:D1에 AL값을 저장한다.
            INC     BX              ; BX값을 1씩 누적한다
            LOOP    R_DATA_3        ; 반복루프
; 다음의 내용은 R_DATA_1~R_DATA_2의 내용과 거의 같다 
; 5FA3H-주인공
            MOV     AX,5FA3H
            MOV     ES,AX           ; ES에 5FA3H를 넣는다
            MOV     DI,0            ; DI에 초기값 0을 넣는다
            MOV     AX,OFFSET RD_FE
            MOV     SI,AX
            MOV     CX,6            ; 6번 반복하도록 한다.
            MOV     BX,0            ; BX에 초기값 0을 넣는다.
            CLD
R_DATA_4:
            MOV     AL,[BX+SI]      ; DS:[BX+SI]에서 1바이트를 읽어 AL에
                                    ; 저장한다
            STOSB                   ; ES:D1에 AL값을 저장한다.
            INC     BX              ; BX값을 1씩 누적한다
            LOOP    R_DATA_4        ; 반복루프
; 5FA4H-공백
            MOV     AX,5FA4H
            MOV     ES,AX           ; ES에 5FA4H를 넣는다
            MOV     DI,0            ; DI에 초기값 0을 넣는다
            MOV     AX,OFFSET RD_XX
            MOV     SI,AX
            MOV     CX,6            ; 6번 반복하도록 한다.
            MOV     BX,0            ; BX에 초기값 0을 넣는다.
            CLD
R_DATA_5:
            MOV     AL,[BX+SI]      ; DS:[BX+SI]에서 1바이트를 읽어 AL에
                                    ; 저장한다
            STOSB                   ; ES:D1에 AL값을 저장한다.
            INC     BX              ; BX값을 1씩 누적한다
            LOOP    R_DATA_5        ; 반복루프      
; 5FA5H-아이템(작은 점)
            MOV     AX,5FA5H
            MOV     ES,AX           ; ES에 5FA5H를 넣는다
            MOV     DI,0            ; DI에 초기값 0을 넣는다
            MOV     AX,OFFSET RD_02
            MOV     SI,AX
            MOV     CX,6            ; 6번 반복하도록 한다.
            MOV     BX,0            ; BX에 초기값 0을 넣는다.
            CLD
R_DATA_6:
            MOV     AL,[BX+SI]      ; DS:[BX+SI]에서 1바이트를 읽어 AL에
                                    ; 저장한다
            STOSB                   ; ES:D1에 AL값을 저장한다.
            INC     BX              ; BX값을 1씩 누적한다
            LOOP    R_DATA_6        ; 반복루프        
; 5FA6H-출구(네모)
            MOV     AX,5FA6H
            MOV     ES,AX           ; ES에 5FA6H를 넣는다
            MOV     DI,0            ; DI에 초기값 0을 넣는다
            MOV     AX,OFFSET RD_02
            MOV     SI,AX
            MOV     CX,6            ; 6번 반복하도록 한다.
            MOV     BX,0            ; BX에 초기값 0을 넣는다.
            CLD
R_DATA_7:
            MOV     AL,[BX+SI]      ; DS:[BX+SI]에서 1바이트를 읽어 AL에
                                    ; 저장한다
            STOSB                   ; ES:D1에 AL값을 저장한다.
            INC     BX              ; BX값을 1씩 누적한다
            LOOP    R_DATA_7        ; 반복루프