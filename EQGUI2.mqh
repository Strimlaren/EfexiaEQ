//+------------------------------------------------------------------+
//|                                                       EQGUI2.mqh |
//|                                                    Efexia Sweden |
//|                                                   www.efexia.com |
//+------------------------------------------------------------------+
#property copyright "Efexia Sweden 2022"
#property link      "www.efexia.com"
#property strict

#include <Trade/SymbolInfo.mqh>
#include <Trade/Trade.mqh>
#include <Layouts/Box.mqh>
#include <Controls/Dialog.mqh>
#include <Controls/Edit.mqh>
#include <Controls/Label.mqh>
#include <Controls/Button.mqh>
#include <Controls/CheckBox.mqh>
#include <Controls/ComboBox.mqh>
#include <Strings/String.mqh>

#define CONTROL_WIDTH   (90)
#define CONTROL_HEIGHT  (20)
#define LINK_WIDTH      (20)

string   accounts[100];
long     files_handle;
int      counter, findbin;
ulong    myticket    = 0;
bool     sounded_1, sounded_2, sounded_3, sounded_4, sounded_5, sounded_6;
double   tempeq[1], tempeq2[1], tempeq3[1], tempeq4[1], tempeq5[1], equityarray[1];
double   totaleq, closed_PL, open_PL, dealstotal, totalequity, equity, value2, value3, value4, value5;
string   check1;

color    top_label_color   =  C'0,0,0';

CTrade mTradeui;
class CControlsDialog : public CAppDialog
  {
protected:
   CSymbolInfo      *m_symbol;
   CBox              m_main;

   CBox              m_label_row;
   CLabel            m_top_label_1;
   CLabel            m_top_label_2;
   CLabel            m_top_label_3;
   CLabel            m_top_label_4;
   CLabel            m_top_label_5;
   CLabel            m_top_label_6;

   CBox              m_item_row_1;
   CCheckBox         m_checkbox_1;
   CLabel            m_current_account;
   CEdit             m_edit_1;
   CEdit             m_edit_11;
   CCheckBox         m_checkbox_11;
   CEdit             m_edit_111;

   CBox              m_item_row_2;
   CCheckBox         m_checkbox_2;
   CComboBox         m_combobox_2;
   CEdit             m_edit_2;
   CEdit             m_edit_22;
   CCheckBox         m_checkbox_22;
   CEdit             m_edit_222;

   CBox              m_item_row_3;
   CCheckBox         m_checkbox_3;
   CComboBox         m_combobox_3;
   CEdit             m_edit_3;
   CEdit             m_edit_33;
   CCheckBox         m_checkbox_33;
   CEdit             m_edit_333;

   CBox              m_item_row_4;
   CCheckBox         m_checkbox_4;
   CComboBox         m_combobox_4;
   CEdit             m_edit_4;
   CEdit             m_edit_44;
   CCheckBox         m_checkbox_44;
   CEdit             m_edit_444;

   CBox              m_item_row_5;
   CCheckBox         m_checkbox_5;
   CComboBox         m_combobox_5;
   CEdit             m_edit_5;
   CEdit             m_edit_55;
   CCheckBox         m_checkbox_55;
   CEdit             m_edit_555;

   CBox              m_button_row;
   CLabel            m_empty_label;
   CLabel            m_empty_label_2;
   CLabel            m_sum_equity_label;
   CEdit             m_sum_equity;
   CCheckBox         m_checkbox_66;
   CEdit             m_edit_666;

   CBox              m_button_row2;
   CButton           m_button;

public:
                     CControlsDialog();
                    ~CControlsDialog();
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   void              UpdateValues();
   void              SaveGlobals();
   void              CheckAlarms();
protected:
   virtual bool      CreateMain(const long chart,const string name,const int subwin);
   virtual bool      CreateLabelRow(const long chart,const string name,const int subwin);
   virtual bool      CreateItemRow1(const long chart,const string name,const int subwin);
   virtual bool      CreateItemRow2(const long chart,const string name,const int subwin);
   virtual bool      CreateItemRow3(const long chart,const string name,const int subwin);
   virtual bool      CreateItemRow4(const long chart,const string name,const int subwin);
   virtual bool      CreateItemRow5(const long chart,const string name,const int subwin);
   virtual bool      CreateButtonRow(const long chart,const string name,const int subwin);
   virtual bool      CreateButtonRow2(const long chart,const string name,const int subwin);
   void              OnClickButton();
   void              OnChangeCheckBox();
   string            NumSep(double number);
  };

EVENT_MAP_BEGIN(CControlsDialog)
   ON_EVENT(ON_CLICK,m_button,OnClickButton)
   ON_EVENT(ON_CHANGE,m_checkbox_11,OnChangeCheckBox)
   ON_EVENT(ON_CHANGE,m_checkbox_22,OnChangeCheckBox)
   ON_EVENT(ON_CHANGE,m_checkbox_33,OnChangeCheckBox)
   ON_EVENT(ON_CHANGE,m_checkbox_44,OnChangeCheckBox)
   ON_EVENT(ON_CHANGE,m_checkbox_55,OnChangeCheckBox)
   ON_EVENT(ON_CHANGE,m_checkbox_66,OnChangeCheckBox)
EVENT_MAP_END(CAppDialog)

CControlsDialog::CControlsDialog(void)
  {
  }
CControlsDialog::~CControlsDialog(void)
  {
   if(m_symbol!=NULL)
     {
      delete m_symbol;
      m_symbol=NULL;
     }
  }
bool CControlsDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if (m_symbol==NULL) m_symbol=new CSymbolInfo();
   if(m_symbol!=NULL)
   {
      if (!m_symbol.Name(_Symbol))
         return(false);
   }   
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
   if(!CreateMain(chart,name,subwin))
      return(false);
   if(!CreateLabelRow(chart,name,subwin))
      return(false);
   if(!CreateItemRow1(chart,name,subwin))
      return(false);
   if(!CreateItemRow2(chart,name,subwin))
      return(false);
   if(!CreateItemRow3(chart,name,subwin))
      return(false);
   if(!CreateItemRow4(chart,name,subwin))
      return(false);
   if(!CreateItemRow5(chart,name,subwin))
      return(false);
   if(!CreateButtonRow(chart,name,subwin))
      return(false);
   if(!CreateButtonRow2(chart,name,subwin))
      return(false);
   if(!m_main.Add(m_label_row))
      return(false);
   if(!m_main.Add(m_item_row_1))
      return(false);
   if(!m_main.Add(m_item_row_2))
      return(false);
   if(!m_main.Add(m_item_row_3))
      return(false);
   if(!m_main.Add(m_item_row_4))
      return(false);
   if(!m_main.Add(m_item_row_5))
      return(false);
   if(!m_main.Add(m_button_row))
      return(false);
   if(!m_main.Add(m_button_row2))
      return(false);
   if (!m_main.Pack())
      return(false);
   if (!Add(m_main))
      return(false);
   return(true);
  }
bool CControlsDialog::CreateMain(const long chart,const string name,const int subwin)
  {
   if(!m_main.Create(chart,name+"main",subwin,0,0,CDialog::ClientAreaWidth(),CDialog::ClientAreaHeight()))
      return(false);
   m_main.LayoutStyle(LAYOUT_STYLE_VERTICAL);
   m_main.Padding(10);
   m_main.BringToTop();
   return(true);
  }
bool CControlsDialog::CreateLabelRow(const long chart,const string name,const int subwin)
  {
   if(!m_label_row.Create(chart,name+"label_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT*1.5))
      return(false);

   if(!m_top_label_1.Create(chart,name+"top_label_1",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   m_top_label_1.Text(" Σ");
   m_top_label_1.Color(top_label_color);
   if(!m_top_label_2.Create(chart,name+"top_label_2",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   m_top_label_2.Text(" Account #");
   m_top_label_2.Color(top_label_color);
   if(!m_top_label_3.Create(chart,name+"top_label_3",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   m_top_label_3.Text("Start Equity");
   m_top_label_3.Color(top_label_color);
   if(!m_top_label_4.Create(chart,name+"top_label_4",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   m_top_label_4.Text("P&L / Equity");
   m_top_label_4.Color(top_label_color);
   if(!m_top_label_5.Create(chart,name+"top_label_5",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   m_top_label_5.Text(" ♪♪");
   m_top_label_5.Color(top_label_color);
   if(!m_top_label_6.Create(chart,name+"top_label_6",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   m_top_label_6.Text(" Alarm Level");
   m_top_label_6.Color(top_label_color);


   if(!m_label_row.Add(m_top_label_1))
      return(false);
   if(!m_label_row.Add(m_top_label_2))
      return(false);
   if(!m_label_row.Add(m_top_label_3))
      return(false);
   if(!m_label_row.Add(m_top_label_4))
      return(false);
   if(!m_label_row.Add(m_top_label_5))
      return(false);
   if(!m_label_row.Add(m_top_label_6))
      return(false);  

   return(true);
  }
bool CControlsDialog::CreateItemRow1(const long chart,const string name,const int subwin)
  {
   if(!m_item_row_1.Create(chart,name+"item_row_1",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT*1.5))
      return(false);

   if(!m_checkbox_1.Create(chart,name+"checkbox_1",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_current_account.Create(chart,name+"combobox_1",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
      m_current_account.Color(C'150,150,150');
   if(!m_edit_1.Create(chart,name+"edit_1",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_11.Create(chart,name+"edit_11",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_checkbox_11.Create(chart,name+"checkbox_11",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_111.Create(chart,name+"edit_111",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);

   m_edit_111.TextAlign(ALIGN_RIGHT);
   m_edit_11.ReadOnly(true);
   m_edit_11.ColorBackground(C'215,215,215');
   m_edit_11.TextAlign(ALIGN_RIGHT);
   m_edit_1.Text("");
   m_edit_1.TextAlign(ALIGN_RIGHT);
   m_checkbox_1.Text("");
   m_checkbox_11.Text("");
   m_current_account.Text(" " + (string)AccountInfoInteger(ACCOUNT_LOGIN));

   if(GlobalVariableGet("check1") == 1) m_checkbox_1.Checked(true);
   else m_checkbox_1.Checked(false);
   m_edit_1.Text((string)GlobalVariableGet("starteq1"));
   if(GlobalVariableGet("check11") == 1) m_checkbox_11.Checked(true);
   else m_checkbox_11.Checked(false);
   m_edit_111.Text((string)GlobalVariableGet("larmlevel1"));

   if(!m_item_row_1.Add(m_checkbox_1))
      return(false);
   if(!m_item_row_1.Add(m_current_account))
      return(false);
   if(!m_item_row_1.Add(m_edit_1))
      return(false);
   if(!m_item_row_1.Add(m_edit_11))
      return(false);
   if(!m_item_row_1.Add(m_checkbox_11))
      return(false);
   if(!m_item_row_1.Add(m_edit_111))
      return(false);
   
   return(true);
  }
bool CControlsDialog::CreateItemRow2(const long chart,const string name,const int subwin)
  {
   if(!m_item_row_2.Create(chart,name+"item_row_2",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT*1.5))
      return(false);

   if(!m_checkbox_2.Create(chart,name+"checkbox_2",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_combobox_2.Create(chart,name+"combobox_2",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_2.Create(chart,name+"edit_2",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_22.Create(chart,name+"edit_22",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_checkbox_22.Create(chart,name+"checkbox_22",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_222.Create(chart,name+"edit_222",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);

   m_edit_222.TextAlign(ALIGN_RIGHT);
   m_edit_22.ReadOnly(true);
   m_edit_22.ColorBackground(C'215,215,215');
   m_edit_22.TextAlign(ALIGN_RIGHT);
   m_edit_2.Text("");
   m_edit_2.TextAlign(ALIGN_RIGHT);
   m_checkbox_2.Text("");
   m_checkbox_22.Text("");
   m_combobox_2.SelectByText("#");

   counter = 1;
   files_handle = FileFindFirst("EfexiaEQ/*", accounts[0], FILE_COMMON);
   while(FileFindNext(files_handle, accounts[counter++]));
   for(int u = 0; u < counter; u++)
   {
      findbin = StringFind(accounts[u], ".bin", 0);
      accounts[u] = StringSubstr(accounts[u], 0, findbin);
   }
   FileFindClose(files_handle);
   for(int i = 0; i < counter - 1; i++) m_combobox_2.AddItem(accounts[i]);      
   m_combobox_2.AddItem("#");

   if(!m_item_row_2.Add(m_checkbox_2))
      return(false);
   if(!m_item_row_2.Add(m_combobox_2))
      return(false);
   if(!m_item_row_2.Add(m_edit_2))
      return(false);
   if(!m_item_row_2.Add(m_edit_22))
      return(false);
   if(!m_item_row_2.Add(m_checkbox_22))
      return(false);
   if(!m_item_row_2.Add(m_edit_222))
      return(false);

   if(GlobalVariableGet("check2") == 1) m_checkbox_2.Checked(true);
   else m_checkbox_2.Checked(false);
   m_combobox_2.SelectByValue((long)GlobalVariableGet("combo2"));
   m_edit_2.Text((string)GlobalVariableGet("starteq2"));
   if(GlobalVariableGet("check22") == 1) m_checkbox_22.Checked(true);
   else m_checkbox_22.Checked(false);
   m_edit_222.Text((string)GlobalVariableGet("larmlevel2"));
   
   return(true);
  }
bool CControlsDialog::CreateItemRow3(const long chart,const string name,const int subwin)
  {
   if(!m_item_row_3.Create(chart,name+"item_row_3",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT*1.5))
      return(false);

   if(!m_checkbox_3.Create(chart,name+"checkbox_3",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_combobox_3.Create(chart,name+"combobox_3",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_3.Create(chart,name+"edit_3",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_33.Create(chart,name+"edit_33",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_checkbox_33.Create(chart,name+"checkbox_33",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_333.Create(chart,name+"edit_333",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);

   m_edit_333.TextAlign(ALIGN_RIGHT);
   m_edit_33.ReadOnly(true);
   m_edit_33.ColorBackground(C'215,215,215');
   m_edit_33.TextAlign(ALIGN_RIGHT);
   m_edit_3.Text("");
   m_edit_3.TextAlign(ALIGN_RIGHT);
   m_checkbox_3.Text("");
   m_checkbox_33.Text("");
   m_combobox_3.SelectByText("#");

   counter = 1;
   files_handle = FileFindFirst("EfexiaEQ/*", accounts[0], FILE_COMMON);
   while(FileFindNext(files_handle, accounts[counter++]));
   for(int u = 0; u < counter; u++)
   {
      findbin = StringFind(accounts[u], ".bin", 0);
      accounts[u] = StringSubstr(accounts[u], 0, findbin);
   }
   FileFindClose(files_handle);
   for(int i = 0; i < counter - 1; i++) m_combobox_3.AddItem(accounts[i]);     
   m_combobox_3.AddItem("#"); 

   if(!m_item_row_3.Add(m_checkbox_3))
      return(false);
   if(!m_item_row_3.Add(m_combobox_3))
      return(false);
   if(!m_item_row_3.Add(m_edit_3))
      return(false);
   if(!m_item_row_3.Add(m_edit_33))
      return(false);
   if(!m_item_row_3.Add(m_checkbox_33))
      return(false);
   if(!m_item_row_3.Add(m_edit_333))
      return(false);

   if(GlobalVariableGet("check3") == 1) m_checkbox_3.Checked(true);
   else m_checkbox_3.Checked(false);
   m_combobox_3.SelectByValue((long)GlobalVariableGet("combo3"));
   m_edit_3.Text((string)GlobalVariableGet("starteq3"));
   if(GlobalVariableGet("check33") == 1) m_checkbox_33.Checked(true);
   else m_checkbox_33.Checked(false);
   m_edit_333.Text((string)GlobalVariableGet("larmlevel3"));
   
   return(true);
  }
bool CControlsDialog::CreateItemRow4(const long chart,const string name,const int subwin)
  {
   if(!m_item_row_4.Create(chart,name+"item_row_4",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT*1.5))
      return(false);

   if(!m_checkbox_4.Create(chart,name+"checkbox_4",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_combobox_4.Create(chart,name+"combobox_4",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_4.Create(chart,name+"edit_4",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_44.Create(chart,name+"edit_44",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_checkbox_44.Create(chart,name+"checkbox_44",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_444.Create(chart,name+"edit_444",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);

   m_edit_444.TextAlign(ALIGN_RIGHT);
   m_edit_44.ReadOnly(true);
   m_edit_44.ColorBackground(C'215,215,215');
   m_edit_44.TextAlign(ALIGN_RIGHT);
   m_edit_4.Text("");
   m_edit_4.TextAlign(ALIGN_RIGHT);
   m_checkbox_4.Text("");
   m_checkbox_44.Text("");
   m_combobox_4.SelectByText("#");

   counter = 1;
   files_handle = FileFindFirst("EfexiaEQ/*", accounts[0], FILE_COMMON);
   while(FileFindNext(files_handle, accounts[counter++]));
   for(int u = 0; u < counter; u++)
   {
      findbin = StringFind(accounts[u], ".bin", 0);
      accounts[u] = StringSubstr(accounts[u], 0, findbin);
   }
   FileFindClose(files_handle);
   for(int i = 0; i < counter - 1; i++) m_combobox_4.AddItem(accounts[i]);      
   m_combobox_4.AddItem("#");

   if(!m_item_row_4.Add(m_checkbox_4))
      return(false);
   if(!m_item_row_4.Add(m_combobox_4))
      return(false);
   if(!m_item_row_4.Add(m_edit_4))
      return(false);
   if(!m_item_row_4.Add(m_edit_44))
      return(false);
   if(!m_item_row_4.Add(m_checkbox_44))
      return(false);
   if(!m_item_row_4.Add(m_edit_444))
      return(false);

   if(GlobalVariableGet("check4") == 1) m_checkbox_4.Checked(true);
   else m_checkbox_4.Checked(false);
   m_combobox_4.SelectByValue((long)GlobalVariableGet("combo4"));
   m_edit_4.Text((string)GlobalVariableGet("starteq4"));
   if(GlobalVariableGet("check44") == 1) m_checkbox_44.Checked(true);
   else m_checkbox_44.Checked(false);
   m_edit_444.Text((string)GlobalVariableGet("larmlevel4"));
   
   return(true);
  }
bool CControlsDialog::CreateItemRow5(const long chart,const string name,const int subwin)
  {
   if(!m_item_row_5.Create(chart,name+"item_row_5",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT*1.5))
      return(false);
      m_item_row_5.HorizontalAlign(HORIZONTAL_ALIGN_CENTER);

   if(!m_checkbox_5.Create(chart,name+"checkbox_5",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_combobox_5.Create(chart,name+"combobox_5",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_5.Create(chart,name+"edit_5",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_55.Create(chart,name+"edit_55",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_checkbox_55.Create(chart,name+"checkbox_55",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_555.Create(chart,name+"edit_555",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);

   m_edit_555.TextAlign(ALIGN_RIGHT);
   m_edit_55.ReadOnly(true);
   m_edit_55.ColorBackground(C'215,215,215');
   m_edit_55.TextAlign(ALIGN_RIGHT);
   m_edit_5.Text("");
   m_edit_5.TextAlign(ALIGN_RIGHT);
   m_checkbox_5.Text("");
   m_checkbox_55.Text("");
   m_combobox_5.SelectByText("#");

   counter = 1;
   files_handle = FileFindFirst("EfexiaEQ/*", accounts[0], FILE_COMMON);
   while(FileFindNext(files_handle, accounts[counter++]));
   for(int u = 0; u < counter; u++)
   {
      findbin = StringFind(accounts[u], ".bin", 0);
      accounts[u] = StringSubstr(accounts[u], 0, findbin);
   }
   FileFindClose(files_handle);
   for(int i = 0; i < counter - 1; i++) m_combobox_5.AddItem(accounts[i]);      
   m_combobox_5.AddItem("#");

   if(!m_item_row_5.Add(m_checkbox_5))
      return(false);
   if(!m_item_row_5.Add(m_combobox_5))
      return(false);
   if(!m_item_row_5.Add(m_edit_5))
      return(false);
   if(!m_item_row_5.Add(m_edit_55))
      return(false);
   if(!m_item_row_5.Add(m_checkbox_55))
      return(false);
   if(!m_item_row_5.Add(m_edit_555))
      return(false);

   if(GlobalVariableGet("check5") == 1) m_checkbox_5.Checked(true);
   else m_checkbox_5.Checked(false);
   m_combobox_5.SelectByValue((long)GlobalVariableGet("combo5"));
   m_edit_5.Text((string)GlobalVariableGet("starteq5"));
   if(GlobalVariableGet("check55") == 1) m_checkbox_55.Checked(true);
   else m_checkbox_55.Checked(false);
   m_edit_555.Text((string)GlobalVariableGet("larmlevel5"));
   
   return(true);
  }
bool CControlsDialog::CreateButtonRow(const long chart,const string name,const int subwin)
  {
   if(!m_button_row.Create(chart,name+"button_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT*1.5))
      return(false);
   m_button_row.HorizontalAlign(HORIZONTAL_ALIGN_CENTER);
   
   if(!m_empty_label.Create(chart,name+"emptylabel",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_empty_label_2.Create(chart,name+"emptylabel2",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_sum_equity_label.Create(chart,name+"equity_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_sum_equity.Create(chart,name+"equitytotal",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_checkbox_66.Create(chart,name+"checkbox66",subwin,0,0,LINK_WIDTH,CONTROL_HEIGHT))
      return(false);
   if(!m_edit_666.Create(chart,name+"edit666",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
      return(false);

   m_sum_equity.ReadOnly(true);
   m_sum_equity.TextAlign(ALIGN_RIGHT);
   m_sum_equity.Text("0");
   m_sum_equity.ColorBackground(C'215,215,215');
   m_checkbox_66.Text("");
   m_edit_666.TextAlign(ALIGN_RIGHT);
  
   if(!m_button_row.Add(m_empty_label))
      return(false);
   m_empty_label.Text("");
   if(!m_button_row.Add(m_empty_label_2))
      return(false);
   m_empty_label_2.Text("");
   if(!m_button_row.Add(m_sum_equity_label))
      return(false);
   m_sum_equity_label.Text("Total Equity: ");
   if(!m_button_row.Add(m_sum_equity))
      return(false);
   if(!m_button_row.Add(m_checkbox_66))
      return(false);
   m_checkbox_66.Text("");
   if(!m_button_row.Add(m_edit_666))
      return(false);
   m_edit_666.Text("");

   if(GlobalVariableGet("check66") == 1) m_checkbox_66.Checked(true);
   else m_checkbox_66.Checked(false);
   m_edit_666.Text((string)GlobalVariableGet("larmlevel6"));

   return(true);
  }
bool CControlsDialog::CreateButtonRow2(const long chart,const string name,const int subwin)
  {
   if(!m_button_row2.Create(chart,name+"button_row2",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT*2))
      return(false);
      m_button_row2.HorizontalAlign(HORIZONTAL_ALIGN_CENTER);
   
   if(!m_button.Create(chart,name+"button_button",subwin,0,0,410,CONTROL_HEIGHT*1.5))
      return(false);
   m_button.Text("CLOSE ALL ORDERS AND POSITIONS");
   m_button.ColorBackground(C'255,75,75');
   m_button.ColorBorder(C'150,0,0');
   m_button.FontSize(10);
   m_button.Color(C'150,0,0');

   if(!m_button_row2.Add(m_button))
      return(false);
   return(true);
  }
void CControlsDialog::OnClickButton()
  {
   while(PositionsTotal() != 0)
     {
      for(int u = 0; u < PositionsTotal(); u++)
        {
         myticket = PositionGetTicket(u); PositionSelectByTicket(myticket);
         mTradeui.PositionClose(myticket, 5);
        }
 
      for(int y = 0; y < OrdersTotal(); y++)
        {
         myticket = OrderGetTicket(y); OrderSelect(myticket);
         mTradeui.OrderDelete(myticket); 
        }

       ObjectSetInteger(0,"CloseButton",OBJPROP_STATE, false);
    }
  }
void CControlsDialog::UpdateValues()
{
   closed_PL = 0;
   open_PL = 0;
   value2 = 0;
   value3 = 0;
   value4 = 0;
   value5 = 0;

   HistorySelect(0, TimeCurrent());
   for(int i = 0; i < HistoryDealsTotal(); i++)
   {
      myticket = HistoryDealGetTicket(i);
      if(HistoryDealGetInteger(myticket, DEAL_TYPE) == 0 || HistoryDealGetInteger(myticket, DEAL_TYPE) == 1) closed_PL = closed_PL  + HistoryDealGetDouble(myticket, DEAL_PROFIT) 
                                                                                                                                    + HistoryDealGetDouble(myticket, DEAL_SWAP)
                                                                                                                                    + HistoryDealGetDouble(myticket, DEAL_COMMISSION);
   }
   for(int u = 0; u < PositionsTotal(); u++)
   {
      myticket = PositionGetTicket(u); PositionSelectByTicket(myticket);
      open_PL += PositionGetDouble(POSITION_PROFIT);
   }
   equity = (double)m_edit_1.Text() + closed_PL + open_PL;
   equityarray[0] = closed_PL + open_PL;
   FileSave("EfexiaEQ/" + (string)AccountInfoInteger(ACCOUNT_LOGIN) + ".bin", equityarray, FILE_COMMON);
   m_edit_11.Text((string)NumSep(equity));

   FileLoad("EfexiaEQ/" + (string)m_combobox_2.Select() + ".bin", tempeq2, FILE_COMMON);
   value2 = tempeq2[0] + (double)m_edit_2.Text();
   if(m_combobox_2.Select() != "#") m_edit_22.Text((string)NumSep(value2));
   else m_edit_22.Text("0.0");

   FileLoad("EfexiaEQ/" + (string)m_combobox_3.Select() + ".bin", tempeq3, FILE_COMMON);
   value3 = tempeq3[0] + (double)m_edit_3.Text();
   if(m_combobox_3.Select() != "#") m_edit_33.Text((string)NumSep(value3));
   else m_edit_33.Text("0.0");

   FileLoad("EfexiaEQ/" + (string)m_combobox_4.Select() + ".bin", tempeq4, FILE_COMMON);
   value4 = tempeq4[0] + (double)m_edit_4.Text();
   if(m_combobox_4.Select() != "#") m_edit_44.Text((string)NumSep(value4));
   else m_edit_44.Text("0.0");

   FileLoad("EfexiaEQ/" + (string)m_combobox_5.Select() + ".bin", tempeq5, FILE_COMMON);
   value5 = tempeq5[0] + (double)m_edit_5.Text();
   if(m_combobox_5.Select() != "#") m_edit_55.Text((string)NumSep(value5));
   else m_edit_55.Text("0.0");

   totaleq = 0;
   if(m_checkbox_1.Checked()) totaleq += equity;
   if(m_checkbox_2.Checked()) totaleq += value2;
   if(m_checkbox_3.Checked()) totaleq += value3;
   if(m_checkbox_4.Checked()) totaleq += value4;
   if(m_checkbox_5.Checked()) totaleq += value5;
   m_sum_equity.Text((string)NumSep(totaleq));   
}
void CControlsDialog::SaveGlobals()
{
   if(m_checkbox_1.Checked() == true) GlobalVariableSet("check1", 1);
   else GlobalVariableSet("check1", 0);
   if(m_checkbox_2.Checked() == true) GlobalVariableSet("check2", 1);
   else GlobalVariableSet("check2", 0);
   if(m_checkbox_3.Checked() == true) GlobalVariableSet("check3", 1);
   else GlobalVariableSet("check3", 0);
   if(m_checkbox_4.Checked() == true) GlobalVariableSet("check4", 1);
   else GlobalVariableSet("check4", 0);
   if(m_checkbox_5.Checked() == true) GlobalVariableSet("check5", 1);
   else GlobalVariableSet("check5", 0);

   GlobalVariableSet("combo2", m_combobox_2.Value());
   GlobalVariableSet("combo3", m_combobox_3.Value());
   GlobalVariableSet("combo4", m_combobox_4.Value());
   GlobalVariableSet("combo5", m_combobox_5.Value());
   
   GlobalVariableSet("starteq1", (double)m_edit_1.Text());
   GlobalVariableSet("starteq2", (double)m_edit_2.Text());
   GlobalVariableSet("starteq3", (double)m_edit_3.Text());
   GlobalVariableSet("starteq4", (double)m_edit_4.Text());
   GlobalVariableSet("starteq5", (double)m_edit_5.Text());

   if(m_checkbox_11.Checked() == true) GlobalVariableSet("check11", 1);
   else GlobalVariableSet("check11", 0);
   if(m_checkbox_22.Checked() == true) GlobalVariableSet("check22", 1);
   else GlobalVariableSet("check22", 0);
   if(m_checkbox_33.Checked() == true) GlobalVariableSet("check33", 1);
   else GlobalVariableSet("check33", 0);
   if(m_checkbox_44.Checked() == true) GlobalVariableSet("check44", 1);
   else GlobalVariableSet("check44", 0);
   if(m_checkbox_55.Checked() == true) GlobalVariableSet("check55", 1);
   else GlobalVariableSet("check55", 0);
   if(m_checkbox_66.Checked() == true) GlobalVariableSet("check66", 1);
   else GlobalVariableSet("check66", 0);

   GlobalVariableSet("larmlevel1", (double)m_edit_111.Text());
   GlobalVariableSet("larmlevel2", (double)m_edit_222.Text());
   GlobalVariableSet("larmlevel3", (double)m_edit_333.Text());
   GlobalVariableSet("larmlevel4", (double)m_edit_444.Text());
   GlobalVariableSet("larmlevel5", (double)m_edit_555.Text());
   GlobalVariableSet("larmlevel6", (double)m_edit_666.Text());

   GlobalVariableSet("XUL", (double)m_main.Left());
   GlobalVariableSet("YUL", (double)m_main.Top());
   GlobalVariableSet("XLR", (double)m_main.Right());
   GlobalVariableSet("YLR", (double)m_main.Bottom());
}
void CControlsDialog::CheckAlarms()
{
   if((double)equity < (double)m_edit_111.Text() && m_checkbox_11.Checked() == true && sounded_1 == false)
   {
      MessageBox("Account " + (string)AccountInfoInteger(ACCOUNT_LOGIN) + " below " + (string)m_edit_111.Text() + " equity.", "Equity Alert", MB_OK|MB_ICONSTOP);
      SendNotification("Account " + (string)AccountInfoInteger(ACCOUNT_LOGIN) + " below " + (string)m_edit_111.Text() + " equity.");
      sounded_1 = true;
      m_edit_111.Text("0.0");
      m_checkbox_11.Checked(false);
   }

   if(value2 < (double)m_edit_222.Text() && m_checkbox_22.Checked() == true && sounded_2 == false)
   {
      MessageBox("Account " + m_combobox_2.Select() + " below " + m_edit_222.Text() + " equity.", "Equity Alert", MB_OK|MB_ICONSTOP);
      SendNotification("Account " + m_combobox_2.Select() + " below " + m_edit_222.Text() + " equity.");
      sounded_2 = true;
      m_edit_111.Text("0.0");
      m_checkbox_22.Checked(false);
   }

   if(value3 < (double)m_edit_333.Text() && m_checkbox_33.Checked() == true && sounded_3 == false)
   {
      MessageBox("Account " + m_combobox_3.Select() + " below " + m_edit_333.Text() + " equity.", "Equity Alert", MB_OK|MB_ICONSTOP);
      SendNotification("Account " + m_combobox_3.Select() + " below " + m_edit_333.Text() + " equity.");
      sounded_3 = true;
      m_edit_111.Text("0.0");
      m_checkbox_33.Checked(false);
   }

   if(value4 < (double)m_edit_444.Text() && m_checkbox_44.Checked() == true && sounded_4 == false)
   {
      MessageBox("Account " + m_combobox_4.Select() + " below " + m_edit_444.Text() + " equity.", "Equity Alert", MB_OK|MB_ICONSTOP);
      SendNotification("Account " + m_combobox_4.Select() + " below " + m_edit_444.Text() + " equity.");
      sounded_4 = true;
      m_edit_111.Text("0.0");
      m_checkbox_44.Checked(false);
   }

   if(value5 < (double)m_edit_555.Text() && m_checkbox_55.Checked() == true && sounded_5 == false)
   { 
      MessageBox("Account " + m_combobox_5.Select() + " below " + m_edit_555.Text() + " equity.", "Equity Alert", MB_OK|MB_ICONSTOP);
      SendNotification("Account " + m_combobox_5.Select() + " below " + m_edit_555.Text() + " equity.");
      sounded_5 = true;
      m_edit_111.Text("0.0");
      m_checkbox_55.Checked(false);
   }

   if(totaleq < (double)m_edit_666.Text() && m_checkbox_66.Checked() == true && sounded_6 == false)
   {
      MessageBox("Total equity below " + (string)m_edit_666.Text() + ".", "Equity Alert", MB_OK|MB_ICONSTOP);
      SendNotification("Total equity below " + (string)m_edit_666.Text() + ".");
      sounded_6 = true;
      m_edit_111.Text("0.0");
      m_checkbox_66.Checked(false);
   }
}
void CControlsDialog::OnChangeCheckBox()
{
   if(sounded_1 == true) sounded_1 = false;
   if(sounded_2 == true) sounded_2 = false;
   if(sounded_3 == true) sounded_3 = false;
   if(sounded_4 == true) sounded_4 = false;
   if(sounded_5 == true) sounded_5 = false;
   if(sounded_6 == true) sounded_6 = false;
}
string CControlsDialog::NumSep(double number)
{
   CString num_str;
   string prepend = number<0?"-":"";
   number=number<0?-number:number;
   int decimal_index = -1;
   if(typename(number)=="double" || typename(number)=="float")
   {
      num_str.Assign(DoubleToString((double)number,1));
      decimal_index = num_str.Find(0,".");
   }
   else
      num_str.Assign(string(number));
   int len = (int)num_str.Len();
   decimal_index = decimal_index > 0 ? decimal_index : len; 
   int res = len - (len - decimal_index);
   for(int i = res-3;i>0;i-=3)
      num_str.Insert(i,",");
   return prepend+num_str.Str();
}