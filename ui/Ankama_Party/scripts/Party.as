package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.OpenArena;
   import d2hooks.OpenTeamSearch;
   import d2hooks.PartyCancelledInvitation;
   import d2hooks.PartyCannotJoinError;
   import d2hooks.PartyInvitation;
   import d2hooks.PartyJoin;
   import d2hooks.PartyRefuseInvitationNotification;
   import flash.display.Sprite;
   import ui.JoinParty;
   import ui.PartyDisplay;
   import ui.PvpArena;
   import ui.TeamSearch;
   import ui.items.PartyMember;
   
   public class Party extends Sprite
   {
      
      private static var _self:Party;
      
      public static const PARTY_DISPLAY_UI:String = "partyDisplay";
      
      public static const PARTY_JOIN_UI:String = "partyJoin";
      
      public static var CURRENT_PARTY_TYPE_DISPLAYED_IS_ARENA:Boolean;
       
      
      protected var teamSearch:TeamSearch = null;
      
      protected var partyDisplay:PartyDisplay = null;
      
      protected var partyMember:PartyMember = null;
      
      protected var joinParty:JoinParty = null;
      
      protected var pvpArena:PvpArena = null;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var socialApi:SocialApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _popupName:String;
      
      private var _otherName:String;
      
      private var _teamSearchTab:int;
      
      private var _teamSearchDonjon:int;
      
      public function Party()
      {
         super();
      }
      
      public static function getInstance() : Party
      {
         return _self;
      }
      
      public function main() : void
      {
         _self = this;
         this.sysApi.addHook(OpenTeamSearch,this.onOpenTeamSearch);
         this.sysApi.addHook(OpenArena,this.onOpenArena);
         this.sysApi.addHook(PartyInvitation,this.onPartyInvitation);
         this.sysApi.addHook(PartyCannotJoinError,this.onPartyCannotJoinError);
         this.sysApi.addHook(PartyRefuseInvitationNotification,this.onPartyRefuseInvitationNotification);
         this.sysApi.addHook(PartyJoin,this.onPartyJoin);
         this.sysApi.addHook(PartyCancelledInvitation,this.onPartyCancelledInvitation);
      }
      
      public function get teamSearchTab() : int
      {
         return this._teamSearchTab;
      }
      
      public function set teamSearchTab(param1:int) : void
      {
         this._teamSearchTab = param1;
      }
      
      public function get teamSearchDonjon() : int
      {
         return this._teamSearchDonjon;
      }
      
      public function set teamSearchDonjon(param1:int) : void
      {
         this._teamSearchDonjon = param1;
      }
      
      public function onPartyInvitation(param1:uint, param2:String, param3:Number, param4:uint, param5:Object, param6:Object, param7:uint = 0, param8:Object = null, param9:String = "") : void
      {
         if(this.socialApi.isIgnored(param2))
         {
            return;
         }
         if(this.uiApi.getUi(PARTY_JOIN_UI))
         {
            this.uiApi.unloadUi(PARTY_JOIN_UI);
         }
         this.uiApi.loadUi(PARTY_JOIN_UI,PARTY_JOIN_UI,[param1,param2,param3,param4,param5,param6,param7,param8,param9]);
      }
      
      public function onPartyJoin(param1:int, param2:Object, param3:Boolean, param4:Boolean, param5:String = "") : void
      {
         if(this.uiApi.getUi(PARTY_JOIN_UI))
         {
            this.uiApi.unloadUi(PARTY_JOIN_UI);
         }
         if(!this.uiApi.getUi(PARTY_DISPLAY_UI))
         {
            this.uiApi.loadUi(PARTY_DISPLAY_UI,PARTY_DISPLAY_UI,{
               "partyMembers":param2,
               "restricted":param3,
               "arena":param4,
               "id":param1,
               "name":param5
            });
         }
      }
      
      public function onOpenTeamSearch() : void
      {
         if(this.uiApi.getUi("teamSearch"))
         {
            this.uiApi.unloadUi("teamSearch");
         }
         else
         {
            this.uiApi.loadUi("teamSearch","teamSearch");
         }
      }
      
      public function onOpenArena() : void
      {
         if(this.uiApi.getUi("pvpArena"))
         {
            this.uiApi.unloadUi("pvpArena");
         }
         else
         {
            this.uiApi.loadUi("pvpArena","pvpArena");
         }
      }
      
      private function onPartyCannotJoinError(param1:String) : void
      {
         this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),param1,[this.uiApi.getText("ui.common.ok")]);
      }
      
      private function onPartyRefuseInvitationNotification() : void
      {
         if(this.uiApi.getUi(PARTY_JOIN_UI))
         {
            this.uiApi.unloadUi(PARTY_JOIN_UI);
         }
      }
      
      private function onAcceptInvitation() : void
      {
      }
      
      private function onRefuseInvitation() : void
      {
      }
      
      private function onCancelInvitation() : void
      {
      }
      
      private function onIgnoreInvitation() : void
      {
      }
      
      private function onPartyCancelledInvitation(param1:uint = 0) : void
      {
         if(this.uiApi.getUi(PARTY_JOIN_UI))
         {
            this.uiApi.unloadUi(PARTY_JOIN_UI);
         }
      }
   }
}
