package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.tiphon.types.AnimationModifierPriority;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.getQualifiedClassName;
   
   public class CustomBreedAnimationModifier implements IAnimationModifier
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(CustomBreedAnimationModifier));
       
      
      public var randomStatique:Boolean = false;
      
      public function CustomBreedAnimationModifier()
      {
         super();
      }
      
      public function get priority() : int
      {
         return AnimationModifierPriority.NORMAL;
      }
      
      public function getModifiedAnimation(param1:String, param2:TiphonEntityLook) : String
      {
         var _loc3_:Swl = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param2.getBone() != 1)
         {
            return param1;
         }
         switch(param1)
         {
            case AnimationEnum.ANIM_STATIQUE:
               if(this.randomStatique)
               {
                  _loc3_ = Tiphon.skullLibrary.getResourceById(param2.getBone(),AnimationEnum.ANIM_STATIQUE);
                  _loc5_ = new Array();
                  if(_loc3_)
                  {
                     for each(_loc6_ in _loc3_.getDefinitions())
                     {
                        if(_loc6_.indexOf(AnimationEnum.ANIM_STATIQUE + param2.firstSkin.toString()) == 0)
                        {
                           _loc7_ = _loc6_.split("_")[0];
                           if(_loc5_.indexOf(_loc7_) == -1)
                           {
                              _loc5_.push(_loc7_);
                           }
                        }
                     }
                  }
                  else
                  {
                     _loc5_.push(AnimationEnum.ANIM_STATIQUE + param2.firstSkin.toString());
                  }
                  if(_loc5_.length > 1)
                  {
                     _loc8_ = Math.floor(Math.random() * _loc5_.length);
                     return _loc5_[_loc8_];
                  }
                  return _loc5_[0];
               }
               _loc9_ = param2.firstSkin;
               if(_loc9_ == 1114 || _loc9_ == 1115 || _loc9_ == 1402 || _loc9_ == 1463 || _loc9_ == param2.defaultSkin)
               {
                  return AnimationEnum.ANIM_STATIQUE;
               }
               return AnimationEnum.ANIM_STATIQUE + param2.firstSkin.toString();
            case AnimationEnum.ANIM_MARCHE:
            case AnimationEnum.ANIM_COURSE:
               _loc4_ = param1 + "_" + param2.firstSkin.toString();
               if(Tiphon.skullLibrary.hasAnim(param2.getBone(),_loc4_))
               {
                  return _loc4_;
               }
               return param1;
            default:
               return param1;
         }
      }
   }
}
