public with sharing class CommentDependentClasses {
    String regExp = '*/';
    String replacement = '*//*';

    public CommentDependentClasses(){
    }
    
    public List<String> CommentMultipleClasses(List<String> lstCLasses, String sessionId)
    {
    	//Http httpResponse = new Http();
    	String classStatus;
    	List<String> failedclasses=new List<String>();
    	for(String str:lstCLasses)
    	{
    		JsonTest containerResponse = new JsonTest();
    		//pre-Step 1
    		pollCurrentClass(sessionId);
    		//Step 1 - Create MetadataContainer
    		containerResponse = createMetadataContainer(str,sessionId);
    		//Step 2 - Create ApexClassMember
    		classStatus=createApexClassMember(str,containerResponse,sessionId);
    		if(classStatus!='Created')
	    	{
	    		failedclasses.add(str);
	    	}
    		//Step 3 - Create ContainerAsyncRequest
    		createContainerAsyncRequest(containerResponse,sessionId);
    	}
    	return failedclasses;
    }
    
    public List<String> CommentMultipleTriggers(List<String> lstTrigger, String sessionId)
    {
	    	//Http httpResponse = new Http();
	    	String triggerStatus;
	    	List<String> failedTriggers=new List<String>();
	    	for(String str:lstTrigger)
	    	{
		    	JsonTest containerResponse = new JsonTest();
	    		//pre-Step 1
	    		pollCurrentTrigger(sessionId);
	    		//Step 1 - Create MetadataContainer
	    		containerResponse = createMetadataContainer(str,sessionId);
	    		//Step 2 - Create ApexClassMember
	    		triggerStatus=createApexTriggerMember(str,containerResponse,sessionId);
	    		if(triggerStatus!='Created')
	    		{
	    			failedTriggers.add(str);
	    		}
	    		//Step 3 - Create ContainerAsyncRequest
	    		createContainerAsyncRequest(containerResponse,sessionId);
	    	}
	    	return failedTriggers;
    } 
      
    public List<String> CommentMultiplePages(List<String> lstPages, String sessionId)
    {
	    	//Http httpResponse = new Http();
	    	String pageStatus;
	    	List<String> lstfailedPages=new List<String>();
	    	System.debug('lstPages='+lstPages);
	    	for(String str:lstPages)
	    	{
		    	JsonTest containerResponse = new JsonTest();
	    		//pre-Step 1
	    		pollCurrentApexPage(sessionId);
	    		//Step 1 - Create MetadataContainer
	    		containerResponse = createMetadataContainer(str,sessionId);
	    		//Step 2 - Create ApexClassMember
	    		pageStatus=createApexPageMember(str,containerResponse,sessionId);
	    		System.debug('pageStatus='+pageStatus);
	    		if(pageStatus!='Created')
	    		{
	    			lstfailedPages.add(str);
	    		}
	    		//Step 3 - Create ContainerAsyncRequest
	    		createContainerAsyncRequest(containerResponse,sessionId);
	    	}
	    	return lstfailedPages;
    }  
       
    public void pollcurrentTrigger(String sessionId)
    {
    	HttpRequest apexTriggerRequest= new HttpRequest();
    	apexTriggerRequest.setHeader('Authorization', 'Bearer ' + sessionId);
        apexTriggerRequest.setHeader('Content-Type', 'application/json');
        apexTriggerRequest.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ApexTrigger/');
        apexTriggerRequest.setMethod('GET');
        //Response
        Http httpResponse = new Http();
        HttpResponse apexTriggerResponse = httpResponse.send(apexTriggerRequest);
        System.debug('apexTriggerResponse='+apexTriggerResponse.getBody());
    }
    
    public void pollcurrentApexPage(String sessionId)
    {
    	HttpRequest apexApexPageRequest= new HttpRequest();
    	apexApexPageRequest.setHeader('Authorization', 'Bearer ' + sessionId);
        apexApexPageRequest.setHeader('Content-Type', 'application/json');
        apexApexPageRequest.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ApexPage/');
        apexApexPageRequest.setMethod('GET');
        //Response
        Http httpResponse = new Http();
        HttpResponse apexApexPageResponse = httpResponse.send(apexApexPageRequest);
        System.debug('apexApexPageResponse'+apexApexPageResponse.getBody());
    }
    
    public void pollCurrentClass(String sessionId){

        //Request
        HttpRequest apexClassRequest = new HttpRequest();
        apexClassRequest.setHeader('Authorization', 'Bearer ' + sessionId);
        apexClassRequest.setHeader('Content-Type', 'application/json');
        apexClassRequest.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ApexClass/');
        apexClassRequest.setMethod('GET');
        //Response
        Http httpResponse = new Http();
        HttpResponse apexClassResponse = httpResponse.send(apexClassRequest);
        System.debug('apexClassResponse='+apexClassResponse.getBody());
    }

    public JsonTest createMetadataContainer(String containerName, String sessionId){
		
        //Request
        HttpRequest containerRequest = buildHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/MetadataContainer/', 'POST',sessionId);
        
        String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
		String randStr = '';
		while (randStr.length() < 5) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx+1);
		}
        
        containerRequest.setBody('{"Name":"'+randStr+'"}');
        //Response
        HttpResponse containerResponse = buildHttpResponse(containerRequest);
        return (JsonTest)JSON.Deserialize(containerResponse.getBody(), JsonTest.class);	
    }

    public String createApexClassMember(String className, JsonTest containerResponse,String sessionId){
        Map<ID, ApexClass> ApexClassBody=new Map<ID, ApexClass>();
        ApexClassBody=Configurationcleanupselector.getApexClassBody(className);
        //Map<ID, ApexClass> ApexClassBody = new Map<ID, ApexClass>([SELECT Id,Body,Name FROM ApexClass where Name=:className]); 
        //Request
        String classBody = '';
        HttpRequest apexClassRequest = buildHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ApexClassMember/', 'POST',sessionId);
        for (ID idKey : ApexClassBody.keyset()) 
        {
            ApexClass a = ApexClassBody.get(idKey);
            String cvt = a.Body.normalizeSpace();
            String s1 = cvt.substringBefore('{');
            String s2 = cvt.substringAfter('{');
            s2 ='{ /*'+ s2;
           	s2 = s2.replace(regExp, replacement);
            s2 =s2 + '*/ }';
            classBody = classBody + s1 + s2;   
            System.debug('CLass Boby after commenting'+classBody );
        	apexClassRequest.setBody('{"ContentEntityId": "'+a.id+'", "MetadataContainerId": "'+  +'", "Body" : "' + classBody + '"}');
        }
        //Response
        HttpResponse apexClassResponse = buildHttpResponse(apexClassRequest);
        System.debug('apexClassResponce='+apexClassResponse.getStatus());
        return apexClassResponse.getStatus();
        
    }
    
    public String createApexTriggerMember(String TriggerName, JsonTest containerResponse, String sessionId){
        Map<ID, ApexTrigger> ApexTriggerBody=new Map<ID, ApexTrigger>();
        ApexTriggerBody=Configurationcleanupselector.getApexTrigger(TriggerName);
        //Map<ID, ApexTrigger> ApexTriggerBody = new Map<ID, ApexTrigger>([SELECT Id,Body,Name FROM ApexTrigger where Name=:TriggerName]); 
        //Request
        String classBody = '';
        HttpRequest apexTriggerRequest = buildHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ApexTriggerMember/', 'POST',sessionId);
        System.debug('apexTriggerRequest'+apexTriggerRequest);
        for (ID idKey : ApexTriggerBody.keyset()) 
        {
            ApexTrigger a = ApexTriggerBody.get(idKey);
            String cvt = a.Body.normalizeSpace();
            String s1 = cvt.substringBefore('{');
            String s2 = cvt.substringAfter('{');
            s2 ='{ /*'+ s2;
           	s2 = s2.replace(regExp, replacement);
            s2 =s2 + '*/ }';
            classBody = classBody + s1 + s2;   
            System.debug('CLass Boby after commenting'+classBody );
        	apexTriggerRequest.setBody('{"ContentEntityId": "'+a.id+'", "MetadataContainerId": "'+  +'", "Body" : "' + classBody + '"}');
        }
        //Response
        HttpResponse apexTriggerResponse = buildHttpResponse(apexTriggerRequest);
        System.debug('apexTriggerResponse'+apexTriggerResponse);
        System.debug('apexTriggerResponse='+apexTriggerResponse.getStatus());
        return apexTriggerResponse.getStatus();
    }
    
    public String createApexPageMember(String PageName, JsonTest containerResponse, String sessionId){
        //Map<ID, ApexPage> ApexPageBody = new Map<ID, ApexPage>();
        //ApexPageBody=Configurationcleanupselector.selectApexPagemarkup();
        ApexPage a=Configurationcleanupselector.selectApexPagemarkup(PageName);
        System.debug('ApexPageBody'+a);
        //Request
        String classBody = '';
        HttpRequest apexPageRequest = buildHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ApexPageMember/', 'POST',sessionId);
        System.debug('apexTriggerRequest'+apexPageRequest);
        //for (ID idKey : ApexPageBody.keyset()) 
        //{
            String regExp='-->';
            String replacement='--><!--';
            
            String regExp1='"';
            String replacement1='';
            
            //ApexPage a = ApexPageBody.get(idKey);
            //System.debug('Interator id'+idKey);
            //System.debug('Apex PageID'+a.id);
            String cvt = a.Markup.normalizeSpace();
            
            String s1= cvt.substringBefore(' ');
            System.debug('s1'+s1);
            String s2= cvt.substringAfter(' ');
            s2 = s2.replace(regExp, replacement);
            s2 = s2.replace(regExp1, replacement1);
			System.debug('s2'+s2);            
            s1=s1+'></apex:page><!--';
            s2 =s2 + '-->';
            classBody = s1+s2;
            //classBody = '<apex:page></apex:page>';   
            System.debug('CLass Body after commenting'+classBody);
        	apexPageRequest.setBody('{"ContentEntityId": "'+a.id+'", "MetadataContainerId": "'+  +'","Body" : "' + classBody + '"}');
        	//req.setBody('{"Name" : "TestPageFromRest","Markup" : "<apex:page>hello</apex:page>","ControllerType" : "0","MasterLabel":"TestPageFromRest","ApiVersion":"29.0"}');
        //}
        //Response
        HttpResponse apexPageResponse = buildHttpResponse(apexPageRequest);
        System.debug('apexPageResponse'+apexPageResponse.getBody());
        System.debug('apexPageResponse='+apexPageResponse.getStatus());
        return apexPageResponse.getStatus();
    }

    public void createContainerAsyncRequest(JsonTest containerResponse, String sessionId){
        JsonTest containerAsyncJson=new JsonTest(); 
        //Request
        HttpRequest containerAsyncRequest = buildHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ContainerAsyncRequest/', 'POST',sessionId);
        containerAsyncRequest.setBody('{"IsCheckOnly": false, "MetadataContainerId": "'+ containerResponse.id +'"}');
        //Response
        HttpResponse containerAsyncResponse = buildHttpResponse(containerAsyncRequest);
        containerAsyncJson = (JsonTest)JSON.Deserialize(containerAsyncResponse.getBody(), JsonTest.class);
    }
    
	public HttpRequest buildHttpRequest(String endpoint, String method, String sessionId){
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + sessionId);
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endpoint);
        request.setMethod(method);
        return request;
    }

    public HttpResponse buildHttpResponse(HttpRequest sendRequest){
        Http poll = new Http();
        HttpResponse pollResponse = poll.send(sendRequest);
        return pollResponse;
    }

    public class JsonTest{
        Public String Id;
    }

    Public class JsonGET {
        public String body;
    }
}