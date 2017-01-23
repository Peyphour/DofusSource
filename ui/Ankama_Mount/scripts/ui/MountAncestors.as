package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2enums.ShortcutHookListEnum;
   
   public class MountAncestors
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      private var _mount:Object;
      
      private var _names:Array;
      
      public var btn_close:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var lbl_name:Label;
      
      public var d0:EntityDisplayer;
      
      public var d1:EntityDisplayer;
      
      public var d2:EntityDisplayer;
      
      public var d3:EntityDisplayer;
      
      public var d4:EntityDisplayer;
      
      public var d5:EntityDisplayer;
      
      public var d6:EntityDisplayer;
      
      public var d7:EntityDisplayer;
      
      public var d8:EntityDisplayer;
      
      public var d9:EntityDisplayer;
      
      public var d10:EntityDisplayer;
      
      public var d11:EntityDisplayer;
      
      public var d12:EntityDisplayer;
      
      public var d13:EntityDisplayer;
      
      public var d14:EntityDisplayer;
      
      public function MountAncestors()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._names = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 15)
         {
            this.uiApi.addComponentHook(this["d" + _loc2_],"onRollOver");
            this.uiApi.addComponentHook(this["d" + _loc2_],"onRollOut");
            _loc2_++;
         }
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this._mount = param1.mount;
         this.lbl_title.text = this.uiApi.getText("ui.mount.ancestors",this._mount.name);
         this.lbl_name.text = this._mount.name;
         this.d0.look = this._mount.ancestor.entityLook;
         this.displayMount(this._mount.ancestor,this.d1,this.d2);
         this._names[this.d0.name] = this._mount.description;
         if(this._mount.ancestor.father)
         {
            this.displayMount(this._mount.ancestor.father,this.d3,this.d4);
            this.displayMount(this._mount.ancestor.mother,this.d5,this.d6);
            if(this._mount.ancestor.father.father)
            {
               this.displayMount(this._mount.ancestor.father.father,this.d7,this.d8);
               this.displayMount(this._mount.ancestor.father.mother,this.d9,this.d10);
            }
            if(this._mount.ancestor.mother.father)
            {
               this.displayMount(this._mount.ancestor.mother.father,this.d11,this.d12);
               this.displayMount(this._mount.ancestor.mother.mother,this.d13,this.d14);
            }
         }
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
         this._mount = null;
         this._names = null;
      }
      
      private function displayMount(param1:Object, param2:Object, param3:Object) : void
      {
         if(param1.father)
         {
            param2.look = param1.father.entityLook;
            this._names[param2.name] = param1.father.mount.name;
         }
         if(param1.mother)
         {
            param3.look = param1.mother.entityLook;
            this._names[param3.name] = param1.mother.mount.name;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:Object = this.uiApi.textTooltipInfo(this._names[param1.name]);
         if(_loc2_)
         {
            this.uiApi.showTooltip(_loc2_,param1,false,"standard",1,7,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_close)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
   }
}
