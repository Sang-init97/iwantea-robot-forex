
//|                                                 EALifeChange.mq4 |
//|                                                   Tran Dinh Sang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#define Copyright    "Tran Dinh Sang"
#property copyright "Tran Dinh Sang - sang.tran2197@gmail.com"
#property link      "https://www.facebook.com/andrew.soll.97"
#define ExpertName   "IWantBot EA"
#define Version      "1.00"
#property strict
/*********************************************************************/
/*                     Include Area - START                           */
/*********************************************************************/

#include <stdlib.mqh>
#include <stderror.mqh>
#include <WinUser32.mqh>
#include <IWantBoxLib.mqh>

/*********************************************************************/
/*                      Include Area - END                            */
/*********************************************************************/

/*********************************************************************/
/*                Input Parameter Declearation - START               */
/*********************************************************************/

enum RunMode_en
{
   Slow = 0,
   Agressive 
}

enum NewsCloseMode_en
{
   DontUse_Close  = 0, // Don't use Close 
   CloseAll_Order,     // Close All Order
   ClosePositive_Order, // Close Positive Order
   CloseNegative_Order // Close Negative Order
};

enum TradeStrategy_en
{
  DontUse_AnyStrategy = 0, // Don't Use Any Strategy
  TOKYO_Strategy, // Tokyo Strategy 
  LONDON_Strategy, // London Strategy 
  ADX_RSI_ICHI_Strategy, // ADX-ICHI Strategy 
  ADX_RSI_ICHI_Strategy_Revert, // ADX-ICHI Revert Strategy 
  PINBAR_Strategy, // Pinbar Strategy  
  MAGICBOX_Strategy, // MagicBox Strategy 
  MAGICBOX_Strategy_Revert, // MagicBox Revert Strategy 
  HMA_ADX_Strategy,    // HMA Strategy 
  PARA_ADX_Strategy,    // PARA Strategy  
};

enum SymbolSetting_en
{
   ABCXYZ = 0,
   ABCXYZm,
   ABCXYZc
};

enum TP_Slection_en
{
   TP_1 = 0, // Take Profit 1
   TP_2,     // Take Profit 2
   TP_3      // Take Profit 3
};

enum SL_Slection_en
{
   SL_1 = 0, // Stop Loss 1
   SL_2,     // Stop Loss 2
   SL_3,     // Stop Loss 3
};

enum GBPUSD_Selection_en
{
  Option_1 = 0, // Option 1
  Option_2 // Option 2
};

extern string CONTACT                        = "----------------| CONTACT |----------------";
extern string EMAIL                          = "sang.tran2197@gmail.com";
extern string TELEGRAM                       = "https://t.me/SagzTran";

extern string TRADING_SETTING                = "----------------| TRADING SETTING |----------------"; // TRADING SETTING
input string Commnet                         = "IWantBot X EA";
input int MagicNumber                        = 888888;  // Magic Number
input RunMode_en  RunMode                    = Slow;    // Run Mode
input bool FilterTime_Use                    = true;    // Filter Time Using
input int Slippage                           = 5;       // Slippage
input double TakeProfit_1                    = 30.0;    // Take Profit 1
input double TakeProfit_2                    = 35.0;    // Take Profit 2
input double TakeProfit_3                    = 40.0;    // Take Profit 3
input double StopLoss_1                      = 20.0;    // Stop Loss 1
input double StopLoss_2                      = 25.0;    // Stop Loss 2
input double StopLoss_3                      = 30.0;    // Stop Loss 3
bool NewBar_Use                        = true; // Check Candle Close
extern string LOT_SETTING                    = "---------------------------------------"; // ------------------------------------
input bool RisKManagement_Use                = false;   // Risk Management Using
input double FixLot                          = 0.01;    // Risk Fix Lot
input double Percent_Risk                    = 1.0;     // Risk Percent
extern string TRAILING_SETTING               = "---------------------------------------"; // ------------------------------------
input bool TrailingStop_Setting              = true;   // Trailing Using
input double Trailing_Start                  = 10.0;    // Trailing Start
input double Trailing_Stop                   = 25.0;   // Trailing Stop
input double Trailing_Step                   = 3.0;    // Trailing Step

extern string PAIRS_SETTING                  = "---------------------------------------"; // ------------------------------------
SymbolSetting_en  Symbol_Setting                                        = ABCXYZ;   // Symbol Setting
input bool AUDCAD                                                       = true;   
input TradeStrategy_en TradeStrategy_AUDCAD                             = LONDON_Strategy; // Trade Strategy AUDCAD
input TP_Slection_en TP_AUDCAD                                          = TP_1; // Take Profit AUDCAD
input SL_Slection_en SL_AUDCAD                                          = SL_1; // Stop Loss AUDCAD

input bool AUDNZD                                                       = true;
input TradeStrategy_en TradeStrategy_AUDNZD                             = DontUse_AnyStrategy; // Trade Strategy AUDNZD 
input TP_Slection_en TP_AUDNZD                                          = TP_1; // Take Profit AUDNZD
input SL_Slection_en SL_AUDNZD                                          = SL_1; // Stop Loss AUDNZD

input bool AUDCHF                            = true;
input TradeStrategy_en TradeStrategy_AUDCHF                             = TOKYO_Strategy; // Trade Strategy AUDCHF
input TP_Slection_en TP_AUDCHF                                          = TP_1; // Take Profit AUDCHF
input SL_Slection_en SL_AUDCHF                                          = SL_1; // Stop Loss AUDCHF

input bool AUDUSD                            = true;
input TradeStrategy_en TradeStrategy_AUDUSD                             = HMA_ADX_Strategy; // Trade Strategy AUDUSD
input TP_Slection_en TP_AUDUSD                                          = TP_1; // Take Profit AUDUSD
input SL_Slection_en SL_AUDUSD                                          = SL_2; // Stop Loss AUDUSD

input bool AUDJPY                            = true;
input TradeStrategy_en TradeStrategy_AUDJPY                             = TOKYO_Strategy; // Trade Strategy AUDJPY
input TP_Slection_en TP_AUDJPY                                          = TP_2; // Take Profit AUDJPY
input SL_Slection_en SL_AUDJPY                                          = SL_2; // Stop Loss AUDJPY

input bool CADJPY                            = true;
input TradeStrategy_en TradeStrategy_CADJPY                             = TOKYO_Strategy; // Trade Strategy CADJPY
input TP_Slection_en TP_CADJPY                                          = TP_2; // Take Profit CADJPY
input SL_Slection_en SL_CADJPY                                          = SL_2; // Stop Loss CADJPY

input bool CADCHF                            = true;
input TradeStrategy_en TradeStrategy_CADCHF                             = DontUse_AnyStrategy; // Trade Strategy CADCHF 
input TP_Slection_en TP_CADCHF                                          = TP_1; // Take Profit CADCHF
input SL_Slection_en SL_CADCHF                                          = SL_1; // Stop Loss CADCHF

input bool CHFJPY                            = true;
input TradeStrategy_en TradeStrategy_CHFJPY                             = MAGICBOX_Strategy; // Trade Strategy CHFJPY
input TP_Slection_en TP_CHFJPY                                          = TP_1; // Take Profit CHFJPY
input SL_Slection_en SL_CHFJPY                                          = SL_1; // Stop Loss CHFJPY

input bool EURCAD                            = true;
input TradeStrategy_en TradeStrategy_EURCAD                             = HMA_ADX_Strategy; // Trade Strategy EURCAD
input TP_Slection_en TP_EURCAD                                          = TP_2; // Take Profit EURCAD
input SL_Slection_en SL_EURCAD                                          = SL_1; // Stop Loss EURCAD

input bool EURCHF                            = true;
input TradeStrategy_en TradeStrategy_EURCHF                             = HMA_ADX_Strategy; // Trade Strategy EURCHF
input TP_Slection_en TP_EURCHF                                          = TP_1; // Take Profit EURCHF
input SL_Slection_en SL_EURCHF                                          = SL_1; // Stop Loss EURCHF
 
input bool EURGBP                            = true;
input TradeStrategy_en TradeStrategy_EURGBP                             = DontUse_AnyStrategy ; // Trade Strategy EURGBP 
input TP_Slection_en TP_EURGBP                                          = TP_1; // Take Profit EURGBP
input SL_Slection_en SL_EURGBP                                          = SL_1; // Stop Loss EURGBP

input bool EURUSD                            = true;
input TradeStrategy_en TradeStrategy_EURUSD                             = ADX_RSI_ICHI_Strategy; // Trade Strategy EURUSD 
input TP_Slection_en TP_EURUSD                                          = TP_2; // Take Profit EURUSD
input SL_Slection_en SL_EURUSD                                          = SL_2; // Stop Loss EURUSD

input bool EURAUD                            = true;
input TradeStrategy_en TradeStrategy_EURAUD                             = MAGICBOX_Strategy; // Trade Strategy EURAUD
input TP_Slection_en TP_EURAUD                                          = TP_2; // Take Profit EURAUD
input SL_Slection_en SL_EURAUD                                          = SL_2; // Stop Loss EURAUD

input bool EURJPY                            = true;
input TradeStrategy_en TradeStrategy_EURJPY                             = TOKYO_Strategy; // Trade Strategy EURJPY 
input TP_Slection_en TP_EURJPY                                          = TP_2; // Take Profit EURJPY
input SL_Slection_en SL_EURJPY                                          = SL_2; // Stop Loss EURJPY

input bool GBPCHF                            = true;
input TradeStrategy_en TradeStrategy_GBPCHF                             = LONDON_Strategy; // Trade Strategy GBPCHF
input TP_Slection_en TP_GBPCHF                                          = TP_3; // Take Profit GBPCHF
input SL_Slection_en SL_GBPCHF                                          = SL_2; // Stop Loss GBPCHF

input bool GBPUSD                            = true;
input TradeStrategy_en TradeStrategy_GBPUSD                             = TOKYO_Strategy; // Trade Strategy GBPUSD
input TP_Slection_en TP_GBPUSD                                          = TP_3; // Take Profit GBPUSD
input SL_Slection_en SL_GBPUSD                                          = SL_2; // Stop Loss GBPUSD

input bool GBPCAD                            = true;
input TradeStrategy_en TradeStrategy_GBPCAD                             = DontUse_AnyStrategy; // Trade Strategy GBPCAD
input TP_Slection_en TP_GBPCAD                                          = TP_2; // Take Profit GBPCAD
input SL_Slection_en SL_GBPCAD                                          = SL_2; // Stop Loss GBPCAD

input bool GBPJPY                            = true;
input TradeStrategy_en TradeStrategy_GBPJPY                             = TOKYO_Strategy; // Trade Strategy GBPJPY
input TP_Slection_en TP_GBPJPY                                          = TP_3; // Take Profit GBPJPY
input SL_Slection_en SL_GBPJPY                                          = SL_2; // Stop Loss GBPJPY

input bool GBPAUD                            = true;
input TradeStrategy_en TradeStrategy_GBPAUD                             = ADX_RSI_ICHI_Strategy; // Trade Strategy GBPAUD
input TP_Slection_en TP_GBPAUD                                          = TP_2; // Take Profit GBPAUD
input SL_Slection_en SL_GBPAUD                                          = SL_2; // Stop Loss GBPAUD

input bool NZDCHF                            = true;
input TradeStrategy_en TradeStrategy_NZDCHF                             = DontUse_AnyStrategy; // Trade Strategy NZDCHF 
input TP_Slection_en TP_NZDCHF                                          = TP_1; // Take Profit NZDCHF 
input SL_Slection_en SL_NZDCHF                                          = SL_1; // Stop Loss NZDCHF 

input bool NZDCAD                            = true;
input TradeStrategy_en TradeStrategy_NZDCAD                             = DontUse_AnyStrategy; // Trade Strategy NZDCAD
input TP_Slection_en TP_NZDCAD                                          = TP_1; // Take Profit NZDCAD
input SL_Slection_en SL_NZDCAD                                          = SL_2; // Stop Loss NZDCAD

input bool NZDJPY                            = true;
input TradeStrategy_en TradeStrategy_NZDJPY                             = MAGICBOX_Strategy; // Trade Strategy NZDJPY 
input TP_Slection_en TP_NZDJPY                                          = TP_2; // Take Profit NZDJPY
input SL_Slection_en SL_NZDJPY                                          = SL_2; // Stop Loss NZDJPY

input bool NZDUSD                            = true;
input TradeStrategy_en TradeStrategy_NZDUSD                             = ADX_RSI_ICHI_Strategy; // Trade Strategy NZDUSD
input TP_Slection_en TP_NZDUSD                                          = TP_2; // Take Profit NZDUSD
input SL_Slection_en SL_NZDUSD                                          = SL_2; // Stop Loss NZDUSD 

input bool USDCAD                            = true;
input TradeStrategy_en TradeStrategy_USDCAD                             = PINBAR_Strategy; // Trade Strategy USDCAD
input TP_Slection_en TP_USDCAD                                          = TP_2; // Take Profit USDCAD
input SL_Slection_en SL_USDCAD                                          = SL_2; // Stop Loss USDCAD

input bool USDCHF                            = true;
input TradeStrategy_en TradeStrategy_USDCHF                             = HMA_ADX_Strategy; // Trade Strategy USDCHF 
input TP_Slection_en TP_USDCHF                                          = TP_1; // Take Profit USDCHF
input SL_Slection_en SL_USDCHF                                          = SL_1; // Stop Loss USDCHF

input bool USDJPY                            = true;
input TradeStrategy_en TradeStrategy_USDJPY                             = HMA_ADX_Strategy; // Trade Strategy USDJPY
input TP_Slection_en TP_USDJPY                                          = TP_1; // Take Profit USDJPY
input SL_Slection_en SL_USDJPY                                          = SL_1; // Stop Loss USDJPY


input string BREAKOUT_SETTING               = "------------------------------------"; // ------------------------------------
 string UniqueID                        = "TOKYO Section";   
 int    NumberOfDays                    = 50;        
input string periodA_begin              = "00:00"; // Start TOKYO Section    
input string periodA_end                = "06:00"; // Stop TOKYO Section        
int    nextDayA                         = 0;                 
                                                             
string periodB_end                      = "23:00";         
int    nextDayB                         = 0;                 
input bool TokyoSection_Display         = false;  // TOKYO Box Display                                                               
color  rectAB_color                     = PowderBlue; 
bool   rectAB_background                = true;               
color  rectA_color                      = Red;
bool   rectA_background                 = false;              
color  rectB1_color                     = DarkOrchid;
bool   rectB1_background                = false;             
int    rectB1_band                      = 0;                  
color  rectsB2_color                    = SkyBlue;
bool   rectsB2_background               = true;               
int    rectsB2_band                     = 0;  

input double Distance                   = 6; // Distance from High/Low Breakout

string MA_SETTING                       = "----------------| MA SETTING |----------------";
bool MA_CloseUse                        = false;
ENUM_TIMEFRAMES MA_TimeFrame            = PERIOD_M15;
ENUM_MA_METHOD MA_Method                = MODE_EMA;
int MA_Period                           = 100;

/*********************************************************************/
/*                Input Parameter Declearation - START               */
/*********************************************************************/
extern string ATR_SETTING               = "------------------------------------";  // ------------------------------------
bool Daily_Open_Line                    = false;      // Display Daily Open Line
input bool ADR_Entry                    = false;      // ATR Entry Using
input bool display_ADR                  = false;      // Display ATR Line
bool ADR_Line                           = false;     
input double ADR_Percent                = 40.0;       // ATR Percent %

extern string NEWS_SETTING               = "------------------------------------";  // ------------------------------------
input bool OpenNewOrderInNews_Allow                   = true; // Don't Open Order in News
input NewsCloseMode_en ClosePositiveOrderInNews_Use   = ClosePositive_Order; // Close Order in News
input double CloseTargetProfit                       = 10; // Close Order in Target ($)
input int AfterNewsStop                              = 30; // After News Stop (minutes)
input int BeforeNewsStop                             = 5;  // Before News Stop (minutes)
extern string NEWS2_SETTING               = "------------------------------------";  // ------------------------------------
input bool NewsLight                                 = false;  // News Light Impact
input bool NewsMedium                                = false;  // News Medium Impact
input bool NewsHard                                  = true;   // News High Impact
input  int GMT                                       = 0;      // News GMT Setting
input string NewsSymb                                = "USD"; // News Currency
input string News_Link                               = "http://ec.forexprostools.com/?columns=exc_currency"; // News Website Link
bool  DrawLines                                 = true;       
bool  Next                                      = false;    
bool  Signal                                    = false;   
bool AlertNew_Check                             = false;

input string TIME_SETTING_1                 = "------------------------------------"; // ------------------------------------
input int Hour_Start_2                      = 1;  // Hour Start Run (GMT +0)
input int Hour_End_2                        = 17; // Hour Stop Run (GMT +0)
input int Hour_Start_1                      = 6;  // Hour Start Run Tokyo (GMT +0)
input int Hour_End_1                        = 17; // Hour Stop Run Tokyo (GMT +0)
bool CloseOrderAuto_Use                    = true; // Close Order Auto Using
input string TARGET_PROFIT                  = "------------------------------------"; // ------------------------------------
input bool CloseTarget_Use                  = true; // Close Target Day Using
input double CloseAt_Profit                 = 20.0; // Profit Stop Day Target($)
input double CLoseAt_StopLoss               = 20.0; // Stop Loss Day Target($)
input string TimeFrame_Setting              = "------------------------------------"; // ------------------------------------
input ENUM_TIMEFRAMES ADX_TIMEFRAME         = PERIOD_M15; // Indicator TimeFrame ADX  
input ENUM_TIMEFRAMES ICHI_TIMEFRAME        = PERIOD_M15; // Indicator TimeFrame Ichimoku  
input ENUM_TIMEFRAMES MAGICBOX_TIMEFRAME    = PERIOD_M15; // Indicator TimeFrame MagicBox  
input ENUM_TIMEFRAMES HMA_TIMEFRAME         = PERIOD_M15; // Indicator TimeFrame HMA  
input ENUM_TIMEFRAMES PARA_TIMEFRAME        = PERIOD_M15; // Indicator TimeFrame PARA  
input int HMA_Period                        = 50.0; // Indicator HMA Period  
string ADDITIONAL_SETTING             = "------------------------------------"; // GBPUSD - DAILY BREAKOUT
bool GBPUSD_DailyBreakout_Use         = false; // GBPUSD Daily Breakout using
GBPUSD_Selection_en GBPUSD_Selection = Option_1; // GBPUSD Option Selection
double Distance_Break                  = 2.5; // GBPUSD Distance Break (Pips)
string GhiChu_01                         = "------------------------------------"; // ------------------------------------
double Lot_Option1                    = 0.01;  // Lot Option 1
double TP_Option1                     = 10; // TakeProfit Option 1
double SL_Option1                     = 5; // StopLoss Option 1
string GhiChu_02                         = "------------------------------------"; // ------------------------------------
double Lot1_Option2                    = 0.03;  // Lot 1 Option 2
double Lot2_Option2                    = 0.01;  // Lot 2 Option 2
double Lot3_Option2                    = 0.01;  // Lot 3 Option 2
double SL1_Option2                     = 5; // StopLoss 1 Option 2
double SL2_Option2                     = 5; // StopLoss 2 Option 2
double SL3_Option2                     = 5; // StopLoss 3 Option 2
double TP1_Option2                     = 5; // TakeProfit 1 Option 2
double TP2_Option2                     = 10; // TakeProfit 2 Option 2
double TP3_Option2                     = 15; // TakeProfit 3 Option 2



input string END           = "----------------| END |----------------"; 
/*********************************************************************/
/*                Input Parameter News Setting - START               */
/*********************************************************************/

/*********************************************************************/
/*                Input Parameter News Setting - END               */
/*********************************************************************/

int      BuyTicket;
int      SellTicket;

double   UsePoint;
int      UseSlipage;

static int PairTrade_Count = 0;

static string PairTrade[30] = {};

#define KEY_LEFT           37 
#define KEY_RIGHT          39 
#define KEY_UP             38 
#define KEY_DOWN           40 

#define INDENT_TOP         15
#define INDENT_BOTTOM      30

#define CLIENT_BG_X        5
#define CLIENT_BG_Y        20

#define CLIENT_BG_WIDTH    245
#define CLIENT_BG_HEIGHT   150

#define BUTTON_WIDTH       75
#define BUTTON_HEIGHT      20

#define BUTTON_GAP_X       5
#define BUTTON_GAP_Y       5

#define EDIT_WIDTH         75
#define EDIT_HEIGHT        18

#define EDIT_GAP_X         15
#define EDIT_GAP_Y         15

#define SPEEDTEXT_GAP_X    240
#define SPEEDTEXT_GAP_Y    28

#define SPEEDBAR_GAP_X     210
#define SPEEDBAR_GAP_Y     28

#define LIGHT              0
#define DARK               1

#define CLOSEALL           0
#define CLOSELAST          1
#define CLOSEPROFIT        2
#define CLOSELOSS          3
#define CLOSEPARTIAL       4

#define OPENPRICE          0
#define CLOSEPRICE         1

#define OP_ALL             -1

#define OBJPREFIX          "TP - "

bool TimerIsEnabled        = false;
int TimerInterval          = 250;

double LotSize             = 0;
double LotStep             = 0;
double MinLot              = 0;
double MaxLot              = 0;
double MinStop             = 0;

double LotSizeInp          = 0;
double StopLossInp         = 0;
double TakeProfitInp       = 0;
string SymbolInp           = "";

int SelectedTheme          = 0;
int CloseMode              = 0;
bool IsPainting            = false;
bool SoundIsEnabled        = false;
bool PlayTicks             = false;

int mouse_x                = 0;
int mouse_y                = 0;
int mouse_w                = 0;
datetime mouse_dt          = 0;
double mouse_pr            = 0;

int draw                   = 0;
int BrushClrIndex          = 0;
int BrushIndex             = 0;

int MaxSpeedBars           = 10;
double AvgPrice            = 0;
double UpTicks             = 0;
double DwnTicks            = 0;
int LastReason             = 0;

color COLOR_BG             = clrNONE;
color COLOR_FONT           = clrNONE;
color COLOR_FONT2          = clrNONE;
color COLOR_MOVE           = clrNONE;
color COLOR_GREEN          = clrNONE;
color COLOR_RED            = clrNONE;
color COLOR_HEDGE          = clrNONE;
color COLOR_BID_REC        = clrNONE;
color COLOR_ASK_REC        = clrNONE;
color COLOR_ARROW          = clrNONE;

color COLOR_SELL           = C'225,68,29';
color COLOR_BUY            = C'3,95,172';
color COLOR_CLOSE          = clrGoldenrod;

int ErrorInterval          = 250;
string ErrorSound          = "::Files\\TradePanel\\error.wav";

string MB_CAPTION=ExpertName+" v"+Version+" | "+Copyright;

string CloseArr[]={"CLOSE ALL","CLOSE LAST","CLOSE PROFIT","CLOSE LOSS","CLOSE PARTIAL"};

string BrushArr[]={"l","«","¨","t","­","Ë","°"};
color BrushClrArr[]={clrRed,clrGold,clrMagenta,clrBrown,clrDodgerBlue,clrGreen,clrOrange,clrWhite,clrBlack};

int x1=0, x2=CLIENT_BG_WIDTH;
int y1=0, y2=CLIENT_BG_HEIGHT;

int button_y=0;
int inputs_y=0;
int label_y=0;

int fr_x=0;

bool ShowOrdHistory=true;

/* Globle variable for News - START */
color   highc                = clrRed;
color mediumc                       = clrBlue;    
color lowc           = clrLime;    
int   Style          = 0;          
int   Upd            = 86400;     

bool  Vhigh          = false;
bool  Vmedium        = false;
bool  Vlow           = false;
int   MinBefore=0;
int   MinAfter=0;

int NomNews=0;
string NewsArr[4][1000];
int Now=0;
datetime LastUpd;
string str1;

/* ----------------------------ATR----------------------------------- */
color ADR_color_above_100=clrLime; 
color ADR_color_below_100=clrRed;
int TimeZoneOfData= 0;
int             NumOfDays_D             = 1;

bool ADR_Alert_Sound=false;
ENUM_LINE_STYLE ADR_linestyle=STYLE_DOT;
int ADR_Linethickness=2;
color ADR_Line_Colour = clrCoral;
ENUM_LINE_STYLE Daily_Open_linestyle=STYLE_DOT;
int Daily_Open_Linethickness=1;
color Daily_Open_Line_Colour = clrRed;

bool     Y_enabled = true;
bool     M_enabled = false;
int      NumOfDays_M             = 30;
bool     M6_enabled = true;
bool M6_Trading_weighting = false;
int Recent_Days_Weighting = 5;
bool Weighting_to_ADR_percentage = true;
int      NumOfDays_6M            = 180;
string   FontName              = "Calibri";
int      FontSize              = 12;
color    FontColor             = Yellow;
int      Window                = 0;
int      Corner                = 1;
int      HorizPos              = 50;
int      VertPos               = 20;
color    FontColor2            = Lime;
int      Font2Size             = 12;

int      DistanceL, DistanceHv, DistanceH, Distance6Mv, Distance6M, DistanceMv, DistanceM, DistanceYv, DistanceY, DistanceADRv, DistanceADR, Distance6Mv_new, Distance6M_new;

double pnt;
int    dig;
string objname = "DRPE";
class CSumDays
{
public:
   double            m_sum;
   int               m_days;
                     CSumDays(double sum, int days)
   {
      m_sum = sum;
      m_days = days;
   }
};
double TodayOpenBuffer[];

/* Globle variable for News - END */

/*********************************************************************/
/*                Global Variable Declearation - END                 */
/*********************************************************************/

int OnInit()
{
   TimeCheck_EA = TimeBotEnd_Function();
   /* Get UsePoint of Symbol */
   UsePoint = PipPoint(Symbol());
   SymbolSetting_Function();
   /* Get Slippage  */
   UseSlipage = GetSlippage(Symbol(), Slippage);
   /* Count Pair Trade at First Time after SW start */
   CoutPairTrade();
   /* Alert the EA is started */
   string StartAlert = StringConcatenate("EA Robot is Loading History");
   Alert(StartAlert);  
   
   for(int index = 0; index < PairTrade_Count; index ++ )
   {
      if(PairTrade[index] != "NoUse")
      {
          LoadHistory(PairTrade[index]);  
          //Calculate_UpperLower(PairTrade[index], periodA_begin, periodA_end, periodB_end, rectsB2_band, nextDayA, nextDayB);    
      }
      else
      {
         /* Do nothing */
      }
   }
   /* PANEL - START */
   if(!IsTesting())
      TimerIsEnabled=EventSetMillisecondTimer(TimerInterval);

   if(!IsTesting())
      if(!ChartGetInteger(0,CHART_EVENT_MOUSE_MOVE))
         ChartEventMouseMoveSet(true);

   if(!TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      MessageBox("Warning: No Internet connection found!\nPlease check your network connection.",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_NO_CONNECTION),MB_OK|MB_ICONWARNING);
     }

   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))//Terminal
     {
      MessageBox("Warning: Check if automated trading is allowed in the terminal settings!",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_NOT_ALLOWED),MB_OK|MB_ICONWARNING);
     }
   else
     {
      if(!MQLInfoInteger(MQL_TRADE_ALLOWED))//CheckBox
        {
         MessageBox("Warning: Automated trading is forbidden in the program settings for "+__FILE__,
                    MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_NOT_ALLOWED),MB_OK|MB_ICONWARNING);
        }
     }

   if(!AccountInfoInteger(ACCOUNT_TRADE_EXPERT))//Server
     {
      MessageBox("Warning: Automated trading is forbidden for the account "+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+" at the trade server side.",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_EXPERT_DISABLED_BY_SERVER),MB_OK|MB_ICONWARNING);
     }

   if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))//Investor
     {
      MessageBox("Warning: Trading is forbidden for the account "+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"."+
                 "\n\nPerhaps an investor password has been used to connect to the trading account."+
                 "\n\nCheck the terminal journal for the following entry:"+
                 "\n\'"+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"\': trading has been disabled - investor mode.",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED),MB_OK|MB_ICONWARNING);
     }

   if(!SymbolInfoInteger(_Symbol,SYMBOL_TRADE_MODE))//Symbol
     {
      MessageBox("Warning: Trading is disabled for the symbol "+_Symbol+" at the trade server side.",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED),MB_OK|MB_ICONWARNING);
     }


   if(MQLInfoInteger(MQL_TESTER))
      Print("Some functions are not available in the strategy tester.");


   if(!GlobalVariableCheck(ExpertName+" - Sound"))
      SoundIsEnabled=true;
   else
      SoundIsEnabled=GlobalVariableGet(ExpertName+" - Sound");


   SelectedTheme=(int)GlobalVariableGet(ExpertName+" - Theme");
   if(SelectedTheme==LIGHT)
      SetColors(LIGHT);
   else
      SetColors(DARK);


   LotSizeInp=GlobalVariableGet(ExpertName+" - LotSize");
   StopLossInp=GlobalVariableGet(ExpertName+" - StopLoss");
   TakeProfitInp=GlobalVariableGet(ExpertName+" - TakeProfit");


   if(!IsTesting())
      CloseMode=(int)GlobalVariableGet(ExpertName+" - Close");


   if(IsConnected())
      AvgPrice=(MarketInfo(_Symbol,MODE_ASK)+MarketInfo(_Symbol,MODE_BID))/2;


   GetSetCoordinates();


   ObjectsCreateAll();


   if(LastReason==REASON_CHARTCHANGE)
      _PlaySound("::Files\\TradePanel\\switch.wav");

   if(StringLen(NewsSymb)>1)str1=NewsSymb;
   else str1=Symbol();

   Vhigh=NewsHard;
   Vmedium=NewsMedium;
   Vlow=NewsLight;
   
   MinBefore=BeforeNewsStop;
   MinAfter=AfterNewsStop;
   DeleteObjects();

   InitEA_Function();  

   SetIndexStyle(0,DRAW_LINE,Daily_Open_linestyle,Daily_Open_Linethickness, Daily_Open_Line_Colour);
	 SetIndexBuffer(0,TodayOpenBuffer);
	 SetIndexLabel(0,"Daily Open");
	 SetIndexEmptyValue(0,0.0);
//+------------------------------------------------------------------+
   pnt = MarketInfo(Symbol(), MODE_POINT);
   dig = MarketInfo(Symbol(), MODE_DIGITS);
   if(dig == 3 || dig == 5)
   {
      pnt *= 10;
   }
   ObjectCreate(objname + "ADR", OBJ_LABEL, Window, 0, 0);
   ObjectCreate(objname + "%", OBJ_LABEL, Window, 0, 0);
   if (Y_enabled)
   {
      ObjectCreate(objname + "Y", OBJ_LABEL, Window, 0, 0);
      ObjectCreate(objname + "Y-value", OBJ_LABEL, Window, 0, 0);
   }
   if (M_enabled)
   {
      ObjectCreate(objname + "M", OBJ_LABEL, Window, 0, 0);
      ObjectCreate(objname + "M-value", OBJ_LABEL, Window, 0, 0);
   }
   if (M6_enabled)
   {
      ObjectCreate(objname + "6M", OBJ_LABEL, Window, 0, 0);
      ObjectCreate(objname + "6M-value", OBJ_LABEL, Window, 0, 0);
   }
   ObjectCreate(objname + "H", OBJ_LABEL, Window, 0, 0);
   ObjectCreate(objname + "H-value", OBJ_LABEL, Window, 0, 0);
   ObjectCreate(objname + "L", OBJ_LABEL, Window, 0, 0);
   ObjectCreate(objname + "L-value", OBJ_LABEL, Window, 0, 0);  
  
   StartAlert = StringConcatenate("EA Robot is Started");
   Alert(StartAlert);  


   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{

   EventKillTimer();
   TimerIsEnabled=false;


   if(!IsTesting())
      if(ChartGetInteger(0,CHART_EVENT_MOUSE_MOVE))
         ChartEventMouseMoveSet(false);


   if(reason!=REASON_INITFAILED)
     {

      GlobalVariableSet(ExpertName+" - X",x1);
      GlobalVariableSet(ExpertName+" - Y",y1);

      GlobalVariableSet(ExpertName+" - LotSize",LotSize);
      GlobalVariableSet(ExpertName+" - StopLoss",StopLoss_1);
      GlobalVariableSet(ExpertName+" - TakeProfit",TakeProfit_1);

      if(!IsTesting())
        {
         GlobalVariableSet(ExpertName+" - Theme",SelectedTheme);
         GlobalVariableSet(ExpertName+" - Sound",SoundIsEnabled);
         GlobalVariableSet(ExpertName+" - Close",CloseMode);
        }

      GlobalVariablesFlush();
     }


   if(reason==REASON_CHARTCHANGE)
     {
      UpTicks=0;
      DwnTicks=0;
     }


   if(reason<=REASON_REMOVE || reason==REASON_INITFAILED)
     {
      for(int i=0; i<ObjectsTotal(); i++)
        {

         string obj_name=ObjectName(i);

         if(StringSubstr(obj_name,0,StringLen(OBJPREFIX))==OBJPREFIX)
           {

            if(ObjectsDeleteAll(0,OBJPREFIX,-1,-1)>0)
               break;
           }
        }
     }


   LastReason=reason;
   
   ObjectsDeleteAll(0,OBJ_VLINE);

   DeleteObjects();

   SymbolSetting_Function();

   ObjectsDeleteAll();

   ObjectsDeleteAll(0, objname);

   CoutPairTrade();
}

/*********************************************************************/
/*               OnTimer Function - START                            */
/*********************************************************************/
void OnTimer()
{
   ObjectsCheckAll();
   GetSetInputs();
   SymbolInfo();
   AccAndTradeInfo();
}

/*********************************************************************/
/*                   OnTimer Function - START                        */
/*********************************************************************/

/*********************************************************************/
/*                   OnTick Function - START                          */
/*********************************************************************/
void OnTick(void)
{
  /* Local variable declearation - START */
  bool TimeFilterCheck = false;
  bool TimeFilterCheck_RSI_ICHI_ADX = false;
  bool TimeFilterCheck_StopOrder = false;
  bool TimeFilterCheck_GBPUSD = false;
  bool NewBar_Check_15M = IsNewBarPinbar_Check(true);
  bool NewBar_Check_1M = IsNewBar_Check(NewBar_Use);
  bool Profit_Check = false;
  double NewTrade_Check;
  TradeStrategy_en TradeStrategy;
  /* Local variable declearation - END */
  TimeCheck_EA = TimeBotEnd_Function();
  TimeFilterCheck = CheckRunTime_Function(FilterTime_Use);
  TimeFilterCheck_RSI_ICHI_ADX = CheckRunTime_Function_RSI_ICHI_ADX(FilterTime_Use);
  TimeFilterCheck_StopOrder = CheckRunTime_StopOrder_Function(FilterTime_Use);
  TimeFilterCheck_GBPUSD = CheckRunTime_Function_GBPUSD_Breakout(FilterTime_Use);
  int retry = 0;
  
  /* StartTOKYO_Section - START */
  if(TokyoSection_Display == true)
  {
    StartTOKYO_Section();
  }

  /* StartTOKYO_Section- END */
  Profit_Check = SumAllProfit_Check();

  /* Check news is opened - START */
  if(OpenNewOrderInNews_Allow)
  {
    NewTrade_Check = NewCheck_Function(OpenNewOrderInNews_Allow);
    if(AlertNew_Check)     
    {
        Alert("NewTrade_Check: ", NewTrade_Check);
    }
  }
  else
  {
    NewCheck_Function(OpenNewOrderInNews_Allow);
    NewTrade_Check == 0;
  }
  if (GBPUSD_DailyBreakout_Use == true && TimeFilterCheck_GBPUSD == true && Profit_Check == false) 
  {
    if(BuyStopCount(Symbol_GBPUSD, MagicNumber) == 0 && SellStopCount(Symbol_GBPUSD, MagicNumber) == 0)
    {
      GBPUSD_BreakoutFunction(Symbol_GBPUSD);
    }
  }
  /* Main Function - START */     
  /* Check news is opened - END */
  for(int index = 0; index < PairTrade_Count; index ++ )
  {
    Calculate_UpperLower(PairTrade[index], periodA_begin, periodA_end, periodB_end, rectsB2_band, nextDayA, nextDayB);
    if(PairTrade[index] != "NoUse")
    {
      TrailingStop_Function(TrailingStop_Setting, PairTrade[index]);
      TradeStrategy              = StrategyCheck_Function(PairTrade[index]);        
      if(NewTrade_Check > 0 )
      {
          CloseOrderInNews_Function();                  
      }         
      if(false == TimeFilterCheck && TimeFilterCheck_RSI_ICHI_ADX == true && TimeCheck_EA == true && Profit_Check == false)
      {  
        if(PINBAR_Strategy == TradeStrategy && MaxTradeEachSide(PairTrade[index]) >= 1)
        {
          Close_PinbarOrder(PairTrade[index]);
        }                              
        if(PINBAR_Strategy == TradeStrategy && TimeFilterCheck_StopOrder == true && NewBar_Check_15M == true)   
        {
          BuyStop_Pinbar(PairTrade[index]);
          SellStop_Pinbar(PairTrade[index]);
        }            
        if(MAGICBOX_Strategy == TradeStrategy)
        {
          // CloseOrderMagicBox_Function(PairTrade[index]);
        } 
        if(MAGICBOX_Strategy_Revert == TradeStrategy)
        {
          // CloseOrderMagicBoxRevert_Function(PairTrade[index]);
        }                         
        if(MaxTradeEachSide(PairTrade[index]) == 0 && NewBar_Check_1M == true && NewTrade_Check == 0 && ATR_Runing_Condition(PairTrade[index]))  
        {
          if(BuyMainFunction(PairTrade[index]) == true)
          {
            while(MaxTradeEachSide(PairTrade[index]) == 0 && retry < 10)
            {
              Buy_Function(BuyMainFunction(PairTrade[index]), PairTrade[index]);
              retry ++;
              Sleep(1);
            }           
          }
          retry = 0;
          if(SellMainFunction(PairTrade[index]) == true)
          {
            while(MaxTradeEachSide(PairTrade[index]) == 0 && retry < 10)
            {
              Sell_Function(SellMainFunction(PairTrade[index]), PairTrade[index]);
              retry ++;
              Sleep(1);
            }           
          }       
        }          
      }
      else if(true == TimeFilterCheck && TimeCheck_EA == true && Profit_Check == false)
      {  
        if(PINBAR_Strategy == TradeStrategy && MaxTradeEachSide(PairTrade[index]) >= 1)
        {
          Close_PinbarOrder(PairTrade[index]);
        }              
        if(PINBAR_Strategy == TradeStrategy && TimeFilterCheck_StopOrder == true && NewBar_Check_15M == true)   
        {
          BuyStop_Pinbar(PairTrade[index]);
          SellStop_Pinbar(PairTrade[index]);
        }              
        if(MAGICBOX_Strategy == TradeStrategy)
        {
          // CloseOrderMagicBox_Function(PairTrade[index]);
        }  
        if(MAGICBOX_Strategy_Revert == TradeStrategy)
        {
          // CloseOrderMagicBoxRevert_Function(PairTrade[index]);
        }         
        if(MaxTradeEachSide(PairTrade[index]) == 0 && NewBar_Check_1M == true && NewTrade_Check == 0 && TimeFilterCheck_StopOrder == true && ATR_Runing_Condition(PairTrade[index]))
        {
          if(BuyMainFunction(PairTrade[index]) == true)
          {
            while(MaxTradeEachSide(PairTrade[index]) == 0  && retry < 10)
            {
              Buy_Function(BuyMainFunction(PairTrade[index]), PairTrade[index]);
              retry ++;
              Sleep(1);
            }           
          }
          retry = 0;
          if(SellMainFunction(PairTrade[index]) == true)
          {
            while(MaxTradeEachSide(PairTrade[index]) == 0 && retry < 10)
            {
              Sell_Function(SellMainFunction(PairTrade[index]), PairTrade[index]);
              retry ++;
              Sleep(1);
            }           
          }  
        }
        if(TradeStrategy == TOKYO_Strategy && TimeFilterCheck_StopOrder == true)
        {
          if(PairTrade[index] != Symbol_GBPUSD)
          {
            if(MaxTradeEachSide(PairTrade[index]) == 0 && NewTrade_Check == 0  && BuyStopCount(PairTrade[index], MagicNumber) == 0)
            {                  
              Buy_StopFunction(PairTrade[index]);
            }
            if(MaxTradeEachSide(PairTrade[index]) == 0 && NewTrade_Check == 0  && SellStopCount(PairTrade[index], MagicNumber) == 0)
            {
              Sell_StopFunction(PairTrade[index]);     
            }  
          }
          else
          {
            if(MaxTradeEachSide(PairTrade[index]) == 0 && NewTrade_Check == 0  && MaxPendingOrderBuy_GBPUSD(Symbol_GBPUSD, MagicNumber) == 0)
            {                  
              Buy_StopFunction(PairTrade[index]);
            }
            if(MaxTradeEachSide(PairTrade[index]) == 0 && NewTrade_Check == 0  && MaxPendingOrderSell_GBPUSD(Symbol_GBPUSD, MagicNumber) == 0)
            {
              Sell_StopFunction(PairTrade[index]);     
            }             
          }
        } 
        if(TradeStrategy == LONDON_Strategy && TimeFilterCheck_StopOrder == true)
        {
          if(MaxTradeEachSide(PairTrade[index]) == 0  && NewTrade_Check == 0 && BuyStopCount(PairTrade[index], MagicNumber) == 0 && SellStopCount(PairTrade[index], MagicNumber) == 0)
          {
            LondonStopOrder_Function(PairTrade[index]);
          }   
        }    
      }
      else
      {
        AutoCloseAllOrder_Function(); 
      }      
    }
    if(TimeFilterCheck_StopOrder == true && Profit_Check == false)
    {
        /* Do nothing */
    }
    else
    {
      if(TimeFilterCheck_GBPUSD == false)
      {
        if(PairTrade[index] != "NoUse")
        {
            CloseAllPending_Order(PairTrade[index]);
        }
      }
    }
    while(IsTradeContextBusy()) Sleep(1);    
  } 

  ATR_Runing(Symbol());
  /* Main Function - END */ 
}

/*********************************************************************/
/*                   OnTick Function - END                           */
/*********************************************************************/

/*********************************************************************/
/*               Function is new bar check - START                   */
/*********************************************************************/
bool IsNewBar_Check(bool isNewBar_Use)
{
   if(true == isNewBar_Use)
   {
      /* Open time for the current bar */
      datetime          currentBarTime = iTime(Symbol(), PERIOD_M1, 0);
      /* Initialise on first use */
      static datetime   prevBarTime    =  currentBarTime;
      if  (prevBarTime < currentBarTime)        // New Bar opended
      {
         prevBarTime = currentBarTime;          // Update prev time before exit
         return(true);
      }
      else
      {
         return(false);
      }
   }
   else
   {
      return(true);
   }
}

bool IsNewBarPinbar_Check(bool isNewBar_Use)
{
   if(true == isNewBar_Use)
   {
      /* Open time for the current bar */
      datetime          currentBarTime = iTime(Symbol(), PERIOD_M15, 0);
      /* Initialise on first use */
      static datetime   prevBarTime_Pinbar    =  currentBarTime;
      if  (prevBarTime_Pinbar < currentBarTime)        // New Bar opended
      {
         prevBarTime_Pinbar = currentBarTime;          // Update prev time before exit
         return(true);
      }
      else
      {
         return(false);
      }
   }
   else
   {
      return(true);
   }
}

/*********************************************************************/
/*               Function is new bar check - END                     */
/*********************************************************************/


/*********************************************************************/
/*               Infor Status function - START                       */
/*********************************************************************/
void Infor_Status()
{
   Comment("" 
      + "\n" 
      + " IWantBot EA " 
      + "\n" 
      + "________________________________" 
      + "\n" 
      + "Account: " + (string) AccountCompany() 
      + "\n" 
      + "\n"
      + "Time: " + TimeToStr(TimeCurrent(), TIME_DATE|TIME_SECONDS) 
      + "\n" 
      + "________________________________" 
      + "\n" 
      + "Name: " + (string) AccountName() 
      + "\n"
      
      + "_______________________________" 
      + "\n" 
      + "Blance: " + DoubleToStr(AccountBalance(), 2) 
      + "\n" 
      + "\n"
      + "Equity: " + DoubleToStr(AccountEquity(), 2) 
      + "\n" 
   + "_______________________________");   
}


/*********************************************************************/
/*               Infor Status function - END                         */
/*********************************************************************/


/*********************************************************************/
/*                  Buy Open Function - START                        */
/*********************************************************************/

void Buy_Function(bool Buy_Condtion, string argSymbol)
{

   /* Local variable declearation - START */
   double OpenPrice;
   double BuyStopLoss;
   double BuyTakeProfit;
   double StopLoss;
   double TakeProfit;
   TradeStrategy_en TradeStrategy;
   /* Local variable declearation - END */
   double LotSize;
  
   /* Buy_Function - START */
   
   if(true == Buy_Condtion)
   {
      TradeStrategy = StrategyCheck_Function(argSymbol);
      /* Open Buy Order */
      UseSlipage = GetSlippage(argSymbol, Slippage);
      TakeProfit = TPValue_Get(argSymbol);
      StopLoss   = SLValue_Get(argSymbol);
      LotSize = CalcLotSize(RisKManagement_Use, Percent_Risk, StopLoss, FixLot);
      LotSize = VerifyLotSize(LotSize);
      BuyTicket = OpenBuyOrder(argSymbol, LotSize, UseSlipage, MagicNumber, Commnet);       
      if(BuyTicket > 0 && (StopLoss > 0 || TakeProfit > 0))
      {
         /* Calculate the Take Profit and Stop Loss */
         OrderSelect(BuyTicket, SELECT_BY_TICKET);   
         /* Read open Price */    
         OpenPrice = OrderOpenPrice();
         /* Calculate Stop Loss */
         BuyStopLoss = CalcBuyStopLoss(argSymbol, StopLoss, OpenPrice);  
         /* Check CalcBuyStopLoss is ok */
         if(BuyStopLoss > 0) 
         {
            BuyStopLoss = AdjustBelowStopLevel(argSymbol, BuyStopLoss, Slippage);
         }
         /* Read Take Profit */
         BuyTakeProfit = CalcBuyTakeProfit(argSymbol, TakeProfit , OpenPrice);           
         /* Check CalcBuyTakeProfit is ok */
         if(BuyTakeProfit > 0)
         {
            BuyTakeProfit = AdjustAboveStopLevel(argSymbol, BuyTakeProfit, Slippage);
         }
         
         /* Add Stop Loss and Take Profit */
         AddStopProfit(BuyTicket, BuyStopLoss, BuyTakeProfit); 
         
         AlreadyBuy_Set(argSymbol);

         ADXBelow25_Reset(argSymbol);
            
      }        
   } 
   else
   {
      /* Do nothing */
   }
   /* Buy_Function - END */ 
}

/*********************************************************************/
/*                  Buy Open Function - END                          */
/*********************************************************************/

/*********************************************************************/
/*                  Sell Open Function - START                       */
/*********************************************************************/

void Sell_Function(bool Sell_Condtion, string argSymbol)
{

   /* Local variable declearation - START */
   double OpenPrice;
   double SellStopLoss;
   double SellTakeProfit;
   double StopLoss;
   double TakeProfit;
   TradeStrategy_en TradeStrategy;
   /* Local variable declearation - END */
   
   /* Buy_Function - START */
   
   if(true == Sell_Condtion)
   {
      UseSlipage = GetSlippage(argSymbol, Slippage);
      TradeStrategy = StrategyCheck_Function(argSymbol);
      TakeProfit = TPValue_Get(argSymbol);
      StopLoss   = SLValue_Get(argSymbol);   
      LotSize = CalcLotSize(RisKManagement_Use, Percent_Risk, StopLoss, FixLot);
      LotSize = VerifyLotSize(LotSize);     
      /* Open Buy Order */
      SellTicket = OpenSellOrder(argSymbol, LotSize, UseSlipage, MagicNumber, Commnet);  
      
      if(SellTicket > 0 && (StopLoss > 0 || TakeProfit > 0))
      {
         /* Calculate the Take Profit and Stop Loss */
         OrderSelect(SellTicket, SELECT_BY_TICKET);   
         /* Read open Price */    
         OpenPrice = OrderOpenPrice();
         /* Calculate Stop Loss */  
         SellStopLoss = CalcSellStopLoss(argSymbol, StopLoss, OpenPrice);      
         /* Check CalcBuyStopLoss is ok */
         if(SellStopLoss > 0) 
         {
            SellStopLoss = AdjustAboveStopLevel(argSymbol, SellStopLoss, Slippage);
         }
         /* Read Take Profit */
         SellTakeProfit = CalcSellTakeProfit(argSymbol, TakeProfit , OpenPrice);
                 
         /* Check CalcBuyTakeProfit is ok */
         if(SellTakeProfit > 0)
         {
            SellTakeProfit = AdjustBelowStopLevel(argSymbol, SellTakeProfit, Slippage);
         }
         
         /* Add Stop Loss and Take Profit */
         AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);  
         
         AlreadySell_Set(argSymbol); 

         ADXBelow25_Reset(argSymbol);
      }        
   } 
   else
   {
      /* Do nothing */
   }
   /* Buy_Function - END */ 
}

/*********************************************************************/
/*                  Sell Open Function - END                         */
/*********************************************************************/

/*********************************************************************/
/*                  Buy Stop Function - START                        */
/*********************************************************************/

void Buy_StopFunction(string argSymbol)
{
   double PendingPrice;
   double BuyStop_TakeProfit;
   double BuyStop_StopLoss;
   double Price;
   double StopLevel = MarketInfo(argSymbol,MODE_STOPLEVEL) * PipPoint(argSymbol)/10;
   double TakeProfit = TPValue_Get(argSymbol);
   double StopLoss   = SLValue_Get(argSymbol);
   UseSlipage = GetSlippage(argSymbol, Slippage);

   PendingPrice = Get_dPriceHigh(argSymbol);
   if(AlreadyPendingBuy_Check(argSymbol) == false)
   {
      Price = MarketInfo(argSymbol, MODE_ASK);
      if((PendingPrice - Price) < StopLevel)
      {
         PendingPrice = PendingPrice + StopLevel;
         AlreadyPendingBuy_Set(argSymbol);        
      }
   }
   BuyStop_StopLoss     = CalcBuyStopLoss(argSymbol, StopLoss, PendingPrice);
   BuyStop_TakeProfit   =  CalcBuyTakeProfit(argSymbol, TakeProfit , PendingPrice);
   LotSize = CalcLotSize(RisKManagement_Use, Percent_Risk, StopLoss, FixLot);
   LotSize = VerifyLotSize(LotSize);   
   BuyTicket = OpenBuyStopOder(argSymbol, LotSize, PendingPrice, BuyStop_StopLoss, BuyStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);
}

void Sell_StopFunction(string argSymbol)
{
   double PendingPrice;
   double SellStop_TakeProfit;
   double SellStop_StopLoss;
   double Price;
   double StopLevel = MarketInfo(argSymbol,MODE_STOPLEVEL) * PipPoint(argSymbol)/10;
   double TakeProfit = TPValue_Get(argSymbol);
   double StopLoss   = SLValue_Get(argSymbol);
   UseSlipage = GetSlippage(argSymbol, Slippage);

   PendingPrice = Get_dPriceLow(argSymbol);
   if(AlreadyPendingSell_Check(argSymbol) == false)
   {
      Price = MarketInfo(argSymbol, MODE_BID);
      if((Price - PendingPrice) < StopLevel)
      {
         PendingPrice = PendingPrice - StopLevel;
         AlreadyPendingSell_Set(argSymbol);         
      } 
   }
   SellStop_StopLoss      = CalcSellStopLoss(argSymbol, StopLoss, PendingPrice);    
   SellStop_TakeProfit    =  CalcSellTakeProfit(argSymbol, TakeProfit , PendingPrice);
   LotSize = CalcLotSize(RisKManagement_Use, Percent_Risk, StopLoss, FixLot);
   LotSize = VerifyLotSize(LotSize);
   SellTicket = OpenSellStopOrder(argSymbol, LotSize, PendingPrice, SellStop_StopLoss, SellStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);
}

void CloseAllPending_Order(string argSymbol)
{
   CloseAllBuyStopOrders(argSymbol, MagicNumber);
   CloseAllSellStopOrders(argSymbol, MagicNumber);
   AlreadyPendingSell_ReSet(argSymbol);
   AlreadyPendingBuy_ReSet(argSymbol);
}

/*********************************************************************/
/*                  Buy Stop Function - END                          */
/*********************************************************************/

/*********************************************************************/
/*                  Bollinger Condition - START                      */
/*********************************************************************/

bool RSI_BuyCondition_PINBAR(string argSymbol)
{
   /* Local variable declearation - START */
   double iRSI_Value;
   bool returnCondition;
   /* Local variable declearation - END */
   iRSI_Value = iRSI(argSymbol,PERIOD_M15,9,PRICE_CLOSE,1);
   if(iRSI_Value < 30)
   {
      returnCondition = true;
   }
   else
   {
      returnCondition = false;
   }
   
   return returnCondition;
}

bool RSI_SellCondition_PINBAR(string argSymbol)
{
   /* Local variable declearation - START */
   double iRSI_Value;
   bool returnCondition;
   /* Local variable declearation - END */
   iRSI_Value = iRSI(argSymbol,PERIOD_M15,9,PRICE_CLOSE,1);
   if(iRSI_Value > 70)
   {
      returnCondition = true;
   }
   else
   {
      returnCondition = false;
   }
   
   return returnCondition;
}

bool SellBollingger_ConditionCheck(string argSymbol)
{
  double bandUpValue;
  bandUpValue = iBands(argSymbol,PERIOD_M15,20,2,0,PRICE_CLOSE,MODE_UPPER,1);

  double PriceHigh = iHigh(argSymbol, PERIOD_M15, 1);
  double PriceLow  = iLow(argSymbol, PERIOD_M15, 1);
  double PriceClose  = iClose(argSymbol, PERIOD_M15, 1);
  double PriceOpen  = iOpen(argSymbol, PERIOD_M15, 1);

  if((PriceClose > bandUpValue) || (bandUpValue < PriceHigh && bandUpValue > PriceOpen))
  {
    return true;
  }
  else
  {
    return false;
  }
}

bool BuyBollingger_ConditionCheck(string argSymbol)
{
  double bandDownValue;
  bandDownValue = iBands(argSymbol,PERIOD_M15,20,2,0,PRICE_CLOSE,MODE_LOWER,1);

  double PriceHigh = iHigh(argSymbol, PERIOD_M15, 1);
  double PriceLow  = iLow(argSymbol, PERIOD_M15, 1);
  double PriceClose  = iClose(argSymbol, PERIOD_M15, 1);
  double PriceOpen  = iOpen(argSymbol, PERIOD_M15, 1);

  if((PriceClose < bandDownValue) || (bandDownValue > PriceLow && bandDownValue < PriceOpen))
  {
    return true;
  }
  else
  {
    return false;
  }
}

/*********************************************************************/
/*                  Bollinger Condition - END                        */
/*********************************************************************/

/*********************************************************************/
/*                    Buy Process Function - START                   */
/*********************************************************************/

bool BuyMainFunction(string argSymbol)
{
  double iMA_Value;
  double Price;
  bool   returnValue = false;

  TradeStrategy_en TradeStrategy;
  TradeStrategy              = StrategyCheck_Function(argSymbol);

  switch(TradeStrategy)
  {
    case DontUse_AnyStrategy:
    {
      returnValue = false;
      break;
    }
    case TOKYO_Strategy:
    {
      break;
    }
    case LONDON_Strategy:
    {
      break;
    }
    case ADX_RSI_ICHI_Strategy:
    {
      if(ADX_Condition(argSymbol) && Buy_IchimokuCondition_Check(argSymbol))
       {
         returnValue = true;
       }
       else
       {
         returnValue = false;
       }
       break;
    }
    case ADX_RSI_ICHI_Strategy_Revert:
    {
       if(ADX_Condition(argSymbol) && Sell_IchimokuCondition_Check(argSymbol))
       {
         returnValue = true;
       }
       else
       {
         returnValue = false;
       }
       break;
    }
    case PINBAR_Strategy:
    {
       returnValue = false;
       break;
    }  
    case MAGICBOX_Strategy:
    {
      if(ADX_MagicBox_Condition(argSymbol) && MagicBox_Buy(argSymbol))
      {
        returnValue = true;
      }
      else
      {
        returnValue = false;
      }
      break;
    }
    case MAGICBOX_Strategy_Revert:
    {
      if(ADX_MagicBox_Condition(argSymbol) && MagicBox_Sell(argSymbol))
      {
        returnValue = true;
      }
      else
      {
        returnValue = false;
      }
      break;
    }
    case HMA_ADX_Strategy:
    {
      if(HMABuy_Condition(argSymbol) && ADX_Condition(argSymbol))
      {
        returnValue = true;
      }
      else
      {
        returnValue = false;
      }
      break;
    } 
    case PARA_ADX_Strategy:
    {
      if(BuyParabolic_Condition(argSymbol) && ADX_Condition(argSymbol))
      {
        returnValue = true;
      }
      else
      {
        returnValue = false;
      }
      break;
    }   
    default:
      break;
  }

  return returnValue;
  
}

/*********************************************************************/
/*                    Buy Process Function - END                     */
/*********************************************************************/

void BuyStop_Pinbar(string argSymbol)
{
  
  if(BuyBollingger_ConditionCheck(argSymbol) && RSI_BuyCondition_PINBAR(argSymbol) && Bullish_PinBarCandle_Check(argSymbol))
  {   
    PINBAR_BuyStop_Function(argSymbol);
  }  
  else
  {
    /* Do nothing */
  }
}

void SellStop_Pinbar(string argSymbol)
{
  if(SellBollingger_ConditionCheck(argSymbol) && RSI_SellCondition_PINBAR(argSymbol) && Bearish_PinBarCandle_Check(argSymbol))
  {
    PINBAR_SellStop_Function(argSymbol);
  }  
  else
  {
    /* Do nothing */
  }
}

/*********************************************************************/
/*                    CloseOrderFunctionV5 - START                   */
/*********************************************************************/

void CloseOrder_Function(string argSymbol)
{
    int index = 0;

    for(index=0; index<OrdersTotal(); index++)
    {
        OrderSelect(index, SELECT_BY_POS, MODE_TRADES);
        if(OrderType()<=OP_SELL &&  OrderSymbol()==argSymbol && OrderMagicNumber()==MagicNumber)     
        {
            if(OrderType()==OP_BUY)  
            {
                if(Sell_IchimokuCondition_Check(argSymbol))
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                }
            }
            else
            {
                if(Buy_IchimokuCondition_Check(argSymbol))
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                }
            }
        }        
    }
}

void CloseOrderBreakOut_Function(string argSymbol)
{
   int index = 0;
    
   double iMASignal;
   double Price_Value;

   iMASignal           = iMA(argSymbol, MA_TimeFrame, MA_Period, 0, MA_Method, PRICE_CLOSE, 1);
   Price_Value         = iClose(argSymbol, MA_TimeFrame, 1);
   if(MA_CloseUse == true)
   {
    for(index=0; index<OrdersTotal(); index++)
    {
        OrderSelect(index, SELECT_BY_POS, MODE_TRADES);
        if(OrderType()<=OP_SELL &&  OrderSymbol()==argSymbol && OrderMagicNumber()==MagicNumber)     
        {
            if(OrderType()==OP_BUY)  
            {
                if(Price_Value < iMASignal)
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                    AlreadyBuy_Reset(argSymbol);
                }
            }
            else
            {
                if(Price_Value > iMASignal)
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                    AlreadySell_Reset(argSymbol);
                }
            }
        }        
    }
   }
   else
   {
     /* Do nothing */
   }

}

/*********************************************************************/
/*                    CloseOrderFunctionV5 - END                     */
/*********************************************************************/

void PINBAR_BuyStop_Function(string argSymbol)
{
    double PendingPrice;
    double BuyStop_TakeProfit;
    double BuyStop_StopLoss;
    PendingPrice = Get_PinbarBuy(argSymbol);

    double StopLevel = MarketInfo(argSymbol,MODE_STOPLEVEL);
    double TakeProfit = TPValue_Get(argSymbol);
    double StopLoss   = SLValue_Get(argSymbol);
    UseSlipage = GetSlippage(argSymbol, Slippage);

    BuyStop_StopLoss     = CalcBuyStopLoss(argSymbol, StopLoss, PendingPrice);
    BuyStop_TakeProfit   =  CalcBuyTakeProfit(argSymbol, TakeProfit , PendingPrice);
    LotSize = CalcLotSize(RisKManagement_Use, Percent_Risk, StopLoss, FixLot);
    LotSize = VerifyLotSize(LotSize); 

    BuyTicket = OpenBuyStopOder(argSymbol, LotSize, PendingPrice, BuyStop_StopLoss, BuyStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);    
}

void PINBAR_SellStop_Function(string argSymbol)
{
    double PendingPrice;
    double SellStop_TakeProfit;
    double SellStop_StopLoss;
    PendingPrice = Get_PinbarSell(argSymbol);

    double StopLevel = MarketInfo(argSymbol,MODE_STOPLEVEL);
    double TakeProfit = TPValue_Get(argSymbol);
    double StopLoss   = SLValue_Get(argSymbol);
    UseSlipage = GetSlippage(argSymbol, Slippage);

    SellStop_StopLoss      = CalcSellStopLoss(argSymbol, StopLoss, PendingPrice);    
    SellStop_TakeProfit    =  CalcSellTakeProfit(argSymbol, TakeProfit , PendingPrice);
    LotSize = CalcLotSize(RisKManagement_Use, Percent_Risk, StopLoss, LotSize);
    LotSize = VerifyLotSize(LotSize); 

    SellTicket = OpenSellStopOrder(argSymbol, LotSize, PendingPrice, SellStop_StopLoss, SellStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);    
}

/*********************************************************************/
/*                    Sell Process Function - START                  */
/*********************************************************************/

bool SellMainFunction(string argSymbol)
{
  double iMA_Value;
  double Price;
  bool   returnValue = false;

  TradeStrategy_en TradeStrategy;
  TradeStrategy              = StrategyCheck_Function(argSymbol);

  switch(TradeStrategy)
  {
    case DontUse_AnyStrategy:
    {
      returnValue = false;
      break;
    }
    case TOKYO_Strategy:
    {
      break;
    }
    case LONDON_Strategy:
    {
      break;
    }
    case ADX_RSI_ICHI_Strategy:
    {
       if(ADX_Condition(argSymbol) && Sell_IchimokuCondition_Check(argSymbol))
       {
         returnValue = true;
       }
       else
       {
         returnValue = false;
       }
       break;
    }
    case ADX_RSI_ICHI_Strategy_Revert:
    {
       if(ADX_Condition(argSymbol) && Buy_IchimokuCondition_Check(argSymbol))
       {
         returnValue = true;
       }
       else
       {
         returnValue = false;
       }
       break;       
    }
    case PINBAR_Strategy:
    {
       returnValue = false;
       break;
    } 
    case MAGICBOX_Strategy:
    {
      if(ADX_MagicBox_Condition(argSymbol) && MagicBox_Sell(argSymbol))
      {
        returnValue = true;
      }
      else
      {
        returnValue = false;
      }
      break;
    }
    case MAGICBOX_Strategy_Revert:
    {
      if(ADX_MagicBox_Condition(argSymbol) && MagicBox_Buy(argSymbol))
      {
        returnValue = true;
      }
      else
      {
        returnValue = false;
      }
      break;
    }
    case HMA_ADX_Strategy:
    {
      if(HMASell_Condition(argSymbol) && ADX_Condition(argSymbol))
      {
        returnValue = true;
      }
      else
      {
        returnValue = false;
      }
      break;
    }
    case PARA_ADX_Strategy:
    {
      if(SellParabolic_Condition(argSymbol) && ADX_Condition(argSymbol))
      {
        returnValue = true;
      }
      else
      {
        returnValue = false;
      }
      break;
    }
    default:
      break;
  }

  return returnValue;
}

/*********************************************************************/
/*                    Sell Process Function - END                    */
/*********************************************************************/

void Close_PinbarOrder(string argSymbol)
{
  if(MaxTradeEachSide(argSymbol) >= 1)
  {
    CloseAllSellStopOrders(argSymbol, MagicNumber);
    CloseAllBuyStopOrders(argSymbol, MagicNumber);
  }
}

/*********************************************************************/
/*                  Ichimoku Condition - START                       */
/*********************************************************************/

bool Buy_IchimokuCondition_Check(string argSymbol)
{
   /* Local variable declearation - START */
   double iUpKumo_Cloud;
   double iDownKumo_Cloud;
   double Price;
   bool returnCondition;
   /* Local variable declearation - END */
   
   /* Read Value of IchiMoku */
   iUpKumo_Cloud        = iIchimoku(argSymbol, ICHI_TIMEFRAME, 9, 26, 52, MODE_SENKOUSPANA, 1);
   iDownKumo_Cloud      = iIchimoku(argSymbol, ICHI_TIMEFRAME, 9, 26, 52, MODE_SENKOUSPANB, 1);
   Price                = iClose(argSymbol, ICHI_TIMEFRAME, 1);

   if(Price > iUpKumo_Cloud && Price > iDownKumo_Cloud)
   {
      returnCondition = true;
   }
   else
   {
      returnCondition = false;
   }
   
   return returnCondition;
}

/*********************************************************************/
/*                  Ichimoku Condition - END                          */
/*********************************************************************/

/*********************************************************************/
/*                  Ichimoku Condition - START                       */
/*********************************************************************/

bool Sell_IchimokuCondition_Check(string argSymbol)
{
   /* Local variable declearation - START */
   double iUpKumo_Cloud;
   double iDownKumo_Cloud;
   double Price;
   bool returnCondition;
   /* Local variable declearation - END */
   
   /* Read Value of IchiMoku */
   iUpKumo_Cloud        = iIchimoku(argSymbol, ICHI_TIMEFRAME, 9, 26, 52, MODE_SENKOUSPANA, 1);
   iDownKumo_Cloud      = iIchimoku(argSymbol, ICHI_TIMEFRAME, 9, 26, 52, MODE_SENKOUSPANB, 1);
   Price                = iClose(argSymbol, ICHI_TIMEFRAME, 1);

   if(Price < iUpKumo_Cloud && Price < iDownKumo_Cloud)
   {
      returnCondition = true;
   }
   else
   {
      returnCondition = false;
   } 

   return returnCondition;
}

/*********************************************************************/
/*                  Ichimoku Condition - END                          */
/*********************************************************************/

/*********************************************************************/
/*                  London Main Function - START                     */
/*********************************************************************/

void LondonStopOrder_Function(string argSymbol)
{
  int calcDigits = MarketInfo(argSymbol, MODE_DIGITS);
  double MiddleTokyo;

  MiddleTokyo = Get_dPriceMiddle(argSymbol);
  MiddleTokyo = NormalizeDouble(MiddleTokyo, calcDigits);
  UseSlipage = GetSlippage(argSymbol, Slippage);

  double SellStop_TakeProfit;
  double SellStop_StopLoss;
  double BuyStop_TakeProfit;
  double BuyStop_StopLoss;

  double TakeProfit = TPValue_Get(argSymbol);
  double StopLoss   = SLValue_Get(argSymbol);

  SellStop_StopLoss = CalcSellStopLoss(argSymbol, StopLoss, MiddleTokyo);  
  SellStop_TakeProfit   =  CalcSellTakeProfit(argSymbol, TakeProfit , MiddleTokyo);
  BuyStop_TakeProfit   =  CalcBuyTakeProfit(argSymbol, TakeProfit , MiddleTokyo);
  BuyStop_StopLoss = CalcBuyStopLoss(argSymbol, StopLoss, MiddleTokyo); 

  if(iClose(argSymbol, 0, 1) > Get_dPriceHigh(argSymbol))
  {
     SellTicket = OpenSellStopOrder(argSymbol, FixLot, MiddleTokyo, SellStop_StopLoss, SellStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);
  }
  if (iClose(argSymbol, 0, 1) < Get_dPriceLow(argSymbol))
  {  
    BuyTicket = OpenBuyStopOder(argSymbol, FixLot, MiddleTokyo, BuyStop_StopLoss, BuyStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);
  }
}

/*********************************************************************/
/*                  London Main Function - END                       */
/*********************************************************************/


/*********************************************************************/
/*                  ADX Indicator Condition - START                   */
/*********************************************************************/

bool ADX_Condition(string argSymbol)
{
   /* Local variable declearation - START */
    double iADX_Value_Now = 0.0;
    double iADX_Value_Before = 0.0;
    bool returnCondition = false;
   /* Local variable declearation - END */
   iADX_Value_Now     = iADX(argSymbol, ADX_TIMEFRAME,14,PRICE_CLOSE, MODE_MAIN,1);
   iADX_Value_Before  = iADX(argSymbol, ADX_TIMEFRAME,14,PRICE_CLOSE, MODE_MAIN,2);

   if(iADX_Value_Now >= 25.5 && iADX_Value_Before < 25)
   {
      returnCondition = true;                                                               
   }
   else
   {
      returnCondition = false;
   }
     
   return returnCondition;
}

/*********************************************************************/
/*                  ADX Indicator Condition - END                    */
/*********************************************************************/

/*********************************************************************/
/*                      RSI Condition - START                        */
/*********************************************************************/

bool RSI_BuyCondition(string argSymbol)
{
   /* Local variable declearation - START */
   double iRSI_Value;
   bool returnCondition;
   /* Local variable declearation - END */
   iRSI_Value = iRSI(argSymbol,PERIOD_M15,7,PRICE_CLOSE,1);
   if(iRSI_Value > 70)
   {
      returnCondition = true;
   }
   else
   {
      returnCondition = false;
   }
   
   return returnCondition;
}

/*********************************************************************/
/*                        RSI Condition - END                        */
/*********************************************************************/

/*********************************************************************/
/*                      RSI Condition - START                        */
/*********************************************************************/

bool RSI_SellCondition(string argSymbol)
{
   /* Local variable declearation - START */
   double iRSI_Value;
   bool returnCondition;
   /* Local variable declearation - END */
   iRSI_Value = iRSI(argSymbol,PERIOD_M15,7,PRICE_CLOSE,1);
   if(iRSI_Value < 30)
   {
      returnCondition = true;
   }
   else
   {
      returnCondition = false;
   }
   
   return returnCondition;
}

/*********************************************************************/
/*                        RSI Condition - END                        */
/*********************************************************************/

/*********************************************************************/
/*                   TOKYO SECTION BREAK OUT - START                 */
/*********************************************************************/

void DeleteObjects() 
{
  datetime dtTradeDate=TimeCurrent();
  for (int i=0; i<NumberOfDays; i++) 
  {
    ObjectDelete(UniqueID + " BoxHL  " + TimeToStr(dtTradeDate,TIME_DATE));
    ObjectDelete(UniqueID + " BoxBO_High  " + TimeToStr(dtTradeDate,TIME_DATE));
    ObjectDelete(UniqueID + " BoxBO_Low  " + TimeToStr(dtTradeDate,TIME_DATE));
    ObjectDelete(UniqueID + " BoxPeriodA  " + TimeToStr(dtTradeDate,TIME_DATE));
    ObjectDelete(UniqueID + " BoxPeriodB  " + TimeToStr(dtTradeDate,TIME_DATE));

    dtTradeDate=decrementTradeDate(dtTradeDate);
    while (TimeDayOfWeek(dtTradeDate) > 5 || TimeDayOfWeek(dtTradeDate) < 1 ) dtTradeDate = decrementTradeDate(dtTradeDate);     // Removed Sundays from plots
  }     
}

void StartTOKYO_Section()
{
  datetime dtTradeDate=TimeCurrent();

  for (int i=0; i<NumberOfDays; i++) 
  {
    DrawObjects(dtTradeDate, UniqueID + " BoxHL  " + TimeToStr(dtTradeDate,TIME_DATE), periodA_begin, periodA_end, periodB_end, rectAB_color, 0, 1, rectAB_background,nextDayA,nextDayB);
    DrawObjects(dtTradeDate, UniqueID + " BoxBO_High  " + TimeToStr(dtTradeDate,TIME_DATE), periodA_begin, periodA_end, periodB_end, rectsB2_color, rectsB2_band,2,rectsB2_background,nextDayA,nextDayB);
    DrawObjects(dtTradeDate, UniqueID + " BoxBO_Low  " + TimeToStr(dtTradeDate,TIME_DATE), periodA_begin, periodA_end, periodB_end, rectsB2_color, rectsB2_band,3,rectsB2_background,nextDayA,nextDayB);
    DrawObjects(dtTradeDate, UniqueID + " BoxPeriodA  " + TimeToStr(dtTradeDate,TIME_DATE), periodA_begin, periodA_end, periodA_end, rectA_color, 0,4, rectA_background,nextDayA,nextDayB);
    DrawObjects(dtTradeDate, UniqueID + " BoxPeriodB  " + TimeToStr(dtTradeDate,TIME_DATE), periodA_begin, periodA_end, periodB_end, rectB1_color, rectB1_band,5, rectB1_background,nextDayA,nextDayB);


    dtTradeDate=decrementTradeDate(dtTradeDate);
    while (TimeDayOfWeek(dtTradeDate) > 5 || TimeDayOfWeek(dtTradeDate) < 1 ) dtTradeDate = decrementTradeDate(dtTradeDate);     // Removed Sundays from plots
  }

}

/*********************************************************************/
/*                   TOKYO SECTION Upper/Lower - START               */
/*********************************************************************/

/*********************************************************************/
/*                    Only DoJi Function - START                     */
/*********************************************************************/

bool Bearish_PinBarCandle_Check(string argSymbol)
{
  bool PinBar = false;

  double body = MathAbs((iOpen(argSymbol, PERIOD_M15, 1) -  iClose(argSymbol, PERIOD_M15, 1)));
  double candle = iHigh(argSymbol, PERIOD_M15, 1) - iLow(argSymbol, PERIOD_M15, 1);

  double tie_up;
  double tie_down;

  double devide_value;
  UsePoint = PipPoint(argSymbol);

  if(iOpen(argSymbol, PERIOD_M15, 1) > iClose(argSymbol, PERIOD_M15, 1))
  {
    /* Bearish candle */
    tie_up = MathAbs(iHigh(argSymbol, PERIOD_M15, 1) - iOpen(argSymbol, PERIOD_M15, 1));
    tie_down = MathAbs(iClose(argSymbol, PERIOD_M15, 1) - iLow(argSymbol, PERIOD_M15, 1));
    if(body != 0)
    {
      devide_value = tie_up / body;
    }
    if(devide_value >= 2 && tie_down < tie_up)
    {
      PinBar = true;
      Set_PinbarSell((iLow(argSymbol, PERIOD_M15, 1) - Distance*UsePoint), argSymbol);
    }
  }
  else if(iOpen(argSymbol, PERIOD_M15, 1) < iClose(argSymbol, PERIOD_M15, 1))
  {
    /* Bearish candle */
    tie_up = MathAbs(iHigh(argSymbol, PERIOD_M15, 1) - iClose(argSymbol, PERIOD_M15, 1));
    tie_down = MathAbs(iOpen(argSymbol, PERIOD_M15, 1) - iLow(argSymbol, PERIOD_M15, 1));
    if(body != 0)
    {
      devide_value = tie_up / body;
    }
    if(devide_value >= 2 && tie_down < tie_up)
    {
      PinBar = true;
      Set_PinbarSell((iLow(argSymbol, PERIOD_M15, 1) - Distance*UsePoint), argSymbol);
    }
  }
  else
  {
    PinBar = false;
  }
  
  return PinBar;

}

bool Bullish_PinBarCandle_Check(string argSymbol)
{
  bool PinBar = false;

  double body = MathAbs((iOpen(argSymbol, PERIOD_M15, 1) -  iClose(argSymbol, PERIOD_M15, 1)));
  double candle = iHigh(argSymbol, PERIOD_M15, 1) - iLow(argSymbol, PERIOD_M15, 1);

  double tie_down;
  double tie_up;

  double devide_value;
  UsePoint = PipPoint(argSymbol);

  if(iOpen(argSymbol, PERIOD_M15, 1) < iClose(argSymbol, PERIOD_M15, 1))
  {
    /* Bullish candle */
    tie_down = MathAbs(iOpen(argSymbol, PERIOD_M15, 1) - iLow(argSymbol, PERIOD_M15, 1));
    tie_up = MathAbs(iHigh(argSymbol, PERIOD_M15, 1) - iClose(argSymbol, PERIOD_M15, 1));
    if(body != 0)
    {
      devide_value = tie_down / body;
    }
    if(devide_value >= 2 && tie_down > tie_up)
    {
      PinBar = true;
      Set_PinbarBuy((iHigh(argSymbol, PERIOD_M15, 1) + Distance*UsePoint), argSymbol);
    }
  }
  else if(iOpen(argSymbol, PERIOD_M15, 1) > iClose(argSymbol, PERIOD_M15, 1))
  {
    /* Bullish candle */
    tie_down = MathAbs(iClose(argSymbol, PERIOD_M15, 1) - iLow(argSymbol, PERIOD_M15, 1));
    tie_up = MathAbs(iHigh(argSymbol, PERIOD_M15, 1) - iOpen(argSymbol, PERIOD_M15, 1));
    if(body != 0)
    {
      devide_value = tie_down / body;
    }
    if(devide_value >= 2 && tie_down > tie_up)
    {
      PinBar = true;
      Set_PinbarBuy((iHigh(argSymbol, PERIOD_M15, 1) + Distance*UsePoint), argSymbol);
    }
  }
  else
  {
    PinBar = false;
  }
  
  return PinBar;

}


bool MagicBox_Sell(string argSymbol)
{
   double Regression_value;
   Regression_value = iCustom(argSymbol, MAGICBOX_TIMEFRAME, "MagicBox", "================ Alerts ==================", false, 1, 1);
   if(EMPTY_VALUE != Regression_value)
   {
      return true;
   }
   else
   {
      return false;
   }
}

bool MagicBox_Buy(string argSymbol)
{
   double Regression_value;
   Regression_value = iCustom(argSymbol, MAGICBOX_TIMEFRAME, "MagicBox", "================ Alerts ==================", false, 0, 1);
   if(EMPTY_VALUE != Regression_value)
   {
      return true;
   }
   else
   {
      return false;
   }
}

bool ADX_MagicBox_Condition(string argSymbol)
{
    /* Local variable declearation - START */
    double iADX_Value_Now;
    bool returnCondition = false;
    /* Local variable declearation - END */
    iADX_Value_Now     = iADX(argSymbol, MAGICBOX_TIMEFRAME,14,PRICE_CLOSE, MODE_MAIN,1);

    if(iADX_Value_Now > 25)
    {
        returnCondition = true;                                                               
    }
    else
    {
        returnCondition = false;
    }
     
    return returnCondition;
}

/*********************************************************************/
/*                    Only DoJi Function - END                       */
/*********************************************************************/

bool TimeBotEnd_Function()
{
   int day_end             =TimeDay(D'2022.03.30');
   int month_end           =TimeMonth(D'2022.03.30');
   int year_end            =TimeYear(D'2022.03.30');

   int day_start           =TimeDay(D'2021.09.17');
   int month_start         =TimeMonth(D'2021.09.17');
   int year_start          =TimeYear(D'2021.09.17');

   int day_current         =TimeDay(TimeCurrent());
   int month_current       =TimeMonth(TimeCurrent());
   int year_current        =TimeYear(TimeCurrent());

   if(year_current <= year_end && month_current <= month_end && day_current <= day_end)
   {
      return true;
   }
   else
   {
      Alert("ERROR - CONTACT: sang.tran2197@gmail.com");
      //Alert("Lien He Sazgn Tran: sang.tran2197@gmail.com");
      return false;
   }
}

void Calculate_UpperLower(string argSymbol, string sTimeBegin, string sTimeEnd, string sTimeObjEnd, int iOffSet, int nextDayA, int nextDayB)
{
  datetime dtTimeBegin, dtTimeEnd, dtTimeObjEnd;
  double   dPriceHigh,  dPriceLow, dPriceMiddle;
  int      iBarBegin,   iBarEnd;

  UsePoint = PipPoint(argSymbol);

  datetime dtFirstTime;
  datetime dtLastTime; 

  int intShiftHighest;
  int intShiftLowest;

  datetime dtTradeDate=TimeCurrent();
  
  dtTimeBegin = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeBegin);
  dtTimeEnd = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeEnd);
  dtTimeObjEnd = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeObjEnd); 

  if(nextDayA == 1) dtTimeEnd = dtTimeEnd + 86400;
  if(nextDayB == 1) dtTimeObjEnd = dtTimeObjEnd + 86400;
  if(nextDayA == 1 && TimeDayOfWeek(dtTradeDate) == 5) dtTimeEnd = dtTimeEnd + (2 * 86400);
  if(nextDayB == 1 && TimeDayOfWeek(dtTradeDate) == 5) dtTimeObjEnd = dtTimeObjEnd + (2 * 86400);


  dtFirstTime = fmin( dtTimeBegin, dtTimeEnd );
  dtLastTime  = fmax( dtTimeBegin, dtTimeEnd ) - 1;

  iBarBegin = iBarShift(argSymbol, PERIOD_M15, dtFirstTime);                                   
  iBarEnd   = iBarShift(argSymbol, PERIOD_M15, dtLastTime);   
  
  intShiftHighest = iHighest(argSymbol, PERIOD_M15, MODE_HIGH, (iBarBegin)-iBarEnd, iBarEnd);
  intShiftLowest  = iLowest (argSymbol, PERIOD_M15, MODE_LOW , (iBarBegin)-iBarEnd, iBarEnd);

  dPriceHigh   = iHigh(argSymbol, PERIOD_M15, intShiftHighest);
  dPriceLow    = iLow(argSymbol, PERIOD_M15, intShiftLowest);  
  
  dPriceMiddle = ((dPriceHigh - dPriceLow) / 2);
  dPriceMiddle = dPriceHigh - dPriceMiddle;

  dPriceHigh   = dPriceHigh + Distance*UsePoint;
  dPriceLow    = dPriceLow  - Distance*UsePoint;

  Set_dPriceMiddle(dPriceMiddle, argSymbol);
  Set_dPriceHigh(dPriceHigh, argSymbol);
  Set_dPriceLow(dPriceLow, argSymbol);

}

/*********************************************************************/
/*                   TOKYO SECTION Upper/Lower - END                 */
/*********************************************************************/

void DrawObjects(datetime dtTradeDate, string sObjName, string sTimeBegin, string sTimeEnd, string sTimeObjEnd, color cObjColor, int iOffSet, int iForm, bool background, int nextDayA, int nextDayB) 
{
  datetime dtTimeBegin, dtTimeEnd, dtTimeObjEnd;
  double   dPriceHigh,  dPriceLow;
  int      iBarBegin,   iBarEnd;

  dtTimeBegin = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeBegin);
  dtTimeEnd = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeEnd);
  dtTimeObjEnd = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeObjEnd);
  
  if(nextDayA == 1) dtTimeEnd = dtTimeEnd + 86400;
  if(nextDayB == 1) dtTimeObjEnd = dtTimeObjEnd + 86400;
  if(nextDayA == 1 && TimeDayOfWeek(dtTradeDate) == 5) dtTimeEnd = dtTimeEnd + (2 * 86400);
  if(nextDayB == 1 && TimeDayOfWeek(dtTradeDate) == 5) dtTimeObjEnd = dtTimeObjEnd + (2 * 86400);
      
  iBarBegin = iBarShift(NULL, 0, dtTimeBegin);                                 
  iBarEnd = iBarShift(NULL, 0, dtTimeEnd);                                     
  dPriceHigh = High[Highest(NULL, 0, MODE_HIGH, (iBarBegin)-iBarEnd, iBarEnd)];
  dPriceLow = Low [Lowest (NULL, 0, MODE_LOW , (iBarBegin)-iBarEnd, iBarEnd)];

 
  ObjectCreate(sObjName, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
  
//---- High-Low Rectangle - Period A and B combined
   if(iForm==1){  
      ObjectSet(sObjName, OBJPROP_TIME1 , dtTimeBegin);
      ObjectSet(sObjName, OBJPROP_TIME2 , dtTimeObjEnd);
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceHigh);  
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceLow);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_BACK, background);
   }
   
//---- Upper Rectangle  - Period B
  if(iForm==2){
      ObjectSet(sObjName, OBJPROP_TIME1 , dtTimeEnd);
      ObjectSet(sObjName, OBJPROP_TIME2 , dtTimeObjEnd);
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceHigh);
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceHigh + iOffSet*UsePoint);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_BACK, background);
   }
 
 //---- Lower Rectangle - Period B
  if(iForm==3){
      ObjectSet(sObjName, OBJPROP_TIME1 , dtTimeEnd);
      ObjectSet(sObjName, OBJPROP_TIME2 , dtTimeObjEnd);
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceLow - iOffSet*UsePoint);
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceLow);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_BACK, background);
   }

//---- Period A Rectangle
  if(iForm==4){
      ObjectSet(sObjName, OBJPROP_TIME1 , dtTimeBegin);
      ObjectSet(sObjName, OBJPROP_TIME2 , dtTimeEnd);
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceHigh);
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceLow);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_WIDTH, 2);
      ObjectSet(sObjName, OBJPROP_BACK, background);
      string sObjDesc = StringConcatenate("High: ",dPriceHigh,"  Low: ", dPriceLow);  
      ObjectSetText(sObjName, sObjDesc,10,"Times New Roman",Black);
   }   
//---- Period B Rectangle
  if(iForm==5){
      ObjectSet(sObjName, OBJPROP_TIME1 , dtTimeEnd);
      ObjectSet(sObjName, OBJPROP_TIME2 , dtTimeObjEnd);
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceHigh + iOffSet*UsePoint);
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceLow - iOffSet*UsePoint);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_WIDTH, 2);
      ObjectSet(sObjName, OBJPROP_BACK, background);
   }      
}

datetime decrementTradeDate (datetime dtTimeDate) 
{
   int iTimeYear=TimeYear(dtTimeDate);
   int iTimeMonth=TimeMonth(dtTimeDate);
   int iTimeDay=TimeDay(dtTimeDate);
   int iTimeHour=TimeHour(dtTimeDate);
   int iTimeMinute=TimeMinute(dtTimeDate);

   iTimeDay--;
   if (iTimeDay==0) {
     iTimeMonth--;
     if (iTimeMonth==0) {
       iTimeYear--;
       iTimeMonth=12;
     }
    
     // Thirty days hath September...  
     if (iTimeMonth==4 || iTimeMonth==6 || iTimeMonth==9 || iTimeMonth==11) iTimeDay=30;
     // ...all the rest have thirty-one...
     if (iTimeMonth==1 || iTimeMonth==3 || iTimeMonth==5 || iTimeMonth==7 || iTimeMonth==8 || iTimeMonth==10 || iTimeMonth==12) iTimeDay=31;
     // ...except...
     if (iTimeMonth==2) if (MathMod(iTimeYear, 4)==0) iTimeDay=29; else iTimeDay=28;
   }
  return(StrToTime(iTimeYear + "." + iTimeMonth + "." + iTimeDay + " " + iTimeHour + ":" + iTimeMinute));
}

/*********************************************************************/
/*                   TOKYO SECTION BREAK OUT - END                   */
/*********************************************************************/

/*********************************************************************/
/*                    Auto Close Order Function - START             */
/*********************************************************************/

void AutoCloseAllOrder_Function()
{
    int index = 0;
    for(index=0; index<OrdersTotal(); index++)
    {
        OrderSelect(index, SELECT_BY_POS, MODE_TRADES);
        OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
    }

    /* Reset status */
    Already_Buy_EURCAD = false;
    Already_Buy_CADCHF = false;
    Already_Buy_AUDUSD = false;
    Already_Buy_GBPCHF = false;
    Already_Buy_NZDCHF = false;
    Already_Buy_USDCAD = false;
    Already_Buy_AUDCHF = false;
    Already_Buy_NZDJPY = false;
    Already_Buy_CADJPY = false;
    Already_Buy_GBPUSD = false;
    Already_Buy_GBPCAD = false;
    Already_Buy_AUDJPY = false;
    Already_Buy_EURAUD = false;
    Already_Buy_GBPJPY = false;
    Already_Buy_NZDCAD = false;
    Already_Buy_EURJPY = false;
    Already_Buy_USDCHF = false;
    Already_Buy_EURCHF = false;
    Already_Buy_EURGBP = false;
    Already_Buy_NZDUSD = false;
    Already_Buy_CHFJPY = false;
    Already_Buy_AUDCAD = false;
    Already_Buy_AUDNZD = false;
    Already_Buy_USDJPY = false;
    Already_Buy_GBPAUD = false;
    Already_Buy_EURUSD = false;

    Already_Sell_EURCAD = false;
    Already_Sell_CADCHF = false;
    Already_Sell_AUDUSD = false;
    Already_Sell_GBPCHF = false;
    Already_Sell_NZDCHF = false;
    Already_Sell_USDCAD = false;
    Already_Sell_AUDCHF = false;
    Already_Sell_NZDJPY = false;
    Already_Sell_CADJPY = false;
    Already_Sell_GBPUSD = false;
    Already_Sell_GBPCAD = false;
    Already_Sell_AUDJPY = false;
    Already_Sell_EURAUD = false;
    Already_Sell_GBPJPY = false;
    Already_Sell_NZDCAD = false;
    Already_Sell_EURJPY = false;
    Already_Sell_USDCHF = false;
    Already_Sell_EURCHF = false;
    Already_Sell_EURGBP = false;
    Already_Sell_NZDUSD = false;
    Already_Sell_CHFJPY = false;
    Already_Sell_AUDCAD = false;
    Already_Sell_AUDNZD = false;
    Already_Sell_USDJPY = false;
    Already_Sell_GBPAUD = false;
    Already_Sell_EURUSD = false;

    Already_BelowMiddle_EURCAD = false;
    Already_BelowMiddle_CADCHF = false;
    Already_BelowMiddle_AUDUSD = false;
    Already_BelowMiddle_GBPCHF = false;
    Already_BelowMiddle_NZDCHF = false;
    Already_BelowMiddle_USDCAD = false;
    Already_BelowMiddle_AUDCHF = false;
    Already_BelowMiddle_NZDJPY = false;
    Already_BelowMiddle_CADJPY = false;
    Already_BelowMiddle_GBPUSD = false;
    Already_BelowMiddle_GBPCAD = false;
    Already_BelowMiddle_AUDJPY = false;
    Already_BelowMiddle_EURAUD = false;
    Already_BelowMiddle_GBPJPY = false;
    Already_BelowMiddle_NZDCAD = false;
    Already_BelowMiddle_EURJPY = false;
    Already_BelowMiddle_USDCHF = false;
    Already_BelowMiddle_EURCHF = false;
    Already_BelowMiddle_EURGBP = false;
    Already_BelowMiddle_NZDUSD = false;
    Already_BelowMiddle_CHFJPY = false;
    Already_BelowMiddle_AUDCAD = false;
    Already_BelowMiddle_AUDNZD = false;
    Already_BelowMiddle_USDJPY = false;
    Already_BelowMiddle_GBPAUD = false;
    Already_BelowMiddle_EURUSD = false;

    Already_AboveMiddle_EURCAD = false;
    Already_AboveMiddle_CADCHF = false;
    Already_AboveMiddle_AUDUSD = false;
    Already_AboveMiddle_GBPCHF = false;
    Already_AboveMiddle_NZDCHF = false;
    Already_AboveMiddle_USDCAD = false;
    Already_AboveMiddle_AUDCHF = false;
    Already_AboveMiddle_NZDJPY = false;
    Already_AboveMiddle_CADJPY = false;
    Already_AboveMiddle_GBPUSD = false;
    Already_AboveMiddle_GBPCAD = false;
    Already_AboveMiddle_AUDJPY = false;
    Already_AboveMiddle_EURAUD = false;
    Already_AboveMiddle_GBPJPY = false;
    Already_AboveMiddle_NZDCAD = false;
    Already_AboveMiddle_EURJPY = false;
    Already_AboveMiddle_USDCHF = false;
    Already_AboveMiddle_EURCHF = false;
    Already_AboveMiddle_EURGBP = false;
    Already_AboveMiddle_NZDUSD = false;
    Already_AboveMiddle_CHFJPY = false;
    Already_AboveMiddle_AUDCAD = false;
    Already_AboveMiddle_AUDNZD = false;
    Already_AboveMiddle_USDJPY = false;
    Already_AboveMiddle_GBPAUD = false;
    Already_AboveMiddle_EURUSD = false; 

    ADXBelow25_EURCAD = true;
    ADXBelow25_CADCHF = true;
    ADXBelow25_AUDUSD = true;
    ADXBelow25_GBPCHF = true;
    ADXBelow25_NZDCHF = true;
    ADXBelow25_USDCAD = true;
    ADXBelow25_AUDCHF = true;
    ADXBelow25_NZDJPY = true;
    ADXBelow25_CADJPY = true;
    ADXBelow25_GBPUSD = true;
    ADXBelow25_GBPCAD = true;
    ADXBelow25_AUDJPY = true;
    ADXBelow25_EURAUD = true;
    ADXBelow25_GBPJPY = true;
    ADXBelow25_NZDCAD = true;
    ADXBelow25_EURJPY = true;
    ADXBelow25_USDCHF = true;
    ADXBelow25_EURCHF = true;
    ADXBelow25_EURGBP = true;
    ADXBelow25_NZDUSD = true;
    ADXBelow25_CHFJPY = true;
    ADXBelow25_AUDCAD = true;
    ADXBelow25_AUDNZD = true;
    ADXBelow25_USDJPY = true;
    ADXBelow25_GBPAUD = true;
    ADXBelow25_EURUSD = true; 
}

/*********************************************************************/
/*                    Auto Close Order Function - END                 */
/*********************************************************************/

/*********************************************************************/
/*                    Trailing Stop - START                          */
/*********************************************************************/

void TrailingStop_Function(bool TrailingStop, string argSymbol)
{
   if(true == TrailingStop)
   {
      if(BuyMarketCount(argSymbol, MagicNumber) > 0 && Trailing_Start > 0)
      {
         BuyTrailingStop(argSymbol,  Trailing_Stop , Trailing_Start, Trailing_Step , MagicNumber);
      }
      
      if(SellMarketCount(argSymbol, MagicNumber) > 0 && Trailing_Stop > 0)
      {
         SellTrailingStop(argSymbol,  Trailing_Stop , Trailing_Start, Trailing_Step , MagicNumber);
      }
   }
   else
   {
      /* Do nothing */
   }
}

/*********************************************************************/
/*                    Trailing Stop - END                            */
/*********************************************************************/

/*********************************************************************/
/*                    Check Time Time Run - STRART                   */
/*********************************************************************/

bool CheckRunTime_Function(bool filterTime)
{
   int CurrentHour;
   
   bool returnCheckTime = false;
   
   if(true == filterTime)
   {
      CurrentHour = TimeHour(TimeCurrent());
      if(CurrentHour >= Hour_Start_1 && CurrentHour < Hour_End_1)
      {
        returnCheckTime = true;
      }
   }
   else
   {
      returnCheckTime = true;   
   }
   return returnCheckTime;
}

bool CheckRunTime_StopOrder_Function(bool filterTime)
{
   int CurrentHour;
   
   bool returnCheckTime = false;
   
   if(true == filterTime)
   {
      CurrentHour = TimeHour(TimeCurrent());
      if(CurrentHour >= Hour_Start_1 && CurrentHour < (Hour_End_1 - 1))
      {
        returnCheckTime = true;
      }
   }
   else
   {
      returnCheckTime = true;   
   }
   return returnCheckTime;
}

bool CheckRunTime_Function_RSI_ICHI_ADX(bool filterTime)
{
   int CurrentHour;
   
   bool returnCheckTime = false;
   
   if(true == filterTime)
   {
      CurrentHour = TimeHour(TimeCurrent());
      if(CurrentHour >= Hour_Start_2 && CurrentHour < Hour_End_2)
      {
        returnCheckTime = true;
      }
   }
   else
   {
      returnCheckTime = true;   
   }
   return returnCheckTime;
}

bool CheckRunTime_Function_GBPUSD_Breakout(bool filterTime)
{
   int CurrentHour;
   
   bool returnCheckTime = false;
   
   if(true == filterTime)
   {
      CurrentHour = TimeHour(TimeCurrent());
      if(CurrentHour >= 0 && CurrentHour < (Hour_End_1 - 1))
      {
        returnCheckTime = true;
      }
   }
   else
   {
      returnCheckTime = true;   
   }
   return returnCheckTime;
}


/*********************************************************************/
/*                    Check Time Time Run - END                      */
/*********************************************************************/

/*********************************************************************/
/*                    Only Buy or Sell Function - START               */
/*********************************************************************/

int MaxTradeEachSide(string argSymbol)
{
   int BuyOderCount        = BuyMarketCount(argSymbol, MagicNumber);
   int SellOderCount       = SellMarketCount(argSymbol, MagicNumber);
   
   int Sum = BuyOderCount + SellOderCount; 
   return Sum;
  
}

int MaxTradeEachSide_OrderStop(string argSymbol)
{
   int BuyOderCount        = BuyStopCount(argSymbol, MagicNumber);
   int SellOderCount       = SellStopCount(argSymbol, MagicNumber);
   
   int Sum = BuyOderCount + SellOderCount; 
   return Sum;
  
}

int MaxPendingOrderBuy_GBPUSD(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   int iTimeHour;
   datetime dtTimeDate;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      dtTimeDate = OrderOpenTime();
      iTimeHour = TimeHour(dtTimeDate);

      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_BUYSTOP && iTimeHour >= Hour_Start_1)
      {
         OrderCount++;
      }
   }
   return(OrderCount); 
}

int MaxPendingOrderSell_GBPUSD(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   int iTimeHour;
   datetime dtTimeDate;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      dtTimeDate = OrderOpenTime();
      iTimeHour = TimeHour(dtTimeDate);

      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_SELLSTOP && iTimeHour >= Hour_Start_1)
      {
         OrderCount++;
      }
   }
   return(OrderCount); 
}

/*********************************************************************/
/*                    Only Buy or Sell Function - END                 */
/*********************************************************************/

/*********************************************************************/
/*                    Pair Trade Setting - START                      */
/*********************************************************************/

void CoutPairTrade()
{
    PairTrade_Count = 0;
    if(EURCAD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[0] = Symbol_EURCAD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[0] = "NoUse"; 
    }
    if(CADCHF == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[1] = Symbol_CADCHF;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[1] = "NoUse"; 
    }
    if(AUDUSD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[2] = Symbol_AUDUSD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[2] = "NoUse"; 
    }
    if(GBPCHF == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[3] = Symbol_GBPCHF;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[3] = "NoUse"; 
    }
    if(NZDCHF == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[4] = Symbol_NZDCHF;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[4] = "NoUse"; 
    }
    if(USDCAD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[5] = Symbol_USDCAD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[5] = "NoUse"; 
    }
    if(AUDCHF == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[6] = Symbol_AUDCHF;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[6] = "NoUse"; 
    }
    if(NZDJPY == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[7] = Symbol_NZDJPY;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[7] = "NoUse"; 
    }
    if(CADJPY == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[8] = Symbol_CADJPY;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[8] = "NoUse"; 
    }
    if(GBPUSD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[9] = Symbol_GBPUSD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[9] = "NoUse"; 
    }
    if(GBPCAD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[10] = Symbol_GBPCAD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[10] = "NoUse"; 
    }
    if(AUDJPY == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[11] = Symbol_AUDJPY;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[11] = "NoUse"; 
    }
    if(EURAUD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[12] = Symbol_EURAUD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[12] = "NoUse"; 
    } 
    if(GBPJPY == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[13] = Symbol_GBPJPY;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[13] = "NoUse"; 
    } 
    if(NZDCAD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[14] = Symbol_NZDCAD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[14] = "NoUse"; 
    }
    if(EURJPY == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[15] = Symbol_EURJPY;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[15] = "NoUse"; 
    }
    if(USDCHF == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[16] = Symbol_USDCHF;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[16] = "NoUse"; 
    }  
    if(EURCHF == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[17] = Symbol_EURCHF;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[17] = "NoUse"; 
    }
    if(EURGBP == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[18] = Symbol_EURGBP;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[18] = "NoUse"; 
    }  
    if(NZDUSD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[19] = Symbol_NZDUSD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[19] = "NoUse"; 
    }
    if(CHFJPY == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[20] = Symbol_CHFJPY;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[20] = "NoUse"; 
    }
    if(AUDCAD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[21] = Symbol_AUDCAD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[21] = "NoUse"; 
    }
    if(AUDNZD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[22] = Symbol_AUDNZD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[22] = "NoUse"; 
    }
    if(USDJPY == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[23] = Symbol_USDJPY;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[23] = "NoUse"; 
    } 
    if(GBPAUD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[24] = Symbol_GBPAUD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[24] = "NoUse"; 
    }
    if(EURUSD == true)
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[25] = Symbol_EURUSD;
    }
    else
    {
       PairTrade_Count = PairTrade_Count + 1; 
       PairTrade[25] = "NoUse"; 
    } 
}

/*********************************************************************/
/*                    Pair Trade Setting - END                       */
/*********************************************************************/


/*********************************************************************/
/*                  PANEL function - START                           */
/*********************************************************************/
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

   if(id==CHARTEVENT_OBJECT_CLICK)
     {

      //-- DisplayLastKnownPing
      if(sparam==OBJPREFIX+"CONNECTION")
        {
         //-- SetTransparentColor
         int sRed=88,sGreen=88,sBlue=88,sRGB=0;
         sRGB=(sBlue<<16);sRGB|=(sGreen<<8);sRGB|=sRed;
         //--
         double Ping=TerminalInfoInteger(TERMINAL_PING_LAST);//SetPingToMs
         string text=TerminalInfoInteger(TERMINAL_CONNECTED)?DoubleToString(Ping/1000,2)+" ms":"NC";/*SetText*/
         //--
         LabelCreate(0,OBJPREFIX+"PING",0,ChartMiddleX(),ChartMiddleY(),CORNER_LEFT_UPPER,text,"Tahoma",200,sRGB,0,ANCHOR_CENTER,true,false,true,0,"\n");
         //--
         Sleep(1000);
         ObjectDelete(0,OBJPREFIX+"PING");//DeleteObject
        }

      //-- SwitchTheme
      if(sparam==OBJPREFIX+"THEME")
        {
         if(SelectedTheme==LIGHT)
            SetTheme(DARK);
         else
            SetTheme(LIGHT);
        }

      //-- StartPainting
      if(sparam==OBJPREFIX+"PAINT")
        {
         if(!IsPainting)
           {
            //-- EnablePainting
            IsPainting=true;
            //-- BlockMouseScroll
            ChartMouseScrollSet(false);
            //-- DisplayInfo
            LabelCreate(0,OBJPREFIX+"ERASE",0,5,15,CORNER_LEFT_LOWER,"Press down to erase","Arial",9,COLOR_RED,0,ANCHOR_LEFT,false,false,true,0,"\n");
            LabelCreate(0,OBJPREFIX+"BRUSHCOLOR",0,ChartMiddleX(),15,CORNER_LEFT_LOWER,"Press up to change color / Press left to change brush","Arial",9,BrushClrArr[BrushClrIndex],0,ANCHOR_CENTER,false,false,true,0,"\n");
            LabelCreate(0,OBJPREFIX+"BRUSHTYPE",0,ChartMiddleX()+155,15,CORNER_LEFT_LOWER,BrushArr[BrushIndex],"Wingdings",9,BrushClrArr[BrushClrIndex],0,ANCHOR_CENTER,false,false,true,0,"\n");
            LabelCreate(0,OBJPREFIX+"STOPPAINT",0,5,15,CORNER_RIGHT_LOWER,"Press right to stop drawing","Arial",9,COLOR_GREEN,0,ANCHOR_RIGHT,false,false,true,0,"\n");
           }
        }

      //-- SoundManagement
      if(sparam==OBJPREFIX+"SOUND" || sparam==OBJPREFIX+"SOUNDIO")
        {
         //-- EnableSound
         if(!SoundIsEnabled)
           {
            SoundIsEnabled=true;
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,C'59,41,40');//SetObject
            PlaySound("::Files\\TradePanel\\sound.wav");
           }
         //-- DisableSound
         else
           {
            SoundIsEnabled=false;
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,clrNONE);//SetObject
           }
        }

      //-- TickSoundsManagement
      if(sparam==OBJPREFIX+"PLAY")
        {
         //-- EnableTickSounds
         if(!PlayTicks)
           {
            PlayTicks=true;
            //-- SetObjects
            ObjectSetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT,";");
            ObjectSetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE,14);
           }
         //-- DisableTickSounds
         else
           {
            PlayTicks=false;
            //-- SetObjects
            ObjectSetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT,"4");
            ObjectSetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE,15);
           }
        }

      //-- SetBull/BearColors
      if(sparam==OBJPREFIX+"CANDLES¦")
        {
         color clrBullish = RandomColor();
         color clrBearish = RandomColor();
         //-- SetChart
         ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrBullish);
         ChartSetInteger(0,CHART_COLOR_CHART_UP,clrBullish);
         ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrBearish);
         ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrBearish);
         ChartSetInteger(0,CHART_COLOR_CHART_LINE,RandomColor());
        }

      //-- RemoveExpert
      if(sparam==OBJPREFIX+"EXIT")
        {
         if(MessageBox("Do you really want to remove the EA?",MB_CAPTION,MB_ICONQUESTION|MB_YESNO)==IDYES)
            ExpertRemove();//Exit
        }

      //-- SetClosingMode
      if(sparam==OBJPREFIX+"CLOSE¹²³")
        {
         CloseMode++;
         if(CloseMode>=ArraySize(CloseArr))//Reset
            CloseMode=0;
         ObjectSetString(0,OBJPREFIX+"CLOSE¹²³",OBJPROP_TEXT,0,CloseArr[CloseMode]);//SetObject
         _PlaySound("::Files\\TradePanel\\switch.wav");
        }

      //-- DecLotSize
      if(sparam==OBJPREFIX+"LOTSIZE<")
         ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize-=LotStep,2));//SetObject

      //-- IncLotSize
      if(sparam==OBJPREFIX+"LOTSIZE>")
         ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize+=LotStep,2));//SetObject

      //-- SellClick
      if(sparam==OBJPREFIX+"SELL")
        {
         //-- SendSellOrder
         OrderSend(OP_SELL);
         //-- ResetButton
         Sleep(100);
         ObjectSetInteger(0,OBJPREFIX+"SELL",OBJPROP_STATE,false);//SetObject
        }

      //-- CloseClick
      if(sparam==OBJPREFIX+"CLOSE")
        {
         //-- CloseOrder(s)
         OrderClose();
         //-- ResetButton
         Sleep(100);
         ObjectSetInteger(0,OBJPREFIX+"CLOSE",OBJPROP_STATE,false);//SetObject
        }

      //-- BuyClick
      if(sparam==OBJPREFIX+"BUY")
        {
         //-- SendBuyOrder
         OrderSend(OP_BUY);
         //-- ResetButton
         Sleep(100);
         ObjectSetInteger(0,OBJPREFIX+"BUY",OBJPROP_STATE,false);//SetObject
        }

      //-- ResetCoordinates
      if(sparam==OBJPREFIX+"RESET")
        {
         LabelMove(0,OBJPREFIX+"BCKGRND[]",CLIENT_BG_X,CLIENT_BG_Y);
         ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_STATE,false);//SetObject
         if(ObjectGetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE))
            ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE,false);/*SetObject*/
         //-- MoveObjects
         GetSetCoordinates();
         ObjectsMoveAll();
        }

      //--
     }
//--
   if(id==CHARTEVENT_KEYDOWN)
     {

      //-- BrushType
      if(lparam==KEY_LEFT)
        {
         if(IsPainting)
           {
            BrushIndex++;
            if(BrushIndex>=ArraySize(BrushArr))//Reset
               BrushIndex=0;
            ObjectSetString(0,OBJPREFIX+"BRUSHTYPE",OBJPROP_TEXT,0,BrushArr[BrushIndex]);//SetObject
           }
        }

      //-- StopPainting
      if(lparam==KEY_RIGHT)
        {
         if(IsPainting)
           {
            //-- DisablePainting
            IsPainting=false;
            //-- DeleteObjects
            if(ObjectFind(0,OBJPREFIX+"ERASE")==0)
               ObjectDelete(0,OBJPREFIX+"ERASE");
            if(ObjectFind(0,OBJPREFIX+"BRUSHCOLOR")==0)
               ObjectDelete(0,OBJPREFIX+"BRUSHCOLOR");
            if(ObjectFind(0,OBJPREFIX+"BRUSHTYPE")==0)
               ObjectDelete(0,OBJPREFIX+"BRUSHTYPE");
            if(ObjectFind(0,OBJPREFIX+"STOPPAINT")==0)
               ObjectDelete(0,OBJPREFIX+"STOPPAINT");
            //-- UnblockMouseScroll
            ChartMouseScrollSet(true);
           }
        }

      //-- BrushColor
      if(lparam==KEY_UP)
        {
         if(IsPainting)
           {
            BrushClrIndex++;
            if(BrushClrIndex>=ArraySize(BrushClrArr))//Reset
               BrushClrIndex=0;
            //-- SetObjects
            ObjectSetInteger(0,OBJPREFIX+"BRUSHCOLOR",OBJPROP_COLOR,0,BrushClrArr[BrushClrIndex]);
            ObjectSetInteger(0,OBJPREFIX+"BRUSHTYPE",OBJPROP_COLOR,0,BrushClrArr[BrushClrIndex]);
           }
        }

      //-- DeleteDraws
      if(lparam==KEY_DOWN)
        {
         if(IsPainting)
           {
            if(ObjectsDeleteAll(0,"draw",0,OBJ_TEXT)>0)
               draw=0;
           }
        }

      //--  
     }
//---
   if(id==CHARTEVENT_MOUSE_MOVE)
     {

      //-- UserIsHolding (Left-Click)
      if(sparam=="1")
        {

         //-- MoveClient
         if(ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED) || ObjectFind(0,OBJPREFIX+"BCKGRND[]")!=0)
           {
            //-- MoveObjects
            GetSetCoordinates();
            ObjectsMoveAll();
           }

         //-- Paint
         if(IsPainting)
           {
            //-- GetMousePosition
            mouse_x=(int)lparam;
            mouse_y=(int)dparam;
            //-- ConvertXYToDatePrice
            ChartXYToTimePrice(0,mouse_x,mouse_y,mouse_w,mouse_dt,mouse_pr);
            //-- CreateObjects
            TextCreate(0,"draw"+IntegerToString(draw),0,mouse_dt,mouse_pr,BrushArr[BrushIndex],"Wingdings",10,BrushClrArr[BrushClrIndex],0,ANCHOR_CENTER,false,false,true,0,"\n");
            draw++;
           }

         //--
        }

      //--
     }
//---
  }
//+------------------------------------------------------------------+
//| OnTester                                                         |
//+------------------------------------------------------------------+
void _OnTester()
  {
//--- CheckObjects
   ObjectsCheckAll();

//-- GetSetUserInputs
   GetSetInputs();

//-- DisplaySymbolInfo
   SymbolInfo();

//-- DisplayAccount&TradeInfo
   AccAndTradeInfo();

//-- SellClick
   if(ObjectFind(0,OBJPREFIX+"SELL")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"SELL",OBJPROP_STATE))
        {
         //-- SendSellOrder
         OrderSend(OP_SELL);
         ObjectSetInteger(0,OBJPREFIX+"SELL",OBJPROP_STATE,false);//ResetButton
        }
     }

//-- CloseClick
   if(ObjectFind(0,OBJPREFIX+"CLOSE")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"CLOSE",OBJPROP_STATE))
        {
         //-- CloseOrder(s)
         OrderClose();
         ObjectSetInteger(0,OBJPREFIX+"CLOSE",OBJPROP_STATE,false);//ResetButton
        }
     }

//-- BuyClick
   if(ObjectFind(0,OBJPREFIX+"BUY")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"BUY",OBJPROP_STATE))
        {
         //-- SendBuyOrder
         OrderSend(OP_BUY);
         ObjectSetInteger(0,OBJPREFIX+"BUY",OBJPROP_STATE,false);//ResetButton
        }
     }

//-- MoveClient
   if(ObjectFind(0,OBJPREFIX+"BCKGRND[]")==0)//ObjectIsPresent
     {
      //-- GetCurrentPos
      int bg_x=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_XDISTANCE);
      int bg_y=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_YDISTANCE);
      //-- MoveObjects
      if(bg_x!=x1 || bg_y!=y1)
        {
         GetSetCoordinates();
         ObjectsMoveAll();
        }
     }

//-- ResetPosition
   if(ObjectFind(0,OBJPREFIX+"RESET")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"RESET",OBJPROP_STATE))
        {
         //-- MoveObject
         LabelMove(0,OBJPREFIX+"BCKGRND[]",CLIENT_BG_X,CLIENT_BG_Y);
         ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_STATE,false);//SetObject
         if(ObjectGetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE))
            ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE,false);//SetObject
        }
     }

//---
  }
//+------------------------------------------------------------------+
//| OrderSend                                                        |
//+------------------------------------------------------------------+
void OrderSend(const int Type)
  {
//--
   int op_tkt=0;
   uint tick=0;
   uint ex_time=0;
//--
   double rq_price=0;
   double slippage=0;
//--- reset the error value
   ResetLastError();
//-- CheckOrdSendRequirements
   if(IsTradeAllowed() && !IsTradeContextBusy() && IsConnected())
     {
      //-- SellOrders
      if(Type==OP_SELL)
        {
         //-- EnoughMargin
         if(AccountFreeMarginCheck(_Symbol,OP_SELL,LotSize)>=0)
           {
            //-- CorrectLotSize (Rounded by GetSetInputs)
            if(LotSize>=MinLot && LotSize<=MaxLot)
              {
               tick=GetTickCount();//GetTime
               rq_price=MarketInfo(_Symbol,MODE_BID);//GetPrice
               op_tkt=OrderSend(_Symbol,OP_SELL,LotSize,rq_price,Slippage,0,0,ExpertName, MagicNumber,0,COLOR_SELL);//SendOrder
              }
            else
              {
               //-- Error
               Print("OrderSend failed with error #131 [Invalid trade volume]");
               _PlaySound(ErrorSound);
               //--
               Sleep(ErrorInterval);
               return;
              }
            //--
            if(op_tkt<0)
              {
               //-- Error
               Print("OrderSend failed with error #",_LastError);
               _PlaySound(ErrorSound);
               //--
               Sleep(ErrorInterval);
               return;
              }
            else
              {
               //-- Succeeded
               ex_time=GetTickCount()-tick;//CalcExeTime
               slippage=(PriceByTkt(OPENPRICE,op_tkt)-rq_price)/_Point;//CalcSlippage
               Print("OrderSend placed successfully (Open Sell) "+"#"+IntegerToString(op_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | Slippage: "+DoubleToString(slippage,0)+"p");
               _PlaySound("::Files\\TradePanel\\sell.wav");
               //-- SL
               if(StopLoss_1>0 && StopLoss_1>=MinStop)
                 {
                  if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+StopLoss_1*_Point,OrderTakeProfit(),0,COLOR_SELL))
                       {
                        //-- Error
                        Print("Error in OrderModify. Error code=",_LastError);
                        _PlaySound(ErrorSound);
                        Sleep(ErrorInterval);
                       }
                     else
                       {
                        //-- Succeeded
                        //Print("Order modified successfully");
                       }
                    }
                 }
               //-- TP
               if(TakeProfit_1>0 && TakeProfit_1>=MinStop)
                 {
                  if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-TakeProfit_1*_Point,0,COLOR_BUY))
                       {
                        //-- Error
                        Print("Error in OrderModify. Error code=",_LastError);
                        _PlaySound(ErrorSound);
                        Sleep(ErrorInterval);
                       }
                     else
                       {
                        //-- Succeeded
                        //Print("Order modified successfully");*/
                       }
                    }
                 }
              }
            //--
           }
         else
           {
            //-- NotEnoughMoney
            Print(" '",AccountNumber(),"' :"," order #0 sell ",DoubleToString(LotSize,2)," ",_Symbol," [Not enough money]");
            _PlaySound(ErrorSound);
           }
         //--
        }
      //-- BuyOrders
      if(Type==OP_BUY)
        {
         //-- EnoughMargin
         if(AccountFreeMarginCheck(_Symbol,OP_BUY,LotSize)>=0)
           {
            //-- CorrectLotSize (Rounded by GetSetInputs)
            if(LotSize>=MinLot && LotSize<=MaxLot)
              {
               tick=GetTickCount();//GetTime
               rq_price=MarketInfo(_Symbol,MODE_ASK);//GetPrice
               op_tkt=OrderSend(_Symbol,OP_BUY,LotSize,rq_price,Slippage,0,0,ExpertName, MagicNumber, 0,COLOR_BUY);//SendOrder
              }
            else
              {
               //-- Error
               Print("OrderSend failed with error #131 [Invalid trade volume]");
               _PlaySound(ErrorSound);
               //--
               Sleep(ErrorInterval);
               return;
              }
            //--
            if(op_tkt<0)
              {
               //-- Error
               Print("OrderSend failed with error #",_LastError);
               _PlaySound(ErrorSound);
               //--
               Sleep(ErrorInterval);
               return;
              }
            else
              {
               //-- Succeeded
               ex_time=GetTickCount()-tick;//CalcExeTime
               slippage=(rq_price-PriceByTkt(OPENPRICE,op_tkt))/_Point;//CalcSlippage
               Print("OrderSend placed successfully (Open Buy) "+"#"+IntegerToString(op_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | Slippage: "+DoubleToString(slippage,0)+"p");
               _PlaySound("::Files\\TradePanel\\buy.wav");
               //-- SL
               if(StopLoss_1>0 && StopLoss_1>=MinStop)
                 {
                  if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-StopLoss_1*_Point,OrderTakeProfit(),0,COLOR_SELL))
                       {
                        //-- Error
                        Print("Error in OrderModify. Error code=",_LastError);
                        _PlaySound(ErrorSound);
                        Sleep(ErrorInterval);
                       }
                     else
                       {
                        //-- Succeeded
                        //Print("Order modified successfully");
                       }
                    }
                 }
               //-- TP
               if(TakeProfit_1>0 && TakeProfit_1>=MinStop)
                 {
                  if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+TakeProfit_1*_Point,0,COLOR_BUY))
                       {
                        //-- Error
                        Print("Error in OrderModify. Error code=",_LastError);
                        _PlaySound(ErrorSound);
                        Sleep(ErrorInterval);
                       }
                     else
                       {
                        //-- Succeeded
                        //Print("Order modified successfully");
                       }
                    }
                 }
              }
            //--
           }
         else
           {
            //-- NotEnoughMoney
            Print(" '",AccountNumber(),"' :"," order #0 buy ",DoubleToString(LotSize,2)," ",_Symbol," [Not enough money]");
            _PlaySound(ErrorSound);
           }
         //--
        }
     }
   else
     {
      //-- RequirementsNotFulfilled
      if(!IsConnected())
         Print("No Internet connection found! Please check your network connection and try again.");
      if(IsTradeContextBusy())
         Print("Trade context is busy, Please wait...");
      if(!IsTradeAllowed())
         Print("Check if automated trading is allowed in the terminal / program settings and try again.");
      //--
      _PlaySound(ErrorSound);
      //--
      Sleep(ErrorInterval);
      return;
      //--
     }
//--
  }
//+------------------------------------------------------------------+
//| OrderClose                                                       |
//+------------------------------------------------------------------+
void OrderClose()
  {
//--
   double ordprofit=0;
   double ordlots=0;
//--
   int c_tkt=0;
   int ordtype=0;
   uint tick=0;
   uint ex_time=0;
//--
   double rq_price=0;
   double slippage=0;
//--
   string ordtypestr="";
//--- reset the error value
   ResetLastError();
//-- CheckOrdCloseRequirements
   if(IsTradeAllowed() && !IsTradeContextBusy() && IsConnected())
     {
      //-- SelectOrder
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderMagicNumber()==MagicNumber)
              {
                for(int index = 0; index < PairTrade_Count; index ++ )
                {
                  if(PairTrade[index] != "NoUse")
                  {
                      CloseAllPending_Order(PairTrade[index]);
                  }
                }
               if(OrderType()<=OP_SELL)//MarketOrdersOnly
                 {
                  //--
                  ordprofit=OrderProfit()+OrderCommission()+OrderSwap();//GetPtofit
                  ordlots=(CloseMode==CLOSEPARTIAL)?ordlots=LotSizeInp:OrderLots();//SetLots
                  if(ordlots>OrderLots())
                     ordlots=OrderLots();
                  //--
                  if((CloseMode==CLOSEALL) || (CloseMode==CLOSELAST) || (CloseMode==CLOSEPROFIT && ordprofit>0) || (CloseMode==CLOSELOSS && ordprofit<0) || (CloseMode==CLOSEPARTIAL))
                    {
                     tick=GetTickCount();
                     rq_price=OrderClosePrice();
                     c_tkt=OrderTicket();
                     ordtype=OrderType();
                     ordtypestr=(OrderType()==OP_SELL)?ordtypestr="Sell":ordtypestr="Buy";
                     //--
                     if(!OrderClose(OrderTicket(),ordlots,rq_price,0,COLOR_CLOSE))
                       {
                        //-- Error
                        Print("OrderClose failed with error #",_LastError);
                        Sleep(ErrorInterval);
                        return;
                       }
                     else
                       {
                        //-- Succeeded
                        ex_time=GetTickCount()-tick;//CalcExeTime
                        slippage=(ordtype==OP_SELL)?(PriceByTkt(CLOSEPRICE,c_tkt)-rq_price)/_Point:(rq_price-PriceByTkt(CLOSEPRICE,c_tkt))/_Point;//CalcSlippage
                        Print("Order closed successfully"+" (Close "+ordtypestr+") "+"#"+IntegerToString(c_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | "+"Slippage: "+DoubleToString(slippage,0)+"p");
                        _PlaySound("::Files\\TradePanel\\close.wav");
                        //--
                        if(CloseMode==CLOSELAST || CloseMode==CLOSEPARTIAL)
                           break;
                       }
                    }
                  //--
                 }
              }
           }
        }
      //--
     }
   else
     {
      //-- RequirementsNotFulfilled
      if(!IsConnected())
         Print("No Internet connection found! Please check your network connection and try again.");
      if(IsTradeContextBusy())
         Print("Trade context is busy, Please wait...");
      if(!IsTradeAllowed())
         Print("Check if automated trading is allowed in the terminal / program settings and try again.");
      //--
      _PlaySound(ErrorSound);
      //--
      Sleep(ErrorInterval);
      return;
     }
//--
  }
//+------------------------------------------------------------------+
//| OpenPos                                                          |
//+------------------------------------------------------------------+
int OpenPos(const int Type)
  {
//--
   int count=0;
//--
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_SELL && Type==OP_SELL)
               count++;
            if(OrderType()==OP_BUY && Type==OP_BUY)
               count++;
            if(OrderType()<=OP_SELL && Type==OP_ALL)
               count++;
           }
        }
     }
   return(count);
//--
  }
//+------------------------------------------------------------------+
//| ØOpenPrice                                                       |
//+------------------------------------------------------------------+
double ØOpenPrice()
  {
//--
   double ordlots=0;
   double price=0;
   double avgprice=0;
//--
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               ordlots+=OrderLots();
               price+=OrderLots()*OrderOpenPrice();
              }
           }
        }
     }
//-- CalcAvgPrice
   avgprice=price/ordlots;
//--
   return(avgprice);
  }
//+------------------------------------------------------------------+
//| FloatingProfits                                                  |
//+------------------------------------------------------------------+
double FloatingProfits()
  {
//--  
   double profit=0;
//--
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               profit+=OrderProfit()+OrderCommission()+OrderSwap();
              }
           }
        }
     }
   return(profit);
//--
  }
//+------------------------------------------------------------------+
//| FloatingPoints                                                   |
//+------------------------------------------------------------------+
double FloatingPoints()
  {
//--
   double sellpts=0;
   double buypts=0;
//--
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_SELL)
               sellpts+=(OrderOpenPrice()-OrderClosePrice())/_Point;
            if(OrderType()==OP_BUY)
               buypts+=(OrderClosePrice()-OrderOpenPrice())/_Point;
           }
        }
     }
   return(sellpts+buypts);
//--
  }
//+------------------------------------------------------------------+
//| DailyProfits                                                     |
//+------------------------------------------------------------------+
double DailyProfits()
  {
//--  
   double profit=0;
//--
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               if(TimeToStr(TimeCurrent(),TIME_DATE)==TimeToString(OrderCloseTime(),TIME_DATE))
                  profit+=OrderProfit()+OrderCommission()+OrderSwap();
              }
           }
        }
     }
   return(profit);
//--
  }
//+------------------------------------------------------------------+
//| DailyPoints                                                      |
//+------------------------------------------------------------------+
double DailyPoints()
  {
//--
   double sellpts=0;
   double buypts=0;
//--
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               if(TimeToStr(TimeCurrent(),TIME_DATE)==TimeToString(OrderCloseTime(),TIME_DATE))
                 {
                  if(OrderType()==OP_SELL)
                     sellpts+=(OrderOpenPrice()-OrderClosePrice())/_Point;
                  if(OrderType()==OP_BUY)
                     buypts+=(OrderClosePrice()-OrderOpenPrice())/_Point;
                 }
              }
           }
        }
     }
   return(sellpts+buypts);
//--
  }
//+------------------------------------------------------------------+
//| DailyReturn                                                      |
//+------------------------------------------------------------------+
double DailyReturn()
  {
//--
   double percent=0;
   double startbal=0;

//-- GetStartBalance
   startbal=(DailyProfits()>0)?AccountBalance()-DailyProfits():AccountBalance()+MathAbs(DailyProfits());

//-- CalcReturn (ROI)
   if(startbal!=0)//AvoidZeroDivide
      percent=DailyProfits()*100/startbal;
//--
   return(percent);
  }
//+------------------------------------------------------------------+
//| PriceByTkt                                                       |
//+------------------------------------------------------------------+
double PriceByTkt(const int Type,const int Ticket)
  {
//--
   double price=0;
//--
   if(OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      if(Type==OPENPRICE)
         price=OrderOpenPrice();
      if(Type==CLOSEPRICE)
         price=OrderClosePrice();
     }
//--
   return(price);
  }
//+------------------------------------------------------------------+
//| GetSetInputs                                                     |
//+------------------------------------------------------------------+
void GetSetInputs()
  {
//-- GetMarketInfo
   LotStep=MarketInfo(_Symbol,MODE_LOTSTEP);
   MinLot=MarketInfo(_Symbol,MODE_MINLOT);
   MaxLot=MarketInfo(_Symbol,MODE_MAXLOT);
   MinStop=MarketInfo(_Symbol,MODE_STOPLEVEL);

//-- GetLotSizeInput
   LotSizeInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT));/*SetObject*/
//-- RoundLotSize
   LotSize=LotSizeInp;
   LotSize=MathRound(LotSize/LotStep)*LotStep;
   ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/
//-- WrongLotSize
   if(LotSize<=MinLot)
     {
      LotSize=MinLot;
      ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/
     }
//--
   if(LotSize>=MaxLot)
     {
      LotSize=MaxLot;
      ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/
     }

//-- GetSLInput
   StopLossInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>",OBJPROP_TEXT));/*GetObject*/
//-- WrongSL
   if(StopLossInp<0 || StopLossInp<MinStop)
     {
      ObjectSetString(0,OBJPREFIX+"SL<>",OBJPROP_TEXT,0,DoubleToString(StopLoss_1,0));/*SetObject*/
     }
   else
     {
     }

//-- GetTPInput
   TakeProfitInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"TP<>",OBJPROP_TEXT));/*GetObject*/
//-- WrongTP
   if(TakeProfitInp<0 || TakeProfitInp<MinStop)
     {
      ObjectSetString(0,OBJPREFIX+"TP<>",OBJPROP_TEXT,0,DoubleToString(TakeProfit_1,0));/*SetObject*/
     }
   else
     {
     }

//-- SymbolChanger
   SymbolInp=ObjectGetString(0,OBJPREFIX+"SYMBOL¤",OBJPROP_TEXT);//GetSymbolInput

   if(SymbolInp!="" && _Symbol!=SymbolInp)
     {
      if(SymbolFind(SymbolInp))
        {
         ChartSetSymbolPeriod(0,SymbolInp,PERIOD_CURRENT);//SetChart
        }
      else
        {
         //-- WrongSymbolInput
         MessageBox("Warning: Symbol "+SymbolInp+" couldn't be found!\n\nMake sure it is available in the symbol list.\n(View -> Symbols / Ctrl+U)",
                    MB_CAPTION,MB_OK|MB_ICONWARNING);
         ObjectSetString(0,OBJPREFIX+"SYMBOL¤",OBJPROP_TEXT,_Symbol);//Reset
        }
     }
//--
  }
//+------------------------------------------------------------------+
//| SymbolInfo                                                       |
//+------------------------------------------------------------------+
void SymbolInfo()
  {
//-- SetObjects
   ObjectSetString(0,OBJPREFIX+"ASK",OBJPROP_TEXT,DoubleToString(MarketInfo(_Symbol,MODE_ASK),_Digits));
   ObjectSetString(0,OBJPREFIX+"BID",OBJPROP_TEXT,DoubleToString(MarketInfo(_Symbol,MODE_BID),_Digits));
//--
   ObjectSetString(0,OBJPREFIX+"UPTICKS",OBJPROP_TEXT,DoubleToString(UpTicks,0));
   ObjectSetString(0,OBJPREFIX+"DWNTICKS",OBJPROP_TEXT,DoubleToString(DwnTicks,0));
//--
   ObjectSetString(0,OBJPREFIX+"TIMER",OBJPROP_TEXT,"--> "+TimeToString(Time[0]+Period()*60-TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
//--
   ObjectSetString(0,OBJPREFIX+"SPREAD",OBJPROP_TEXT,DoubleToString(MarketInfo(_Symbol,MODE_SPREAD),0)+"p");

//-- GetOpen&Close
   double dayopen=iOpen(NULL,PERIOD_D1,0);
   double dayclose=iClose(NULL,PERIOD_D1,0);

//-- AvoidZeroDivide
   if(dayclose!=0)
     {
      //-- CalcPercentage
      double symbol_p=NormalizeDouble((dayclose-dayopen)/dayclose*100,2);
      //-- PositiveValue
      if(symbol_p>0)
        {
         //-- SetObjects
         ObjectSetString(0,OBJPREFIX+"SYMBOL§",OBJPROP_TEXT,0,"é");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§",OBJPROP_COLOR,±Clr(symbol_p));
         //--
         ObjectSetString(0,OBJPREFIX+"SYMBOL%",OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%",OBJPROP_COLOR,±Clr(symbol_p));
        }
      //-- NegativeValue
      if(symbol_p<0)
        {
         //-- SetObjects
         ObjectSetString(0,OBJPREFIX+"SYMBOL§",OBJPROP_TEXT,0,"ê");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§",OBJPROP_COLOR,±Clr(symbol_p));
         //--
         ObjectSetString(0,OBJPREFIX+"SYMBOL%",OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%",OBJPROP_COLOR,±Clr(symbol_p));
        }
      //-- NeutralValue
      if(symbol_p==0)
        {
         //-- SetObjects
         ObjectSetString(0,OBJPREFIX+"SYMBOL§",OBJPROP_TEXT,0,"è");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%",OBJPROP_COLOR,±Clr(symbol_p));
         //--
         ObjectSetString(0,OBJPREFIX+"SYMBOL%",OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§",OBJPROP_COLOR,±Clr(symbol_p));
        }
     }
//-- ResetCumulatedTicks
   ResetTicks();
//--
  }
//+------------------------------------------------------------------+
//| Speedometer                                                      |
//+------------------------------------------------------------------+
void Speedometer()
  {
//-- CalcSpeed
   double LastPrice=AvgPrice/_Point;
   double CurrentPrice=((MarketInfo(_Symbol,MODE_ASK)+MarketInfo(_Symbol,MODE_BID))/2)/_Point;
   double Speed=NormalizeDouble((CurrentPrice-LastPrice),0);
   AvgPrice=(MarketInfo(_Symbol,MODE_ASK)+MarketInfo(_Symbol,MODE_BID))/2;

//-- SetMaxSpeed
   if(Speed>99)
      Speed=99;

//-- ResetColors
   for(int i=0; i<(MaxSpeedBars); i++)
     {
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"SPEED#"+IntegerToString(i,0,0),OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,OBJPREFIX+"SPEEDª",OBJPROP_COLOR,clrNONE);
     }

//-- SetColor&Text
   for(int i=0; i<MathAbs(Speed); i++)
     {
      //-- PositiveValue
      if(Speed>0)
        {
         //-- SetObjects
         ObjectSetInteger(0,OBJPREFIX+"SPEED#"+IntegerToString(i,0,0),OBJPROP_COLOR,COLOR_BUY);
         ObjectSetInteger(0,OBJPREFIX+"SPEEDª",OBJPROP_COLOR,COLOR_BUY);
         //--
         UpTicks+=Speed;//Cumulated
        }
      //-- NegativeValue
      if(Speed<0)
        {
         //-- SetObjects
         ObjectSetInteger(0,OBJPREFIX+"SPEED#"+IntegerToString(i,0,0),OBJPROP_COLOR,COLOR_SELL);
         ObjectSetInteger(0,OBJPREFIX+"SPEEDª",OBJPROP_COLOR,COLOR_SELL);
         //--
         DwnTicks+=MathAbs(Speed);//Cumulated
        }
      ObjectSetString(0,OBJPREFIX+"SPEEDª",OBJPROP_TEXT,0,±Str(Speed,0));//SetObject
     }

//-- IsPlayTickSound
   if(PlayTicks)
     {
      //-- SetWavFile
      string SpeedToStr="";
      //-- PositiveValue
      if(Speed>0)
        {
         SpeedToStr="+"+DoubleToString(MathMin(Speed,10),0);
        }
      //-- NegativeValue
      else
        {
         SpeedToStr=""+DoubleToString(MathMax(Speed,-10),0);
        }
      //--
      _PlaySound("::Files\\TradePanel\\Tick"+SpeedToStr+".wav");
     }
//--
  }
//+------------------------------------------------------------------+
//| AccAndTradeInfo                                                  |
//+------------------------------------------------------------------+
void AccAndTradeInfo()
  {
//-- ZeroOrders
   if(OpenPos(OP_ALL)==0)
     {
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"ROIª",OBJPROP_COLOR,±Clr(DailyProfits()));
      ObjectSetInteger(0,OBJPREFIX+"ROI§",OBJPROP_COLOR,±Clr(DailyProfits()));
      //--
      ObjectSetString(0,OBJPREFIX+"ROI%",OBJPROP_TEXT,±Str(DailyReturn(),2)+"%");
      ObjectSetInteger(0,OBJPREFIX+"ROI%",OBJPROP_COLOR,±Clr(DailyReturn()));
      //--
      ObjectSetString(0,OBJPREFIX+"PROFITS",OBJPROP_TEXT,±Str(DailyProfits(),2)+_AccountCurrency());
      ObjectSetInteger(0,OBJPREFIX+"PROFITS",OBJPROP_COLOR,±Clr(DailyProfits()));
      //--
      ObjectSetString(0,OBJPREFIX+"POINTS",OBJPROP_TEXT,±Str(DailyPoints(),0)+"p");
      ObjectSetInteger(0,OBJPREFIX+"POINTS",OBJPROP_COLOR,±Clr(DailyPoints()));
      //--
      ObjectSetString(0,OBJPREFIX+"FLOATª",OBJPROP_TEXT,"");
      ObjectSetInteger(0,OBJPREFIX+"FLOATª",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT§",OBJPROP_TEXT,"");
      ObjectSetInteger(0,OBJPREFIX+"FLOAT§",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT$",OBJPROP_TEXT,DoubleToString(0,_Digits));
      ObjectSetInteger(0,OBJPREFIX+"FLOAT$",OBJPROP_COLOR,clrNONE);
     }

//-- BuyOrders
   if(OpenPos(OP_BUY)>0 && OpenPos(OP_SELL)==0)
     {
      //-- SetObjects
      ObjectSetString(0,OBJPREFIX+"FLOATª",OBJPROP_TEXT,"ö");
      ObjectSetInteger(0,OBJPREFIX+"FLOATª",OBJPROP_COLOR,clrDodgerBlue);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT§",OBJPROP_TEXT,"Buy");
      ObjectSetInteger(0,OBJPREFIX+"FLOAT§",OBJPROP_COLOR,clrDodgerBlue);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT$",OBJPROP_TEXT,DoubleToString(ØOpenPrice(),_Digits));
      ObjectSetInteger(0,OBJPREFIX+"FLOAT$",OBJPROP_COLOR,clrDodgerBlue);
     }

//-- SellOrders
   if(OpenPos(OP_SELL)>0 && OpenPos(OP_BUY)==0)
     {
      //-- SetObjects
      ObjectSetString(0,OBJPREFIX+"FLOATª",OBJPROP_TEXT,"ø");
      ObjectSetInteger(0,OBJPREFIX+"FLOATª",OBJPROP_COLOR,clrOrangeRed);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT§",OBJPROP_TEXT,"Sell");
      ObjectSetInteger(0,OBJPREFIX+"FLOAT§",OBJPROP_COLOR,clrOrangeRed);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT$",OBJPROP_TEXT,DoubleToString(ØOpenPrice(),_Digits));
      ObjectSetInteger(0,OBJPREFIX+"FLOAT$",OBJPROP_COLOR,clrOrangeRed);
     }

//-- Buy&Sell Orders (Hedge)
   if(OpenPos(OP_BUY)>0 && OpenPos(OP_SELL)>0)
     {
      //-- SetObjects
      ObjectSetString(0,OBJPREFIX+"FLOATª",OBJPROP_TEXT,"ô");
      ObjectSetInteger(0,OBJPREFIX+"FLOATª",OBJPROP_COLOR,COLOR_HEDGE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT§",OBJPROP_TEXT,"Hedge");
      ObjectSetInteger(0,OBJPREFIX+"FLOAT§",OBJPROP_COLOR,COLOR_HEDGE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT$",OBJPROP_TEXT,DoubleToString(ØOpenPrice(),_Digits));
      ObjectSetInteger(0,OBJPREFIX+"FLOAT$",OBJPROP_COLOR,COLOR_HEDGE);
     }

//-- AtLeastOneOrder
   if(OpenPos(OP_ALL)>0)
     {
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"ROIª",OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,OBJPREFIX+"ROI§",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetInteger(0,OBJPREFIX+"ROI%",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetString(0,OBJPREFIX+"PROFITS",OBJPROP_TEXT,±Str(FloatingProfits(),2)+_AccountCurrency());
      ObjectSetInteger(0,OBJPREFIX+"PROFITS",OBJPROP_COLOR,±Clr(FloatingProfits()));
      //--
      ObjectSetString(0,OBJPREFIX+"POINTS",OBJPROP_TEXT,±Str(FloatingPoints(),0)+"p");
      ObjectSetInteger(0,OBJPREFIX+"POINTS",OBJPROP_COLOR,±Clr(FloatingPoints()));
     }

//-- DisplayOrderHistory
   if(ShowOrdHistory)
      DrawOrdHistory();
//--
  }
//+------------------------------------------------------------------+
//| GetSetCoordinates                                                |
//+------------------------------------------------------------------+
void GetSetCoordinates()
  {
//-- 
   if(ObjectFind(0,OBJPREFIX+"BCKGRND[]")!=0)//ObjectNotFound
     {

      //-- DeleteObjects (Background must be at the back)
      for(int i=0; i<ObjectsTotal(); i++)
        {
         //-- GetObjectName
         string obj_name=ObjectName(i);
         //-- PrefixObjectFound
         if(StringSubstr(obj_name,0,StringLen(OBJPREFIX))==OBJPREFIX)
           {
            //-- DeleteObjects
            if(ObjectsDeleteAll(0,OBJPREFIX,-1,-1)>0)
               break;
           }
        }

      //-- GetXYValues (Saved)
      if(GlobalVariableGet(ExpertName+" - X")!=0 && GlobalVariableGet(ExpertName+" - Y")!=0)
        {
         x1=(int)GlobalVariableGet(ExpertName+" - X");
         y1=(int)GlobalVariableGet(ExpertName+" - Y");
        }
      //-- SetXYValues (Default)
      else
        {
         x1=CLIENT_BG_X;
         y1=CLIENT_BG_Y;
        }

      //-- CreateObject (Background)
      RectLabelCreate(0,OBJPREFIX+"BCKGRND[]",0,x1,y1,x2,y2,COLOR_BG,BORDER_FLAT,CORNER_LEFT_UPPER,clrOrange,STYLE_SOLID,1,false,true,true,0,"\n");
      ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED,false);//UnselectObject
     }

//-- GetCoordinates
   x1=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_XDISTANCE);
   y1=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_YDISTANCE);

//-- SetCommonAxis
   button_y=y1+y2-(BUTTON_HEIGHT+BUTTON_GAP_Y);
   inputs_y=button_y-BUTTON_HEIGHT-BUTTON_GAP_Y;
   label_y=inputs_y+EDIT_HEIGHT/2;
//--
   fr_x=x1+SPEEDBAR_GAP_X;
//--
  }
//+------------------------------------------------------------------+
//| CreateObjects                                                    |
//+------------------------------------------------------------------+ 
void ObjectsCreateAll()
  {
//--
   ButtonCreate(0,OBJPREFIX+"RESET",0,CLIENT_BG_X,CLIENT_BG_Y,15,15,CORNER_LEFT_UPPER,"°","Wingdings",10,COLOR_FONT,COLOR_MOVE,clrOrange,false,false,false,true,0,"\n");
//--
   RectLabelCreate(0,OBJPREFIX+"BORDER[]",0,x1,y1,x2,INDENT_TOP,clrOrange,BORDER_FLAT,CORNER_LEFT_UPPER,clrOrange,STYLE_SOLID,1,false,false,true,0,"\n");
//-- 
   LabelCreate(0,OBJPREFIX+"CAPTION",0,x1+(x2/2),y1,CORNER_LEFT_UPPER,"Trade Panel","Calibri",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n");
//-- 
   LabelCreate(0,OBJPREFIX+"EXIT",0,(x1+(x2/2))+115,y1-2,CORNER_LEFT_UPPER,"r","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   ButtonCreate(0,OBJPREFIX+"MOVE",0,x1,y1,15,15,CORNER_LEFT_UPPER,"ó","Wingdings",10,COLOR_FONT,COLOR_MOVE,clrDarkOrange,false,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"CONNECTION",0,(x1+(x2/2))-97,y1-2,CORNER_LEFT_UPPER,"ü","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"",false);
//--
   LabelCreate(0,OBJPREFIX+"THEME",0,(x1+(x2/2))-72,y1-4,CORNER_LEFT_UPPER,"N","Webdings",15,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"PAINT",0,(x1+(x2/2))-48,y1,CORNER_LEFT_UPPER,"$","Wingdings 2",13,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"PLAY",0,(x1+(x2/2))+75,y1-5,CORNER_LEFT_UPPER,"4","Webdings",15,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"CANDLES¦",0,(x1+(x2/2))+97,y1-6,CORNER_LEFT_UPPER,"ß","Webdings",15,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"SOUND",0,(x1+(x2/2))+50,y1-2,CORNER_LEFT_UPPER,"X","Webdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"SOUNDIO",0,(x1+(x2/2))+60,y1-1,CORNER_LEFT_UPPER,"ð","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   EditCreate(0,OBJPREFIX+"SYMBOL¤",0,x1+BUTTON_GAP_X,y1+INDENT_TOP+BUTTON_GAP_X,EDIT_WIDTH,EDIT_HEIGHT,_Symbol,"Trebuchet MS",10,ALIGN_CENTER,false,CORNER_LEFT_UPPER,COLOR_FONT,COLOR_BG,clrDimGray,false,false,true,0);
//--
   LabelCreate(0,OBJPREFIX+"SYMBOL§",0,x1+100,y1+27,CORNER_LEFT_UPPER,"","Wingdings",12,clrLimeGreen,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"SYMBOL%",0,x1+145,y1+27,CORNER_LEFT_UPPER,"","Arial Black",8,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"SPEEDª",0,x1+SPEEDTEXT_GAP_X,y1+SPEEDTEXT_GAP_Y,CORNER_LEFT_UPPER,"","Tahoma",12,clrNONE,0.0,ANCHOR_RIGHT,false,false,true,0);
//--
   LabelCreate(0,OBJPREFIX+"CLOSE¹²³",0,(x1+BUTTON_GAP_X)+37,(y1+INDENT_TOP+BUTTON_GAP_X)+27,CORNER_LEFT_UPPER,CloseArr[CloseMode],"Arial",6,COLOR_FONT,0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"SPREAD",0,x1+90,y1+55,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"SPREAD§",0,x1+110,y1+55,CORNER_LEFT_UPPER,"h","Wingdings",12,COLOR_FONT,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   RectLabelCreate(0,OBJPREFIX+"ASK[]",0,x1+155,y1+41,85,15,COLOR_ASK_REC,BORDER_FLAT,CORNER_LEFT_UPPER,COLOR_ASK_REC,STYLE_SOLID,1,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"ASK",0,x1+180,y1+49,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT2,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   RectLabelCreate(0,OBJPREFIX+"BID[]",0,x1+125,y1+56,85,15,COLOR_BID_REC,BORDER_FLAT,CORNER_LEFT_UPPER,COLOR_BID_REC,STYLE_SOLID,1,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"BID",0,x1+180,y1+63,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT2,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"UPTICKS",0,x1+225,y1+49,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT2,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"DWNTICKS",0,x1+140,y1+63,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT2,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"UP»",0,x1+141,y1+47,CORNER_LEFT_UPPER,"6","Webdings",12,COLOR_SELL,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"DN»",0,x1+225,y1+63,CORNER_LEFT_UPPER,"5","Webdings",12,COLOR_BUY,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"TIMER",0,x1+10,y1+65,CORNER_LEFT_UPPER,"","Tahoma",7,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"FLOATª",0,x1+BUTTON_GAP_X+5,inputs_y-15,CORNER_LEFT_UPPER,"","Wingdings",15,clrNONE,0,ANCHOR_LEFT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"FLOAT§",0,x1+BUTTON_GAP_X+45,inputs_y-15,CORNER_LEFT_UPPER,"","Arial",9,clrNONE,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"FLOAT$",0,x1+BUTTON_GAP_X+120,inputs_y-15,CORNER_LEFT_UPPER,"","Arial",9,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"PROFITS",0,x1+BUTTON_GAP_X+190,inputs_y-15,CORNER_LEFT_UPPER,"","Arial",9,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"POINTS",0,x1+BUTTON_GAP_X+235,inputs_y-15,CORNER_LEFT_UPPER,"","Arial",9,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"ROIª",0,x1+BUTTON_GAP_X+5,inputs_y-15,CORNER_LEFT_UPPER,"Today","Arial",9,clrNONE,0,ANCHOR_LEFT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"ROI§",0,x1+BUTTON_GAP_X+45,inputs_y-15,CORNER_LEFT_UPPER,"P","Wingdings",15,clrNONE,0,ANCHOR_LEFT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"ROI%",0,x1+BUTTON_GAP_X+120,inputs_y-15,CORNER_LEFT_UPPER,"","Arial",9,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   EditCreate(0,OBJPREFIX+"SL<>",0,x1+BUTTON_GAP_X,inputs_y,EDIT_WIDTH,EDIT_HEIGHT,DoubleToString(StopLossInp,0),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"SLª",0,x1+BUTTON_GAP_X+EDIT_GAP_Y,label_y,CORNER_LEFT_UPPER,"sl","Arial",10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   EditCreate(0,OBJPREFIX+"LOTSIZE<>",0,x1+BUTTON_GAP_X+BUTTON_WIDTH+BUTTON_GAP_X,inputs_y,EDIT_WIDTH,EDIT_HEIGHT,DoubleToString(LotSizeInp,2),"Tahoma",10,ALIGN_CENTER,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"LOTSIZE<",0,(x1+BUTTON_GAP_X+EDIT_GAP_Y)+75,label_y,CORNER_LEFT_UPPER,"6","Webdings",10,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"LOTSIZE>",0,(x1+BUTTON_GAP_X+EDIT_GAP_Y)+130,label_y,CORNER_LEFT_UPPER,"5","Webdings",10,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//--
   EditCreate(0,OBJPREFIX+"TP<>",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3),inputs_y,EDIT_WIDTH,EDIT_HEIGHT,DoubleToString(TakeProfitInp,0),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"TPª",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+EDIT_GAP_Y,label_y,CORNER_LEFT_UPPER,"tp","Arial",10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   ButtonCreate(0,OBJPREFIX+"SELL",0,x1+BUTTON_GAP_X,button_y,BUTTON_WIDTH,BUTTON_HEIGHT,CORNER_LEFT_UPPER,"Sell","Trebuchet MS",10,C'59,41,40',C'255,128,128',C'239,112,112',false,false,false,true,1,"\n");
//--
   ButtonCreate(0,OBJPREFIX+"CLOSE",0,x1+BUTTON_WIDTH+(BUTTON_GAP_X*2),button_y,BUTTON_WIDTH,BUTTON_HEIGHT,CORNER_LEFT_UPPER,"Close","Trebuchet MS",10,C'59,41,40',C'255,255,160',C'239,239,144',false,false,false,true,1,"\n");
//--
   ButtonCreate(0,OBJPREFIX+"BUY",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3),button_y,BUTTON_WIDTH,BUTTON_HEIGHT,CORNER_LEFT_UPPER,"Buy","Trebuchet MS",10,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");

//-- CreateSpeedBars
   for(int i=0; i<MaxSpeedBars; i++)
     {
      LabelCreate(0,OBJPREFIX+"SPEED#"+IntegerToString(i),0,fr_x,y1+SPEEDBAR_GAP_Y,CORNER_LEFT_UPPER,"l","Arial Black",15,clrNONE,0.0,ANCHOR_RIGHT,false,false,true,0);
      fr_x-=5;
     }

//-- Strategy Tester (Cannot change symbol)
   if(IsTesting())
     {
      if(ObjectFind(0,OBJPREFIX+"SYMBOL¤")==0)//ObjectIsPresent
        {
         if(!ObjectGetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_READONLY))//GetObject
            ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_READONLY,true);//SetObject
        }
     }
//--
  }
//+------------------------------------------------------------------+
//| MoveObjects                                                      |
//+------------------------------------------------------------------+
void ObjectsMoveAll()
  {
//--
   RectLabelMove(0,OBJPREFIX+"BORDER[]",x1,y1);
//--
   LabelMove(0,OBJPREFIX+"CAPTION",(x1+(x2/2)),y1);
//--
   LabelMove(0,OBJPREFIX+"EXIT",(x1+(x2/2))+115,y1-2);
//--
   ButtonMove(0,OBJPREFIX+"MOVE",x1,y1);
//--
   LabelMove(0,OBJPREFIX+"CONNECTION",(x1+(x2/2))-97,y1-2);
//--
   LabelMove(0,OBJPREFIX+"THEME",(x1+(x2/2))-72,y1-4);
//--
   LabelMove(0,OBJPREFIX+"PAINT",(x1+(x2/2))-48,y1);
//--
   LabelMove(0,OBJPREFIX+"PLAY",(x1+(x2/2))+75,y1-5);
//--
   LabelMove(0,OBJPREFIX+"CANDLES¦",(x1+(x2/2))+97,y1-6);
//--
   LabelMove(0,OBJPREFIX+"SOUND",(x1+(x2/2))+50,y1-2);
//--
   LabelMove(0,OBJPREFIX+"SOUNDIO",(x1+(x2/2))+60,y1-1);
//--
   EditMove(0,OBJPREFIX+"SYMBOL¤",x1+BUTTON_GAP_X,y1+INDENT_TOP+BUTTON_GAP_X);
//--
   LabelMove(0,OBJPREFIX+"SYMBOL§",x1+100,y1+27);
//--
   LabelMove(0,OBJPREFIX+"SYMBOL%",x1+145,y1+27);
//--   
   LabelMove(0,OBJPREFIX+"SPEEDª",x1+SPEEDTEXT_GAP_X,y1+SPEEDTEXT_GAP_Y);
//--
   LabelMove(0,OBJPREFIX+"CLOSE¹²³",(x1+BUTTON_GAP_X)+37,(y1+INDENT_TOP+BUTTON_GAP_X)+27);
//--
   LabelMove(0,OBJPREFIX+"SPREAD",x1+90,y1+55);
//--
   LabelMove(0,OBJPREFIX+"SPREAD§",x1+110,y1+55);
//--
   RectLabelMove(0,OBJPREFIX+"ASK[]",x1+155,y1+41);
//--
   LabelMove(0,OBJPREFIX+"ASK",x1+180,y1+49);
//--
   RectLabelMove(0,OBJPREFIX+"BID[]",x1+125,y1+56);
//--
   LabelMove(0,OBJPREFIX+"BID",x1+180,y1+63);
//--
   LabelMove(0,OBJPREFIX+"UPTICKS",x1+225,y1+49);
//--
   LabelMove(0,OBJPREFIX+"DWNTICKS",x1+140,y1+63);
//--
   LabelMove(0,OBJPREFIX+"UP»",x1+141,y1+47);
//--
   LabelMove(0,OBJPREFIX+"DN»",x1+225,y1+63);
//--
   LabelMove(0,OBJPREFIX+"TIMER",x1+10,y1+65);
//--
   LabelMove(0,OBJPREFIX+"FLOATª",x1+BUTTON_GAP_X+5,inputs_y-15);
//--
   LabelMove(0,OBJPREFIX+"FLOAT§",x1+BUTTON_GAP_X+45,inputs_y-15);
//--
   LabelMove(0,OBJPREFIX+"FLOAT$",x1+BUTTON_GAP_X+120,inputs_y-15);
//--
   LabelMove(0,OBJPREFIX+"PROFITS",x1+BUTTON_GAP_X+190,inputs_y-15);
//--
   LabelMove(0,OBJPREFIX+"POINTS",x1+BUTTON_GAP_X+235,inputs_y-15);
//--
   LabelMove(0,OBJPREFIX+"ROIª",x1+BUTTON_GAP_X+5,inputs_y-15);
//--
   LabelMove(0,OBJPREFIX+"ROI§",x1+BUTTON_GAP_X+45,inputs_y-15);
//--
   LabelMove(0,OBJPREFIX+"ROI%",x1+BUTTON_GAP_X+120,inputs_y-15);
//--
   EditMove(0,OBJPREFIX+"SL<>",x1+BUTTON_GAP_X,inputs_y);
//--
   LabelMove(0,OBJPREFIX+"SLª",x1+BUTTON_GAP_X+EDIT_GAP_Y,label_y);
//--
   EditMove(0,OBJPREFIX+"LOTSIZE<>",x1+BUTTON_WIDTH+(BUTTON_GAP_X*2),inputs_y);
//--
   LabelMove(0,OBJPREFIX+"LOTSIZE<",(x1+BUTTON_GAP_X+EDIT_GAP_Y)+75,label_y);
//--
   LabelMove(0,OBJPREFIX+"LOTSIZE>",(x1+BUTTON_GAP_X+EDIT_GAP_Y)+130,label_y);
//--
   EditMove(0,OBJPREFIX+"TP<>",x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3),inputs_y);
//--
   LabelMove(0,OBJPREFIX+"TPª",x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+EDIT_GAP_Y,label_y);
//--
   ButtonMove(0,OBJPREFIX+"SELL",x1+BUTTON_GAP_X,button_y);
//--
   ButtonMove(0,OBJPREFIX+"CLOSE",x1+BUTTON_WIDTH+(BUTTON_GAP_X*2),button_y);
//--
   ButtonMove(0,OBJPREFIX+"BUY",x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3),button_y);

//-- MoveSpeedBars
   for(int i=0; i<MaxSpeedBars; i++)
     {
      LabelMove(0,OBJPREFIX+"SPEED#"+IntegerToString(i),fr_x,y1+SPEEDBAR_GAP_Y);
      fr_x-=5;
     }
//--
  }
//+------------------------------------------------------------------+
//| CheckObjects                                                     |
//+------------------------------------------------------------------+
void ObjectsCheckAll()
  {
//-- CreateObjects
   ObjectsCreateAll();/*User may have deleted one*/

//+------- TrackSomeObjects -------+

//-- IsSelectable
   if(ObjectFind(0,OBJPREFIX+"MOVE")==0 && ObjectFind(0,OBJPREFIX+"BCKGRND[]")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE))//GetObject
        {
         if(!ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED))//GetObject
            ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED,true);//SetObject
        }
      //-- IsNotSelectable
      else
        {
         if(!ObjectGetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE))//GetObject
            ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED,false);//SetObject
        }
     }

//-- IsConnected
   if(ObjectFind(0,OBJPREFIX+"CONNECTION")==0)//ObjectIsPresent
     {
      if(TerminalInfoInteger(TERMINAL_CONNECTED))
        {
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT)!="ü")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT,"ü");//SetObject
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP)!="Connected")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP,"Connected");//SetObject
        }
      //-- IsDisconnected
      else
        {
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT)!="ñ")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT,"ñ");//SetObject
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP)!="No connection!")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP,"No connection!");//SetObject
        }
     }

//-- SoundIsEnabled
   if(ObjectFind(0,OBJPREFIX+"SOUNDIO")==0)//ObjectIsPresent
     {
      if(SoundIsEnabled)
        {
         if(ObjectGetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR)!=C'59,41,40')//GetObject
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,C'59,41,40');//SetObject
        }
      //-- SoundIsDisabled
      else
        {
         if(ObjectGetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR)!=clrNONE)//GetObject
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,clrNONE);//SetObject
        }
     }

//-- TickSoundsAreEnabled
   if(ObjectFind(0,OBJPREFIX+"PLAY")==0)//ObjectIsPresent
     {
      if(PlayTicks)
        {
         if(ObjectGetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT)!=";")//GetObject
            ObjectSetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT,";");//SetObject
         if(ObjectGetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE)!=14)//GetObject
            ObjectSetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE,14);//SetObject
        }
      //-- TickSoundsAreDisabled
      else
        {
         if(ObjectGetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT)!="4")//GetObject
            ObjectSetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT,"4");//SetObject
         if(ObjectGetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE)!=15)//GetObject
            ObjectSetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE,15);//SetObject
        }
     }

//+--------------------------------+
//--
  }
//+------------------------------------------------------------------+
//| SetColors                                                        |
//+------------------------------------------------------------------+
void SetColors(const int Type)
  {
//--
   if(Type==LIGHT)
     {
      //-- Light
      COLOR_BG=C'240,240,240';
      COLOR_FONT=C'40,41,59';
      COLOR_FONT2=COLOR_FONT;
      COLOR_MOVE=clrDarkGray;
      COLOR_GREEN=clrForestGreen;
      COLOR_RED=clrIndianRed;
      COLOR_HEDGE=clrDarkOrange;
      COLOR_ASK_REC=C'255,228,255';
      COLOR_BID_REC=C'215,228,255';
     }
   else
     {
      //-- Dark
      COLOR_BG=C'28,28,28';
      COLOR_FONT=clrDarkGray;
      COLOR_FONT2=COLOR_BG;
      COLOR_MOVE=clrDimGray;
      COLOR_GREEN=clrLimeGreen;
      COLOR_RED=clrRed;
      COLOR_HEDGE=clrGold;
      COLOR_ASK_REC=COLOR_SELL;
      COLOR_BID_REC=COLOR_BUY;
     }
//--
  }
//+------------------------------------------------------------------+
//| SetTheme                                                         |
//+------------------------------------------------------------------+
void SetTheme(const int Type)
  {
//--
   if(Type==LIGHT)
     {
      //-- Light
      COLOR_BG=C'240,240,240';
      COLOR_FONT=C'40,41,59';
      COLOR_MOVE=clrDarkGray;
      COLOR_GREEN=clrForestGreen;
      COLOR_RED=clrIndianRed;
      COLOR_HEDGE=clrDarkOrange;
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_BGCOLOR,COLOR_MOVE);
      ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_BGCOLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_BGCOLOR,COLOR_MOVE);
      ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"CLOSE¹²³",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_BGCOLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"ASK[]",OBJPROP_BGCOLOR,C'255,228,255');
      ObjectSetInteger(0,OBJPREFIX+"ASK[]",OBJPROP_COLOR,C'255,228,255');
      ObjectSetInteger(0,OBJPREFIX+"ASK",OBJPROP_COLOR,COLOR_FONT);
      ObjectSetInteger(0,OBJPREFIX+"UPTICKS",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"BID[]",OBJPROP_BGCOLOR,C'215,228,255');
      ObjectSetInteger(0,OBJPREFIX+"BID[]",OBJPROP_COLOR,C'215,228,255');
      ObjectSetInteger(0,OBJPREFIX+"BID",OBJPROP_COLOR,COLOR_FONT);
      ObjectSetInteger(0,OBJPREFIX+"DWNTICKS",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"SPREAD§",OBJPROP_COLOR,COLOR_FONT);
      ObjectSetInteger(0,OBJPREFIX+"SPREAD",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"TIMER",OBJPROP_COLOR,COLOR_FONT);
      //-- StoreSelectedTheme
      SelectedTheme=LIGHT;
     }
   else
     {
      //-- Dark
      COLOR_BG=C'28,28,28';
      COLOR_FONT=clrDarkGray;
      COLOR_MOVE=clrDimGray;
      COLOR_GREEN=clrLimeGreen;
      COLOR_RED=clrRed;
      COLOR_HEDGE=clrGold;
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_BGCOLOR,COLOR_MOVE);
      ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_BGCOLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_BGCOLOR,COLOR_MOVE);
      ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"CLOSE¹²³",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_BGCOLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"ASK[]",OBJPROP_BGCOLOR,COLOR_SELL);
      ObjectSetInteger(0,OBJPREFIX+"ASK[]",OBJPROP_COLOR,COLOR_SELL);
      ObjectSetInteger(0,OBJPREFIX+"ASK",OBJPROP_COLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"UPTICKS",OBJPROP_COLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"BID[]",OBJPROP_BGCOLOR,COLOR_BUY);
      ObjectSetInteger(0,OBJPREFIX+"BID[]",OBJPROP_COLOR,COLOR_BUY);
      ObjectSetInteger(0,OBJPREFIX+"BID",OBJPROP_COLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"DWNTICKS",OBJPROP_COLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"SPREAD§",OBJPROP_COLOR,COLOR_FONT);
      ObjectSetInteger(0,OBJPREFIX+"SPREAD",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"TIMER",OBJPROP_COLOR,COLOR_FONT);
      //-- StoreSelectedTheme
      SelectedTheme=DARK;
     }
//--
  }
//+------------------------------------------------------------------+
//| ResetTicks                                                       |
//+------------------------------------------------------------------+
bool ResetTicks()
  {
//--
   static datetime lastbar=0;
//--
   if(lastbar!=Time[0])
     {
      //-- ResetTicks
      UpTicks=0;
      DwnTicks=0;
      //-- StoreBarTime
      lastbar=Time[0];
      return(true);
     }
   else
     {
      return(false);
     }
//--
  }
//+------------------------------------------------------------------+
//| ±Str                                                             |
//+------------------------------------------------------------------+
string ±Str(double Inp,int Precision)
  {
//-- PositiveValue
   if(Inp>0)
     {
      return("+"+DoubleToString(Inp,Precision));
     }
//-- NegativeValue
   else
     {
      return(DoubleToString(Inp,Precision));
     }
//--
  }
//+------------------------------------------------------------------+
//| ±Clr                                                             |
//+------------------------------------------------------------------+
color ±Clr(double Inp)
  {
//--
   color clr=clrNONE;
//-- PositiveValue
   if(Inp>0)
     {
      clr=COLOR_GREEN;
     }
//-- NegativeValue
   if(Inp<0)
     {
      clr=COLOR_RED;
     }
//-- NeutralValue
   if(Inp==0)
     {
      clr=COLOR_FONT;
     }
//--
   return(clr);
//--
  }
//+------------------------------------------------------------------+
//| SymbolFind                                                       |
//+------------------------------------------------------------------+
bool SymbolFind(const string _Symb)
  {
//--
   bool result=false;
//--
   for(int i=0; i<SymbolsTotal(false); i++)
     {
      if(_Symb==SymbolName(i,false))
        {
         result=true;//SymbolFound
         break;
        }
     }
   return(result);
  }
//+------------------------------------------------------------------+
//| DrawOrdHistory                                                   |
//+------------------------------------------------------------------+
void DrawOrdHistory()
  {
//--
   string obj_name="",ordtype="",ticket="",openprice="",closeprice="",ordlots="",stoploss="",takeprofit="";
//--
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               //-- SetColor&OrdType
               if(OrderType()==OP_SELL){COLOR_ARROW=COLOR_SELL;ordtype="sell";}//SellOrders
               else{COLOR_ARROW=COLOR_BUY;ordtype="buy";}/*BuyOrders*/
               //-- ConvertToString
               ticket=IntegerToString(OrderTicket());//GetTicket
               openprice=DoubleToString(OrderOpenPrice(),_Digits);//GetOpenPrice
               closeprice=DoubleToString(OrderClosePrice(),_Digits);//GetClosePrice
               ordlots=DoubleToString(OrderLots(),2);/*GetOrderLots*/
               //-- OrderLine
               obj_name="#"+ticket+" "+openprice+" -> "+closeprice;//SetName
               TrendCreate(0,obj_name,0,OrderOpenTime(),OrderOpenPrice(),OrderCloseTime(),OrderClosePrice(),COLOR_ARROW,STYLE_DOT,1,false,false,false,0);
               //-- OpenArrow
               obj_name="#"+ticket+" "+ordtype+" "+ordlots+" "+_Symbol+" at "+openprice;//SetName
               ArrowCreate(0,obj_name,0,OrderOpenTime(),OrderOpenPrice(),1,ANCHOR_BOTTOM,COLOR_ARROW,STYLE_SOLID,1,false,false,false,0);
               //-- CloseArrow
               obj_name+=" close at "+closeprice;//SetName
               ArrowCreate(0,obj_name,0,OrderCloseTime(),OrderClosePrice(),3,ANCHOR_BOTTOM,COLOR_CLOSE,STYLE_SOLID,1,false,false,false,0);
               //-- StopLossArrow
               if(OrderStopLoss()>0)
                 {
                  stoploss=DoubleToString(OrderStopLoss(),_Digits);//GetStopLoss
                  obj_name="#"+ticket+" "+ordtype+" "+ordlots+" "+_Symbol+" at "+openprice+" sl at "+stoploss;//SetName
                  ArrowCreate(0,obj_name,0,OrderOpenTime(),OrderStopLoss(),4,ANCHOR_BOTTOM,COLOR_SELL,STYLE_SOLID,1,false,false,false,0);
                 }
               //-- TakeProfitArrow
               if(OrderTakeProfit()>0)
                 {
                  takeprofit=DoubleToString(OrderTakeProfit(),_Digits);//GetTakeProfit
                  obj_name="#"+ticket+" "+ordtype+" "+ordlots+" "+_Symbol+" at "+openprice+" tp at "+takeprofit;//SetName
                  ArrowCreate(0,obj_name,0,OrderOpenTime(),OrderTakeProfit(),4,ANCHOR_BOTTOM,COLOR_BUY,STYLE_SOLID,1,false,false,false,0);
                 }
               //--
              }
           }
        }
     }
//--
  }
//+------------------------------------------------------------------+
//| Create rectangle label                                           |
//+------------------------------------------------------------------+
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              x=0,                      // X coordinate
                     const int              y=0,                      // Y coordinate
                     const int              width=50,                 // width
                     const int              height=18,                // height
                     const color            back_clr=C'236,233,216',  // background color
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color            clr=clrRed,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=true,              // hidden in the object list
                     const long             z_order=0,                // priority for mouse click 
                     const string           tooltip="\n")             // tooltip for mouse hover
  {
//--- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create a rectangle label! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Move rectangle label                                             |
//+------------------------------------------------------------------+
bool RectLabelMove(const long   chart_ID=0,       // chart's ID
                   const string name="RectLabel", // label name
                   const int    x=0,              // X coordinate
                   const int    y=0)              // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)==0)
     {
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
        {
         Print(__FUNCTION__,
               ": failed to move X coordinate of the label! Error code = ",_LastError);
         return(false);
        }
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
        {
         Print(__FUNCTION__,
               ": failed to move Y coordinate of the label! Error code = ",_LastError);
         return(false);
        }
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create the button                                                | 
//+------------------------------------------------------------------+ 
bool ButtonCreate(const long              chart_ID=0,               // chart's ID 
                  const string            name="Button",            // button name 
                  const int               sub_window=0,             // subwindow index 
                  const int               x=0,                      // X coordinate 
                  const int               y=0,                      // Y coordinate 
                  const int               width=50,                 // button width 
                  const int               height=18,                // button height 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                  const string            text="Button",            // text 
                  const string            font="Arial",             // font 
                  const int               font_size=10,             // font size 
                  const color             clr=clrBlack,             // text color 
                  const color             back_clr=C'236,233,216',  // background color 
                  const color             border_clr=clrNONE,       // border color 
                  const bool              state=false,              // pressed/released 
                  const bool              back=false,               // in the background 
                  const bool              selection=false,          // highlight to move 
                  const bool              hidden=true,              // hidden in the object list 
                  const long              z_order=0,                // priority for mouse click 
                  const string            tooltip="\n")             // tooltip for mouse hover
  {
//-- reset the error value 
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create the button! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the button                                                  |
//+------------------------------------------------------------------+
bool ButtonMove(const long   chart_ID=0,    // chart's ID
                const string name="Button", // button name
                const int    x=0,           // X coordinate
                const int    y=0)           // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)==0)
     {
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
        {
         Print(__FUNCTION__,
               ": failed to move X coordinate of the button! Error code = ",_LastError);
         return(false);
        }
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
        {
         Print(__FUNCTION__,
               ": failed to move Y coordinate of the button! Error code = ",_LastError);
         return(false);
        }
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create a text label                                              | 
//+------------------------------------------------------------------+ 
bool LabelCreate(const long              chart_ID=0,               // chart's ID 
                 const string            name="Label",             // label name 
                 const int               sub_window=0,             // subwindow index 
                 const int               x=0,                      // X coordinate 
                 const int               y=0,                      // Y coordinate 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                 const string            text="Label",             // text 
                 const string            font="Arial",             // font 
                 const int               font_size=10,             // font size 
                 const color             clr=clrRed,               // color 
                 const double            angle=0.0,                // text slope 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                 const bool              back=false,               // in the background 
                 const bool              selection=false,          // highlight to move 
                 const bool              hidden=true,              // hidden in the object list 
                 const long              z_order=0,                // priority for mouse click 
                 const string            tooltip="\n",             // tooltip for mouse hover
                 const bool              tester=true)              // create object in the strategy tester
  {
//-- reset the error value 
   ResetLastError();
//-- CheckTester
   if(!tester && IsTesting())
      return(false);
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create text label! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the text label                                              |
//+------------------------------------------------------------------+
bool LabelMove(const long   chart_ID=0,   // chart's ID
               const string name="Label", // label name
               const int    x=0,          // X coordinate
               const int    y=0)          // Y coordinate
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)==0)
     {
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
        {
         Print(__FUNCTION__,
               ": failed to move X coordinate of the label! Error code = ",_LastError);
         return(false);
        }
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
        {
         Print(__FUNCTION__,
               ": failed to move Y coordinate of the label! Error code = ",_LastError);
         return(false);
        }
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Create Edit object                                               |
//+------------------------------------------------------------------+
bool EditCreate(const long             chart_ID=0,               // chart's ID
                const string           name="Edit",              // object name
                const int              sub_window=0,             // subwindow index
                const int              x=0,                      // X coordinate
                const int              y=0,                      // Y coordinate
                const int              width=50,                 // width
                const int              height=18,                // height
                const string           text="Text",              // text
                const string           font="Arial",             // font
                const int              font_size=10,             // font size
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type
                const bool             read_only=false,          // ability to edit
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                const color            clr=clrBlack,             // text color
                const color            back_clr=clrWhite,        // background color
                const color            border_clr=clrNONE,       // border color
                const bool             back=false,               // in the background
                const bool             selection=false,          // highlight to move
                const bool             hidden=true,              // hidden in the object list
                const long             z_order=0,                // priority for mouse click 
                const string           tooltip="\n")             // tooltip for mouse hover
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create \"Edit\" object! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
      ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Move Edit object                                                 |
//+------------------------------------------------------------------+
bool EditMove(const long   chart_ID=0,  // chart's ID
              const string name="Edit", // object name
              const int    x=0,         // X coordinate
              const int    y=0)         // Y coordinate
  {

//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)==0)
     {
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
        {
         Print(__FUNCTION__,
               ": failed to move X coordinate of the object! Error code = ",_LastError);
         return(false);
        }
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
        {
         Print(__FUNCTION__,
               ": failed to move Y coordinate of the object! Error code = ",_LastError);
         return(false);
        }
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Creating Text object                                             | 
//+------------------------------------------------------------------+ 
bool TextCreate(const long              chart_ID=0,               // chart's ID 
                const string            name="Text",              // object name 
                const int               sub_window=0,             // subwindow index 
                datetime                time=0,                   // anchor point time 
                double                  price=0,                  // anchor point price 
                const string            text="Text",              // the text itself 
                const string            font="Arial",             // font 
                const int               font_size=10,             // font size 
                const color             clr=clrRed,               // color 
                const double            angle=0.0,                // text slope 
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                const bool              back=false,               // in the background 
                const bool              selection=false,          // highlight to move 
                const bool              hidden=true,              // hidden in the object list 
                const long              z_order=0,                // priority for mouse click 
                const string            tooltip="\n")             // tooltip for mouse hover
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
        {
         Print(__FUNCTION__,
               ": failed to create \"Text\" object! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create the arrow                                                 | 
//+------------------------------------------------------------------+ 
bool ArrowCreate(const long              chart_ID=0,           // chart's ID 
                 const string            name="Arrow",         // arrow name 
                 const int               sub_window=0,         // subwindow index 
                 datetime                time=0,               // anchor point time 
                 double                  price=0,              // anchor point price 
                 const uchar             arrow_code=252,       // arrow code 
                 const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // anchor point position 
                 const color             clr=clrRed,           // arrow color 
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style 
                 const int               width=3,              // arrow size 
                 const bool              back=false,           // in the background 
                 const bool              selection=true,       // highlight to move 
                 const bool              hidden=true,          // hidden in the object list 
                 const long              z_order=0)            // priority for mouse click 
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
        {
         Print(__FUNCTION__,
               ": failed to create an arrow! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create a trend line by the given coordinates                     | 
//+------------------------------------------------------------------+ 
bool TrendCreate(const long            chart_ID=0,        // chart's ID 
                 const string          name="TrendLine",  // line name 
                 const int             sub_window=0,      // subwindow index 
                 datetime              time1=0,           // first point time 
                 double                price1=0,          // first point price 
                 datetime              time2=0,           // second point time 
                 double                price2=0,          // second point price 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=false,        // in the background 
                 const bool            selection=true,    // highlight to move 
                 const bool            ray_right=false,   // line's continuation to the right 
                 const bool            hidden=true,       // hidden in the object list 
                 const long            z_order=0)         // priority for mouse click 
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
        {
         Print(__FUNCTION__,
               ": failed to create a trend line! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------------------+ 
//| ChartEventMouseMoveSet                                                       | 
//+------------------------------------------------------------------------------+ 
bool ChartEventMouseMoveSet(const bool value)
  {
//-- reset the error value 
   ResetLastError();
//--
   if(!ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,0,value))
     {
      Print(__FUNCTION__,
            ", Error Code = ",_LastError);
      return(false);
     }
//--
   return(true);
  }
//+--------------------------------------------------------------------+ 
//| ChartMouseScrollSet                                                | 
//+--------------------------------------------------------------------+ 
bool ChartMouseScrollSet(const bool value)
  {
//-- reset the error value 
   ResetLastError();
//--
   if(!ChartSetInteger(0,CHART_MOUSE_SCROLL,0,value))
     {
      Print(__FUNCTION__,
            ", Error Code = ",_LastError);
      return(false);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| ChartMiddleX                                                     |
//+------------------------------------------------------------------+
int ChartMiddleX()
  {
   return((int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| ChartMiddleY                                                     |
//+------------------------------------------------------------------+
int ChartMiddleY()
  {
   return((int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| RandomColor                                                      |
//+------------------------------------------------------------------+
color RandomColor()
  {
//--
   int p1=0+255*MathRand()/32768;
   int p2=0+255*MathRand()/32768;
   int p3=0+255*MathRand()/32768;
//--
   return(StringToColor(IntegerToString(p1)+","+IntegerToString(p2)+","+IntegerToString(p3)));
  }
//+------------------------------------------------------------------+ 
//| PlaySound                                                        | 
//+------------------------------------------------------------------+ 
void _PlaySound(const string FileName)
  {
   if(SoundIsEnabled)
      PlaySound(FileName);
  }
//+------------------------------------------------------------------+
//| AccountCurrency                                                  |
//+------------------------------------------------------------------+
string _AccountCurrency()
  {
//--
   string txt="";
   if(AccountCurrency()=="AUD")txt="$";
   if(AccountCurrency()=="CAD")txt="$";
   if(AccountCurrency()=="CHF")txt="Fr.";
   if(AccountCurrency()=="EUR")txt="€";
   if(AccountCurrency()=="GBP")txt="£";
   if(AccountCurrency()=="JPY")txt="¥";
   if(AccountCurrency()=="NZD")txt="$";
   if(AccountCurrency()=="USD")txt="$";
   if(txt=="")txt="$";
   return(txt);
//--
  }
//+------------------------------------------------------------------+ 
//| Resources                                                        | 
//+------------------------------------------------------------------+ 
#resource "\\Files\\TradePanel\\sound.wav"
#resource "\\Files\\TradePanel\\error.wav"
#resource "\\Files\\TradePanel\\switch.wav"
#resource "\\Files\\TradePanel\\sell.wav"
#resource "\\Files\\TradePanel\\buy.wav"
#resource "\\Files\\TradePanel\\close.wav"
//--
#resource "\\Files\\TradePanel\\Tick+1.wav"
#resource "\\Files\\TradePanel\\Tick+2.wav"
#resource "\\Files\\TradePanel\\Tick+3.wav"
#resource "\\Files\\TradePanel\\Tick+4.wav"
#resource "\\Files\\TradePanel\\Tick+5.wav"
#resource "\\Files\\TradePanel\\Tick+6.wav"
#resource "\\Files\\TradePanel\\Tick+7.wav"
#resource "\\Files\\TradePanel\\Tick+8.wav"
#resource "\\Files\\TradePanel\\Tick+9.wav"
#resource "\\Files\\TradePanel\\Tick+10.wav"
//--
#resource "\\Files\\TradePanel\\Tick-1.wav"
#resource "\\Files\\TradePanel\\Tick-2.wav"
#resource "\\Files\\TradePanel\\Tick-3.wav"
#resource "\\Files\\TradePanel\\Tick-4.wav"
#resource "\\Files\\TradePanel\\Tick-5.wav"
#resource "\\Files\\TradePanel\\Tick-6.wav"
#resource "\\Files\\TradePanel\\Tick-7.wav"
#resource "\\Files\\TradePanel\\Tick-8.wav"
#resource "\\Files\\TradePanel\\Tick-9.wav"
#resource "\\Files\\TradePanel\\Tick-10.wav"
//+------------------------------------------------------------------+ 
//| End of the code                                                  | 
//+------------------------------------------------------------------+ 

/*********************************************************************/
/*                      PANEL Function - END                        */
/*********************************************************************/


/*********************************************************************/
/*                      NEWS Function - END                        */
/*********************************************************************/

//+------------------------------------------------------------------+
//////////////////////////////////////////////////////////////////////////////////
// Download CBOE page source code in a text variable
// And returns the result
//////////////////////////////////////////////////////////////////////////////////
string ReadCBOE()
  {

   string cookie=NULL,headers;
   char post[],result[];     string TXT="";
   int res;
//--- to work with the server, you must add the URL "https://www.google.com/finance"  
//--- the list of allowed URL (Main menu-> Tools-> Settings tab "Advisors"): 
   string google_url="http://ec.forexprostools.com/?columns=exc_currency,exc_importance&importance=1,2,3&calType=week&timeZone=15&lang=1";
//--- 
   ResetLastError();
//--- download html-pages
   int timeout=5000; //--- timeout less than 1,000 (1 sec.) is insufficient at a low speed of the Internet
   res=WebRequest("GET",google_url,cookie,NULL,timeout,post,0,result,headers);
//--- error checking
   if(res==-1)
     {
      Print("WebRequest error, err.code  =",GetLastError());
      MessageBox("You must add the address ' "+google_url+"' in the list of allowed URL tab 'Advisors' "," Error ",MB_ICONINFORMATION);
      //--- You must add the address ' "+ google url"' in the list of allowed URL tab 'Advisors' "," Error "
     }
   else
     {
      //--- successful download
      //PrintFormat("File successfully downloaded, the file size in bytes  =%d.",ArraySize(result)); 
      //--- save the data in the file
      int filehandle=FileOpen("news-log.html",FILE_WRITE|FILE_BIN);
      if(filehandle!=INVALID_HANDLE)
        {
         //---save the contents of the array result [] in file 
         FileWriteArray(filehandle,result,0,ArraySize(result));
         //--- close file 
         FileClose(filehandle);

         int filehandle2=FileOpen("news-log.html",FILE_READ|FILE_BIN);
         TXT=FileReadString(filehandle2,ArraySize(result));
         FileClose(filehandle2);
        }else{
         Print("Error in FileOpen. Error code =",GetLastError());
        }
     }

   return(TXT);
  }
//+------------------------------------------------------------------+
datetime TimeNewsFunck(int nomf)
  {
   string s=NewsArr[0][nomf];
   string time=StringConcatenate(StringSubstr(s,0,4),".",StringSubstr(s,5,2),".",StringSubstr(s,8,2)," ",StringSubstr(s,11,2),":",StringSubstr(s,14,4));
   return((datetime)(StringToTime(time) + GMT*3600));
  }
//////////////////////////////////////////////////////////////////////////////////
void UpdateNews()
  {
   string TEXT=ReadCBOE();
   int sh = StringFind(TEXT,"pageStartAt>")+12;
   int sh2= StringFind(TEXT,"</tbody>");
   TEXT=StringSubstr(TEXT,sh,sh2-sh);

   sh=0;
   while(!IsStopped())
     {
      sh = StringFind(TEXT,"event_timestamp",sh)+17;
      sh2= StringFind(TEXT,"onclick",sh)-2;
      if(sh<17 || sh2<0)break;
      NewsArr[0][NomNews]=StringSubstr(TEXT,sh,sh2-sh);

      sh = StringFind(TEXT,"flagCur",sh)+10;
      sh2= sh+3;
      if(sh<10 || sh2<3)break;
      NewsArr[1][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      if(StringFind(str1,NewsArr[1][NomNews])<0)continue;

      sh = StringFind(TEXT,"title",sh)+7;
      sh2= StringFind(TEXT,"Volatility",sh)-1;
      if(sh<7 || sh2<0)break;
      NewsArr[2][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      if(StringFind(NewsArr[2][NomNews],"High")>=0 && !Vhigh)continue;
      if(StringFind(NewsArr[2][NomNews],"Moderate")>=0 && !Vmedium)continue;
      if(StringFind(NewsArr[2][NomNews],"Low")>=0 && !Vlow)continue;

      sh=StringFind(TEXT,"left event",sh)+12;
      int sh1=StringFind(TEXT,"Speaks",sh);
      sh2=StringFind(TEXT,"<",sh);
      if(sh<12 || sh2<0)break;
      if(sh1<0 || sh1>sh2)NewsArr[3][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      else NewsArr[3][NomNews]=StringSubstr(TEXT,sh,sh1-sh);

      NomNews++;
      if(NomNews==300)break;
     }
  }
//+------------------------------------------------------------------+

double NewCheck_Function(bool TradeNew)
{
   double CheckNews=0;
   if(AfterNewsStop>0)
     {
      if(TimeCurrent()-LastUpd>=Upd){Comment("News Loading...");Print("News Loading...");UpdateNews();LastUpd=TimeCurrent();Comment("");}
      WindowRedraw();
      //---Draw a line on the chart news--------------------------------------------
      if(DrawLines)
        {
         for(int i=0;i<NomNews;i++)
           {
            string Name=StringSubstr(TimeToStr(TimeNewsFunck(i),TIME_MINUTES)+"_"+NewsArr[1][i]+"_"+NewsArr[3][i],0,63);
            if(NewsArr[3][i]!="")if(ObjectFind(Name)==0)continue;
            if(StringFind(str1,NewsArr[1][i])<0)continue;
            if(TimeNewsFunck(i)<TimeCurrent() && Next)continue;

            color clrf = clrNONE;
            if(Vhigh && StringFind(NewsArr[2][i],"High")>=0)clrf=highc;
            if(Vmedium && StringFind(NewsArr[2][i],"Moderate")>=0)clrf=mediumc;
            if(Vlow && StringFind(NewsArr[2][i],"Low")>=0)clrf=lowc;

            if(clrf==clrNONE)continue;

            if(NewsArr[3][i]!="")
              {
               ObjectCreate(Name,0,OBJ_VLINE,TimeNewsFunck(i),0);
               ObjectSet(Name,OBJPROP_COLOR,clrf);
               ObjectSet(Name,OBJPROP_STYLE,Style);
               ObjectSet(Name,OBJPROP_STYLE,2);
               ObjectSetInteger(0,Name,OBJPROP_BACK,true);
              }
           }
        }
      //---------------event Processing------------------------------------
      int i;
      CheckNews=0;
      for(i=0;i<NomNews;i++)
        {
         int power=0;
         if(Vhigh && StringFind(NewsArr[2][i],"High")>=0)power=1;
         if(Vmedium && StringFind(NewsArr[2][i],"Moderate")>=0)power=2;
         if(Vlow && StringFind(NewsArr[2][i],"Low")>=0)power=3;
         if(power==0)continue;
         if(TimeCurrent()+MinBefore*60>TimeNewsFunck(i) && TimeCurrent()-MinAfter*60<TimeNewsFunck(i) && StringFind(str1,NewsArr[1][i])>=0)
           {
            CheckNews=1;
            break;
           }
         else CheckNews=0;

        }
      if(CheckNews==1 && i!=Now && Signal) { Alert("In ",(int)(TimeNewsFunck(i)-TimeCurrent())/60," minutes released news ",NewsArr[1][i],"_",NewsArr[3][i]);Now=i;}
     }

   if(CheckNews>0)
     {
      /////  We are doing here if we are in the framework of the news
      Comment("News time");

     }else{
      // We are out of scope of the news release (No News)
      Comment("No news");

     }
     
     return CheckNews;
}

void CloseOrderInNews_Function()
{
   int index = 0;
   switch(ClosePositiveOrderInNews_Use)
   {
      case DontUse_Close:
      {
         break;
      }
      case CloseAll_Order:
      {
         AutoCloseAllOrder_Function();
         break;
      }
      case ClosePositive_Order:
      {
          for(index=0; index<OrdersTotal(); index++)
          {
              OrderSelect(index, SELECT_BY_POS, MODE_TRADES);
              if(OrderProfit() > CloseTargetProfit)
              {
                  OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);           
              }
              else
              {
               /* Do nothing */
              }
          }
          break;       
      }
      case CloseNegative_Order:
      {
          for(index=0; index<OrdersTotal(); index++)
          {
              OrderSelect(index, SELECT_BY_POS, MODE_TRADES);
              if(OrderProfit() < 0.0)
              {
                  OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);           
              }
              else
              {
               /* Do nothing */
              }
          } 
          break;       
      }
   }
}

//////////////////////////////////////////////////////////////////////////////
void AlreadyBuy_Reset(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_Buy_EURCAD = false;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_Buy_CADCHF = false;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_Buy_AUDUSD = false;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_Buy_GBPCHF = false;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_Buy_NZDCHF = false;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_Buy_USDCAD = false;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_Buy_AUDCHF = false;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_Buy_NZDJPY = false;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_Buy_CADJPY = false;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_Buy_GBPUSD = false;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_Buy_GBPCAD = false;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_Buy_AUDJPY = false;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_Buy_EURAUD = false;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_Buy_GBPJPY = false;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_Buy_NZDCAD = false;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_Buy_EURJPY = false;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_Buy_USDCHF = false;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_Buy_EURCHF = false;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_Buy_EURGBP = false;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_Buy_NZDUSD = false;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_Buy_CHFJPY = false;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_Buy_AUDCAD = false;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_Buy_AUDNZD = false;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_Buy_USDJPY = false;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_Buy_GBPAUD = false;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_Buy_EURUSD = false;
   }
}

void AlreadySell_Reset(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_Sell_EURCAD = false;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_Sell_CADCHF = false;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_Sell_AUDUSD = false;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_Sell_GBPCHF = false;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_Sell_NZDCHF = false;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_Sell_USDCAD = false;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_Sell_AUDCHF = false;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_Sell_NZDJPY = false;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_Sell_CADJPY = false;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_Sell_GBPUSD = false;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_Sell_GBPCAD = false;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_Sell_AUDJPY = false;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_Sell_EURAUD = false;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_Sell_GBPJPY = false;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_Sell_NZDCAD = false;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_Sell_EURJPY = false;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_Sell_USDCHF = false;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_Sell_EURCHF = false;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_Sell_EURGBP = false;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_Sell_NZDUSD = false;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_Sell_CHFJPY = false;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_Sell_AUDCAD = false;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_Sell_AUDNZD = false;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_Sell_USDJPY = false;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_Sell_GBPAUD = false;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_Sell_EURUSD = false;
   }
}

void AlreadyBuy_Set(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_Buy_EURCAD = true;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_Buy_CADCHF = true;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_Buy_AUDUSD = true;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_Buy_GBPCHF = true;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_Buy_NZDCHF = true;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_Buy_USDCAD = true;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_Buy_AUDCHF = true;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_Buy_NZDJPY = true;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_Buy_CADJPY = true;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_Buy_GBPUSD = true;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_Buy_GBPCAD = true;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_Buy_AUDJPY = true;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_Buy_EURAUD = true;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_Buy_GBPJPY = true;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_Buy_NZDCAD = true;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_Buy_EURJPY = true;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_Buy_USDCHF = true;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_Buy_EURCHF = true;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_Buy_EURGBP = true;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_Buy_NZDUSD = true;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_Buy_CHFJPY = true;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_Buy_AUDCAD = true;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_Buy_AUDNZD = true;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_Buy_USDJPY = true;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_Buy_GBPAUD = true;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_Buy_EURUSD = true;
   }
}

void AlreadySell_Set(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_Sell_EURCAD = true;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_Sell_CADCHF = true;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_Sell_AUDUSD = true;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_Sell_GBPCHF = true;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_Sell_NZDCHF = true;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_Sell_USDCAD = true;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_Sell_AUDCHF = true;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_Sell_NZDJPY = true;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_Sell_CADJPY = true;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_Sell_GBPUSD = true;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_Sell_GBPCAD = true;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_Sell_AUDJPY = true;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_Sell_EURAUD = true;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_Sell_GBPJPY = true;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_Sell_NZDCAD = true;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_Sell_EURJPY = true;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_Sell_USDCHF = true;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_Sell_EURCHF = true;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_Sell_EURGBP = true;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_Sell_NZDUSD = true;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_Sell_CHFJPY = true;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_Sell_AUDCAD = true;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_Sell_AUDNZD = true;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_Sell_USDJPY = true;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_Sell_GBPAUD = true;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_Sell_EURUSD = true;
   }
}

bool AlreadyBuy_Check(string argSymbol)
{
  /* Set Return_Check is false */
   bool Return_Check = false;
   if(argSymbol == Symbol_EURCAD && Already_Buy_EURCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADCHF && Already_Buy_CADCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDUSD && Already_Buy_AUDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCHF && Already_Buy_GBPCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCHF && Already_Buy_NZDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDCAD && Already_Buy_USDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCHF && Already_Buy_AUDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDJPY && Already_Buy_NZDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADJPY && Already_Buy_CADJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPUSD && Already_Buy_GBPUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCAD && Already_Buy_GBPCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDJPY && Already_Buy_AUDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURAUD && Already_Buy_EURAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPJPY && Already_Buy_GBPJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCAD && Already_Buy_NZDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURJPY && Already_Buy_EURJPY == true)
   {  
      Return_Check = true;
   }
   if(argSymbol == Symbol_USDCHF && Already_Buy_USDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURCHF && Already_Buy_EURCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURGBP && Already_Buy_EURGBP == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDUSD && Already_Buy_NZDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CHFJPY && Already_Buy_CHFJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCAD && Already_Buy_AUDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDNZD && Already_Buy_AUDNZD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDJPY && Already_Buy_USDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPAUD && Already_Buy_GBPAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURUSD && Already_Buy_EURUSD == true)
   {  
       Return_Check = true;
   }
   
   return Return_Check;  
}

bool AlreadySell_Check(string argSymbol)
{
  /* Set Return_Check is false */
   bool Return_Check = false;   
   if(argSymbol == Symbol_EURCAD && Already_Sell_EURCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADCHF && Already_Sell_CADCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDUSD && Already_Sell_AUDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCHF && Already_Sell_GBPCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCHF && Already_Sell_NZDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDCAD && Already_Sell_USDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCHF && Already_Sell_AUDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDJPY && Already_Sell_NZDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADJPY && Already_Sell_CADJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPUSD && Already_Sell_GBPUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCAD && Already_Sell_GBPCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDJPY && Already_Sell_AUDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURAUD && Already_Sell_EURAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPJPY && Already_Sell_GBPJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCAD && Already_Sell_NZDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURJPY && Already_Sell_EURJPY == true)
   {  
      Return_Check = true;
   }
   if(argSymbol == Symbol_USDCHF && Already_Sell_USDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURCHF && Already_Sell_EURCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURGBP && Already_Sell_EURGBP == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDUSD && Already_Sell_NZDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CHFJPY && Already_Sell_CHFJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCAD && Already_Sell_AUDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDNZD && Already_Sell_AUDNZD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDJPY && Already_Sell_USDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPAUD && Already_Sell_GBPAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURUSD && Already_Sell_EURUSD == true)
   {  
       Return_Check = true;
   }
   
   return Return_Check; 
   
}

TradeStrategy_en StrategyCheck_Function(string argSymbol)
{
  TradeStrategy_en returnValue;
   if(argSymbol == Symbol_EURCAD)
   {  
      returnValue =  TradeStrategy_EURCAD;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
      returnValue =  TradeStrategy_CADCHF;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
      returnValue =  TradeStrategy_AUDUSD;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
      returnValue =  TradeStrategy_GBPCHF;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
      returnValue =  TradeStrategy_NZDCHF;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
      returnValue =  TradeStrategy_USDCAD;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
      returnValue =  TradeStrategy_AUDCHF;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
      returnValue =  TradeStrategy_NZDJPY;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
      returnValue =  TradeStrategy_CADJPY;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
      returnValue =  TradeStrategy_GBPUSD;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
      returnValue =  TradeStrategy_GBPCAD;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
      returnValue =  TradeStrategy_AUDJPY;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
      returnValue =  TradeStrategy_EURAUD;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
      returnValue =  TradeStrategy_GBPJPY;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
      returnValue =  TradeStrategy_NZDCAD;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
      returnValue =  TradeStrategy_EURJPY;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
      returnValue =  TradeStrategy_USDCHF;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
      returnValue =  TradeStrategy_EURCHF;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
      returnValue =  TradeStrategy_EURGBP;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
      returnValue =  TradeStrategy_NZDUSD;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
      returnValue =  TradeStrategy_CHFJPY;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
      returnValue =  TradeStrategy_AUDCAD;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
      returnValue =  TradeStrategy_AUDNZD;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
      returnValue =  TradeStrategy_USDJPY;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
      returnValue =  TradeStrategy_GBPAUD;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
      returnValue =  TradeStrategy_EURUSD;
   }

   return returnValue;  
}

void AlreadyAboveMiddle_Set(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_AboveMiddle_EURCAD = true;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_AboveMiddle_CADCHF = true;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_AboveMiddle_AUDUSD = true;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_AboveMiddle_GBPCHF = true;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_AboveMiddle_NZDCHF = true;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_AboveMiddle_USDCAD = true;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_AboveMiddle_AUDCHF = true;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_AboveMiddle_NZDJPY = true;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_AboveMiddle_CADJPY = true;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_AboveMiddle_GBPUSD = true;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_AboveMiddle_GBPCAD = true;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_AboveMiddle_AUDJPY = true;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_AboveMiddle_EURAUD = true;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_AboveMiddle_GBPJPY = true;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_AboveMiddle_NZDCAD = true;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_AboveMiddle_EURJPY = true;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_AboveMiddle_USDCHF = true;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_AboveMiddle_EURCHF = true;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_AboveMiddle_EURGBP = true;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_AboveMiddle_NZDUSD = true;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_AboveMiddle_CHFJPY = true;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_AboveMiddle_AUDCAD = true;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_AboveMiddle_AUDNZD = true;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_AboveMiddle_USDJPY = true;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_AboveMiddle_GBPAUD = true;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_AboveMiddle_EURUSD = true;
   }
}

void AlreadyBelowMiddle_Set(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_BelowMiddle_EURCAD = true;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_BelowMiddle_CADCHF = true;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_BelowMiddle_AUDUSD = true;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_BelowMiddle_GBPCHF = true;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_BelowMiddle_NZDCHF = true;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_BelowMiddle_USDCAD = true;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_BelowMiddle_AUDCHF = true;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_BelowMiddle_NZDJPY = true;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_BelowMiddle_CADJPY = true;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_BelowMiddle_GBPUSD = true;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_BelowMiddle_GBPCAD = true;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_BelowMiddle_AUDJPY = true;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_BelowMiddle_EURAUD = true;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_BelowMiddle_GBPJPY = true;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_BelowMiddle_NZDCAD = true;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_BelowMiddle_EURJPY = true;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_BelowMiddle_USDCHF = true;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_BelowMiddle_EURCHF = true;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_BelowMiddle_EURGBP = true;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_BelowMiddle_NZDUSD = true;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_BelowMiddle_CHFJPY = true;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_BelowMiddle_AUDCAD = true;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_BelowMiddle_AUDNZD = true;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_BelowMiddle_USDJPY = true;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_BelowMiddle_GBPAUD = true;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_BelowMiddle_EURUSD = true;
   }
}

bool AlreadyBelowMiddle_Check(string argSymbol)
{
  /* Set Return_Check is false */
   bool Return_Check = false;   
   if(argSymbol == Symbol_EURCAD && Already_BelowMiddle_EURCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADCHF && Already_BelowMiddle_CADCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDUSD && Already_BelowMiddle_AUDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCHF && Already_BelowMiddle_GBPCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCHF && Already_BelowMiddle_NZDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDCAD && Already_BelowMiddle_USDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCHF && Already_BelowMiddle_AUDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDJPY && Already_BelowMiddle_NZDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADJPY && Already_BelowMiddle_CADJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPUSD && Already_BelowMiddle_GBPUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCAD && Already_BelowMiddle_GBPCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDJPY && Already_BelowMiddle_AUDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURAUD && Already_BelowMiddle_EURAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPJPY && Already_BelowMiddle_GBPJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCAD && Already_BelowMiddle_NZDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURJPY && Already_BelowMiddle_EURJPY == true)
   {  
      Return_Check = true;
   }
   if(argSymbol == Symbol_USDCHF && Already_BelowMiddle_USDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURCHF && Already_BelowMiddle_EURCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURGBP && Already_BelowMiddle_EURGBP == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDUSD && Already_BelowMiddle_NZDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CHFJPY && Already_BelowMiddle_CHFJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCAD && Already_BelowMiddle_AUDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDNZD && Already_BelowMiddle_AUDNZD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDJPY && Already_BelowMiddle_USDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPAUD && Already_BelowMiddle_GBPAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURUSD && Already_BelowMiddle_EURUSD == true)
   {  
       Return_Check = true;
   }
   
   return Return_Check;   
}

bool AlreadyAboveMiddle_Check(string argSymbol)
{
  /* Set Return_Check is false */
   bool Return_Check = false;   
   if(argSymbol == Symbol_EURCAD && Already_AboveMiddle_EURCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADCHF && Already_AboveMiddle_CADCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDUSD && Already_AboveMiddle_AUDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCHF && Already_AboveMiddle_GBPCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCHF && Already_AboveMiddle_NZDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDCAD && Already_AboveMiddle_USDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCHF && Already_AboveMiddle_AUDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDJPY && Already_AboveMiddle_NZDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADJPY && Already_AboveMiddle_CADJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPUSD && Already_AboveMiddle_GBPUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCAD && Already_AboveMiddle_GBPCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDJPY && Already_AboveMiddle_AUDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURAUD && Already_AboveMiddle_EURAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPJPY && Already_AboveMiddle_GBPJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCAD && Already_AboveMiddle_NZDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURJPY && Already_AboveMiddle_EURJPY == true)
   {  
      Return_Check = true;
   }
   if(argSymbol == Symbol_USDCHF && Already_AboveMiddle_USDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURCHF && Already_AboveMiddle_EURCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURGBP && Already_AboveMiddle_EURGBP == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDUSD && Already_AboveMiddle_NZDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CHFJPY && Already_AboveMiddle_CHFJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCAD && Already_AboveMiddle_AUDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDNZD && Already_AboveMiddle_AUDNZD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDJPY && Already_AboveMiddle_USDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPAUD && Already_AboveMiddle_GBPAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURUSD && Already_AboveMiddle_EURUSD == true)
   {  
       Return_Check = true;
   }
   
   return Return_Check;   
}

void SymbolSetting_Function()
{
   string currentSymbol = Symbol();             
   string Symbol_Result = StringSubstr(currentSymbol, 6, 1);

   if(Symbol_Result == "")
   {
     Symbol_Setting = ABCXYZ;
   }
   else if (Symbol_Result == "m")
   {
     Symbol_Setting = ABCXYZm;
   }
   else if (Symbol_Result == "c")
   {
     Symbol_Setting = ABCXYZc;
   }
   else
   {
     Symbol_Setting = ABCXYZ;
   }

   switch(Symbol_Setting)
   {
      case ABCXYZ:
      {
         Symbol_EURCAD                            = "EURCAD";
         Symbol_CADCHF                            = "CADCHF";
         Symbol_AUDUSD                            = "AUDUSD";
         Symbol_GBPCHF                            = "GBPCHF";
         Symbol_NZDCHF                            = "NZDCHF";
         Symbol_USDCAD                            = "USDCAD";
         Symbol_AUDCHF                            = "AUDCHF";
         Symbol_NZDJPY                            = "NZDJPY";
         Symbol_CADJPY                            = "CADJPY";
         Symbol_GBPUSD                            = "GBPUSD";
         Symbol_GBPCAD                            = "GBPCAD";
         Symbol_AUDJPY                            = "AUDJPY";
         Symbol_EURAUD                            = "EURAUD";
         Symbol_GBPJPY                            = "GBPJPY";
         Symbol_NZDCAD                            = "NZDCAD";
         Symbol_EURJPY                            = "EURJPY";
         Symbol_USDCHF                            = "USDCHF";
         Symbol_EURCHF                            = "EURCHF";
         Symbol_EURGBP                            = "EURGBP";
         Symbol_NZDUSD                            = "NZDUSD";
         Symbol_CHFJPY                            = "CHFJPY";
         Symbol_AUDCAD                            = "AUDCAD";
         Symbol_AUDNZD                            = "AUDNZD";
         Symbol_USDJPY                            = "USDJPY";
         Symbol_GBPAUD                            = "GBPAUD";
         Symbol_EURUSD                            = "EURUSD";
         break;
      }
      case ABCXYZm:
      {
         Symbol_EURCAD                            = "EURCAD";
         Symbol_CADCHF                            = "CADCHF";
         Symbol_AUDUSD                            = "AUDUSD";
         Symbol_GBPCHF                            = "GBPCHF";
         Symbol_NZDCHF                            = "NZDCHF";
         Symbol_USDCAD                            = "USDCAD";
         Symbol_AUDCHF                            = "AUDCHF";
         Symbol_NZDJPY                            = "NZDJPY";
         Symbol_CADJPY                            = "CADJPY";
         Symbol_GBPUSD                            = "GBPUSD";
         Symbol_GBPCAD                            = "GBPCAD";
         Symbol_AUDJPY                            = "AUDJPY";
         Symbol_EURAUD                            = "EURAUD";
         Symbol_GBPJPY                            = "GBPJPY";
         Symbol_NZDCAD                            = "NZDCAD";
         Symbol_EURJPY                            = "EURJPY";
         Symbol_USDCHF                            = "USDCHF";
         Symbol_EURCHF                            = "EURCHF";
         Symbol_EURGBP                            = "EURGBP";
         Symbol_NZDUSD                            = "NZDUSD";
         Symbol_CHFJPY                            = "CHFJPY";
         Symbol_AUDCAD                            = "AUDCAD";
         Symbol_AUDNZD                            = "AUDNZD";
         Symbol_USDJPY                            = "USDJPY";
         Symbol_GBPAUD                            = "GBPAUD";
         Symbol_EURUSD                            = "EURUSD";
         Symbol_EURCAD= StringConcatenate(Symbol_EURCAD, "m");
         Symbol_CADCHF= StringConcatenate(Symbol_CADCHF, "m");
         Symbol_AUDUSD= StringConcatenate(Symbol_AUDUSD, "m");
         Symbol_GBPCHF= StringConcatenate(Symbol_GBPCHF, "m");
         Symbol_NZDCHF= StringConcatenate(Symbol_NZDCHF, "m");
         Symbol_USDCAD= StringConcatenate(Symbol_USDCAD, "m");
         Symbol_AUDCHF= StringConcatenate(Symbol_AUDCHF, "m");
         Symbol_NZDJPY= StringConcatenate(Symbol_NZDJPY, "m");
         Symbol_CADJPY= StringConcatenate(Symbol_CADJPY, "m");
         Symbol_GBPUSD= StringConcatenate(Symbol_GBPUSD, "m");
         Symbol_GBPCAD= StringConcatenate(Symbol_GBPCAD, "m");
         Symbol_AUDJPY= StringConcatenate(Symbol_AUDJPY, "m");
         Symbol_EURAUD= StringConcatenate(Symbol_EURAUD, "m");
         Symbol_GBPJPY= StringConcatenate(Symbol_GBPJPY, "m");
         Symbol_NZDCAD= StringConcatenate(Symbol_NZDCAD, "m");
         Symbol_EURJPY= StringConcatenate(Symbol_EURJPY, "m");
         Symbol_USDCHF= StringConcatenate(Symbol_USDCHF, "m");
         Symbol_EURCHF= StringConcatenate(Symbol_EURCHF, "m");
         Symbol_EURGBP= StringConcatenate(Symbol_EURGBP, "m");
         Symbol_NZDUSD= StringConcatenate(Symbol_NZDUSD, "m");
         Symbol_CHFJPY= StringConcatenate(Symbol_CHFJPY, "m");
         Symbol_AUDCAD= StringConcatenate(Symbol_AUDCAD, "m");
         Symbol_AUDNZD= StringConcatenate(Symbol_AUDNZD, "m");
         Symbol_USDJPY= StringConcatenate(Symbol_USDJPY, "m");
         Symbol_GBPAUD= StringConcatenate(Symbol_GBPAUD, "m");
         Symbol_EURUSD= StringConcatenate(Symbol_EURUSD, "m");   
         break;      
      }
      case ABCXYZc:
      {
         Symbol_EURCAD                            = "EURCAD";
         Symbol_CADCHF                            = "CADCHF";
         Symbol_AUDUSD                            = "AUDUSD";
         Symbol_GBPCHF                            = "GBPCHF";
         Symbol_NZDCHF                            = "NZDCHF";
         Symbol_USDCAD                            = "USDCAD";
         Symbol_AUDCHF                            = "AUDCHF";
         Symbol_NZDJPY                            = "NZDJPY";
         Symbol_CADJPY                            = "CADJPY";
         Symbol_GBPUSD                            = "GBPUSD";
         Symbol_GBPCAD                            = "GBPCAD";
         Symbol_AUDJPY                            = "AUDJPY";
         Symbol_EURAUD                            = "EURAUD";
         Symbol_GBPJPY                            = "GBPJPY";
         Symbol_NZDCAD                            = "NZDCAD";
         Symbol_EURJPY                            = "EURJPY";
         Symbol_USDCHF                            = "USDCHF";
         Symbol_EURCHF                            = "EURCHF";
         Symbol_EURGBP                            = "EURGBP";
         Symbol_NZDUSD                            = "NZDUSD";
         Symbol_CHFJPY                            = "CHFJPY";
         Symbol_AUDCAD                            = "AUDCAD";
         Symbol_AUDNZD                            = "AUDNZD";
         Symbol_USDJPY                            = "USDJPY";
         Symbol_GBPAUD                            = "GBPAUD";
         Symbol_EURUSD                            = "EURUSD";
         Symbol_EURCAD= StringConcatenate(Symbol_EURCAD, "c");
         Symbol_CADCHF= StringConcatenate(Symbol_CADCHF, "c");
         Symbol_AUDUSD= StringConcatenate(Symbol_AUDUSD, "c");
         Symbol_GBPCHF= StringConcatenate(Symbol_GBPCHF, "c");
         Symbol_NZDCHF= StringConcatenate(Symbol_NZDCHF, "c");
         Symbol_USDCAD= StringConcatenate(Symbol_USDCAD, "c");
         Symbol_AUDCHF= StringConcatenate(Symbol_AUDCHF, "c");
         Symbol_NZDJPY= StringConcatenate(Symbol_NZDJPY, "c");
         Symbol_CADJPY= StringConcatenate(Symbol_CADJPY, "c");
         Symbol_GBPUSD= StringConcatenate(Symbol_GBPUSD, "c");
         Symbol_GBPCAD= StringConcatenate(Symbol_GBPCAD, "c");
         Symbol_AUDJPY= StringConcatenate(Symbol_AUDJPY, "c");
         Symbol_EURAUD= StringConcatenate(Symbol_EURAUD, "c");
         Symbol_GBPJPY= StringConcatenate(Symbol_GBPJPY, "c");
         Symbol_NZDCAD= StringConcatenate(Symbol_NZDCAD, "c");
         Symbol_EURJPY= StringConcatenate(Symbol_EURJPY, "c");
         Symbol_USDCHF= StringConcatenate(Symbol_USDCHF, "c");
         Symbol_EURCHF= StringConcatenate(Symbol_EURCHF, "c");
         Symbol_EURGBP= StringConcatenate(Symbol_EURGBP, "c");
         Symbol_NZDUSD= StringConcatenate(Symbol_NZDUSD, "c");
         Symbol_CHFJPY= StringConcatenate(Symbol_CHFJPY, "c");
         Symbol_AUDCAD= StringConcatenate(Symbol_AUDCAD, "c");
         Symbol_AUDNZD= StringConcatenate(Symbol_AUDNZD, "c");
         Symbol_USDJPY= StringConcatenate(Symbol_USDJPY, "c");
         Symbol_GBPAUD= StringConcatenate(Symbol_GBPAUD, "c");
         Symbol_EURUSD= StringConcatenate(Symbol_EURUSD, "c");
         break;
      }
   }
}

double TPValue_Get(string argSymbol)
{
	double TP_return = 0;
   if(argSymbol == Symbol_EURCAD)
   {  
	  switch(TP_EURCAD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_CADCHF)
   {  
	  switch(TP_CADCHF)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
	  switch(TP_AUDUSD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
	  switch(TP_GBPCHF)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
	  switch(TP_NZDCHF)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_USDCAD)
   {  
	  switch(TP_USDCAD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
	  switch(TP_AUDCHF)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
	  switch(TP_NZDJPY)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_CADJPY)
   {  
	  switch(TP_CADJPY)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
	  switch(TP_GBPUSD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
	  switch(TP_GBPCAD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
	  switch(TP_AUDJPY)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURAUD)
   {  
	  switch(TP_EURAUD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
	  switch(TP_GBPJPY)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
	  switch(TP_NZDCAD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURJPY)
   {  
	  switch(TP_EURJPY)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_USDCHF)
   {  
	  switch(TP_USDCHF)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURCHF)
   {  
	  switch(TP_EURCHF)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURGBP)
   {  
	  switch(TP_EURGBP)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
	  switch(TP_NZDUSD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
	  switch(TP_CHFJPY)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
	  switch(TP_AUDCAD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
	  switch(TP_AUDNZD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_USDJPY)
   {  
	  switch(TP_USDJPY)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
	  switch(TP_GBPAUD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURUSD)
   {  
	  switch(TP_EURUSD)
	   {
		 case TP_1:
		 {
			TP_return = TakeProfit_1;
			break;
		 }
		 case TP_2:
		 {
			TP_return = TakeProfit_2;
			break;
		 }
		 case TP_3:
		 {
			TP_return = TakeProfit_3;
			break;
		 }	 
	   }
   }
   return TP_return;
}     

double SLValue_Get(string argSymbol)
{
   double SL_return = 0;
   if(argSymbol == Symbol_EURCAD)
   {  
	  switch(SL_EURCAD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_CADCHF)
   {  
	  switch(SL_CADCHF)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
	  switch(SL_AUDUSD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
	  switch(SL_GBPCHF)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
	  switch(SL_NZDCHF)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_USDCAD)
   {  
	  switch(SL_USDCAD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
	  switch(SL_AUDCHF)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
	  switch(SL_NZDJPY)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_CADJPY)
   {  
	  switch(SL_CADJPY)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
	  switch(SL_GBPUSD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
	  switch(SL_GBPCAD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
	  switch(SL_AUDJPY)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURAUD)
   {  
	  switch(SL_EURAUD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
	  switch(SL_GBPJPY)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
	  switch(SL_NZDCAD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURJPY)
   {  
	  switch(SL_EURJPY)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_USDCHF)
   {  
	  switch(SL_USDCHF)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURCHF)
   {  
	  switch(SL_EURCHF)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURGBP)
   {  
	  switch(SL_EURGBP)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
	  switch(SL_NZDUSD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
	  switch(SL_CHFJPY)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
	  switch(SL_AUDCAD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
	  switch(SL_AUDNZD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_USDJPY)
   {  
	  switch(SL_USDJPY)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
	  switch(SL_GBPAUD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   if(argSymbol == Symbol_EURUSD)
   {  
	  switch(SL_EURUSD)
	   {
		 case SL_1:
		 {
			SL_return = StopLoss_1;
			break;
		 }
		 case SL_2:
		 {
			SL_return = StopLoss_2;
			break;
		 }
		 case SL_3:
		 {
			SL_return = StopLoss_3;
			break;
		 }	 
	   }
   }
   return SL_return;
}     

static bool Already_PendingBuy_EURCAD = false;
static bool Already_PendingBuy_CADCHF = false;
static bool Already_PendingBuy_AUDUSD = false;
static bool Already_PendingBuy_GBPCHF = false;
static bool Already_PendingBuy_NZDCHF = false;
static bool Already_PendingBuy_USDCAD = false;
static bool Already_PendingBuy_AUDCHF = false;
static bool Already_PendingBuy_NZDJPY = false;
static bool Already_PendingBuy_CADJPY = false;
static bool Already_PendingBuy_GBPUSD = false;
static bool Already_PendingBuy_GBPCAD = false;
static bool Already_PendingBuy_AUDJPY = false;
static bool Already_PendingBuy_EURAUD = false;
static bool Already_PendingBuy_GBPJPY = false;
static bool Already_PendingBuy_NZDCAD = false;
static bool Already_PendingBuy_EURJPY = false;
static bool Already_PendingBuy_USDCHF = false;
static bool Already_PendingBuy_EURCHF = false;
static bool Already_PendingBuy_EURGBP = false;
static bool Already_PendingBuy_NZDUSD = false;
static bool Already_PendingBuy_CHFJPY = false;
static bool Already_PendingBuy_AUDCAD = false;
static bool Already_PendingBuy_AUDNZD = false;
static bool Already_PendingBuy_USDJPY = false;
static bool Already_PendingBuy_GBPAUD = false;
static bool Already_PendingBuy_EURUSD = false; 

static bool Already_PendingSell_EURCAD = false;
static bool Already_PendingSell_CADCHF = false;
static bool Already_PendingSell_AUDUSD = false;
static bool Already_PendingSell_GBPCHF = false;
static bool Already_PendingSell_NZDCHF = false;
static bool Already_PendingSell_USDCAD = false;
static bool Already_PendingSell_AUDCHF = false;
static bool Already_PendingSell_NZDJPY = false;
static bool Already_PendingSell_CADJPY = false;
static bool Already_PendingSell_GBPUSD = false;
static bool Already_PendingSell_GBPCAD = false;
static bool Already_PendingSell_AUDJPY = false;
static bool Already_PendingSell_EURAUD = false;
static bool Already_PendingSell_GBPJPY = false;
static bool Already_PendingSell_NZDCAD = false;
static bool Already_PendingSell_EURJPY = false;
static bool Already_PendingSell_USDCHF = false;
static bool Already_PendingSell_EURCHF = false;
static bool Already_PendingSell_EURGBP = false;
static bool Already_PendingSell_NZDUSD = false;
static bool Already_PendingSell_CHFJPY = false;
static bool Already_PendingSell_AUDCAD = false;
static bool Already_PendingSell_AUDNZD = false;
static bool Already_PendingSell_USDJPY = false;
static bool Already_PendingSell_GBPAUD = false;
static bool Already_PendingSell_EURUSD = false;

bool AlreadyPendingSell_Check(string argSymbol)
{
  /* Set Return_Check is false */
   bool Return_Check = false;   
   if(argSymbol == Symbol_EURCAD && Already_PendingSell_EURCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADCHF && Already_PendingSell_CADCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDUSD && Already_PendingSell_AUDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCHF && Already_PendingSell_GBPCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCHF && Already_PendingSell_NZDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDCAD && Already_PendingSell_USDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCHF && Already_PendingSell_AUDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDJPY && Already_PendingSell_NZDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADJPY && Already_PendingSell_CADJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPUSD && Already_PendingSell_GBPUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCAD && Already_PendingSell_GBPCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDJPY && Already_PendingSell_AUDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURAUD && Already_PendingSell_EURAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPJPY && Already_PendingSell_GBPJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCAD && Already_PendingSell_NZDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURJPY && Already_PendingSell_EURJPY == true)
   {  
      Return_Check = true;
   }
   if(argSymbol == Symbol_USDCHF && Already_PendingSell_USDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURCHF && Already_PendingSell_EURCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURGBP && Already_PendingSell_EURGBP == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDUSD && Already_PendingSell_NZDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CHFJPY && Already_PendingSell_CHFJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCAD && Already_PendingSell_AUDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDNZD && Already_PendingSell_AUDNZD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDJPY && Already_PendingSell_USDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPAUD && Already_PendingSell_GBPAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURUSD && Already_PendingSell_EURUSD == true)
   {  
       Return_Check = true;
   }
   
   return Return_Check;   
}


bool AlreadyPendingBuy_Check(string argSymbol)
{
  /* Set Return_Check is false */
   bool Return_Check = false;   
   if(argSymbol == Symbol_EURCAD && Already_PendingBuy_EURCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADCHF && Already_PendingBuy_CADCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDUSD && Already_PendingBuy_AUDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCHF && Already_PendingBuy_GBPCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCHF && Already_PendingBuy_NZDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDCAD && Already_PendingBuy_USDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCHF && Already_PendingBuy_AUDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDJPY && Already_PendingBuy_NZDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADJPY && Already_PendingBuy_CADJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPUSD && Already_PendingBuy_GBPUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCAD && Already_PendingBuy_GBPCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDJPY && Already_PendingBuy_AUDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURAUD && Already_PendingBuy_EURAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPJPY && Already_PendingBuy_GBPJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCAD && Already_PendingBuy_NZDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURJPY && Already_PendingBuy_EURJPY == true)
   {  
      Return_Check = true;
   }
   if(argSymbol == Symbol_USDCHF && Already_PendingBuy_USDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURCHF && Already_PendingBuy_EURCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURGBP && Already_PendingBuy_EURGBP == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDUSD && Already_PendingBuy_NZDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CHFJPY && Already_PendingBuy_CHFJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCAD && Already_PendingBuy_AUDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDNZD && Already_PendingBuy_AUDNZD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDJPY && Already_PendingBuy_USDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPAUD && Already_PendingBuy_GBPAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURUSD && Already_PendingBuy_EURUSD == true)
   {  
       Return_Check = true;
   }
   
   return Return_Check;   
}

void AlreadyPendingBuy_Set(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_PendingBuy_EURCAD = true;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_PendingBuy_CADCHF = true;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_PendingBuy_AUDUSD = true;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_PendingBuy_GBPCHF = true;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_PendingBuy_NZDCHF = true;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_PendingBuy_USDCAD = true;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_PendingBuy_AUDCHF = true;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_PendingBuy_NZDJPY = true;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_PendingBuy_CADJPY = true;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_PendingBuy_GBPUSD = true;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_PendingBuy_GBPCAD = true;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_PendingBuy_AUDJPY = true;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_PendingBuy_EURAUD = true;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_PendingBuy_GBPJPY = true;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_PendingBuy_NZDCAD = true;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_PendingBuy_EURJPY = true;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_PendingBuy_USDCHF = true;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_PendingBuy_EURCHF = true;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_PendingBuy_EURGBP = true;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_PendingBuy_NZDUSD = true;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_PendingBuy_CHFJPY = true;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_PendingBuy_AUDCAD = true;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_PendingBuy_AUDNZD = true;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_PendingBuy_USDJPY = true;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_PendingBuy_GBPAUD = true;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_PendingBuy_EURUSD = true;
   }
}

void AlreadyPendingSell_Set(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_PendingSell_EURCAD = true;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_PendingSell_CADCHF = true;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_PendingSell_AUDUSD = true;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_PendingSell_GBPCHF = true;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_PendingSell_NZDCHF = true;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_PendingSell_USDCAD = true;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_PendingSell_AUDCHF = true;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_PendingSell_NZDJPY = true;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_PendingSell_CADJPY = true;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_PendingSell_GBPUSD = true;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_PendingSell_GBPCAD = true;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_PendingSell_AUDJPY = true;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_PendingSell_EURAUD = true;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_PendingSell_GBPJPY = true;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_PendingSell_NZDCAD = true;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_PendingSell_EURJPY = true;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_PendingSell_USDCHF = true;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_PendingSell_EURCHF = true;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_PendingSell_EURGBP = true;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_PendingSell_NZDUSD = true;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_PendingSell_CHFJPY = true;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_PendingSell_AUDCAD = true;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_PendingSell_AUDNZD = true;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_PendingSell_USDJPY = true;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_PendingSell_GBPAUD = true;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_PendingSell_EURUSD = true;
   }
}

void AlreadyPendingSell_ReSet(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_PendingSell_EURCAD = false;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_PendingSell_CADCHF = false;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_PendingSell_AUDUSD = false;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_PendingSell_GBPCHF = false;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_PendingSell_NZDCHF = false;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_PendingSell_USDCAD = false;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_PendingSell_AUDCHF = false;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_PendingSell_NZDJPY = false;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_PendingSell_CADJPY = false;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_PendingSell_GBPUSD = false;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_PendingSell_GBPCAD = false;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_PendingSell_AUDJPY = false;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_PendingSell_EURAUD = false;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_PendingSell_GBPJPY = false;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_PendingSell_NZDCAD = false;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_PendingSell_EURJPY = false;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_PendingSell_USDCHF = false;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_PendingSell_EURCHF = false;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_PendingSell_EURGBP = false;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_PendingSell_NZDUSD = false;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_PendingSell_CHFJPY = false;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_PendingSell_AUDCAD = false;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_PendingSell_AUDNZD = false;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_PendingSell_USDJPY = false;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_PendingSell_GBPAUD = false;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_PendingSell_EURUSD = false;
   }
}

void AlreadyPendingBuy_ReSet(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       Already_PendingBuy_EURCAD = false;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       Already_PendingBuy_CADCHF = false;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       Already_PendingBuy_AUDUSD = false;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       Already_PendingBuy_GBPCHF = false;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       Already_PendingBuy_NZDCHF = false;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       Already_PendingBuy_USDCAD = false;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       Already_PendingBuy_AUDCHF = false;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       Already_PendingBuy_NZDJPY = false;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       Already_PendingBuy_CADJPY = false;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       Already_PendingBuy_GBPUSD = false;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       Already_PendingBuy_GBPCAD = false;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       Already_PendingBuy_AUDJPY = false;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       Already_PendingBuy_EURAUD = false;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       Already_PendingBuy_GBPJPY = false;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       Already_PendingBuy_NZDCAD = false;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       Already_PendingBuy_EURJPY = false;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       Already_PendingBuy_USDCHF = false;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       Already_PendingBuy_EURCHF = false;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       Already_PendingBuy_EURGBP = false;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       Already_PendingBuy_NZDUSD = false;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       Already_PendingBuy_CHFJPY = false;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       Already_PendingBuy_AUDCAD = false;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       Already_PendingBuy_AUDNZD = false;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       Already_PendingBuy_USDJPY = false;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       Already_PendingBuy_GBPAUD = false;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       Already_PendingBuy_EURUSD = false;
   }
}

static double dPriceHigh_Use_EURCAD;
static double dPriceHigh_Use_CADCHF;
static double dPriceHigh_Use_AUDUSD;
static double dPriceHigh_Use_GBPCHF;
static double dPriceHigh_Use_NZDCHF;
static double dPriceHigh_Use_USDCAD;
static double dPriceHigh_Use_AUDCHF;
static double dPriceHigh_Use_NZDJPY;
static double dPriceHigh_Use_CADJPY;
static double dPriceHigh_Use_GBPUSD;
static double dPriceHigh_Use_GBPCAD;
static double dPriceHigh_Use_AUDJPY;
static double dPriceHigh_Use_EURAUD;
static double dPriceHigh_Use_GBPJPY;
static double dPriceHigh_Use_NZDCAD;
static double dPriceHigh_Use_EURJPY;
static double dPriceHigh_Use_USDCHF;
static double dPriceHigh_Use_EURCHF;
static double dPriceHigh_Use_EURGBP;
static double dPriceHigh_Use_NZDUSD;
static double dPriceHigh_Use_CHFJPY;
static double dPriceHigh_Use_AUDCAD;
static double dPriceHigh_Use_AUDNZD;
static double dPriceHigh_Use_USDJPY;
static double dPriceHigh_Use_GBPAUD;
static double dPriceHigh_Use_EURUSD;

static double dPriceMiddle_Use_EURCAD;
static double dPriceMiddle_Use_CADCHF;
static double dPriceMiddle_Use_AUDUSD;
static double dPriceMiddle_Use_GBPCHF;
static double dPriceMiddle_Use_NZDCHF;
static double dPriceMiddle_Use_USDCAD;
static double dPriceMiddle_Use_AUDCHF;
static double dPriceMiddle_Use_NZDJPY;
static double dPriceMiddle_Use_CADJPY;
static double dPriceMiddle_Use_GBPUSD;
static double dPriceMiddle_Use_GBPCAD;
static double dPriceMiddle_Use_AUDJPY;
static double dPriceMiddle_Use_EURAUD;
static double dPriceMiddle_Use_GBPJPY;
static double dPriceMiddle_Use_NZDCAD;
static double dPriceMiddle_Use_EURJPY;
static double dPriceMiddle_Use_USDCHF;
static double dPriceMiddle_Use_EURCHF;
static double dPriceMiddle_Use_EURGBP;
static double dPriceMiddle_Use_NZDUSD;
static double dPriceMiddle_Use_CHFJPY;
static double dPriceMiddle_Use_AUDCAD;
static double dPriceMiddle_Use_AUDNZD;
static double dPriceMiddle_Use_USDJPY;
static double dPriceMiddle_Use_GBPAUD;
static double dPriceMiddle_Use_EURUSD;

static double dPriceLow_Use_EURCAD;
static double dPriceLow_Use_CADCHF;
static double dPriceLow_Use_AUDUSD;
static double dPriceLow_Use_GBPCHF;
static double dPriceLow_Use_NZDCHF;
static double dPriceLow_Use_USDCAD;
static double dPriceLow_Use_AUDCHF;
static double dPriceLow_Use_NZDJPY;
static double dPriceLow_Use_CADJPY;
static double dPriceLow_Use_GBPUSD;
static double dPriceLow_Use_GBPCAD;
static double dPriceLow_Use_AUDJPY;
static double dPriceLow_Use_EURAUD;
static double dPriceLow_Use_GBPJPY;
static double dPriceLow_Use_NZDCAD;
static double dPriceLow_Use_EURJPY;
static double dPriceLow_Use_USDCHF;
static double dPriceLow_Use_EURCHF;
static double dPriceLow_Use_EURGBP;
static double dPriceLow_Use_NZDUSD;
static double dPriceLow_Use_CHFJPY;
static double dPriceLow_Use_AUDCAD;
static double dPriceLow_Use_AUDNZD;
static double dPriceLow_Use_USDJPY;
static double dPriceLow_Use_GBPAUD;
static double dPriceLow_Use_EURUSD;

static bool Already_Buy_EURCAD = false;
static bool Already_Buy_CADCHF = false;
static bool Already_Buy_AUDUSD = false;
static bool Already_Buy_GBPCHF = false;
static bool Already_Buy_NZDCHF = false;
static bool Already_Buy_USDCAD = false;
static bool Already_Buy_AUDCHF = false;
static bool Already_Buy_NZDJPY = false;
static bool Already_Buy_CADJPY = false;
static bool Already_Buy_GBPUSD = false;
static bool Already_Buy_GBPCAD = false;
static bool Already_Buy_AUDJPY = false;
static bool Already_Buy_EURAUD = false;
static bool Already_Buy_GBPJPY = false;
static bool Already_Buy_NZDCAD = false;
static bool Already_Buy_EURJPY = false;
static bool Already_Buy_USDCHF = false;
static bool Already_Buy_EURCHF = false;
static bool Already_Buy_EURGBP = false;
static bool Already_Buy_NZDUSD = false;
static bool Already_Buy_CHFJPY = false;
static bool Already_Buy_AUDCAD = false;
static bool Already_Buy_AUDNZD = false;
static bool Already_Buy_USDJPY = false;
static bool Already_Buy_GBPAUD = false;
static bool Already_Buy_EURUSD = false;

static bool Already_Sell_EURCAD = false;
static bool Already_Sell_CADCHF = false;
static bool Already_Sell_AUDUSD = false;
static bool Already_Sell_GBPCHF = false;
static bool Already_Sell_NZDCHF = false;
static bool Already_Sell_USDCAD = false;
static bool Already_Sell_AUDCHF = false;
static bool Already_Sell_NZDJPY = false;
static bool Already_Sell_CADJPY = false;
static bool Already_Sell_GBPUSD = false;
static bool Already_Sell_GBPCAD = false;
static bool Already_Sell_AUDJPY = false;
static bool Already_Sell_EURAUD = false;
static bool Already_Sell_GBPJPY = false;
static bool Already_Sell_NZDCAD = false;
static bool Already_Sell_EURJPY = false;
static bool Already_Sell_USDCHF = false;
static bool Already_Sell_EURCHF = false;
static bool Already_Sell_EURGBP = false;
static bool Already_Sell_NZDUSD = false;
static bool Already_Sell_CHFJPY = false;
static bool Already_Sell_AUDCAD = false;
static bool Already_Sell_AUDNZD = false;
static bool Already_Sell_USDJPY = false;
static bool Already_Sell_GBPAUD = false;
static bool Already_Sell_EURUSD = false;

static bool Already_BelowMiddle_EURCAD = false;
static bool Already_BelowMiddle_CADCHF = false;
static bool Already_BelowMiddle_AUDUSD = false;
static bool Already_BelowMiddle_GBPCHF = false;
static bool Already_BelowMiddle_NZDCHF = false;
static bool Already_BelowMiddle_USDCAD = false;
static bool Already_BelowMiddle_AUDCHF = false;
static bool Already_BelowMiddle_NZDJPY = false;
static bool Already_BelowMiddle_CADJPY = false;
static bool Already_BelowMiddle_GBPUSD = false;
static bool Already_BelowMiddle_GBPCAD = false;
static bool Already_BelowMiddle_AUDJPY = false;
static bool Already_BelowMiddle_EURAUD = false;
static bool Already_BelowMiddle_GBPJPY = false;
static bool Already_BelowMiddle_NZDCAD = false;
static bool Already_BelowMiddle_EURJPY = false;
static bool Already_BelowMiddle_USDCHF = false;
static bool Already_BelowMiddle_EURCHF = false;
static bool Already_BelowMiddle_EURGBP = false;
static bool Already_BelowMiddle_NZDUSD = false;
static bool Already_BelowMiddle_CHFJPY = false;
static bool Already_BelowMiddle_AUDCAD = false;
static bool Already_BelowMiddle_AUDNZD = false;
static bool Already_BelowMiddle_USDJPY = false;
static bool Already_BelowMiddle_GBPAUD = false;
static bool Already_BelowMiddle_EURUSD = false;

static bool Already_AboveMiddle_EURCAD = false;
static bool Already_AboveMiddle_CADCHF = false;
static bool Already_AboveMiddle_AUDUSD = false;
static bool Already_AboveMiddle_GBPCHF = false;
static bool Already_AboveMiddle_NZDCHF = false;
static bool Already_AboveMiddle_USDCAD = false;
static bool Already_AboveMiddle_AUDCHF = false;
static bool Already_AboveMiddle_NZDJPY = false;
static bool Already_AboveMiddle_CADJPY = false;
static bool Already_AboveMiddle_GBPUSD = false;
static bool Already_AboveMiddle_GBPCAD = false;
static bool Already_AboveMiddle_AUDJPY = false;
static bool Already_AboveMiddle_EURAUD = false;
static bool Already_AboveMiddle_GBPJPY = false;
static bool Already_AboveMiddle_NZDCAD = false;
static bool Already_AboveMiddle_EURJPY = false;
static bool Already_AboveMiddle_USDCHF = false;
static bool Already_AboveMiddle_EURCHF = false;
static bool Already_AboveMiddle_EURGBP = false;
static bool Already_AboveMiddle_NZDUSD = false;
static bool Already_AboveMiddle_CHFJPY = false;
static bool Already_AboveMiddle_AUDCAD = false;
static bool Already_AboveMiddle_AUDNZD = false;
static bool Already_AboveMiddle_USDJPY = false;
static bool Already_AboveMiddle_GBPAUD = false;
static bool Already_AboveMiddle_EURUSD = false; 

static bool ADXBelow25_EURCAD = true;
static bool ADXBelow25_CADCHF = true;
static bool ADXBelow25_AUDUSD = true;
static bool ADXBelow25_GBPCHF = true;
static bool ADXBelow25_NZDCHF = true;
static bool ADXBelow25_USDCAD = true;
static bool ADXBelow25_AUDCHF = true;
static bool ADXBelow25_NZDJPY = true;
static bool ADXBelow25_CADJPY = true;
static bool ADXBelow25_GBPUSD = true;
static bool ADXBelow25_GBPCAD = true;
static bool ADXBelow25_AUDJPY = true;
static bool ADXBelow25_EURAUD = true;
static bool ADXBelow25_GBPJPY = true;
static bool ADXBelow25_NZDCAD = true;
static bool ADXBelow25_EURJPY = true;
static bool ADXBelow25_USDCHF = true;
static bool ADXBelow25_EURCHF = true;
static bool ADXBelow25_EURGBP = true;
static bool ADXBelow25_NZDUSD = true;
static bool ADXBelow25_CHFJPY = true;
static bool ADXBelow25_AUDCAD = true;
static bool ADXBelow25_AUDNZD = true;
static bool ADXBelow25_USDJPY = true;
static bool ADXBelow25_GBPAUD = true;
static bool ADXBelow25_EURUSD = true;

static string Symbol_EURCAD                            = "EURCAD";
static string Symbol_CADCHF                            = "CADCHF";
static string Symbol_AUDUSD                            = "AUDUSD";
static string Symbol_GBPCHF                            = "GBPCHF";
static string Symbol_NZDCHF                            = "NZDCHF";
static string Symbol_USDCAD                            = "USDCAD";
static string Symbol_AUDCHF                            = "AUDCHF";
static string Symbol_NZDJPY                            = "NZDJPY";
static string Symbol_CADJPY                            = "CADJPY";
static string Symbol_GBPUSD                            = "GBPUSD";
static string Symbol_GBPCAD                            = "GBPCAD";
static string Symbol_AUDJPY                            = "AUDJPY";
static string Symbol_EURAUD                            = "EURAUD";
static string Symbol_GBPJPY                            = "GBPJPY";
static string Symbol_NZDCAD                            = "NZDCAD";
static string Symbol_EURJPY                            = "EURJPY";
static string Symbol_USDCHF                            = "USDCHF";
static string Symbol_EURCHF                            = "EURCHF";
static string Symbol_EURGBP                            = "EURGBP";
static string Symbol_NZDUSD                            = "NZDUSD";
static string Symbol_CHFJPY                            = "CHFJPY";
static string Symbol_AUDCAD                            = "AUDCAD";
static string Symbol_AUDNZD                            = "AUDNZD";
static string Symbol_USDJPY                            = "USDJPY";
static string Symbol_GBPAUD                            = "GBPAUD";
static string Symbol_EURUSD                            = "EURUSD";

static bool TimeCheck_EA                               = false;

void ADXBelow25_Reset(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       ADXBelow25_EURCAD = false;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       ADXBelow25_CADCHF = false;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       ADXBelow25_AUDUSD = false;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       ADXBelow25_GBPCHF = false;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       ADXBelow25_NZDCHF = false;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       ADXBelow25_USDCAD = false;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       ADXBelow25_AUDCHF = false;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       ADXBelow25_NZDJPY = false;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       ADXBelow25_CADJPY = false;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       ADXBelow25_GBPUSD = false;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       ADXBelow25_GBPCAD = false;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       ADXBelow25_AUDJPY = false;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       ADXBelow25_EURAUD = false;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       ADXBelow25_GBPJPY = false;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       ADXBelow25_NZDCAD = false;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       ADXBelow25_EURJPY = false;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       ADXBelow25_USDCHF = false;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       ADXBelow25_EURCHF = false;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       ADXBelow25_EURGBP = false;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       ADXBelow25_NZDUSD = false;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       ADXBelow25_CHFJPY = false;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       ADXBelow25_AUDCAD = false;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       ADXBelow25_AUDNZD = false;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       ADXBelow25_USDJPY = false;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       ADXBelow25_GBPAUD = false;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       ADXBelow25_EURUSD = false;
   }
}

void ADXBelow25_Check(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       ADXBelow25_EURCAD = true;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       ADXBelow25_CADCHF = true;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       ADXBelow25_AUDUSD = true;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       ADXBelow25_GBPCHF = true;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       ADXBelow25_NZDCHF = true;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       ADXBelow25_USDCAD = true;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
       ADXBelow25_AUDCHF = true;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
       ADXBelow25_NZDJPY = true;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       ADXBelow25_CADJPY = true;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       ADXBelow25_GBPUSD = true;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       ADXBelow25_GBPCAD = true;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       ADXBelow25_AUDJPY = true;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       ADXBelow25_EURAUD = true;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       ADXBelow25_GBPJPY = true;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       ADXBelow25_NZDCAD = true;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       ADXBelow25_EURJPY = true;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       ADXBelow25_USDCHF = true;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       ADXBelow25_EURCHF = true;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       ADXBelow25_EURGBP = true;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       ADXBelow25_NZDUSD = true;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       ADXBelow25_CHFJPY = true;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       ADXBelow25_AUDCAD = true;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       ADXBelow25_AUDNZD = true;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       ADXBelow25_USDJPY = true;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       ADXBelow25_GBPAUD = true;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       ADXBelow25_EURUSD = true;
   }
}


bool ADX25_Check(string argSymbol)
{
   bool Return_Check = false;
   if(argSymbol == Symbol_EURCAD && ADXBelow25_EURCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADCHF && ADXBelow25_CADCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDUSD && ADXBelow25_AUDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCHF && ADXBelow25_GBPCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCHF && ADXBelow25_NZDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDCAD && ADXBelow25_USDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCHF && ADXBelow25_AUDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDJPY && ADXBelow25_NZDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CADJPY && ADXBelow25_CADJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPUSD && ADXBelow25_GBPUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPCAD && ADXBelow25_GBPCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDJPY && ADXBelow25_AUDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURAUD && ADXBelow25_EURAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPJPY && ADXBelow25_GBPJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDCAD && ADXBelow25_NZDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURJPY && ADXBelow25_EURJPY == true)
   {  
      Return_Check = true;
   }
   if(argSymbol == Symbol_USDCHF && ADXBelow25_USDCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURCHF && ADXBelow25_EURCHF == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURGBP && ADXBelow25_EURGBP == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_NZDUSD && ADXBelow25_NZDUSD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_CHFJPY && ADXBelow25_CHFJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDCAD && ADXBelow25_AUDCAD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_AUDNZD && ADXBelow25_AUDNZD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_USDJPY && ADXBelow25_USDJPY == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_GBPAUD && ADXBelow25_GBPAUD == true)
   {  
       Return_Check = true;
   }
   if(argSymbol == Symbol_EURUSD && ADXBelow25_EURUSD == true)
   {  
       Return_Check = true;
   }
   
   return Return_Check;
}

double Get_dPriceHigh(string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
       return dPriceHigh_Use_EURCAD;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       return dPriceHigh_Use_CADCHF;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       return dPriceHigh_Use_AUDUSD;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       return dPriceHigh_Use_GBPCHF;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       return dPriceHigh_Use_NZDCHF;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       return dPriceHigh_Use_USDCAD;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
      return dPriceHigh_Use_AUDCHF;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
      return dPriceHigh_Use_NZDJPY;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       return dPriceHigh_Use_CADJPY;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       return dPriceHigh_Use_GBPUSD;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       return dPriceHigh_Use_GBPCAD;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       return dPriceHigh_Use_AUDJPY;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       return dPriceHigh_Use_EURAUD;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       return dPriceHigh_Use_GBPJPY;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       return dPriceHigh_Use_NZDCAD;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       return dPriceHigh_Use_EURJPY;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       return dPriceHigh_Use_USDCHF;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       return dPriceHigh_Use_EURCHF;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       return dPriceHigh_Use_EURGBP;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       return dPriceHigh_Use_NZDUSD;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       return dPriceHigh_Use_CHFJPY;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       return dPriceHigh_Use_AUDCAD;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       return dPriceHigh_Use_AUDNZD;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       return dPriceHigh_Use_USDJPY;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       return dPriceHigh_Use_GBPAUD;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       return dPriceHigh_Use_EURUSD;
   }

   return 0;
}

void Set_dPriceHigh(float dPriceHigh, string argSymbol)
{

   if(argSymbol == Symbol_EURCAD)
   {  
    dPriceHigh_Use_EURCAD = dPriceHigh;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
		dPriceHigh_Use_CADCHF = dPriceHigh;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
		dPriceHigh_Use_AUDUSD = dPriceHigh;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
		dPriceHigh_Use_GBPCHF = dPriceHigh;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
		dPriceHigh_Use_NZDCHF = dPriceHigh;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
		dPriceHigh_Use_USDCAD = dPriceHigh;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
		dPriceHigh_Use_AUDCHF = dPriceHigh;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
		dPriceHigh_Use_NZDJPY = dPriceHigh;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
		dPriceHigh_Use_CADJPY = dPriceHigh;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
    dPriceHigh_Use_GBPUSD = dPriceHigh;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
		dPriceHigh_Use_GBPCAD = dPriceHigh;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
		dPriceHigh_Use_AUDJPY = dPriceHigh;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
		dPriceHigh_Use_EURAUD = dPriceHigh;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
		dPriceHigh_Use_GBPJPY = dPriceHigh;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
		dPriceHigh_Use_NZDCAD = dPriceHigh;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
		dPriceHigh_Use_EURJPY = dPriceHigh;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
		dPriceHigh_Use_USDCHF = dPriceHigh;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
		dPriceHigh_Use_EURCHF = dPriceHigh;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
		dPriceHigh_Use_EURGBP = dPriceHigh;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
		dPriceHigh_Use_NZDUSD = dPriceHigh;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
		dPriceHigh_Use_CHFJPY = dPriceHigh;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
		dPriceHigh_Use_AUDCAD = dPriceHigh;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
		dPriceHigh_Use_AUDNZD = dPriceHigh;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
	dPriceHigh_Use_USDJPY = dPriceHigh;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
		dPriceHigh_Use_GBPAUD = dPriceHigh;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
		dPriceHigh_Use_EURUSD = dPriceHigh;
   }
}

void Set_dPriceMiddle(float dPriceMiddle, string argSymbol)
{

   if(argSymbol == Symbol_EURCAD)
   {  
    dPriceMiddle_Use_EURCAD = dPriceMiddle;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
		dPriceMiddle_Use_CADCHF = dPriceMiddle;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
		dPriceMiddle_Use_AUDUSD = dPriceMiddle;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
		dPriceMiddle_Use_GBPCHF = dPriceMiddle;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
		dPriceMiddle_Use_NZDCHF = dPriceMiddle;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
		dPriceMiddle_Use_USDCAD = dPriceMiddle;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
		dPriceMiddle_Use_AUDCHF = dPriceMiddle;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
		dPriceMiddle_Use_NZDJPY = dPriceMiddle;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
		dPriceMiddle_Use_CADJPY = dPriceMiddle;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
    dPriceMiddle_Use_GBPUSD = dPriceMiddle;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
		dPriceMiddle_Use_GBPCAD = dPriceMiddle;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
		dPriceMiddle_Use_AUDJPY = dPriceMiddle;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
		dPriceMiddle_Use_EURAUD = dPriceMiddle;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
		dPriceMiddle_Use_GBPJPY = dPriceMiddle;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
		dPriceMiddle_Use_NZDCAD = dPriceMiddle;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
		dPriceMiddle_Use_EURJPY = dPriceMiddle;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
		dPriceMiddle_Use_USDCHF = dPriceMiddle;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
		dPriceMiddle_Use_EURCHF = dPriceMiddle;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
		dPriceMiddle_Use_EURGBP = dPriceMiddle;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
		dPriceMiddle_Use_NZDUSD = dPriceMiddle;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
		dPriceMiddle_Use_CHFJPY = dPriceMiddle;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
		dPriceMiddle_Use_AUDCAD = dPriceMiddle;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
		dPriceMiddle_Use_AUDNZD = dPriceMiddle;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
	dPriceMiddle_Use_USDJPY = dPriceMiddle;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
		dPriceMiddle_Use_GBPAUD = dPriceMiddle;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
		dPriceMiddle_Use_EURUSD = dPriceMiddle;
   }
}

double Get_dPriceMiddle(string argSymbol)
{

   if(argSymbol == Symbol_EURCAD)
   {  
       return dPriceMiddle_Use_EURCAD;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       return dPriceMiddle_Use_CADCHF;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       return dPriceMiddle_Use_AUDUSD;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       return dPriceMiddle_Use_GBPCHF;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       return dPriceMiddle_Use_NZDCHF;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       return dPriceMiddle_Use_USDCAD;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
      return dPriceMiddle_Use_AUDCHF;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
      return dPriceMiddle_Use_NZDJPY;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       return dPriceMiddle_Use_CADJPY;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       return dPriceMiddle_Use_GBPUSD;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       return dPriceMiddle_Use_GBPCAD;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       return dPriceMiddle_Use_AUDJPY;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       return dPriceMiddle_Use_EURAUD;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       return dPriceMiddle_Use_GBPJPY;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       return dPriceMiddle_Use_NZDCAD;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       return dPriceMiddle_Use_EURJPY;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       return dPriceMiddle_Use_USDCHF;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       return dPriceMiddle_Use_EURCHF;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       return dPriceMiddle_Use_EURGBP;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       return dPriceMiddle_Use_NZDUSD;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       return dPriceMiddle_Use_CHFJPY;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       return dPriceMiddle_Use_AUDCAD;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       return dPriceMiddle_Use_AUDNZD;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       return dPriceMiddle_Use_USDJPY;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       return dPriceMiddle_Use_GBPAUD;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       return dPriceMiddle_Use_EURUSD;
   }

   return 0;
}

double Get_dPriceLow(string argSymbol)
{

   if(argSymbol == Symbol_EURCAD)
   {  
       return dPriceLow_Use_EURCAD;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       return dPriceLow_Use_CADCHF;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       return dPriceLow_Use_AUDUSD;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       return dPriceLow_Use_GBPCHF;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       return dPriceLow_Use_NZDCHF;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       return dPriceLow_Use_USDCAD;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
      return dPriceLow_Use_AUDCHF;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
      return dPriceLow_Use_NZDJPY;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       return dPriceLow_Use_CADJPY;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       return dPriceLow_Use_GBPUSD;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       return dPriceLow_Use_GBPCAD;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       return dPriceLow_Use_AUDJPY;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       return dPriceLow_Use_EURAUD;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       return dPriceLow_Use_GBPJPY;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       return dPriceLow_Use_NZDCAD;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       return dPriceLow_Use_EURJPY;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       return dPriceLow_Use_USDCHF;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       return dPriceLow_Use_EURCHF;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       return dPriceLow_Use_EURGBP;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       return dPriceLow_Use_NZDUSD;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       return dPriceLow_Use_CHFJPY;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       return dPriceLow_Use_AUDCAD;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       return dPriceLow_Use_AUDNZD;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       return dPriceLow_Use_USDJPY;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       return dPriceLow_Use_GBPAUD;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       return dPriceLow_Use_EURUSD;
   }

   return 0;
}

void Set_dPriceLow(float dPriceLow,string argSymbol)
{

   if(argSymbol == Symbol_EURCAD)
   {  
    dPriceLow_Use_EURCAD = dPriceLow;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
		dPriceLow_Use_CADCHF = dPriceLow;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
		dPriceLow_Use_AUDUSD = dPriceLow;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
		dPriceLow_Use_GBPCHF = dPriceLow;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
		dPriceLow_Use_NZDCHF = dPriceLow;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
		dPriceLow_Use_USDCAD = dPriceLow;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
		dPriceLow_Use_AUDCHF = dPriceLow;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
		dPriceLow_Use_NZDJPY = dPriceLow;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
		dPriceLow_Use_CADJPY = dPriceLow;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
        dPriceLow_Use_GBPUSD = dPriceLow;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
		dPriceLow_Use_GBPCAD = dPriceLow;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
		dPriceLow_Use_AUDJPY = dPriceLow;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
		dPriceLow_Use_EURAUD = dPriceLow;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
		dPriceLow_Use_GBPJPY = dPriceLow;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
		dPriceLow_Use_NZDCAD = dPriceLow;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
		dPriceLow_Use_EURJPY = dPriceLow;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
		dPriceLow_Use_USDCHF = dPriceLow;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
		dPriceLow_Use_EURCHF = dPriceLow;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
		dPriceLow_Use_EURGBP = dPriceLow;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
		dPriceLow_Use_NZDUSD = dPriceLow;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
		dPriceLow_Use_CHFJPY = dPriceLow;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
		dPriceLow_Use_AUDCAD = dPriceLow;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
		dPriceLow_Use_AUDNZD = dPriceLow;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
	dPriceLow_Use_USDJPY = dPriceLow;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
		dPriceLow_Use_GBPAUD = dPriceLow;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
		dPriceLow_Use_EURUSD = dPriceLow;
   }
}

bool SumAllProfit_Check()
{
  bool retValue = false;
  if(CloseTarget_Use == true)
  {
    double SumProfit = SumProfit("OP_ALL") + SumProfitH();
    if(SumProfit > CloseAt_Profit || SumProfit < (-CLoseAt_StopLoss))
    {
      retValue = true;
    }
    else
    {
      retValue = false;
    }
  }
  else
  {
    retValue = false;
  }
  return retValue;
}

double SumProfit(string LoaiLenh)
{
   double sum = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderMagicNumber() == MagicNumber)
         {
            if(LoaiLenh == "OP_BUY" && OrderType() == OP_BUY)
            {
               sum+= OrderProfit()+OrderSwap()+OrderCommission();
            }
            else if(LoaiLenh == "OP_SELL"  && OrderType()  == OP_SELL)
            {
               sum += OrderProfit()+OrderSwap()+OrderCommission();
            }
            else if(LoaiLenh == "OP_ALL")
            {
               sum += OrderProfit()+OrderSwap()+OrderCommission();
            }
            
         }
         else if(OrderMagicNumber() == MagicNumber)
         {
            if(LoaiLenh == "OP_ALL")
            {
               sum += OrderProfit()+OrderSwap()+OrderCommission();
            }
            else if(LoaiLenh == "OP_BUY" && OrderType() == OP_BUY)
            {
               sum+= OrderProfit()+OrderSwap()+OrderCommission();
            }
            else if(LoaiLenh == "OP_SELL"  && OrderType()  == OP_SELL)
            {
               sum += OrderProfit()+OrderSwap()+OrderCommission();
            }
            
         }
  
      }
   } 
   return sum;
}

double SumProfitH()
{
  double result=0;

  datetime today_midnight=TimeCurrent()-(TimeCurrent()%(PERIOD_D1*60));

  for(int i=0;i<OrdersHistoryTotal();i++)
  {
     OrderSelect(i,SELECT_BY_POS ,MODE_HISTORY);
      
      if(OrderMagicNumber() == MagicNumber && OrderCloseTime()>=today_midnight)
         {
           result=result+OrderProfit();
         }
   } 
   return (result);       
}

void Set_PinbarBuy(float PinbarBuy, string argSymbol)
{

   if(argSymbol == Symbol_EURCAD)
   {  
    PinbarBuy_Use_EURCAD = PinbarBuy;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
		PinbarBuy_Use_CADCHF = PinbarBuy;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
		PinbarBuy_Use_AUDUSD = PinbarBuy;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
		PinbarBuy_Use_GBPCHF = PinbarBuy;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
		PinbarBuy_Use_NZDCHF = PinbarBuy;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
		PinbarBuy_Use_USDCAD = PinbarBuy;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
		PinbarBuy_Use_AUDCHF = PinbarBuy;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
		PinbarBuy_Use_NZDJPY = PinbarBuy;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
		PinbarBuy_Use_CADJPY = PinbarBuy;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
    PinbarBuy_Use_GBPUSD = PinbarBuy;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
		PinbarBuy_Use_GBPCAD = PinbarBuy;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
		PinbarBuy_Use_AUDJPY = PinbarBuy;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
		PinbarBuy_Use_EURAUD = PinbarBuy;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
		PinbarBuy_Use_GBPJPY = PinbarBuy;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
		PinbarBuy_Use_NZDCAD = PinbarBuy;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
		PinbarBuy_Use_EURJPY = PinbarBuy;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
		PinbarBuy_Use_USDCHF = PinbarBuy;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
		PinbarBuy_Use_EURCHF = PinbarBuy;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
		PinbarBuy_Use_EURGBP = PinbarBuy;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
		PinbarBuy_Use_NZDUSD = PinbarBuy;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
		PinbarBuy_Use_CHFJPY = PinbarBuy;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
		PinbarBuy_Use_AUDCAD = PinbarBuy;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
		PinbarBuy_Use_AUDNZD = PinbarBuy;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
	PinbarBuy_Use_USDJPY = PinbarBuy;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
		PinbarBuy_Use_GBPAUD = PinbarBuy;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
		PinbarBuy_Use_EURUSD = PinbarBuy;
   }
}

void Set_PinbarSell(float PinbarSell, string argSymbol)
{
   if(argSymbol == Symbol_EURCAD)
   {  
    PinbarSell_Use_EURCAD = PinbarSell;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
		PinbarSell_Use_CADCHF = PinbarSell;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
		PinbarSell_Use_AUDUSD = PinbarSell;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
		PinbarSell_Use_GBPCHF = PinbarSell;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
		PinbarSell_Use_NZDCHF = PinbarSell;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
		PinbarSell_Use_USDCAD = PinbarSell;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
		PinbarSell_Use_AUDCHF = PinbarSell;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
		PinbarSell_Use_NZDJPY = PinbarSell;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
		PinbarSell_Use_CADJPY = PinbarSell;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
    PinbarSell_Use_GBPUSD = PinbarSell;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
		PinbarSell_Use_GBPCAD = PinbarSell;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
		PinbarSell_Use_AUDJPY = PinbarSell;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
		PinbarSell_Use_EURAUD = PinbarSell;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
		PinbarSell_Use_GBPJPY = PinbarSell;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
		PinbarSell_Use_NZDCAD = PinbarSell;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
		PinbarSell_Use_EURJPY = PinbarSell;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
		PinbarSell_Use_USDCHF = PinbarSell;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
		PinbarSell_Use_EURCHF = PinbarSell;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
		PinbarSell_Use_EURGBP = PinbarSell;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
		PinbarSell_Use_NZDUSD = PinbarSell;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
		PinbarSell_Use_CHFJPY = PinbarSell;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
		PinbarSell_Use_AUDCAD = PinbarSell;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
		PinbarSell_Use_AUDNZD = PinbarSell;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
	PinbarSell_Use_USDJPY = PinbarSell;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
		PinbarSell_Use_GBPAUD = PinbarSell;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
		PinbarSell_Use_EURUSD = PinbarSell;
   }
}

double Get_PinbarSell(string argSymbol)
{

   if(argSymbol == Symbol_EURCAD)
   {  
       return PinbarSell_Use_EURCAD;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       return PinbarSell_Use_CADCHF;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       return PinbarSell_Use_AUDUSD;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       return PinbarSell_Use_GBPCHF;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       return PinbarSell_Use_NZDCHF;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       return PinbarSell_Use_USDCAD;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
      return PinbarSell_Use_AUDCHF;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
      return PinbarSell_Use_NZDJPY;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       return PinbarSell_Use_CADJPY;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       return PinbarSell_Use_GBPUSD;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       return PinbarSell_Use_GBPCAD;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       return PinbarSell_Use_AUDJPY;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       return PinbarSell_Use_EURAUD;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       return PinbarSell_Use_GBPJPY;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       return PinbarSell_Use_NZDCAD;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       return PinbarSell_Use_EURJPY;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       return PinbarSell_Use_USDCHF;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       return PinbarSell_Use_EURCHF;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       return PinbarSell_Use_EURGBP;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       return PinbarSell_Use_NZDUSD;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       return PinbarSell_Use_CHFJPY;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       return PinbarSell_Use_AUDCAD;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       return PinbarSell_Use_AUDNZD;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       return PinbarSell_Use_USDJPY;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       return PinbarSell_Use_GBPAUD;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       return PinbarSell_Use_EURUSD;
   }

   return 0;
}

double Get_PinbarBuy(string argSymbol)
{

   if(argSymbol == Symbol_EURCAD)
   {  
       return PinbarBuy_Use_EURCAD;
   }
   if(argSymbol == Symbol_CADCHF)
   {  
       return PinbarBuy_Use_CADCHF;
   }
   if(argSymbol == Symbol_AUDUSD)
   {  
       return PinbarBuy_Use_AUDUSD;
   }
   if(argSymbol == Symbol_GBPCHF)
   {  
       return PinbarBuy_Use_GBPCHF;
   }
   if(argSymbol == Symbol_NZDCHF)
   {  
       return PinbarBuy_Use_NZDCHF;
   }
   if(argSymbol == Symbol_USDCAD)
   {  
       return PinbarBuy_Use_USDCAD;
   }
   if(argSymbol == Symbol_AUDCHF)
   {  
      return PinbarBuy_Use_AUDCHF;
   }
   if(argSymbol == Symbol_NZDJPY)
   {  
      return PinbarBuy_Use_NZDJPY;
   }
   if(argSymbol == Symbol_CADJPY)
   {  
       return PinbarBuy_Use_CADJPY;
   }
   if(argSymbol == Symbol_GBPUSD)
   {  
       return PinbarBuy_Use_GBPUSD;
   }
   if(argSymbol == Symbol_GBPCAD)
   {  
       return PinbarBuy_Use_GBPCAD;
   }
   if(argSymbol == Symbol_AUDJPY)
   {  
       return PinbarBuy_Use_AUDJPY;
   }
   if(argSymbol == Symbol_EURAUD)
   {  
       return PinbarBuy_Use_EURAUD;
   }
   if(argSymbol == Symbol_GBPJPY)
   {  
       return PinbarBuy_Use_GBPJPY;
   }
   if(argSymbol == Symbol_NZDCAD)
   {  
       return PinbarBuy_Use_NZDCAD;
   }
   if(argSymbol == Symbol_EURJPY)
   {  
       return PinbarBuy_Use_EURJPY;
   }
   if(argSymbol == Symbol_USDCHF)
   {  
       return PinbarBuy_Use_USDCHF;
   }
   if(argSymbol == Symbol_EURCHF)
   {  
       return PinbarBuy_Use_EURCHF;
   }
   if(argSymbol == Symbol_EURGBP)
   {  
       return PinbarBuy_Use_EURGBP;
   }
   if(argSymbol == Symbol_NZDUSD)
   {  
       return PinbarBuy_Use_NZDUSD;
   }
   if(argSymbol == Symbol_CHFJPY)
   {  
       return PinbarBuy_Use_CHFJPY;
   }
   if(argSymbol == Symbol_AUDCAD)
   {  
       return PinbarBuy_Use_AUDCAD;
   }
   if(argSymbol == Symbol_AUDNZD)
   {  
       return PinbarBuy_Use_AUDNZD;
   }
   if(argSymbol == Symbol_USDJPY)
   {  
       return PinbarBuy_Use_USDJPY;
   }
   if(argSymbol == Symbol_GBPAUD)
   {  
       return PinbarBuy_Use_GBPAUD;
   }
   if(argSymbol == Symbol_EURUSD)
   {  
       return PinbarBuy_Use_EURUSD;
   }

   return 0;
}

static double PinbarBuy_Use_EURCAD;
static double PinbarBuy_Use_CADCHF;
static double PinbarBuy_Use_AUDUSD;
static double PinbarBuy_Use_GBPCHF;
static double PinbarBuy_Use_NZDCHF;
static double PinbarBuy_Use_USDCAD;
static double PinbarBuy_Use_AUDCHF;
static double PinbarBuy_Use_NZDJPY;
static double PinbarBuy_Use_CADJPY;
static double PinbarBuy_Use_GBPUSD;
static double PinbarBuy_Use_GBPCAD;
static double PinbarBuy_Use_AUDJPY;
static double PinbarBuy_Use_EURAUD;
static double PinbarBuy_Use_GBPJPY;
static double PinbarBuy_Use_NZDCAD;
static double PinbarBuy_Use_EURJPY;
static double PinbarBuy_Use_USDCHF;
static double PinbarBuy_Use_EURCHF;
static double PinbarBuy_Use_EURGBP;
static double PinbarBuy_Use_NZDUSD;
static double PinbarBuy_Use_CHFJPY;
static double PinbarBuy_Use_AUDCAD;
static double PinbarBuy_Use_AUDNZD;
static double PinbarBuy_Use_USDJPY;
static double PinbarBuy_Use_GBPAUD;
static double PinbarBuy_Use_EURUSD;

static double PinbarSell_Use_EURCAD;
static double PinbarSell_Use_CADCHF;
static double PinbarSell_Use_AUDUSD;
static double PinbarSell_Use_GBPCHF;
static double PinbarSell_Use_NZDCHF;
static double PinbarSell_Use_USDCAD;
static double PinbarSell_Use_AUDCHF;
static double PinbarSell_Use_NZDJPY;
static double PinbarSell_Use_CADJPY;
static double PinbarSell_Use_GBPUSD;
static double PinbarSell_Use_GBPCAD;
static double PinbarSell_Use_AUDJPY;
static double PinbarSell_Use_EURAUD;
static double PinbarSell_Use_GBPJPY;
static double PinbarSell_Use_NZDCAD;
static double PinbarSell_Use_EURJPY;
static double PinbarSell_Use_USDCHF;
static double PinbarSell_Use_EURCHF;
static double PinbarSell_Use_EURGBP;
static double PinbarSell_Use_NZDUSD;
static double PinbarSell_Use_CHFJPY;
static double PinbarSell_Use_AUDCAD;
static double PinbarSell_Use_AUDNZD;
static double PinbarSell_Use_USDJPY;
static double PinbarSell_Use_GBPAUD;
static double PinbarSell_Use_EURUSD;

void CloseOrderMagicBox_Function(string argSymbol)
{
    int index = 0;

    for(index=0; index<OrdersTotal(); index++)
    {
        OrderSelect(index, SELECT_BY_POS, MODE_TRADES);
        if(OrderType()<=OP_SELL &&  OrderSymbol()==argSymbol && OrderMagicNumber()==MagicNumber)     
        {
            if(OrderType()==OP_BUY)  
            {
                if(MagicBox_Sell(argSymbol))
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                }
            }
            else
            {
                if(MagicBox_Buy(argSymbol))
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                }
            }
        }        
    }
}


void CloseOrderMagicBoxRevert_Function(string argSymbol)
{
    int index = 0;

    for(index=0; index<OrdersTotal(); index++)
    {
        OrderSelect(index, SELECT_BY_POS, MODE_TRADES);
        if(OrderType()<=OP_SELL &&  OrderSymbol()==argSymbol && OrderMagicNumber()==MagicNumber)     
        {
            if(OrderType()==OP_BUY)  
            {
                if(MagicBox_Buy(argSymbol))
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                }
            }
            else
            {
                if(MagicBox_Sell(argSymbol))
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                }
            }
        }        
    }
}

void GBPUSD_BreakoutFunction(string argSymbol)
{
  double SellStop_StopLoss;
  double SellStop_TakeProfit;
  double BuyStop_TakeProfit;
  double BuyStop_StopLoss;

  if(GBPUSD_DailyBreakout_Use)
  {
    double HighValue;
    double LowValue;

    HighValue = iHigh(argSymbol, PERIOD_D1, 1);
    LowValue  = iLow(argSymbol, PERIOD_D1, 1);

    HighValue = HighValue + Distance_Break*UsePoint;
    LowValue  = LowValue - Distance_Break*UsePoint;

    UsePoint = PipPoint(argSymbol);

    if(GBPUSD_Selection == Option_1)
    {
      SellStop_StopLoss = CalcSellStopLoss(argSymbol, SL_Option1, LowValue);  
      SellStop_TakeProfit   =  CalcSellTakeProfit(argSymbol, TP_Option1 , LowValue);
      BuyStop_TakeProfit   =  CalcBuyTakeProfit(argSymbol, TP_Option1 , HighValue);
      BuyStop_StopLoss = CalcBuyStopLoss(argSymbol, SL_Option1, HighValue);   

      /* Set buy stop order */
      BuyTicket = OpenBuyStopOder(argSymbol, Lot_Option1, HighValue, BuyStop_StopLoss, BuyStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);
      /* Set Sell stop order */
      SellTicket = OpenSellStopOrder(argSymbol, Lot_Option1, LowValue, SellStop_StopLoss, SellStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet); 
    }
    else
    {
      SellStop_StopLoss = CalcSellStopLoss(argSymbol, SL1_Option2, LowValue);  
      SellStop_TakeProfit   =  CalcSellTakeProfit(argSymbol, TP1_Option2 , LowValue);
      BuyStop_TakeProfit   =  CalcBuyTakeProfit(argSymbol, TP1_Option2 , HighValue);
      BuyStop_StopLoss = CalcBuyStopLoss(argSymbol, SL1_Option2, HighValue);   

      /* Set buy stop order */
      BuyTicket = OpenBuyStopOder(argSymbol, Lot1_Option2, HighValue, BuyStop_StopLoss, BuyStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);
      /* Set Sell stop order */
      SellTicket = OpenSellStopOrder(argSymbol, Lot1_Option2, LowValue, SellStop_StopLoss, SellStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);   

      ///////////////////////////////////////////////////////////////////

      SellStop_StopLoss = CalcSellStopLoss(argSymbol, SL2_Option2, LowValue);  
      SellStop_TakeProfit   =  CalcSellTakeProfit(argSymbol, TP2_Option2 , LowValue);
      BuyStop_TakeProfit   =  CalcBuyTakeProfit(argSymbol, TP2_Option2 , HighValue);
      BuyStop_StopLoss = CalcBuyStopLoss(argSymbol, SL2_Option2, HighValue);   

      /* Set buy stop order */
      BuyTicket = OpenBuyStopOder(argSymbol, Lot2_Option2, HighValue, BuyStop_StopLoss, BuyStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);
      /* Set Sell stop order */
      SellTicket = OpenSellStopOrder(argSymbol, Lot2_Option2, LowValue, SellStop_StopLoss, SellStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet); 

      ///////////////////////////////////////////////////////////////////

      SellStop_StopLoss = CalcSellStopLoss(argSymbol, SL3_Option2, LowValue);  
      SellStop_TakeProfit   =  CalcSellTakeProfit(argSymbol, TP3_Option2 , LowValue);
      BuyStop_TakeProfit   =  CalcBuyTakeProfit(argSymbol, TP3_Option2 , HighValue);
      BuyStop_StopLoss = CalcBuyStopLoss(argSymbol, SL3_Option2, HighValue);   

      /* Set buy stop order */
      BuyTicket = OpenBuyStopOder(argSymbol, Lot3_Option2, HighValue, BuyStop_StopLoss, BuyStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet);
      /* Set Sell stop order */
      SellTicket = OpenSellStopOrder(argSymbol, Lot3_Option2, LowValue, SellStop_StopLoss, SellStop_TakeProfit, UseSlipage, MagicNumber, 0, Commnet); 
    }
  }
}

void InitEA_Function()
{
  Already_Buy_EURCAD = false;
  Already_Buy_CADCHF = false;
  Already_Buy_AUDUSD = false;
  Already_Buy_GBPCHF = false;
  Already_Buy_NZDCHF = false;
  Already_Buy_USDCAD = false;
  Already_Buy_AUDCHF = false;
  Already_Buy_NZDJPY = false;
  Already_Buy_CADJPY = false;
  Already_Buy_GBPUSD = false;
  Already_Buy_GBPCAD = false;
  Already_Buy_AUDJPY = false;
  Already_Buy_EURAUD = false;
  Already_Buy_GBPJPY = false;
  Already_Buy_NZDCAD = false;
  Already_Buy_EURJPY = false;
  Already_Buy_USDCHF = false;
  Already_Buy_EURCHF = false;
  Already_Buy_EURGBP = false;
  Already_Buy_NZDUSD = false;
  Already_Buy_CHFJPY = false;
  Already_Buy_AUDCAD = false;
  Already_Buy_AUDNZD = false;
  Already_Buy_USDJPY = false;
  Already_Buy_GBPAUD = false;
  Already_Buy_EURUSD = false;

  Already_Sell_EURCAD = false;
  Already_Sell_CADCHF = false;
  Already_Sell_AUDUSD = false;
  Already_Sell_GBPCHF = false;
  Already_Sell_NZDCHF = false;
  Already_Sell_USDCAD = false;
  Already_Sell_AUDCHF = false;
  Already_Sell_NZDJPY = false;
  Already_Sell_CADJPY = false;
  Already_Sell_GBPUSD = false;
  Already_Sell_GBPCAD = false;
  Already_Sell_AUDJPY = false;
  Already_Sell_EURAUD = false;
  Already_Sell_GBPJPY = false;
  Already_Sell_NZDCAD = false;
  Already_Sell_EURJPY = false;
  Already_Sell_USDCHF = false;
  Already_Sell_EURCHF = false;
  Already_Sell_EURGBP = false;
  Already_Sell_NZDUSD = false;
  Already_Sell_CHFJPY = false;
  Already_Sell_AUDCAD = false;
  Already_Sell_AUDNZD = false;
  Already_Sell_USDJPY = false;
  Already_Sell_GBPAUD = false;
  Already_Sell_EURUSD = false;

  Already_BelowMiddle_EURCAD = false;
  Already_BelowMiddle_CADCHF = false;
  Already_BelowMiddle_AUDUSD = false;
  Already_BelowMiddle_GBPCHF = false;
  Already_BelowMiddle_NZDCHF = false;
  Already_BelowMiddle_USDCAD = false;
  Already_BelowMiddle_AUDCHF = false;
  Already_BelowMiddle_NZDJPY = false;
  Already_BelowMiddle_CADJPY = false;
  Already_BelowMiddle_GBPUSD = false;
  Already_BelowMiddle_GBPCAD = false;
  Already_BelowMiddle_AUDJPY = false;
  Already_BelowMiddle_EURAUD = false;
  Already_BelowMiddle_GBPJPY = false;
  Already_BelowMiddle_NZDCAD = false;
  Already_BelowMiddle_EURJPY = false;
  Already_BelowMiddle_USDCHF = false;
  Already_BelowMiddle_EURCHF = false;
  Already_BelowMiddle_EURGBP = false;
  Already_BelowMiddle_NZDUSD = false;
  Already_BelowMiddle_CHFJPY = false;
  Already_BelowMiddle_AUDCAD = false;
  Already_BelowMiddle_AUDNZD = false;
  Already_BelowMiddle_USDJPY = false;
  Already_BelowMiddle_GBPAUD = false;
  Already_BelowMiddle_EURUSD = false;

  Already_AboveMiddle_EURCAD = false;
  Already_AboveMiddle_CADCHF = false;
  Already_AboveMiddle_AUDUSD = false;
  Already_AboveMiddle_GBPCHF = false;
  Already_AboveMiddle_NZDCHF = false;
  Already_AboveMiddle_USDCAD = false;
  Already_AboveMiddle_AUDCHF = false;
  Already_AboveMiddle_NZDJPY = false;
  Already_AboveMiddle_CADJPY = false;
  Already_AboveMiddle_GBPUSD = false;
  Already_AboveMiddle_GBPCAD = false;
  Already_AboveMiddle_AUDJPY = false;
  Already_AboveMiddle_EURAUD = false;
  Already_AboveMiddle_GBPJPY = false;
  Already_AboveMiddle_NZDCAD = false;
  Already_AboveMiddle_EURJPY = false;
  Already_AboveMiddle_USDCHF = false;
  Already_AboveMiddle_EURCHF = false;
  Already_AboveMiddle_EURGBP = false;
  Already_AboveMiddle_NZDUSD = false;
  Already_AboveMiddle_CHFJPY = false;
  Already_AboveMiddle_AUDCAD = false;
  Already_AboveMiddle_AUDNZD = false;
  Already_AboveMiddle_USDJPY = false;
  Already_AboveMiddle_GBPAUD = false;
  Already_AboveMiddle_EURUSD = false; 

  ADXBelow25_EURCAD = true;
  ADXBelow25_CADCHF = true;
  ADXBelow25_AUDUSD = true;
  ADXBelow25_GBPCHF = true;
  ADXBelow25_NZDCHF = true;
  ADXBelow25_USDCAD = true;
  ADXBelow25_AUDCHF = true;
  ADXBelow25_NZDJPY = true;
  ADXBelow25_CADJPY = true;
  ADXBelow25_GBPUSD = true;
  ADXBelow25_GBPCAD = true;
  ADXBelow25_AUDJPY = true;
  ADXBelow25_EURAUD = true;
  ADXBelow25_GBPJPY = true;
  ADXBelow25_NZDCAD = true;
  ADXBelow25_EURJPY = true;
  ADXBelow25_USDCHF = true;
  ADXBelow25_EURCHF = true;
  ADXBelow25_EURGBP = true;
  ADXBelow25_NZDUSD = true;
  ADXBelow25_CHFJPY = true;
  ADXBelow25_AUDCAD = true;
  ADXBelow25_AUDNZD = true;
  ADXBelow25_USDJPY = true;
  ADXBelow25_GBPAUD = true;
  ADXBelow25_EURUSD = true;

  Already_PendingBuy_EURCAD = false;
  Already_PendingBuy_CADCHF = false;
  Already_PendingBuy_AUDUSD = false;
  Already_PendingBuy_GBPCHF = false;
  Already_PendingBuy_NZDCHF = false;
  Already_PendingBuy_USDCAD = false;
  Already_PendingBuy_AUDCHF = false;
  Already_PendingBuy_NZDJPY = false;
  Already_PendingBuy_CADJPY = false;
  Already_PendingBuy_GBPUSD = false;
  Already_PendingBuy_GBPCAD = false;
  Already_PendingBuy_AUDJPY = false;
  Already_PendingBuy_EURAUD = false;
  Already_PendingBuy_GBPJPY = false;
  Already_PendingBuy_NZDCAD = false;
  Already_PendingBuy_EURJPY = false;
  Already_PendingBuy_USDCHF = false;
  Already_PendingBuy_EURCHF = false;
  Already_PendingBuy_EURGBP = false;
  Already_PendingBuy_NZDUSD = false;
  Already_PendingBuy_CHFJPY = false;
  Already_PendingBuy_AUDCAD = false;
  Already_PendingBuy_AUDNZD = false;
  Already_PendingBuy_USDJPY = false;
  Already_PendingBuy_GBPAUD = false;
  Already_PendingBuy_EURUSD = false; 

  Already_PendingSell_EURCAD = false;
  Already_PendingSell_CADCHF = false;
  Already_PendingSell_AUDUSD = false;
  Already_PendingSell_GBPCHF = false;
  Already_PendingSell_NZDCHF = false;
  Already_PendingSell_USDCAD = false;
  Already_PendingSell_AUDCHF = false;
  Already_PendingSell_NZDJPY = false;
  Already_PendingSell_CADJPY = false;
  Already_PendingSell_GBPUSD = false;
  Already_PendingSell_GBPCAD = false;
  Already_PendingSell_AUDJPY = false;
  Already_PendingSell_EURAUD = false;
  Already_PendingSell_GBPJPY = false;
  Already_PendingSell_NZDCAD = false;
  Already_PendingSell_EURJPY = false;
  Already_PendingSell_USDCHF = false;
  Already_PendingSell_EURCHF = false;
  Already_PendingSell_EURGBP = false;
  Already_PendingSell_NZDUSD = false;
  Already_PendingSell_CHFJPY = false;
  Already_PendingSell_AUDCAD = false;
  Already_PendingSell_AUDNZD = false;
  Already_PendingSell_USDJPY = false;
  Already_PendingSell_GBPAUD = false;
  Already_PendingSell_EURUSD = false;
}

double GetHMA_Value(string argSymbol)
{
   int l_period_0 = MathFloor(HMA_Period / 2);
   double g_ibuf_124 = 2.0 * iMA(argSymbol, 0, l_period_0, HMA_TIMEFRAME, MODE_LWMA, PRICE_CLOSE, 1) - iMA(argSymbol, 0, HMA_Period, HMA_TIMEFRAME, MODE_LWMA, PRICE_CLOSE, 1);
   return g_ibuf_124;
}

bool HMABuy_Condition(string argSymbol)
{
   double PriceClose  = iClose(argSymbol, HMA_TIMEFRAME, 1);
   double HMAValue      = GetHMA_Value(argSymbol);
   if(PriceClose > HMAValue)
   {
      return true;
   }
   else
   {
      return false;
   }
}

bool HMASell_Condition(string argSymbol)
{
   double PriceClose    = iClose(argSymbol, HMA_TIMEFRAME, 1);
   double HMAValue      = GetHMA_Value(argSymbol);
   if(PriceClose < HMAValue)
   {
      return true;
   }
   else
   {
      return false;
   }
}

void DisplayInfo(string Info, string font, int fontSize, color C, int pos, int line)
{
   string InfoLabelName;
   InfoLabelName = StringConcatenate("Label",pos,line);
   if (true)
   {
      if (ObjectFind(InfoLabelName)<0)
      {      
            ObjectCreate(InfoLabelName,OBJ_LABEL,0,0,0,0,0,0,0);
            ObjectSet( InfoLabelName, OBJPROP_CORNER, pos);
            ObjectSet( InfoLabelName, OBJPROP_XDISTANCE,20);
	         ObjectSet( InfoLabelName, OBJPROP_YDISTANCE, 20+line*(1.1*fontSize+5));
	         ObjectSetText(InfoLabelName,Info, fontSize, font, C);      
      }
      else
      {
         ObjectSetText(InfoLabelName,Info, fontSize ,font, C);
      }
   }
}

bool is_ready(string symbol, ENUM_TIMEFRAMES tf)
{
   ResetLastError();
   int n = iBars(symbol, tf);
   if(GetLastError() != ERR_NO_ERROR || n <= 0){
      Sleep(10);
      return false;
   }
   return true;
}

void LoadHistory(string symbol)
{
     ENUM_TIMEFRAMES tfs[] = {
      PERIOD_M1,  PERIOD_M5, PERIOD_M15,
      PERIOD_M30, PERIOD_H1, PERIOD_H4, 
      PERIOD_D1,  PERIOD_W1, PERIOD_MN1
   };
   for(int i=SymbolsTotal(true)-1; i>=0; --i)
      for(int j=ArraySize(tfs)-1; j>=0; --j)
         while(!IsStopped() && !is_ready(symbol, tfs[j]));
}

bool BuyParabolic_Condition(string argSymbol)
{
  double iSar_value = iSAR(argSymbol, PARA_TIMEFRAME ,0.02, 0.2, 1);
  double PriceClose  = iClose(argSymbol, PARA_TIMEFRAME, 1);
  if(PriceClose > iSar_value)
  {
    return true;
  }
  else
  {
    return false;
  }
}

bool SellParabolic_Condition(string argSymbol)
{
  double iSar_value= iSAR(argSymbol, PARA_TIMEFRAME ,0.02, 0.2, 1);
  double PriceClose  = iClose(argSymbol, PARA_TIMEFRAME, 1);
  if(PriceClose < iSar_value)
  {
    return true;
  }
  else
  {
    return false;
  }
}

int ATR_Runing(string argSymbol)
{
   int lastbar;
   int counted_bars= Bars;
   if (counted_bars>0) counted_bars--;
   lastbar = Bars-counted_bars;	
   double ADR_val;
   // DailyOpen(0,lastbar);
   
//+------------------------------------------------------------------+
   CSumDays sum_day(0, 0);
   CSumDays sum_m(0, 0);
   CSumDays sum_6m(0, 0);
   CSumDays sum_6m_add(0, 0);
   range(NumOfDays_D, sum_day, argSymbol);
   range(NumOfDays_M, sum_m, argSymbol);
   range(NumOfDays_6M, sum_6m, argSymbol);
   range(Recent_Days_Weighting, sum_6m_add, argSymbol);
   double hi = iHigh(argSymbol, PERIOD_D1, 0);
   double lo = iLow(argSymbol, PERIOD_D1, 0);
   if(ADR_Entry)
   {
      if(pnt > 0)
      {
          string Y, M, M6, H, L, ADR;
          double m, m6, h, l;
          if (Y_enabled) Y = DoubleToStr(sum_day.m_sum / sum_day.m_days / pnt, 0);
          m = sum_m.m_sum / sum_m.m_days / pnt;
          M = DoubleToStr(sum_m.m_sum / sum_m.m_days / pnt, 0);
          m6 = sum_6m.m_sum / sum_6m.m_days;
          h = (hi - Bid) / pnt;
          H = DoubleToStr((hi - Bid) / pnt, 0);
          l = (Bid - lo) / pnt;
          L = DoubleToStr((Bid - lo) / pnt, 0);
          if(m6 == 0) return 0;
          if(Weighting_to_ADR_percentage)
          {
            double WADR = ((iHigh(argSymbol, PERIOD_D1, 0) - iLow(argSymbol, PERIOD_D1, 0)) + (iHigh(argSymbol, PERIOD_D1, 1) - iLow(argSymbol, PERIOD_D1, 1)) + (iHigh(argSymbol, PERIOD_D1, 2) - iLow(argSymbol, PERIOD_D1, 2)) +
                            (iHigh(argSymbol, PERIOD_D1, 3) - iLow(argSymbol, PERIOD_D1, 3)) + (iHigh(argSymbol, PERIOD_D1, 4) - iLow(argSymbol, PERIOD_D1, 4))) / 5;
            double val = (m6 + WADR) / 2 / pnt;
            // double val = (m6) / 2 / pnt;
            // double val = (m6) / pnt;
            ADR_val=(h + l) / val * 100;
            ADR = DoubleToStr(ADR_val, 0);
          }
          else
          {
              ADR_val=(h + l) / (m6 / pnt) * 100;
            ADR = DoubleToStr(ADR_val, 0);
          }
          if(M6_Trading_weighting)
          {
            m6 = (m6 + sum_6m_add.m_sum / sum_6m_add.m_days) / 2;
          }
          if(ADR_Line)
          {
            ObjectCreate(0,objname+"ADR high line",OBJ_TREND,0,0,hi-m6);
            ObjectSetInteger(0,objname+"ADR high line",OBJPROP_TIME1,iTime(_Symbol,PERIOD_D1,0)+TimeZoneOfData*3600);
            ObjectSetInteger(0,objname+"ADR high line",OBJPROP_TIME2,iTime(_Symbol,PERIOD_CURRENT,0));
            ObjectSetDouble(0,objname+"ADR high line",OBJPROP_PRICE1,hi-m6);
            ObjectSetDouble(0,objname+"ADR high line",OBJPROP_PRICE2,hi-m6);
            ObjectSetInteger(0,objname+"ADR high line",OBJPROP_COLOR,ADR_Line_Colour);
            ObjectSetInteger(0,objname+"ADR high line",OBJPROP_STYLE,ADR_linestyle);
            ObjectSetInteger(0,objname+"ADR high line",OBJPROP_WIDTH,ADR_Linethickness);
            ObjectSetInteger(0,objname+"ADR high line",OBJPROP_RAY,false);
            
            ObjectCreate(0,objname+"ADR low line",OBJ_TREND,0,0,lo+m6);
            ObjectSetInteger(0,objname+"ADR low line",OBJPROP_TIME1,iTime(_Symbol,PERIOD_D1,0)+TimeZoneOfData*3600);
            ObjectSetInteger(0,objname+"ADR low line",OBJPROP_TIME2,iTime(_Symbol,PERIOD_CURRENT,0));
            ObjectSetDouble(0,objname+"ADR low line",OBJPROP_PRICE1,lo+m6);
            ObjectSetDouble(0,objname+"ADR low line",OBJPROP_PRICE2,lo+m6);
            ObjectSetInteger(0,objname+"ADR low line",OBJPROP_COLOR,ADR_Line_Colour);
            ObjectSetInteger(0,objname+"ADR low line",OBJPROP_STYLE,ADR_linestyle);
            ObjectSetInteger(0,objname+"ADR low line",OBJPROP_WIDTH,ADR_Linethickness);
            ObjectSetInteger(0,objname+"ADR low line",OBJPROP_RAY,false);
          }
          m6 = m6 / pnt;
          M6 = DoubleToStr(m6, 0);
          DistanceL = StringLen(L) * 10 + 5;
          DistanceHv = 30;
          DistanceH = StringLen(H) * 10 + 5;
          Distance6Mv = 30;
          Distance6M = StringLen(M6) * 10 + 5;
          DistanceMv = 30;
          DistanceM = StringLen(M) * 10 + 5;
          DistanceYv = 30;
          DistanceY = StringLen(Y) * 10 + 5;
          DistanceADRv = 30;
          DistanceADR = StringLen(ADR) * 10 + 20;
          if(display_ADR)
          {
            ObjectSet(objname + "ADR", OBJPROP_CORNER, Corner);
            ObjectSet(objname + "ADR", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + M_enabled * (DistanceMv + DistanceM) + Y_enabled * (DistanceYv + DistanceY) + DistanceADRv + DistanceADR);
            ObjectSet(objname + "ADR", OBJPROP_YDISTANCE, VertPos);
            ObjectSetText(objname + "ADR", "ADR", FontSize, FontName, FontColor);
            ObjectSet(objname + "%", OBJPROP_CORNER, Corner);
            ObjectSet(objname + "%", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + M_enabled * (DistanceMv + DistanceM) + Y_enabled * (DistanceYv + DistanceY) + DistanceADRv);
            ObjectSet(objname + "%", OBJPROP_YDISTANCE, VertPos);
            
            static bool oneTime=true;
            if(ADR_val < 100)
            {
                ObjectSetText(objname + "%", ADR + "%", Font2Size, FontName, ADR_color_below_100);
                oneTime=true;
            }
            else
            {
                if(ADR_Alert_Sound && oneTime)
                {
                  Alert(_Symbol+" ADX >= 100%");
                  oneTime=false;
                }
                ObjectSetText(objname + "%", ADR + "%", Font2Size, FontName, ADR_color_above_100);
            }
          }
          if (Y_enabled)
          {
            ObjectSet(objname + "Y", OBJPROP_CORNER, Corner);
            ObjectSet(objname + "Y", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + M_enabled * (DistanceMv + DistanceM) + DistanceYv + DistanceY);
            ObjectSet(objname + "Y", OBJPROP_YDISTANCE, VertPos);
            ObjectSetText(objname + "Y", "Y:", Font2Size, FontName, FontColor);
            ObjectSet(objname + "Y-value", OBJPROP_CORNER, Corner);
            ObjectSet(objname + "Y-value", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + M_enabled * (DistanceMv + DistanceM) + DistanceYv);
            ObjectSet(objname + "Y-value", OBJPROP_YDISTANCE, VertPos);
            ObjectSetText(objname + "Y-value", Y, Font2Size, FontName, FontColor2);
          }
          if (M_enabled)
          {
            ObjectSet(objname + "M", OBJPROP_CORNER, Corner);
            ObjectSet(objname + "M", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + DistanceMv + DistanceM);
            ObjectSet(objname + "M", OBJPROP_YDISTANCE, VertPos);
            ObjectSetText(objname + "M", "M:", Font2Size, FontName, FontColor);
            ObjectSet(objname + "M-value", OBJPROP_CORNER, Corner);
            ObjectSet(objname + "M-value", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + DistanceMv);
            ObjectSet(objname + "M-value", OBJPROP_YDISTANCE, VertPos);
            ObjectSetText(objname + "M-value", M, Font2Size, FontName, FontColor2);
          }
          if (M6_enabled)
          {
            ObjectSet(objname + "6M", OBJPROP_CORNER, Corner);
            ObjectSet(objname + "6M", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + Distance6Mv + Distance6M);
            ObjectSet(objname + "6M", OBJPROP_YDISTANCE, VertPos);
            ObjectSetText(objname + "6M", "6M:", Font2Size, FontName, FontColor);
            ObjectSet(objname + "6M-value", OBJPROP_CORNER, Corner);
            ObjectSet(objname + "6M-value", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + Distance6Mv);
            ObjectSet(objname + "6M-value", OBJPROP_YDISTANCE, VertPos);
            ObjectSetText(objname + "6M-value", M6, Font2Size, FontName, FontColor2);
          }
          ObjectSet(objname + "H", OBJPROP_CORNER, Corner);
          ObjectSet(objname + "H", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH);
          ObjectSet(objname + "H", OBJPROP_YDISTANCE, VertPos);
          ObjectSetText(objname + "H", "H:", Font2Size, FontName, FontColor);
          ObjectSet(objname + "H-value", OBJPROP_CORNER, Corner);
          ObjectSet(objname + "H-value", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv);
          ObjectSet(objname + "H-value", OBJPROP_YDISTANCE, VertPos);
          ObjectSetText(objname + "H-value", H, Font2Size, FontName, FontColor2);
          ObjectSet(objname + "L", OBJPROP_CORNER, Corner);
          ObjectSet(objname + "L", OBJPROP_XDISTANCE, HorizPos + DistanceL);
          ObjectSet(objname + "L", OBJPROP_YDISTANCE, VertPos);
          ObjectSetText(objname + "L", "L:", Font2Size, FontName, FontColor);
          ObjectSet(objname + "L-value", OBJPROP_CORNER, Corner);
          ObjectSet(objname + "L-value", OBJPROP_XDISTANCE, HorizPos);
          ObjectSet(objname + "L-value", OBJPROP_YDISTANCE, VertPos);
          ObjectSetText(objname + "L-value", L, Font2Size, FontName, FontColor2);
      } 
   }

   return 0;

}

void range(int days, CSumDays &sumdays, string argSymbol)
{
   sumdays.m_days = 0;
   sumdays.m_sum = 0;
   for(int i = 1; i < Bars - 1; i++)
   {
      double hi = iHigh(argSymbol, PERIOD_D1, i);
      double lo = iLow(argSymbol, PERIOD_D1, i);
      datetime dt = iTime(argSymbol, PERIOD_D1, i);
      if(TimeDayOfWeek(dt) > 0 && TimeDayOfWeek(dt) < 6)
      {
         sumdays.m_sum += hi - lo;
         sumdays.m_days = sumdays.m_days + 1;
         if(sumdays.m_days >= days) break;
      }
   }
}

bool ATR_Runing_Condition(string argSymbol)
{
   int lastbar;
   int counted_bars= Bars;
   if (counted_bars>0) counted_bars--;
   lastbar = Bars-counted_bars;	
   double ADR_val;
   // DailyOpen(0,lastbar);
   
//+------------------------------------------------------------------+
   CSumDays sum_day(0, 0);
   CSumDays sum_m(0, 0);
   CSumDays sum_6m(0, 0);
   CSumDays sum_6m_add(0, 0);
   range(NumOfDays_D, sum_day, argSymbol);
   range(NumOfDays_M, sum_m, argSymbol);
   range(NumOfDays_6M, sum_6m, argSymbol);
   range(Recent_Days_Weighting, sum_6m_add, argSymbol);
   double hi = iHigh(argSymbol, PERIOD_D1, 0);
   double lo = iLow(argSymbol, PERIOD_D1, 0);
   if(ADR_Entry)
   {
      if(pnt > 0)
      {
          string Y, M, M6, H, L, ADR;
          double m, m6, h, l;
          if (Y_enabled) Y = DoubleToStr(sum_day.m_sum / sum_day.m_days / pnt, 0);
          m = sum_m.m_sum / sum_m.m_days / pnt;
          M = DoubleToStr(sum_m.m_sum / sum_m.m_days / pnt, 0);
          m6 = sum_6m.m_sum / sum_6m.m_days;
          h = (hi - Bid) / pnt;
          H = DoubleToStr((hi - Bid) / pnt, 0);
          l = (Bid - lo) / pnt;
          L = DoubleToStr((Bid - lo) / pnt, 0);
          if(m6 == 0) return 0;
          if(Weighting_to_ADR_percentage)
          {
            double WADR = ((iHigh(argSymbol, PERIOD_D1, 0) - iLow(argSymbol, PERIOD_D1, 0)) + (iHigh(argSymbol, PERIOD_D1, 1) - iLow(argSymbol, PERIOD_D1, 1)) + (iHigh(argSymbol, PERIOD_D1, 2) - iLow(argSymbol, PERIOD_D1, 2)) +
                            (iHigh(argSymbol, PERIOD_D1, 3) - iLow(argSymbol, PERIOD_D1, 3)) + (iHigh(argSymbol, PERIOD_D1, 4) - iLow(argSymbol, PERIOD_D1, 4))) / 5;
            // double val = (m6 + WADR) / 2 / pnt;
            double val = (m6) / 2 / pnt;
            ADR_val=(h + l) / val * 100;
            ADR = DoubleToStr(ADR_val, 0);
          }
          else
          {
            ADR_val=(h + l) / (m6 / pnt) * 100;
            ADR = DoubleToStr(ADR_val, 0);
          }
          if(M6_Trading_weighting)
          {
            m6 = (m6 + sum_6m_add.m_sum / sum_6m_add.m_days) / 2;
          }
      if(ADR_val > ADR_Percent)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    else
    {
      return false;
    }
  }
  else
  {
    return true;
  }
}

int GMTGet_Function()
{
  int server_gmt_offset_hours = (long) MathRound((TimeCurrent() - TimeGMT()) / 3600.0);
  return server_gmt_offset_hours;
}
