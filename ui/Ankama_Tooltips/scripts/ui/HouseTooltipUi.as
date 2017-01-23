package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HouseTooltipUi
   {
       
      
      private var _timerHide:Timer;
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var lbl_guildName:Label;
      
      public var lbl_ownerName:Label;
      
      public var lbl_price:Label;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      private var _guild:GuildWrapper;
      
      public function HouseTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_.ownerName && _loc2_.ownerName != "" && _loc2_.ownerName != "?")
         {
            if(_loc2_.ownerName == Api.system.getPlayerManager().nickname)
            {
               this.lbl_ownerName.text = this.uiApi.getText("ui.common.myHouse");
            }
            else
            {
               this.lbl_ownerName.text = this.uiApi.getText("ui.common.houseOwnerName",_loc2_.ownerName);
            }
         }
         else
         {
            this.lbl_ownerName.text = this.uiApi.getText("ui.common.houseWithNoOwner");
         }
         if(this.lbl_price)
         {
            this.lbl_price.visible = _loc2_.isOnSale || _loc2_.isSaleLocked;
         }
         this._guild = _loc2_.guildIdentity;
         if(this._guild)
         {
            this.tx_emblemBack.visible = false;
            this.tx_emblemBack.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_emblemBack,"onTextureReady");
            this.tx_emblemBack.uri = this._guild.backEmblem.fullSizeIconUri;
            this.tx_emblemUp.visible = true;
            this.tx_emblemUp.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_emblemUp,"onTextureReady");
            this.tx_emblemUp.uri = this._guild.upEmblem.fullSizeIconUri;
            this.lbl_guildName.text = this._guild.guildName;
         }
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
         if(param1.autoHide)
         {
            this._timerHide = new Timer(2500);
            this._timerHide.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerHide.start();
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.uiApi.hideTooltip(this.uiApi.me().name);
      }
      
      public function unload() : void
      {
         if(this._timerHide)
         {
            this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerHide.stop();
            this._timerHide = null;
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         switch(param1)
         {
            case this.tx_emblemBack:
               this.utilApi.changeColor(this.tx_emblemBack.getChildByName("back"),this._guild.backEmblem.color,1);
               this.tx_emblemBack.visible = true;
               break;
            case this.tx_emblemUp:
               _loc2_ = this.dataApi.getEmblemSymbol(this._guild.upEmblem.idEmblem);
               if(_loc2_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._guild.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._guild.upEmblem.color,0,true);
               }
         }
      }
   }
}
