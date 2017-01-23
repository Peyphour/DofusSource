package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.VideoPlayer;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.MapComplementaryInformationsData;
   import d2hooks.StopCinematic;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Cinematic
   {
       
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      private var _hasFlushed:Boolean = false;
      
      public var btn_skip:ButtonContainer;
      
      public var mainCtr:GraphicContainer;
      
      public var vplayer:VideoPlayer;
      
      public var tx_loading:Texture;
      
      public var tx_loading_bg:Texture;
      
      public var lb_loading:Label;
      
      private var _timeout:Boolean;
      
      private var _timer:Timer;
      
      public function Cinematic()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:String = this.sysApi.getConfigEntry("config.gfx.path.cinematic");
         var _loc3_:* = _loc2_ + param1.cinematicId + ".flv";
         this.sysApi.log(8,"Ouverture de la vidéo " + _loc3_);
         this.uiApi.addComponentHook(this.vplayer,"onVideoConnectFailed");
         this.uiApi.addComponentHook(this.vplayer,"onVideoConnectSuccess");
         this.uiApi.addComponentHook(this.vplayer,"onVideoBufferChange");
         this.sysApi.addHook(StopCinematic,this.onStopCinematic);
         this.sysApi.addHook(MapComplementaryInformationsData,this.onMapComplementaryInformationsData);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.vplayer.mute = !this.soundApi.soundsAreActivated();
         this.vplayer.flv = _loc3_;
         this.vplayer.connect();
         this.sysApi.showWorld(false);
         this.soundApi.activateSounds(false);
         if(this.uiApi.getUi("mapInfo"))
         {
            this.uiApi.getUi("mapInfo").uiClass.visible = false;
         }
         this.vplayer.width = this.mainCtr.width;
         this.vplayer.height = this.mainCtr.height;
         this._timer = new Timer(2000,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         this._timeout = false;
         this._timer.start();
      }
      
      public function unload() : void
      {
         this.sysApi.log(8,"Fermeture de l\'interface vidéo");
         this.sysApi.showWorld(true);
         this.soundApi.activateSounds(true);
         if(this.uiApi.getUi("mapInfo"))
         {
            this.uiApi.getUi("mapInfo").uiClass.visible = true;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_skip:
               this.sysApi.dispatchHook(StopCinematic);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:Object = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_skip:
               _loc2_ = this.uiApi.getText("ui.cancel.cinematic");
         }
         _loc5_ = this.uiApi.textTooltipInfo(_loc2_);
         this.uiApi.showTooltip(_loc5_,param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.vplayer.stop();
               this.sysApi.dispatchHook(StopCinematic);
         }
         return false;
      }
      
      public function onVideoConnectFailed(param1:Object) : void
      {
         switch(param1)
         {
            case this.vplayer:
               this.sysApi.log(16,"Echec de la lecture de la vidéo " + this.vplayer.flv);
               this.sysApi.dispatchHook(StopCinematic);
         }
      }
      
      public function dispatchQuitCinematic() : void
      {
         this.sysApi.dispatchHook(StopCinematic);
      }
      
      public function onVideoConnectSuccess(param1:Object) : void
      {
         switch(param1)
         {
            case this.vplayer:
               this.vplayer.play();
         }
      }
      
      public function onVideoBufferChange(param1:Object, param2:uint) : void
      {
         if(param1 == this.vplayer)
         {
            this.sysApi.log(8,"Changement d\'état du buffer vidéo : " + param2 + "     (timeout " + this._timeout + ")");
            switch(param2)
            {
               case 0:
                  this.tx_loading.visible = false;
                  this.lb_loading.visible = false;
                  this.tx_loading_bg.visible = false;
                  break;
               case 1:
                  if(this._timeout && this._hasFlushed)
                  {
                     this.vplayer.stop();
                     this.sysApi.dispatchHook(StopCinematic);
                  }
                  break;
               case 2:
                  this._hasFlushed = true;
            }
         }
      }
      
      public function onMapComplementaryInformationsData(param1:Object, param2:uint, param3:Boolean) : void
      {
         this.sysApi.showWorld(false);
      }
      
      private function onStopCinematic() : void
      {
         this.vplayer.stop();
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function onTimeOut(param1:Event) : void
      {
         this._timeout = true;
      }
   }
}
