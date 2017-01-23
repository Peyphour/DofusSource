package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.FinishMoveListRequest;
   import d2actions.FinishMoveSetRequest;
   import d2enums.SelectMethodEnum;
   import d2enums.ShortcutHookListEnum;
   import flash.utils.Dictionary;
   
   public class FinishMoveList
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      private var _finishMoves:Array;
      
      private var _enabledFinishMoves:Vector.<int>;
      
      private var _disabledFinishMoves:Vector.<int>;
      
      private var _btnDataAssoc:Dictionary;
      
      public var gd_finishMoves:Grid;
      
      public var btn_validate:ButtonContainer;
      
      public var btn_cancel:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var tx_illu:Texture;
      
      public var tx_help:Texture;
      
      public var lbl_info:Label;
      
      public function FinishMoveList()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._enabledFinishMoves = new Vector.<int>(0);
         this._disabledFinishMoves = new Vector.<int>(0);
         this._btnDataAssoc = new Dictionary();
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.sysApi.addHook(d2hooks.FinishMoveList,this.onFinishMoveList);
         this.sysApi.sendAction(new FinishMoveListRequest());
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.tx_help.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_help,"onTextureReady");
         this.tx_help.uri = this.uiApi.createUri(this.sysApi.getConfigEntry("config.ui.skin") + "texture/help_icon_normal.png");
      }
      
      public function updateFinishMoveLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_finishMoveName.text = param1.name;
            this._btnDataAssoc[param2.btn_finishMove] = param1;
            if(param1.hasOwnProperty("enabled"))
            {
               param2.btn_finishMove.selected = param2.tx_checkFinishMove.visible = this._enabledFinishMoves.indexOf(param1.id) != -1;
            }
            else
            {
               param2.tx_checkFinishMove.visible = false;
               param2.btn_finishMove.softDisabled = true;
            }
         }
         else
         {
            param2.lbl_finishMoveName.text = "";
            param2.tx_checkFinishMove.visible = false;
            param2.btn_finishMove.softDisabled = true;
         }
      }
      
      private function restoreFinishMoves() : void
      {
         var _loc1_:Object = null;
         this._enabledFinishMoves.length = 0;
         this._disabledFinishMoves.length = 0;
         for each(_loc1_ in this._finishMoves)
         {
            if(_loc1_.enabled)
            {
               this._enabledFinishMoves.push(_loc1_.id);
            }
            else
            {
               this._disabledFinishMoves.push(_loc1_.id);
            }
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1 == this.tx_help)
         {
            _loc2_ = this.lbl_info.textfield.getLineMetrics(0);
            this.tx_help.x = this.lbl_info.x + this.lbl_info.textfield.getLineMetrics(0).x + this.lbl_info.textfield.textWidth + 10;
         }
      }
      
      public function onFinishMoveList(param1:Array) : void
      {
         var _loc3_:Object = null;
         this._finishMoves = param1;
         this.restoreFinishMoves();
         var _loc2_:Array = this.dataApi.getFinishMoves();
         var _loc4_:Array = new Array();
         for each(_loc3_ in _loc2_)
         {
            if(this._enabledFinishMoves.indexOf(_loc3_.id) == -1 && this._disabledFinishMoves.indexOf(_loc3_.id) == -1)
            {
               _loc4_.push({
                  "id":_loc3_.id,
                  "name":this.dataApi.getSpell(_loc3_.getSpellLevel().spellId).name
               });
            }
         }
         _loc4_ = _loc4_.concat(this._finishMoves);
         _loc4_.sortOn("id",Array.NUMERIC);
         this.gd_finishMoves.dataProvider = _loc4_;
         this.btn_cancel.disabled = true;
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 == this.gd_finishMoves && param2 != SelectMethodEnum.AUTO && param2 != SelectMethodEnum.UP_ARROW && param2 != SelectMethodEnum.DOWN_ARROW && param2 != SelectMethodEnum.LEFT_ARROW && param2 != SelectMethodEnum.RIGHT_ARROW)
         {
            _loc4_ = this._enabledFinishMoves.indexOf(this.gd_finishMoves.selectedItem.id);
            _loc5_ = this._disabledFinishMoves.indexOf(this.gd_finishMoves.selectedItem.id);
            if(_loc4_ != -1)
            {
               this._enabledFinishMoves.splice(_loc4_,1);
               this._disabledFinishMoves.push(this.gd_finishMoves.selectedItem.id);
            }
            else if(_loc5_ != -1)
            {
               this._disabledFinishMoves.splice(_loc5_,1);
               this._enabledFinishMoves.push(this.gd_finishMoves.selectedItem.id);
            }
            this.gd_finishMoves.updateItem(this.gd_finishMoves.selectedIndex);
            this.btn_cancel.disabled = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_validate:
               if(this._finishMoves.length)
               {
                  this.sysApi.sendAction(new FinishMoveSetRequest(this._enabledFinishMoves,this._disabledFinishMoves));
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               break;
            case this.btn_cancel:
               if(this._finishMoves.length)
               {
                  this.restoreFinishMoves();
                  this.gd_finishMoves.updateItems();
                  this.btn_cancel.disabled = true;
               }
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         if(param1 == this.tx_help)
         {
            _loc2_ = this.uiApi.getText("ui.grimoire.finishMove.help");
         }
         else
         {
            _loc3_ = this._btnDataAssoc[param1];
            if(_loc3_)
            {
               this.tx_illu.uri = this.uiApi.createUri((this.uiApi.me().getConstant("illuPath") as String).replace("#",_loc3_.id));
               this.tx_illu.visible = true;
               if(!_loc3_.hasOwnProperty("enabled"))
               {
                  _loc2_ = this.uiApi.getText("ui.grimoire.finishMove.buyInShop");
               }
            }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
   }
}
