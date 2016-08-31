global with sharing class CommentDependentClassesBatch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
	
	public String typeName='';
	public List<String> lstClassesToDelete;  
	public Map<String, List<String>> typeWiseMapforDeletion;
	public String sessionId;// = UserInfo.getSessionId();
	//public List<String> lstFailedTriggers=new List<String>();
    //public List<String> lstFailedClasses=new List<String>();
    //public List<String> lstFailedPages=new List<String>();
    public map<String,List<String>> failedComponentsToComment=new map<String,List<String>>();
	global CommentDependentClassesBatch(String key, Map<String, List<String>> typeWiseMap,string sess, map<String, List<String>> mapFailedComponents)
	{
		failedComponentsToComment.put('ApexTrigger',mapFailedComponents.get('ApexTrigger'));
		failedComponentsToComment.put('ApexClass',mapFailedComponents.get('ApexClass'));
		failedComponentsToComment.put('ApexPages',mapFailedComponents.get('ApexPages'));
		sessionId = sess;
		System.debug('In Cons sessionId'+sessionId);
		lstClassesToDelete=new List<String>();
		typeName=key;
		lstClassesToDelete=getTypeWiseList(key, typeWiseMap);
	}
	
	global List<String> getTypeWiseList(String key, Map<String, List<String>> typeWiseMap)
	{
		typeWiseMapforDeletion=typeWiseMap;
		lstClassesToDelete=typeWiseMapforDeletion.get(key);
		System.debug(lstClassesToDelete);
		return lstClassesToDelete; 		
	} 
	
	global List<String> start(Database.BatchableContext BC){
		//sessionId=UserInfo.getSessionId();
		System.debug('In Start method sessionId '+sessionId);
        return lstClassesToDelete;	
    }
    global void execute(Database.BatchableContext BC, List<String> scope){	
        try{
        	System.debug('one ');
        	CommentDependentClasses c=new CommentDependentClasses();
        	if(typeName=='ApexTrigger')
        	{
        		
        		List<String> lstFailedTriggers=new List<String>();
        		lstFailedTriggers=failedComponentsToComment.get('ApexTrigger');
        		System.debug('sessionId='+sessionId);
        		for (String s:c.CommentMultipleTriggers(scope, sessionId))
        		{
        			lstFailedTriggers.add(s);
        		} 
        		//lstFailedTriggers.addAll(c.CommentMultipleTriggers(scope, sessionId));
        		failedComponentsToComment.put('ApexTrigger',lstFailedTriggers);
        		System.debug('Failed Triggers='+lstFailedTriggers);
        	}
        	else if(typeName=='ApexClass')
        	{
        		List<String> lstFailedClasses=new List<String>();
        		lstFailedClasses=failedComponentsToComment.get('ApexClass');
        		System.debug('sessionId='+sessionId);
        		for(String s:c.CommentMultipleClasses(scope, sessionId))
        		{
        			lstFailedClasses.add(s);	
        		}
        		//lstFailedClasses.addAll(c.CommentMultipleClasses(scope, sessionId));
        		failedComponentsToComment.put('ApexClass',lstFailedClasses);
        		System.debug('lstFailedClasses='+lstFailedClasses);
        	}
        	else if(typeName=='ApexPages')
        	{
        		List<String> lstFailedPages=new List<String>();
        		lstFailedPages=failedComponentsToComment.get('ApexPages');
        		System.debug('sessionId='+sessionId);
        		for(String s:c.CommentMultiplePages(scope,sessionId))
        		{
        			lstFailedPages.add(s);
        		} 
        		//lstFailedPages.addAll(c.CommentMultiplePages(scope,sessionId));
        		failedComponentsToComment.put('ApexPages',lstFailedPages);
        		System.debug('lstFailedPages='+lstFailedPages);
        	}
        	else{
        	
        	}
        	/*System.debug('lstFailedClasses='+);
	    	System.debug('lstFailedPages='+lstFailedPages);
	    	System.debug('lstFailedTriggers='+lstFailedTriggers);*/
        	System.debug('one end');
        }
        catch(Exception e){
        	System.debug('Error in Batch'+e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
    	System.debug('Inside finish');
    	System.debug('sessionId='+sessionId); 
    	system.debug('IDDDDD  - ' + UserInfo.getSessionId());
    	if(typeName=='ApexTrigger') 
    	{
    		typeWiseMapforDeletion.remove('ApexTrigger');
    		typeName='ApexClass';
    		//Id sessionId=UserInfo.getSessionId();
    		Database.executeBatch(new CommentDependentClassesBatch(typeName,typeWiseMapforDeletion,sessionId,failedComponentsToComment),11);
    	}
    	else if(typeName=='ApexClass')
    	{
    		typeWiseMapforDeletion.remove('ApexClass');
    		typeName='ApexPages';
    		//Id sessionId=UserInfo.getSessionId();
    		Database.executeBatch(new CommentDependentClassesBatch(typeName,typeWiseMapforDeletion,sessionId,failedComponentsToComment),11);
    	}
    	else
    	{
    		typeWiseMapforDeletion.remove('ApexPages');
    		
    	}
    	if(typeWiseMapforDeletion.size()<=0)
    	{
	    	Id idOfCurrentBetch = BC.getJobId();
	        //List<AsyncApexJob> lstAsyncApexJob = new List<AsyncApexJob>();
	        AsyncApexJob lstAsyncApexJob = Configurationcleanupselector.asyncApexJobDetails(idOfCurrentBetch);
	        AsyncApexJob a=lstAsyncApexJob;
	    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {a.CreatedBy.Email};
	        mail.setToAddresses(toAddresses);
	        mail.setSubject('Details of Classes, Pages and Triggers failed to Comment');
			mail.setPlainTextBody('Classes='+failedComponentsToComment.get('ApexClass')+', Page='+failedComponentsToComment.get('ApexPages') +', Triggers='+failedComponentsToComment.get('ApexTrigger')+' are not commented and will give errors while you compile. Please Comment these mannually');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	}
    }		
}