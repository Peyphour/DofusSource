package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class HyperlinkShowNpcManager
   {
       
      
      public function HyperlinkShowNpcManager()
      {
         super();
      }
      
      public static function showNpc(param1:int, param2:int = 0) : MovieClip
      {
         var _loc4_:Dictionary = null;
         var _loc5_:Object = null;
         var _loc6_:TiphonSprite = null;
         var _loc7_:Rectangle = null;
         var _loc8_:uint = 0;
         var _loc9_:* = undefined;
         var _loc10_:GraphicCell = null;
         var _loc3_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(_loc3_)
         {
            _loc4_ = _loc3_.getEntitiesDictionnary();
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_ is GameRolePlayNpcInformations && (_loc5_.npcId == param1 || param1 == -1))
               {
                  _loc6_ = EntitiesManager.getInstance().getEntity(GameRolePlayNpcInformations(_loc5_).contextualId) as TiphonSprite;
                  if(_loc6_)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < _loc6_.numChildren)
                     {
                        _loc9_ = _loc6_.getChildAt(_loc8_);
                        if(_loc9_ is ScriptedAnimation)
                        {
                           _loc7_ = _loc9_.getBounds(StageShareManager.stage);
                           break;
                        }
                        _loc8_++;
                     }
                     if(!_loc7_)
                     {
                        _loc7_ = _loc6_.getBounds(StageShareManager.stage);
                     }
                  }
                  else
                  {
                     _loc10_ = InteractiveCellManager.getInstance().getCell(_loc5_.disposition.cellId);
                     _loc7_ = new Rectangle(_loc10_.x,_loc10_.y,_loc10_.width,_loc10_.height);
                     _loc7_.y = _loc7_.y - 80;
                  }
                  return HyperlinkDisplayArrowManager.showAbsoluteArrow(_loc7_,0,0,1,param2);
               }
            }
         }
         return null;
      }
   }
}
