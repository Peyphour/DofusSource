package com.ankamagames.tiphon.types.cache
{
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   
   public class SpriteCacheInfo
   {
       
      
      public var sprite:TiphonSprite;
      
      public var look:TiphonEntityLook;
      
      public function SpriteCacheInfo(param1:TiphonSprite, param2:TiphonEntityLook)
      {
         super();
         this.sprite = param1;
         this.look = param2;
      }
   }
}
