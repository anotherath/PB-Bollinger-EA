#include <Trade\Trade.mqh>

CTrade trade;

// Mảng để lưu trữ thời gian của nến hiện tại
datetime currentBarTimeArray[1];                     
static datetime previousBarTime = 0;

double bidPrice, askPrice, lastPrice;

double upperBandValue, middleBandValue, lowerBandValue;
double prevUpperBandValue, prevMiddleBandValue, prevLowerBandValue;
double upperBand[], middleBand[], lowerBand[];

string statePositions;
int bbHandle;

double prevOpenPrice;
double prevHighPrice;
double prevLowPrice;
double prevClosePrice;

double headBarSide;
double bodyBarSide;
double tailBarSide;
double barSide;

double pip_value; // Giá trị của 1 pip
input double lotSize = 0.05;
double slPrice;
double entryPrice;
CPositionInfo position;

int OnInit() {
   bbHandle = iBands(Symbol(), PERIOD_CURRENT, 20, 0, 2, PRICE_CLOSE);
   pip_value = SymbolInfoDouble(_Symbol, SYMBOL_POINT); // Giá trị của 1 pip
   return(INIT_SUCCEEDED);
}
  
  
void OnDeinit(const int reason) {}


void OnTick() {

   updateBollingerBands();
   updatePrice();
   
   Comment(
        "bidPrice: " , bidPrice , "\n",
        "askPrice: " , askPrice , "\n",
        "lastPrice: ", lastPrice, "\n",
        "prevUpperBandValue: " , prevUpperBandValue , "\n",
        "prevMiddleBandValue: " , prevMiddleBandValue , "\n",
        "prevLowerBandValue: ", prevLowerBandValue, "\n"
   );
   
   if(isNewBar() && PositionsTotal() == 0){
      // Lấy giá của nến trước đó
      prevOpenPrice = iOpen(Symbol(), PERIOD_CURRENT, 1);
      prevHighPrice = iHigh(Symbol(), PERIOD_CURRENT, 1);
      prevLowPrice = iLow(Symbol(), PERIOD_CURRENT, 1);
      prevClosePrice = iClose(Symbol(), PERIOD_CURRENT, 1);

   // Kiểm tra xem nến trước đó có phải là Pin Bar tăng không
      if (isPinBarUp() && prevPriceHitLowerBand())
      {
         Buy(prevLowPrice);
         Buy(prevLowPrice);
         statePositions="buy";
         
      }
      
      if (isPinBarDown() && prevPriceHitUpperBand())
      {
         Sell(prevHighPrice);
         Sell(prevHighPrice);
         statePositions="sell";
      }
   }
   
   if(PositionsTotal() > 0){
   
      if((PositionsTotal() == 2 && lastPrice >= middleBandValue && statePositions == "buy") ||
         (PositionsTotal() == 2 && lastPrice <= middleBandValue && statePositions == "sell"))
      {
         Close();
         changeSL();
      }
      
      if((PositionsTotal() == 1 && lastPrice >= upperBandValue && statePositions == "buy") ||
          PositionsTotal() == 1 && lastPrice <= lowerBandValue && statePositions == "sell"
      ) Close();
      
   }
}
  
  
 bool isNewBar(){
    // Sao chép thời gian của nến hiện tại vào mảng
    if (CopyTime(Symbol(), Period(), 0, 1, currentBarTimeArray) > 0)
    {
        datetime currentBarTime = currentBarTimeArray[0];

        // Kiểm tra xem thời gian nến hiện tại có khác với thời gian nến trước đó
        if (currentBarTime != previousBarTime)
        {
            // Cập nhật thời gian nến trước đó
            previousBarTime = currentBarTime;

            // Thực hiện các hành động cần thiết khi có nến mới
            return true;
            // ...
        }
    }
    else
    {
        Print("Lỗi khi sao chép thời gian nến: ", GetLastError());
    }
    return false;
 }
 

void updatePrice() {
   bidPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   askPrice = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   lastPrice = SymbolInfoDouble(Symbol(), SYMBOL_LAST);
}


void updateBollingerBands() {

   ArraySetAsSeries(upperBand, true);
   ArraySetAsSeries(middleBand, true);
   ArraySetAsSeries(lowerBand, true);
   
   
   CopyBuffer(bbHandle, 1, 0, 2, upperBand);   // Dải trên
   CopyBuffer(bbHandle, 0, 0, 2, middleBand);  // Dải giữa
   CopyBuffer(bbHandle, 2, 0, 2, lowerBand);   // Dải dưới
   
   
   upperBandValue = upperBand[0];
   middleBandValue = middleBand[0];
   lowerBandValue = lowerBand[0];
   
   prevUpperBandValue = upperBand[1];
   prevMiddleBandValue = middleBand[1];
   prevLowerBandValue = lowerBand[1];
}
  
void Buy(double prevLowPrice) {
   slPrice = prevLowPrice - 200 * pip_value;
   Print("prevLowPrice:", prevLowPrice);
   Print("sl:", slPrice);
   if (!trade.Buy(lotSize, Symbol(), 0, slPrice, 0)) {
      Print("Lỗi mở lệnh Buy: ", GetLastError());
   }
}

void Sell(double prevHighPrice) {
   slPrice = prevHighPrice + 200 * pip_value;
   Print("prevHighPrice:", prevHighPrice);
   Print("sl:", slPrice);
   if (!trade.Sell(lotSize, Symbol(), 0, slPrice, 0)) {
      Print("Lỗi mở lệnh Sell: ", GetLastError());
   }
}

void Close() {
   trade.PositionClose(PositionGetTicket(0));
}

void changeSL() {
     if (position.SelectByTicket(PositionGetTicket(0)))
   {
      entryPrice = position.PriceOpen();
      if (trade.PositionModify(PositionGetTicket(0), entryPrice, 0)){
         Print("Thay đổi Stop Loss thành công.");
      } else
         Print("Lỗi khi thay đổi Stop Loss: ", GetLastError());
   }
}

bool isPinBarUp() {
   barSide = prevHighPrice - prevLowPrice;
   
   if(prevOpenPrice > prevClosePrice) {
      bodyBarSide = prevOpenPrice - prevClosePrice;
      tailBarSide = prevClosePrice - prevLowPrice;
      headBarSide = prevHighPrice - prevOpenPrice;
   } else {
      bodyBarSide = prevClosePrice - prevOpenPrice;
      tailBarSide = prevOpenPrice - prevLowPrice;
      headBarSide = prevHighPrice - prevClosePrice;
   }
   
   if(barSide != 0){
      if(bodyBarSide/barSide < 1.0/3 && tailBarSide >= headBarSide) {
         return true;
      }
   }
   
   return false;
}

bool isPinBarDown() {
   barSide = prevHighPrice - prevLowPrice;

   
   if(prevOpenPrice > prevClosePrice) {
      bodyBarSide = prevOpenPrice - prevClosePrice;
      tailBarSide = prevClosePrice - prevLowPrice;
      headBarSide = prevHighPrice - prevOpenPrice;
   } else {
      bodyBarSide = prevClosePrice - prevOpenPrice;
      tailBarSide = prevOpenPrice - prevLowPrice;
      headBarSide = prevHighPrice - prevClosePrice;
   }
   
   if(barSide != 0){
      if(bodyBarSide/barSide < 1.0/3 && tailBarSide <= headBarSide) {
         return true;
      }
   }
   
   return false;
}

bool prevPriceHitLowerBand() {

   if(prevClosePrice > prevLowerBandValue &&
      prevOpenPrice > prevLowerBandValue &&
      prevHighPrice > prevLowerBandValue &&
      prevLowPrice > prevLowerBandValue) {return false;}
    return true;
}

bool prevPriceHitUpperBand() {

   if(prevClosePrice < prevUpperBandValue &&
      prevOpenPrice < prevUpperBandValue &&
      prevHighPrice < prevUpperBandValue &&
      prevLowPrice < prevUpperBandValue) {return false;}
    return true;
}
