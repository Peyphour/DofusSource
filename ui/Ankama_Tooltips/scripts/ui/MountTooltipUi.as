package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import d2hooks.MountRenamed;
   import d2hooks.MountSterilized;
   import d2hooks.MountXpRatio;
   import flash.geom.ColorTransform;
   import makers.MountTooltipMaker;
   
   public class MountTooltipUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _mountId:Number;
      
      private var _mount:Object;
      
      private var _serenityText:String;
      
      private var _playerMount:Boolean;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_serenity:GraphicContainer;
      
      public var ctr_mountReproduction:GraphicContainer;
      
      public var tx_mount:EntityDisplayer;
      
      public var tx_love:Texture;
      
      public var tx_maturity:Texture;
      
      public var tx_stamina:Texture;
      
      public var lbl_name:Label;
      
      public var lbl_ratio:Label;
      
      public var lbl_ratio0:Label;
      
      public var lbl_love:Label;
      
      public var lbl_maturity:Label;
      
      public var lbl_stamina:Label;
      
      public var lbl_reproduction:Label;
      
      public var tx_progressBarEnergy:Texture;
      
      public var tx_progressBarXP:Texture;
      
      public var tx_progressBarTired:Texture;
      
      public var tx_progressBarReproduction:Texture;
      
      public var tx_progressBarLove:Texture;
      
      public var tx_progressBarMaturity:Texture;
      
      public var tx_progressBarStamina:Texture;
      
      public var tx_progressBarSerenity:Texture;
      
      public function MountTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.sysApi.addHook(MountRenamed,this.onMountRenamed);
         this.sysApi.addHook(MountXpRatio,this.onMountXpRatio);
         this.sysApi.addHook(MountSterilized,this.onMountSterilized);
         this.uiApi.addComponentHook(this.lbl_love,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_love,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_maturity,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_maturity,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_stamina,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_stamina,"onRollOut");
         this.uiApi.addComponentHook(this.lbl_reproduction,"onRollOver");
         this.uiApi.addComponentHook(this.lbl_reproduction,"onRollOut");
         this.uiApi.addComponentHook(this.ctr_serenity,"onRollOver");
         this.uiApi.addComponentHook(this.ctr_serenity,"onRollOut");
         this.uiApi.addComponentHook(this.tx_love,"onRollOver");
         this.uiApi.addComponentHook(this.tx_love,"onRollOut");
         this.uiApi.addComponentHook(this.tx_maturity,"onRollOver");
         this.uiApi.addComponentHook(this.tx_maturity,"onRollOut");
         this.uiApi.addComponentHook(this.tx_stamina,"onRollOver");
         this.uiApi.addComponentHook(this.tx_stamina,"onRollOut");
         this._mount = param1.data;
         this.uiApi.me().mouseChildren = true;
         if(this._mount.isFecondationReady)
         {
            this.lbl_name.useCustomFormat = true;
            this.lbl_name.text = this._mount.name + " - " + this.uiApi.getText("ui.mount.fecondable");
         }
         this._serenityText = this._mount.aggressivityMax + "/" + this._mount.serenity + "/" + this._mount.serenityMax;
         this.tx_mount.look = param1.data.entityLook;
         this._mountId = param1.data.id;
         var _loc2_:Object = this.playerApi.getMount();
         if(_loc2_)
         {
            if(_loc2_.id == this._mountId)
            {
               this._playerMount = true;
            }
            else
            {
               this._playerMount = false;
            }
         }
         else
         {
            this._playerMount = false;
         }
         this.lbl_ratio.visible = this._playerMount;
         this.lbl_ratio0.visible = this._playerMount;
         this.tx_progressBarEnergy.transform.colorTransform = new ColorTransform(1,1,1,1,68,-160,-160);
         this.tx_progressBarXP.transform.colorTransform = new ColorTransform(1,1,1,1,-110,-66,0);
         this.tx_progressBarTired.transform.colorTransform = new ColorTransform(1,1,1,1,71,-50,-146);
         this.tx_progressBarReproduction.transform.colorTransform = new ColorTransform(1,1,1,1,71,-50,-146);
         this.tx_progressBarLove.transform.colorTransform = new ColorTransform(1,1,1,1,71,-50,-146);
         this.tx_progressBarMaturity.transform.colorTransform = new ColorTransform(1,1,1,1,71,-50,-146);
         this.tx_progressBarStamina.transform.colorTransform = new ColorTransform(1,1,1,1,71,-50,-146);
         this.tx_progressBarSerenity.transform.colorTransform = new ColorTransform(1,1,1,1,71,-50,-146);
         this.uiApi.getUi(MountTooltipMaker.lastUiName).getElement("tooltipCtr").addContent(this.uiApi.me());
      }
      
      private function onMountRenamed(param1:Number, param2:String) : void
      {
         if(param1 == this._mountId)
         {
            this.lbl_name.text = param2;
         }
      }
      
      private function onMountXpRatio(param1:uint) : void
      {
         this.lbl_ratio.text = param1 + "%";
      }
      
      private function onMountSterilized(param1:Number) : void
      {
         if(param1 == this._mountId)
         {
            this.ctr_mountReproduction.visible = false;
            this.lbl_reproduction.text = this.uiApi.getText("ui.mount.castrated");
            this.lbl_reproduction.css = "[local.css]normal.css";
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 6;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 == this.lbl_love)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipLove");
         }
         else if(param1 == this.lbl_maturity)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipMaturity");
         }
         else if(param1 == this.lbl_stamina)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipStamina");
         }
         else if(param1 == this.ctr_serenity)
         {
            _loc2_ = this._serenityText;
            _loc3_ = 7;
            _loc4_ = 1;
         }
         else if(param1 == this.tx_stamina)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipZone1");
            _loc3_ = 1;
            _loc4_ = 7;
            _loc5_ = 10;
         }
         else if(param1 == this.tx_maturity)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerToolTipZone2");
            _loc3_ = 1;
            _loc4_ = 7;
            _loc5_ = 10;
         }
         else if(param1 == this.tx_love)
         {
            _loc2_ = this.uiApi.getText("ui.mount.viewerTooltipZone3");
            _loc3_ = 1;
            _loc4_ = 7;
            _loc5_ = 10;
         }
         else if(param1 == this.lbl_reproduction)
         {
            if(this._mount.fecondationTime != -1)
            {
               _loc2_ = this.uiApi.getText("ui.mount.pregnantSince",this._mount.fecondationTime);
               _loc3_ = 1;
               _loc4_ = 7;
            }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,_loc5_,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function unload() : void
      {
      }
   }
}
