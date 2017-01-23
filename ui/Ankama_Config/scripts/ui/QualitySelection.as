package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.StatesEnum;
   import d2hooks.SetDofusQuality;
   import flash.ui.MouseCursor;
   
   public class QualitySelection
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var configApi:ConfigApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _qualityTextures:Array;
      
      private var _selectedQuality:uint = 2;
      
      private var _selectedTypo:uint = 1;
      
      public var mainCtr:Object;
      
      public var grid_quality:Grid;
      
      public var btn_quality:ButtonContainer;
      
      public var btn_typo:ButtonContainer;
      
      public var btn_small:ButtonContainer;
      
      public var btn_big:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var ctr_quality:GraphicContainer;
      
      public var ctr_typo:GraphicContainer;
      
      public var lbl_big_example:TextArea;
      
      public var lbl_small_example:TextArea;
      
      public function QualitySelection()
      {
         this._qualityTextures = new Array();
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:Array = [{
            "id":0,
            "title":"low",
            "x":130,
            "y":60
         },{
            "id":1,
            "title":"medium",
            "x":150,
            "y":45
         },{
            "id":2,
            "title":"high",
            "x":175,
            "y":80
         }];
         this.grid_quality.dataProvider = _loc2_;
         this.grid_quality.selectedIndex = this._selectedQuality;
         this._qualityTextures[this._selectedQuality].btn_quality.selected = true;
      }
      
      public function unload() : void
      {
         this._qualityTextures = null;
      }
      
      public function updateQualitySlot(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_title.text = this.uiApi.getText("ui.option.quality." + param1.title + "Quality").toLocaleUpperCase();
            param2.lbl_processor.text = this.uiApi.getText("ui.option.quality." + param1.title + ".processor");
            param2.lbl_ram.text = this.uiApi.getText("ui.option.quality." + param1.title + ".ram");
            param2.tx_decoQuality.uri = this.uiApi.createUri(this.uiApi.me().getConstant("bg_quality" + param1.id));
            this._qualityTextures[param1.id] = param2;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         this.sysApi.setMouseCursor(MouseCursor.BUTTON);
         if(param1 == this.lbl_small_example)
         {
            this.btn_small.state = StatesEnum.STATE_OVER;
         }
         else if(param1 == this.lbl_big_example)
         {
            this.btn_big.state = StatesEnum.STATE_OVER;
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.sysApi.setMouseCursor(MouseCursor.AUTO);
         if(!this.btn_small.selected && param1 == this.lbl_small_example)
         {
            this.btn_small.state = StatesEnum.STATE_NORMAL;
         }
         else if(!this.btn_big.selected && param1 == this.lbl_big_example)
         {
            this.btn_big.state = StatesEnum.STATE_NORMAL;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_quality:
               this.sysApi.dispatchHook(SetDofusQuality,this._selectedQuality);
               if(!this.ctr_typo.visible)
               {
                  this.configApi.setConfigProperty("dofus","askForQualitySelection",false);
                  this.ctr_quality.visible = false;
                  this.lbl_title.text = this.uiApi.getText("ui.option.typo.select");
                  this.lbl_big_example.text = this.uiApi.getText("ui.option.typo.exampleBig",17);
                  this.lbl_small_example.text = this.uiApi.getText("ui.option.typo.example",15);
                  this.btn_big.selected = true;
                  this.ctr_typo.visible = true;
               }
               else
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               break;
            case this.btn_small:
            case this.lbl_small_example:
               this._selectedTypo = 0;
               this.btn_small.selected = true;
               break;
            case this.btn_big:
            case this.lbl_big_example:
               this._selectedTypo = 1;
               this.btn_big.selected = true;
               break;
            case this.btn_typo:
               this.sysApi.changeActiveFontType(this._selectedTypo == 0?"smallScreen":"");
               this.configApi.setConfigProperty("dofus","smallScreenFont",this._selectedTypo == 0?true:false);
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.grid_quality && param2 != 7)
         {
            this._selectedQuality = this.grid_quality.selectedItem.id;
         }
      }
   }
}
