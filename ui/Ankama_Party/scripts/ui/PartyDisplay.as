package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.internalDatacenter.people.PartyCompanionWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.PartyNameSetRequest;
   import d2actions.PartyPledgeLoyaltyRequest;
   import d2actions.PartyShowMenu;
   import d2actions.ToggleLockParty;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.FoldAll;
   import d2hooks.IdolPartyLost;
   import d2hooks.IdolSelected;
   import d2hooks.IdolsList;
   import d2hooks.OptionLockParty;
   import d2hooks.PartyJoin;
   import d2hooks.PartyLeaderUpdate;
   import d2hooks.PartyLeave;
   import d2hooks.PartyLocateMembers;
   import d2hooks.PartyLoyaltyStatus;
   import d2hooks.PartyMemberLifeUpdate;
   import d2hooks.PartyMemberRemove;
   import d2hooks.PartyMemberUpdate;
   import d2hooks.PartyNameUpdate;
   import d2hooks.PartyUpdate;
   
   public class PartyDisplay
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var partyApi:PartyApi;
      
      public var configApi:ConfigApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var menuApi:ContextMenuApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var gd_party:Grid;
      
      public var btn_minimize:ButtonContainer;
      
      public var tx_button_minimize:Texture;
      
      public var tx_background_grid:TextureBitmap;
      
      public var tx_partyType:Texture;
      
      public var btn_info:ButtonContainer;
      
      public var btn_switchParty:ButtonContainer;
      
      private var _isArenaParty:Boolean = false;
      
      private var _isMinimized:Boolean;
      
      private var _leaderId:Number;
      
      private var _selectedMember:PartyMemberWrapper;
      
      private var _members:Array;
      
      private var _othersFollowingPlayerId:Number;
      
      private var _arenaPartyId:int;
      
      private var _partyId:int;
      
      private var _arenaPartyName:String;
      
      private var _partyName:String;
      
      private var _fightLocked:Boolean;
      
      private var _partyLocked:Boolean;
      
      private var _arenaPartyLocked:Boolean;
      
      private var _foldStatus:Boolean;
      
      private var _partyIdols:Vector.<uint>;
      
      private var _idolsScore:uint;
      
      private var _membersYOffset:int;
      
      private var _bonusHeight:int;
      
      private var _arenaIconUri:Object;
      
      private var _partyIconUri:Object;
      
      public function PartyDisplay()
      {
         this._partyIdols = new Vector.<uint>(0);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.sysApi.addHook(PartyJoin,this.onPartyJoin);
         this.sysApi.addHook(PartyLocateMembers,this.onPartyLocateMembers);
         this.sysApi.addHook(PartyUpdate,this.onPartyUpdate);
         this.sysApi.addHook(PartyLeave,this.onPartyLeave);
         this.sysApi.addHook(PartyLeaderUpdate,this.onPartyLeaderUpdate);
         this.sysApi.addHook(PartyMemberUpdate,this.onPartyMemberUpdate);
         this.sysApi.addHook(PartyMemberRemove,this.onPartyMemberRemove);
         this.sysApi.addHook(FoldAll,this.onFoldAll);
         this.sysApi.addHook(OptionLockParty,this.onOptionLockParty);
         this.sysApi.addHook(PartyLoyaltyStatus,this.onPartyLoyaltyStatus);
         this.sysApi.addHook(PartyMemberLifeUpdate,this.onPartyMemberLifeUpdate);
         this.sysApi.addHook(PartyNameUpdate,this.onPartyNameUpdate);
         this.sysApi.addHook(IdolsList,this.onIdolsList);
         this.sysApi.addHook(IdolSelected,this.onIdolSelected);
         this.sysApi.addHook(IdolPartyLost,this.onIdolPartyLost);
         this.uiApi.addComponentHook(this.btn_switchParty,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_switchParty,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_switchParty,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_info,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_info,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_info,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_minimize,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_minimize,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_minimize,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.gd_party,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_party,ComponentHookList.ON_SELECT_ITEM);
         this._isMinimized = false;
         this._membersYOffset = int(this.uiApi.me().getConstant("vertical_offset_between_members"));
         this._bonusHeight = int(this.uiApi.me().getConstant("bonus_height"));
         this.updateGrid(param1.partyMembers);
         this.gd_party.mouseEnabled = false;
         this._fightLocked = param1.restricted;
         this._partyLocked = false;
         this._arenaPartyLocked = false;
         this._isArenaParty = param1.arena;
         Party.CURRENT_PARTY_TYPE_DISPLAYED_IS_ARENA = this._isArenaParty;
         this.btn_switchParty.softDisabled = true;
         this._arenaIconUri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_sword.png");
         this._partyIconUri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_green_group.png");
         if(this._isArenaParty)
         {
            this.tx_partyType.uri = this._arenaIconUri;
         }
         else
         {
            this.tx_partyType.uri = this._partyIconUri;
         }
         if(this._isArenaParty)
         {
            this._arenaPartyId = param1.id;
            this._arenaPartyName = param1.name;
         }
         else
         {
            this._partyId = param1.id;
            this._partyName = param1.name;
         }
      }
      
      public function getCurrentGroupId() : int
      {
         if(this._isArenaParty)
         {
            return this._arenaPartyId;
         }
         return this._partyId;
      }
      
      private function updateGrid(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:PartyCompanionWrapper = null;
         this._members = new Array();
         this._leaderId = 0;
         if(param1 == null)
         {
            if(this._isArenaParty)
            {
               param1 = this.partyApi.getPartyMembers(1);
            }
            else
            {
               param1 = this.partyApi.getPartyMembers(0);
            }
         }
         for each(_loc2_ in param1)
         {
            if(_loc2_.isLeader)
            {
               this._leaderId = _loc2_.id;
            }
            this._members.push(_loc2_);
            if(_loc2_.companions && _loc2_.companions.length > 0)
            {
               for each(_loc3_ in _loc2_.companions)
               {
                  this._members.push(_loc3_);
               }
            }
         }
         this._members.sortOn(["isMember","initiative","id"],[Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
         this.gd_party.dataProvider = this._members;
         this.updateBackground();
      }
      
      private function updateGridOrder() : void
      {
         this._members.sortOn(["isMember","initiative","id"],[Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
         this.gd_party.updateItems();
      }
      
      private function updateBackground() : void
      {
         if(this.gd_party.dataProvider == null)
         {
            return;
         }
         this.gd_party.height = Math.min(this._members.length,8) * (this.gd_party.slotHeight + this._membersYOffset);
         this.tx_background_grid.height = this.gd_party.height + this._bonusHeight;
      }
      
      private function showMembersParty(param1:Boolean) : void
      {
         this.gd_party.visible = param1;
         this.tx_background_grid.visible = param1;
         this.btn_info.visible = param1;
         this.btn_switchParty.visible = param1;
         this._isMinimized = !param1;
         if(param1)
         {
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
         }
         else
         {
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
         }
      }
      
      private function updateIdolsScore() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Idol = null;
         var _loc4_:Number = NaN;
         var _loc3_:uint = this._partyIdols.length;
         this._idolsScore = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this.dataApi.getIdol(this._partyIdols[_loc1_]);
            _loc4_ = this.getIdolCoeff(_loc2_);
            this._idolsScore = this._idolsScore + _loc2_.score * _loc4_;
            _loc1_++;
         }
      }
      
      private function getIdolCoeff(param1:Idol) : Number
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Number = 1;
         var _loc3_:Object = param1.synergyIdolsIds;
         var _loc4_:Object = param1.synergyIdolsCoeff;
         var _loc5_:uint = _loc3_.length;
         var _loc8_:uint = this._partyIdols.length;
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               if(_loc3_[_loc7_] == this._partyIdols[_loc6_])
               {
                  _loc2_ = _loc2_ * _loc4_[_loc7_];
               }
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
         this.modContextMenu.closeAllMenu();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case this.gd_party:
               if(param2 == GridItemSelectMethodEnum.AUTO)
               {
                  return;
               }
               this._selectedMember = param1.selectedItem;
               if(this._selectedMember is PartyCompanionWrapper)
               {
                  _loc4_ = this.menuApi.create(this._selectedMember as PartyCompanionWrapper);
                  if(_loc4_.content.length > 0)
                  {
                     this.modContextMenu.createContextMenu(_loc4_);
                  }
               }
               else
               {
                  this.sysApi.sendAction(new PartyShowMenu(this._selectedMember.id,this.getCurrentGroupId()));
               }
               break;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_minimize:
               if(this._isMinimized)
               {
                  this.showMembersParty(true);
               }
               else
               {
                  this.showMembersParty(false);
               }
               break;
            case this.btn_info:
               this.showOptionsMenu();
               break;
            case this.btn_switchParty:
               this.switchPartyType();
         }
      }
      
      private function switchPartyType() : void
      {
         this._isArenaParty = !this._isArenaParty;
         Party.CURRENT_PARTY_TYPE_DISPLAYED_IS_ARENA = this._isArenaParty;
         if(this._isArenaParty)
         {
            this.tx_partyType.uri = this._arenaIconUri;
         }
         else
         {
            this.tx_partyType.uri = this._partyIconUri;
         }
         this.updateGrid();
      }
      
      private function showOptionsMenu() : void
      {
         var _loc1_:Array = new Array();
         _loc1_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.common.options")));
         var _loc2_:* = this.playerApi.id() != this._leaderId;
         if(!this._isArenaParty)
         {
            _loc1_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.party.rename"),this.nameParty,null,_loc2_ || this.sysApi.isFightContext(),null,false,false,!!this._isArenaParty?this._arenaPartyName:this._partyName,true));
            _loc1_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.party.lockFight"),this.optionLockFight,[!this._fightLocked],_loc2_,null,this._fightLocked,false));
            _loc1_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.party.refuseOtherInvitations"),this.optionLockParty,[!this._partyLocked],false,null,this._partyLocked,false));
         }
         else
         {
            _loc1_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.party.refuseOtherInvitations"),this.optionLockParty,[!this._arenaPartyLocked],false,null,this._arenaPartyLocked,false));
         }
         this.modContextMenu.createContextMenu(_loc1_);
      }
      
      private function optionLockFight(param1:Boolean) : void
      {
         this.sysApi.sendAction(new ToggleLockParty());
      }
      
      private function optionLockParty(param1:Boolean) : void
      {
         this.sysApi.sendAction(new PartyPledgeLoyaltyRequest(this.getCurrentGroupId(),param1));
      }
      
      private function nameParty() : void
      {
         this.modCommon.openInputPopup(this.uiApi.getText("ui.party.rename"),this.uiApi.getText("ui.party.choseName"),this.onChangePartyName,null,!!this._isArenaParty?this._arenaPartyName:this._partyName,"A-Za-z0-9 ",ProtocolConstantsEnum.MAX_PARTY_NAME_LEN);
      }
      
      private function onChangePartyName(param1:String) : void
      {
         if(param1.length >= ProtocolConstantsEnum.MIN_PARTY_NAME_LEN)
         {
            this.sysApi.sendAction(new PartyNameSetRequest(this.getCurrentGroupId(),param1));
         }
      }
      
      private function onFoldAll(param1:Boolean) : void
      {
         if(param1)
         {
            this._foldStatus = this.gd_party.visible;
            this.showMembersParty(false);
         }
         else
         {
            this.showMembersParty(this._foldStatus);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:PartyMemberWrapper = null;
         switch(param1)
         {
            case this.btn_info:
               _loc3_ = 0;
               _loc4_ = 0;
               for each(_loc7_ in this.gd_party.dataProvider)
               {
                  _loc3_ = _loc3_ + (_loc7_.level > ProtocolConstantsEnum.MAX_LEVEL?ProtocolConstantsEnum.MAX_LEVEL:_loc7_.level);
                  _loc4_ = _loc4_ + _loc7_.initiative;
               }
               _loc5_ = this.uiApi.getText("ui.party.partyInformation",_loc3_,this._idolsScore,this.gd_party.dataProvider.length == 0?"":Math.round(_loc4_ / this.gd_party.dataProvider.length));
               _loc6_ = {
                  "point":2,
                  "relativePoint":0
               };
               if(_loc5_)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc5_),param1,false,"standard",_loc6_.point,_loc6_.relativePoint,3,null,null,null,"TextInfo");
               }
               break;
            case this.btn_switchParty:
               _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.party.switchPartyType"));
               this.uiApi.showTooltip(_loc2_,param1,false,"standard",7,1,3,null,null,null,"TextInfo");
               break;
            case this.btn_minimize:
               if(this._isArenaParty)
               {
                  if(this._arenaPartyName != "")
                  {
                     _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.common.koliseum") + this.uiApi.getText("ui.common.colon") + this._arenaPartyName);
                  }
                  else
                  {
                     _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.common.koliseum"));
                  }
               }
               else if(this._partyName != "")
               {
                  _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.common.party") + this.uiApi.getText("ui.common.colon") + this._partyName);
               }
               else
               {
                  _loc2_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.common.party"));
               }
               this.uiApi.showTooltip(_loc2_,param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onPartyLeaderUpdate(param1:int, param2:Number) : void
      {
         var _loc3_:PartyMemberWrapper = null;
         if(param1 == this.getCurrentGroupId())
         {
            for each(_loc3_ in this.gd_party.dataProvider)
            {
               if(_loc3_.id == param2)
               {
                  this._leaderId = _loc3_.id;
               }
            }
            this.updateBackground();
         }
      }
      
      private function onPartyMemberUpdate(param1:int, param2:Number) : void
      {
         if(param1 == this.getCurrentGroupId())
         {
            this.updateGrid();
         }
      }
      
      private function onPartyMemberLifeUpdate(param1:int, param2:Number, param3:int, param4:int) : void
      {
         if(param1 == this.getCurrentGroupId())
         {
            this.updateGridOrder();
         }
      }
      
      private function onPartyNameUpdate(param1:int, param2:String) : void
      {
         if(param1 == this._arenaPartyId)
         {
            this._arenaPartyName = param2;
         }
         else
         {
            this._partyName = param2;
         }
      }
      
      private function onPartyMemberRemove(param1:int, param2:Number) : void
      {
         if(param1 == this.getCurrentGroupId())
         {
            this.updateGrid();
         }
      }
      
      private function onPartyLocateMembers(param1:Vector.<uint>) : void
      {
      }
      
      public function onPartyJoin(param1:int, param2:Object, param3:Boolean, param4:Boolean, param5:String = "") : void
      {
         this.updateGrid(param2);
         this._fightLocked = param3;
         this._isArenaParty = param4;
         Party.CURRENT_PARTY_TYPE_DISPLAYED_IS_ARENA = this._isArenaParty;
         if(this._isArenaParty)
         {
            this.tx_partyType.uri = this._arenaIconUri;
         }
         else
         {
            this.tx_partyType.uri = this._partyIconUri;
         }
         this.btn_switchParty.softDisabled = false;
         if(this._isArenaParty)
         {
            this._arenaPartyId = param1;
            this._arenaPartyName = param5;
         }
         else
         {
            this._partyId = param1;
            this._partyName = param5;
         }
      }
      
      private function onPartyUpdate(param1:int, param2:Object) : void
      {
         if(param1 == this.getCurrentGroupId())
         {
            this.updateGrid(param2);
         }
      }
      
      private function onPartyLeave(param1:int, param2:Boolean) : void
      {
         if(this._isArenaParty)
         {
            if(param1 == this._arenaPartyId)
            {
               if(this._partyId != 0)
               {
                  this.switchPartyType();
                  this.btn_switchParty.softDisabled = true;
                  this._arenaPartyId = 0;
               }
               else if(this.uiApi && this.uiApi.me())
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
            }
            else
            {
               this.btn_switchParty.softDisabled = true;
               this._partyId = 0;
            }
         }
         else if(param1 == this._partyId)
         {
            if(this._arenaPartyId != 0)
            {
               this.switchPartyType();
               this.btn_switchParty.softDisabled = true;
               this._partyId = 0;
            }
            else
            {
               this.uiApi.unloadUi(this.uiApi.me().name);
            }
         }
         else
         {
            this.btn_switchParty.softDisabled = true;
            this._arenaPartyId = 0;
         }
      }
      
      private function onOptionLockParty(param1:Boolean) : void
      {
         this._fightLocked = param1;
      }
      
      private function onPartyLoyaltyStatus(param1:int, param2:Boolean) : void
      {
         if(param1 == this._arenaPartyId)
         {
            this._arenaPartyLocked = param2;
         }
         else if(param1 == this._partyId)
         {
            this._partyLocked = param2;
         }
      }
      
      private function onIdolsList(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         this._partyIdols.length = 0;
         for each(_loc4_ in param2)
         {
            this._partyIdols.push(_loc4_);
         }
         this.updateIdolsScore();
      }
      
      private function onIdolSelected(param1:uint, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         if(param3)
         {
            if(param2)
            {
               this._partyIdols.push(param1);
            }
            else
            {
               _loc4_ = this._partyIdols.indexOf(param1);
               if(_loc4_ != -1)
               {
                  this._partyIdols.splice(_loc4_,1);
               }
            }
            this.updateIdolsScore();
         }
      }
      
      private function onIdolPartyLost(param1:uint) : void
      {
         var _loc2_:int = this._partyIdols.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._partyIdols.splice(_loc2_,1);
         }
         this.updateIdolsScore();
      }
   }
}
