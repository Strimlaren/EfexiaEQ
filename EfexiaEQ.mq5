//+------------------------------------------------------------------+
//|                                                     EfexiaEQ.mq5 |
//|                                                  Mirza Mesinovic |
//|                                                   www.efexia.com |
//+------------------------------------------------------------------+
#property copyright "Copyright Efexia 2022"
#property link      "www.efexia.com"
#property version   "1.1"

#include <Trade/Trade.mqh>
#include "EQGUI2.mqh"

CTrade mTrade;
CControlsDialog GUI;

int OnInit()
{
  EventSetMillisecondTimer(50);

  if(GlobalVariableCheck("XUL"))
  {
    if(!GUI.Create(0,"EfexiaEQ Control Panel",0,(int)GlobalVariableGet("XUL")-4,
                                                (int)GlobalVariableGet("YUL")-24,
                                                (int)GlobalVariableGet("XLR")+4,
                                                (int)GlobalVariableGet("YLR")+4))
      return(INIT_FAILED);
    if(!GUI.Run())
      return(INIT_FAILED);
  }
  else
  {
    if(!GUI.Create(0,"EfexiaEQ Control Panel",0,3,90,450,330)) return(INIT_FAILED);
    if(!GUI.Run()) return(INIT_FAILED);
  }
  
  return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{ 
  EventKillTimer();
  GUI.SaveGlobals();
  //GlobalVariableDel("XUL");
  //GlobalVariableDel("YUL");
  //GlobalVariableDel("XLR");
  //GlobalVariableDel("YLR");
  GUI.Destroy(reason);
}

void OnTimer()
{
  GUI.UpdateValues();
  GUI.CheckAlarms();
}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
 GUI.ChartEvent(id,lparam,dparam,sparam);
}
