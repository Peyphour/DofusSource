package com.ankamagames.dofus.factories
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.AlignmentSideEnum;
   import com.ankamagames.dofus.network.enums.FightTypeEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.enums.TeamTypeEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.FightCommonInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberWithAllianceCharacterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.getQualifiedClassName;
   
   public class RolePlayEntitiesFactory
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RolePlayEntitiesFactory));
      
      private static const TEAM_CHALLENGER_LOOK:String = "{19}";
      
      private static const TEAM_DEFENDER_LOOK:String = "{20}";
      
      private static const TEAM_TAX_COLLECTOR_LOOK:String = "{21}";
      
      private static const TEAM_ANGEL_LOOK:String = "{32}";
      
      private static const TEAM_DEMON_LOOK:String = "{33}";
      
      private static const TEAM_NEUTRAL_LOOK:String = "{1237}";
      
      private static const TEAM_BAD_ANGEL_LOOK:String = "{1235}";
      
      private static const TEAM_BAD_DEMON_LOOK:String = "{1236}";
      
      private static const TEAM_CHALLENGER_AVA_ALLY:String = "{2248}";
      
      private static const TEAM_CHALLENGER_AVA_ATTACKERS:String = "{2249}";
      
      private static const TEAM_CHALLENGER_AVA_DEFENDERS:String = "{2251}";
      
      private static const TEAM_DEFENDER_AVA_ALLY:String = "{2252}";
      
      private static const TEAM_DEFENDER_AVA_ATTACKERS:String = "{2253}";
      
      private static const TEAM_DEFENDER_AVA_DEFENDERS:String = "{2255}";
       
      
      public function RolePlayEntitiesFactory()
      {
         super();
      }
      
      public static function createFightEntity(param1:FightCommonInformations, param2:FightTeamInformations, param3:MapPoint, param4:int) : IEntity
      {
         var _loc6_:String = null;
         var _loc8_:AllianceFrame = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:PrismSubAreaWrapper = null;
         var _loc12_:int = 0;
         var _loc5_:Number = EntitiesManager.getInstance().getFreeEntityId();
         switch(param1.fightType)
         {
            case FightTypeEnum.FIGHT_TYPE_AGRESSION:
               switch(param2.teamSide)
               {
                  case AlignmentSideEnum.ALIGNMENT_ANGEL:
                     if(param2.teamTypeId == TeamTypeEnum.TEAM_TYPE_BAD_PLAYER)
                     {
                        _loc6_ = TEAM_BAD_ANGEL_LOOK;
                     }
                     else
                     {
                        _loc6_ = TEAM_ANGEL_LOOK;
                     }
                     break;
                  case AlignmentSideEnum.ALIGNMENT_EVIL:
                     if(param2.teamTypeId == TeamTypeEnum.TEAM_TYPE_BAD_PLAYER)
                     {
                        _loc6_ = TEAM_BAD_DEMON_LOOK;
                     }
                     else
                     {
                        _loc6_ = TEAM_DEMON_LOOK;
                     }
                     break;
                  case AlignmentSideEnum.ALIGNMENT_NEUTRAL:
                  case AlignmentSideEnum.ALIGNMENT_MERCENARY:
                     _loc6_ = TEAM_NEUTRAL_LOOK;
                     break;
                  case AlignmentSideEnum.ALIGNMENT_WITHOUT:
                     _loc6_ = TEAM_CHALLENGER_LOOK;
               }
               break;
            case FightTypeEnum.FIGHT_TYPE_Koh:
               _loc8_ = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
               _loc9_ = !!_loc8_.hasAlliance?Number(_loc8_.alliance.allianceId):Number(-1);
               if(param2.teamMembers[0] is FightTeamMemberWithAllianceCharacterInformations)
               {
                  _loc10_ = (param2.teamMembers[0] as FightTeamMemberWithAllianceCharacterInformations).allianceInfos.allianceId;
               }
               _loc11_ = _loc8_.getPrismSubAreaById(PlayedCharacterManager.getInstance().currentSubArea.id);
               _loc12_ = !!_loc11_?!!_loc11_.alliance?int(_loc11_.alliance.allianceId):int(_loc9_):-1;
               switch(param2.teamId)
               {
                  case TeamEnum.TEAM_DEFENDER:
                     if(_loc9_ != -1 && _loc9_ == _loc10_)
                     {
                        _loc6_ = TEAM_DEFENDER_AVA_ALLY;
                     }
                     else if(_loc12_ != -1)
                     {
                        if(_loc10_ == _loc12_)
                        {
                           _loc6_ = TEAM_DEFENDER_AVA_DEFENDERS;
                        }
                        else
                        {
                           _loc6_ = TEAM_DEFENDER_AVA_ATTACKERS;
                        }
                     }
                     else
                     {
                        _loc6_ = TEAM_DEFENDER_AVA_ATTACKERS;
                     }
                     break;
                  case TeamEnum.TEAM_CHALLENGER:
                     if(_loc9_ != -1 && _loc9_ == _loc10_)
                     {
                        _loc6_ = TEAM_CHALLENGER_AVA_ALLY;
                     }
                     else if(_loc12_ != -1)
                     {
                        if(_loc10_ == _loc12_)
                        {
                           _loc6_ = TEAM_CHALLENGER_AVA_DEFENDERS;
                        }
                        else
                        {
                           _loc6_ = TEAM_CHALLENGER_AVA_ATTACKERS;
                        }
                     }
                     else
                     {
                        _loc6_ = TEAM_CHALLENGER_AVA_ATTACKERS;
                     }
               }
               break;
            case FightTypeEnum.FIGHT_TYPE_PvT:
               switch(param2.teamId)
               {
                  case TeamEnum.TEAM_DEFENDER:
                     _loc6_ = TEAM_TAX_COLLECTOR_LOOK;
                     break;
                  case TeamEnum.TEAM_CHALLENGER:
                     _loc6_ = TEAM_CHALLENGER_LOOK;
               }
               break;
            case FightTypeEnum.FIGHT_TYPE_CHALLENGE:
               _loc6_ = TEAM_CHALLENGER_LOOK;
               break;
            default:
               switch(param2.teamId)
               {
                  case TeamEnum.TEAM_CHALLENGER:
                     _loc6_ = TEAM_CHALLENGER_LOOK;
                     break;
                  case TeamEnum.TEAM_DEFENDER:
                     _loc6_ = TEAM_DEFENDER_LOOK;
               }
         }
         _loc6_ = _loc6_.replace("}","||1=" + param4 + "}");
         var _loc7_:IEntity = new AnimatedCharacter(_loc5_,TiphonEntityLook.fromString(_loc6_));
         _loc7_.position = param3;
         IAnimated(_loc7_).setDirection(0);
         return _loc7_;
      }
   }
}
