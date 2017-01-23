package ui.items
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.ProtocolConstantsEnum;
   
   public class GiftCharacterSelectionItem
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var mountApi:MountApi;
      
      private var _grid:Object;
      
      private var _data;
      
      private var _selected:Boolean;
      
      private var _bgLevelUri:Object;
      
      private var _bgPrestigeUri:Object;
      
      public var btn_character:ButtonContainer;
      
      public var lbl_name:Label;
      
      public var lbl_level:Label;
      
      public var tx_level:Texture;
      
      public var ed_avatar:EntityDisplayer;
      
      public function GiftCharacterSelectionItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._grid = param1.grid;
         this._data = param1.data;
         this._selected = false;
         this._bgLevelUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgLevel_uri"));
         this._bgPrestigeUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgPrestige_uri"));
         if(this.data)
         {
            this.uiApi.addComponentHook(this.btn_character,"onRollOver");
            this.uiApi.addComponentHook(this.btn_character,"onRelease");
            this.uiApi.addComponentHook(this.btn_character,"onRollOut");
         }
         else
         {
            this.uiApi.me().visible = false;
         }
         this.ed_avatar.setAnimationAndDirection("AnimArtwork",1);
         this.ed_avatar.view = "timeline";
         this.update(this._data,this._selected);
      }
      
      public function unload() : void
      {
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function update(param1:*, param2:Boolean) : void
      {
         if(!param1)
         {
            return;
         }
         this._selected = param2;
         this.btn_character.selected = param2;
         this.ed_avatar.width = 49;
         this.ed_avatar.height = 71;
         this.lbl_name.text = param1.name;
         if(param1.level > ProtocolConstantsEnum.MAX_LEVEL)
         {
            this.lbl_level.text = "" + (param1.level - ProtocolConstantsEnum.MAX_LEVEL);
            this.tx_level.uri = this._bgPrestigeUri;
         }
         else
         {
            this.lbl_level.text = param1.level;
            this.tx_level.uri = this._bgLevelUri;
         }
         this.ed_avatar.look = this.mountApi.getRiderEntityLook(param1.entityLook);
         this._data = param1;
      }
      
      public function select(param1:Boolean) : void
      {
         this.btn_character.selected = param1;
      }
      
      public function onRollOver(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_character:
               this.btn_character.bgAlpha = 0.2;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_character:
               this.btn_character.bgAlpha = 0.2;
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_character:
               if(this._selected)
               {
                  this.btn_character.bgAlpha = 0.2;
               }
               else
               {
                  this.btn_character.bgAlpha = 0;
               }
         }
      }
   }
}
