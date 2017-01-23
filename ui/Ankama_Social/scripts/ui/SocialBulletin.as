package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.TextAreaInput;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import d2actions.AllianceBulletinSetRequest;
   import d2actions.GuildBulletinSetRequest;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.AllianceBulletin;
   import d2hooks.GuildBulletin;
   
   public class SocialBulletin
   {
      
      private static var GUILD:int = 1;
      
      private static var ALLIANCE:int = 2;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var socialApi:SocialApi;
      
      public var timeApi:TimeApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _currentSocialGroup:int;
      
      private var _socialGroupData:Object;
      
      public var lbl_title:Label;
      
      public var ctr_text:GraphicContainer;
      
      public var lbl_bulletin:TextArea;
      
      public var btn_edit:ButtonContainer;
      
      public var lbl_lastEdit:Label;
      
      public var ctr_edit:GraphicContainer;
      
      public var inp_bulletin:TextAreaInput;
      
      public var btn_notifyMembers:ButtonContainer;
      
      public var btn_valid:ButtonContainer;
      
      public var btn_exit:ButtonContainer;
      
      public function SocialBulletin()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(GuildBulletin,this.onGuildBulletin);
         this.sysApi.addHook(AllianceBulletin,this.onAllianceBulletin);
         this.uiApi.addComponentHook(this.lbl_lastEdit,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_lastEdit,ComponentHookList.ON_ROLL_OUT);
         this.inp_bulletin.maxChars = ProtocolConstantsEnum.USER_MAX_BULLETIN_LEN;
         this._currentSocialGroup = this.uiApi.getUi("socialBase").uiClass.getTab();
         if(this.socialApi.hasGuildRight(this.playerApi.id(),"isBoss"))
         {
            this.btn_edit.visible = true;
         }
         else if(this._currentSocialGroup == GUILD && this.socialApi.hasGuildRank(this.playerApi.id(),2))
         {
            this.btn_edit.visible = true;
         }
         else
         {
            this.btn_edit.visible = false;
         }
         this.btn_valid.visible = false;
         this.btn_exit.visible = false;
         this.btn_notifyMembers.visible = false;
         if(this._currentSocialGroup == ALLIANCE)
         {
            this._socialGroupData = this.socialApi.getAlliance();
            this.lbl_title.text = this._socialGroupData.allianceName;
         }
         else
         {
            this._socialGroupData = this.socialApi.getGuild();
            this.lbl_title.text = this._socialGroupData.guildName;
         }
         this.updateBulletin();
      }
      
      public function unload() : void
      {
         var _loc1_:Number = Math.round(new Date().time / 1000);
         if(this._currentSocialGroup == GUILD)
         {
            this.sysApi.setData("guildBulletinLastVisitTimestamp",_loc1_);
         }
         else
         {
            this.sysApi.setData("allianceBulletinLastVisitTimestamp",_loc1_);
         }
      }
      
      private function switchEditMode(param1:Boolean) : void
      {
         if(param1)
         {
            this.inp_bulletin.text = this._socialGroupData.bulletin;
            this.inp_bulletin.focus();
            this.inp_bulletin.setSelection(8388607,8388607);
            this.ctr_edit.visible = true;
            this.ctr_text.visible = false;
            this.btn_edit.visible = false;
            this.btn_valid.visible = true;
            this.btn_exit.visible = true;
            this.btn_notifyMembers.visible = true;
         }
         else
         {
            this.ctr_edit.visible = false;
            this.ctr_text.visible = true;
            this.btn_edit.visible = true;
            this.btn_valid.visible = false;
            this.btn_exit.visible = false;
            this.btn_notifyMembers.visible = false;
         }
      }
      
      private function updateBulletin() : void
      {
         var _loc1_:Number = NaN;
         if(this._currentSocialGroup == ALLIANCE)
         {
            this._socialGroupData = this.socialApi.getAlliance();
         }
         else
         {
            this._socialGroupData = this.socialApi.getGuild();
         }
         this.lbl_bulletin.text = this._socialGroupData.formattedBulletin;
         this.inp_bulletin.text = this._socialGroupData.bulletin;
         if(!this.lbl_bulletin.text || this.lbl_bulletin.text == "")
         {
            if(this._currentSocialGroup == ALLIANCE)
            {
               this.lbl_bulletin.text = this.uiApi.getText("ui.motd.allianceBulletinDefault");
            }
            else
            {
               this.lbl_bulletin.text = this.uiApi.getText("ui.motd.guildBulletinDefault");
            }
         }
         if(this._socialGroupData.bulletinWriterName != "")
         {
            _loc1_ = this._socialGroupData.bulletinTimestamp * 1000;
            this.lbl_lastEdit.text = this.uiApi.getText("ui.motd.lastModification",this.timeApi.getDate(_loc1_,true) + " " + this.timeApi.getClock(_loc1_,true,true),this._socialGroupData.bulletinWriterName);
         }
      }
      
      private function onAllianceBulletin() : void
      {
         var _loc1_:Number = NaN;
         if(this._currentSocialGroup == ALLIANCE)
         {
            this.updateBulletin();
            this.switchEditMode(false);
            _loc1_ = Math.round(new Date().time / 1000);
            this.sysApi.setData("allianceBulletinLastVisitTimestamp",_loc1_);
         }
      }
      
      private function onGuildBulletin() : void
      {
         var _loc1_:Number = NaN;
         if(this._currentSocialGroup == GUILD)
         {
            this.updateBulletin();
            this.switchEditMode(false);
            _loc1_ = Math.round(new Date().time / 1000);
            this.sysApi.setData("guildBulletinLastVisitTimestamp",_loc1_);
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         if(param1 == this.btn_edit)
         {
            this.switchEditMode(true);
         }
         else if(param1 == this.btn_exit)
         {
            this.switchEditMode(false);
         }
         else if(param1 == this.btn_valid)
         {
            if(this.inp_bulletin.text != this._socialGroupData.bulletin)
            {
               _loc2_ = this.btn_notifyMembers.selected;
               if(this._currentSocialGroup == GUILD)
               {
                  this.sysApi.sendAction(new GuildBulletinSetRequest(this.inp_bulletin.text,_loc2_));
               }
               else if(this._currentSocialGroup == ALLIANCE)
               {
                  this.sysApi.sendAction(new AllianceBulletinSetRequest(this.inp_bulletin.text,_loc2_));
               }
            }
            else
            {
               this.switchEditMode(false);
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         if(param1 == this.lbl_lastEdit)
         {
            if(this._currentSocialGroup == GUILD)
            {
               _loc2_ = this.uiApi.getText("ui.motd.guildBulletinEdit");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.motd.allianceBulletinEdit");
            }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
