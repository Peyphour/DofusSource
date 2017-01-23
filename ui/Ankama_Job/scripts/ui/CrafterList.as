package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.AlignementSideEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.JobCrafterDirectoryListRequest;
   import d2actions.LeaveDialogRequest;
   import d2enums.ComponentHookList;
   import d2enums.PlayerStatusEnum;
   import d2hooks.ChatFocus;
   import d2hooks.CrafterDirectoryListUpdate;
   import flash.utils.Dictionary;
   
   public class CrafterList
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var jobsApi:JobsApi;
      
      public var soundApi:SoundApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _sortCriteria:String;
      
      private var _crafters:Array;
      
      private var _jobs:Array;
      
      private var _sCraftersText:String;
      
      private var _sChooseJobText:String;
      
      private var _iconsPath:String;
      
      private var _gridComponentsList:Dictionary;
      
      public var combo_job:ComboBox;
      
      public var gd_crafters:Grid;
      
      public var lbl_nbCrafter:Label;
      
      public var lbl_job:Label;
      
      public var btn_tabAli:ButtonContainer;
      
      public var btn_tabBreed:ButtonContainer;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabLevel:ButtonContainer;
      
      public var btn_tabCoord:ButtonContainer;
      
      public var btn_tabCost:ButtonContainer;
      
      public var btn_tabMinLevel:ButtonContainer;
      
      public var btn_search:Object;
      
      public var btn_close:ButtonContainer;
      
      public var bgcombo_job:TextureBitmap;
      
      public function CrafterList()
      {
         this._gridComponentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Array) : void
      {
         var _loc3_:* = undefined;
         this.soundApi.playSound(SoundTypeEnum.GRIMOIRE_OPEN);
         this.sysApi.addHook(CrafterDirectoryListUpdate,this.onCrafterDirectoryListUpdate);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_tabCoord,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_tabCoord,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_tabCost,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_tabCost,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_tabMinLevel,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_tabMinLevel,ComponentHookList.ON_ROLL_OUT);
         this._sChooseJobText = this.uiApi.getText("ui.craft.chooseJob");
         this._sCraftersText = this.uiApi.getText("ui.craft.crafters");
         this._iconsPath = this.uiApi.me().getConstant("icons_uri");
         this.gd_crafters.dataProvider = new Array();
         this._sortCriteria = "jobLevel";
         this._jobs = new Array();
         var _loc2_:Array = new Array();
         if(param1.length > 1)
         {
            _loc2_.push(this._sChooseJobText);
            for each(_loc3_ in param1)
            {
               _loc2_.push(this.jobsApi.getJobName(_loc3_));
               this._jobs.push(_loc3_);
            }
            this.combo_job.dataProvider = _loc2_;
            this.combo_job.value = _loc2_[0];
            this.lbl_job.visible = false;
            this.bgcombo_job.visible = true;
         }
         else
         {
            this.sysApi.sendAction(new JobCrafterDirectoryListRequest(param1[0]));
            this.lbl_job.text = this.jobsApi.getJobName(param1[0]);
            this.combo_job.visible = this.bgcombo_job.visible = false;
         }
      }
      
      public function unload() : void
      {
         this.sysApi.sendAction(new LeaveDialogRequest());
         this.soundApi.playSound(SoundTypeEnum.GRIMOIRE_CLOSE);
      }
      
      public function updateCrafterLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:SubArea = null;
         var _loc5_:String = null;
         if(param1)
         {
            if(!this._gridComponentsList[param2.tx_loc.name])
            {
               this.uiApi.addComponentHook(param2.tx_loc,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_loc,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.tx_loc,ComponentHookList.ON_RIGHT_CLICK);
            }
            this._gridComponentsList[param2.tx_loc.name] = param1;
            if(!this._gridComponentsList[param2.tx_status.name])
            {
               this.uiApi.addComponentHook(param2.tx_status,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_status,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.tx_status.name] = param1;
            if(!this._gridComponentsList[param2.btn_more.name])
            {
               this.uiApi.addComponentHook(param2.btn_more,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.btn_more,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.btn_more,ComponentHookList.ON_RELEASE);
            }
            this._gridComponentsList[param2.btn_more.name] = param1;
            param2.lbl_name.text = "{player," + param1.playerName + "," + param1.playerId + "::" + param1.playerName + "}";
            param2.lbl_job.text = this.jobsApi.getJobName(param1.jobId);
            param2.lbl_level.text = param1.jobLevel;
            param2.tx_status.visible = true;
            switch(param1.statusId)
            {
               case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                  param2.tx_status.uri = this.uiApi.createUri(this._iconsPath + "green.png");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_AFK:
               case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                  param2.tx_status.uri = this.uiApi.createUri(this._iconsPath + "yellow.png");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_PRIVATE:
                  param2.tx_status.uri = this.uiApi.createUri(this._iconsPath + "blue.png");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_SOLO:
                  param2.tx_status.uri = this.uiApi.createUri(this._iconsPath + "red.png");
            }
            param2.tx_head.uri = this.uiApi.createUri(this.uiApi.me().getConstant("heads") + param1.breed + "" + (!!param1.sex?"0":"1") + ".png");
            switch(param1.alignmentSide)
            {
               case AlignementSideEnum.ALIGNMENT_ANGEL:
                  param2.tx_alignment.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "tx_alignement_bonta.png");
                  break;
               case AlignementSideEnum.ALIGNMENT_EVIL:
                  param2.tx_alignment.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "tx_alignement_brakmar.png");
                  break;
               default:
                  param2.tx_alignment.uri = null;
            }
            param2.btn_more.visible = true;
            if(!param1.isInWorkshop)
            {
               param2.lbl_loc.text = "-";
            }
            else
            {
               _loc4_ = this.dataApi.getSubArea(param1.subAreaId);
               _loc5_ = this.dataApi.getArea(_loc4_.areaId).name + " " + param1.worldPos;
               param2.lbl_loc.text = _loc5_;
            }
            if(param1.freeCraft)
            {
               param2.tx_notFree.visible = false;
            }
            else
            {
               param2.tx_notFree.visible = true;
            }
            param2.lbl_lvlMin.text = param1.minLevelCraft;
         }
         else
         {
            param2.lbl_name.text = "";
            param2.lbl_level.text = "";
            param2.lbl_loc.text = "";
            param2.lbl_lvlMin.text = "";
            param2.tx_notFree.visible = false;
            param2.tx_alignment.uri = null;
            param2.tx_head.uri = null;
            param2.btn_more.visible = false;
            param2.tx_status.visible = false;
            param2.lbl_job.text = "";
         }
      }
      
      private function sortCrafters() : void
      {
         if(!this._crafters || this._crafters.length < 1)
         {
            return;
         }
         if(this._crafters.length == 1)
         {
            this.gd_crafters.dataProvider = this._crafters;
            return;
         }
         switch(this._sortCriteria)
         {
            case "alignmentSide":
            case "breed":
            case "jobLevel":
            case "minLevelCraft":
               if(this._bDescendingSort)
               {
                  this._crafters.sortOn(this._sortCriteria,Array.NUMERIC);
               }
               else
               {
                  this._crafters.sortOn(this._sortCriteria,Array.NUMERIC | Array.DESCENDING);
               }
               break;
            case "playerName":
               if(this._bDescendingSort)
               {
                  this._crafters.sortOn("playerName",Array.CASEINSENSITIVE);
               }
               else
               {
                  this._crafters.sortOn("playerName",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               break;
            case "freeCraft":
            case "worldPos":
               if(this._bDescendingSort)
               {
                  this._crafters.sortOn(this._sortCriteria);
               }
               else
               {
                  this._crafters.sortOn(this._sortCriteria,Array.DESCENDING);
               }
         }
         this.gd_crafters.dataProvider = this._crafters;
      }
      
      public function onCrafterDirectoryListUpdate(param1:Object) : void
      {
         var _loc2_:* = undefined;
         this._crafters = new Array();
         for each(_loc2_ in param1)
         {
            this._crafters.push(_loc2_);
         }
         this.sortCrafters();
         this.lbl_nbCrafter.text = this._crafters.length + " " + this._sCraftersText;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_search:
               break;
            case this.btn_tabAli:
               if(this._sortCriteria == "alignmentSide")
               {
                  this._bDescendingSort = !this._bDescendingSort;
               }
               this._sortCriteria = "alignmentSide";
               this.sortCrafters();
               break;
            case this.btn_tabBreed:
               if(this._sortCriteria == "breed")
               {
                  this._bDescendingSort = !this._bDescendingSort;
               }
               this._sortCriteria = "breed";
               this.sortCrafters();
               break;
            case this.btn_tabName:
               if(this._sortCriteria == "playerName")
               {
                  this._bDescendingSort = !this._bDescendingSort;
               }
               this._sortCriteria = "playerName";
               this.sortCrafters();
               break;
            case this.btn_tabLevel:
               if(this._sortCriteria == "jobLevel")
               {
                  this._bDescendingSort = !this._bDescendingSort;
               }
               this._sortCriteria = "jobLevel";
               this.sortCrafters();
               break;
            case this.btn_tabCost:
               if(this._sortCriteria == "freeCraft")
               {
                  this._bDescendingSort = !this._bDescendingSort;
               }
               this._sortCriteria = "freeCraft";
               this.sortCrafters();
               break;
            case this.btn_tabCoord:
               if(this._sortCriteria == "worldPos")
               {
                  this._bDescendingSort = !this._bDescendingSort;
               }
               this._sortCriteria = "worldPos";
               this.sortCrafters();
               break;
            case this.btn_tabMinLevel:
               if(this._sortCriteria == "minLevelCraft")
               {
                  this._bDescendingSort = !this._bDescendingSort;
               }
               this._sortCriteria = "minLevelCraft";
               this.sortCrafters();
         }
         if(param1.name.indexOf("btn_more") == 0)
         {
            _loc2_ = this._gridComponentsList[param1.name];
            this.sysApi.dispatchHook(ChatFocus,_loc2_.playerName);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:SubArea = null;
         var _loc5_:* = null;
         if(param1 == this.btn_tabCoord)
         {
            _loc2_ = this.uiApi.getText("ui.craft.crafterWorkshopPosition");
         }
         else if(param1 == this.btn_tabMinLevel)
         {
            _loc2_ = this.uiApi.getText("ui.craft.minLevelCraft");
         }
         else if(param1 == this.btn_tabCost)
         {
            _loc2_ = this.uiApi.getText("ui.craft.notFree");
         }
         if(param1.name.indexOf("btn_more") == 0)
         {
            _loc2_ = this.uiApi.getText("ui.common.wisperMessage");
         }
         else if(param1.name.indexOf("tx_status") == 0)
         {
            _loc3_ = this._gridComponentsList[param1.name];
            switch(_loc3_.statusId)
            {
               case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                  _loc2_ = this.uiApi.getText("ui.chat.status.availiable");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                  _loc2_ = this.uiApi.getText("ui.chat.status.idle");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_AFK:
                  _loc2_ = this.uiApi.getText("ui.chat.status.away");
                  if(_loc3_.awayMessage != null)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.common.colon") + _loc3_.awayMessage);
                  }
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_PRIVATE:
                  _loc2_ = this.uiApi.getText("ui.chat.status.private");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_SOLO:
                  _loc2_ = this.uiApi.getText("ui.chat.status.solo");
            }
         }
         else if(param1.name.indexOf("tx_loc") == 0)
         {
            _loc3_ = this._gridComponentsList[param1.name];
            if(_loc3_.isInWorkshop)
            {
               _loc4_ = this.dataApi.getSubArea(_loc3_.subAreaId);
               _loc5_ = this.uiApi.getText("ui.craft.nearCraftTable") + " : " + this.dataApi.getArea(_loc4_.areaId).name + " ( " + _loc4_.name + " )";
               _loc2_ = _loc5_;
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
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:uint = 0;
         switch(param1)
         {
            case this.combo_job:
               if(this.combo_job.selectedIndex > 0)
               {
                  _loc4_ = this._jobs[this.combo_job.selectedIndex - 1];
                  this.sysApi.sendAction(new JobCrafterDirectoryListRequest(_loc4_));
               }
               else
               {
                  this.gd_crafters.dataProvider = new Array();
                  this.lbl_nbCrafter.text = "";
               }
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = this._gridComponentsList[param1.name];
         if(_loc2_)
         {
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
   }
}
