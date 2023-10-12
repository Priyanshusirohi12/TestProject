public class QuickBooksConnectionWrapper {
    public Header Header {get;set;} 
    public Columns Columns {get;set;} 
    public Rows Rows {get;set;} 
    public class Header {
        public String Time_Z {get;set;} // in json: Time
        public String ReportName {get;set;} 
        public String ReportBasis {get;set;} 
        public String StartPeriod {get;set;} 
        public String EndPeriod {get;set;} 
        public String SummarizeColumnsBy {get;set;} 
        public String Currency_Z {get;set;} // in json: Currency
        public String Customer {get;set;} 
        public List<Option> Option {get;set;} 
        public string dateMacro {get; set;}
    }
    public class Column {
        public String ColTitle {get;set;} 
        public String ColType {get;set;} 
        public List<Option> MetaData {get;set;} 
    }
    
    public class ColData {
        public String value {get;set;} 
    }
    
    public class Columns {
        public List<Column> Column {get;set;}  
    }
    
    public class Option {
        public String Name {get;set;} 
        public String Value {get;set;} 
    }
    
    public class Row {
        public Header Header {get;set;} 
        public Header Summary {get;set;} 
        public String type {get;set;} 
        public String group_Z {get;set;} // in json: group
    }
    
    public class Rows {
        public List<Row> Row {get;set;} 
    }
}