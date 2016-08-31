public with sharing class ConfigurationCleanUpServiceHandler {
    //Search Keyword
    //public String SearchKeyword = 'ConfigurationCleanUpService'; 
    //Boolean result= FALSE;
    
    public Map<String, Map<String, List<String>>> classwiseMap = new Map<String, Map<String, List<String>>>();
    public Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
    public MetadataAPI mapi = new MetadataAPI();
    
    public ConfigurationCleanUpServiceHandler(){     
        SummaryMap.put('ApexClass', null);
        SummaryMap.put('ApexTrigger', null);
        SummaryMap.put('ApexPages', null);
        }
    
    Public set<String> SearchInClass(List<String> searchKeywords)
    {
        List<String> lstDependentCLasses = new List<String>();
        String keywordsToSearch;
        set<String> ClassSummary = new set<String>();
        List<String> lstclasses=new List<String>();
        for(String s:searchKeywords)
        {
        	keywordsToSearch=keywordsToSearch+s+' '+'OR ';
        }
        String preFinalString=keywordsToSearch.removeStart('null');
        String FinalString=preFinalString.removeEndIgnoreCase('OR ');
        //SOSL Dynamic Query
        String SearchQuery = 'FIND {'+FinalString+'}RETURNING ApexClass(Name)';
        List<Search.SearchResult> ClassSearchResult=Configurationcleanupselector.selectclasses(SearchQuery);
        //Retriving Keyword Used in Class
        for (Search.SearchResult searchResult : ClassSearchResult) { 
        ApexClass Classes = (ApexClass) searchResult.getSObject(); 
        ClassSummary.add(Classes.Name);
        }
        ClassSummary.removeAll(searchKeywords);
        lstclasses.addAll(ClassSummary);
        SummaryMap.put('ApexClass',lstclasses);
        System.debug('Dependent Classes='+lstclasses);
        System.debug('inside inclass');
        return ClassSummary; 
    }
    
    Public void SearchInTrigger(List<String> searchKeywords)
    {
        String keywordsToSearch;
        List<String> TriggerSummary = new list<String>();
        for(String s:searchKeywords)
        {
        	keywordsToSearch=keywordsToSearch+s+' '+'OR ';
        }
        String preFinalString=keywordsToSearch.removeStart('null');
        String FinalString=preFinalString.removeEndIgnoreCase('OR ');
        String SearchQuery = 'FIND {'+FinalString+'}RETURNING ApexTrigger(name)';
        List<Search.SearchResult> TriggersearchResults=Configurationcleanupselector.selectTriggers(SearchQuery);
        //Retriving Keyword Used in Triggers
        for (Search.SearchResult TriggersResults : TriggersearchResults) { 
        ApexTrigger Triggers = (ApexTrigger) TriggersResults.getSObject();
            TriggerSummary.add(Triggers.Name);
        }
        System.debug('TriggerSummary='+TriggerSummary);
        System.debug('inside inTrigger');
        SummaryMap.put('ApexTrigger', TriggerSummary); 
    }
    
    public Map<String, List<String>> getSummaryMap()
    {
    	return SummaryMap;
    }
    
    Public void SearchInPage(List<String> searchKeywords)
    {        
        //Retriving Keyword Used in Pages
        List<String> PageNames = new List<String>();
        PageNames=Configurationcleanupselector.selectApexPages(searchKeywords);
        System.debug('Dependent Pages='+PageNames);
        SummaryMap.put('ApexPages', PageNames);
        System.debug('inside inclassPage');
    }

    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    
    /*public static Map<string, List<String>> getWorkflows()
    {
    	Map<string, List<String>> WorkflowMap = new Map<string, List<String>>();
    	MetadataAPI mapi = new MetadataAPI();
        MetadataService.FileProperties[] fileproperties = mapi.listWorkflowMetadata();
        if(fileproperties != null){
        	list<String> WorkflowName;
    		for(MetadataService.FileProperties fileProperty : fileproperties)
    		{
	    		if(fileProperty.fullName != null && fileProperty.fullName != '')
    	        {
        	        WorkflowName = new List<String>();                
            	    string Objectname = fileProperty.fullName;
                	if(WorkflowMap.containsKey(Objectname.substringBefore('.')))
                	{ 
	                    WorkflowName.addAll(WorkflowMap.get(Objectname.substringBefore('.')));
    	                WorkflowName.add(Objectname.substringAfter('.'));   
        	        }
            	    else{
                	   	WorkflowName.add(Objectname.substringAfter('.'));
                	}
               		WorkflowMap.put(Objectname.substringBefore('.'), WorkflowName);      
    			}
    		}
        }
    	return WorkflowMap;        
    }
    public static Map<string, List<String>> getValidationRules()
    {
    	Map<string, List<String>> ValidationRuleMap = new Map<string, List<String>>();
    	MetadataAPI mapi = new MetadataAPI();
        MetadataService.FileProperties[] fileproperties = mapi.listValidationRuleMetadata();
        if(fileproperties != null){
        	list<String> ValidationRuleName;
    		for(MetadataService.FileProperties fileProperty : fileproperties)
    		{
	    		if(fileProperty.fullName != null && fileProperty.fullName != '')
    	        {
        	        ValidationRuleName = new List<String>();                
            	    string Objectname = fileProperty.fullName;
                	if(ValidationRuleMap.containsKey(Objectname.substringBefore('.')))
                	{ 
                    	ValidationRuleName.addAll(ValidationRuleMap.get(Objectname.substringBefore('.')));
                    	ValidationRuleName.add(Objectname.substringAfter('.'));   
                	}
                	else{
	                    ValidationRuleName.add(Objectname.substringAfter('.'));
    	            }
        	       	ValidationRuleMap.put(Objectname.substringBefore('.'), ValidationRuleName);      
    			}
    		}
        }
    	return ValidationRuleMap;         
    }*/
}