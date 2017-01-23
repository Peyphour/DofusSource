package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class HyperlinkShowMonsterManager
   {
       
      
      public function HyperlinkShowMonsterManager()
      {
         super();
      }
      
      public static function showMonster(param1:int, param2:int = 0) : Sprite
      {
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:GraphicCell = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Dictionary = null;
         var _loc8_:Object = null;
         var _loc3_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(_loc3_)
         {
            _loc7_ = _loc3_.getEntitiesDictionnary();
            for each(_loc8_ in _loc7_)
            {
               if(_loc8_ is GameRolePlayGroupMonsterInformations && (_loc8_.staticInfos.mainCreatureLightInfos.creatureGenericId == param1 || param1 == -1))
               {
                  _loc4_ = DofusEntities.getEntity(GameRolePlayGroupMonsterInformations(_loc8_).contextualId) as AnimatedCharacter;
                  if(_loc4_ && _loc4_.stage)
                  {
                     _loc5_ = InteractiveCellManager.getInstance().getCell(_loc4_.position.cellId);
                     _loc6_ = new Rectangle(_loc5_.x + AtouinConstants.CELL_HALF_WIDTH,_loc5_.y + AtouinConstants.CELL_HALF_HEIGHT - 80,0,0);
                     return HyperlinkDisplayArrowManager.showAbsoluteArrow(_loc6_,0,0,1,param2);
                  }
                  return null;
               }
               if(_loc8_ is GameFightMonsterInformations && (_loc8_.creatureGenericId == param1 || param1 == -1))
               {
                  _loc4_ = DofusEntities.getEntity(GameFightMonsterInformations(_loc8_).contextualId) as AnimatedCharacter;
                  if(_loc4_ && _loc4_.stage)
                  {
                     _loc5_ = InteractiveCellManager.getInstance().getCell(_loc4_.position.cellId);
                     _loc6_ = new Rectangle(_loc5_.x + AtouinConstants.CELL_HALF_WIDTH,_loc5_.y + AtouinConstants.CELL_HALF_HEIGHT - 80,0,0);
                     return HyperlinkDisplayArrowManager.showAbsoluteArrow(_loc6_,0,0,1,param2);
                  }
                  return null;
               }
            }
         }
         return null;
      }
      
      public static function getMonsterName(param1:uint) : String
      {
         var _loc2_:Monster = Monster.getMonsterById(param1);
         if(_loc2_)
         {
            return _loc2_.name;
         }
         return "[null]";
      }
   }
}
