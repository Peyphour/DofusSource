package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.internalDatacenter.people.PartyCompanionWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.AddIgnored;
   import d2actions.PartyAcceptInvitation;
   import d2actions.PartyRefuseInvitation;
   import d2enums.PartyTypeEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.PartyMemberRemove;
   import d2hooks.PartyMemberUpdateDetails;
   
   public class JoinParty
   {
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var mountApi:MountApi;
      
      private var _partyId:uint;
      
      private var _members:Array;
      
      private var _fromName:String;
      
      private var _partyName:String;
      
      private var _leaderId:Number;
      
      private var _typeId:uint = 0;
      
      private var _dungeonId:uint = 0;
      
      private var _acceptMembersDungeon:Array;
      
      public var lbl_fromName:Label;
      
      public var lbl_dungeon:Label;
      
      public var btnClose:Object;
      
      public var btnValidate:ButtonContainer;
      
      public var btnCancel:ButtonContainer;
      
      public var btnIgnore:ButtonContainer;
      
      public var grid_members:Grid;
      
      public var tx_slotPlayer:Object;
      
      public function JoinParty()
      {
         super();
      }
      
      public function main(param1:Array) : void
      {
         var _loc2_:PartyMemberWrapper = null;
         var _loc3_:PartyCompanionWrapper = null;
         var _loc4_:* = null;
         this.sysApi.addHook(PartyMemberUpdateDetails,this.onPartyMemberUpdate);
         this.sysApi.addHook(PartyMemberRemove,this.onPartyMemberRemove);
         this._partyId = param1[0];
         this._fromName = param1[1];
         this._leaderId = param1[2];
         this._typeId = param1[3];
         this._dungeonId = param1[6];
         this._partyName = param1[8];
         this._members = new Array();
         for each(_loc2_ in param1[4])
         {
            this._members.push(_loc2_);
            for each(_loc3_ in _loc2_.companions)
            {
               this._members.push(_loc3_);
            }
         }
         for each(_loc2_ in param1[5])
         {
            this._members.push(_loc2_);
            for each(_loc3_ in _loc2_.companions)
            {
               this._members.push(_loc3_);
            }
         }
         this._acceptMembersDungeon = new Array();
         for(_loc4_ in param1[4])
         {
            this._acceptMembersDungeon.push(_loc4_);
         }
         if(this._typeId == PartyTypeEnum.PARTY_TYPE_ARENA)
         {
            this.lbl_fromName.text = this.uiApi.getText("ui.common.invitationArena");
         }
         else
         {
            this.lbl_fromName.text = this.uiApi.getText("ui.common.invitationGroupe");
         }
         this.lbl_dungeon.text = this.uiApi.getText("ui.common.invitationPresentation",this._fromName,this._partyName);
         if(this._dungeonId != 0)
         {
            if(this._partyName != "")
            {
               this.lbl_dungeon.text = this.lbl_dungeon.text + " ";
            }
            this.lbl_dungeon.text = this.lbl_dungeon.text + this.uiApi.getText("ui.common.invitationDonjon",this.dataApi.getDungeon(this._dungeonId).name);
         }
         this.lbl_dungeon.text = this.lbl_dungeon.text + ".";
         this.updateGrid();
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function updateGrid() : void
      {
         this.grid_members.dataProvider = this._members;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btnClose:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btnCancel:
               this.sysApi.sendAction(new PartyRefuseInvitation(this._partyId));
               break;
            case this.btnValidate:
               this.sysApi.sendAction(new PartyAcceptInvitation(this._partyId));
               break;
            case this.btnIgnore:
               this.sysApi.sendAction(new AddIgnored(this._fromName));
               this.sysApi.sendAction(new PartyRefuseInvitation(this._partyId));
         }
      }
      
      public function updateEntry(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.ed_Player.look = this.mountApi.getRiderEntityLook(param1.entityLook);
            param2.ed_Player.visible = true;
            if(!param1.isMember)
            {
               param2.tx_slotPlayerLine.visible = true;
            }
            else
            {
               param2.tx_slotPlayerLine.visible = this.isReady(param1.id);
            }
            param2.lbl_name.text = "{player," + param1.name + "," + param1.id + "::" + param1.name + "}";
            if(param1.breedId)
            {
               param2.lbl_breed.text = this.dataApi.getBreed(param1.breedId).shortName;
            }
            else
            {
               param2.lbl_breed.text = "";
            }
            if(param1.level == 0 || param1 is PartyCompanionWrapper)
            {
               param2.lbl_level.text = "";
            }
            else if(param1.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               param2.lbl_level.text = this.uiApi.getText("ui.common.prestige") + " " + (param1.level - ProtocolConstantsEnum.MAX_LEVEL);
            }
            else
            {
               param2.lbl_level.text = this.uiApi.getText("ui.common.level") + " " + param1.level;
            }
            param2.tx_leaderCrown.gotoAndStop = 2;
            param2.tx_leaderCrown.visible = param1.id == this._leaderId && !(param1 is PartyCompanionWrapper);
         }
         else
         {
            param2.tx_slotPlayerLine.visible = false;
            param2.tx_leaderCrown.visible = false;
            param2.ed_Player.visible = false;
            param2.lbl_name.text = "";
            param2.lbl_breed.text = "";
            param2.lbl_level.text = "";
         }
      }
      
      private function isReady(param1:Number) : Boolean
      {
         var _loc2_:int = 0;
         if(this._acceptMembersDungeon == null || this._acceptMembersDungeon.length <= 0)
         {
            return false;
         }
         for each(_loc2_ in this._acceptMembersDungeon)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:* = null;
         if(param2.data)
         {
            if(param2.data.subAreaId)
            {
               _loc3_ = this.uiApi.getText("ui.common.invitationLocation") + " " + this.dataApi.getSubArea(param2.data.subAreaId).name + " (" + param2.data.worldX + "," + param2.data.worldY + ")";
            }
            if(_loc3_ != "")
            {
               this.uiApi.showTooltip(_loc3_,param2.container,false,"standard",2,0,0,null,null,null,null);
            }
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onPartyMemberUpdate(param1:uint, param2:PartyMemberWrapper, param3:Boolean) : void
      {
         var _loc5_:PartyCompanionWrapper = null;
         var _loc6_:Array = null;
         var _loc7_:PartyMemberWrapper = null;
         var _loc8_:int = 0;
         var _loc9_:PartyCompanionWrapper = null;
         if(this._partyId != param1)
         {
            return;
         }
         var _loc4_:int = this.getMemberIndex(param2.id);
         if(_loc4_ == -1)
         {
            this._members.push(param2);
            for each(_loc5_ in param2.companions)
            {
               this._members.push(_loc5_);
            }
         }
         else
         {
            _loc6_ = new Array();
            for each(_loc7_ in this._members)
            {
               if(_loc7_.id != param2.id)
               {
                  _loc6_.push(_loc7_);
               }
            }
            this._members = _loc6_;
            this._members.splice(_loc4_,0,param2);
            _loc8_ = 0;
            for each(_loc9_ in param2.companions)
            {
               _loc8_++;
               this._members.splice(_loc4_ + _loc8_,0,_loc9_);
            }
         }
         this.updateGrid();
      }
      
      private function onPartyMemberRemove(param1:uint, param2:Number) : void
      {
         var _loc4_:PartyMemberWrapper = null;
         if(this._partyId != param1)
         {
            return;
         }
         var _loc3_:Array = new Array();
         for each(_loc4_ in this._members)
         {
            if(_loc4_.id != param2)
            {
               _loc3_.push(_loc4_);
            }
         }
         this._members = _loc3_;
         this.updateGrid();
      }
      
      private function getMemberIndex(param1:Number) : int
      {
         var _loc2_:PartyMemberWrapper = null;
         for each(_loc2_ in this._members)
         {
            if(_loc2_.id == param1)
            {
               return this._members.indexOf(_loc2_);
            }
         }
         return -1;
      }
   }
}
