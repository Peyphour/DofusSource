package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.AchievementCategory;
   import com.ankamagames.dofus.datacenter.quest.AchievementReward;
   import com.ankamagames.dofus.internalDatacenter.appearance.OrnamentWrapper;
   import com.ankamagames.dofus.internalDatacenter.appearance.TitleWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.network.types.game.achievement.AchievementRewardable;
   import com.ankamagames.dofus.network.types.game.dare.DareReward;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.AchievementRewardRequest;
   import d2actions.DareRewardRequest;
   import d2actions.GiftAssignAllRequest;
   import d2actions.GiftAssignRequest;
   import d2actions.OpenBook;
   import d2enums.ComponentHookList;
   import d2enums.DareRewardTypeEnum;
   import d2enums.LocationEnum;
   import d2hooks.AchievementRewardSuccess;
   import d2hooks.DareRewardSuccess;
   import d2hooks.GiftAssigned;
   import d2hooks.GiftsWaitingAllocation;
   import d2hooks.GuildInformationsMemberUpdate;
   import d2hooks.OpenDareSearch;
   import flash.utils.Dictionary;
   
   public class RewardsAndGiftsUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var questApi:QuestApi;
      
      public var utilApi:UtilApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var socialApi:SocialApi;
      
      public var menuApi:ContextMenuApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private const TYPE_ACHIEVEMENT_REWARD:int = 0;
      
      private const TYPE_GIFT:int = 1;
      
      private const TYPE_DARE_REWARD:int = 2;
      
      private var _componentDict:Dictionary;
      
      private var _achievementCategories:Array;
      
      private var _myGuildXp:int;
      
      public var ctr_mainWindow:GraphicContainer;
      
      public var ctr_grid:GraphicContainer;
      
      public var gd_rewardsAndGifts:Grid;
      
      public var ctr_bottom:GraphicContainer;
      
      public var btn_acceptAll:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public function RewardsAndGiftsUi()
      {
         this._componentDict = new Dictionary(true);
         this._achievementCategories = new Array();
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:AchievementCategory = null;
         var _loc3_:GuildMember = null;
         var _loc4_:Number = NaN;
         var _loc5_:GuildMember = null;
         this.sysApi.addHook(AchievementRewardSuccess,this.onAchievementRewardSuccess);
         this.sysApi.addHook(GuildInformationsMemberUpdate,this.onGuildInformationsMemberUpdate);
         this.sysApi.addHook(GiftAssigned,this.onGiftAssigned);
         this.sysApi.addHook(GiftsWaitingAllocation,this.onGiftsWaitingAllocation);
         this.sysApi.addHook(DareRewardSuccess,this.onDareRewardSuccess);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_acceptAll,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_acceptAll,ComponentHookList.ON_ROLL_OUT);
         if(this.socialApi.hasGuild())
         {
            _loc4_ = this.playerApi.id();
            for each(_loc5_ in this.socialApi.getGuildMembers())
            {
               if(_loc5_.id == _loc4_)
               {
                  _loc3_ = _loc5_;
                  break;
               }
            }
            this._myGuildXp = _loc3_.experienceGivenPercent;
         }
         for each(_loc2_ in this.dataApi.getAchievementCategories())
         {
            this._achievementCategories[_loc2_.id] = _loc2_;
         }
         this.updateList(true);
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function updateAchievementLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:ItemWrapper = null;
         var _loc8_:EmoteWrapper = null;
         var _loc9_:SpellWrapper = null;
         var _loc10_:TitleWrapper = null;
         var _loc11_:OrnamentWrapper = null;
         if(param1)
         {
            param2.lbl_title.text = param1.title;
            if(this.sysApi.getPlayerManager().hasRights)
            {
               param2.lbl_title.text = param2.lbl_title.text + (" (" + param1.id + ")");
            }
            param2.lbl_category.text = param1.subtitle;
            if(param1.type != this.TYPE_GIFT)
            {
               param2.lbl_title.handCursor = true;
            }
            else
            {
               param2.lbl_title.handCursor = false;
            }
            if(param1.kamas > 0)
            {
               param2.lbl_rewardsKama.text = this.utilApi.formateIntToString(param1.kamas);
            }
            else
            {
               param2.lbl_rewardsKama.text = "0";
            }
            if(param1.xp > 0)
            {
               param2.lbl_rewardsXp.text = this.utilApi.formateIntToString(param1.xp);
            }
            else
            {
               param2.lbl_rewardsXp.text = "0";
            }
            _loc4_ = new Array();
            if(param1.rewardData)
            {
               _loc5_ = 0;
               while(_loc5_ < param1.rewardData.itemsReward.length)
               {
                  if(param1.rewardData.itemsReward[_loc5_] is int)
                  {
                     _loc7_ = this.dataApi.getItemWrapper(param1.rewardData.itemsReward[_loc5_],0,0,param1.rewardData.itemsQuantityReward[_loc5_]);
                     _loc4_.push(_loc7_);
                  }
                  else
                  {
                     _loc4_.push(param1.rewardData.itemsReward[_loc5_] as ItemWrapper);
                  }
                  _loc5_++;
               }
               for each(_loc6_ in param1.rewardData.emotesReward)
               {
                  _loc8_ = this.dataApi.getEmoteWrapper(_loc6_);
                  _loc4_.push(_loc8_);
               }
               for each(_loc6_ in param1.rewardData.spellsReward)
               {
                  _loc9_ = this.dataApi.getSpellWrapper(_loc6_);
                  _loc4_.push(_loc9_);
               }
               for each(_loc6_ in param1.rewardData.titlesReward)
               {
                  _loc10_ = this.dataApi.getTitleWrapper(_loc6_);
                  _loc4_.push(_loc10_);
               }
               for each(_loc6_ in param1.rewardData.ornamentsReward)
               {
                  _loc11_ = this.dataApi.getOrnamentWrapper(_loc6_);
                  _loc4_.push(_loc11_);
               }
            }
            param2.gd_rewards.dataProvider = _loc4_;
            if(!this._componentDict[param2.gd_rewards.name])
            {
               this.uiApi.addComponentHook(param2.gd_rewards,ComponentHookList.ON_ITEM_ROLL_OVER);
               this.uiApi.addComponentHook(param2.gd_rewards,ComponentHookList.ON_ITEM_ROLL_OUT);
            }
            this._componentDict[param2.gd_rewards.name] = param1;
            if(!this._componentDict[param2.btn_acceptOne.name])
            {
               this.uiApi.addComponentHook(param2.btn_acceptOne,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.btn_acceptOne,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.btn_acceptOne,ComponentHookList.ON_ROLL_OUT);
            }
            this._componentDict[param2.btn_acceptOne.name] = param1;
            if(param1.type != this.TYPE_GIFT)
            {
               if(!this._componentDict[param2.lbl_title.name])
               {
                  this.uiApi.addComponentHook(param2.lbl_title,ComponentHookList.ON_RELEASE);
               }
               this._componentDict[param2.lbl_title.name] = [param1.type,param1.id];
            }
            param2.ctr_achievement.visible = true;
         }
         else
         {
            param2.ctr_achievement.visible = false;
         }
      }
      
      public function updateList(param1:Boolean = false) : void
      {
         var _loc4_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:AchievementRewardable = null;
         var _loc11_:Achievement = null;
         var _loc12_:AchievementCategory = null;
         var _loc13_:int = 0;
         var _loc14_:AchievementReward = null;
         var _loc15_:String = null;
         var _loc16_:DareReward = null;
         var _loc17_:Monster = null;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc2_:int = this.gd_rewardsAndGifts.dataProvider.length;
         var _loc3_:Array = new Array();
         var _loc5_:Object = this.playerApi.getWaitingGifts();
         if(_loc5_.length > 0)
         {
            for each(_loc8_ in _loc5_)
            {
               _loc9_ = {"itemsReward":_loc8_.items};
               _loc4_ = {
                  "title":_loc8_.title,
                  "subtitle":this.uiApi.getText("ui.shop.article"),
                  "rewardData":_loc9_,
                  "kamas":0,
                  "xp":0,
                  "id":_loc8_.uid,
                  "type":this.TYPE_GIFT
               };
               _loc3_.push(_loc4_);
            }
         }
         var _loc6_:Object = this.questApi.getRewardableAchievements();
         if(_loc6_.length > 0)
         {
            for each(_loc10_ in _loc6_)
            {
               _loc11_ = this.dataApi.getAchievement(_loc10_.id);
               _loc12_ = _loc11_.category;
               if(_loc12_.parentId != 0)
               {
                  _loc12_ = this._achievementCategories[_loc12_.parentId];
               }
               _loc4_ = {
                  "title":_loc11_.name,
                  "subtitle":_loc12_.name,
                  "rewardData":null,
                  "kamas":0,
                  "xp":0,
                  "id":_loc10_.id,
                  "type":this.TYPE_ACHIEVEMENT_REWARD
               };
               for each(_loc13_ in _loc11_.rewardIds)
               {
                  _loc14_ = this.dataApi.getAchievementReward(_loc13_);
                  if(_loc14_)
                  {
                     if((_loc14_.levelMin == -1 || _loc14_.levelMin <= _loc10_.finishedlevel) && (_loc14_.levelMax >= _loc10_.finishedlevel || _loc14_.levelMax == -1))
                     {
                        _loc4_.rewardData = _loc14_;
                        break;
                     }
                  }
               }
               _loc4_.kamas = this.questApi.getAchievementKamasReward(_loc11_,_loc10_.finishedlevel);
               _loc4_.xp = this.questApi.getAchievementExperienceReward(_loc11_,_loc10_.finishedlevel);
               this.sysApi.log(2,"    --> " + _loc4_.xp);
               _loc3_.push(_loc4_);
            }
         }
         var _loc7_:Object = this.socialApi.getDareRewards();
         if(_loc7_.length > 0)
         {
            _loc15_ = "";
            for each(_loc16_ in _loc7_)
            {
               switch(_loc16_.type)
               {
                  case DareRewardTypeEnum.DARE_REWARD_TYPE_JACKPOT:
                     _loc15_ = this.uiApi.getText("ui.dare.jackpot");
                     break;
                  case DareRewardTypeEnum.DARE_REWARD_TYPE_PARTICIPATION_REFILL:
                  case DareRewardTypeEnum.DARE_REWARD_TYPE_OWNER_JACKPOT_REFILL:
                     _loc15_ = this.uiApi.getText("ui.dare.refund");
                     break;
                  case DareRewardTypeEnum.DARE_REWARD_TYPE_OWNER_PARTICIPATION:
                     _loc15_ = this.uiApi.getText("ui.dare.reward.participation");
               }
               _loc17_ = this.dataApi.getMonsterFromId(_loc16_.monsterId);
               _loc18_ = "";
               if(_loc17_)
               {
                  _loc18_ = _loc17_.name;
               }
               _loc4_ = {
                  "title":this.uiApi.getText("ui.dare.dareShort") + this.uiApi.getText("ui.common.colon") + _loc18_,
                  "subtitle":_loc15_,
                  "rewardData":null,
                  "kamas":_loc16_.kamas,
                  "xp":0,
                  "id":_loc16_.dareId,
                  "type":this.TYPE_DARE_REWARD,
                  "rewardType":_loc16_.type
               };
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length == 0)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return;
         }
         if(_loc3_.length <= 4 && (param1 || _loc3_.length != _loc2_))
         {
            _loc19_ = 4 - _loc3_.length;
            _loc20_ = int(this.uiApi.me().getConstant("height_line"));
            this.ctr_mainWindow.height = int(this.uiApi.me().getConstant("height_tx_generalBg")) - _loc19_ * _loc20_;
            this.ctr_grid.height = int(this.uiApi.me().getConstant("height_tx_gridBg")) - _loc19_ * _loc20_;
            this.gd_rewardsAndGifts.height = int(this.uiApi.me().getConstant("height_grid")) - _loc19_ * _loc20_;
         }
         this.gd_rewardsAndGifts.dataProvider = _loc3_;
      }
      
      private function getMountPercentXp() : int
      {
         var _loc1_:int = 0;
         if(this.playerApi.getMount() != null && this.playerApi.isRidding() && this.playerApi.getMount().xpRatio > 0)
         {
            _loc1_ = this.playerApi.getMount().xpRatio;
         }
         return _loc1_;
      }
      
      public function onAchievementRewardSuccess(param1:int) : void
      {
         this.updateList();
      }
      
      private function onGiftAssigned(param1:uint) : void
      {
         this.updateList();
      }
      
      private function onGiftsWaitingAllocation(param1:Boolean) : void
      {
         if(param1)
         {
            this.updateList();
         }
      }
      
      private function onDareRewardSuccess() : void
      {
         this.updateList();
      }
      
      public function onGuildInformationsMemberUpdate(param1:Object) : void
      {
         if(param1.id == this.playerApi.id())
         {
            this._myGuildXp = param1.experienceGivenPercent;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_acceptAll:
               this.sysApi.sendAction(new AchievementRewardRequest(-1));
               this.sysApi.sendAction(new GiftAssignAllRequest(this.playerApi.id()));
               this.sysApi.sendAction(new DareRewardRequest(-1,0));
               break;
            default:
               if(param1.name.indexOf("btn_acceptOne") != -1)
               {
                  _loc2_ = this._componentDict[param1.name];
                  if(_loc2_.type == this.TYPE_ACHIEVEMENT_REWARD)
                  {
                     this.sysApi.sendAction(new AchievementRewardRequest(_loc2_.id));
                  }
                  else if(_loc2_.type == this.TYPE_GIFT)
                  {
                     this.sysApi.sendAction(new GiftAssignRequest(_loc2_.id,this.playerApi.id()));
                  }
                  else if(_loc2_.type == this.TYPE_DARE_REWARD)
                  {
                     this.sysApi.sendAction(new DareRewardRequest(_loc2_.id,_loc2_.rewardType));
                  }
               }
               else if(param1.name.indexOf("lbl_title") != -1)
               {
                  _loc2_ = this._componentDict[param1.name];
                  if(_loc2_[0] == this.TYPE_ACHIEVEMENT_REWARD)
                  {
                     _loc2_ = new Object();
                     _loc2_.achievementId = this._componentDict[param1.name][1];
                     _loc2_.forceOpen = true;
                     this.sysApi.sendAction(new OpenBook("achievementTab",_loc2_));
                  }
                  else if(_loc2_[0] == this.TYPE_DARE_REWARD)
                  {
                     this.sysApi.dispatchHook(OpenDareSearch,"" + _loc2_[1],"searchFilterId");
                  }
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         if(param1.name.indexOf("btn_acceptOne") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.achievement.rewardsGet");
         }
         var _loc4_:int = this.getMountPercentXp();
         if(param1 == this.btn_acceptAll && _loc4_ || this._myGuildXp)
         {
            _loc2_ = this.uiApi.getText("ui.popup.warning");
         }
         if(_loc4_)
         {
            _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.achievement.mountXpPercent",_loc4_));
         }
         if(this._myGuildXp)
         {
            _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.achievement.guildXpPercent",this._myGuildXp));
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(param2.data && param1.name.indexOf("gd_rewards") != -1)
         {
            _loc3_ = param2.data;
            if(_loc3_ == null || !(_loc3_ is ItemWrapper))
            {
               return;
            }
            _loc4_ = this.menuApi.create(_loc3_);
            if(_loc4_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc4_);
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(param2.data && param1.name.indexOf("gd_rewards") != -1)
         {
            _loc4_ = {
               "point":LocationEnum.POINT_BOTTOM,
               "relativePoint":LocationEnum.POINT_TOP
            };
            if(param2.data is ItemWrapper)
            {
               _loc3_ = param2.data.name;
               _loc3_ = _loc3_ + this.averagePricesApi.getItemAveragePriceString(param2.data,true);
            }
            else if(param2.data is EmoteWrapper)
            {
               _loc3_ = this.uiApi.getText("ui.common.emote",param2.data.emote.name);
            }
            else if(param2.data is SpellWrapper)
            {
               _loc3_ = this.uiApi.getText("ui.common.spell",param2.data.spell.name);
            }
            else if(param2.data is TitleWrapper)
            {
               _loc3_ = this.uiApi.getText("ui.common.title",param2.data.title.name);
            }
            else if(param2.data is OrnamentWrapper)
            {
               _loc3_ = this.uiApi.getText("ui.common.ornament",param2.data.name);
            }
            if(_loc3_)
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param1,false,"standard",_loc4_.point,_loc4_.relativePoint,3,null,null,null,"TextInfo");
            }
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
   }
}
