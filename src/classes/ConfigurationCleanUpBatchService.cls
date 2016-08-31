global class ConfigurationCleanUpBatchService implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{    
    global Map<String,List<String>> receivedlist = new Map<String,List<String>>();
    global List<String> batchlist = new List<String>(); 
    global string configName;
    public String sessionId; 
    
    global ConfigurationCleanUpBatchService(Map<String,List<String>> listofsobject){
        sessionId = UserInfo.getSessionId();
        for(String sObj : listofsobject.keySet()){
            batchlist = listofsobject.get(sObj);
            configName = sObj;
            listofsobject.remove(sObj);
            receivedlist = listofsobject.clone();
            break;
        }
    }
    global List<String> start(Database.BatchableContext BC){
        System.debug('configName in start: ' +configName);
        System.debug('configName in start: ' +batchlist);
        return batchlist;
        //return new IterableConfigurationHandler();
    }
    global void execute(Database.BatchableContext BC, List<String> scope){	
        System.debug('configName : '+configName);
        List<String> ss = new  List<String>();
        try{
            ToolingAPIService t = new ToolingAPIService();
            MetadataAPI mapi = new MetadataAPI();
            for (String s : scope) 
            {   
                if(configName == 'ApexTrigger'){
                	System.debug('Apex trigger');
                    t.TriggerDelete(s, sessionId);
                }
                if(configName == 'ApexPage'){
                	System.debug('Apex page');
                    t.PageDelete(s, sessionId);
                } 
                ss.add(string.valueOf(s));
            }
            if(configName == 'WorkFlow'){
            	System.debug('workflow');
                mapi.deleteWorkflow(ss);
            }
            if(configName == 'ValidationRule'){
            	System.debug('validation rule');
               // mapi.deleteValidationRule(scssope);
            }
        }
        catch(Exception e){
            System.debug('Exception : '+ e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
    	System.debug('IN FINISH');
       if(receivedlist.size() > 0){
            System.debug('listofsobject '+receivedlist);
            System.debug('configName in Finish: '+configName);
            configName = ''; 
            Id batchInstanceId = Database.executeBatch(new ConfigurationCleanUpBatchService(receivedlist));
        }
    }     
}