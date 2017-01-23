package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterWaveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GroupMonsterStaticInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GroupMonsterStaticInformationsWithAlternatives;
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupLightInformations;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import utils.FormulaHandler;
   
   public class WorldRpMonstersGroupTooltipUi
   {
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var partyApi:PartyApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var sysApi:SystemApi;
      
      public var socialApi:SocialApi;
      
      public var timeApi:TimeApi;
      
      public var roleplayApi:RoleplayApi;
      
      private var _numFirstMonsters:uint;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_wave:GraphicContainer;
      
      public var ctr_xp:GraphicContainer;
      
      public var ctr_malusDropArena:GraphicContainer;
      
      public var ctr_back:GraphicContainer;
      
      public var ctr_main:GraphicContainer;
      
      public var ctr_starsParent:GraphicContainer;
      
      public var ctr_stars:GraphicContainer;
      
      public var ctr_groupOptimal:GraphicContainer;
      
      public var ctr_malusDrop:GraphicContainer;
      
      public var ctr_level:GraphicContainer;
      
      public var ctr_separatorMalus:GraphicContainer;
      
      public var ctr_separatorXp:GraphicContainer;
      
      public var lbl_level:Label;
      
      public var lbl_monsterList:Label;
      
      public var lbl_disabledMonsterList:Label;
      
      public var lbl_nbWaves:Label;
      
      public var lbl_monsterXp:Label;
      
      public var lbl_groupOptimal:Label;
      
      public var lbl_malusDrop:Label;
      
      public var tx_wave:Texture;
      
      public var star00:Texture;
      
      public var star01:Texture;
      
      public var star02:Texture;
      
      public var star03:Texture;
      
      public var star04:Texture;
      
      public var star10:Texture;
      
      public var star11:Texture;
      
      public var star12:Texture;
      
      public var star13:Texture;
      
      public var star14:Texture;
      
      public var star20:Texture;
      
      public var star21:Texture;
      
      public var star22:Texture;
      
      public var star23:Texture;
      
      public var star24:Texture;
      
      public function WorldRpMonstersGroupTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Monster = null;
         var _loc8_:PartyMemberWrapper = null;
         var _loc12_:int = 0;
         var _loc13_:GuildMember = null;
         var _loc14_:Number = NaN;
         var _loc20_:Object = null;
         var _loc28_:Number = NaN;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:PrismSubAreaWrapper = null;
         var _loc35_:Object = null;
         var _loc36_:GroupMonsterStaticInformations = null;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:MonstersGroupData = null;
         var _loc40_:int = 0;
         var _loc2_:Object = param1.data;
         if(_loc2_.ageBonusRate != 0)
         {
            _loc28_ = this.timeApi.getTimestamp() - this.timeApi.getTimezoneOffset() - _loc2_.creationTime;
            _loc29_ = (100 + this.roleplayApi.getAlmanaxMonsterStarRateBonus()) / 100;
            _loc3_ = Math.min(200,_loc28_ / (_loc2_.ageBonusRate / _loc29_));
         }
         var _loc4_:* = _loc3_ > 0;
         this.ctr_back.width = 1;
         this.ctr_wave.height = 1;
         this.lbl_monsterList.width = 1;
         this.lbl_monsterXp.width = 1;
         this.lbl_disabledMonsterList.width = 1;
         this.ctr_level.width = 1;
         this.ctr_groupOptimal.width = 1;
         this.ctr_malusDrop.width = 1;
         this.ctr_separatorMalus.width = 1;
         this.ctr_separatorXp.width = 1;
         this.ctr_malusDropArena.height = 1;
         this.star00.visible = false;
         this.star01.visible = false;
         this.star02.visible = false;
         this.star03.visible = false;
         this.star04.visible = false;
         this.star10.visible = false;
         this.star11.visible = false;
         this.star12.visible = false;
         this.star13.visible = false;
         this.star14.visible = false;
         this.star20.visible = false;
         this.star21.visible = false;
         this.star22.visible = false;
         this.star23.visible = false;
         this.star24.visible = false;
         if(_loc2_.alignmentSide == 1)
         {
            this.lbl_monsterList.cssClass = "bonta";
            this.lbl_disabledMonsterList.cssClass = "bonta";
         }
         else if(_loc2_.alignmentSide == 2)
         {
            this.lbl_monsterList.cssClass = "brakmar";
            this.lbl_disabledMonsterList.cssClass = "brakmar";
         }
         else
         {
            this.lbl_monsterList.cssClass = "center";
            this.lbl_disabledMonsterList.cssClass = "center";
         }
         if(_loc4_)
         {
            this.ctr_starsParent.visible = true;
            this.ctr_starsParent.height = 15;
            _loc31_ = _loc3_;
            if(_loc31_ > 100)
            {
               _loc30_ = 2;
               _loc31_ = _loc31_ - 100;
            }
            else
            {
               _loc30_ = 1;
            }
            _loc32_ = Math.round(_loc31_ / 20);
            _loc5_ = 0;
            while(_loc5_ < _loc32_)
            {
               this["star" + _loc30_ + "" + _loc5_].visible = true;
               _loc5_++;
            }
            _loc5_ = _loc5_;
            while(_loc5_ < 5)
            {
               this["star" + (_loc30_ - 1) + "" + _loc5_].visible = true;
               _loc5_++;
            }
         }
         else
         {
            this.hideBloc(this.ctr_starsParent);
         }
         var _loc7_:Object = this.partyApi.getPartyMembers();
         var _loc9_:Object = this.playerApi.getPlayedCharacterInfo();
         var _loc10_:Object = this.playerApi.characteristics();
         var _loc11_:Array = new Array();
         if(_loc7_.length == 0 && this.playerApi.hasCompanion())
         {
            _loc11_.push(FormulaHandler.createGroupMember(this.playerApi.getPlayedCharacterInfo().level));
            _loc11_.push(FormulaHandler.createGroupMember(this.playerApi.getPlayedCharacterInfo().level,true));
         }
         else
         {
            for each(_loc8_ in _loc7_)
            {
               _loc11_.push(FormulaHandler.createGroupMember(_loc8_.level));
               _loc33_ = _loc8_.companions.length;
               _loc5_ = 0;
               while(_loc5_ < _loc33_)
               {
                  _loc11_.push(FormulaHandler.createGroupMember(_loc8_.level,true));
                  _loc5_++;
               }
            }
         }
         _loc12_ = _loc10_.wisdom.base + _loc10_.wisdom.additionnal + _loc10_.wisdom.objectsAndMountBonus + _loc10_.wisdom.alignGiftBonus + _loc10_.wisdom.contextModif;
         _loc13_ = this.getPlayerGuild(_loc9_.id);
         if(this.socialApi.hasAlliance())
         {
            _loc34_ = this.socialApi.getPrismSubAreaById(this.playerApi.currentSubArea().id);
            if(this.socialApi.hasAlliance() && _loc34_ && _loc34_.mapId != -1 && (!_loc34_.alliance || _loc34_.alliance && _loc34_.alliance.allianceId == this.socialApi.getAlliance().allianceId))
            {
               _loc14_ = 25;
            }
         }
         var _loc15_:* = FormulaHandler.createPlayerData(_loc9_.level,_loc12_,this.playerApi.getExperienceBonusPercent(),this.playerApi.getMount() != null && this.playerApi.isRidding()?Number(this.playerApi.getMount().xpRatio):Number(0),_loc13_ != null?Number(_loc13_.experienceGivenPercent):Number(0),_loc14_);
         this._numFirstMonsters = 0;
         var _loc16_:MonstersGroupData = this.getMonstersGroupData(_loc2_.staticInfos,_loc15_,_loc11_,_loc3_);
         this.lbl_level.text = this.uiApi.getText("ui.common.level") + " " + _loc16_.level;
         var _loc17_:String = "";
         var _loc18_:String = "";
         var _loc19_:Array = _loc16_.group;
         for each(_loc20_ in _loc19_)
         {
            if(_loc20_.visible)
            {
               _loc6_ = this.dataApi.getMonsterFromId(_loc20_.monsterId);
               _loc17_ = _loc17_ + ("\n" + (!!_loc6_.isMiniBoss?"<b>":"") + _loc6_.name + " (" + _loc20_.level + ")" + (!!_loc6_.isMiniBoss?"</b>":""));
            }
            else
            {
               _loc6_ = this.dataApi.getMonsterFromId(_loc20_.monsterId);
               _loc18_ = _loc18_ + ("\n" + _loc6_.name + " (" + _loc20_.level + ")");
            }
         }
         if(_loc17_)
         {
            _loc17_ = _loc17_.substr(1);
         }
         var _loc21_:String = "";
         var _loc22_:* = _loc11_.length > 0;
         var _loc23_:GameRolePlayGroupMonsterWaveInformations = _loc2_ as GameRolePlayGroupMonsterWaveInformations;
         if(_loc23_)
         {
            this.ctr_wave.visible = true;
            this.lbl_nbWaves.text = "x " + (_loc23_.nbWaves + 1);
            this.lbl_nbWaves.fullWidth();
            this.ctr_wave.height = this.lbl_nbWaves.height;
            _loc35_ = _loc23_.alternatives;
            _loc37_ = _loc16_.xpSolo;
            _loc38_ = _loc16_.xpGroup;
            for each(_loc36_ in _loc35_)
            {
               _loc39_ = this.getMonstersGroupData(_loc36_,_loc15_,_loc11_,_loc3_);
               _loc37_ = _loc37_ + _loc39_.xpSolo;
               _loc38_ = _loc38_ + _loc39_.xpGroup;
            }
            _loc21_ = _loc21_ + this.uiApi.getText("ui.tooltip.monsterXpAlone",this.utilApi.formateIntToString(_loc37_));
            if(_loc22_)
            {
               _loc21_ = _loc21_ + ("\n" + this.uiApi.getText("ui.tooltip.monsterXpParty",this.utilApi.formateIntToString(_loc38_)));
            }
         }
         else
         {
            this.hideBloc(this.ctr_wave);
            _loc21_ = _loc21_ + this.uiApi.getText("ui.tooltip.monsterXpAlone",this.utilApi.formateIntToString(_loc16_.xpSolo));
            if(_loc22_)
            {
               _loc21_ = _loc21_ + ("\n" + this.uiApi.getText("ui.tooltip.monsterXpParty",this.utilApi.formateIntToString(_loc16_.xpGroup)));
            }
         }
         this.lbl_monsterXp.text = _loc21_;
         this.lbl_monsterList.text = _loc17_;
         this.lbl_disabledMonsterList.visible = _loc18_ != "";
         this.lbl_disabledMonsterList.text = _loc18_;
         this.lbl_monsterList.fullWidth();
         this.lbl_disabledMonsterList.fullWidth();
         this.lbl_monsterXp.fullWidth();
         this.lbl_level.fullWidth();
         if(_loc2_.lootShare != null && _loc2_.lootShare > 0)
         {
            _loc40_ = FormulaHandler.getArenaMalusDrop(_loc2_.lootShare,_loc7_.length);
            if(_loc40_ > 0)
            {
               this.ctr_separatorMalus.visible = true;
               this.lbl_groupOptimal.text = this.uiApi.getText("ui.tooltip.maxMemberParty",_loc2_.lootShare);
               this.lbl_groupOptimal.fullWidth();
               this.lbl_malusDrop.text = this.uiApi.getText("ui.tooltip.arenaMalus",_loc40_);
               this.lbl_malusDrop.fullWidth();
               this.ctr_malusDropArena.visible = true;
            }
            else
            {
               this.ctr_separatorMalus.visible = false;
               this.hideBloc(this.ctr_malusDropArena);
            }
         }
         else
         {
            this.ctr_separatorMalus.visible = false;
            this.hideBloc(this.ctr_malusDropArena);
         }
         var _loc24_:int = this.getMaxWidth();
         this.lbl_monsterList.width = _loc24_;
         this.lbl_monsterXp.width = _loc24_;
         this.lbl_disabledMonsterList.width = _loc24_;
         this.ctr_xp.width = _loc24_;
         this.ctr_level.width = _loc24_;
         this.ctr_starsParent.width = _loc24_;
         this.ctr_main.width = _loc24_;
         this.ctr_groupOptimal.width = _loc24_;
         this.ctr_malusDrop.width = _loc24_;
         this.ctr_malusDropArena.width = _loc24_;
         this.ctr_separatorMalus.width = _loc24_;
         this.ctr_separatorXp.width = _loc24_;
         if(this.ctr_wave.visible)
         {
            this.tx_wave.x = _loc24_ / 2 - (this.tx_wave.width + this.lbl_nbWaves.width) / 2;
            this.lbl_nbWaves.x = this.tx_wave.x + this.tx_wave.width;
         }
         this.ctr_back.width = _loc24_ + 8;
         if(this.ctr_malusDropArena.visible)
         {
            this.ctr_malusDropArena.height = this.lbl_groupOptimal.textHeight + this.lbl_malusDrop.textHeight;
         }
         this.uiApi.me().render();
         var _loc25_:* = this.ctr_back.height == 0;
         var _loc26_:Number = this.ctr_main.height;
         var _loc27_:int = this.ctr_separatorXp.y + this.lbl_monsterList.height + this.lbl_disabledMonsterList.height - (!!this.lbl_disabledMonsterList.visible?25:0);
         if(_loc26_ < _loc27_)
         {
            _loc26_ = _loc27_;
         }
         if(_loc25_)
         {
            if(_loc22_)
            {
               _loc26_ = _loc26_ + 21;
            }
            if(_loc4_ && this.ctr_wave.visible)
            {
               _loc26_ = _loc26_ + 13;
            }
            else if(!this.ctr_wave.visible)
            {
               _loc26_ = _loc26_ - (!!_loc4_?14:28);
            }
         }
         if(!_loc25_ && this.lbl_disabledMonsterList.visible)
         {
            _loc26_ = _loc26_ + 8;
         }
         this.ctr_back.height = _loc26_;
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset,true,param1.data.disposition.cellId);
      }
      
      private function getMaxWidth() : int
      {
         var _loc1_:int = 0;
         if(this.ctr_stars.visible && this.ctr_stars.width > this.lbl_monsterList.width && this.ctr_stars.width > this.lbl_monsterXp.width && this.ctr_stars.width > this.lbl_disabledMonsterList.width && this.ctr_stars.width > this.lbl_level.width)
         {
            _loc1_ = this.ctr_stars.width;
         }
         else if(this.lbl_level.width > this.ctr_stars.width && this.lbl_level.width > this.lbl_monsterList.width && this.lbl_level.width > this.lbl_monsterXp.width && this.lbl_level.width > this.lbl_disabledMonsterList.width)
         {
            _loc1_ = this.lbl_level.width;
         }
         else if(this.lbl_groupOptimal.visible && this.lbl_groupOptimal.width > this.lbl_monsterList.width && this.lbl_groupOptimal.width > this.lbl_monsterXp.width && this.lbl_groupOptimal.width > this.lbl_disabledMonsterList.width && this.lbl_groupOptimal.width > this.lbl_level.width)
         {
            _loc1_ = this.lbl_groupOptimal.width;
         }
         else if(this.lbl_malusDrop.visible && this.lbl_malusDrop.width > this.lbl_monsterList.width && this.lbl_malusDrop.width > this.lbl_monsterXp.width && this.lbl_malusDrop.width > this.lbl_disabledMonsterList.width && this.lbl_malusDrop.width > this.lbl_level.width)
         {
            _loc1_ = this.lbl_malusDrop.width;
         }
         else if(this.lbl_disabledMonsterList.visible && this.lbl_disabledMonsterList.width > this.lbl_monsterXp.width && this.lbl_disabledMonsterList.width >= this.lbl_disabledMonsterList.width && this.lbl_disabledMonsterList.width > this.lbl_monsterList.width && this.lbl_disabledMonsterList.width >= this.ctr_stars.width && this.lbl_disabledMonsterList.width > this.lbl_level.width)
         {
            _loc1_ = this.lbl_disabledMonsterList.width;
         }
         else if(this.lbl_monsterXp.visible && this.lbl_monsterXp.width > this.ctr_stars.width && this.lbl_monsterXp.width > this.lbl_monsterList.width && this.lbl_monsterXp.width > this.lbl_disabledMonsterList.width && this.lbl_monsterXp.width > this.lbl_level.width)
         {
            _loc1_ = this.lbl_monsterXp.width;
         }
         else
         {
            _loc1_ = this.lbl_monsterList.width;
         }
         return _loc1_;
      }
      
      private function hideBloc(param1:GraphicContainer) : void
      {
         param1.height = 0;
         param1.visible = false;
      }
      
      public function getRealMonsterGrade(param1:Array, param2:int) : int
      {
         var _loc3_:MonsterInGroupLightInformations = null;
         if(param1 == null)
         {
            return 0;
         }
         for each(_loc3_ in param1)
         {
            if(_loc3_.creatureGenericId == param2)
            {
               param1.splice(param1.indexOf(_loc3_),1);
               return _loc3_.grade;
            }
         }
         return -1;
      }
      
      private function xtremAdvancedSortMonster(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = 0;
         if(param1.monsterId == param2.monsterId)
         {
            if(param1.level > param2.level)
            {
               _loc3_ = -1;
            }
            else if(param1.level < param2.level)
            {
               _loc3_ = 1;
            }
            else
            {
               _loc3_ = 0;
            }
         }
         else if(param1.maxLevel > param2.maxLevel)
         {
            _loc3_ = -1;
         }
         else if(param1.maxLevel < param2.maxLevel)
         {
            _loc3_ = 1;
         }
         else if(param1.totalLevel > param2.totalLevel)
         {
            _loc3_ = -1;
         }
         else if(param1.totalLevel < param2.totalLevel)
         {
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      private function truncate(param1:Number) : int
      {
         var _loc2_:uint = Math.pow(10,0);
         var _loc3_:Number = param1 * _loc2_;
         return int(_loc3_) / _loc2_;
      }
      
      private function getPlayerGuild(param1:Number) : GuildMember
      {
         var _loc2_:GuildMember = null;
         for each(_loc2_ in this.socialApi.getGuildMembers())
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function getMonstersGroupData(param1:GroupMonsterStaticInformations, param2:*, param3:Array, param4:int) : MonstersGroupData
      {
         var _loc5_:MonstersGroupData = null;
         var _loc9_:* = undefined;
         var _loc11_:PartyMemberWrapper = null;
         var _loc12_:Monster = null;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:Object = null;
         var _loc21_:uint = 0;
         var _loc24_:int = 0;
         var _loc25_:Object = null;
         var _loc26_:Object = null;
         var _loc27_:Object = null;
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:int = this.dataApi.getMonsterFromId(param1.mainCreatureLightInfos.creatureGenericId).grades[param1.mainCreatureLightInfos.grade - 1].level;
         _loc6_[param1.mainCreatureLightInfos.creatureGenericId] = _loc8_;
         _loc7_[param1.mainCreatureLightInfos.creatureGenericId] = _loc8_;
         var _loc10_:Object = this.partyApi.getPartyMembers();
         for each(_loc9_ in param1.underlings)
         {
            _loc12_ = this.dataApi.getMonsterFromId(_loc9_.creatureGenericId);
            _loc13_ = _loc12_.grades[_loc9_.grade - 1].level;
            if(_loc6_[_loc9_.creatureGenericId] && _loc6_[_loc9_.creatureGenericId] > 0)
            {
               _loc6_[_loc9_.creatureGenericId] = _loc6_[_loc9_.creatureGenericId] + _loc13_;
            }
            else
            {
               _loc6_[_loc9_.creatureGenericId] = _loc13_;
            }
            if(_loc7_[_loc9_.creatureGenericId] && _loc7_[_loc9_.creatureGenericId] > 0)
            {
               if(_loc7_[_loc9_.creatureGenericId] < _loc13_)
               {
                  _loc7_[_loc9_.creatureGenericId] = _loc13_;
               }
            }
            else
            {
               _loc7_[_loc9_.creatureGenericId] = _loc13_;
            }
         }
         if(param1 is GroupMonsterStaticInformationsWithAlternatives)
         {
            _loc14_ = new Array();
            _loc24_ = _loc10_.length;
            if(_loc24_ == 0 && this.playerApi.hasCompanion())
            {
               _loc24_ = 2;
            }
            else
            {
               for each(_loc11_ in _loc10_)
               {
                  _loc24_ = _loc24_ + _loc11_.companions.length;
               }
            }
            for each(_loc26_ in (param1 as GroupMonsterStaticInformationsWithAlternatives).alternatives)
            {
               if(_loc25_ == null || _loc26_.playerCount <= _loc24_)
               {
                  _loc25_ = _loc26_;
               }
            }
            for each(_loc27_ in _loc25_.monsters)
            {
               _loc14_.push(_loc27_);
            }
         }
         var _loc15_:Array = [];
         var _loc16_:Monster = this.dataApi.getMonsterFromId(param1.mainCreatureLightInfos.creatureGenericId);
         var _loc17_:int = this.getRealMonsterGrade(_loc14_,param1.mainCreatureLightInfos.creatureGenericId);
         var _loc18_:uint = _loc17_ <= 0?uint(_loc16_.grades[param1.mainCreatureLightInfos.grade - 1].level):uint(_loc16_.grades[_loc17_ - 1].level);
         _loc15_.push({
            "monsterId":param1.mainCreatureLightInfos.creatureGenericId,
            "level":_loc18_,
            "hiddenLevel":_loc16_.grades[param1.mainCreatureLightInfos.grade - 1].hiddenLevel,
            "gradeXp":(_loc17_ <= 0?_loc16_.grades[param1.mainCreatureLightInfos.grade - 1].gradeXp:_loc16_.grades[_loc17_ - 1].gradeXp),
            "totalLevel":_loc6_[param1.mainCreatureLightInfos.creatureGenericId],
            "maxLevel":_loc7_[param1.mainCreatureLightInfos.creatureGenericId],
            "visible":_loc17_ >= 0
         });
         for each(_loc9_ in param1.underlings)
         {
            _loc16_ = this.dataApi.getMonsterFromId(_loc9_.creatureGenericId);
            _loc17_ = this.getRealMonsterGrade(_loc14_,_loc9_.creatureGenericId);
            _loc13_ = _loc17_ <= 0?int(_loc16_.grades[_loc9_.grade - 1].level):int(_loc16_.grades[_loc17_ - 1].level);
            if(_loc17_ >= 0)
            {
               _loc18_ = _loc18_ + _loc13_;
            }
            _loc15_.push({
               "monsterId":_loc9_.creatureGenericId,
               "level":_loc13_,
               "hiddenLevel":_loc16_.grades[_loc9_.grade - 1].hiddenLevel,
               "gradeXp":(_loc17_ <= 0?_loc16_.grades[_loc9_.grade - 1].gradeXp:_loc16_.grades[_loc17_ - 1].gradeXp),
               "totalLevel":_loc6_[_loc9_.creatureGenericId],
               "maxLevel":_loc7_[_loc9_.creatureGenericId],
               "visible":_loc17_ >= 0
            });
         }
         _loc15_.sort(this.xtremAdvancedSortMonster);
         _loc19_ = new Array();
         for each(_loc20_ in _loc15_)
         {
            if(_loc20_.visible)
            {
               _loc19_.push(FormulaHandler.createMonsterData(_loc20_.level,_loc20_.gradeXp * this.roleplayApi.getMonsterXpBoostMultiplier(_loc20_.monsterId) * this.roleplayApi.getAlmanaxMonsterXpBonusMultiplier(_loc20_.monsterId),_loc20_.hiddenLevel));
            }
         }
         _loc21_ = this._numFirstMonsters == 0?uint(_loc19_.length):uint(this._numFirstMonsters);
         var _loc22_:uint = this.getIdolsExpBonusPercent(this.playerApi.getSoloIdols(),_loc21_,_loc15_,0);
         var _loc23_:uint = this.getIdolsExpBonusPercent(this.playerApi.getPartyIdols(),_loc21_,_loc15_,param3.length);
         FormulaHandler.getInstance().initXpFormula(param2,_loc19_,param3,param4,_loc22_,_loc23_);
         _loc5_ = new MonstersGroupData(_loc18_,_loc15_,FormulaHandler.getInstance().xpSolo,FormulaHandler.getInstance().xpGroup);
         return _loc5_;
      }
      
      private function getIdolsExpBonusPercent(param1:Object, param2:uint, param3:Array, param4:uint) : uint
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Idol = null;
         var _loc9_:Boolean = false;
         var _loc10_:Monster = null;
         var _loc11_:Object = null;
         var _loc12_:uint = 0;
         var _loc8_:uint = param1.length;
         _loc5_ = 0;
         while(_loc5_ < _loc8_)
         {
            _loc7_ = this.dataApi.getIdol(param1[_loc5_]);
            _loc9_ = false;
            for each(_loc11_ in param3)
            {
               _loc10_ = this.dataApi.getMonsterFromId(_loc11_.monsterId);
               if(_loc10_.incompatibleIdols.indexOf(_loc7_.id) != -1)
               {
                  _loc9_ = true;
                  break;
               }
            }
            if(!(_loc9_ || _loc7_.groupOnly && (param4 < 4 || param2 < 4)))
            {
               _loc6_ = this.getIdolCoeff(_loc7_,param1);
               _loc12_ = _loc12_ + _loc7_.experienceBonus * _loc6_;
            }
            _loc5_++;
         }
         return _loc12_;
      }
      
      private function getIdolCoeff(param1:Idol, param2:Object) : Number
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:Number = 1;
         var _loc4_:Object = param1.synergyIdolsIds;
         var _loc5_:Object = param1.synergyIdolsCoeff;
         var _loc6_:uint = _loc4_.length;
         var _loc9_:uint = param2.length;
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               if(_loc4_[_loc8_] == param2[_loc7_])
               {
                  _loc3_ = _loc3_ * _loc5_[_loc8_];
               }
               _loc8_++;
            }
            _loc7_++;
         }
         return _loc3_;
      }
      
      public function unload() : void
      {
      }
   }
}

class MonstersGroupData
{
    
   
   private var _level:int;
   
   private var _group:Array;
   
   private var _xpSolo:Number;
   
   private var _xpGroup:Number;
   
   function MonstersGroupData(param1:int, param2:Array, param3:Number, param4:Number)
   {
      super();
      this._level = param1;
      this._group = param2;
      this._xpSolo = param3;
      this._xpGroup = param4;
   }
   
   public function get level() : int
   {
      return this._level;
   }
   
   public function get group() : Array
   {
      return this._group;
   }
   
   public function get xpSolo() : Number
   {
      return this._xpSolo;
   }
   
   public function get xpGroup() : Number
   {
      return this._xpGroup;
   }
}
