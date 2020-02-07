@IsTest
private class SendEmailTemplateTest {


    @IsTest
    static void testBehavior() {
        Contact contactVar = new Contact(
            FirstName = 'qwe',
            LastName = 'qwe',
            Email = 'qwe@qwe.qw'
        );
        insert contactVar;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            EmailTemplate testTemplate = new EmailTemplate(
                Name = 'Test template',
                DeveloperName = 'name',
                TemplateType = 'text',
                FolderId = UserInfo.getUserId()
            );
            insert testTemplate;

            SendEmailTemplate.EmailRequest request = new SendEmailTemplate.EmailRequest();
            request.emailName = 'name';
            request.targetId = contactVar.Id;
            request.whatId = UserInfo.getUserId();
            SendEmailTemplate.sendEmail(new List<SendEmailTemplate.EmailRequest>{
                request
            });
        }

    }

    @IsTest
    static void testBehavior2() {
        SendEmailTemplate.sendEmail(new List<SendEmailTemplate.EmailRequest>{
            null
        });
    }
}