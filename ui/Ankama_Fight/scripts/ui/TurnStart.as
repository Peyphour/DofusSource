package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.ProtocolConstantsEnum;
   import flash.utils.getTimer;
   
   public class TurnStart
   {
      
      public static const POPUP_TIME:uint = 2000;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var fightApi:FightApi;
      
      private var _clockStart:uint;
      
      public var mainCtr:GraphicContainer;
      
      public var tx_picture:Object;
      
      public var tx_background:Texture;
      
      public var entityDisplayer:EntityDisplayer;
      
      public var lb_name:Label;
      
      public var lb_level:Label;
      
      public var windowCtr:GraphicContainer;
      
      public function TurnStart()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addEventListener(this.onEnterFrame,"time");
         this.restart(param1.fighterId,param1.waitingTime);
      }
      
      public function unload() : void
      {
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      public function restart(param1:Number, param2:uint) : void
      {
         var _loc5_:Number = NaN;
         var _loc3_:Object = this.fightApi.getFighterInformations(param1);
         this._clockStart = getTimer();
         this.lb_name.text = this.fightApi.getFighterName(param1);
         var _loc4_:int = this.fightApi.getFighterLevel(param1);
         if(param1 > 0 && _loc4_ > ProtocolConstantsEnum.MAX_LEVEL)
         {
            this.lb_level.text = this.uiApi.getText("ui.common.prestige") + " " + (_loc4_ - ProtocolConstantsEnum.MAX_LEVEL);
         }
         else
         {
            this.lb_level.text = this.uiApi.getText("ui.common.level") + " " + _loc4_;
         }
         if(this.lb_name.textWidth > this.lb_level.textWidth)
         {
            _loc5_ = this.lb_name.textWidth + this.lb_name.x * 1.9;
         }
         else
         {
            _loc5_ = this.lb_level.textWidth + this.lb_level.x * 1.9;
         }
         this.windowCtr.width = _loc5_ + parseInt(this.uiApi.me().getConstant("windowMargin"));
         this.entityDisplayer.useFade = false;
         this.entityDisplayer.setAnimationAndDirection("AnimArtwork",1);
         this.entityDisplayer.view = "turnstart";
         this.entityDisplayer.look = this.fightApi.getFighterInformations(param1).look;
         this.mainCtr.visible = true;
         this.uiApi.me().render();
      }
      
      public function onEnterFrame() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(this.mainCtr.visible)
         {
            _loc1_ = getTimer();
            _loc2_ = _loc1_ - this._clockStart;
            _loc3_ = this.uiApi.me();
            if(_loc2_ > POPUP_TIME)
            {
               this.mainCtr.visible = false;
            }
         }
      }
   }
}
