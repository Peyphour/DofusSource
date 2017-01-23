package com.ankamagames.dofus.misc.options
{
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.berilia.types.data.ExtendedStyleSheet;
   import com.ankamagames.dofus.types.DofusOptions;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.types.Callback;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public dynamic class ChatOptions extends OptionManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ChatOptions));
      
      public static const CSS_LOADED:String = "CSS_LOADED";
       
      
      public var colors:Array;
      
      public function ChatOptions()
      {
         this.colors = new Array();
         super("chat");
         add("channelLocked",false);
         add("filterInsult",true);
         add("letLivingObjectTalk",true);
         add("smileysAutoclosed",false);
         add("showTime",false);
         add("showShortcut",false);
         add("showInfoPrefix",false);
         add("chatFontSize",1);
         add("chatExpertMode",true);
         add("channelTabs",[[0,1,2,3,4,7,8,9,10,12,13],[10,11],[9],[2,5,6]]);
         add("tabsNames",["0","1","2","3"]);
         add("chatoutput",false);
         add("currentChatTheme","");
         add("externalChatEnabledChannels",[]);
         var _loc1_:String = "theme://css/chat.css";
         CssManager.getInstance().askCss(_loc1_,new Callback(this.onCssLoaded,_loc1_));
      }
      
      private function onCssLoaded(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc2_:ExtendedStyleSheet = CssManager.getInstance().getCss(param1);
         var _loc4_:ChatOptions = OptionManager.getOptionManager("chat") as ChatOptions;
         var _loc5_:String = (OptionManager.getOptionManager("dofus") as DofusOptions)["currentUiSkin"];
         var _loc6_:String = _loc4_.currentChatTheme;
         var _loc7_:int = 0;
         while(_loc7_ < 14)
         {
            _loc3_ = _loc2_.getStyle("p" + _loc7_);
            this.colors[_loc7_] = uint(this.color0x(_loc3_["color"]));
            add("channelColor" + _loc7_,this.colors[_loc7_]);
            if(_loc5_ != _loc6_)
            {
               _loc4_["channelColor" + _loc7_] = this.colors[_loc7_];
            }
            _loc7_++;
         }
         if(_loc5_ != _loc6_)
         {
            _loc4_.currentChatTheme = _loc5_;
         }
         _loc3_ = _loc2_.getStyle("p");
         add("alertColor",uint(this.color0x(_loc3_["color"])));
         dispatchEvent(new Event(CSS_LOADED));
      }
      
      private function color0x(param1:String) : String
      {
         return param1.replace("#","0x");
      }
   }
}
