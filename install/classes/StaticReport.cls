public class StaticReport {
    
    /* Static Report
     * @author Maciej Szymczak
     * @version 2022.10.05
     */
    
    public String report {get;set;}
    
    public StaticReport() {
        report = [select Body from StaticResource where Name = :apexPages.currentPage().getParameters().get('Name')].Body.toString();
    }    
    
}