; 초롱이의 모험 데이터 세그먼트 
; PAGE 406 ~ 412
DATA SEGMENT    

; LEVEL
LVL_H           DB      00H             ; 현재 게임중인 레벨의 상위값
LVL_L           DB      00H             ; 현재 게임중인 레벨의 하위값

MAX_X           DB      00H             ; 레벨(미로)의 X축 크기
MAX_Y           DB      00H             ; 레벨(미로)의 Y축 크기
F_GAME          DB      0               ; 마지막 레벨 선언
FINALGAME       DB      0   
FINALGAMEB      DB      00H 
LEVELEND        DB      0   

; BATTERY
ON_OFF          DB      00H 
BATSET          DB      00H 
BAT_SW          DB      0   

BATTERYKS       DB      00H             ; 주인공이 갖고 있는 건전지 개수
BAT_TIME        DB      0   
BAT_TIMEB       DB      0   
BATTERYEND      DB      0   

DEL_BAT         DB      0   

LASEROF         DB      00H             ; 레이저총의 건전지 사용 상태
LASERKS         DB      00H             ; 레이저총에 사용산 건전지의 남은 양
RADAROF         DB      00H             ; 레이더의 건전지 사용 상태
RADARKS         DB      00H             ; 레이더에 사용하는 건전지의 남은 양
HELMETOF        DB      00H             ; 헬멧의 건전지 사용 상태
HELMETKS        DB      00H             ; 헬멧에 사용하는 건전지의 남은 양

RADAR_T         DB      0   
RADAR_SW        DB      00H 
HELMET_T        DB      0   

; ICON-INDEX
INCON_NO        DB      00H 
INDEX_P         DB      0   
INDEX_PB        DB      0   
INDEX_SW1       DB      0   

; WEAPON
USE_WEAPON      DB      0               ; 현재 사용하는 무기
BIRDKS          DW      0               ; 새총 사용 횟수
GUNKS           DW      0               ; 권총 사용 횟수
SPELLKS         DW      0               ; 마법 사용 횟수

; ITEM & SPELL
WIZARD          DB      0   
WIZARDX         DB      0   
RANTERNQ        DB      0               ; 초롱    
RANTERN         DW      0               
X_MAN           DB      0               ; 투명 인간 사용 여부    
X_MAN_TIME      DB      0               ; 투명 인간 남은 시간
SUPERRADAR      DB      0               ; 강화 레이더 사용 여부
WIZ_LIGHT       DB      0               ; 마법의 불 사용 여부
SKELETON        DB      0               ; 주인공이 얻은 해골 아이템 개수

; PLAYER STATE
P_BH            DB      00H             ; 주인공이 향하고 있는 방향
p_BH_X          DB      0
P_STATE         DB      00H,00H,00H,00H ; 주인공의 주변 상황
LIFEKS          DB      0               ; 주인공의 남은 에너지 개수
D_FACE          DB      00H             ; 화면에 출력할 주인공 얼굴 그림값
COMBAT          DB      00H             ; 전투 상태 체크
MOVE_Q          DB      0               ; 움직임 체크
LEVEL_Q         DB      0               ; 레벨 종료 체크

; PLAYER POSITION
PLAY_Y          DB      00H             ; 미로 내의 주인공 X축 위치
PLAY_X          DB      00H             ; 미로 내의 주인공 Y축 위치
PLAY_XB         DB      00H
PLAY_YB         DB      00H

FW_MON          DB      0
FW_MONB         DB      0
FWD_Q           DB      0
FWD_R           DW      0
FORWARD         DW      0
FORWARDX        DB      0

; GRAPHICS
GSEG            DW      0000H
GOFF            DW      0000H
GSOFF           DW      0000H
GX1             DW      0000H
GY1             DW      0000H
GX2             DW      0000H
GY2             DW      0000H
GTSEG           DW      0000H

GX1B            DW      0
GX2B            DW      0
GY1B            DW      0
GY2B            DW      0
GSOFFB          DW      0

SCRDATA         DB      31H,28H,29H,08H,68H,02H,64H,65H
                DB      02H,03H,02H,01H,1EH     ; 허큘레스 데이터

G_CARD          DB      0               ; 사용중인 그래픽 카드

GADD            DW      0000H
GAD             DW      0000H

SCREEN          DW      0000H

RG_X1           DB      00H
RG_Y1           DB      00H
RG_X2           DB      00H
RG_Y2           DB      00H

; TIME
TIMECHOKI       DB      00H

TIME_M          DW      0000H           ; 남은 시간(분)
TIME_S          DW      0000H           ; 남은 시간(초)

TIME_A          DB      0

RND             DW      1891H           ; 난수용 변수

STIME           DB      0
SR_TIME         DB      0
TIMEOVER        DB      0
;
VAL0            DB      00H
VAL1            DB      00H
VAL2            DB      00H
VAL3            DB      00H
VALUE01         DB      00H
LOOPING         DW      0000H
LOOPING1        DW      0000H
LOOPING2        DW      0
LOOPINGX        DW      0
LOOPINGY        DW      0

; FILE
DRIVEKS         DB      00H             ; 드라이브 개수
DRIVEKSB        DB      00H

ADRIVE          DB      00H             ; A 드라이브
BDRIVE          DB      00H             ; B 드라이브

M_DRIVE         DB      0               ; MAIN 디스켓이 들어 있는 드라이브
D_DRIVE         DB      0               ; DATA 디스켓이 들어 있는 드라이브

FDLEN           DW      0000H           ; 화일 길이
FDSEG           DW      0000H           ; 화일 위치
FNOFF           DW      0000H           ; 화일 이름 저장 위치
ERROR           DB      00H             ; 에러

A_FILE          DB      'A.CWS',0
B_FILE          DB      'B.CWS',0  
C_FILE          DB      'C.CWS',0
D_FILE          DB      'D.CWS',0
E_FILE          DB      'E.CWS',0
F_FILE          DB      'F.CWS',0
G_FILE          DB      'G.CWS',0
H_FILE          DB      'H.CWS',0
I_FILE          DB      'I.CWS',0
J_FILE          DB      'J.CWS',0
K_FILE          DB      'K.CWS',0
L_FILE          DB      'L.CWS',0
M_FILE          DB      'M.CWS',0

MIROFILE        DB      'L00.MRO',0
RANKNAME        DB      'R.CWS',0

; RADAR
RD_00           DB      0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
RD_01           DB      0AAH,55H,0AAH,55H,0AAH,55H
RD_02           DB      0FFH,0FFH,0E7H,0E7H,0FFH,0FFH
RD_1X           DB      0,7EH,7EH,7EH,7EH,0
RD_FE           DB      0FFH,0C3H,0DBH,0DBH,0C3H,0FFH
RD_FF           DB      0FFH,0E7H,0C3H,0C3H,0E7H,0FFH
RD_XX           DB      0,0,0,0,0,0

BLANK           DB      0

; MONSTER
MST_X           DB      0
MST_Y           DB      0
MST_ADR         DW      0
MST_MOVE        DB      0

MON_MOVE        DB      0
MST_MOVEB       DB      0

MST_XB          DB      0
MST_YB          DB      0

MST_B0          DB      0
MST_B1          DB      0
MST_B2          DB      0
MST_B3          DB      0

TIME_MONSTER    DW      0000H
MON_TIME_SW     DB      0

FORWARD_STEP    DB      0,0,0,0,0
FORWARD_STOP    DB      0,0,0,0,0

VALUE_A         DW      0

GAME_OVER       DB      0

; TARGET
TARGET_X        DB      0               ; 과녁 X 좌표
TARGET_Y        DB      0               ; 과녁 Y 좌표
TARGET_XB       DB      0
TARGET_YB       DB      0

TARGET_Q        DB      0
TAR_SW          DB      0
TARGET_BH       DB      0               ; 과녁 움직임 방향
T_SPEED         DB      0               ; 과녁 움직임 지연 시간

; SCORE
SCORE           DB      0,0,0,0,0,0     ; ORIGINAL
SCOREA          DB      0,0,0,0,0,0     ; ADD ?
B_SCORE         DB      0,0,0,0,0,2     ; BONUS SCORE

ITEMS0          DB      0,0,0,1,5,0     ; 건전지 점수
ITEMS1          DB      0,0,0,0,8,0     ; 총알 점수
ITEMS2          DB      0,0,0,3,0,0     ; 두루마리 점수
ITEMS3          DB      0,0,0,0,3,0     ; 돌 점수
ITEMS4          DB      0,0,0,6,0,0     ; 생명수 점수
ITEMS5          DB      0,0,0,8,0,0     ; 초롱 점수
ITEMS6          DB      0,0,0,0,5,0     ; 사과 점수
ITEMS7          DB      0,0,0,5,0,0     ; 시계 점수
ITEMS8          DB      0,0,0,2,5,0     ; 해골 점수
ITEMS9          DB      0,0,1,5,0,0     ; 돈주머니 점수

MONS0           DB      0,0,0,5,0,0     ; 박쥐 점수
MONS1           DB      0,0,1,0,0,0     ; 거미 점수
MONS2           DB      0,0,2,0,0,0     ; 유령 점수
MONS3           DB      0,0,3,0,0,0     ; 해골 점수
MONS4           DB      0,0,5,0,0,0     ; 미라 점수

BONUS           DB      1,14,13,20,18
BONUSX          DB      0

; CARVE
CARVEFONT       DB      00H
CARVENAME       DB      0,0,0,0,0,0,0,0
CARVENAMEB      DB      0
CARVE_NO        DW      0
CARVE_NOB       DW      0
INSERTDATA      DB      8,13,18,4,17,19,37,3,0,19,0,37,33
INSERTMAIN      DB      8,13,18,4,17,19,37,12,0,8,13,37,33

B_B             DB      0,0,0,0,0,0,0,0

R_X1            DW      0
R_X2            DW      0
R_X3            DW      0

; SOUND & DELAY
SDATA01         DW      0
SDATA02         DW      0
SDATA03         DW      0
SDATA04         DW      0
SOUNDD          DW      0
SOUNDDD         DW      0

SPEEDDATA       DW      0000H
DELAYDATA       DW      26

LOOPER          DB      0

C_F             DB      0
C_H             DB      0

GRASW           DW      0

G_PAGE          DB      0

START_VAL       DB      0

H_HER           DB      ' H. HERCULES '
C_CGA           DB      ' C. CGA '
HCHC            DB      0

YESNO           DB      0               ; 게임 종료 선택
ENDMSG          DB      'THANK YOU...   CWS'

D_ERROR         DB      00H
KEY_PUSH        DB      00H
KEY_KEY         DW      0000H

EYE_EYE         DW      0000H           ; 게임 중 눈깜빡임 체크

WIZ_SCROL       DB      ?
WIZ_SC_SW       DB      ?

PUSH_KEY0       DB      ?
PUSH_KEY1       DW      0000H

NJNJ            DW      0000H
CGAMODE         DB      00H

TITLE_X1        DW      00H
TITLE_X2        DW      00H
TITLE_SW        DW      00H

DATA            ENDS