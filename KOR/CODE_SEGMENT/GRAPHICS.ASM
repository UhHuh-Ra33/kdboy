; 4.6 그래픽 처리
; Page 124 - 149
; 그래픽 처리
; 기능: 여라가지 그래픽 처리를 한다
; 입력: 그래픽 기능 번호의 값을 AL 레지스터에 넣는다
; 출력: 화면
GRASUB      PROC        NEAR

            CMP         AH,0            ; AH 레지스터 값이 0과
            JNE         GRAS1           ; 같지 않으면 GRAS1으로 분기한다.
                                        ; AH 레지스터 값이 0이면
            CALL        G0SUB           ; 그림 데이터를 화면에 그린다.
            
            RET                         ; 복귀한다.
GRAS1:
            CMP         AH,1            ; AH 레지스터 값이 1과
            JNE         GRAS2           ; 같지 않으면 GRAS2로 간다.
            CALL        G1SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS2:
            CMP         AH,2            ; AH 레지스터 값이 2과
            JNE         GRAS3           ; 같지 않으면 GRAS3로 간다.
            CALL        G2SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS3:
            CMP         AH,3            ; AH 레지스터 값이 3과
            JNE         GRAS4           ; 같지 않으면 GRAS4로 간다.
            CALL        G3SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS4:
            CMP         AH,4            ; AH 레지스터 값이 4과
            JNE         GRAS5           ; 같지 않으면 GRAS5로 간다.
            CALL        G4SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS5:
            CMP         AH,5            ; AH 레지스터 값이 5과
            JNE         GRAS6           ; 같지 않으면 GRAS6로 간다.
            CALL        G5SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS6:
            CMP         AH,6            ; AH 레지스터 값이 6과
            JNE         GRAS7           ; 같지 않으면 GRAS7로 간다.
            CALL        G6SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS7:
            CMP         AH,7            ; AH 레지스터 값이 7과
            JNE         GRAS8           ; 같지 않으면 GRAS8로 간다.
            CALL        G7SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS8:
            CMP         AH,8            ; AH 레지스터 값이 8과
            JNE         GRAS9           ; 같지 않으면 GRAS9로 간다.
            CALL        G8SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS9:
            CMP         AH,9            ; AH 레지스터 값이 9과
            JNE         GRAS10          ; 같지 않으면 GRAS10로 간다.
            CALL        G9SUB           ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS10:
            CMP         AH,10           ; AH 레지스터 값이 10과
            JNE         GRAS11          ; 같지 않으면 GRAS11로 간다.
            CALL        G10SUB          ; 화면의 그림을 데이터로 저장한다.
            RET                         ; 복귀한다
GRAS11:
            RET                         ; 복귀한다
    
GRASUB      ENDP

; 그림 데이터를 화면에 출력
; 기능: 그림 데이터를 화면에 그린다
; 입력: X1값을 GX1에 X2값을 GX2에, Y1값을 GY1에, Y2값
;       은 GY2에 넣고, 그림 데이터가 저장되어 있는 버퍼의
;       세그먼트값을 GESG에, 오프셋값을 GOFF에 넣는다.
; 출력: 화면

G0SUB       PROC        NEAR
            MOV         AX,GX2
            SUB         AX,GX1          ; X2에서 X1 값을 뺀다
            AND         AL,00000001B
            CMP         AL,00000001B    ; 그림 데이터의 X축 길이가 짝수가 아니면
            JNE         G0_HS           ; G0_HS 로 간다.

            CALL        G0SUB_J         ; 그림 데이터를 화면에 그린다 (2)
                                        ; 보다 빠른 그래픽 처리를 하기 위해서
                                        ; 이다. 2바이트 단위로 그림 데이터를
                                        ; 화면에 그린다.
            RET                         ; 복귀한다.

G0_HS:
            MOV         BX,GY1
            SHL         BX,1            ; Y1의 값에 2를 곱해서 BX에 저장
            MOV         DX,GY2
            SHL         DX,1            ; Y2의 값에 2를 곱해서 DX에 저장
            MOV         S1,GOFF         ; 그림 데이터 시작 위치(Offset)

            MOV         CX,GX2
            MOV         AX,GX1
            MOV         CH,AL           ; CL에는 X2값을, CH에는 X1값을 넣는다.
G0_1:       
            PUSH        CX              ; CX값을 저장한다.
            PUSH        SI              ; SI값을 저장한다.                            
            MOV         SI,BX           ; 현재 그림을 그릴 Y축 값을 갖고 있는
                                        ; BX값을 S1에 넣는다.

; 5000:0000에는 라인 어드레스 값이 저장되어 있다.

            MOV         AX,5000H
            MOV         DS,AX           ; DX에 5000H를 넣는다.
            LODSW                       ; DS:S1에 젖아 되어 있는 라인 어드레스
                                        ; 값을 얻는다.
            MOV         ES,AX           ; 얻어온 라인 어드레스값을 ES에 넣는다.
            MOV         AH,0            ; AX의 상위 값을 지운다 (AH)
            MOV         AL,CH           ; X1값을 AL에 넣는다.
            MOV         DI,AX           ; AX값을 DI에 넣는다.
                                        ; 그림을 그릴 X값 DI에 넣는다.
            MOV         DS,BP           ; 데이터 세그먼트값이 저장되어 있는 BP
                                        ; 의 값을 DS에 넣는다.

            ADD         DI,SCREEN       ; D1에 SCREEN값을 넣는다.

            MOV         DS,GSEG         ; 그림 데이터 시작 위치(Segment)
            POP         SI              ; S1값을 찾는다.
            SUB         CL,CH           ; X1값에서 X1값을 뺀다.
            MOV         CH,0            ; CX의 상위값(CH)을 지운다.
            INC         CL              ; 1을 더한다.
                                        ; X축의 반복 횟수값을 구한다.
            CLD

G0_2:
            MOVSB                       ; 그림 데이터 1바이트를 비디오 버퍼
                                        ; (화면)로 옮긴다.
            LOOP        G0_2            ; 이 내용을 반복 처리한다.
                                        ; X축의 그림을 그린다.
G0_3:
            POP         CX              ; CX값을 찾는다.
            CMP         BX,DX           ; BX값과 DX값이
            JE          G0_4            ; 같으면 G0_4로 간다.
                                        ; Y축의 글미을 다 그렸으면 G0_4로

            INC         BX              ; 다음 라인에 그림을 그리기 위해 BX
            INC         BX              ; 값을 누적한다.
            JMP         SHORT G0_1      ; G0_1으로 돌아간다.
G0_4:
            MOV         DS,BP           ; 데이터 세그먼트값이 저장되어 있는 BP
                                        ; 값을 DS에 넣는다.
                                        ; 바뀐 DS값을 복구한다.

            RET

G0SUB       ENDP
