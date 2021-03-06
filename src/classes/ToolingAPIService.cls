public class ToolingAPIService {
    
    //METHOD TO DELETE TRIGGER USING REST API
    public void TriggerDelete(ID a , String sessionID){
        String endp = URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v29.0/tooling/sobjects/ApexTrigger/'+ a;
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'OAuth  ' + sessionID);
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endp);
            req.setMethod('DELETE');
        
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug('************************** Trigger Response'+res.getStatus());
    }
    
    //METHOD TO DELETE CLASS USING REST API
    public String ClassDelete(ID a , String sessionID){
        String endp = URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v29.0/tooling/sobjects/ApexClass/'+a;
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'OAuth  ' + sessionID);
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endp);
            req.setMethod('DELETE');
        
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug('************************** Class Response'+res.getBody());
            return res.getStatus();
    }
    
    //METHOD TO DELETE VISUALFORCE PAGE USING REST API
    public void PageDelete(ID a , String sessionID){
        String endp = URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v29.0/tooling/sobjects/ApexPage/'+ a;
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'OAuth  ' + sessionID);
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endp);
            req.setMethod('DELETE');
        
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug('************************** Page Response'+res.getStatus());
    }
    
    public void AsyncApexJobDelete(ID a , String sessionID){
        String endp = URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v29.0/tooling/sobjects/AsyncApexJob/'+ a;
        System.debug('endp='+endp);
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'OAuth  ' + sessionID);
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endp);
            req.setMethod('DELETE');
        
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug('************************** Page Response'+res.getStatus());
			System.debug('Page Response='+res.getBody());            
    }
    

}