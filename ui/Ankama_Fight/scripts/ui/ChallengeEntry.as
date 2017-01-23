package ui
{
   public class ChallengeEntry
   {
      
      public static const STATE_INPROGRESS:uint = 0;
      
      public static const STATE_COMPLETE:uint = 1;
      
      public static const STATE_FAILED:uint = 2;
       
      
      public var btn_challenge:Object;
      
      public var tx_result_challenge:Object;
      
      public var tx_slot_challenge:Object;
      
      public var tx_picto_challenge:Object;
      
      private var _data:Object;
      
      private var _state:Object;
      
      private var _challengeUi:Object;
      
      public function ChallengeEntry(param1:Object, param2:Object, param3:Object, param4:uint, param5:uint)
      {
         super();
         this._challengeUi = param1;
         this.data = param3;
         this.display(param2,param4,param5);
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         if(this.tx_picto_challenge)
         {
            this.tx_picto_challenge.uri = param1.iconUri;
         }
         this.state = param1.result;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set state(param1:uint) : void
      {
         this._state = param1;
         this.refresh_state();
      }
      
      private function display(param1:Object, param2:uint, param3:uint) : void
      {
         this.btn_challenge = Api.uiApi.createContainer("ButtonContainer");
         this.btn_challenge.x = param2;
         this.btn_challenge.y = param3;
         this.btn_challenge.changingStateData = new Array();
         this.btn_challenge.finalize();
         this.btn_challenge.width = 40;
         this.btn_challenge.height = 40;
         this.tx_picto_challenge = Api.uiApi.createComponent("Texture");
         this.tx_picto_challenge.x = 9;
         this.tx_picto_challenge.y = 4;
         this.tx_picto_challenge.width = 40;
         this.tx_picto_challenge.height = 40;
         this.tx_picto_challenge.name = "tx_picto_challenge";
         this.tx_picto_challenge.uri = this._data.iconUri;
         this.tx_picto_challenge.autoGrid = false;
         this.tx_picto_challenge.dispatchMessages = true;
         this.tx_picto_challenge.finalize();
         this.btn_challenge.addChild(this.tx_picto_challenge);
         this.tx_result_challenge = Api.uiApi.createComponent("Texture");
         this.tx_result_challenge.x = 9;
         this.tx_result_challenge.y = 4;
         this.tx_result_challenge.width = 40;
         this.tx_result_challenge.height = 40;
         this.tx_result_challenge.uri = Api.uiApi.createUri(this._challengeUi.getConstant("assets") + "Challenge_tx_Perdu");
         this.tx_result_challenge.autoGrid = false;
         this.tx_result_challenge.dispatchMessages = true;
         this.tx_result_challenge.finalize();
         this.btn_challenge.addChild(this.tx_result_challenge);
         param1.addChild(this.btn_challenge);
         this.refresh_state();
      }
      
      private function refresh_state() : void
      {
         if(this.tx_result_challenge)
         {
            switch(this._state)
            {
               case STATE_INPROGRESS:
                  this.tx_result_challenge.visible = false;
                  break;
               case STATE_COMPLETE:
                  this.tx_result_challenge.visible = true;
                  this.tx_result_challenge.uri = Api.uiApi.createUri(this._challengeUi.getConstant("texture") + "hud/filter_iconChallenge_check.png");
                  break;
               case STATE_FAILED:
                  this.tx_result_challenge.visible = true;
                  this.tx_result_challenge.uri = Api.uiApi.createUri(this._challengeUi.getConstant("texture") + "hud/filter_iconChallenge_cross.png");
            }
         }
      }
   }
}
