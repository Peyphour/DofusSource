package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.FriendSpouseFollow;
   import d2actions.JoinSpouse;
   import d2actions.PartyInvitation;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.SpouseFollowStatusUpdated;
   import d2hooks.SpouseUpdated;
   import flash.display.Sprite;
   
   public class Spouse
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var socialApi:SocialApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      public var chatApi:ChatApi;
      
      private var _spouse:Object;
      
      private var _charMask:Sprite;
      
      private var _bgLevelUri:Object;
      
      private var _bgPrestigeUri:Object;
      
      public var spouseCtr:GraphicContainer;
      
      public var lbl_title:Label;
      
      public var lbl_name:Label;
      
      public var lbl_breed:Label;
      
      public var lbl_levelTitle:Label;
      
      public var tx_level:Texture;
      
      public var lbl_level:Label;
      
      public var lbl_guild:Label;
      
      public var lbl_state:Label;
      
      public var lbl_loc:Label;
      
      public var lbl_alignment:Label;
      
      public var btn_lbl_btn_follow:Label;
      
      public var btn_group:ButtonContainer;
      
      public var btn_follow:ButtonContainer;
      
      public var btn_join:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var tx_inFight:Texture;
      
      public var ent_spouse:EntityDisplayer;
      
      public function Spouse()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(SpouseFollowStatusUpdated,this.onSpouseFollowStatusUpdated);
         this.sysApi.addHook(SpouseUpdated,this.onSpouseUpdated);
         this.uiApi.addComponentHook(this.btn_group,"onRelease");
         this.uiApi.addComponentHook(this.btn_follow,"onRelease");
         this.uiApi.addComponentHook(this.btn_join,"onRelease");
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._bgLevelUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgLevel_uri"));
         this._bgPrestigeUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgPrestige_uri"));
         this._charMask = new Sprite();
         this._charMask.name = "charMask";
         this.displaySpouse();
      }
      
      public function unload() : void
      {
      }
      
      private function displaySpouse() : void
      {
         this._spouse = this.socialApi.getSpouse();
         this.lbl_name.text = "{player," + this._spouse.name + "," + this._spouse.id + "::" + this._spouse.name + "}";
         this.lbl_title.text = this.uiApi.processText(this.uiApi.getText("ui.common.spouse"),this._spouse.sex > 0?"f":"m",true);
         if(this._spouse.level > ProtocolConstantsEnum.MAX_LEVEL)
         {
            this.lbl_levelTitle.text = this.uiApi.getText("ui.common.prestige") + this.uiApi.getText("ui.common.colon");
            this.lbl_level.text = "" + (this._spouse.level - ProtocolConstantsEnum.MAX_LEVEL);
            this.tx_level.uri = this._bgPrestigeUri;
         }
         else
         {
            this.lbl_levelTitle.text = this.uiApi.getText("ui.common.level") + this.uiApi.getText("ui.common.colon");
            this.lbl_level.text = this._spouse.level;
            this.tx_level.uri = this._bgLevelUri;
         }
         if(this._spouse.breed > 0)
         {
            this.lbl_breed.text = this.dataApi.getBreed(this._spouse.breed).shortName;
         }
         else
         {
            this.lbl_breed.text = "-";
         }
         if(this._spouse.entityLook != this.ent_spouse.look)
         {
            this.ent_spouse.look = this._spouse.entityLook;
         }
         this.lbl_guild.text = this.chatApi.getGuildLink(this._spouse,this._spouse.guildName);
         this.lbl_alignment.text = this.dataApi.getAlignmentSide(this._spouse.alignmentSide).name;
         if(this._spouse.online)
         {
            this.lbl_state.text = this.uiApi.getText("ui.server.state.online");
            this.lbl_loc.text = this.dataApi.getSubArea(this._spouse.subareaId).name;
            if(this._spouse.inFight)
            {
               this.tx_inFight.visible = true;
            }
            else
            {
               this.tx_inFight.visible = false;
            }
            if(this._spouse.followSpouse)
            {
               this.btn_lbl_btn_follow.text = this.uiApi.getText("ui.common.stopFollow");
            }
            else
            {
               this.btn_lbl_btn_follow.text = this.uiApi.getText("ui.common.follow");
            }
            if(this.btn_follow.disabled)
            {
               this.btn_follow.disabled = false;
            }
            if(this.btn_group.disabled)
            {
               this.btn_group.disabled = false;
            }
            if(this.btn_join.disabled)
            {
               this.btn_join.disabled = false;
            }
         }
         else
         {
            if(this.tx_inFight.visible)
            {
               this.tx_inFight.visible = false;
            }
            this.lbl_loc.text = "-";
            this.lbl_state.text = this.uiApi.getText("ui.server.state.offline");
            this.btn_follow.disabled = true;
            this.btn_group.disabled = true;
            this.btn_join.disabled = true;
         }
      }
      
      private function onSpouseFollowStatusUpdated(param1:Boolean) : void
      {
         if(param1)
         {
            this.btn_lbl_btn_follow.text = this.uiApi.getText("ui.common.stopFollow");
         }
         else
         {
            this.btn_lbl_btn_follow.text = this.uiApi.getText("ui.common.follow");
         }
         this._spouse = this.socialApi.getSpouse();
      }
      
      private function onSpouseUpdated() : void
      {
         this._spouse = this.socialApi.getSpouse();
         this.displaySpouse();
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_follow:
               this.sysApi.sendAction(new FriendSpouseFollow(!this._spouse.followSpouse));
               break;
            case this.btn_group:
               this.sysApi.sendAction(new PartyInvitation(this._spouse.name));
               break;
            case this.btn_join:
               this.sysApi.sendAction(new JoinSpouse());
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
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
