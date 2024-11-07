@isTest
private class StaticReportTest {

    static testMethod void test() {
        PageReference pageRef = Page.StaticReport;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Name','StaticReport');
        new StaticReport();
    }
    
    
}