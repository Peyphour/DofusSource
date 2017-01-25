package com.ankamagames.dofus.console.debug
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.misc.BuildTypeParser;
   import com.ankamagames.dofus.network.Metadata;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import flash.utils.ByteArray;
   
   public class VersionInstructionHandler implements ConsoleInstructionHandler
   {
       
      
      public function VersionInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         switch(param2)
         {
            case "version":
               switch(param3[0])
               {
                  case "revision":
                     param1.output("Build revision : " + BuildInfos.BUILD_REVISION);
                     break;
                  case "patch":
                     param1.output("Build patch : " + BuildInfos.BUILD_PATCH);
                     break;
                  case "date":
                     param1.output("Build date     : " + BuildInfos.BUILD_DATE);
                     break;
                  case "protocol":
                     param1.output("Protocol       : " + Metadata.PROTOCOL_BUILD + " (" + Metadata.PROTOCOL_DATE + ")");
                     break;
                  case "visionneuse":
                     param1.output("Visioneuse md5 : " + MD5.hashBytes(new Constants.BOOK_READER_APP() as ByteArray));
                     break;
                  case undefined:
                     param1.output("DOFUS v" + BuildInfos.BUILD_VERSION + " (" + BuildTypeParser.getTypeName(BuildInfos.BUILD_TYPE) + ")");
                     param1.output("MD5 visionneuse : " + MD5.hashBytes(new Constants.BOOK_READER_APP() as ByteArray));
                     break;
                  default:
                     param1.output("Unknown argument : " + param3[0]);
               }
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "version":
               return "Get the client version.";
            default:
               return "No help for command \'" + param1 + "\'";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         switch(param1)
         {
            case "version":
               return ["revision","patch","date","protocol","visionneuse"];
            default:
               return [];
         }
      }
   }
}
