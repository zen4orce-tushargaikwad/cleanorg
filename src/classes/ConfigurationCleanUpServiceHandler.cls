public with sharing class ConfigurationCleanUpServiceHandler {
    //Search Keyword
    //public String SearchKeyword = 'ConfigurationCleanUpService'; 
    //Boolean result= FALSE;
    
    public Map<String, Map<String, List<String>>> classwiseMap = new Map<String, Map<String, List<String>>>();
    public Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
    public Map<String, List<String>> typeWiseMap;
    public MetadataAPI mapi = new MetadataAPI();
    
    public ConfigurationCleanUpServiceHandler(){     
       
        }
    
    Public List<String> SearchInClass(List<String> searchKeywords)
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
        return lstclasses; 
    }
    
    Public List<String> SearchInTrigger(List<String> searchKeywords)
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
        return TriggerSummary;  
    }
    
    /*public Map<String, List<String>> getSummaryMap()
    {
    	return SummaryMap;
    }*/
    
    Public List<String> SearchInPage(List<String> searchKeywords)
    {        
        //Retriving Keyword Used in Pages
        List<String> PageNames = new List<String>();
        PageNames=Configurationcleanupselector.selectApexPages(searchKeywords);
        System.debug('Dependent Pages='+PageNames);
        SummaryMap.put('ApexPages', PageNames);
        System.debug('inside inclassPage');
        return PageNames;
    }

    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    public void deleteclasses(List<String> lstClassesToDelete)
    {
    	
    	List<String> lstDependentClasses=new List<String>();
    	List<String> lstDependentPages=new List<String>();
    	List<String> lstDependentTriggers=new List<String>();
    	List<ApexClass> lstclasses=new List<ApexClass>();
    	lstDependentClasses=SearchInClass(lstClassesToDelete);
    	lstDependentPages=SearchInPage(lstClassesToDelete);
    	lstDependentTriggers=SearchInTrigger(lstClassesToDelete);
    	System.debug('lstDependentClasses='+lstDependentClasses);
    	System.debug('lstDependentPages='+lstDependentPages);
    	System.debug('lstDependentTriggers='+lstDependentTriggers);
    	//typeWiseMap=getSummaryMap();
    	//System.debug('typeWiseMap='+typeWiseMap);
    	String sessionId=UserInfo.getSessionId();
    	Integer count = System.purgeOldAsyncJobs(Date.today()+1);
    	Database.executeBatch(new CommentDependentClassBatch(lstClassesToDelete,lstDependentClasses,sessionId),10);
    	Database.executeBatch(new CommentDependentTriggersBatch(lstClassesToDelete,lstDependentTriggers,sessionId),10);
    	Database.executeBatch(new CommentDependentPagesBatch(lstClassesToDelete,lstDependentPages,sessionId),10);
    	//lstclasses=Configurationcleanupselector.getApexClasses(lstClassesToDelete);
    	//Database.executeBatch(new DeleteclassesBatch(lstclasses,UserInfo.getSessionId()),10);
    }
}