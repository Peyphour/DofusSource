package ui
{
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import flash.text.AntiAliasType;
   
   public class ChatComponentHandler
   {
      
      public static const CHAT_ADVANCED:String = "advanced";
      
      public static const CHAT_NORMAL:String = "normal";
       
      
      private var _type:String;
      
      private var _chat:Object;
      
      private var _parent:GraphicContainer;
      
      public function ChatComponentHandler(param1:String, param2:GraphicContainer, param3:TextArea = null)
      {
         super();
         this._parent = param2;
         this._type = param1;
         Api.chat.setMaxMessagesStored(100);
         if(this._type == CHAT_ADVANCED)
         {
            Api.chat.changeCssHandler("inline");
            this._chat = Api.ui.createComponent("ChatComponent");
            this._chat.width = this._parent.width;
            this._chat.height = this._parent.height - 8;
            this._chat.smiliesActivated = false;
            this._chat.css = Api.ui.createUri(Api.ui.getUi("chat").getConstant("css") + "chat.css");
         }
         else
         {
            Api.chat.changeCssHandler("old");
            if(!param3)
            {
               this._chat = Api.ui.createComponent("TextArea");
               this._chat.name = "ta_chat";
               this._chat.width = this._parent.width;
               this._chat.height = this._parent.height;
               this._chat.css = Api.ui.createUri(Api.ui.getUi("chat").getConstant("css") + "chat_input.css");
               this._chat.cssClass = "p";
               this._chat.selectable = true;
               this._chat.useEmbedFonts = false;
               this._chat.hyperlinkEnabled = true;
            }
            else
            {
               this._chat = param3;
            }
            this._chat.antialias = AntiAliasType.ADVANCED;
         }
         if(!param3)
         {
            this._parent.addContent(this._chat as GraphicContainer);
            this._chat.scrollCss = Api.ui.createUri(Api.ui.getUi("chat").getConstant("css") + "scrollBar.css");
            this._chat.scrollTopMargin = 5;
            this._chat.scrollPos = -1;
            this._chat.finalize();
         }
      }
      
      public function setCssColor(param1:String, param2:String = null) : void
      {
         this._chat.setCssColor(param1,param2);
      }
      
      public function setCssSize(param1:uint, param2:uint, param3:String = null) : void
      {
         if(this._type == CHAT_ADVANCED)
         {
            this._chat.setCssSize(param1,param2,param3);
         }
         else
         {
            this._chat.setCssSize(param1,param3);
         }
      }
      
      public function initSmileyTab(param1:String, param2:Object) : void
      {
         if(this._type == CHAT_ADVANCED)
         {
            this._chat.initSmileyTab(param1,param2);
         }
      }
      
      public function appendText(param1:String, param2:String = null, param3:Boolean = true) : Object
      {
         if(this._type == CHAT_ADVANCED)
         {
            return this._chat.appendText(param1,param2,param3);
         }
         if(param3)
         {
            this._chat.appendText(param1,param2);
         }
         return null;
      }
      
      public function clearText() : void
      {
         if(this._type == CHAT_ADVANCED)
         {
            this._chat.clearText();
         }
         else
         {
            this._chat.text = "";
         }
      }
      
      public function getTextForChannel(param1:*) : Object
      {
         if(this._type == CHAT_ADVANCED)
         {
            return Api.chat.getParagraphByChannel(param1);
         }
         return Api.chat.getMessagesByChannel(param1);
      }
      
      public function getHistoryForChannel(param1:*) : Object
      {
         return Api.chat.getHistoryMessagesByChannel(param1);
      }
      
      public function insertParagraphes(param1:Array) : void
      {
         if(this._type == CHAT_ADVANCED)
         {
            this._chat.insertParagraphes(param1);
         }
      }
      
      public function activeSmilies() : void
      {
         if(this._type == CHAT_ADVANCED)
         {
            this._chat.smiliesActivated = !this._chat.smiliesActivated;
         }
      }
      
      public function removeLines(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         if(this._type == CHAT_ADVANCED)
         {
            this._chat.removeLines(param1);
         }
         else
         {
            _loc3_ = this._chat.htmlText;
            _loc2_ = 0;
            while(_loc2_ < param1)
            {
               _loc4_ = _loc3_.indexOf("</TEXTFORMAT>") + 13;
               _loc3_ = _loc3_.substr(_loc4_);
               _loc2_++;
            }
            this._chat.htmlText = _loc3_;
         }
      }
      
      public function scrollNeeded() : Boolean
      {
         if(this._type == CHAT_ADVANCED)
         {
            return this._chat.scrollV == this._chat.maxScrollV;
         }
         return this._chat.scrollV == this._chat.maxScrollV || this._chat.maxScrollV <= 6;
      }
      
      public function get height() : Number
      {
         return this._chat.height;
      }
      
      public function set height(param1:Number) : void
      {
         this._chat.height = param1;
      }
      
      public function get scrollV() : Number
      {
         return this._chat.scrollV;
      }
      
      public function set scrollV(param1:Number) : void
      {
         this._chat.scrollV = param1;
      }
      
      public function get maxScrollV() : Number
      {
         return this._chat.maxScrollV;
      }
      
      public function set maxScrollV(param1:Number) : void
      {
         this._chat.maxScrollV = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get text() : String
      {
         return this._chat.text;
      }
      
      public function get htmlText() : String
      {
         var _loc1_:String = null;
         if(this.type == CHAT_NORMAL)
         {
            _loc1_ = this._chat.htmlText;
         }
         return _loc1_;
      }
      
      public function set htmlText(param1:String) : void
      {
         if(this.type == CHAT_NORMAL)
         {
            this._chat.htmlText = param1;
         }
      }
   }
}
