package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.CompassTypeEnum;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   
   public class CartographyTooltip
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var ctr_flags:GraphicContainer;
      
      public var ctr_flags_bg:GraphicContainer;
      
      public var ctr_flags_bgHeight:int;
      
      public var gd_flags:Grid;
      
      public var ctr_mapElements:GraphicContainer;
      
      public var ctr_mapElements_bg:GraphicContainer;
      
      public var ctr_mapElements_bgHeight:int;
      
      public var gd_mapElements:Grid;
      
      public var lbl_coords:Label;
      
      public var totalHeight:Number;
      
      private var _numElements:uint;
      
      private var _numFlags:uint;
      
      private var _mapElementHeight:int;
      
      private var _mapFlagElementHeight:int;
      
      private var _lastParams:Object;
      
      private var _maxWidth:uint;
      
      private var _ctrMapElementsWidth:uint;
      
      private var _subAreaName:String;
      
      private var _myPositionUri:String;
      
      private var _labelDefaultX:Number;
      
      private var _elementsIds:Vector.<String>;
      
      private var _flagsIds:Vector.<String>;
      
      private var _containers:Dictionary;
      
      public function CartographyTooltip()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._myPositionUri = this.sysApi.getConfigEntry("config.gfx.path") + "icons/hints/character.png";
         this._labelDefaultX = this.uiApi.me().getConstant("labelTextX");
         this._mapFlagElementHeight = this.uiApi.me().getConstant("mapFlagElementHeight");
         this._mapElementHeight = this.uiApi.me().getConstant("mapElementHeight");
         this.update(param1);
      }
      
      public function update(param1:Object) : void
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.totalHeight = 0;
         var _loc2_:SubArea = this.dataApi.getSubArea(param1.subAreaId);
         this._subAreaName = !!_loc2_?_loc2_.name:null;
         this.lbl_coords.text = "[" + param1.mapX + "," + param1.mapY + "]";
         this.ctr_flags.height = 0;
         this.ctr_flags.width = 0;
         this.ctr_flags_bg.width = 0;
         this.ctr_flags_bgHeight = 0;
         this._ctrMapElementsWidth = 0;
         this.ctr_mapElements.width = 0;
         this._maxWidth = 0;
         this.ctr_mapElements_bg.width = 0;
         this.ctr_mapElements_bgHeight = 0;
         if(param1.mapElements)
         {
            _loc3_ = new Vector.<String>(0);
            _loc4_ = new Array();
            _loc5_ = new Array();
            _loc8_ = 0;
            while(_loc8_ < param1.mapElements.length)
            {
               if(_loc3_.indexOf(param1.mapElements[_loc8_].text) == -1 && (param1.mapElements[_loc8_].element.id.indexOf("search_flag") == -1 || param1.hasOwnProperty("mouseOnArrow") && param1.mouseOnArrow == true))
               {
                  _loc6_ = param1.mapElements[_loc8_].element.textureName;
                  if(_loc6_.indexOf("|") != -1)
                  {
                     _loc6_ = _loc6_.split("|")[1];
                  }
                  if(_loc6_ && (_loc6_ == "point0" || _loc6_ == "myPosition" || _loc6_ == "myPosition2" || _loc6_ == "character.png" || _loc6_ == "flag.png" || _loc6_.indexOf("flag") != -1))
                  {
                     _loc7_ = -1;
                     if(param1.mapElements[_loc8_].element.id == "flag_playerPosition" || param1.mapElements[_loc8_].element.id == "center")
                     {
                        _loc7_ = 2;
                     }
                     else if(param1.mapElements[_loc8_].element.id.indexOf("flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST) != -1)
                     {
                        _loc7_ = 1;
                     }
                     else if(param1.mapElements[_loc8_].element.id.indexOf("Phoenix") != -1)
                     {
                        _loc7_ = 0;
                     }
                     _loc4_.push({
                        "elem":param1.mapElements[_loc8_],
                        "priority":_loc7_
                     });
                  }
                  else
                  {
                     _loc5_.push(param1.mapElements[_loc8_]);
                  }
                  _loc3_.push(param1.mapElements[_loc8_].text);
               }
               _loc8_++;
            }
            _loc4_.sortOn("priority",Array.DESCENDING | Array.NUMERIC);
            _loc8_ = 0;
            while(_loc8_ < _loc4_.length)
            {
               _loc4_[_loc8_] = _loc4_[_loc8_].elem;
               _loc8_++;
            }
            this._elementsIds = new Vector.<String>(0);
            this._flagsIds = new Vector.<String>(0);
            this._containers = new Dictionary();
            this._numElements = _loc5_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               this._elementsIds.push(_loc5_[_loc8_].element.id);
               _loc8_++;
            }
            this.gd_mapElements.finalized = false;
            this.gd_mapElements.dataProvider = _loc5_;
            this.gd_mapElements.height = this._numElements * this._mapElementHeight;
            this._numFlags = _loc4_.length;
            this.gd_flags.finalized = false;
            _loc8_ = 0;
            while(_loc8_ < _loc4_.length)
            {
               this._flagsIds.push(_loc4_[_loc8_].element.id);
               _loc8_++;
            }
            this.gd_flags.dataProvider = _loc4_;
            this.gd_flags.height = this._numFlags * this._mapFlagElementHeight;
            this.ctr_flags.height = this.gd_flags.height;
         }
         else
         {
            this.gd_flags.dataProvider = [];
            this.gd_mapElements.dataProvider = [];
            this._numElements = 0;
            this._numFlags = 0;
         }
         this.ctr_mapElements_bg.visible = this._numElements > 0;
         this.ctr_flags.visible = this._numFlags > 0;
         this._lastParams = param1;
         if(this._maxWidth > 0)
         {
            this.ctr_mapElements.width = this._maxWidth;
            this.ctr_flags.width = this._maxWidth;
         }
         else
         {
            this.ctr_mapElements.width = this.ctr_mapElements.contentWidth;
            this.ctr_flags.width = this.ctr_flags.contentWidth;
         }
         this.uiApi.me().render();
         this.ctr_mapElements_bg.height = this.ctr_mapElements_bgHeight > 0?Number(this.ctr_mapElements_bgHeight):Number(this.gd_mapElements.height + 10);
         this.ctr_flags_bg.height = this.ctr_flags_bgHeight > 0?Number(this.ctr_flags_bgHeight):Number(this.gd_flags.height + 10);
         if(!this._numFlags)
         {
            this.ctr_mapElements.y = 0;
         }
         else
         {
            this.ctr_mapElements.y = this.ctr_flags_bg.height + 5;
         }
         this.totalHeight = 40;
         if(this.ctr_mapElements_bg.visible)
         {
            this.totalHeight = this.totalHeight + this.ctr_mapElements_bg.height;
         }
         if(this.ctr_flags.visible)
         {
            this.totalHeight = this.totalHeight + this.ctr_flags_bg.height;
         }
      }
      
      public function updateFlag(param1:Object, param2:*, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         if(param1)
         {
            param2.tx_icon.visible = true;
            this.updateElement(this.gd_flags,param1,param2);
            _loc4_ = param2.lbl_text.x + param2.lbl_text.width;
            this._maxWidth = Math.max(Math.max(_loc4_,this._maxWidth),this._ctrMapElementsWidth);
         }
         else
         {
            param2.tx_icon.visible = false;
            param2.lbl_text.text = "";
         }
      }
      
      public function updateMapElement(param1:Object, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.tx_icon.visible = true;
            this.updateElement(this.gd_mapElements,param1,param2);
            this._ctrMapElementsWidth = Math.max(param2.lbl_text.x + param2.lbl_text.width,this._ctrMapElementsWidth);
         }
         else
         {
            param2.tx_icon.visible = false;
            param2.lbl_text.text = "";
         }
      }
      
      public function hasElement(param1:String) : Boolean
      {
         var _loc2_:Object = null;
         if(this._lastParams.mapElements)
         {
            for each(_loc2_ in this._lastParams.mapElements)
            {
               if(_loc2_.element.id == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function updateElement(param1:Grid, param2:Object, param3:*) : void
      {
         var _loc9_:Vector.<String> = null;
         var _loc10_:GraphicContainer = null;
         var _loc11_:int = 0;
         var _loc13_:* = 0;
         var _loc14_:* = 0;
         var _loc15_:* = 0;
         var _loc16_:ColorTransform = null;
         var _loc17_:int = 0;
         var _loc4_:* = param2.element.uri;
         var _loc5_:int = param2.element.color;
         var _loc6_:Array = !!_loc4_?_loc4_.split("/"):null;
         var _loc7_:String = !!_loc6_?_loc6_[_loc6_.length - 1]:null;
         var _loc8_:Boolean = !!_loc7_?_loc7_.indexOf("flag") != -1:false;
         if(_loc7_ && _loc7_.indexOf("myPosition") != -1)
         {
            _loc4_ = this.sysApi.getConfigEntry("config.gfx.path") + "icons/hints/character.png";
         }
         else if(_loc8_)
         {
            _loc4_ = this.sysApi.getConfigEntry("config.gfx.path") + "icons/hints/flag.png";
         }
         if(_loc4_)
         {
            _loc6_ = _loc4_.split("|");
            if(_loc4_.indexOf("hintsShadow") != -1)
            {
               _loc4_ = _loc4_.replace("hintsShadow","hints");
            }
            param3.tx_icon.uri = this.uiApi.createUri(_loc6_.length > 1 && _loc6_[1] == "myPosition"?this._myPositionUri:_loc4_);
            param3.tx_icon.visible = true;
            param3.lbl_text.x = this._labelDefaultX;
         }
         else
         {
            param3.tx_icon.visible = false;
            param3.lbl_text.x = 0;
         }
         if(_loc5_ != -1)
         {
            _loc13_ = _loc5_ >> 16 & 255;
            _loc14_ = _loc5_ >> 8 & 255;
            _loc15_ = _loc5_ >> 0 & 255;
            _loc16_ = new ColorTransform(0.6,0.6,0.6,1,_loc13_ - 80,_loc14_ - 80,_loc15_ - 80);
            param3.tx_icon.transform.colorTransform = _loc16_;
         }
         else
         {
            param3.tx_icon.transform.colorTransform = new ColorTransform();
         }
         param3.lbl_text.text = param2.text + (_loc7_ == "410.png" && this._subAreaName?" - " + this._subAreaName:"");
         param3.lbl_text.width = 0;
         param3.lbl_text.fullWidth();
         this._containers[param2.element.id] = {
            "container":param3.lbl_text.getParent(),
            "label":param3.lbl_text
         };
         if(param1 == this.gd_mapElements)
         {
            _loc9_ = this._elementsIds;
            _loc10_ = this.ctr_mapElements_bg;
         }
         else
         {
            _loc9_ = this._flagsIds;
            _loc10_ = this.ctr_flags_bg;
         }
         var _loc12_:Boolean = true;
         _loc11_ = 0;
         while(_loc11_ < _loc9_.length)
         {
            if(!this._containers[_loc9_[_loc11_]])
            {
               _loc12_ = false;
               break;
            }
            _loc11_++;
         }
         if(_loc12_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc9_.length)
            {
               this._containers[_loc9_[_loc11_]].container.y = 5;
               _loc11_++;
            }
            _loc17_ = 0;
            _loc11_ = 0;
            while(_loc11_ < _loc9_.length)
            {
               this._containers[_loc9_[_loc11_]].container.y = this._containers[_loc9_[_loc11_]].container.y + _loc17_;
               _loc17_ = _loc17_ + (this._containers[_loc9_[_loc11_]].label.textHeight - 18);
               _loc11_++;
            }
            if(param1 == this.gd_mapElements)
            {
               this.ctr_mapElements_bgHeight = _loc9_.length * this._mapElementHeight + _loc17_ + 10;
               this.ctr_mapElements_bg.height = this.ctr_mapElements_bgHeight;
            }
            else
            {
               this.ctr_flags_bgHeight = _loc9_.length * this._mapFlagElementHeight + _loc17_ + 10;
               this.ctr_flags_bg.height = this.ctr_flags_bgHeight;
            }
         }
      }
   }
}
