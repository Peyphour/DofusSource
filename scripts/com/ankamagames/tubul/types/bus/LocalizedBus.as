package com.ankamagames.tubul.types.bus
{
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.types.sounds.LocalizedSound;
   import flash.geom.Point;
   
   public class LocalizedBus extends AudioBus
   {
       
      
      public function LocalizedBus(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      public function updateObserverPosition(param1:Point) : void
      {
         var _loc2_:ISound = null;
         for each(_loc2_ in _soundVector)
         {
            if(_loc2_ is LocalizedSound)
            {
               (_loc2_ as LocalizedSound).updateObserverPosition(param1);
            }
         }
      }
   }
}
