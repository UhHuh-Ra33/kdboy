; 게임 준비 작업(2)
; 기능 : 드라이브 개수를 선택하게 한다
; PAGE 58 ~ 64
            MOV     AL,M_DRIVE
            MOV     ADRIVE,AL       ; TODO: ADRIVE의 출처
            MOV     AL,D_DRIVE
            MOV     BDRIVE,AL       ; TODO: BDRIVE의 출처

; 레벨은 두 자리로 되어 있는데, 이것을 하위와 상위로 나누어 처리한다.
            MOV     LVL_L,0         ; 레벨의 하위값에 0을 넣는다.
            MOV     LVL_H,0         ; 레벨의 상위값에 0을 넣는다.

            MOV     BAT_SW,2

; 메세지 및 주인공 표정등의 데이터가 저장되어 있는 A.CWS 화일을 읽는다
A_LOAD:
            MOV     AX,OFFSET A_FILE        ; A_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구해서
                                            ; FNOFF에 넣는다
            MOV     AX,43072
            MOV     FDLEN,AX        ; 화일 길이
            MOV     AX,4000H
            MOV     FDSEG,AX        ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D          ; A.CWS를 읽는다

            CMP     ERROR,1         ; ERROR가 1과
            JE      A_LOAD          ; 같으면 A_LOAD로 돌아간다.
                                    ; 화일로드시 에러가 발생하면 ERROR
                                    ; 값은 1로 된다.
                                    ; 에러가 없으면 다음 행으로 간다.

; 폰트 및 아이템, 아이콘 데이터 등이 저장되어 있는 B.CWS 화일을 읽는다.
B_LOAD:
            MOV     AX,OFFSET B_FILE        ; B_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구해서
                                            ; FNOFF에 넣는다
            MOV     AX,63536
            MOV     FDLEN,AX        ; 화일 길이
            MOV     AX,5000H
            MOV     FDSEG,AX        ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D          ; B.CWS를 읽는다

            CMP     ERROR,1         ; ERROR가 1과
            JE      B_LOAD          ; 같으면 A_LOAD로 돌아간다.
                                    ; 화일로드시 에러가 발생하면 ERROR
                                    ; 값은 1로 된다.
                                    ; 에러가 없으면 다음 행으로 간다.
            
            CMP     G_CARD,2        ; 사용자가 고른 그래픽 모드가 2와
            JE      L_LOAD          ; 같으면 L_LOAD로 간다.
                                    ; 1=허큘레스, 2=CGA
            JMP     SHORT EE_LOAD   ; EE_LOAD로 간다

; CGA 모드용 라인 어드레스값이 저장되어 있는 L.CWS 화일을 읽는다.
L_LOAD:
            MOV     AX,OFFSET L_FILE        ; L_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구해서
                                            ; FNOFF에 넣는다
            MOV     AX,800
            MOV     FDLEN,AX        ; 화일 길이
            MOV     AX,5000H
            MOV     FDSEG,AX        ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D          ; L.CWS를 읽는다
            CMP     ERROR,1         
            JE      L_LOAD          ; 에러가 있으면 L_LOAD로 돌아간다.
            
            MOV     GADD,4000H
            MOV     GAD,400H

            CMP     CGAMODE,0       ; CGAMODE가 0과
            JE      CGA_MODE_SET1   ; 같으면 CGA_MODE_SET1으로 간다.

; 작은 CWS 로고 그림 데이터가 저장되어 있는 H.CWS 화일을 읽는다.

H_LOAD:
            MOV     AX,OFFSET H_FILE        ; H_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구해서
                                            ; FNOFF에 넣는다
            MOV     AX,2734
            MOV     FDLEN,AX        ; 화일 길이
            MOV     AX,7000H
            MOV     FDSEG,AX        ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D          ; H.CWS를 읽는다

            CMP     ERROR,1         ; ERROR가 1과
            JE      H_LOAD          ; 에러가 있으면 L_LOAD로 돌아간다.

; 현재 화면 전체를 지운다.

            MOV     GX1,0           ; X1=0
            MOV     GX2,79          ; X2=79
            MOV     GY1,0           ; Y1=0
            MOV     GT2,399         ; Y2=399
            MOV     AH,6            ; 화면을 지우는 기능
            MOV     AL,0
            CALL    GRASUB          ; 그래픽 처리

; 작은 CWS 마크를 그린다.

            MOV     GX1,33          
            MOV     GX2,46          
            MOV     GY1,6           
            MOV     GT2,140      
            MOV     GSEG,7000H      ; H.CWS로 읽어들인 데이터
            MOV     GOFF,640H        
            MOV     AH,0            ; 그림 더에티러르 화면에 그린다.
            CALL    GRASUB          ; 그래픽 처리  

            CALL    DELKEY          ; 키 버퍼의 내용을 지운다.

            MOV     CX,3000         ; 3,000mSec(3초) 동안 
            CALL    DELAY           ; 지연한다.

; 화면에서 그림 데이터를 위로 올라가게 만든다.

            MOV     GX1,0          
            MOV     GX2,79          
            MOV     GY1,379           
            MOV     GT2,389
            MOV     GSEG,7000H
            MOV     GOFF,0
H_LOAD1:
            MOV     AH,0            ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB          ; 그래픽 처리

            MOV     AX,GY1          ; GY1값을 AX에 복사한다.
            PUSH    AX              ; AX값을 저장한다.
; 조금전 그린 그림의 맨 아래를 지운다.
            INC     GY2
            MOV     AX,GY2
            MOV     GY1,AX
            MOV     AH,6            ; 화면을 지운다
            MOV     AL,0            
            CALL    GRASUB          ; 그래픽 처리

            POP     AX              ; AX값을 찾는다.
            DEC     AX              ; AX값에서 1을 뺀다.
            MOV     GY1,AX          ; AX값을 GY1에 복사한다.
                                    ; 다음에 그림을 그릴 때에는 한 줄 위에
                                    ; 그림을 그리게 된다.
            ADD     AX,19
            MOV     GY2,AX          ; AX에 19을 더해서 GY2에 넣는다.

            CMP     GY1,179         ; GY1이 179와
            JNE     H_LOAD1         ; 같지 않으면 H_LOAD1으로 돌아간다

; 드라이브 개수 선택 그림 데이터가 저장 되어 있는 E.CWS 화일을 읽는다.

E_LOAD:
            MOV     AX,OFFSET E_FILE        ; E_FILE(화일명)의 시작 위치
            MOV     FNOFF,AX                ; (OFFSET) 값을 구해서
                                            ; FNOFF에 넣는다
            MOV     AX,32000
            MOV     FDLEN,AX        ; 화일 길이
            MOV     AX,7000H
            MOV     FDSEG,AX        ; 화일 데이터를 옮길 위치(Segment)
            CALL    LOAD_D          ; E.CWS를 읽는다

            CMP     ERROR,1         ; ERROR가 1과
            JE      E_LOAD          ; 에러가 있으면 E_LOAD로 돌아간다.

; 키 입력을 기다린다.
; 일정 시간 동안 키 입력이 없을 경우 다음 내용을 처리한다.
            MOV     CX,0

EX_LOAD:
            PUSH    CX              ; CX 값을 저장한다.

            MOV     CX,1
            CALL    DELAY           ; 시간 지연을 한다.

            POP     CX              ; CX값을 찾는다.

            CMP     CX,8888         ; CX값이 8888과
            JE      EXE_LOAD        ; 같으면 EXE_LOAD로 간다.
            INC     CX              ; CX값을 1씩 누적한다

            MOV     AH,1
            INT     16H             ; 키 입력을 받는다
            JZ      EX_LOAD         ; 아무 키도 입력되지 않았으면 EX_LOAD
                                    ; 로 간다.

; 드라이브 개수 선택 그림을 화면에 그린다.

EXE_LOAD:
            MOV     GSEG,7000H      ; 그림 데이터의 시작 위치(Segment)
            MOV     GOFF,0          ; 그림 데이터의 시작 위치(Offset)
            MOV     GX1,0           ; X1=0
            MOV     GY1,0           ; Y1=0
            MOV     GX2,79          ; X2=79
            MOV     GY2,399         ; Y2=399
            MOV     AH,0            ; 그림 데이터를 화면에 그린다.
            CALL    GRASUB          ; 그래픽 처리

            MOV     CX,500          ; 500mSec(0.5초) 동안
            CALL    DELAY           ; 시간 지연

            CALL    DELKEY          ; 키 버퍼의 내용을 지운다
            
            MOV     DRIVEKS,1       ; 드라이브 개수 초기 값으 1로 한다.

            MOV     VALUE01,0       ; 손가락을 그리기 전의 초기값
            CALL    MF_INDEX        ; 손가락 그림을 화면에 그린다.

; 드라이브 개수 선택

MF1:
            MOV     AH,0
            INT     16H             ; 키 입력을 받는다.
                                    ; AL에는 아스키 코드가
                                    ; AH에는 스캔 코드가 저장된다.
            
            CMP     AH,75           ; AH가 왼쪽 화살표키 코드값과
            JNE     MF2             ; 같지 않으면 MF2로 간다.
                                    ; 같으면 다음 행을 처리한다.
            MOV     DRIVEKS,1       ; 드라이브 개수 한개를 선택한다.
            CALL    MF_INDEX        ; 손가락 그림을 화면에 그린다.

            JMP     SHORT MF1       ; MF1으로 돌아간다.
MF2:
            CMP     AH,77           ; AH가 오른쪽 화살표키 코드값과
            JNE     MF3             ; 같지 않으면 MF3로 간다.
                                    ; 같으면 다음 행을 처리한다.

            MOV     DRIVEKS,2       ; 드라이브 개수 한개를 선택한다.
            CALL    MF_INDEX        ; 손가락 그림을 화면에 그린다.

            JMP     SHORT MF1       ; MF1으로 돌아간다.
MF3:
            CMP     AL,13           ; AL가 RETURN키 코드값과
            JNE     MF1             ; 같지 않으면 MF1로 간다.
                                    ; 같으면 다음 행을 처리한다.
MF4:
            CALL    SOUND04         ; 소리를 낸다

            MOV     AL,M_DRIVE
            MOV     ADRIVE,AL       ; MDRIVE 값을 ADRIVE에 복사
            MOV     BDRIVE,AL       ; MDRIVE 값을 BDRIVE에 복사

            CMP     DRIVEKS,2       ; 드라이브 개수가 두개가
            JNE     C_LOAD          ; 아니면 C_LOAD로 간다.

            CMP     M_DRIVE,1       ; 메인 디스켓이 들어 있는 드라이브가
                                    ; A 드라이브(A=1, B=2)
            JE      MF5_000         ; 같으면 MF5_000으로 간다
            CMP     M_DRIVE,2       ; 메인 드라이브가 B 드라이브와
            JE      MF5_000         ; 같으면 MF5_000으로 간다.

            MOV     BDRIVE,1
            MOV     D_DRIVE,1
            JMP     SHORT C_LOAD    ; C_LOAD로 간다.

MF5_000:
            MOV     BDRIVE,0
            MOV     D_DRIVE,0
