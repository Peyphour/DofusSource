package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.PrismSettingsRequest;
   import d2enums.CompassTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.PrismStateEnum;
   import d2hooks.AddMapFlag;
   import d2hooks.PrismsListUpdate;
   import flash.utils.Dictionary;
   
   public class AllianceAreas
   {
      
      private static const SERVER_CONST_KOH_DURATION:int = 2;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var configApi:ConfigApi;
      
      public var mapApi:MapApi;
      
      public var utilApi:UtilApi;
      
      private var _prismsList:Array;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _compHookData:Dictionary;
      
      private var _assetsPath:String;
      
      private var _txtHours:Array;
      
      private var _txtMinutes:Array;
      
      private var _quartersNumber:uint;
      
      private var _subAreaBeingModified:int = -1;
      
      private var _forceShowPrismId:int;
      
      private var _moduleTypeIdToDisplay:int = 0;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_setHour:GraphicContainer;
      
      public var gd_subAreas:Grid;
      
      public var btn_tabType:ButtonContainer;
      
      public var btn_tabSubArea:ButtonContainer;
      
      public var btn_tabCoord:ButtonContainer;
      
      public var btn_tabModules:ButtonContainer;
      
      public var btn_tabNuggets:ButtonContainer;
      
      public var btn_tabState:ButtonContainer;
      
      public var btn_tabVulneHour:ButtonContainer;
      
      public var lbl_conquestInfo:Label;
      
      public var cb_moduleTypes:ComboBox;
      
      public var lbl_prismArea:Label;
      
      public var lbl_explanationHour:Label;
      
      public var cb_hours:ComboBox;
      
      public var cb_minutes:ComboBox;
      
      public var btn_close:ButtonContainer;
      
      public var btn_save:ButtonContainer;
      
      public var btn_undo:ButtonContainer;
      
      public function AllianceAreas()
      {
         this._compHookData = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         var _loc3_:ItemWrapper = null;
         var _loc4_:Boolean = false;
         var _loc6_:PrismSubAreaWrapper = null;
         var _loc7_:int = 0;
         var _loc8_:ObjectItem = null;
         var _loc9_:* = undefined;
         this.sysApi.addHook(PrismsListUpdate,this.onPrismsListUpdate);
         this.uiApi.addComponentHook(this.cb_moduleTypes,ComponentHookList.ON_SELECT_ITEM);
         this._assetsPath = this.uiApi.me().getConstant("texture");
         this._txtHours = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"];
         this._txtMinutes = ["00","30"];
         this.cb_hours.dataNameField = "";
         this.cb_hours.dataProvider = this._txtHours;
         this.cb_minutes.dataNameField = "";
         this.cb_minutes.dataProvider = this._txtMinutes;
         this._prismsList = new Array();
         var _loc2_:Array = new Array();
         var _loc5_:Object = this.socialApi.getAlliance().prismIds;
         _loc2_.push({
            "id":0,
            "label":this.uiApi.getText("ui.common.all")
         });
         for each(_loc7_ in _loc5_)
         {
            _loc6_ = this.socialApi.getPrismSubAreaById(_loc7_);
            this._prismsList.push(_loc6_);
            for each(_loc8_ in _loc6_.modulesObjects)
            {
               _loc3_ = this.dataApi.getItemWrapper(_loc8_.objectGID,0,0,1);
               _loc4_ = false;
               for each(_loc9_ in _loc2_)
               {
                  if(_loc9_.label == _loc3_.name)
                  {
                     _loc4_ = true;
                  }
               }
               if(!_loc4_)
               {
                  _loc2_.push({
                     "id":_loc8_.objectGID,
                     "label":_loc3_.name
                  });
               }
            }
         }
         this.cb_moduleTypes.dataProvider = _loc2_;
         this.cb_moduleTypes.value = this.cb_moduleTypes.dataProvider[0];
         if(rest)
         {
            this._forceShowPrismId = rest[0];
         }
         else
         {
            this._forceShowPrismId = -1;
         }
         this.updateSubAreas();
      }
      
      public function unload() : void
      {
      }
      
      public function updateSubAreaLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(!this._compHookData[param2.lbl_subArea.name])
         {
            this.uiApi.addComponentHook(param2.lbl_subArea,"onRollOver");
            this.uiApi.addComponentHook(param2.lbl_subArea,"onRollOut");
         }
         this._compHookData[param2.lbl_subArea.name] = param1;
         if(!this._compHookData[param2.tx_type.name])
         {
            this.uiApi.addComponentHook(param2.tx_type,"onRollOver");
            this.uiApi.addComponentHook(param2.tx_type,"onRollOut");
         }
         this._compHookData[param2.tx_type.name] = param1;
         if(!this._compHookData[param2.lbl_vulneHour.name])
         {
            this.uiApi.addComponentHook(param2.lbl_vulneHour,"onRollOver");
            this.uiApi.addComponentHook(param2.lbl_vulneHour,"onRollOut");
         }
         this._compHookData[param2.lbl_vulneHour.name] = param1;
         if(!this._compHookData[param2.tx_module.name])
         {
            this.uiApi.addComponentHook(param2.tx_module,"onRollOver");
            this.uiApi.addComponentHook(param2.tx_module,"onRollOut");
         }
         this._compHookData[param2.tx_module.name] = param1;
         if(!this._compHookData[param2.lbl_state.name])
         {
            this.uiApi.addComponentHook(param2.lbl_state,"onRollOver");
            this.uiApi.addComponentHook(param2.lbl_state,"onRollOut");
         }
         this._compHookData[param2.lbl_state.name] = param1;
         if(!this._compHookData[param2.lbl_coord.name])
         {
            this.uiApi.addComponentHook(param2.lbl_coord,"onRelease");
         }
         this._compHookData[param2.lbl_coord.name] = param1;
         if(param1)
         {
            if(param1.isVillage)
            {
               param2.tx_type.uri = this.uiApi.createUri(this._assetsPath + "tx_conquestVillage.png");
            }
            else
            {
               param2.tx_type.uri = this.uiApi.createUri(this._assetsPath + "tx_conquestPrism.png");
            }
            param2.lbl_subArea.text = param1.subAreaName;
            param2.lbl_coord.text = param1.worldX + "," + param1.worldY;
            param2.lbl_coord.mouseEnabled = true;
            param2.lbl_coord.handCursor = true;
            param2.lbl_nuggets.text = this.utilApi.kamasToString(param1.rewardTokenCount,"");
            if(param1.modulesObjects.length > 0)
            {
               param2.tx_module.visible = true;
            }
            else
            {
               param2.tx_module.visible = false;
            }
            param2.lbl_state.text = this.uiApi.getText("ui.prism.state" + param1.state);
            _loc4_ = param1.timeSlotHour.toString();
            if(_loc4_.length == 1)
            {
               _loc4_ = "0" + _loc4_;
            }
            _loc5_ = (param1.timeSlotQuarter * 15).toString();
            if(_loc5_.length == 1)
            {
               _loc5_ = "0" + _loc5_;
            }
            param2.lbl_vulneHour.text = _loc4_ + ":" + _loc5_;
            if((param1.state == PrismStateEnum.PRISM_STATE_INVULNERABLE || param1.state == PrismStateEnum.PRISM_STATE_NORMAL) && this.socialApi.hasGuildRight(this.playerApi.id(),"setAlliancePrism"))
            {
               param2.btn_setHour.visible = true;
               if(!this._compHookData[param2.btn_setHour.name])
               {
                  this.uiApi.addComponentHook(param2.btn_setHour,ComponentHookList.ON_RELEASE);
                  this.uiApi.addComponentHook(param2.btn_setHour,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.btn_setHour,ComponentHookList.ON_ROLL_OUT);
               }
               this._compHookData[param2.btn_setHour.name] = param1;
            }
            else
            {
               param2.btn_setHour.visible = false;
            }
            if(param1.subAreaId == this._forceShowPrismId)
            {
               param2.ctr_line.bgColor = this.sysApi.getConfigEntry("colors.grid.over");
            }
            else
            {
               param2.ctr_line.bgColor = -1;
            }
         }
         else
         {
            param2.tx_type.uri = null;
            param2.lbl_subArea.text = "";
            param2.lbl_coord.text = "";
            param2.lbl_nuggets.text = "";
            param2.lbl_state.text = "";
            param2.lbl_vulneHour.text = "";
            param2.ctr_line.bgColor = -1;
            param2.tx_module.visible = false;
            param2.btn_setHour.visible = false;
         }
      }
      
      private function updateSubAreas() : void
      {
         var _loc4_:PrismSubAreaWrapper = null;
         var _loc6_:ObjectItem = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = new Array();
         for each(_loc4_ in this._prismsList)
         {
            if(_loc4_.mapId > -1)
            {
               if(_loc4_.isVillage)
               {
                  _loc2_++;
               }
               else
               {
                  _loc1_++;
               }
            }
            if(_loc4_)
            {
               if(this._moduleTypeIdToDisplay == 0)
               {
                  _loc3_.push(_loc4_);
               }
               else if(_loc4_.modulesObjects && _loc4_.modulesObjects.length > 0)
               {
                  for each(_loc6_ in _loc4_.modulesObjects)
                  {
                     if(_loc6_.objectGID == this._moduleTypeIdToDisplay)
                     {
                        _loc3_.push(_loc4_);
                     }
                  }
               }
            }
         }
         if(_loc1_ == 0 && _loc2_ == 0)
         {
            this.lbl_conquestInfo.text = this.uiApi.getText("ui.alliance.noArea");
         }
         else if(_loc1_ > 0 && _loc2_ == 0)
         {
            this.lbl_conquestInfo.text = this.uiApi.processText(this.uiApi.getText("ui.alliance.nbAreas",_loc1_),"m",_loc1_ == 1);
         }
         else if(_loc1_ == 0 && _loc2_ > 0)
         {
            this.lbl_conquestInfo.text = this.uiApi.processText(this.uiApi.getText("ui.alliance.nbVillages",_loc2_),"m",_loc2_ == 1);
         }
         else
         {
            this.lbl_conquestInfo.text = this.uiApi.processText(this.uiApi.getText("ui.alliance.nbAreasAndVillages",_loc1_,_loc2_),"m",_loc2_ == 1 && _loc1_ == 1);
         }
         this.gd_subAreas.dataProvider = _loc3_;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(this._forceShowPrismId == _loc3_[_loc5_].subAreaId)
            {
               this.gd_subAreas.moveTo(_loc5_,true);
               return;
            }
            _loc5_++;
         }
      }
      
      private function setHour(param1:Object) : void
      {
         this.ctr_setHour.visible = true;
         this._subAreaBeingModified = param1.subAreaId;
         var _loc2_:String = param1.timeSlotHour.toString();
         if(_loc2_.length == 1)
         {
            _loc2_ = "0" + _loc2_;
         }
         var _loc3_:String = (param1.timeSlotQuarter * 15).toString();
         if(_loc3_.length == 1)
         {
            _loc3_ = "0" + _loc3_;
         }
         var _loc4_:Number = this.configApi.getServerConstant(SERVER_CONST_KOH_DURATION) as Number;
         this.lbl_prismArea.text = param1.subAreaName;
         this.lbl_explanationHour.text = this.uiApi.getText("ui.prism.vulnerabilityHourInfos",_loc4_ / 1000 / 3600,_loc2_,_loc3_);
         var _loc5_:int = this._txtHours.indexOf(_loc2_);
         if(_loc5_ == -1)
         {
            _loc5_ = 0;
         }
         this.cb_hours.value = this._txtHours[_loc5_];
         _loc5_ = this._txtMinutes.indexOf(_loc3_);
         if(_loc5_ == -1)
         {
            _loc5_ = 0;
         }
         this.cb_minutes.value = this._txtMinutes[_loc5_];
      }
      
      private function onPrismsListUpdate(param1:Object) : void
      {
         var _loc2_:PrismSubAreaWrapper = null;
         var _loc3_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:PrismSubAreaWrapper = null;
         var _loc4_:int = this.socialApi.getAlliance().allianceId;
         for each(_loc5_ in param1)
         {
            _loc2_ = this.socialApi.getPrismSubAreaById(_loc5_);
            if(_loc2_.alliance.allianceId == _loc4_)
            {
               _loc3_ = false;
               for each(_loc6_ in this._prismsList)
               {
                  if(_loc6_.subAreaId == _loc5_)
                  {
                     _loc6_ = _loc2_;
                     _loc3_ = true;
                  }
               }
               if(!_loc3_)
               {
                  this._prismsList.push(_loc2_);
               }
            }
         }
         this.updateSubAreas();
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.sysApi.log(2,"release sur " + param1.name);
         switch(param1)
         {
            case this.btn_tabType:
               if(this._bDescendingSort)
               {
                  this.gd_subAreas.sortOn("isVillage",Array.NUMERIC);
               }
               else
               {
                  this.gd_subAreas.sortOn("isVillage",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabSubArea:
               if(this._bDescendingSort)
               {
                  this.gd_subAreas.sortOn("subAreaName",Array.CASEINSENSITIVE);
               }
               else
               {
                  this.gd_subAreas.sortOn("subAreaName",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabCoord:
               if(this._bDescendingSort)
               {
                  this.gd_subAreas.sortOn("worldX",Array.NUMERIC);
               }
               else
               {
                  this.gd_subAreas.sortOn("worldX",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabModules:
               if(this._bDescendingSort)
               {
                  this.gd_subAreas.sortOn("modulesObjects");
               }
               else
               {
                  this.gd_subAreas.sortOn("modulesObjects",Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabNuggets:
               this.sysApi.log(2,"btn_tabNuggets " + this._bDescendingSort);
               if(this._bDescendingSort)
               {
                  this.gd_subAreas.sortOn("rewardTokenCount",Array.NUMERIC);
               }
               else
               {
                  this.gd_subAreas.sortOn("rewardTokenCount",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabState:
               if(this._bDescendingSort)
               {
                  this.gd_subAreas.sortOn("state",Array.NUMERIC);
               }
               else
               {
                  this.gd_subAreas.sortOn("state",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabVulneHour:
               if(this._bDescendingSort)
               {
                  this.gd_subAreas.sortOn("nextVulnerabilityDate",Array.NUMERIC);
               }
               else
               {
                  this.gd_subAreas.sortOn("nextVulnerabilityDate",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_close:
            case this.btn_undo:
               this.ctr_setHour.visible = false;
               this._subAreaBeingModified = -1;
               break;
            case this.btn_save:
               _loc2_ = this.timeApi.getTimezoneOffset();
               _loc3_ = _loc2_ / 1000 * 60 % 60;
               _loc4_ = _loc2_ / (1000 * 60 * 60) % 24;
               _loc5_ = (this.cb_hours.selectedIndex - _loc4_) * 4 + (this.cb_minutes.selectedIndex - _loc3_) * 2;
               if(_loc5_ < 0)
               {
                  _loc5_ = _loc5_ + 96;
               }
               this._quartersNumber = _loc5_;
               if(this._subAreaBeingModified > -1)
               {
                  this.sysApi.sendAction(new PrismSettingsRequest(this._subAreaBeingModified,this._quartersNumber));
               }
               this.ctr_setHour.visible = false;
               this._subAreaBeingModified = -1;
               break;
            default:
               if(param1.name.indexOf("lbl_coord") != -1)
               {
                  _loc6_ = this._compHookData[param1.name];
                  _loc7_ = _loc6_.worldX;
                  _loc8_ = _loc6_.worldY;
                  this.sysApi.dispatchHook(AddMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_PVP_SEEK + "_pos_" + _loc7_ + "_" + _loc8_,_loc7_ + "," + _loc8_ + " (" + this.uiApi.getText("ui.zaap.prism") + ")",this.mapApi.getCurrentWorldMap().id,_loc7_,_loc8_,16711680,true);
               }
               else if(param1.name.indexOf("btn_setHour") != -1)
               {
                  _loc6_ = this._compHookData[param1.name];
                  this.setHour(_loc6_);
               }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.cb_moduleTypes:
               this._moduleTypeIdToDisplay = this.cb_moduleTypes.selectedItem.id;
               this.updateSubAreas();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:PrismSubAreaWrapper = null;
         var _loc6_:Date = null;
         var _loc7_:Boolean = false;
         var _loc8_:Date = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:Number = NaN;
         var _loc14_:ItemWrapper = null;
         var _loc15_:ObjectItem = null;
         var _loc2_:uint = 7;
         var _loc3_:uint = 1;
         if(param1.name.indexOf("tx_type") != -1)
         {
            _loc7_ = this._compHookData[param1.name].isVillage;
            if(_loc7_)
            {
               _loc4_ = this.uiApi.getText("ui.zaap.village");
            }
            else
            {
               _loc4_ = this.uiApi.getText("ui.zaap.prism");
            }
         }
         else if(param1.name.indexOf("btn_setHour") != -1)
         {
            _loc4_ = this.uiApi.getText("ui.prism.changeVulnerabilityHour");
         }
         else if(param1.name.indexOf("lbl_vulneHour") != -1)
         {
            _loc5_ = this._compHookData[param1.name];
            if(!_loc5_ || _loc5_.lastTimeSlotModificationAuthorName == "?" && _loc5_.lastTimeSlotModificationAuthorGuildId == 0)
            {
               return;
            }
            if(!this.socialApi.getGuildByid(_loc5_.lastTimeSlotModificationAuthorGuildId) || !this.socialApi.getGuildByid(_loc5_.lastTimeSlotModificationAuthorGuildId).guildName)
            {
               _loc4_ = this.uiApi.getText("ui.prism.lastVulnerabilityChange",this.timeApi.getDate(_loc5_.lastTimeSlotModificationDate * 1000,true));
            }
            else
            {
               _loc4_ = this.uiApi.getText("ui.prism.lastVulnerabilityChangeBy",this.timeApi.getDate(_loc5_.lastTimeSlotModificationDate * 1000,true),_loc5_.lastTimeSlotModificationAuthorName,this.socialApi.getGuildByid(_loc5_.lastTimeSlotModificationAuthorGuildId).guildName);
            }
            _loc6_ = new Date(_loc5_.nextVulnerabilityDate * 1000 + this.timeApi.getTimezoneOffset());
            _loc8_ = new Date(_loc5_.nextVulnerabilityDate * 1000);
            _loc9_ = _loc6_.getUTCHours().toString();
            if(_loc9_.length == 1)
            {
               _loc9_ = "0" + _loc9_;
            }
            _loc10_ = _loc6_.getUTCMinutes().toString();
            if(_loc10_.length == 1)
            {
               _loc10_ = "0" + _loc10_;
            }
            _loc11_ = _loc8_.getHours().toString();
            if(_loc11_.length == 1)
            {
               _loc11_ = "0" + _loc11_;
            }
            _loc12_ = _loc8_.getMinutes().toString();
            if(_loc12_.length == 1)
            {
               _loc12_ = "0" + _loc12_;
            }
            _loc4_ = _loc4_ + ("\n" + this.uiApi.getText("ui.prism.serverVulnerabilityHour") + this.uiApi.getText("ui.common.colon") + _loc9_ + ":" + _loc10_);
            _loc4_ = _loc4_ + ("\n" + this.uiApi.getText("ui.prism.localVulnerabilityHour") + this.uiApi.getText("ui.common.colon") + _loc11_ + ":" + _loc12_);
         }
         else if(param1.name.indexOf("lbl_state") != -1)
         {
            _loc5_ = this._compHookData[param1.name];
            if(_loc5_)
            {
               _loc6_ = new Date();
               _loc13_ = _loc5_.nextVulnerabilityDate * 1000 - _loc6_.time;
               if(_loc5_.state == PrismStateEnum.PRISM_STATE_WEAKENED || _loc5_.state == PrismStateEnum.PRISM_STATE_SABOTAGED)
               {
                  _loc4_ = this.uiApi.getText("ui.prism.stateInfos" + _loc5_.state,this.timeApi.getDuration(_loc13_));
               }
               else
               {
                  _loc4_ = this.uiApi.getText("ui.prism.stateInfos" + _loc5_.state);
               }
            }
         }
         else if(param1.name.indexOf("tx_module") != -1)
         {
            _loc5_ = this._compHookData[param1.name];
            if(_loc5_ && _loc5_.modulesObjects.length > 0)
            {
               _loc4_ = "";
               for each(_loc15_ in _loc5_.modulesObjects)
               {
                  _loc14_ = this.dataApi.getItemWrapper(_loc15_.objectGID,0,0,1);
                  _loc4_ = _loc4_ + (_loc14_.name + "\n");
               }
               _loc4_ = _loc4_.substr(0,_loc4_.length - 1);
            }
         }
         else if(param1.name.indexOf("lbl_subArea") != -1)
         {
            _loc5_ = this._compHookData[param1.name];
            if(_loc5_)
            {
               _loc4_ = this.uiApi.getText("ui.social.guild.taxStartDate") + this.uiApi.getText("ui.common.colon") + this.timeApi.getDate(_loc5_.placementDate * 1000);
            }
         }
         if(_loc4_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc4_),param1,false,"standard",_loc2_,_loc3_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
