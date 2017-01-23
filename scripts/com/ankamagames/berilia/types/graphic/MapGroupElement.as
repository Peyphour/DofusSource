package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.MapViewer;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   import gs.TweenMax;
   import gs.events.TweenEvent;
   
   public class MapGroupElement extends Sprite
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapGroupElement));
      
      protected static var glowFilter:GlowFilter;
      
      protected static var cssUri:Uri;
       
      
      private var _icons:Vector.<MapIconElement>;
      
      private var _initialPos:Array;
      
      private var _tween:Array;
      
      private var _shape:Shape;
      
      private var _open:Boolean;
      
      private var _mapviewer:MapViewer;
      
      private var _iconsNumberLabel:Label;
      
      public function MapGroupElement(param1:MapViewer)
      {
         super();
         this._icons = new Vector.<MapIconElement>();
         this._mapviewer = param1;
         mouseEnabled = false;
         mouseChildren = false;
         if(!glowFilter)
         {
            glowFilter = new GlowFilter(XmlConfig.getInstance().getEntry("colors.text.glow"),1,4,4,6,3);
         }
         if(!cssUri)
         {
            cssUri = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "css/normal.css");
         }
         this.addNumberIconsLabel();
      }
      
      public function get opened() : Boolean
      {
         return this._open;
      }
      
      public function open(param1:Number = NaN) : void
      {
         var _loc11_:MapIconElement = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         if(!this._icons || !this._icons.length)
         {
            return;
         }
         if(this._iconsNumberLabel)
         {
            this._iconsNumberLabel.visible = false;
         }
         var _loc2_:uint = this._icons.length * 5;
         var _loc3_:Point = new Point(0,0);
         var _loc4_:uint = this._icons[0].textureWidth * 1.5;
         var _loc5_:uint = this._icons[0].textureHeight * 1.5;
         if(_loc2_ < _loc4_ * 3 / 4)
         {
            _loc2_ = _loc4_ * 3 / 4;
         }
         if(_loc2_ < _loc5_ * 3 / 4)
         {
            _loc2_ = _loc5_ * 3 / 4;
         }
         var _loc6_:Number = !!isNaN(param1)?Number(Math.min(0.1 * this._icons.length,0.5)):Number(param1);
         if(!this._shape)
         {
            this._shape = new Shape();
         }
         else
         {
            this._shape.graphics.clear();
         }
         _loc2_ = _loc2_ * (1 / this._mapviewer.zoomFactor);
         this._shape.graphics.beginFill(16777215,0);
         this._shape.graphics.drawCircle(_loc3_.x,_loc3_.y,40);
         super.addChildAt(this._shape,0);
         this.killAllTween();
         this._tween.push(new TweenMax(this._shape,_loc6_,{
            "alpha":1,
            "onCompleteListener":this.openingEnd
         }));
         var _loc7_:Boolean = false;
         if(!this._initialPos)
         {
            this._initialPos = new Array();
            _loc7_ = true;
         }
         var _loc8_:Number = Math.PI * 2 / this._icons.length;
         var _loc9_:Number = Math.PI / 2 + Math.PI / 4;
         var _loc10_:int = this._icons.length - 1;
         while(_loc10_ >= 0)
         {
            _loc11_ = this._icons[_loc10_];
            if(_loc7_)
            {
               this._initialPos.push({
                  "icon":this._icons[_loc10_],
                  "textureX":_loc11_.textureX,
                  "textureY":_loc11_.textureY
               });
            }
            _loc9_ = this._icons.length % 2 == 0?Number(30):Number(0);
            _loc12_ = _loc10_ % 2 == 0?1:-1;
            _loc13_ = (_loc10_ + 1) / 2;
            _loc14_ = _loc9_ + _loc12_ * _loc13_ * 60;
            _loc15_ = Math.sin(_loc14_ * Math.PI / 180) * 30 / this._mapviewer.zoomFactor;
            _loc16_ = -Math.cos(_loc14_ * Math.PI / 180) * 30 / this._mapviewer.zoomFactor;
            this._tween.push(new TweenMax(_loc11_,_loc6_,{
               "textureX":_loc15_,
               "textureY":_loc16_
            }));
            _loc10_--;
         }
      }
      
      private function openingEnd(param1:TweenEvent) : void
      {
         this._open = true;
      }
      
      private function getInitialPos(param1:Object) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._initialPos)
         {
            if(_loc2_.icon == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function close() : void
      {
         var _loc1_:Object = null;
         if(this._iconsNumberLabel)
         {
            this._iconsNumberLabel.visible = true;
         }
         this.killAllTween();
         if(this._shape)
         {
            this._tween.push(new TweenMax(this._shape,0.2,{
               "alpha":0,
               "onCompleteListener":this.shapeTweenFinished
            }));
         }
         for each(_loc1_ in this._initialPos)
         {
            this._tween.push(new TweenMax(_loc1_.icon,0.2,{
               "textureX":_loc1_.textureX,
               "textureY":_loc1_.textureY
            }));
         }
         this._open = false;
      }
      
      public function addElement(param1:MapIconElement) : void
      {
         this._icons.push(param1);
         param1.group = this;
      }
      
      public function remove() : void
      {
         while(numChildren)
         {
            removeChildAt(0);
         }
         this._icons = null;
         this.killAllTween();
      }
      
      public function display() : void
      {
         var _loc1_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         this._icons.sort(this.compareIconsPriority);
         var _loc2_:uint = this._icons.length;
         var _loc3_:uint = 0;
         var _loc4_:uint = _loc2_ > 2?uint(2):uint(_loc2_);
         _loc1_ = _loc2_ - 1;
         while(_loc1_ >= 0)
         {
            if(this._icons[_loc1_].uri)
            {
               _loc3_++;
            }
            _loc5_ = Math.min(_loc4_,_loc1_);
            _loc6_ = -4 * _loc5_;
            this._icons[_loc1_].setTextureParent(this);
            this._icons[_loc1_].setTexturePosition(0,_loc6_);
            _loc1_--;
         }
         this.updateIconsNumber(_loc3_);
      }
      
      private function updateIconsNumber(param1:uint) : void
      {
         if(param1 > 1)
         {
            if(!this._iconsNumberLabel)
            {
               this.addNumberIconsLabel();
            }
            if(param1.toString() != this._iconsNumberLabel.text)
            {
               this._iconsNumberLabel.text = param1.toString();
               this._iconsNumberLabel.filters = [glowFilter];
               setChildIndex(this._iconsNumberLabel,numChildren - 1);
            }
         }
         else
         {
            this.removeNumberIconsLabel();
         }
      }
      
      private function addNumberIconsLabel() : void
      {
         this._iconsNumberLabel = new Label();
         this._iconsNumberLabel.width = 30;
         this._iconsNumberLabel.height = 20;
         this._iconsNumberLabel.x = -15;
         this._iconsNumberLabel.y = -10;
         this._iconsNumberLabel.css = cssUri;
         addChild(this._iconsNumberLabel);
      }
      
      private function removeNumberIconsLabel() : void
      {
         if(this._iconsNumberLabel)
         {
            this._iconsNumberLabel.filters = null;
            this._iconsNumberLabel.remove();
            this._iconsNumberLabel = null;
         }
      }
      
      private function compareIconsPriority(param1:MapIconElement, param2:MapIconElement) : int
      {
         if(param1.priority < param2.priority)
         {
            return -1;
         }
         if(param1.priority > param2.priority)
         {
            return 1;
         }
         return 0;
      }
      
      private function killAllTween() : void
      {
         var _loc1_:TweenMax = null;
         for each(_loc1_ in this._tween)
         {
            _loc1_.kill();
            _loc1_.gc = true;
         }
         this._tween = new Array();
      }
      
      private function shapeTweenFinished(param1:TweenEvent) : void
      {
         this._shape.graphics.clear();
      }
      
      public function get icons() : Vector.<MapIconElement>
      {
         return this._icons;
      }
   }
}
