public with sharing class TC_CreditApplication {

	public Business borrower;
	public List <Relationship> relationships;
	public List <Equipment> equipmentList;
	public String systemId;
	public String externalId;
	public String stageName;
	public String salesRepId;//ownerId and SalesRep__c
	public Integer desiredTermInMonths;
	public Date commencementDate; //closeDate;
	public Date closeDate;
	public String creditAppName; //BorrowerName-YYYY/DD/MM

	public class Business {
		public String systemId;
		public String externalId;
		public String legalCompanyName;
		public String dba;
		public String fedTaxId;
		public String stateOfIncroporationCode;
		public String billingStreet;
		public String billingCity;
		public String billingStateCode;
		public String billingPostalCode;
		public String billingCountryCode;
		public String phone;
		public String fax;
		public String businessEmail;
		public Integer yearBusinessEstablished;
		public Integer yearsUnderCurrentOwnership;
		public Double annualSalesRevenue;
		public Integer numberOfEmployees;
		public String businessStructure; //Picklist: Corporation, Partnership, Proprietership, LLC
		public Boolean salesTaxExempt;
		public Boolean priorBankrupcy;
		public Boolean hasAnotherCompanyGuarantee;
		public ContactInfo contactInfo;
	}

	public class Equipment {
		public String systemId;
		public String externalId;
		public Business vendor; //this needs to have conta
		public String equipmentType;
		public Double equipmentCost;
		public String equipmentMake;
		public String equipmentModel;
		public String equipmentYear;
		public String description;

	}

	public class ContactInfo {
		public String systemId;
		public String externalId;
		public String firstName;
		public String lastName;
		public String ssn;
		public String title;
		public Double percentageOwnership;
		public String mailingStreet;
		public String mailingCity;
		public String mailingStateCode;
		public String mailingPostalCode;
		public String mailingCountryCode;
		public String homePhone;
		public String mobilePhone;
		public String email;
		public String ownOrRent;
		public Boolean priorBankrupcy;

	}

	public class Relationship {
		public String systemId;
		public String externalId;
		public Business company;
		public ContactInfo person;//this element is not checked when company is not null
		public String relationshipType;
	}

}


/*

{
    "salesRepId": "34223",
    "creditAppName": "Opprotunity Name",
    "closeDate": "Opprotunity Name",
    "stageName": "In Process",
    "desiredTermInMonths": 12,
    "commencementDate": "2018-01-20",
    "externalId": "111111",
    "borrower": {
        "legalCompanyName": "Disney123123",
        "dba": "The Company",
        "fedTaxId": "32-213212",
        "stateOfIncroporationCode": "MN",
        "billingStreet": "140 Main Street",
        "billingCity": "Saint Paul",
        "billingStateCode": "MN",
        "billingPostalCode": "55124",
        "billingCountryCode": "US",
        "phone": "444-333-1122",
        "fax": "444-333-2000",
        "businessEmail": "b@vv.com",
        "yearBusinessEstablished": 1980,
        "yearsUnderCurrentOwnership": 12,
        "annualSalesRevenue": 100921.01,
        "numberOfEmployees": 126,
        "businessStructure": "Partnership",
        "salesTaxExempt": false,
        "priorBankrupcy": false,
        "companyNumber": "12312312312",
        "contactInfo": {
            "firstName": "John",
            "lastName": "John",
            "ssn": "444-55-4422",
            "title": "CEO",
            "percentageOwnership": 55,
            "mailingStreet": "431 State Street",
            "mailingCity": "Minnepolis",
            "mailingStateCode": "MN",
            "mailingPostalCode": "55405",
            "mailingCountryCode": "US",
            "homePhone": "555-332-2221",
            "mobilePhone": "555-332-2124",
            "email": "j@john.com",
            "ownOrRent": "Own",
            "priorBankrupcy": false
        }
    },
    "relationships": [
        {
            "relationshipType": "Business Guarantee",
            "company": {
                "legalCompanyName": "Business Guarantor",
                "dba": "Business Guarantor",
                "fedTaxId": "32-2132112",
                "stateOfIncroporationCode": "MN",
                "billingStreet": "140 Main Street",
                "billingCity": "Saint Paul",
                "billingStateCode": "MN",
                "billingPostalCode": "55124",
                "billingCountryCode": "US",
                "phone": "444-333-1122",
                "fax": "444-333-2000",
                "businessEmail": "b@vv.com",
                "yearBusinessEstablished": 1980,
                "yearsUnderCurrentOwnership": 12,
                "annualSalesRevenue": 100921.01,
                "numberOfEmployees": 126,
                "businessStructure": "Partnership",
                "salesTaxExempt": false,
                "priorBankrupcy": false,
                "companyNumber": "21512312312",
                "contactInfo": {
                    "firstName": "John",
                    "lastName": "Smith",
                    "ssn": "422-55-1222",
                    "title": "CEO",
                    "percentageOwnership": 55,
                    "mailingStreet": "431 State Street",
                    "mailingCity": "Minneapolis",
                    "mailingStateCode": "MN",
                    "mailingPostalCode": "55405",
                    "mailingCountryCode": "US",
                    "homePhone": "555-332-2221",
                    "mobilePhone": "555-332-2124",
                    "email": "j@john.com",
                    "ownOrRent": "Own",
                    "priorBankrupcy": false
                }
            }
        },
        {
            "relationshipType": "Personal Guarantee",
            "person": {
                "firstName": "Dan",
                "lastName": "Brown",
                "ssn": "422-55-1333",
                "title": "CEO",
                "percentageOwnership": 55,
                "mailingStreet": "431 1st Street",
                "mailingCity": "Minneapolis",
                "mailingStateCode": "MN",
                "mailingPostalCode": "55405",
                "mailingCountryCode": "US",
                "homePhone": "555-332-2221",
                "mobilePhone": "555-332-2124",
                "email": "j@john.com",
                "ownOrRent": "Own",
                "priorBankrupcy": false
            }
        }
    ],
    "equipmentList": [
        {
            "vendor": {
                "legalCompanyName": "Vendor Company",
                "dba": "Vendor Company",
                "fedTaxId": "32-212112",
                "stateOfIncroporationCode": "MN",
                "billingStreet": "140 3rd Street",
                "billingCity": "Saint Paul",
                "billingStateCode": "MN",
                "billingPostalCode": "55124",
                "billingCountryCode": "US",
                "phone": "444-555-1122",
                "fax": "444-333-2111",
                "businessEmail": "b1@vv11.com",
                "yearBusinessEstablished": 1980,
                "yearsUnderCurrentOwnership": 12,
                "annualSalesRevenue": 100921.01,
                "numberOfEmployees": 126,
                "businessStructure": "Partnership",
                "salesTaxExempt": false,
                "priorBankrupcy": false,
                "contactInfo": {
                    "firstName": "John",
                    "lastName": "Doe",
                    "ssn": "666-44-5544",
                    "title": "Accountant",
                    "percentageOwnership": 45,
                    "mailingStreet": "431 10th Street",
                    "mailingCity": "Minneapolis",
                    "mailingStateCode": "MN",
                    "mailingPostalCode": "55405",
                    "mailingCountryCode": "US",
                    "mobilePhone": "555-553-2124",
                    "email": "j@john123.com"
                }
            },
            "equipmentType": "New",
            "equipmentCost": 123221.02,
            "equipmentMake": "Black Duck",
            "equipmentModel": "3000 M",
            "equipmentYear": 2017,
            "description": "Awesome truck"
        }
    ]
}

*/