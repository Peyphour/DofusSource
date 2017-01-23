package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.components.TextureBase;
   import com.ankamagames.berilia.types.data.MapElement;
   import com.ankamagames.jerakine.pools.PoolablePoint;
   import com.ankamagames.jerakine.pools.PoolsManager;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   
   public class MapDisplayableElement extends MapElement
   {
      
      public static const VISIBLE_BG_SCALE_CEIL:Number = 1.1;
      
      public static const INITIAL_SCALE:Number = 1;
      
      public static const SCALE_FACTOR:Number = 0.7;
      
      public static const DEFAULT_TEXTURE_SCALE:Number = 1;
       
      
      protected var _texture:TextureBase;
      
      protected var _texturePosition:PoolablePoint;
      
      private var _scale:Number = 1;
      
      public function MapDisplayableElement(param1:String, param2:int, param3:int, param4:String, param5:*, param6:TextureBase)
      {
         super(param1,param2,param3,param4,param5);
         this._texture = param6;
      }
      
      override public function remove() : void
      {
         if(this._texture)
         {
            this._texture.remove();
            if(this._texture.parent)
            {
               this._texture.parent.removeChild(this._texture);
            }
            this._texture = null;
         }
         if(this._texturePosition)
         {
            PoolsManager.getInstance().getPointPool().checkIn(this._texturePosition);
            this._texturePosition = null;
         }
         super.remove();
      }
      
      public function get textureX() : Number
      {
         if(this._texture)
         {
            return this._texture.x;
         }
         return 0;
      }
      
      public function set textureX(param1:Number) : void
      {
         if(this._texture)
         {
            this._texture.x = param1;
         }
      }
      
      public function get textureY() : Number
      {
         if(this._texture)
         {
            return this._texture.y;
         }
         return 0;
      }
      
      public function set textureY(param1:Number) : void
      {
         if(this._texture)
         {
            this._texture.y = param1;
         }
      }
      
      public function get uri() : String
      {
         if(this._texture && this._texture.uri)
         {
            return this._texture.uri.uri;
         }
         return null;
      }
      
      public function get textureName() : String
      {
         if(this._texture && this._texture.uri)
         {
            if(this._texture.uri.subPath)
            {
               return this._texture.uri.subPath;
            }
            return this._texture.uri.fileName;
         }
         return "";
      }
      
      public function getTexturePosition() : Point
      {
         if(!this._texturePosition)
         {
            this._texturePosition = PoolsManager.getInstance().getPointPool().checkOut() as PoolablePoint;
         }
         if(this._texture)
         {
            if(this._texturePosition.x != this._texture.x)
            {
               this._texturePosition.x = this._texture.x;
            }
            if(this._texturePosition.y != this._texture.y)
            {
               this._texturePosition.y = this._texture.y;
            }
         }
         return this._texturePosition;
      }
      
      public function setTexturePosition(param1:Number, param2:Number) : void
      {
         if(this._texture)
         {
            this._texture.x = param1;
            this._texture.y = param2;
         }
      }
      
      public function get textureWidth() : Number
      {
         if(this._texture)
         {
            return this._texture.width;
         }
         return 0;
      }
      
      public function set textureWidth(param1:Number) : void
      {
         if(this._texture)
         {
            this._texture.width = param1;
         }
      }
      
      public function get textureHeight() : Number
      {
         if(this._texture)
         {
            return this._texture.height;
         }
         return 0;
      }
      
      public function set textureHeight(param1:Number) : void
      {
         if(this._texture)
         {
            this._texture.height = param1;
         }
      }
      
      public function set textureScale(param1:Number) : void
      {
         this._scale = param1;
         if(this._texture)
         {
            if(this._scale > VISIBLE_BG_SCALE_CEIL)
            {
               this._texture.scaleX = this._scale * SCALE_FACTOR;
               this._texture.scaleY = this._scale * SCALE_FACTOR;
            }
            else
            {
               this._texture.scaleX = SCALE_FACTOR;
               this._texture.scaleY = SCALE_FACTOR;
            }
         }
      }
      
      public function setTextureParent(param1:DisplayObjectContainer) : void
      {
         if(this._texture)
         {
            param1.addChild(this._texture);
         }
      }
      
      public function hasContainerAsTextureParent(param1:DisplayObjectContainer) : Boolean
      {
         if(this._texture)
         {
            return param1 == this._texture.parent;
         }
         return false;
      }
      
      public function hasTexture() : Boolean
      {
         return this._texture != null;
      }
   }
}
