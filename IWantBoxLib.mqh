//+------------------------------------------------------------------+
//|                                                  IWantBoxLib.mqh |
//|                                                   Tran Dinh Sang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Tran Dinh Sang"
#property link      "https://www.mql5.com"
#property strict

//--- Open Include Area 
#include <stdlib.mqh>
//--- End Include Area

//--- This is function to calcualate the LotSize following the Percent Risk
double CalcLotSize(bool argDynamicLotSize, double argEquitiyPercent, double argStopLoss,  
                  double argFixedLotSize)
{
   
   /* Local variable declearation */
   double riskAmount;
   double tickValue;
   double lotSize;
   if(true == argDynamicLotSize && argStopLoss > 0)
   {
      //--- Calculate the riskAmount
      riskAmount = AccountEquity() * (argEquitiyPercent / 100);
      //--- Get tick value from market
      tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
      if(Point == 0.001 || Point == 0.00001)
      {
         tickValue = tickValue * 10;
      }
      lotSize = (riskAmount / argStopLoss) / tickValue;
   }
   else
   {
      lotSize = argFixedLotSize;
   }
   /* return lot size */
   return (lotSize);
   
}

//--- This is function to varify the lot size
double VerifyLotSize(double argLotsize)
{  
   //--- local variable declearation
   if(argLotsize < MarketInfo(Symbol(), MODE_MINLOT))
   {
      argLotsize = MarketInfo(Symbol(), MODE_MINLOT);
   }
   else if(argLotsize > MarketInfo(Symbol(), MODE_MAXLOT))
   {
      argLotsize = MarketInfo(Symbol(), MODE_MAXLOT);
   }
   //--- Normalize the lot size
   if(0.1 == MarketInfo(Symbol(), MODE_LOTSTEP))
   {
      argLotsize = NormalizeDouble(argLotsize, 1);
   }
   else
   {
      argLotsize = NormalizeDouble(argLotsize, 2);
   }
   return (argLotsize);
}

//--- This is function to OpenBuyOrder
int OpenBuyOrder(string argSymbol, double argLotsize, double argSlippage, 
                 int argMagicNumber, string argComment = "Buy Order")
{
   //--- Local variable declearation
   int ticket;
   int errorCode;
   string errorDescription;
   string errorAlert;
   string errorLog;
   while(IsTradeContextBusy())
   {
      /* Waiting 10ms */
      Sleep(10);
   }
   
   //--- Place the Buy order
   ticket = OrderSend(argSymbol, OP_BUY, argLotsize, MarketInfo(argSymbol, MODE_ASK), 
                      argSlippage, 0, 0, argComment, argMagicNumber, 0, Green);
   //--- Error handling
   if(ticket  < 0)
   {
      errorCode = GetLastError();
      errorDescription = ErrorDescription(errorCode);
      
      errorAlert = StringConcatenate("Open Buy Order - Error ", errorCode, ": ",
                                     errorDescription);
      Alert(errorCode);
      
      errorLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID), " Ask: ",
      MarketInfo(argSymbol, MODE_ASK), " Lot Size: ", argLotsize);
      Print(errorLog);
   }
   
   return(ticket);
}

//--- This is function to OpenSellOrder
int OpenSellOrder(string argSymbol, double argLotsize, double argSlippage, 
                 int argMagicNumber, string argComment = "Sell Order")
{
   //--- Local variable declearation
   int ticket;
   int errorCode;
   string errorDescription;
   string errorAlert;
   string errorLog;
   while(IsTradeContextBusy())
   {
      /* Waiting 10ms */
      Sleep(10);
   }
   
   //--- Place the Sell order
   ticket = OrderSend(argSymbol, OP_SELL, argLotsize, MarketInfo(argSymbol, MODE_BID), 
                      argSlippage, 0, 0, argComment, argMagicNumber, 0, Red);
   //--- Error handling
   if(ticket < 0)
   {
      errorCode = GetLastError();
      errorDescription = ErrorDescription(errorCode);
      
      errorAlert = StringConcatenate("Open Sell Order - Error ", errorCode, ": ",
                                     errorDescription);
      Alert(errorCode);
      
      errorLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID), " Ask: ",
      MarketInfo(argSymbol, MODE_ASK), " Lot Size: ", argLotsize);
      Print(errorLog);
   }
   
   return(ticket);
}

//--- This is function to open Buy Stop Order
int OpenBuyStopOder(string argSymbol, double argLotSize, double argPendingPrice, double argStopLoss,
                    double argTakeProfit, double argSlippage, int argMagicNumber, datetime argExpiration = 0,
                    string argComment = "Buy Stop Order")
{
   //--- Local variable 
   int ticket;
   int errorCode;
   string errorDescription;
   string errorAlert;
   string errorLog;
   while(IsTradeContextBusy())
   {
      Sleep(10);
   }   
   
   //--- Place ticket buy stop order
   ticket = OrderSend(argSymbol, OP_BUYSTOP, argLotSize, argPendingPrice, argSlippage, argStopLoss,
                      argTakeProfit, argComment, argMagicNumber, argExpiration, Green);
   //--- Error handling
   if(ticket = -1)
   {
      errorCode = GetLastError();
      errorDescription = ErrorDescription(errorCode);
      
      errorAlert = StringConcatenate("Open Buy Stop Order - Error ", errorCode, ": ",
                                     errorDescription);
      //Alert(errorCode);
      
      errorLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID), " Ask: ",
      MarketInfo(argSymbol, MODE_ASK), " Lot Size: ", argLotSize, " Price Pending: ", argPendingPrice,
      " StopLoss: ", argStopLoss, " TakeProfit: ", argTakeProfit);
      //Print(errorLog);      
   }
   return(ticket);
}

//--- This is function to open Sell Stop Order
int OpenSellStopOrder(string argSymbol, double argLotSize, double argPendingPrice,
                      double argStopLoss, double argTakeProfit, double argSlippage, double argMagicNumber,
                      datetime argExpiration = 0, string argComment = "Sell Stop Order")
{
   //--- Local variable 
   int ticket;
   int errorCode;
   string errorDescription;
   string errorAlert;
   string errorLog;   
   while(IsTradeContextBusy())
   {
      Sleep(10);
   }  
   //--- Place Sell Stop Order
   ticket = OrderSend(argSymbol,OP_SELLSTOP,argLotSize,argPendingPrice,argSlippage,
                argStopLoss,argTakeProfit,argComment,argMagicNumber,argExpiration,Red);  
                
   //--- Error Handling
   if(ticket == -1)
   {
      errorCode = GetLastError();
      errorDescription = ErrorDescription(errorCode);
      errorAlert = StringConcatenate("Open Sell Stop Order - Error ",errorCode,
      ": ",errorDescription);
      //Alert(errorCode);
      errorLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID),
      " Lots: ",argLotSize," Price: ",argPendingPrice," Stop: ",argStopLoss,
      " Profit: ",argTakeProfit," Expiration: ",TimeToStr(argExpiration));
      //Print(errorLog);
   }
   return(ticket);
}

//--- This is function to place OpenBuyLitmit order
int OpenBuyLimitOrder(string argSymbol, double argLotSize, double argPendingPrice,
                      double argStopLoss, double argTakeProfit, double argSlippage, int argMagicNumber,
                      datetime argExpiration, string argComment = "Buy Limit Order")
{
   //--- Local variable 
   int ticket;
   int errorCode;
   string errorDescription;
   string errorAlert;
   string errorLog;  
   while(IsTradeContextBusy())
   {
      Sleep(10);
   }   
   //--- Place Buy Limit Order
   ticket = OrderSend(argSymbol,OP_BUYLIMIT,argLotSize,argPendingPrice,argSlippage,
                          argStopLoss,argTakeProfit,argComment,argMagicNumber,argExpiration,Green);
   //--- Error Handling
   if(ticket == -1)
   {
      errorCode = GetLastError();
      errorDescription = ErrorDescription(errorCode);
      errorAlert = StringConcatenate("Open Buy Limit Order - Error ",errorCode,
      ": ",errorDescription);
      Alert(errorAlert);
      errorLog = StringConcatenate("Bid: ",MarketInfo(argSymbol,MODE_BID),
      " Lots: ",argLotSize," Price: ",argPendingPrice," Stop: ",argStopLoss,
      " Profit: ",argTakeProfit," Expiration: ",TimeToStr(argExpiration));
      Print(errorLog);
   }
   return(ticket);       
}

//--- This is function to Place Sell Limit order
int OpenSellLimitOrder(string argSymbol, double argLotSize, double argPendingPrice,
                       double argStopLoss, double argTakeProfit, double argSlippage, double argMagicNumber,
                       datetime argExpiration, string argComment = "Sell Limit Order")
{
   //--- Local variable 
   int ticket;
   int errorCode;
   string errorDescription;
   string errorAlert;
   string errorLog;  
   while(IsTradeContextBusy())
   {
      Sleep(10);
   } 
   //--- Place Sell Limit order
   int Ticket = OrderSend(argSymbol,OP_SELLLIMIT,argLotSize,argPendingPrice,argSlippage,
                         argStopLoss,argTakeProfit,argComment,argMagicNumber,argExpiration,Red);
                         
    //--- Error Handling
   if(ticket == -1)
   {
      errorCode = GetLastError();
      errorDescription = ErrorDescription(errorCode);
      errorAlert = StringConcatenate("Open Sell Stop Order - Error ",errorCode, ": ",errorDescription);
      Alert(errorAlert);
      errorLog = StringConcatenate("Ask: ",MarketInfo(argSymbol,MODE_ASK),
      " Lots: ",argLotSize," Price: ",argPendingPrice," Stop: ",argStopLoss,
      " Profit: ",argTakeProfit," Expiration: ",TimeToStr(argExpiration));
      Print(errorLog);
   }
   return ticket;   
}

//--- This is function to Calculate the Pip Point
double PipPoint(string Currency)
{
   int calcDigits;
   double return_pipPoint;
   if("BTCUSDm" == Currency)
   {
      return_pipPoint = 1;
   }
   else
   {
      calcDigits = MarketInfo(Currency, MODE_DIGITS);
      if((2 == calcDigits) || (3 == calcDigits))
      {  
         return_pipPoint = 0.01;
      }
      else if ((4 == calcDigits) || (5 == calcDigits))
      {
         return_pipPoint = 0.0001;
      }
      else
      {
         /* Return Fault */
         return_pipPoint = 0;
      }
   }
   return return_pipPoint; 
}

//--- This is function to get Slippage
int GetSlippage(string Currency, int SlippagePips)
{
   //--- Local variable declearation
   double CalcSlippage;
   int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 4) CalcSlippage = SlippagePips;
   else if(CalcDigits == 3 || CalcDigits == 5) CalcSlippage = SlippagePips * 10;
   return(CalcSlippage);
}

//--- This is functio to Close Buy Order
bool CloseBuyOrder(string argSymbol, int argCloseTicket, double argSlippage)
{
   OrderSelect(argCloseTicket,SELECT_BY_TICKET);
   bool Closed;
   if(OrderCloseTime() == 0)
   {
      double CloseLots = OrderLots();
      while(IsTradeContextBusy()) Sleep(10);
      double ClosePrice = MarketInfo(argSymbol,MODE_BID);
      Closed = OrderClose(argCloseTicket,CloseLots,ClosePrice,argSlippage,Green);
      if(Closed == false)
      {
         int ErrorCode = GetLastError();
         string ErrDesc = ErrorDescription(ErrorCode);
         string ErrAlert = StringConcatenate("Close Buy Order - Error: ",ErrorCode,
         ": ",ErrDesc);
         Alert(ErrAlert);
         string ErrLog = StringConcatenate("Ticket: ",argCloseTicket," Bid: ",
         MarketInfo(argSymbol,MODE_BID));
         Print(ErrLog);
      }
   }
   return(Closed);
}

bool CloseSellOrder(string argSymbol, int argCloseTicket, double argSlippage)
{
   bool Closed;
   OrderSelect(argCloseTicket,SELECT_BY_TICKET);
   if(OrderCloseTime() == 0)
   {
      double CloseLots = OrderLots();
      while(IsTradeContextBusy()) Sleep(10);
      double ClosePrice = MarketInfo(argSymbol,MODE_ASK);
      Closed = OrderClose(argCloseTicket,CloseLots,ClosePrice,argSlippage,Red);
      if(Closed == false)
      {
         int ErrorCode = GetLastError();
         string ErrDesc = ErrorDescription(ErrorCode);
         string ErrAlert = StringConcatenate("Close Sell Order - Error: ",ErrorCode,
         ": ",ErrDesc);
         Alert(ErrAlert);
         string ErrLog = StringConcatenate("Ticket: ",argCloseTicket,
         " Ask: ",MarketInfo(argSymbol,MODE_ASK));
         Print(ErrLog);
      }
   }
   return(Closed);
}

//--- This is function to close pending order
bool ClosePendingOrder(string argSymbol, int argCloseTicket)
{
   bool Deleted;
   OrderSelect(argCloseTicket,SELECT_BY_TICKET);
   if(OrderCloseTime() == 0)
   {
      while(IsTradeContextBusy()) Sleep(10);
      Deleted = OrderDelete(argCloseTicket,Red);
      if(Deleted == false)
      {
         int ErrorCode = GetLastError();
         string ErrDesc = ErrorDescription(ErrorCode);
         string ErrAlert = StringConcatenate("Close Pending Order - Error: ",
         ErrorCode,": ",ErrDesc);
         Alert(ErrAlert);
         string ErrLog = StringConcatenate("Ticket: ",argCloseTicket," Bid: ",
         MarketInfo(argSymbol,MODE_BID)," Ask: ",MarketInfo(argSymbol,MODE_ASK));
         Print(ErrLog);
      }
   }
   return(Deleted);
}

double CalcBuyStopLoss(string argSymbol, int argStopLoss, double argOpenPrice)
{
   if(argStopLoss == 0) return(0);
   double BuyStopLoss = argOpenPrice - (argStopLoss * PipPoint(argSymbol));
   return(BuyStopLoss);
}

double CalcSellStopLoss(string argSymbol, int argStopLoss, double argOpenPrice)
{
   if(argStopLoss == 0) return(0);
   double SellStopLoss = argOpenPrice + (argStopLoss * PipPoint(argSymbol));
   return(SellStopLoss);
}

double CalcBuyTakeProfit(string argSymbol, int argTakeProfit, double argOpenPrice)
{
   if(argTakeProfit == 0) return(0);
   double BuyTakeProfit = argOpenPrice + (argTakeProfit * PipPoint(argSymbol));
   return(BuyTakeProfit);
}
double CalcSellTakeProfit(string argSymbol, int argTakeProfit, double argOpenPrice)
{
   if(argTakeProfit == 0) return(0);
   double SellTakeProfit = argOpenPrice - (argTakeProfit * PipPoint(argSymbol));
   return(SellTakeProfit);
}

bool VerifyUpperStopLevel(string argSymbol, double argVerifyPrice, double argOpenPrice = 0)
{ 
   //--- Local variable
   double StopLevel;
   double OpenPrice;
   double UpperStopLevel;
   bool StopVerify;
   
   StopLevel = MarketInfo(argSymbol,MODE_STOPLEVEL) * Point;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol,MODE_ASK);
   else OpenPrice = argOpenPrice;
   UpperStopLevel = OpenPrice + StopLevel;
   if(argVerifyPrice > UpperStopLevel) StopVerify = true;
   else StopVerify = false;
   return(StopVerify);
}

bool VerifyLowerStopLevel(string argSymbol, double argVerifyPrice, double argOpenPrice = 0)
{
   //--- Local variable
   double StopLevel;
   double OpenPrice;
   bool StopVerify;
   double LowerStopLevel;
   
   StopLevel = MarketInfo(argSymbol,MODE_STOPLEVEL) * Point;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol,MODE_BID);
   else OpenPrice = argOpenPrice;
   LowerStopLevel = OpenPrice - StopLevel;
   if(argVerifyPrice < LowerStopLevel) StopVerify = true;
   else StopVerify = false;
   return(StopVerify);
}

double AdjustAboveStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0)
{
   //--- Local variable
   double StopLevel;
   double OpenPrice;
   double AdjustedPrice;
   double UpperStopLevel;
   
   StopLevel = MarketInfo(argSymbol,MODE_STOPLEVEL) * Point;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol,MODE_ASK);
   else OpenPrice = argOpenPrice;
   UpperStopLevel = OpenPrice + StopLevel;
   if(argAdjustPrice <= UpperStopLevel) double AdjustedPrice = UpperStopLevel + (argAddPips * PipPoint(argSymbol));
   else AdjustedPrice = argAdjustPrice;
   return(AdjustedPrice);
}

double AdjustBelowStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0)
{
   //--- Local variable
   double StopLevel;
   double OpenPrice;
   double AdjustedPrice;
   double LowerStopLevel;
   
   StopLevel = MarketInfo(argSymbol,MODE_STOPLEVEL) * Point;
   if(argOpenPrice == 0) OpenPrice = MarketInfo(argSymbol,MODE_BID);
   else OpenPrice = argOpenPrice;
   LowerStopLevel = OpenPrice - StopLevel;
   if(argAdjustPrice >= LowerStopLevel) AdjustedPrice = LowerStopLevel -
   (argAddPips * PipPoint(argSymbol));
   else AdjustedPrice = argAdjustPrice;
   return(AdjustedPrice);
}

bool AddStopProfit(int argTicket, double argStopLoss, double argTakeProfit)
{
   OrderSelect(argTicket,SELECT_BY_TICKET);
   double OpenPrice = OrderOpenPrice();
   while(IsTradeContextBusy()) Sleep(10);
   // Modify Order
   bool TicketMod = OrderModify(argTicket,OrderOpenPrice(),argStopLoss,argTakeProfit,0);
   // Error Handling
   if(TicketMod == false)
   {
      int ErrorCode = GetLastError();
      string ErrDesc = ErrorDescription(ErrorCode);
      string ErrAlert = StringConcatenate("Add Stop/Profit - Error ",ErrorCode,
      ": ",ErrDesc);
      //Alert(ErrAlert);
      string ErrLog = StringConcatenate("Bid: ",MarketInfo(OrderSymbol(),MODE_BID),
      " Ask: ",MarketInfo(OrderSymbol(),MODE_ASK)," Ticket: ",argTicket," Stop: ",
      argStopLoss," Profit: ",argTakeProfit);
      Print(ErrLog);
   }
   return(TicketMod);
}

int TotalOrderCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol)
      {
         OrderCount++;
      }
   }
   return(OrderCount);
}

int BuyMarketCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_BUY)
      {
         OrderCount++;
      }
   }
   return(OrderCount);
}

int SellMarketCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_SELL)
      {
         OrderCount++;
      }
   }
   return(OrderCount);
}

int BuyStopCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_BUYSTOP)
      {
         OrderCount++;
      }
   }
   return(OrderCount);
}

int SellStopCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_SELLSTOP)
      {
         OrderCount++;
      }
   }
   return(OrderCount);
}

int BuyLimitCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_BUYLIMIT)
      {
         OrderCount++;
      }
   }
   return(OrderCount);
}

int SellLimitCount(string argSymbol, int argMagicNumber)
{
   int OrderCount;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_SELLLIMIT)
      {
         OrderCount++;
      }
   }
   return(OrderCount);
}

void CloseAllBuyOrders(string argSymbol, int argMagicNumber, int argSlippage)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_BUY)
      {
         // Close Order
         int CloseTicket = OrderTicket();
         double CloseLots = OrderLots();
         while(IsTradeContextBusy()) Sleep(10);
         double ClosePrice = MarketInfo(argSymbol,MODE_BID);
         bool Closed = OrderClose(CloseTicket,CloseLots,ClosePrice,argSlippage,Red);
         // Error Handling
         if(Closed == false)
         {
            int ErrorCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrorCode);
            string ErrAlert = StringConcatenate("Close All Buy Orders - Error ",
            ErrorCode,": ",ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",
            MarketInfo(argSymbol,MODE_BID), " Ticket: ",CloseTicket," Price: ",
            ClosePrice);
            Print(ErrLog);
         }
         else Counter--;
      }
   }
}

void CloseAllSellOrders(string argSymbol, int argMagicNumber, int argSlippage)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_SELL)
      {
         // Close Order
         int CloseTicket = OrderTicket();
         double CloseLots = OrderLots();
         while(IsTradeContextBusy()) Sleep(10);
         double ClosePrice = MarketInfo(argSymbol,MODE_ASK);
         bool Closed = OrderClose(CloseTicket,CloseLots,ClosePrice,argSlippage,Red);
         // Error Handling
         if(Closed == false)
         {
            int ErrorCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrorCode);
            string ErrAlert = StringConcatenate("Close All Sell Orders - Error ",
            ErrorCode,": ",ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Ask: ",
            MarketInfo(argSymbol,MODE_ASK), " Ticket: ",CloseTicket," Price: ",
            ClosePrice);
            Print(ErrLog);
         }
         else Counter--;
      }
   }
}

void CloseAllBuyStopOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_BUYSTOP)
      {
         // Delete Order
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         bool Closed = OrderDelete(CloseTicket,Red);
         // Error Handling
         if(Closed == false)
         {
            int ErrorCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrorCode);
            string ErrAlert = StringConcatenate("Close All Buy Stop Orders - ",
            "Error",ErrorCode,": ",ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",
            MarketInfo(argSymbol,MODE_BID), " Ask: ",
            MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
          }
         else Counter--;
      }
   }
}

//--- Close All Sell Stop Orders
void CloseAllSellStopOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_SELLSTOP)
      {
         // Delete Order
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         bool Closed = OrderDelete(CloseTicket,Red);
         // Error Handling
         if(Closed == false)
         {
            int ErrorCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrorCode);
            string ErrAlert = StringConcatenate("Close All Sell Stop Orders - ",
            "Error ", ErrorCode,": ",ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",
            MarketInfo(argSymbol,MODE_BID), " Ask: ",
            MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
      else Counter--;
      }
   }
}

//--- CloseAll BuyLimit Orders
void CloseAllBuyLimitOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_BUYLIMIT)
      {
         // Delete Order
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         bool Closed = OrderDelete(CloseTicket,Red);
         // Error Handling
         if(Closed == false)
         {
            int ErrorCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrorCode);
            string ErrAlert = StringConcatenate("Close All Buy Limit Orders - ",
            "Error ", ErrorCode,": ",ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",
            MarketInfo(argSymbol,MODE_BID), " Ask: ",
            MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
         else Counter--;
      }
   }
}

//--- CloseAll SellLimit Orders
void CloseAllSellLimitOrders(string argSymbol, int argMagicNumber)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_SELLLIMIT)
      {
         // Delete Order
         int CloseTicket = OrderTicket();
         while(IsTradeContextBusy()) Sleep(10);
         bool Closed = OrderDelete(CloseTicket,Red);
         // Error Handling
         if(Closed == false)
         {
            int ErrorCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrorCode);
            string ErrAlert = StringConcatenate("Close All Sell Limit Orders - ",
            "Error ", ErrorCode,": ",ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",
            MarketInfo(argSymbol,MODE_BID), " Ask: ",
            MarketInfo(argSymbol,MODE_ASK)," Ticket: ",CloseTicket);
            Print(ErrLog);
         }
         else Counter--;
      }
   }
}

//--- Buy Trailing Stop 
void BuyTrailingStop(string argSymbol, int argTrailingStop, int argMinProfit, int argStep, int argMagicNumber)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      // Calculate Max Stop and Min Profit
      double MaxStopLoss = MarketInfo(argSymbol,MODE_BID) - (argTrailingStop * PipPoint(argSymbol));
      MaxStopLoss = NormalizeDouble(MaxStopLoss,
      MarketInfo(OrderSymbol(),MODE_DIGITS));
      double CurrentStop = NormalizeDouble(OrderStopLoss(),
      MarketInfo(OrderSymbol(),MODE_DIGITS));
      double PipsProfit = MarketInfo(argSymbol,MODE_BID) - OrderOpenPrice();
      double MinProfit = argMinProfit * PipPoint(argSymbol);
      double StepProfit = argStep * PipPoint(argSymbol);
      // Modify Stop
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_BUY && CurrentStop < MaxStopLoss
      && PipsProfit >= StepProfit && MarketInfo(argSymbol,MODE_BID) > (OrderOpenPrice() + MinProfit))
      {
         bool Trailed = OrderModify(OrderTicket(),OrderOpenPrice(),MaxStopLoss,
         OrderTakeProfit(),0);
         // Error Handling
         if(Trailed == false)
         {
            int ErrorCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrorCode);
            string ErrAlert = StringConcatenate("Buy Trailing Stop – Error ", ErrorCode,": ",ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Bid: ",
            MarketInfo(argSymbol,MODE_BID), " Ticket: ",OrderTicket()," Stop: ",
            OrderStopLoss()," Trail: ",MaxStopLoss);
            Print(ErrLog);
         }
      }
   }
}

//--- Sell Trailing Stop 
void SellTrailingStop(string argSymbol, int argTrailingStop, int argMinProfit, int argStep, int argMagicNumber)
{
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
   {
      OrderSelect(Counter,SELECT_BY_POS);
      // Calculate Max Stop and Min Profit
      double MaxStopLoss = MarketInfo(argSymbol,MODE_ASK) + (argTrailingStop * PipPoint(argSymbol));
      MaxStopLoss = NormalizeDouble(MaxStopLoss,
      MarketInfo(OrderSymbol(),MODE_DIGITS));
      double CurrentStop = NormalizeDouble(OrderStopLoss(),
      MarketInfo(OrderSymbol(),MODE_DIGITS));
      double PipsProfit = OrderOpenPrice() - MarketInfo(argSymbol,MODE_ASK);
      double MinProfit = argMinProfit * PipPoint(argSymbol);
      double StepProfit = argStep * PipPoint(argSymbol);
      // Modify Stop
      if(OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol
      && OrderType() == OP_SELL && (CurrentStop > MaxStopLoss || CurrentStop == 0)
      && PipsProfit >= StepProfit && MarketInfo(argSymbol,MODE_ASK) < (OrderOpenPrice() - MinProfit))
      {
         bool Trailed = OrderModify(OrderTicket(),OrderOpenPrice(),MaxStopLoss,
         OrderTakeProfit(),0);
         // Error Handling
         if(Trailed == false)
         {
            int ErrorCode = GetLastError();
            string ErrDesc = ErrorDescription(ErrorCode);
            string ErrAlert = StringConcatenate("Sell Trailing Stop - Error ",
            ErrorCode,": ",ErrDesc);
            Alert(ErrAlert);
            string ErrLog = StringConcatenate("Ask: ",
            MarketInfo(argSymbol,MODE_ASK), " Ticket: ",OrderTicket()," Stop: ",
            OrderStopLoss()," Trail: ",MaxStopLoss);
            Print(ErrLog);
         }
      }
   }
}

