package ui
{
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.externalnotifications.ExternalNotification;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import d2enums.ExternalNotificationTypeEnum;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import types.ConfigProperty;
   
   public class ConfigNotification extends ConfigUi
   {
      
      private static const _displayDurationValues:Array = [3,5,10,30,60];
      
      private static var _events:Array;
       
      
      public var bindsApi:BindsApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _displayDurations:Array;
      
      private var _notificationModes:Array;
      
      private var _maxNumbers:Array;
      
      private var _notificationPositions:Array;
      
      private var _eventBtnList:Dictionary;
      
      private var _soundBtnList:Dictionary;
      
      private var _notifyBtnList:Dictionary;
      
      private var _multiBtnList:Dictionary;
      
      public var btn_alphaWindows:ButtonContainer;
      
      public var cb_notifMode:ComboBox;
      
      public var cb_displayDuration:ComboBox;
      
      public var cb_maxNumber:ComboBox;
      
      public var cb_notifPosition:ComboBox;
      
      public var gd_notifications:Grid;
      
      public var tx_bgForeground2:TextureBitmap;
      
      public function ConfigNotification()
      {
         this._eventBtnList = new Dictionary(true);
         this._soundBtnList = new Dictionary(true);
         this._notifyBtnList = new Dictionary(true);
         this._multiBtnList = new Dictionary(true);
         super();
      }
      
      public function main(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:XMLList = null;
         var _loc9_:XML = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         var _loc2_:Array = new Array();
         _loc2_.push(new ConfigProperty("btn_alphaWindows","notificationsAlphaWindows","dofus"));
         _loc2_.push(new ConfigProperty("cb_notifMode","notificationsMode","dofus"));
         _loc2_.push(new ConfigProperty("cb_displayDuration","notificationsDisplayDuration","dofus"));
         _loc2_.push(new ConfigProperty("cb_maxNumber","notificationsMaxNumber","dofus"));
         _loc2_.push(new ConfigProperty("cb_notifPosition","notificationsPosition","dofus"));
         init(_loc2_);
         if(!_events)
         {
            _events = new Array();
            _loc6_ = new Array();
            _loc7_ = this.dataApi.getExternalNotifications().length;
            _loc8_ = describeType(ExternalNotificationTypeEnum).child("constant");
            for each(_loc9_ in _loc8_)
            {
               _loc10_ = ExternalNotificationTypeEnum[_loc9_.attribute("name")];
               _loc11_ = _loc10_ > _loc7_?_loc6_:_events;
               _loc11_.push({
                  "text":this.getEventDescription(_loc10_),
                  "notifType":_loc10_
               });
            }
            _events.sortOn("notifType",Array.NUMERIC);
            _loc6_.sortOn("notifType",Array.NUMERIC | Array.DESCENDING);
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               _events.splice(0,0,_loc6_[_loc3_]);
               _loc3_++;
            }
         }
         for each(_loc4_ in _events)
         {
            _loc12_ = configApi.getExternalNotificationOptions(_loc4_.notifType);
            _loc4_.active = _loc12_.active;
            if(_loc12_.hasOwnProperty("sound"))
            {
               _loc4_.sound = _loc12_.sound;
            }
            else
            {
               _loc4_.sound = true;
            }
            if(_loc12_.hasOwnProperty("notify"))
            {
               _loc4_.notify = _loc12_.notify;
            }
            else
            {
               _loc4_.notify = true;
            }
            if(_loc12_.hasOwnProperty("multi"))
            {
               _loc4_.multi = _loc12_.multi;
            }
            else
            {
               _loc4_.multi = true;
            }
         }
         this._notificationModes = new Array(uiApi.getText("ui.common.none"),uiApi.getText("ui.alert.activation.noFocusOnOneClient"),uiApi.getText("ui.alert.activation.minimizedOneClient"),uiApi.getText("ui.alert.activation.noFocusOnAnyClient"));
         this.cb_notifMode.dataProvider = this._notificationModes;
         this.cb_notifMode.value = this._notificationModes[sysApi.getOption("notificationsMode","dofus")];
         this.cb_notifMode.dataNameField = "";
         this._displayDurations = new Array(uiApi.getText("ui.alert.displayDuration1"),uiApi.getText("ui.alert.displayDuration2"),uiApi.getText("ui.alert.displayDuration3"),uiApi.getText("ui.alert.displayDuration4"),uiApi.getText("ui.alert.displayDuration5"));
         this.cb_displayDuration.dataProvider = this._displayDurations;
         _loc5_ = _displayDurationValues.indexOf(sysApi.getOption("notificationsDisplayDuration","dofus"));
         this.cb_displayDuration.value = this._displayDurations[_loc5_];
         this.cb_displayDuration.dataNameField = "";
         this._maxNumbers = new Array("1","3","5","10");
         this.cb_maxNumber.dataProvider = this._maxNumbers;
         this.cb_maxNumber.value = sysApi.getOption("notificationsMaxNumber","dofus").toString();
         this.cb_maxNumber.dataNameField = "";
         this.cb_notifPosition.dataProvider = this._notificationPositions = [uiApi.getText("ui.alert.position.bottomRightCorner"),uiApi.getText("ui.alert.position.bottomLeftCorner"),uiApi.getText("ui.alert.position.topRightCorner"),uiApi.getText("ui.alert.position.topLeftCorner")];
         this.cb_notifPosition.value = this._notificationPositions[sysApi.getOption("notificationsPosition","dofus")];
         this.cb_notifPosition.dataNameField = "";
         this.gd_notifications.height = _events.length * this.gd_notifications.slotHeight;
         this.tx_bgForeground2.height = this.gd_notifications.height + 50;
         this.gd_notifications.dataProvider = _events;
      }
      
      private function getEventByType(param1:int) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in _events)
         {
            if(_loc2_.notifType == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function getEventDescription(param1:int) : String
      {
         var _loc3_:ExternalNotification = null;
         var _loc2_:Object = this.dataApi.getExternalNotifications();
         if(param1 == ExternalNotificationTypeEnum.ACHIEVEMENT_UNLOCKED)
         {
            return uiApi.getText("ui.achievement.achievement");
         }
         if(param1 == ExternalNotificationTypeEnum.QUEST_VALIDATED)
         {
            return uiApi.getText("ui.almanax.questDone");
         }
         for each(_loc3_ in _loc2_)
         {
            if(ExternalNotificationTypeEnum[_loc3_.name] == param1)
            {
               return _loc3_.description;
            }
         }
         return null;
      }
      
      override public function reset() : void
      {
         super.reset();
         init(_properties);
      }
      
      public function updateNotificationLine(param1:*, param2:*, param3:Boolean) : void
      {
         this._eventBtnList[param2.btn_activate.name] = param1;
         this._soundBtnList[param2.btn_sound.name] = param1;
         this._notifyBtnList[param2.btn_notify.name] = param1;
         this._multiBtnList[param2.btn_multi.name] = param1;
         if(param1)
         {
            param2.btn_label_btn_activate.text = param1.text;
            param1 = this.getEventByType(param1.notifType);
            param2.btn_activate.selected = param1.active;
            param2.btn_sound.uri = uiApi.createUri(uiApi.me().getConstant("alertIcon") + (!!param1.sound?"audio_selected":"audio_normal") + ".png");
            param2.btn_sound.finalize();
            param2.btn_notify.uri = uiApi.createUri(uiApi.me().getConstant("alertIcon") + (!!param1.notify?"page_selected":"page_normal") + ".png");
            param2.btn_notify.finalize();
            param2.btn_multi.uri = uiApi.createUri(uiApi.me().getConstant("alertIcon") + (!!param1.multi?"multi_selected":"multi_normal") + ".png");
            param2.btn_multi.finalize();
            param2.btn_activate.visible = true;
            param2.btn_sound.visible = param1.hasOwnProperty("sound");
            param2.btn_notify.visible = param1.hasOwnProperty("notify");
            param2.btn_multi.visible = param1.hasOwnProperty("multi");
         }
         else
         {
            param2.btn_activate.visible = false;
            param2.btn_sound.visible = false;
            param2.btn_notify.visible = false;
            param2.btn_multi.visible = false;
         }
      }
      
      public function onMouseUp(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1.name.indexOf("btn_activate") != -1)
         {
            _loc2_ = this._eventBtnList[param1.name];
            this.updateEventOptions(_loc2_.notifType,"active");
         }
         else if(param1.name.indexOf("btn_sound") != -1)
         {
            _loc2_ = this._soundBtnList[param1.name];
            this.updateEventOptions(_loc2_.notifType,"sound");
         }
         else if(param1.name.indexOf("btn_notify") != -1)
         {
            _loc2_ = this._notifyBtnList[param1.name];
            this.updateEventOptions(_loc2_.notifType,"notify");
         }
         else if(param1.name.indexOf("btn_multi") != -1)
         {
            _loc2_ = this._multiBtnList[param1.name];
            this.updateEventOptions(_loc2_.notifType,"multi");
         }
         else if(param1.name.indexOf("btn_alphaWindows") != -1)
         {
            setProperty("dofus","notificationsAlphaWindows",param1.selected);
         }
         this.gd_notifications.updateItem(parseInt(param1.name.split("_").reverse()[0]));
      }
      
      private function updateEventOptions(param1:int, param2:String) : Boolean
      {
         var _loc3_:Object = this.getEventByType(param1);
         _loc3_[param2] = !_loc3_[param2];
         configApi.setExternalNotificationOptions(_loc3_.notifType,_loc3_);
         return _loc3_[param2];
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.cb_notifMode:
               setProperty("dofus","notificationsMode",this.cb_notifMode.selectedIndex);
               break;
            case this.cb_displayDuration:
               setProperty("dofus","notificationsDisplayDuration",_displayDurationValues[this.cb_displayDuration.selectedIndex]);
               break;
            case this.cb_maxNumber:
               setProperty("dofus","notificationsMaxNumber",int(this.cb_maxNumber.selectedItem));
               break;
            case this.cb_notifPosition:
               setProperty("dofus","notificationsPosition",this.cb_notifPosition.selectedIndex);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:Object = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         if(param1.name.indexOf("btn_sound") != -1)
         {
            _loc5_ = this._soundBtnList[param1.name];
            if(this.getEventByType(_loc5_.notifType).sound == true)
            {
               _loc2_ = uiApi.getText("ui.alert.info.sound.deactivate");
            }
            else
            {
               _loc2_ = uiApi.getText("ui.alert.info.sound.activate");
            }
         }
         else if(param1.name.indexOf("btn_multi") != -1)
         {
            _loc5_ = this._multiBtnList[param1.name];
            if(this.getEventByType(_loc5_.notifType).multi == true)
            {
               _loc2_ = uiApi.getText("ui.alert.info.multi.deactivate");
            }
            else
            {
               _loc2_ = uiApi.getText("ui.alert.info.multi.activate");
            }
         }
         else if(param1.name.indexOf("btn_notify") != -1)
         {
            _loc5_ = this._notifyBtnList[param1.name];
            if(this.getEventByType(_loc5_.notifType).notify == true)
            {
               _loc2_ = uiApi.getText("ui.alert.info.notify.deactivate");
            }
            else
            {
               _loc2_ = uiApi.getText("ui.alert.info.notify.activate");
            }
         }
         if(_loc2_ != "")
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
   }
}
