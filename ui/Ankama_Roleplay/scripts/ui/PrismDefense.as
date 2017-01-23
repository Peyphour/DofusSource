package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.AlignmentApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.PrismFightJoinLeaveRequest;
   import d2actions.PrismFightSwapRequest;
   import d2actions.PrismInfoJoinLeaveRequest;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   
   public class PrismDefense
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var alignApi:AlignmentApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _bInFighters:Boolean = false;
      
      private var _bJoinableFight:Boolean = false;
      
      private var _clockStart:uint;
      
      private var _clockDuration:uint;
      
      private var _sAttack:String;
      
      private var _sAttackersWord:String;
      
      public var prismDefenseCtr:GraphicContainer;
      
      public var lbl_loc:Label;
      
      public var lbl_nbBadGuys:Label;
      
      public var tx_progressBar:Texture;
      
      public var tx_badGuys:Texture;
      
      public var gd_defense:Grid;
      
      public var gd_reserve:Grid;
      
      public var btn_join:ButtonContainer;
      
      public var btn_littleClose:ButtonContainer;
      
      public var btn_prism:ButtonContainer;
      
      public var btn_lbl_btn_join:Label;
      
      public function PrismDefense()
      {
         super();
      }
      
      public function main(param1:Array) : void
      {
         this.uiApi.addComponentHook(this.gd_defense,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_defense,"onItemRollOver");
         this.uiApi.addComponentHook(this.gd_defense,"onItemRollOut");
         this.uiApi.addComponentHook(this.gd_reserve,"onSelectItem");
         this.uiApi.addComponentHook(this.gd_reserve,"onItemRollOver");
         this.uiApi.addComponentHook(this.gd_reserve,"onItemRollOut");
         this.uiApi.addComponentHook(this.tx_badGuys,"onRollOver");
         this.uiApi.addComponentHook(this.tx_badGuys,"onRollOut");
         this.gd_defense.autoSelectMode = 0;
         this.gd_reserve.autoSelectMode = 0;
         this.gd_defense.dataProvider = new Array();
         this.tx_progressBar.transform.colorTransform = new ColorTransform(1,0.09,0.09);
         this.tx_progressBar.scaleX = 0;
         this._sAttackersWord = this.uiApi.getText("ui.common.attackers");
         this._bJoinableFight = false;
         if(param1 && param1[0])
         {
            if(param1[0] == 1)
            {
               this._bJoinableFight = true;
            }
         }
         this.prismDefenseCtr.visible = false;
      }
      
      public function unload() : void
      {
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      private function updateFighters() : void
      {
         if(this._bJoinableFight)
         {
            this.prismDefenseCtr.visible = true;
            this.btn_prism.disabled = false;
         }
         else
         {
            this.sysApi.removeEventListener(this.onEnterFrame);
            this.btn_prism.disabled = true;
            this.prismDefenseCtr.visible = false;
         }
      }
      
      public function onPrismFightStateUpdate(param1:uint) : void
      {
         if(!this.sysApi || !this.uiApi)
         {
            return;
         }
         switch(param1)
         {
            case 1:
               this._bJoinableFight = true;
               break;
            case 2:
               this._bJoinableFight = false;
               this.updateFighters();
         }
      }
      
      public function onPrismFightUpdate(param1:int, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
      }
      
      public function onPrismInfoValid(param1:int, param2:int, param3:uint) : void
      {
         this._clockDuration = param1 * 100;
         this._clockStart = getTimer();
         this.sysApi.addEventListener(this.onEnterFrame,"time");
      }
      
      public function onPrismInfoInvalid(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               this.sysApi.log(2,"    pas de raison");
               break;
            case 1:
               this.sysApi.log(2,"    pas de combat");
               break;
            case 2:
               this.sysApi.log(2,"    en combat");
         }
      }
      
      public function onPrismInfoClose() : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_prism:
            case this.btn_littleClose:
               if(this._bJoinableFight)
               {
                  if(this.prismDefenseCtr.visible)
                  {
                     this.sysApi.removeEventListener(this.onEnterFrame);
                     if(this._bInFighters)
                     {
                        this.sysApi.sendAction(new PrismFightJoinLeaveRequest(0,false));
                     }
                     this.sysApi.sendAction(new PrismInfoJoinLeaveRequest(false));
                     this.prismDefenseCtr.visible = false;
                  }
                  else
                  {
                     this.sysApi.sendAction(new PrismInfoJoinLeaveRequest(true));
                     this.prismDefenseCtr.visible = true;
                     this.onPrismFightUpdate(1,true,true,true);
                  }
               }
               break;
            case this.btn_join:
               if(this._bInFighters)
               {
                  this.sysApi.sendAction(new PrismFightJoinLeaveRequest(0,false));
               }
               else
               {
                  this.sysApi.sendAction(new PrismFightJoinLeaveRequest(0,true));
               }
               break;
            case this.gd_defense:
            case this.gd_reserve:
               this.sysApi.sendAction(new PrismFightJoinLeaveRequest(0,true));
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case this.gd_defense:
               _loc4_ = this.gd_defense.selectedItem;
               if(_loc4_)
               {
                  if(_loc4_.playerCharactersInformations.id == this.playerApi.id())
                  {
                     this.sysApi.sendAction(new PrismFightJoinLeaveRequest(0,false));
                  }
                  else
                  {
                     this.sysApi.sendAction(new PrismFightSwapRequest(0,_loc4_.playerCharactersInformations.id));
                  }
               }
               else
               {
                  this.sysApi.sendAction(new PrismFightJoinLeaveRequest(0,true));
               }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(param2.data)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(param2.data.playerCharactersInformations.name + ", " + param2.data.playerCharactersInformations.level + " (" + param2.data.playerCharactersInformations.grade + ")"),param2.container,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRollOver(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_badGuys:
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this._sAttack),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
               break;
            case this.btn_prism:
               if(!this._bJoinableFight)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.pvp.prismAlreadyFighting")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
               }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onEnterFrame() : void
      {
         var _loc1_:uint = getTimer();
         var _loc2_:Number = (_loc1_ - this._clockStart) / this._clockDuration;
         this.tx_progressBar.scaleX = _loc2_;
         if(_loc2_ >= 1)
         {
            this.sysApi.removeEventListener(this.onEnterFrame);
            this._bJoinableFight = false;
            this.updateFighters();
         }
      }
   }
}
