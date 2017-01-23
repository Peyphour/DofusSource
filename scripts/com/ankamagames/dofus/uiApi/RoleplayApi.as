package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.almanax.AlmanaxCalendar;
   import com.ankamagames.dofus.datacenter.bonus.Bonus;
   import com.ankamagames.dofus.datacenter.bonus.MonsterDropChanceBonus;
   import com.ankamagames.dofus.datacenter.bonus.MonsterStarRateBonus;
   import com.ankamagames.dofus.datacenter.bonus.MonsterXPBonus;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.WorldFrame;
   import com.ankamagames.dofus.logic.game.common.managers.AlmanaxManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayInteractivesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.ZaapFrame;
   import com.ankamagames.dofus.logic.game.roleplay.managers.RoleplayManager;
   import com.ankamagames.dofus.logic.game.roleplay.types.RoleplaySpellCastProvider;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.AlternativeMonstersInGroupLightInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterWaveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GroupMonsterStaticInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GroupMonsterStaticInformationsWithAlternatives;
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupLightInformations;
   import com.ankamagames.dofus.scripts.SpellScriptManager;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class RoleplayApi implements IApi
   {
       
      
      private var _module:UiModule;
      
      protected var _log:Logger;
      
      public function RoleplayApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(RoleplayApi));
         super();
      }
      
      private function get roleplayEntitiesFrame() : RoleplayEntitiesFrame
      {
         return Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
      }
      
      private function get roleplayInteractivesFrame() : RoleplayInteractivesFrame
      {
         return Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
      }
      
      private function get spellInventoryManagementFrame() : SpellInventoryManagementFrame
      {
         return Kernel.getWorker().getFrame(SpellInventoryManagementFrame) as SpellInventoryManagementFrame;
      }
      
      private function get roleplayEmoticonFrame() : EmoticonFrame
      {
         return Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
      }
      
      private function get zaapFrame() : ZaapFrame
      {
         return Kernel.getWorker().getFrame(ZaapFrame) as ZaapFrame;
      }
      
      private function get worldFrame() : WorldFrame
      {
         return Kernel.getWorker().getFrame(WorldFrame) as WorldFrame;
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getTotalFightOnCurrentMap() : uint
      {
         return this.roleplayEntitiesFrame.fightNumber;
      }
      
      [Untrusted]
      public function getSpellToForgetList() : Array
      {
         var _loc2_:SpellWrapper = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in PlayedCharacterManager.getInstance().spellsInventory)
         {
            if(_loc2_.spellLevel > 1)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      [Untrusted]
      public function getEmotesList() : Array
      {
         var _loc1_:Array = this.roleplayEmoticonFrame.emotesList;
         return _loc1_;
      }
      
      [Untrusted]
      public function getUsableEmotesList() : Array
      {
         return this.roleplayEmoticonFrame.emotes;
      }
      
      [Untrusted]
      public function getSpawnMap() : uint
      {
         return this.zaapFrame.spawnMapId;
      }
      
      [Trusted]
      public function getEntitiesOnCell(param1:int) : Array
      {
         return EntitiesManager.getInstance().getEntitiesOnCell(param1);
      }
      
      [Trusted]
      public function getPlayersIdOnCurrentMap() : Array
      {
         return this.roleplayEntitiesFrame.playersId;
      }
      
      [Trusted]
      public function getPlayerIsInCurrentMap(param1:Number) : Boolean
      {
         return this.roleplayEntitiesFrame.playersId.indexOf(param1) != -1;
      }
      
      [Trusted]
      public function isUsingInteractive() : Boolean
      {
         if(!this.roleplayInteractivesFrame)
         {
            return false;
         }
         return this.roleplayInteractivesFrame.usingInteractive;
      }
      
      [Untrusted]
      public function getFight(param1:int) : Object
      {
         return this.roleplayEntitiesFrame.fights[param1];
      }
      
      [Trusted]
      public function putEntityOnTop(param1:AnimatedCharacter) : void
      {
         RoleplayManager.getInstance().putEntityOnTop(param1);
      }
      
      [Trusted]
      public function playGfx(param1:uint, param2:uint) : void
      {
         var _loc3_:ISequencer = new SerialSequencer();
         _loc3_.addStep(new AddGfxEntityStep(param1,param2,0,0,0,null,null,true));
         _loc3_.start();
      }
      
      [Untrusted]
      public function getEntityInfos(param1:Object) : Object
      {
         var _loc2_:RoleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         return _loc2_.entitiesFrame.getEntityInfos(param1.id);
      }
      
      [Untrusted]
      public function getEntityByName(param1:String) : Object
      {
         var _loc3_:IEntity = null;
         var _loc4_:GameRolePlayNamedActorInformations = null;
         var _loc2_:RoleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         for each(_loc3_ in EntitiesManager.getInstance().entities)
         {
            _loc4_ = _loc2_.entitiesFrame.getEntityInfos(_loc3_.id) as GameRolePlayNamedActorInformations;
            if(_loc4_ && param1 == _loc4_.name)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      [Trusted]
      public function switchButtonWrappers(param1:Object, param2:Object) : void
      {
         var _loc3_:int = param2.position;
         var _loc4_:int = param1.position;
         param2.setPosition(_loc4_);
         param1.setPosition(_loc3_);
      }
      
      [Trusted]
      public function setButtonWrapperActivation(param1:Object, param2:Boolean, param3:String = "") : void
      {
         param1.active = param2;
         var _loc4_:String = (XmlConfig.getInstance().getEntry("colors.tooltip.text.disabled") as String).replace("0x","#");
         if(param1.active)
         {
            param1.name = param1.name.replace("<font color=\'" + _loc4_ + "\'>","").replace("</font>","");
         }
         else if(param1.name.charAt(0) != "<")
         {
            param1.name = param1.name.replace(param1.name,"<font color=\'" + _loc4_ + "\'>" + param1.name + "</font>");
         }
         if(param3)
         {
            param1.description = param3;
         }
      }
      
      [Trusted]
      public function playEntityAnimation(param1:int, param2:String) : void
      {
         var _loc3_:RoleplayEntitiesFrame = null;
         var _loc4_:Dictionary = null;
         var _loc5_:Object = null;
         var _loc6_:AnimatedCharacter = null;
         var _loc7_:SerialSequencer = null;
         try
         {
            _loc3_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
            _loc4_ = _loc3_.getEntitiesDictionnary();
            if(_loc4_.length <= 0)
            {
               return;
            }
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_ is GameRolePlayNpcInformations && _loc5_.npcId == param1)
               {
                  _loc6_ = DofusEntities.getEntity(GameRolePlayNpcInformations(_loc5_).contextualId) as AnimatedCharacter;
                  _loc7_ = new SerialSequencer();
                  _loc7_.addStep(new PlayAnimationStep(_loc6_,param2));
                  _loc7_.start();
               }
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      [Trusted]
      public function playSpellAnimation(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:RoleplaySpellCastProvider = new RoleplaySpellCastProvider();
         _loc4_.castingSpell.casterId = PlayedCharacterManager.getInstance().id;
         _loc4_.castingSpell.spell = Spell.getSpellById(param1);
         _loc4_.castingSpell.spellRank = _loc4_.castingSpell.spell.getSpellLevel(param2);
         _loc4_.castingSpell.targetedCell = MapPoint.fromCellId(param3);
         var _loc5_:int = _loc4_.castingSpell.spell.getScriptId(_loc4_.castingSpell.isCriticalHit);
         SpellScriptManager.getInstance().runSpellScript(_loc5_,_loc4_,new Callback(this.executeSpellBuffer,null,true,true,_loc4_),new Callback(this.executeSpellBuffer,null,true,false,_loc4_));
      }
      
      [Untrusted]
      public function showNpcBubble(param1:int, param2:String) : void
      {
         var _loc5_:IRectangle = null;
         var _loc6_:Object = null;
         var _loc7_:IDisplayable = null;
         var _loc8_:ChatBubble = null;
         var _loc3_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         var _loc4_:Dictionary = _loc3_.getEntitiesDictionnary();
         if(_loc4_.length <= 0)
         {
            return;
         }
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_ is GameRolePlayNpcInformations && _loc6_.npcId == param1)
            {
               _loc7_ = DofusEntities.getEntity(GameRolePlayNpcInformations(_loc6_).contextualId) as IDisplayable;
               _loc5_ = _loc7_.absoluteBounds;
               _loc8_ = new ChatBubble(param2);
               TooltipManager.show(_loc8_,_loc5_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"npcBubble" + param1,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOPRIGHT,0,true,null,null,null,null,false,StrataEnum.STRATA_WORLD);
               return;
            }
         }
      }
      
      [Untrusted]
      public function getMonsterXpBoostMultiplier(param1:int) : Number
      {
         return this.worldFrame.getMonsterXpBoostMultiplier(param1);
      }
      
      [Untrusted]
      public function getMonsterDropBoostMultiplier(param1:int) : Number
      {
         return this.worldFrame.getMonsterDropBoostMultiplier(param1);
      }
      
      [Untrusted]
      public function getRaceXpBoostMultiplier(param1:int) : Number
      {
         return this.worldFrame.getRaceXpBoostMultiplier(param1);
      }
      
      [Untrusted]
      public function getRaceDropBoostMultiplier(param1:int) : Number
      {
         return this.worldFrame.getRaceDropBoostMultiplier(param1);
      }
      
      [Untrusted]
      public function getMonsterGroupString(param1:*) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:GroupMonsterStaticInformations = null;
         var _loc9_:GroupMonsterStaticInformationsWithAlternatives = null;
         var _loc10_:AlternativeMonstersInGroupLightInformations = null;
         var _loc11_:uint = 0;
         var _loc12_:MonsterInGroupLightInformations = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc2_:* = "";
         _loc2_ = _loc2_ + (param1.contextualId + ";");
         _loc2_ = _loc2_ + (param1.creationTime + ";");
         _loc2_ = _loc2_ + (param1.ageBonusRate + ";");
         _loc2_ = _loc2_ + ((!!param1.hasOwnProperty("nbWaves")?param1["nbWaves"]:0) + ";");
         var _loc6_:Array = new Array();
         _loc6_.push(param1.staticInfos);
         if(param1 is GameRolePlayGroupMonsterWaveInformations)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.alternatives.length)
            {
               _loc6_.push(param1.alternatives[_loc3_]);
               _loc3_++;
            }
         }
         var _loc8_:String = "";
         _loc3_ = 0;
         while(_loc3_ < _loc6_.length)
         {
            _loc7_ = _loc6_[_loc3_];
            _loc9_ = _loc7_ as GroupMonsterStaticInformationsWithAlternatives;
            if(_loc9_)
            {
               _loc11_ = 0;
               _loc8_ = "";
               _loc4_ = 0;
               while(_loc4_ < _loc9_.alternatives.length)
               {
                  _loc8_ = _loc8_ + (_loc9_.alternatives[_loc4_].playerCount + ":");
                  _loc11_ = Math.max(_loc11_,_loc9_.alternatives[_loc4_].monsters.length);
                  _loc4_++;
               }
               _loc2_ = _loc2_ + ("@" + _loc8_.substr(0,_loc8_.length - 1) + "|");
               _loc4_ = 0;
               while(_loc4_ < _loc11_)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc9_.alternatives.length)
                  {
                     _loc12_ = _loc4_ < _loc9_.alternatives[_loc5_].monsters.length?_loc9_.alternatives[_loc5_].monsters[_loc4_]:null;
                     if(_loc12_)
                     {
                        _loc13_ = _loc12_.creatureGenericId;
                     }
                     _loc14_ = !!_loc12_?uint(_loc12_.grade):uint(0);
                     _loc2_ = _loc2_ + (_loc14_ + ":");
                     _loc5_++;
                  }
                  _loc2_ = _loc2_.substr(0,_loc2_.length - 1) + "x" + _loc13_ + "|";
                  _loc4_++;
               }
               _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
            }
            else
            {
               _loc2_ = _loc2_ + (_loc7_.mainCreatureLightInfos.grade + "x" + _loc7_.mainCreatureLightInfos.creatureGenericId);
               _loc4_ = 0;
               while(_loc4_ < _loc7_.underlings.length)
               {
                  _loc2_ = _loc2_ + ("|" + _loc7_.underlings[_loc4_].grade + "x" + _loc7_.underlings[_loc4_].creatureGenericId);
                  _loc4_++;
               }
            }
            _loc2_ = _loc2_ + "&";
            _loc3_++;
         }
         _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
         return _loc2_;
      }
      
      [Untrusted]
      public function getMonsterGroupFromString(param1:String) : GameRolePlayGroupMonsterInformations
      {
         var _loc2_:GameRolePlayGroupMonsterInformations = null;
         var _loc9_:Vector.<GroupMonsterStaticInformations> = null;
         var _loc10_:int = 0;
         var _loc3_:Array = param1.split(";");
         var _loc4_:Number = _loc3_[1];
         var _loc5_:uint = _loc3_[2];
         var _loc6_:uint = _loc3_[3];
         var _loc7_:Array = _loc3_[4].split("&");
         var _loc8_:GroupMonsterStaticInformations = this.getMonsterStaticInfos(_loc7_[0]);
         if(_loc6_ > 0)
         {
            _loc9_ = new Vector.<GroupMonsterStaticInformations>();
            _loc10_ = 1;
            while(_loc10_ < _loc7_.length)
            {
               _loc9_.push(this.getMonsterStaticInfos(_loc7_[_loc10_]));
               _loc10_++;
            }
            _loc2_ = new GameRolePlayGroupMonsterWaveInformations();
            (_loc2_ as GameRolePlayGroupMonsterWaveInformations).initGameRolePlayGroupMonsterWaveInformations(0,null,null,_loc8_,_loc4_,_loc5_,0,0,false,false,false,_loc6_,_loc9_);
         }
         else
         {
            _loc2_ = new GameRolePlayGroupMonsterInformations();
            _loc2_.initGameRolePlayGroupMonsterInformations(0,null,null,_loc8_,_loc4_,_loc5_);
         }
         _loc2_.disposition = new EntityDispositionInformations();
         _loc2_.disposition.initEntityDispositionInformations(-1);
         return _loc2_;
      }
      
      [Untrusted]
      public function getAlmanaxCalendar() : AlmanaxCalendar
      {
         return AlmanaxManager.getInstance().calendar;
      }
      
      [Untrusted]
      public function getAlmanaxMonsterXpBonusMultiplier(param1:int) : Number
      {
         var _loc2_:int = 0;
         var _loc3_:Bonus = null;
         var _loc4_:Number = NaN;
         for each(_loc2_ in AlmanaxManager.getInstance().calendar.bonusesIds)
         {
            _loc3_ = Bonus.getBonusById(_loc2_);
            if(_loc3_ is MonsterXPBonus && (_loc3_.isRespected(param1) || _loc3_.isRespected(Monster.getMonsterById(param1).race)))
            {
               if(isNaN(_loc4_))
               {
                  _loc4_ = 1;
               }
               _loc4_ = _loc4_ * (_loc3_.amount / 100);
            }
         }
         return 1 + (!!isNaN(_loc4_)?0:_loc4_);
      }
      
      [Untrusted]
      public function getAlmanaxMonsterDropChanceBonusMultiplier(param1:int) : Number
      {
         var _loc2_:int = 0;
         var _loc3_:Bonus = null;
         var _loc4_:Number = NaN;
         for each(_loc2_ in AlmanaxManager.getInstance().calendar.bonusesIds)
         {
            _loc3_ = Bonus.getBonusById(_loc2_);
            if(_loc3_ is MonsterDropChanceBonus && (_loc3_.isRespected(param1) || _loc3_.isRespected(Monster.getMonsterById(param1).race)))
            {
               if(isNaN(_loc4_))
               {
                  _loc4_ = 1;
               }
               _loc4_ = _loc4_ * (_loc3_.amount / 100);
            }
         }
         return 1 + (!!isNaN(_loc4_)?0:_loc4_);
      }
      
      [Untrusted]
      public function getAlmanaxMonsterStarRateBonus() : int
      {
         var _loc1_:int = 0;
         var _loc2_:Bonus = null;
         for each(_loc1_ in AlmanaxManager.getInstance().calendar.bonusesIds)
         {
            _loc2_ = Bonus.getBonusById(_loc1_);
            if(_loc2_ is MonsterStarRateBonus && _loc2_.isRespected())
            {
               return _loc2_.amount;
            }
         }
         return 0;
      }
      
      private function getMonsterStaticInfos(param1:String) : GroupMonsterStaticInformations
      {
         var _loc2_:GroupMonsterStaticInformations = null;
         var _loc3_:Array = null;
         var _loc4_:Vector.<MonsterInGroupInformations> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Vector.<AlternativeMonstersInGroupLightInformations> = null;
         var _loc10_:AlternativeMonstersInGroupLightInformations = null;
         var _loc11_:Vector.<MonsterInGroupLightInformations> = null;
         var _loc12_:MonsterInGroupLightInformations = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:GroupMonsterStaticInformationsWithAlternatives = null;
         if(param1.charAt(0) == "@")
         {
            param1 = param1.substr(1);
            _loc3_ = param1.split("|");
            _loc7_ = _loc3_[0].split(":");
            _loc3_.shift();
            if(_loc3_.length > 1)
            {
               _loc4_ = new Vector.<MonsterInGroupInformations>();
               _loc5_ = 1;
               while(_loc5_ < _loc3_.length)
               {
                  _loc8_ = _loc3_[_loc5_].substr(_loc3_[_loc5_].lastIndexOf(":") + 1);
                  _loc4_.push(this.getMonsterInGroupInfo(_loc8_));
                  _loc5_++;
               }
            }
            _loc9_ = new Vector.<AlternativeMonstersInGroupLightInformations>();
            _loc5_ = 0;
            while(_loc5_ < _loc7_.length)
            {
               _loc10_ = new AlternativeMonstersInGroupLightInformations();
               _loc11_ = new Vector.<MonsterInGroupLightInformations>();
               _loc6_ = 0;
               while(_loc6_ < _loc3_.length)
               {
                  _loc13_ = _loc3_[_loc6_].split("x");
                  _loc14_ = _loc13_[0].split(":");
                  if(_loc14_[_loc5_] > 0)
                  {
                     _loc12_ = new MonsterInGroupLightInformations();
                     _loc12_.initMonsterInGroupLightInformations(_loc13_[1],_loc14_[_loc5_]);
                     _loc11_.push(_loc12_);
                  }
                  _loc6_++;
               }
               _loc10_.initAlternativeMonstersInGroupLightInformations(_loc7_[_loc5_],_loc11_);
               _loc9_.push(_loc10_);
               _loc5_++;
            }
            _loc15_ = new GroupMonsterStaticInformationsWithAlternatives();
            _loc15_.initGroupMonsterStaticInformationsWithAlternatives(this.getMonsterInGroupInfo(_loc3_[0].substr(_loc3_[0].lastIndexOf(":") + 1)),_loc4_,_loc9_);
            _loc2_ = _loc15_;
         }
         else
         {
            _loc3_ = param1.split("|");
            _loc2_ = new GroupMonsterStaticInformations();
            if(_loc3_.length > 1)
            {
               _loc4_ = new Vector.<MonsterInGroupInformations>();
               _loc5_ = 1;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_.push(this.getMonsterInGroupInfo(_loc3_[_loc5_]));
                  _loc5_++;
               }
            }
            _loc2_.initGroupMonsterStaticInformations(this.getMonsterInGroupInfo(_loc3_[0]),_loc4_);
         }
         return _loc2_;
      }
      
      private function getMonsterInGroupInfo(param1:String) : MonsterInGroupInformations
      {
         var _loc2_:Array = param1.split("x");
         var _loc3_:MonsterInGroupInformations = new MonsterInGroupInformations();
         _loc3_.initMonsterInGroupInformations(_loc2_[1],_loc2_[0]);
         return _loc3_;
      }
      
      private function executeSpellBuffer(param1:Function, param2:Boolean, param3:Boolean = false, param4:RoleplaySpellCastProvider = null) : void
      {
         var _loc6_:ISequencable = null;
         var _loc5_:SerialSequencer = new SerialSequencer();
         for each(_loc6_ in param4.stepsBuffer)
         {
            _loc5_.addStep(_loc6_);
         }
         _loc5_.start();
      }
   }
}
