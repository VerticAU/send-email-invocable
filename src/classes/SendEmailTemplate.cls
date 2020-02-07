global class SendEmailTemplate {
  
  @InvocableMethod(label='Send Email using Template')
  global static void sendEmail(List<EmailRequest> requests) {
      try{
          for (EmailRequest request : requests) {

              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

              if(String.isNotBlank(request.fromEmailAddress)){
                  OrgWideEmailAddress owa = [SELECT id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = :request.fromEmailAddress LIMIT 1];
                  mail.setOrgWideEmailAddressId(owa.id);
              }

              EmailTemplate templateId = [Select id from EmailTemplate where DeveloperName = :request.emailName];
              mail.setTargetObjectId(request.targetId);
              mail.setTemplateID(templateId.Id);

              if (request.saveAsActivity != null) {
                  mail.setSaveAsActivity(request.saveAsActivity);
              }
              else {
                  mail.setSaveAsActivity(true);
              }

              if (request.whatId != null && request.whatId.length() > 0) {
                  mail.setWhatId(request.whatId);
              }

              System.debug(Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail }, false));
          }
      }catch (Exception ex){
          System.debug(ex.getMessage());
          System.debug(ex.getStackTraceString());
//          hey.Logger.exception(ex);
//          hey.Logger.debug(requests);
      }finally {
//          hey.Logger.publish();
      }
  }

  global class EmailRequest {

    @InvocableVariable(label='From Email Address' description='Org-Wide email address. Please make sure it\'s verified!')
    global String fromEmailAddress;

    @InvocableVariable(label='Email Template Developer Name' required=true description='You can use the following SOQL to find the DeveloperName: SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE Id = "email template id"')
    global String emailName;

    @InvocableVariable(label='Send To Object ID' required=true description='TargetObjectId on the EmailMessage')
    global String targetId;

    @InvocableVariable(label='Regarding Object ID' description='WhatId on the EmailMessage')
    global String whatId;

    @InvocableVariable(label='Save as Activity' description='This is TRUE by default')
    global Boolean saveAsActivity;

  }

}
