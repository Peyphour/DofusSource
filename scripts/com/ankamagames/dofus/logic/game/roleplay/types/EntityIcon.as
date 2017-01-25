package com.ankamagames.dofus.logic.game.roleplay.types
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class EntityIcon extends Sprite
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(EntityIcon));
       
      
      private var _entity:AnimatedCharacter;
      
      private var _icons:Dictionary;
      
      private var _nbIcons:int;
      
      public var needUpdate:Boolean;
      
      public var rendering:Boolean;
      
      public function EntityIcon(param1:AnimatedCharacter)
      {
         super();
         this._entity = param1;
         this._icons = new Dictionary(true);
         mouseEnabled = mouseChildren = false;
      }
      
      public function addIcon(param1:String, param2:String) : void
      {
         this._icons[param2] = new Texture();
         var _loc3_:Texture = this._icons[param2];
         _loc3_.uri = new Uri(param1);
         _loc3_.dispatchMessages = true;
         _loc3_.addEventListener(Event.COMPLETE,this.iconRendered);
         _loc3_.finalize();
         this._nbIcons++;
      }
      
      public function removeIcon(param1:String) : void
      {
         var _loc2_:Texture = this._icons[param1];
         if(_loc2_)
         {
            if(_loc2_.parent == this)
            {
               removeChild(_loc2_);
            }
            delete this._icons[param1];
            this._nbIcons--;
            if(numChildren == this._nbIcons)
            {
               for each(_loc2_ in this._icons)
               {
                  removeChild(_loc2_);
               }
               for each(_loc2_ in this._icons)
               {
                  _loc2_.x = width == 0?Number(_loc2_.width / 2):Number(width + 5 + _loc2_.width / 2);
                  addChild(_loc2_);
               }
               this.needUpdate = true;
            }
         }
      }
      
      public function hasIcon(param1:String) : Boolean
      {
         return this._icons[param1];
      }
      
      public function get length() : int
      {
         return this._nbIcons;
      }
      
      public function remove() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function place(param1:IRectangle) : void
      {
         var _loc2_:Point = new Point(param1.x + param1.width / 2 - width * Atouin.getInstance().currentZoom / 2,param1.y - 10 * Atouin.getInstance().currentZoom);
         var _loc3_:Point = this._entity.parent.globalToLocal(_loc2_);
         x = _loc3_.x;
         y = _loc3_.y;
      }
      
      private function iconRendered(param1:Event) : void
      {
         var _loc2_:Texture = param1.currentTarget as Texture;
         _loc2_.removeEventListener(Event.COMPLETE,this.iconRendered);
         _loc2_.x = width == 0?Number(_loc2_.width / 2):Number(width + 5 + _loc2_.width / 2);
         addChild(_loc2_);
         this.needUpdate = true;
      }
   }
}
