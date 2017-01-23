package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.types.game.idol.PartyIdol;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.OpenIdols;
   import d2hooks.FightIdolList;
   import d2hooks.FoldAll;
   import d2hooks.IdolFightPreparationUpdate;
   import d2hooks.RoleplayBuffViewContent;
   import d2hooks.UpdatePreFightersList;
   
   public class FightIdols
   {
      
      private static const CHALLENGER:String = "challenger";
       
      
      private var _idols:Object;
      
      private var _slots:Array;
      
      private var _hidden:Boolean = false;
      
      private var _rpBuffNumber:int = 0;
      
      private var _foldStatus:Boolean;
      
      private var _totalFightersNumber:uint;
      
      private var _challengerSide:Array;
      
      private var _defenderSide:Array;
      
      private var _playerFighterId:Number;
      
      private var _definitivList:Boolean = false;
      
      private var _deactivationReason:Array;
      
      private var _txBackgroundWidthmodifier:int;
      
      private var _txBackgroundOffset:int;
      
      private var _txButtonMinimizeBgLeftOffset:int;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var storageApi:StorageApi;
      
      public var configApi:ConfigApi;
      
      public var dataApi:DataApi;
      
      public var fightApi:FightApi;
      
      public var playedCharacterApi:PlayedCharacterApi;
      
      public var _forbiddenIdols:Array;
      
      public var idolCtr:GraphicContainer;
      
      public var btn_minimArrow:ButtonContainer;
      
      public var btn_minimArrow_small:ButtonContainer;
      
      public var btn_minimArrow_tx:Texture;
      
      public var tx_background:TextureBitmap;
      
      public var idolFrames:GraphicContainer;
      
      public var tx_idolIcon:TextureBitmap;
      
      public var tx_button_minimize_bgLeft:Texture;
      
      public var idol_slot_1:Texture;
      
      public var idol_slot_2:Texture;
      
      public var idol_slot_3:Texture;
      
      public var idol_slot_4:Texture;
      
      public var idol_slot_5:Texture;
      
      public var idol_slot_6:Texture;
      
      public function FightIdols()
      {
         this._challengerSide = new Array();
         this._defenderSide = new Array();
         this._forbiddenIdols = new Array();
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:Texture = null;
         this._deactivationReason = new Array();
         this._hidden = this.configApi.getConfigProperty("dofus","lastFightIdolUiHidden");
         this._slots = [this.idol_slot_1,this.idol_slot_2,this.idol_slot_3,this.idol_slot_4,this.idol_slot_5,this.idol_slot_6];
         this._txBackgroundWidthmodifier = this.uiApi.me().getConstant("backgroundWidthmodifier");
         this._txBackgroundOffset = this.uiApi.me().getConstant("txBackgroundOffset");
         this._txButtonMinimizeBgLeftOffset = this.uiApi.me().getConstant("txButtonMinimizeBgLeftOffset");
         for each(_loc2_ in this._slots)
         {
            this.uiApi.addComponentHook(_loc2_,"onRollOver");
            this.uiApi.addComponentHook(_loc2_,"onRollOut");
            this.uiApi.addComponentHook(_loc2_,"onRelease");
         }
         this.sysApi.addHook(RoleplayBuffViewContent,this.onInventoryUpdate);
         this.sysApi.addHook(IdolFightPreparationUpdate,this.setIdols);
         this.sysApi.addHook(UpdatePreFightersList,this.updateFightersList);
         this.sysApi.addHook(FightIdolList,this.onFinalIdolList);
         this.btn_minimArrow.visible = false;
         this.tx_background.visible = false;
         this.idolFrames.visible = false;
         this.btn_minimArrow_small.visible = false;
         this.tx_background.height = 65;
         this.sysApi.addHook(FoldAll,this.onFoldAll);
         this._definitivList = param1[2];
         this.setIdols(param1[0],param1[1]);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_minimArrow:
               this._hidden = true;
               this.btn_minimArrow.visible = false;
               this.btn_minimArrow_small.visible = true;
               this.tx_background.visible = false;
               this.idolFrames.visible = false;
               break;
            case this.btn_minimArrow_small:
               this._hidden = false;
               this.btn_minimArrow.visible = true;
               this.btn_minimArrow_small.visible = false;
               this.tx_background.visible = true;
               this.idolFrames.visible = true;
               break;
            default:
               if(param1.name.indexOf("slot") != -1)
               {
                  this.sysApi.sendAction(new OpenIdols());
               }
         }
         this.configApi.setConfigProperty("dofus","lastFightIdolUiHidden",this._hidden);
      }
      
      private function onInventoryUpdate(param1:Object) : void
      {
         this.repositionUi();
      }
      
      private function onFinalIdolList(param1:Object) : void
      {
         this._definitivList = true;
         this._idols = param1;
         this.update(0);
      }
      
      private function repositionUi() : void
      {
         this._rpBuffNumber = this.storageApi.getViewContent("roleplayBuff").length;
         if(this._rpBuffNumber > 0)
         {
            this.btn_minimArrow.x = -this.getBuffUiSize();
            this.idolFrames.x = -this.getBuffUiSize();
            this.btn_minimArrow_small.x = -this.getBuffUiSize();
            this.tx_button_minimize_bgLeft.x = -this.getBuffUiSize() + this._txButtonMinimizeBgLeftOffset;
            this.tx_idolIcon.x = -this.getBuffUiSize();
            this.tx_background.x = -(this.tx_background.width + this.getBuffUiSize()) + this._txBackgroundOffset;
         }
         else
         {
            this.btn_minimArrow.x = 0;
            this.idolFrames.x = -10;
            this.btn_minimArrow_small.x = 0;
            this.tx_background.x = -this.tx_background.width + this._txBackgroundOffset;
         }
         this.uiApi.me().render();
      }
      
      private function getBuffUiSize() : Number
      {
         return (this._slots[0].width + 6) * this._rpBuffNumber + 26 + this.btn_minimArrow.width;
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:com.ankamagames.dofus.datacenter.idols.Idol = null;
         var _loc2_:com.ankamagames.dofus.network.types.game.idol.Idol = this._idols[this._slots.indexOf(param1)];
         if(_loc2_)
         {
            _loc4_ = this.dataApi.getIdol(_loc2_.id);
            _loc3_ = "<p><b>" + _loc4_.item.name + "</b></p><br>";
            _loc3_ = _loc3_ + ("<p>" + _loc4_.spellPair.description + "</p><br>");
            _loc3_ = _loc3_ + ("<p>" + this.uiApi.getText("ui.idol.short.bonusLoot",_loc2_.dropBonusPercent) + "%" + "<br>");
            _loc3_ = _loc3_ + (this.uiApi.getText("ui.idol.short.bonusXp",_loc2_.xpBonusPercent) + "%</p>");
            if(param1.softDisabled == true)
            {
               _loc3_ = _loc3_ + ("<br><p><b>" + this._deactivationReason[this._idols.indexOf(_loc2_)] + "</b></p>");
            }
         }
         if(_loc3_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param1,false,"standard",0,2,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onFoldAll(param1:Boolean) : void
      {
         if(param1)
         {
            this._foldStatus = !this._hidden;
            this._hidden = true;
            this.btn_minimArrow.visible = false;
            this.btn_minimArrow_small.visible = true;
            this.tx_background.visible = false;
            this.idolFrames.visible = false;
         }
         else
         {
            this._hidden = !this._foldStatus;
            this.btn_minimArrow.visible = this._foldStatus;
            this.btn_minimArrow_small.visible = !this._foldStatus;
            this.tx_background.visible = this._foldStatus;
            this.idolFrames.visible = this._foldStatus;
         }
      }
      
      public function update(param1:Number) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:ItemWrapper = null;
         if(this._idols.length == 0)
         {
            this.idolCtr.visible = false;
         }
         else
         {
            if(!this._hidden && this._idols)
            {
               this.btn_minimArrow.visible = true;
               this.btn_minimArrow_small.visible = false;
               this.tx_background.visible = true;
               this.idolFrames.visible = true;
            }
            else
            {
               this.btn_minimArrow_small.visible = true;
            }
            if(!this._hidden)
            {
               this.idolCtr.visible = true;
            }
            _loc3_ = 0;
            while(_loc3_ < this._slots.length)
            {
               _loc2_ = this._slots[_loc3_];
               if(_loc3_ >= this._idols.length)
               {
                  _loc2_.visible = false;
               }
               else
               {
                  _loc2_.visible = true;
                  _loc4_ = this.dataApi.getItemWrapper(Idol(this.dataApi.getIdol(this._idols[_loc3_].id)).itemId);
                  _loc2_.uri = _loc4_.iconUri;
                  if(this._definitivList)
                  {
                     _loc2_.softDisabled = false;
                  }
                  else
                  {
                     _loc2_.softDisabled = !this.isIdolActive(this._idols[_loc3_]);
                  }
               }
               _loc3_++;
            }
            this.tx_background.width = (this._slots[0].width + 6) * this._idols.length + this._txBackgroundWidthmodifier;
            this.repositionUi();
         }
      }
      
      private function setIdols(param1:Number, param2:Object) : void
      {
         this._idols = param2;
         this.update(param1);
      }
      
      private function updateFightersList(param1:Number = 0) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         if(!this._definitivList)
         {
            this._challengerSide = new Array();
            this._defenderSide = new Array();
            _loc2_ = this.fightApi.getFighters();
            if(_loc2_.length == this._totalFightersNumber)
            {
               return;
            }
            this._totalFightersNumber = _loc2_.length;
            this._playerFighterId = this.playedCharacterApi.id();
            for each(_loc3_ in _loc2_)
            {
               if(this.fightApi.getFighterInformations(_loc3_).team == CHALLENGER)
               {
                  this._challengerSide.push(_loc3_);
               }
               else
               {
                  this._defenderSide.push(_loc3_);
               }
            }
            for each(_loc3_ in this._defenderSide)
            {
               _loc4_ = this.fightApi.getMonsterId(_loc3_);
               if(_loc4_ != -1)
               {
                  for each(_loc5_ in this.dataApi.getMonsterFromId(_loc4_).incompatibleIdols)
                  {
                     this._forbiddenIdols.push(_loc5_);
                  }
               }
            }
            this.updateIdolActivation();
         }
      }
      
      public function updateIdolActivation() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._idols.length)
         {
            this._slots[_loc1_].softDisabled = !this.isIdolActive(this._idols[_loc1_]);
            _loc1_++;
         }
      }
      
      public function unload() : void
      {
      }
      
      private function isIdolActive(param1:com.ankamagames.dofus.network.types.game.idol.Idol) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc2_:com.ankamagames.dofus.datacenter.idols.Idol = this.dataApi.getIdol(param1.id);
         if(this._forbiddenIdols.indexOf(param1.id) != -1)
         {
            this._deactivationReason[this._idols.indexOf(param1)] = this.uiApi.getText("ui.idol.desactivationReason.monterIncompatibility");
            return false;
         }
         if(_loc2_.groupOnly && (this._challengerSide.length < 4 || this._defenderSide.length < 4))
         {
            this._deactivationReason[this._idols.indexOf(param1)] = this.uiApi.getText("ui.idol.desactivationReason.battlePartyTooSmall");
            return false;
         }
         if(param1 is PartyIdol)
         {
            for each(_loc3_ in PartyIdol(param1).ownersIds)
            {
               if(_loc3_ == this._playerFighterId || this._challengerSide.indexOf(_loc3_) != -1)
               {
                  _loc4_ = true;
                  break;
               }
            }
            if(!_loc4_)
            {
               this._deactivationReason[this._idols.indexOf(param1)] = this.uiApi.getText("ui.idol.desactivationReason.noOwnerInBattle");
               return false;
            }
         }
         return true;
      }
   }
}
