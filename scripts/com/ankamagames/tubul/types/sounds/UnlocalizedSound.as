package com.ankamagames.tubul.types.sounds
{
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.interfaces.IUnlocalizedSound;
   
   public class UnlocalizedSound extends MP3SoundDofus implements IUnlocalizedSound
   {
       
      
      public function UnlocalizedSound(param1:uint, param2:Uri, param3:Boolean)
      {
         super(param1,param2,param3);
      }
   }
}
