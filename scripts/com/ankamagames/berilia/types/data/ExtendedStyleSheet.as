package com.ankamagames.berilia.types.data
{
   import com.ankamagames.berilia.types.event.CssEvent;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FontManager;
   import flash.text.AntiAliasType;
   import flash.text.StyleSheet;
   import flash.text.TextFormat;
   import flash.text.engine.CFFHinting;
   import flash.text.engine.FontLookup;
   import flash.text.engine.RenderingMode;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   public class ExtendedStyleSheet extends StyleSheet
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ExtendedStyleSheet));
      
      private static const CSS_INHERITANCE_KEYWORD:String = "extends";
      
      private static const CSS_FILES_KEYWORD:String = "files";
       
      
      private var _inherit:Array;
      
      private var _inherited:uint;
      
      private var _url:String;
      
      private var _content:String;
      
      private var _fontStyle:String;
      
      public function ExtendedStyleSheet(param1:String)
      {
         this._inherit = new Array();
         this._inherited = 0;
         this._url = param1;
         super();
      }
      
      public function get inherit() : Array
      {
         return this._inherit;
      }
      
      public function get ready() : Boolean
      {
         return this._inherited == this._inherit.length;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      override public function parseCSS(param1:String) : void
      {
         this._fontStyle = FontManager.getInstance().activeType.toLowerCase();
         this._content = param1;
         super.parseCSS(param1);
         this.update();
      }
      
      override public function transform(param1:Object) : TextFormat
      {
         if(this._fontStyle != FontManager.getInstance().activeType.toLowerCase())
         {
            this.parseCSS(this._content);
         }
         return super.transform(param1);
      }
      
      public function merge(param1:ExtendedStyleSheet, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc6_:* = null;
         var _loc5_:uint = 0;
         while(_loc5_ < param1.styleNames.length)
         {
            if(param1.styleNames[_loc5_] != CSS_INHERITANCE_KEYWORD)
            {
               _loc3_ = getStyle(param1.styleNames[_loc5_]);
               _loc4_ = param1.getStyle(param1.styleNames[_loc5_]);
               if(_loc3_)
               {
                  for(_loc6_ in _loc4_)
                  {
                     if(_loc3_[_loc6_] == null || param2)
                     {
                        _loc3_[_loc6_] = _loc4_[_loc6_];
                     }
                  }
                  _loc4_ = _loc3_;
               }
               setStyle(param1.styleNames[_loc5_],_loc4_);
            }
            _loc5_++;
         }
      }
      
      override public function toString() : String
      {
         var _loc2_:Object = null;
         var _loc4_:* = null;
         var _loc1_:String = "";
         _loc1_ = _loc1_ + ("File " + this.url + " :\n");
         var _loc3_:uint = 0;
         while(_loc3_ < styleNames.length)
         {
            _loc2_ = getStyle(styleNames[_loc3_]);
            _loc1_ = _loc1_ + (" [" + styleNames[_loc3_] + "]\n");
            for(_loc4_ in _loc2_)
            {
               _loc1_ = _loc1_ + ("  " + _loc4_ + " : " + _loc2_[_loc4_] + "\n");
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function TLFTransform(param1:Object) : TextLayoutFormat
      {
         var _loc3_:String = null;
         var _loc2_:TextLayoutFormat = new TextLayoutFormat();
         if(param1["fontFamily"])
         {
            _loc3_ = param1["fontFamily"];
            if(FontManager.getInstance().getFontInfo(_loc3_).antialiasingType == AntiAliasType.ADVANCED)
            {
               _loc2_.renderingMode = RenderingMode.CFF;
               _loc2_.fontLookup = FontLookup.EMBEDDED_CFF;
               _loc2_.cffHinting = CFFHinting.HORIZONTAL_STEM;
            }
            _loc2_.fontFamily = _loc3_;
         }
         if(param1["color"])
         {
            _loc2_.color = param1["color"];
         }
         if(param1["fontSize"])
         {
            _loc2_.fontSize = param1["fontSize"];
         }
         if(param1["paddingLeft"])
         {
            _loc2_.paddingLeft = param1["paddingLeft"];
         }
         if(param1["paddingRight"])
         {
            _loc2_.paddingRight = param1["paddingRight"];
         }
         if(param1["paddingBottom"])
         {
            _loc2_.paddingBottom = param1["paddingBottom"];
         }
         if(param1["paddingTop"])
         {
            _loc2_.paddingTop = param1["paddingTop"];
         }
         if(param1["textIndent"])
         {
            _loc2_.textIndent = param1["textIndent"];
         }
         return _loc2_;
      }
      
      private function update() : void
      {
         var _loc1_:String = null;
         var _loc5_:* = null;
         var _loc6_:Array = null;
         var _loc7_:* = false;
         var _loc8_:Object = null;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:* = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = true;
         while(!_loc3_ && _loc4_)
         {
            _loc3_ = true;
            _loc4_ = false;
            for each(_loc5_ in styleNames)
            {
               _loc6_ = _loc5_.split("_");
               _loc1_ = _loc6_[0];
               if(!_loc2_[_loc1_])
               {
                  _loc7_ = getStyle(_loc1_ + "-" + this._fontStyle) == null;
                  if(_loc6_.length > 1 || _loc7_)
                  {
                     _loc6_.shift();
                     _loc6_.reverse();
                     _loc6_.push(_loc5_);
                     if(_loc7_)
                     {
                        _loc6_.push(_loc1_ + "-" + this._fontStyle);
                     }
                     _loc8_ = {};
                     _loc9_ = true;
                     for each(_loc10_ in _loc6_)
                     {
                        if(_loc10_ != _loc5_ && _loc2_[_loc10_] == null)
                        {
                           _loc9_ = false;
                           break;
                        }
                        _loc11_ = !!_loc2_[_loc10_]?_loc2_[_loc10_]:getStyle(_loc10_);
                        if(_loc11_ != null)
                        {
                           for(_loc12_ in _loc11_)
                           {
                              if(_loc11_[_loc12_] != null)
                              {
                                 _loc8_[_loc12_] = _loc11_[_loc12_];
                              }
                           }
                        }
                     }
                     if(_loc9_)
                     {
                        _loc2_[_loc1_] = _loc8_;
                        _loc3_ = false;
                     }
                     else
                     {
                        _loc4_ = true;
                     }
                  }
                  else
                  {
                     _loc3_ = false;
                     _loc2_[_loc1_] = getStyle(_loc1_);
                  }
               }
            }
         }
         clear();
         for(_loc5_ in _loc2_)
         {
            setStyle(_loc5_,_loc2_[_loc5_]);
         }
         dispatchEvent(new CssEvent(CssEvent.CSS_PARSED,false,false,this));
      }
   }
}
