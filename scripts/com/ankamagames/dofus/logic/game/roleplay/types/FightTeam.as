package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.enums.FightOptionsEnum;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class FightTeam extends GameContextActorInformations
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightTeam));
       
      
      public var fight:Fight;
      
      public var teamType:uint;
      
      public var teamEntity:IEntity;
      
      public var teamInfos:FightTeamInformations;
      
      public var teamOptions:Array;
      
      public function FightTeam(param1:Fight, param2:uint, param3:IEntity, param4:FightTeamInformations, param5:FightOptionsInformations)
      {
         super();
         this.fight = param1;
         this.teamType = param2;
         this.teamEntity = param3;
         this.teamInfos = param4;
         this.look = EntityLookAdapter.toNetwork((param3 as AnimatedCharacter).look);
         this.teamOptions = new Array();
         this.teamOptions[FightOptionsEnum.FIGHT_OPTION_ASK_FOR_HELP] = param5.isAskingForHelp;
         this.teamOptions[FightOptionsEnum.FIGHT_OPTION_SET_CLOSED] = param5.isClosed;
         this.teamOptions[FightOptionsEnum.FIGHT_OPTION_SET_SECRET] = param5.isSecret;
         this.teamOptions[FightOptionsEnum.FIGHT_OPTION_SET_TO_PARTY_ONLY] = param5.isRestrictedToPartyOnly;
      }
      
      public function hasGroupMember() : Boolean
      {
         var _loc4_:PartyMemberWrapper = null;
         var _loc5_:FightTeamMemberInformations = null;
         var _loc1_:Boolean = false;
         var _loc2_:PartyManagementFrame = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
         var _loc3_:Vector.<String> = new Vector.<String>();
         for each(_loc4_ in _loc2_.partyMembers)
         {
            _loc3_.push(_loc4_.name);
         }
         for each(_loc5_ in this.teamInfos.teamMembers)
         {
            if(_loc5_ && _loc5_ is FightTeamMemberCharacterInformations && _loc3_.indexOf(FightTeamMemberCharacterInformations(_loc5_).name) != -1)
            {
               _loc1_ = true;
               break;
            }
         }
         return _loc1_;
      }
      
      public function hasOptions() : Boolean
      {
         var _loc2_:* = undefined;
         var _loc1_:Boolean = false;
         for(_loc2_ in this.teamOptions)
         {
            if(this.teamOptions[_loc2_])
            {
               _loc1_ = true;
               break;
            }
         }
         return _loc1_;
      }
   }
}
