; 게임 준비 작업(2)
; 기능 : 드라이브 개수를 선택하게 한다
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
                                    