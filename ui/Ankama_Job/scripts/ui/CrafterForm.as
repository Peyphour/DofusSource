package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.JobCrafterContactLookRequest;
   import d2hooks.ChatFocus;
   import d2hooks.JobCrafterContactLook;
   
   public class CrafterForm
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var jobsApi:JobsApi;
      
      public var mountApi:MountApi;
      
      private var _data:Object;
      
      public var crafterFormCtr:GraphicContainer;
      
      public var entdis_character:EntityDisplayer;
      
      public var tx_bgDeco:Texture;
      
      public var btn_free:ButtonContainer;
      
      public var btn_mp:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var lbl_nameContent:Label;
      
      public var lbl_jobContent:Label;
      
      public var lbl_levelContent:Label;
      
      public var lbl_subareaContent:Label;
      
      public var lbl_craftingContent:Label;
      
      public var lbl_coordContent:Label;
      
      public var lbl_minLevelContent:Label;
      
      public function CrafterForm()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(JobCrafterContactLook,this.onJobCrafterContactLook);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._data = rest[0];
         this.updateInformations();
         this.entdis_character.direction = 2;
         this.sysApi.sendAction(new JobCrafterContactLookRequest(this._data.playerId));
         this.btn_free.disabled = true;
      }
      
      public function unload() : void
      {
      }
      
      private function updateInformations() : void
      {
         var _loc1_:SubArea = null;
         if(this._data.alignmentSide >= 0)
         {
            this.tx_bgDeco.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + this._data.alignmentSide);
         }
         else
         {
            this.tx_bgDeco.uri = this.uiApi.createUri(this.uiApi.me().getConstant("alignment_uri") + "0");
         }
         this.lbl_nameContent.text = "{player," + this._data.playerName + "," + this._data.playerId + "::" + this._data.playerName + "}";
         this.lbl_jobContent.text = this.jobsApi.getJobName(this._data.jobId);
         this.lbl_levelContent.text = this._data.jobLevel;
         if(!this._data.isInWorkshop)
         {
            this.lbl_craftingContent.text = this.uiApi.getText("ui.common.no");
            this.lbl_coordContent.text = "-";
            this.lbl_subareaContent.text = "";
         }
         else
         {
            this.lbl_craftingContent.text = this.uiApi.getText("ui.common.yes");
            this.lbl_coordContent.text = this._data.worldPos;
            _loc1_ = this.dataApi.getSubArea(this._data.subAreaId);
            this.lbl_subareaContent.text = this.dataApi.getArea(_loc1_.areaId).name + " ( " + _loc1_.name + " )";
         }
         this.btn_free.selected = this._data.freeCraft;
         this.lbl_minLevelContent.text = this.uiApi.getText("ui.craft.minLevel") + this.uiApi.getText("ui.common.colon") + this._data.minLevelCraft;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_mp:
               this.sysApi.dispatchHook(ChatFocus,this._data.playerName);
         }
      }
      
      public function onJobCrafterContactLook(param1:Number, param2:String, param3:*) : void
      {
         if(this.lbl_nameContent.text == param2)
         {
            this.entdis_character.look = this.mountApi.getRiderEntityLook(param3);
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
