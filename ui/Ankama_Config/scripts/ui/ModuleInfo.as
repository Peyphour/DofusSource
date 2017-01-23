package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.InstalledModuleInfoRequest;
   import d2actions.ModuleInstallCancel;
   import d2actions.ModuleInstallConfirm;
   import d2enums.ComponentHookList;
   import d2hooks.ApisHooksActionsList;
   
   public class ModuleInfo
   {
       
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var sysApi:SystemApi;
      
      public var tx_bg:Texture;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var btn_activateModule:ButtonContainer;
      
      public var btn_refuse:ButtonContainer;
      
      public var btn_accept:ButtonContainer;
      
      public var ta_details:TextArea;
      
      public var lbl_moduleName:Label;
      
      public var lbl_moduleAuthor:Label;
      
      public var lbl_moduleVersion:Label;
      
      public var lbl_moduleDofusVersion:Label;
      
      public var lbl_moduleDescription:Label;
      
      private var _module:Object;
      
      private var _confirmActivationCallback:Function;
      
      private var _isUpdate:Boolean;
      
      public function ModuleInfo()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._module = param1.module;
         this._confirmActivationCallback = param1.activationCallback;
         this.showModuleDetails(this._module);
         if(!param1.details)
         {
            this.sysApi.sendAction(new InstalledModuleInfoRequest(this._module.id));
         }
         else
         {
            this.onApisHooksActionsList(param1.details);
         }
         this.sysApi.addHook(ApisHooksActionsList,this.onApisHooksActionsList);
         this.btn_accept.visible = this.btn_refuse.visible = !this._module.trusted && param1.visibleBtns;
         this.btn_close.visible = !this.btn_refuse.visible;
         this.btn_activateModule.visible = this.btn_refuse.visible;
         this.lbl_title.visible = this.btn_refuse.visible;
         if(!this.btn_accept.visible)
         {
            this.tx_bg.height = this.tx_bg.height - 40;
         }
         this._isUpdate = param1.isUpdate;
         if(this._isUpdate)
         {
            this.lbl_title.text = this.uiApi.getText("ui.module.marketplace.confirmationupdate");
            this.btn_activateModule.visible = false;
         }
         this.uiApi.addComponentHook(this.btn_activateModule,ComponentHookList.ON_RELEASE);
      }
      
      private function onApisHooksActionsList(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:* = "";
         if(!this._module.trusted && param1.useNetwork)
         {
            _loc2_ = _loc2_ + ("<p><i>" + this.uiApi.getText("ui.module.marketplace.usenetwork") + "</i></p><br>");
         }
         if(param1.actions.length)
         {
            _loc2_ = _loc2_ + ("<p><b>Actions</b><br>" + this.uiApi.getText("ui.module.marketplace.actions") + this.uiApi.getText("ui.common.colon") + "<ul>");
            for each(_loc3_ in param1.actions)
            {
               if(_loc3_ != "IAction")
               {
                  _loc4_ = this.dataApi.getActionDescriptionByName(_loc3_).description;
                  if(_loc4_)
                  {
                     if(_loc4_.charAt(_loc4_.length - 1) == ".")
                     {
                        _loc4_ = _loc4_.slice(0,-1);
                     }
                     _loc2_ = _loc2_ + ("<li>" + _loc4_ + "</li>");
                  }
                  else
                  {
                     _loc2_ = _loc2_ + ("<li>" + _loc3_ + "</li>");
                  }
               }
            }
            _loc2_ = _loc2_ + "</ul></p>";
         }
         if(param1.apis.length)
         {
            _loc2_ = _loc2_ + ("<p><b>APIs</b><br>" + this.uiApi.getText("ui.module.marketplace.apis") + this.uiApi.getText("ui.common.colon") + "<ul>");
            for each(_loc3_ in param1.apis)
            {
               _loc2_ = _loc2_ + ("<li>" + _loc3_ + "</li>");
            }
            _loc2_ = _loc2_ + "</ul></p>";
         }
         if(param1.hooks.length)
         {
            _loc2_ = _loc2_ + ("<p><b>" + this.uiApi.getText("ui.common.events") + "</b><br>" + this.uiApi.getText("ui.module.marketplace.events") + this.uiApi.getText("ui.common.colon") + "<ul>");
            for each(_loc3_ in param1.hooks)
            {
               _loc2_ = _loc2_ + ("<li>" + _loc3_ + "</li>");
            }
            _loc2_ = _loc2_ + "</ul></p>";
         }
         this.ta_details.appendText(_loc2_);
      }
      
      private function showModuleDetails(param1:Object) : void
      {
         this.lbl_moduleName.text = param1.name;
         this.lbl_moduleAuthor.text = param1.author;
         this.lbl_moduleVersion.text = this.uiApi.getText("ui.common.version") + this.uiApi.getText("ui.common.colon") + param1.version;
         this.lbl_moduleDofusVersion.text = this.uiApi.getText("ui.module.marketplace.dofusversion",param1.dofusVersion);
         this.lbl_moduleDescription.text = this.uiApi.getText("ui.common.description") + this.uiApi.getText("ui.common.colon") + "\n" + param1.description;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_accept:
               if(this.btn_activateModule.selected)
               {
                  this._confirmActivationCallback();
               }
               this.sysApi.sendAction(new ModuleInstallConfirm(this._isUpdate));
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_refuse:
               this.sysApi.sendAction(new ModuleInstallCancel());
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
   }
}
