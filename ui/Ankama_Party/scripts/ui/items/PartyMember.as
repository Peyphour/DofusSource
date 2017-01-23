package ui.items
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.people.PartyCompanionWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.ComponentHookList;
   import d2enums.PlayerStatusEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.PartyCompanionMemberUpdate;
   import d2hooks.PartyMemberFollowUpdate;
   import d2hooks.PartyMemberLifeUpdate;
   import d2hooks.PartyMemberUpdate;
   import d2hooks.PlayerStatusUpdate;
   import flash.display.Sprite;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   
   public class PartyMember
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var mountApi:MountApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _grid:Object;
      
      private var _data;
      
      private var _selected:Boolean;
      
      private var _compteur:uint = 0;
      
      private var _previousSkin:Vector.<uint>;
      
      private var _playerStatus:String = "";
      
      public var ctr_main:GraphicContainer;
      
      public var tx_bg:Texture;
      
      public var ed_player:EntityDisplayer;
      
      public var tx_leaderCrown:Texture;
      
      public var tx_followArrow:Texture;
      
      public var tx_guest:Texture;
      
      public var pb_lifePoints:ProgressBar;
      
      public function PartyMember()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.sysApi.addHook(PartyMemberUpdate,this.onPartyMemberUpdate);
         this.sysApi.addHook(PartyMemberLifeUpdate,this.onPartyMemberLifeUpdate);
         this.sysApi.addHook(PartyCompanionMemberUpdate,this.onPartyCompanionMemberUpdate);
         this.sysApi.addHook(PartyMemberFollowUpdate,this.onPartyMemberFollowUpdate);
         this.sysApi.addHook(PlayerStatusUpdate,this.onPartyMemberStatusUpdate);
         this.uiApi.addComponentHook(this.tx_followArrow,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_followArrow,ComponentHookList.ON_ROLL_OVER);
         this._grid = param1.grid;
         this._data = param1.data;
         this._selected = param1.selected;
         this._previousSkin = new Vector.<uint>();
         this.ed_player.setAnimationAndDirection("AnimArtwork",3);
         this.ed_player.view = "timeline";
         var _loc2_:GlowFilter = new GlowFilter(16777215,0.2,20,20,2,BitmapFilterQuality.HIGH);
         this.ed_player.filters = [_loc2_];
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.beginFill(16733440);
         _loc3_.graphics.drawRect(this.tx_bg.x,this.tx_bg.y,this.tx_bg.width,this.tx_bg.height);
         _loc3_.graphics.endFill();
         this.ctr_main.addChild(_loc3_);
         this.ed_player.mask = _loc3_;
         this.tx_followArrow.visible = false;
         this.tx_leaderCrown.visible = false;
         this.update(this._data,this._selected);
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function update(param1:*, param2:Boolean) : void
      {
         this._data = param1;
         if(this._data)
         {
            this.ed_player.look = this.mountApi.getRiderEntityLook(this._data.entityLook);
            this.tx_leaderCrown.visible = false;
            this.tx_guest.visible = false;
            if(this._data is PartyCompanionWrapper)
            {
               this.tx_bg.alpha = 0.5;
            }
            else
            {
               this.tx_bg.alpha = 1;
            }
            if(!this._data.isMember)
            {
               this.pb_lifePoints.visible = false;
               this.tx_guest.visible = true;
            }
            else
            {
               if(this._data.isLeader)
               {
                  this.tx_leaderCrown.visible = true;
               }
               this.pb_lifePoints.value = this._data.lifePoints / this._data.maxLifePoints;
               this.pb_lifePoints.visible = true;
            }
            if(!Party.CURRENT_PARTY_TYPE_DISPLAYED_IS_ARENA && this.playerApi.getFollowingPlayerIds().indexOf(this._data.id) != -1 && !(this._data is PartyCompanionWrapper))
            {
               this.tx_followArrow.visible = true;
            }
            else
            {
               this.tx_followArrow.visible = false;
            }
            switch(this.data.status)
            {
               case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                  this._playerStatus = "";
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                  this._playerStatus = this.uiApi.getText("ui.chat.status.idle");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_AFK:
                  this._playerStatus = this.uiApi.getText("ui.chat.status.away");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_PRIVATE:
                  this._playerStatus = this.uiApi.getText("ui.chat.status.private");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_SOLO:
                  this._playerStatus = this.uiApi.getText("ui.chat.status.solo");
            }
         }
         else
         {
            this.ed_player.look = null;
            this.pb_lifePoints.visible = false;
            this.tx_leaderCrown.visible = false;
            this.tx_followArrow.visible = false;
            this.tx_bg.visible = false;
            this.tx_guest.visible = false;
         }
      }
      
      public function select(param1:Boolean) : void
      {
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:Object = {
            "point":2,
            "relativePoint":0
         };
         switch(param1)
         {
            case this.ctr_main:
               if(this._data == null)
               {
                  break;
               }
               if(!this._data.isMember)
               {
                  if(this._data.hostName && this._data.hostName != "")
                  {
                     _loc2_ = this._data.name + "\n" + this.uiApi.getText("ui.party.invitedBy") + "\n" + this._data.hostName;
                  }
                  else
                  {
                     _loc2_ = this._data.name;
                  }
               }
               else
               {
                  if(this._data.isLeader)
                  {
                     _loc2_ = this.uiApi.getText("ui.party.leader") + "\n";
                  }
                  else
                  {
                     _loc2_ = "";
                  }
                  if(this._playerStatus != "")
                  {
                     _loc2_ = "(" + this._playerStatus + ") ";
                  }
                  if(!Party.CURRENT_PARTY_TYPE_DISPLAYED_IS_ARENA)
                  {
                     if(this._data.level > ProtocolConstantsEnum.MAX_LEVEL)
                     {
                        _loc2_ = _loc2_ + this.uiApi.getText("ui.party.rollOverPlayerInformationsWithPrestige",this._data.name,this._data.level - ProtocolConstantsEnum.MAX_LEVEL,this._data.prospecting,this._data.lifePoints,this._data.maxLifePoints,this._data.initiative);
                     }
                     else
                     {
                        _loc2_ = _loc2_ + this.uiApi.getText("ui.party.rollOverPlayerInformations",this._data.name,this._data.level == 0?"--":this._data.level,this._data.prospecting,this._data.lifePoints,this._data.maxLifePoints,this._data.initiative);
                     }
                  }
                  else if(this._data.level > ProtocolConstantsEnum.MAX_LEVEL)
                  {
                     _loc2_ = _loc2_ + this.uiApi.getText("ui.party.rollOverArenaPlayerInformationsWithPrestige",this._data.name,this._data.level - ProtocolConstantsEnum.MAX_LEVEL,this._data.rank == 0?"-":this._data.rank,this._data.lifePoints,this._data.maxLifePoints,this._data.initiative);
                  }
                  else
                  {
                     _loc2_ = _loc2_ + this.uiApi.getText("ui.party.rollOverArenaPlayerInformations",this._data.name,this._data.level == 0?"--":this._data.level,this._data.rank == 0?"-":this._data.rank,this._data.lifePoints,this._data.maxLifePoints,this._data.initiative);
                  }
               }
               if(_loc2_)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
               }
               break;
            case this.tx_followArrow:
               _loc2_ = this.uiApi.getText("ui.party.following",this._data.name);
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onPartyMemberUpdate(param1:int, param2:Number) : void
      {
      }
      
      private function onPartyMemberLifeUpdate(param1:int, param2:Number, param3:int, param4:int) : void
      {
         if(this._data != null && param2 == this._data.id && !(this._data is PartyCompanionWrapper))
         {
            this.pb_lifePoints.value = param3 / this._data.maxLifePoints;
         }
      }
      
      private function onPartyCompanionMemberUpdate(param1:int, param2:Number, param3:int, param4:Object) : void
      {
         if(this._data != null && param2 == this._data.id && this._data is PartyCompanionWrapper && param3 == (this._data as PartyCompanionWrapper).index)
         {
            this.pb_lifePoints.value = param4.lifePoints / this._data.maxLifePoints;
         }
      }
      
      private function onPartyMemberFollowUpdate(param1:int, param2:Number, param3:Boolean) : void
      {
         if(this._data == null || Party.CURRENT_PARTY_TYPE_DISPLAYED_IS_ARENA || param2 != this._data.id || this._data is PartyCompanionWrapper)
         {
            return;
         }
         if(param3)
         {
            this.tx_followArrow.visible = true;
         }
         else
         {
            this.tx_followArrow.visible = false;
         }
      }
      
      private function onPartyMemberStatusUpdate(param1:uint, param2:Number, param3:uint, param4:String) : void
      {
         if(this._data && param2 == this._data.id)
         {
            switch(param3)
            {
               case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                  this._playerStatus = "";
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_AFK:
                  this._playerStatus = this.uiApi.getText("ui.chat.status.idle");
               case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                  this._playerStatus = this.uiApi.getText("ui.chat.status.away");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_PRIVATE:
                  this._playerStatus = this.uiApi.getText("ui.chat.status.private");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_SOLO:
                  this._playerStatus = this.uiApi.getText("ui.chat.status.solo");
            }
         }
      }
   }
}
