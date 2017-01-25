package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import flash.utils.Dictionary;
   
   public class SpeakingEntitiesManager
   {
      
      private static var _instance:SpeakingEntitiesManager;
       
      
      private var _triggerAssoc:Dictionary;
      
      private var _entitiesAssoc:Dictionary;
      
      public function SpeakingEntitiesManager()
      {
         this._triggerAssoc = new Dictionary();
         this._entitiesAssoc = new Dictionary();
         super();
      }
      
      public static function getInstance() : SpeakingEntitiesManager
      {
         if(_instance == null)
         {
            _instance = new SpeakingEntitiesManager();
            _instance.init();
         }
         return _instance;
      }
      
      private function init() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:EntityTrigger = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Dictionary = null;
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_PLAYER_LOOSE_LIFE] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_PLAYER_LOOSE_LIFE_1")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_PLAYER_LOOSE_LIFE_2")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_PLAYER_LOOSE_LIFE_3")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_PLAYER_LOOSE_LIFE_4"))];
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_PLAYER_TURN_START] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.5,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_PLAYER_TURN_START_1"))];
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_PLAYER_CLOSE_COMBAT] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.5,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_PLAYER_CLOSE_COMBAT_1"))];
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_PLAYER_TACKLED] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,1,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_PLAYER_TACKLED_1"))];
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_ALLIED_LOOSE_LIFE] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ALLIED_LOOSE_LIFE_1")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ALLIED_LOOSE_LIFE_2")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ALLIED_LOOSE_LIFE_3")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ALLIED_LOOSE_LIFE_4"))];
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_ENEMY_LOOSE_LIFE] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.1,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ENEMY_LOOSE_LIFE_1")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.1,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ENEMY_LOOSE_LIFE_2")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.1,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ENEMY_LOOSE_LIFE_3")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.1,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ENEMY_LOOSE_LIFE_4")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.1,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ENEMY_LOOSE_LIFE_5")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.1,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_ENEMY_LOOSE_LIFE_6"))];
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_KILL_ENEMY] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_KILL_ENEMY_1")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_KILL_ENEMY_2")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_KILL_ENEMY_3")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.15,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_KILL_ENEMY_4"))];
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_CC_OWNER] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.25,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_CC_OWNER_1")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.25,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_CC_OWNER_2")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.25,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_CC_OWNER_3")),new EntityTrigger(EntityTrigger.ENTITY_TYPE_MONSTER,4310,null,0.25,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_CC_OWNER_4"))];
         this._triggerAssoc[SpeakingItemManager.SPEAK_TRIGGER_NEW_MAP] = [new EntityTrigger(EntityTrigger.ENTITY_TYPE_NPC,3065,"PL<11&PO!17485",1,I18n.getUiText("ui.speakingEntity.SPEAK_TRIGGER_NEW_MAP"),true)];
         for(_loc1_ in this._triggerAssoc)
         {
            for each(_loc2_ in this._triggerAssoc[_loc1_])
            {
               if(!this._entitiesAssoc[_loc2_.entityType])
               {
                  this._entitiesAssoc[_loc2_.entityType] = new Dictionary();
               }
               _loc3_ = this._entitiesAssoc[_loc2_.entityType];
               if(!_loc3_[_loc2_.entityId])
               {
                  _loc3_[_loc2_.entityId] = new Dictionary();
               }
               _loc4_ = _loc3_[_loc2_.entityId];
               if(!_loc4_[_loc1_])
               {
                  _loc4_[_loc1_] = [];
               }
               _loc4_[_loc1_].push(_loc2_);
            }
         }
      }
      
      public function triggerEvent(param1:int) : void
      {
         var _loc3_:Dictionary = null;
         var _loc5_:uint = 0;
         var _loc7_:GameContextActorInformations = null;
         var _loc8_:* = undefined;
         var _loc9_:FightEntitiesFrame = null;
         var _loc10_:EntityTrigger = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:uint = 0;
         var _loc2_:Dictionary = new Dictionary();
         var _loc4_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(_loc4_)
         {
            _loc3_ = _loc4_.getEntitiesDictionnary();
         }
         else
         {
            _loc9_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
            if(_loc9_)
            {
               _loc3_ = _loc9_.getEntitiesDictionnary();
            }
            else
            {
               return;
            }
         }
         var _loc6_:Array = [];
         for each(_loc7_ in _loc3_)
         {
            _loc6_ = null;
            _loc5_ = _loc7_.contextualId;
            if(_loc7_ is GameRolePlayNpcInformations && this._entitiesAssoc[EntityTrigger.ENTITY_TYPE_NPC] && this._entitiesAssoc[EntityTrigger.ENTITY_TYPE_NPC][GameRolePlayNpcInformations(_loc7_).npcId] && this._entitiesAssoc[EntityTrigger.ENTITY_TYPE_NPC][GameRolePlayNpcInformations(_loc7_).npcId][param1])
            {
               _loc6_ = this._entitiesAssoc[EntityTrigger.ENTITY_TYPE_NPC][GameRolePlayNpcInformations(_loc7_).npcId][param1];
            }
            else if(_loc7_ is GameFightMonsterInformations && this._entitiesAssoc[EntityTrigger.ENTITY_TYPE_MONSTER] && this._entitiesAssoc[EntityTrigger.ENTITY_TYPE_MONSTER][GameFightMonsterInformations(_loc7_).creatureGenericId] && this._entitiesAssoc[EntityTrigger.ENTITY_TYPE_MONSTER][GameFightMonsterInformations(_loc7_).creatureGenericId][param1])
            {
               _loc6_ = this._entitiesAssoc[EntityTrigger.ENTITY_TYPE_MONSTER][GameFightMonsterInformations(_loc7_).creatureGenericId][param1];
            }
            if(_loc6_)
            {
               for each(_loc10_ in _loc6_)
               {
                  if(!(_loc10_.criterions != null && !_loc10_.criterions.isRespected))
                  {
                     if(!_loc2_[_loc5_])
                     {
                        _loc2_[_loc5_] = [];
                     }
                     _loc2_[_loc5_].push(_loc10_);
                  }
               }
            }
         }
         for(_loc8_ in _loc2_)
         {
            _loc11_ = 0;
            for each(_loc10_ in _loc2_[_loc8_])
            {
               _loc11_ = _loc11_ + _loc10_.probability;
            }
            _loc12_ = Math.random() * (_loc11_ > 1?_loc11_:1);
            _loc13_ = 1;
            while(_loc13_ <= _loc2_[_loc8_].length)
            {
               _loc10_ = _loc2_[_loc8_][_loc13_ - 1];
               if(_loc12_ > _loc13_ * _loc10_.probability)
               {
                  _loc13_++;
                  continue;
               }
               this.speak(_loc10_.text,_loc8_,_loc10_.entityName,_loc10_.displayInChat);
               break;
            }
         }
      }
      
      private function speak(param1:String, param2:int, param3:String = null, param4:Boolean = false) : void
      {
         var _loc6_:IRectangle = null;
         var _loc7_:ChatBubble = null;
         var _loc5_:IDisplayable = DofusEntities.getEntity(param2) as IDisplayable;
         if(_loc5_)
         {
            _loc6_ = _loc5_.absoluteBounds;
            _loc7_ = new ChatBubble(param1);
            TooltipManager.show(_loc7_,_loc6_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"entityBubble" + param2,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOPRIGHT,0,true,null,null,null,null,false,StrataEnum.STRATA_WORLD);
         }
         if(param4)
         {
            KernelEventsManager.getInstance().processCallback(ChatHookList.LivingObjectMessage,param3,param1,TimeManager.getInstance().getTimestamp());
         }
      }
   }
}

import com.ankamagames.dofus.datacenter.items.criterion.GroupItemCriterion;
import com.ankamagames.dofus.datacenter.monsters.Monster;
import com.ankamagames.dofus.datacenter.npcs.Npc;

class EntityTrigger
{
   
   public static const ENTITY_TYPE_NPC:uint = 0;
   
   public static const ENTITY_TYPE_MONSTER:uint = 1;
    
   
   public var criterions:GroupItemCriterion;
   
   public var probability:Number;
   
   public var text:String;
   
   public var displayInChat:Boolean = false;
   
   public var entityType:uint;
   
   public var entityId:uint;
   
   public var entityName:String;
   
   function EntityTrigger(param1:uint, param2:uint, param3:String, param4:Number, param5:String, param6:Boolean = false)
   {
      super();
      this.entityType = param1;
      this.entityId = param2;
      this.criterions = new GroupItemCriterion(param3);
      this.probability = param4;
      this.text = param5;
      this.displayInChat = param6;
      try
      {
         if(param1 == ENTITY_TYPE_NPC)
         {
            this.entityName = Npc.getNpcById(param2).name;
         }
         else if(param1 == ENTITY_TYPE_MONSTER)
         {
            this.entityName = Monster.getMonsterById(param2).name;
         }
         return;
      }
      catch(e:Error)
      {
         return;
      }
   }
}
