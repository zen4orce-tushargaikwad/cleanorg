public with sharing class Configurationcleanupselector {
    //get apexclasses
    public static List<Search.SearchResult> selectclasses(String SearchQuery)
    {
		System.debug('searchResults of class');
    	Search.SearchResults searchResults = Search.find(SearchQuery);
    	return searchResults.get('ApexClass');
    } 
    //get triggers
    public static List<Search.SearchResult> selectTriggers(String SearchQuery)
    {
		System.debug('searchResults in Trigger');
    	Search.SearchResults searchResults = Search.find(SearchQuery);
    	return searchResults.get('ApexTrigger');
    }
    //get visiualforce pages
    public static List<String> selectApexPages(List<String> searchKeywords)
    {
    	Map<ID, ApexPage> ApexpageBody = new Map<ID, ApexPage>([SELECT Id,Name,Markup FROM ApexPage]);
    	List<String> PageNames = new List<String>();
    	for(String s:searchKeywords)
        {
	        for (ID idKey : ApexpageBody.keyset()) 
	        {
	            ApexPage a = ApexpageBody.get(idKey);
		            Boolean PageSearchResult = a.Markup.contains(s);
		            if(PageSearchResult)
		            {
		                PageNames.add(a.Name);
		            }
	        }
        }
        return PageNames;
    }
    //get visiualforcePageMarkup
    public static ApexPage selectApexPagemarkup(String pageName)
    {
    	ApexPage ApexPageBody = ([SELECT Id,Markup,Name FROM ApexPage where Name=:pageName]);
    	return ApexPageBody;
    }
    //get triggers
    public static List<ApexTrigger> selectTriggers()
    {
        List<ApexTrigger> triggerList = new List<ApexTrigger>([Select TableEnumOrId,Name from ApexTrigger]);
        return triggerList;
    }
   	//getvisiualforcePages
    public static List<ApexPage> selectVisualforcePages(){      
        List<ApexPage> apexPageList = new List<ApexPage>([Select Id, Name From Apexpage]);
        return apexPageList;
    }
    //getclasses
    public static List<ApexClass> getApexClasses(List<String> lstNameOfClasses)
    {
    	List<ApexClass> lstclasses=new List<ApexClass>([select Id,Name from ApexCLass where Name IN:lstNameOfClasses]);
    	return  lstclasses;
    }
    public static AsyncApexJob asyncApexJobDetails(Id idOfJob)
    {
        AsyncApexJob a;
        if(idOfJob != null)
        {
          a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                    TotalJobItems, CreatedBy.Email
                  FROM AsyncApexJob WHERE Id =:idOfJob];
        }
   		return a;
   }
   public static Map<ID, ApexTrigger> getApexTrigger(String triggerName)
   {
   		return new Map<ID, ApexTrigger>([SELECT Id,Body,Name FROM ApexTrigger where Name=:triggerName]);	
   }
  	public static Map<ID, ApexClass> getApexClassBody(String className)
  	{
  		return new Map<ID, ApexClass>([SELECT Id,Body,Name FROM ApexClass where Name=:className]);
  	}
}