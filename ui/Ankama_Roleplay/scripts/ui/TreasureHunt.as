package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.internalDatacenter.quest.TreasureHuntStepWrapper;
   import com.ankamagames.dofus.internalDatacenter.quest.TreasureHuntWrapper;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.TreasureHuntDigRequest;
   import d2actions.TreasureHuntFlagRemoveRequest;
   import d2actions.TreasureHuntFlagRequest;
   import d2actions.TreasureHuntGiveUpRequest;
   import d2enums.BuildTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.TreasureHuntFlagStateEnum;
   import d2enums.TreasureHuntStepTypeEnum;
   import d2hooks.AddMapFlag;
   import d2hooks.FlagRemoved;
   import d2hooks.FoldAll;
   import d2hooks.RemoveMapFlag;
   import d2hooks.TreasureHuntAvailableRetryCountUpdate;
   import d2hooks.TreasureHuntFinished;
   import d2hooks.TreasureHuntUpdate;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class TreasureHunt
   {
      
      private static const NB_MAX_LINE:int = 9;
      
      private static var _shortcutColor:String;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var questApi:QuestApi;
      
      public var dataApi:DataApi;
      
      public var bindsApi:BindsApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _hidden:Boolean = true;
      
      private var _foldStatus:Boolean;
      
      private var _compHookData:Dictionary;
      
      private var _huntType:int = -1;
      
      private var _huntTypes:Array;
      
      private var _treasureHunts:Array;
      
      private var _txBgHeight:int;
      
      private var _tx_stepBgHeight:int;
      
      private var _ctrBottomY:int;
      
      private var _gdLineHeight:int;
      
      private var _ctrCurrentPosition:Point;
      
      private var _ctrLastPosition:Point;
      
      private var _ctrStartPosition:Point;
      
      private var _currentLocNames:Array;
      
      private var _flagColors:Array;
      
      private var _firstDisplay:Boolean;
      
      private var _maskVisible:Boolean = true;
      
      public var btn_arrowMinimize:ButtonContainer;
      
      public var btn_mask:ButtonContainer;
      
      public var tx_minMax:TextureBitmap;
      
      public var tx_chestIcon:TextureBitmap;
      
      public var ctr_hunt:GraphicContainer;
      
      public var ctr_instructions:GraphicContainer;
      
      public var ctr_bottom:GraphicContainer;
      
      public var tx_bg:TextureBitmap;
      
      public var tx_stepBg:Texture;
      
      public var tx_title:Texture;
      
      public var tx_help:TextureBitmap;
      
      public var btn_huntType:ButtonContainer;
      
      public var btn_giveUp:ButtonContainer;
      
      public var lbl_huntType:Label;
      
      public var lbl_steps:Label;
      
      public var lbl_try:Label;
      
      public var gd_steps:Grid;
      
      public function TreasureHunt()
      {
         this._compHookData = new Dictionary(true);
         this._huntTypes = new Array();
         this._treasureHunts = new Array();
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(FoldAll,this.onFoldAll);
         this.sysApi.addHook(TreasureHuntUpdate,this.onTreasureHunt);
         this.sysApi.addHook(TreasureHuntFinished,this.onTreasureHuntFinished);
         this.sysApi.addHook(TreasureHuntAvailableRetryCountUpdate,this.onTreasureHuntAvailableRetryCountUpdate);
         this.sysApi.addHook(FlagRemoved,this.onFlagRemoved);
         this.uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_giveUp,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_giveUp,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_arrowMinimize,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_arrowMinimize,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_arrowMinimize,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_title,ComponentHookList.ON_PRESS);
         this.uiApi.addComponentHook(this.tx_title,ComponentHookList.ON_RELEASE_OUTSIDE);
         this.uiApi.addComponentHook(this.tx_title,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_title,ComponentHookList.ON_DOUBLE_CLICK);
         this._flagColors = new Array();
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_UNKNOWN] = this.sysApi.getConfigEntry("colors.flag.unknown");
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_OK] = this.sysApi.getConfigEntry("colors.flag.right");
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_WRONG] = this.sysApi.getConfigEntry("colors.flag.wrong");
         this._currentLocNames = new Array();
         this._hidden = false;
         this.ctr_instructions.visible = true;
         this._huntType = param1 as int;
         this._huntTypes.push(this._huntType);
         this._currentLocNames[this._huntType] = "";
         this._treasureHunts[this._huntType] = this.questApi.getTreasureHunt(this._huntType);
         this._txBgHeight = this.tx_bg.height;
         this._tx_stepBgHeight = this.tx_stepBg.height;
         this._ctrBottomY = this.ctr_bottom.y;
         this._gdLineHeight = this.gd_steps.slotHeight;
         this._ctrCurrentPosition = new Point(this.ctr_hunt.x,this.ctr_hunt.y);
         this._ctrLastPosition = this._ctrCurrentPosition.clone();
         this._ctrStartPosition = this._ctrCurrentPosition.clone();
         this._firstDisplay = true;
         this.updateHuntDisplay(this._huntType,true);
         this._firstDisplay = false;
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function updateStepLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:TreasureHuntWrapper = null;
         if(!this._compHookData[param2.ctr_step.name])
         {
            this.uiApi.addComponentHook(param2.ctr_step,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_step,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.ctr_step.name] = param1;
         if(!this._compHookData[param2.btn_loc.name])
         {
            this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_RELEASE);
         }
         this._compHookData[param2.btn_loc.name] = param1;
         if(!this._compHookData[param2.btn_pictos.name])
         {
            this.uiApi.addComponentHook(param2.btn_pictos,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_pictos,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_pictos,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.btn_pictos.name] = param1;
         if(!this._compHookData[param2.btn_dig.name])
         {
            this.uiApi.addComponentHook(param2.btn_dig,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_dig,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_dig,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.btn_dig.name] = param1;
         if(!this._compHookData[param2.btn_digFight.name])
         {
            this.uiApi.addComponentHook(param2.btn_digFight,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_digFight,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_digFight,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.btn_digFight.name] = param1;
         if(!this._compHookData[param2.tx_flag.name])
         {
            this.uiApi.addComponentHook(param2.tx_flag,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.tx_flag,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_flag,ComponentHookList.ON_ROLL_OUT);
         }
         this._compHookData[param2.tx_flag.name] = param1;
         if(param1 != null)
         {
            param2.btn_digFight.visible = false;
            param2.lbl_text.text = param1.text;
            param2.btn_pictos.visible = false;
            if(param1.type == TreasureHuntStepTypeEnum.START)
            {
               param2.btn_loc.visible = true;
               param2.tx_direction.uri = null;
               param2.btn_dig.visible = false;
               param2.tx_flag.visible = false;
               if(this._currentLocNames[this._huntType] == "" && param2.btn_loc.selected)
               {
                  param2.btn_loc.selected = false;
               }
               else if(this._currentLocNames[this._huntType] != "" && !param2.btn_loc.selected)
               {
                  param2.btn_loc.selected = true;
               }
            }
            else if(param1.type == TreasureHuntStepTypeEnum.DIRECTION_TO_POI || param1.type == TreasureHuntStepTypeEnum.DIRECTION || param1.type == TreasureHuntStepTypeEnum.DIRECTION_TO_HINT)
            {
               param2.btn_loc.visible = false;
               param2.tx_direction.uri = this.uiApi.createUri(this.uiApi.me().getConstant("arrow_uri") + param1.direction + ".png");
               param2.btn_dig.visible = false;
               param2.tx_flag.visible = true;
               if(param1.mapId != 0)
               {
                  param2.tx_flag.uri = this.uiApi.createUri(this.uiApi.me().getConstant("flag_uri") + (param1.flagState + 2) + ".png");
               }
               else
               {
                  param2.tx_flag.uri = this.uiApi.createUri(this.uiApi.me().getConstant("flag_uri") + 1 + ".png");
               }
               if(this.sysApi.getBuildType() >= BuildTypeEnum.TESTING && param1.type == TreasureHuntStepTypeEnum.DIRECTION_TO_POI)
               {
                  param2.btn_pictos.visible = true;
               }
            }
            else if(param1.type == TreasureHuntStepTypeEnum.FIGHT)
            {
               param2.btn_loc.visible = false;
               param2.tx_direction.uri = null;
               param2.tx_flag.visible = false;
               _loc4_ = this._treasureHunts[this._huntType];
               if(_loc4_.checkPointCurrent + 1 != _loc4_.checkPointTotal)
               {
                  param2.btn_dig.visible = true;
                  param2.btn_digFight.visible = false;
               }
               else
               {
                  param2.btn_dig.visible = false;
                  param2.btn_digFight.visible = true;
               }
            }
            else if(param1.type == TreasureHuntStepTypeEnum.UNKNOWN)
            {
               param2.tx_direction.uri = null;
               param2.btn_loc.visible = false;
               param2.tx_flag.visible = false;
               param2.btn_dig.visible = false;
               param2.btn_digFight.visible = false;
            }
         }
         else
         {
            param2.lbl_text.text = "";
            param2.tx_direction.uri = null;
            param2.btn_loc.visible = false;
            param2.btn_pictos.visible = false;
            param2.btn_digFight.visible = false;
            param2.tx_flag.visible = false;
         }
      }
      
      private function showTypeMenu() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc1_:Array = new Array();
         _loc1_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.treasureHunt.type")));
         for each(_loc3_ in this._huntTypes)
         {
            if(this._huntType == _loc3_)
            {
               _loc2_ = true;
            }
            else
            {
               _loc2_ = false;
            }
            _loc1_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.treasureHunt.huntType" + _loc3_),this.updateHuntDisplay,[_loc3_],false,null,_loc2_,true));
         }
         this.modContextMenu.createContextMenu(_loc1_);
      }
      
      private function updateHuntDisplay(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:TreasureHuntStepWrapper = null;
         var _loc4_:String = null;
         var _loc5_:TreasureHuntWrapper = null;
         var _loc6_:* = false;
         var _loc7_:TreasureHuntWrapper = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:MapPosition = null;
         var _loc11_:* = null;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc14_:* = false;
         var _loc15_:int = 0;
         if(this._huntType != param1 || param2)
         {
            _loc5_ = this._treasureHunts[this._huntType];
            _loc6_ = this._currentLocNames[this._huntType] != "";
            if(_loc5_)
            {
               for each(_loc3_ in _loc5_.stepList)
               {
                  _loc4_ = _loc3_.type == TreasureHuntStepTypeEnum.START?"flag_teleportPoint_" + this._huntType + "_" + _loc3_.mapId:"flag_hunt_" + this._huntType + "_" + _loc3_.index;
                  this.sysApi.dispatchHook(RemoveMapFlag,_loc4_,this.dataApi.getMapInfo(_loc3_.mapId).worldMap);
               }
            }
            this._huntType = param1;
            this.lbl_huntType.text = this.uiApi.getText("ui.treasureHunt.huntType" + param1);
            this.btn_huntType.y = 10;
            this.btn_huntType.finalize();
            if(this._treasureHunts[this._huntType])
            {
               _loc7_ = this._treasureHunts[this._huntType];
               this.lbl_steps.text = this.uiApi.getText("ui.common.step",_loc7_.checkPointCurrent + 1,_loc7_.checkPointTotal);
               if(_loc7_.availableRetryCount == -1)
               {
                  this.lbl_try.text = this.uiApi.getText("ui.treasureHunt.infiniteTry");
               }
               else if(_loc7_.availableRetryCount > 0)
               {
                  this.lbl_try.text = this.uiApi.processText(this.uiApi.getText("ui.treasureHunt.tryLeft",_loc7_.availableRetryCount),"",_loc7_.availableRetryCount == 1);
               }
               _loc8_ = this.gd_steps.dataProvider.length;
               _loc9_ = _loc7_.stepList.length;
               if(_loc8_ != _loc9_)
               {
                  if(_loc9_ < NB_MAX_LINE)
                  {
                     _loc15_ = NB_MAX_LINE - _loc9_;
                     this.tx_bg.height = this._txBgHeight - _loc15_ * this._gdLineHeight;
                     this.tx_stepBg.height = this._tx_stepBgHeight - _loc15_ * this._gdLineHeight;
                     this.ctr_bottom.y = this._ctrBottomY - _loc15_ * this._gdLineHeight;
                     this.gd_steps.height = _loc9_ * this._gdLineHeight;
                     this.uiApi.me().render();
                  }
               }
               this.gd_steps.dataProvider = _loc7_.stepList;
               if(_loc7_.checkPointCurrent + 1 != _loc7_.checkPointTotal)
               {
                  this.lbl_try.visible = true;
                  this.btn_mask.x = 210;
                  this.btn_mask.y = 5;
               }
               else
               {
                  this.lbl_try.visible = false;
                  this.btn_mask.x = 250;
                  this.btn_mask.y = 0;
               }
               for each(_loc3_ in _loc7_.stepList)
               {
                  _loc10_ = this.dataApi.getMapInfo(_loc3_.mapId);
                  if(_loc10_.worldMap != -1)
                  {
                     _loc14_ = _loc3_.type == TreasureHuntStepTypeEnum.START;
                     if(_loc14_)
                     {
                        if(this._firstDisplay || !param2 || _loc6_)
                        {
                           _loc4_ = "flag_teleportPoint_" + this._huntType + "_" + _loc3_.mapId;
                           _loc11_ = this.uiApi.getText("ui.treasureHunt.huntType" + this._huntType) + " [" + _loc10_.posX + "," + _loc10_.posY + "]";
                           _loc12_ = 15636787;
                           this._currentLocNames[this._huntType] = _loc4_;
                           this.gd_steps.updateItem(0);
                        }
                        else
                        {
                           continue;
                        }
                     }
                     else
                     {
                        _loc13_ = _loc3_.index + 1;
                        _loc4_ = "flag_hunt_" + this._huntType + "_" + _loc13_;
                        _loc11_ = this.uiApi.getText("ui.treasureHunt.huntType" + this._huntType) + " - " + this.uiApi.getText("ui.treasureHunt.hint",_loc13_) + " [" + _loc10_.posX + "," + _loc10_.posY + "]";
                        _loc12_ = this._flagColors[_loc3_.flagState];
                     }
                     this.sysApi.dispatchHook(AddMapFlag,_loc4_,_loc11_,_loc10_.worldMap,_loc10_.posX,_loc10_.posY,_loc12_,!!_loc14_?true:false,false,!!_loc14_?true:false);
                  }
               }
            }
         }
      }
      
      private function stopDragUi() : void
      {
         this.ctr_hunt.stopDrag();
         var _loc1_:int = this.uiApi.getStageWidth();
         var _loc2_:int = this.uiApi.getStageHeight() - 150;
         if(this.ctr_hunt.x < 0)
         {
            this.ctr_hunt.x = 0;
         }
         else if(this.ctr_hunt.x + this.ctr_hunt.width > _loc1_)
         {
            this.ctr_hunt.x = _loc1_ - this.ctr_hunt.width;
         }
         if(this.ctr_hunt.y < 0)
         {
            this.ctr_hunt.y = 0;
         }
         else if(this.ctr_hunt.y + this.ctr_hunt.height > _loc2_)
         {
            this.ctr_hunt.y = _loc2_ - this.ctr_hunt.height;
         }
         this._ctrLastPosition.x = int(this.ctr_hunt.x);
         this._ctrLastPosition.y = int(this.ctr_hunt.y);
      }
      
      private function onTreasureHunt(param1:uint) : void
      {
         var _loc3_:MapPosition = null;
         var _loc2_:Object = this.questApi.getTreasureHunt(param1);
         if(this._treasureHunts[param1] && this._currentLocNames[param1] && this._currentLocNames[param1] != "" && this._treasureHunts[param1].checkPointCurrent != _loc2_.checkPointCurrent)
         {
            _loc3_ = this.dataApi.getMapInfo(this._treasureHunts[param1].stepList[0].mapId);
            this.sysApi.dispatchHook(RemoveMapFlag,this._currentLocNames[param1],_loc3_.worldMap);
            this._currentLocNames[param1] = "";
         }
         if(this._treasureHunts[param1] && this._treasureHunts[param1].checkPointCurrent != _loc2_.checkPointCurrent)
         {
            this._firstDisplay = true;
         }
         this._treasureHunts[param1] = _loc2_;
         if(this._huntTypes.indexOf(param1) == -1)
         {
            this._huntTypes.push(param1);
            this._currentLocNames[param1] = "";
         }
         this.updateHuntDisplay(param1,true);
         if(this._firstDisplay)
         {
            this._firstDisplay = false;
         }
      }
      
      private function onTreasureHuntFinished(param1:uint) : void
      {
         var _loc3_:TreasureHuntStepWrapper = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc2_:TreasureHuntWrapper = this._treasureHunts[param1];
         for each(_loc3_ in _loc2_.stepList)
         {
            _loc4_ = _loc3_.type == TreasureHuntStepTypeEnum.START?"flag_teleportPoint_" + param1 + "_" + _loc3_.mapId:"flag_hunt_" + param1 + "_" + _loc3_.index;
            this.sysApi.dispatchHook(RemoveMapFlag,_loc4_,this.dataApi.getMapInfo(_loc3_.mapId).worldMap);
         }
         this._currentLocNames[param1] = "";
         this._treasureHunts[param1] = null;
         delete this._treasureHunts[param1];
         _loc5_ = this._huntTypes.indexOf(param1);
         this._huntTypes.splice(_loc5_,1);
         if(param1 == this._huntType)
         {
            if(this._huntTypes.length > 0)
            {
               this.updateHuntDisplay(this._huntTypes[0]);
            }
            else
            {
               this.uiApi.unloadUi(this.uiApi.me().name);
            }
         }
      }
      
      private function onTreasureHuntAvailableRetryCountUpdate(param1:uint, param2:int) : void
      {
         this._treasureHunts[param1] = this.questApi.getTreasureHunt(param1);
         if(param2 == -1)
         {
            this.lbl_try.text = this.uiApi.getText("ui.treasureHunt.infiniteTry");
         }
         else if(param2 > 0)
         {
            this.lbl_try.text = this.uiApi.processText(this.uiApi.getText("ui.treasureHunt.tryLeft",param2),"",param2 == 1);
         }
      }
      
      private function onFlagRemoved(param1:String, param2:int) : void
      {
         if(param1.indexOf("flag_teleportPoint_" + this._huntType + "_") == 0)
         {
            this._currentLocNames[this._huntType] = "";
            this.gd_steps.updateItem(0);
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:MapPosition = null;
         var _loc3_:String = null;
         switch(param1)
         {
            case this.btn_arrowMinimize:
               if(!this._hidden)
               {
                  this._hidden = true;
                  this.ctr_instructions.visible = false;
                  this.tx_minMax.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "treasure_hunt/btnIcon_hunt_plus.png");
                  this.lbl_huntType.visible = false;
                  this.tx_chestIcon.visible = true;
               }
               else
               {
                  this._hidden = false;
                  this.ctr_instructions.visible = true;
                  this.tx_minMax.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "treasure_hunt/btnIcon_hunt_minus.png");
                  this.lbl_huntType.visible = true;
                  this.tx_chestIcon.visible = false;
               }
               break;
            case this.btn_huntType:
               this.showTypeMenu();
               break;
            case this.tx_title:
               this.stopDragUi();
               break;
            case this.btn_giveUp:
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.treasureHunt.giveUpConfirm"),[this.uiApi.getText("ui.common.ok"),this.uiApi.getText("ui.common.cancel")],[this.onPopupGiveUp,this.onPopupClose],this.onPopupGiveUp,this.onPopupClose);
               break;
            case this.btn_mask:
               this._maskVisible = !this._maskVisible;
               this.questApi.toggleWorldMask("treasureHinting",this._maskVisible);
               break;
            default:
               if(param1.name.indexOf("btn_loc") != -1)
               {
                  _loc2_ = this.dataApi.getMapInfo(this._compHookData[param1.name].mapId);
                  _loc3_ = "flag_teleportPoint_" + this._huntType + "_" + this._compHookData[param1.name].mapId;
                  if(this._currentLocNames[this._huntType] == _loc3_)
                  {
                     param1.selected = false;
                     this._currentLocNames[this._huntType] = "";
                  }
                  else
                  {
                     param1.selected = true;
                     this._currentLocNames[this._huntType] = _loc3_;
                  }
                  this.sysApi.dispatchHook(AddMapFlag,_loc3_,this.uiApi.getText("ui.treasureHunt.huntType" + this._huntType) + " [" + _loc2_.posX + "," + _loc2_.posY + "]",_loc2_.worldMap,_loc2_.posX,_loc2_.posY,15636787,true);
               }
               else if(param1.name.indexOf("btn_pictos") != -1)
               {
                  if(this.sysApi.getBuildType() >= BuildTypeEnum.INTERNAL)
                  {
                     this.sysApi.goToUrl("http://utils.dofus.lan/viewPOIFromLabelId.php?labelIds=" + this._compHookData[param1.name].poiLabel);
                  }
                  else if(this.sysApi.getBuildType() == BuildTypeEnum.TESTING)
                  {
                     this.sysApi.goToUrl("http://utils.dofus.lan/viewPOIFromLabelId.php?fromDb=1&labelIds=" + this._compHookData[param1.name].poiLabel);
                  }
               }
               else if(param1.name.indexOf("btn_dig") != -1)
               {
                  this.sysApi.sendAction(new TreasureHuntDigRequest(this._huntType));
               }
               else if(param1.name.indexOf("tx_flag") != -1)
               {
                  this.sysApi.log(2,"clic sur flag " + this._compHookData[param1.name].index + " : " + this._compHookData[param1.name].flagState);
                  if(this._compHookData[param1.name].flagState == -1 || this._compHookData[param1.name].flagState == TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_WRONG)
                  {
                     this.sysApi.sendAction(new TreasureHuntFlagRequest(this._huntType,this._compHookData[param1.name].index));
                  }
                  else if(this._compHookData[param1.name].flagState == TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_UNKNOWN)
                  {
                     this.sysApi.sendAction(new TreasureHuntFlagRemoveRequest(this._huntType,this._compHookData[param1.name].index));
                  }
               }
         }
      }
      
      public function onPress(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_title:
               this._ctrLastPosition.x = int(this.ctr_hunt.x);
               this._ctrLastPosition.y = int(this.ctr_hunt.y);
               this.ctr_hunt.startDrag();
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_title:
               this.ctr_hunt.stopDrag();
               this.ctr_hunt.x = this._ctrStartPosition.x;
               this.ctr_hunt.y = this._ctrStartPosition.y;
         }
      }
      
      public function onReleaseOutside(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_title:
               this.stopDragUi();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:TreasureHuntWrapper = null;
         var _loc3_:uint = 6;
         var _loc4_:uint = 0;
         if(param1 == this.btn_giveUp)
         {
            _loc2_ = this.uiApi.getText("ui.fight.option.giveUp");
         }
         if(param1 == this.btn_arrowMinimize)
         {
            _loc2_ = this.uiApi.getText("ui.tooltip.foldUi") + " (" + this.uiApi.getText("ui.shortcuts.foldAll");
            _loc6_ = this.bindsApi.getShortcutBindStr("foldAll");
            if(_loc6_)
            {
               if(!_shortcutColor)
               {
                  _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
                  _shortcutColor = _shortcutColor.replace("0x","#");
               }
               _loc2_ = _loc2_ + (" <font color=\'" + _shortcutColor + "\'>(" + _loc6_ + ")</font>");
            }
            _loc2_ = _loc2_ + ")";
         }
         else if(param1 == this.tx_help)
         {
            _loc2_ = this.uiApi.getText("ui.treasureHunt.help");
         }
         else if(param1.name.indexOf("ctr_step") != -1)
         {
            _loc5_ = this._compHookData[param1.name];
            if(!_loc5_)
            {
               return;
            }
            _loc2_ = _loc5_.overText;
         }
         else if(param1.name.indexOf("btn_pictos") != -1)
         {
            _loc5_ = this._compHookData[param1.name];
            if(!_loc5_)
            {
               return;
            }
            _loc2_ = "Voir les pictos pour " + _loc5_.poiLabel + " (testing/local only)";
         }
         else if(param1.name.indexOf("tx_flag") != -1)
         {
            _loc5_ = this._compHookData[param1.name];
            if(!_loc5_)
            {
               return;
            }
            if(_loc5_.flagState == -1)
            {
               _loc2_ = this.uiApi.getText("ui.treasureHunt.flagStatePut");
            }
            else if(_loc5_.flagState == TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_UNKNOWN)
            {
               _loc2_ = this.uiApi.getText("ui.treasureHunt.flagStateRemove");
            }
            else if(_loc5_.flagState == TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_WRONG)
            {
               _loc2_ = this.uiApi.getText("ui.treasureHunt.flagStateReplace");
            }
            else if(_loc5_.flagState == TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_OK)
            {
               _loc2_ = this.uiApi.getText("ui.treasureHunt.flagStateCorrect");
            }
         }
         else if(param1.name.indexOf("btn_dig") != -1)
         {
            _loc5_ = this._compHookData[param1.name];
            if(!_loc5_)
            {
               return;
            }
            _loc7_ = this._treasureHunts[this._huntType];
            if(_loc7_.checkPointCurrent + 1 == _loc7_.checkPointTotal)
            {
               _loc2_ = this.uiApi.getText("ui.treasureHunt.searchHereForTreasure");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.treasureHunt.searchHereForNextStep");
            }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
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
            this.ctr_instructions.visible = false;
            this.tx_minMax.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
         }
         else
         {
            this._hidden = !this._foldStatus;
            this.ctr_instructions.visible = this._foldStatus;
            if(this._foldStatus)
            {
               this.tx_minMax.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
            }
            else
            {
               this.tx_minMax.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
            }
         }
      }
      
      public function onPopupClose() : void
      {
      }
      
      public function onPopupGiveUp() : void
      {
         this.sysApi.sendAction(new TreasureHuntGiveUpRequest(this._huntType));
      }
   }
}
