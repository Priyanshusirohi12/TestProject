public with sharing class TC_CreditApplicationMapperHelper {

	private TC_CreditApplication creditApp;
	private TC_CreditApplicationMapperHelper () {}
	private static Map <String, String> companyTypeMap;

	static {

		companyTypeMap = new Map <String, String> {

			'Partnership' => 'Partnership',
			'Corporation' => 'C Corp',
			null => ''

		};
	}

	public TC_CreditApplicationMapperHelper(TC_CreditApplication creditApp) {
		this.creditApp = creditApp;
	}

	public Account mapApplicationFieldsToCompany (TC_CreditApplication.Business comp) {

		Account acc = new Account ();
		acc.Name = comp.legalCompanyName;
		acc.DBA__c = comp.dba;
		acc.Fed_Tax_ID__c = comp.fedTaxId;
		acc.State_of_Incorporation__c = comp.stateOfIncroporationCode;
		acc.BillingStreet = comp.billingStreet;
		acc.BillingCity = comp.billingCity;
		acc.BillingStateCode = comp.billingStateCode;
		acc.BillingPostalCode = comp.billingPostalCode;
		acc.billingCountryCode = 'US';
		acc.Phone = comp.phone;
		acc.Fax = comp.fax;
		acc.Company_Email__c = comp.businessEmail;
		acc.Inception_Date__c = Date.newInstance(comp.yearBusinessEstablished, 1, 30);
		acc.Years_in_Business__c = comp.yearsUnderCurrentOwnership;
		acc.AnnualRevenue = comp.annualSalesRevenue;
		acc.NumberOfEmployees = comp.numberOfEmployees;
		acc.Company_Type__c = companyTypeMap.get(comp.businessStructure) != null ? companyTypeMap.get(comp.businessStructure) : '' ;
		acc.Sales_Tax_Exempt__c = comp.salesTaxExempt;
		acc.File_Bankruptcy__c = comp.priorBankrupcy;
		acc.External_Id__c = comp.externalId;
		return acc;
	}

	public Opportunity mapApplicationFieldsToOpportunity() {

		List <User> salesRep = new List <User> ([SELECT Id, External_Id__c FROM User WHERE External_Id__c = :creditApp.salesRepId LIMIT 1]);

		Opportunity opp = new Opportunity ();
		opp.Name = String.isEmpty(creditApp.creditAppName) ? creditApp.borrower.legalCompanyName + '-' + System.now().format('YYYY-mm-dd') :creditApp.creditAppName;
		opp.CloseDate = creditApp.closeDate == null ? creditApp.commencementDate : creditApp.closeDate;
		opp.Commencement_Date__c = creditApp.commencementDate;
		String defaultStageName = CreditApplication_API_Setting__c.getInstance() != null && !String.isEmpty(CreditApplication_API_Setting__c.getInstance().Default_Stage_Name__c) ? CreditApplication_API_Setting__c.getInstance().Default_Stage_Name__c : 'Undefined';
		opp.StageName = String.isEmpty(creditApp.stageName) ? defaultStageName : creditApp.stageName;
		opp.AccountId = creditApp.borrower.systemId;
		opp.Term__c = creditApp.desiredTermInMonths;
		if (!salesRep.isEmpty()) {
			opp.OwnerId = salesRep[0].Id;
			opp.SalesRep__c = salesRep[0].Id;
		}

		opp.External_Id__c = creditApp.externalId;

		return opp;
	}

	public Contact mapApplicationFieldsToContact(TC_CreditApplication.ContactInfo contactInfo) {
		Contact con = new Contact ();
		con.FirstName = contactInfo.firstName;
		con.LastName = contactInfo.lastName;
		con.SSN__c = contactInfo.ssn;
		con.Guarantor_Ownership__c = contactInfo.percentageOwnership;
		con.Title = contactInfo.title;
		con.MailingStreet = contactInfo.mailingStreet;
		con.MailingCity = contactInfo.mailingCity;
		con.MailingStateCode = contactInfo.mailingStateCode;
		con.MailingPostalCode = contactInfo.mailingPostalCode;
		con.MailingCountryCode = 'US';//contactInfo.mailingCountryCode;
		con.Phone = contactInfo.homePhone;
		con.MobilePhone = contactInfo.mobilePhone;
		con.Email = contactInfo.email;
		con.Rent_Own__c = contactInfo.ownOrRent;
		con.Filed_Bankruptcy__c = contactInfo.priorBankrupcy != null? contactInfo.priorBankrupcy : false;
		con.External_Id__c = contactInfo.externalId;
		return con;
	}

	public Equipment__c mapApplicationFieldsToEquipment(TC_CreditApplication.Equipment eq) {


		Account vendor = mapApplicationFieldsToCompany (eq.vendor);
		vendor.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor') != null
		? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId() : null;

		if (vendor.External_Id__c != null) upsert vendor External_Id__c;
		else insert vendor;
		eq.vendor.systemId = vendor.Id;

		if (eq.vendor.contactInfo != null){
			Contact vCon = mapApplicationFieldsToContact (eq.vendor.contactInfo);
			vCon.AccountId = vendor.Id;
			if (vCon.External_Id__c != null) upsert vCon External_Id__c;
			else insert vCon;

			eq.vendor.contactInfo.systemId = vCon.Id;
		}

		Equipment__c equip = new Equipment__c ();
		equip.Quantity__c = 1;
		equip.Cost_Per_Unit__c = eq.equipmentCost;
		equip.Vendor__c = eq.vendor.systemId;
		equip.Name = eq.description;
		equip.Opportunity__c = creditApp.systemId;
		return equip;

	}

	public Relationship__c mapApplicationFieldsToRelationship (TC_CreditApplication.Relationship crel) {
		Relationship__c rel = new Relationship__c ();

		if (crel.company != null) {
			Account business = mapApplicationFieldsToCompany (crel.company);

			if (business.External_Id__c != null) upsert business External_Id__c;
			else insert business;

			crel.company.systemId = business.Id;
			rel.Business__c = crel.company.systemId;
			rel.RecordTypeId = Schema.SObjectType.Relationship__c.getRecordTypeInfosByName().get('Corporation') != null
			? Schema.SObjectType.Relationship__c.getRecordTypeInfosByName().get('Corporation').getRecordTypeId() : null;
		}

		if (crel.company != null && crel.company.contactInfo != null) {
			rel.Person__r = mapApplicationFieldsToContact(crel.company.contactInfo);
			insert rel.Person__r;
			rel.Person__c = rel.Person__r.Id;
			crel.company.contactInfo.systemId = rel.Person__c;
		} else if (crel.person != null) {
			Contact person = mapApplicationFieldsToContact(crel.person);
			if (person.External_Id__c != null)
			upsert person External_Id__c;
			else insert person;

			rel.Person__c = person.Id;
			crel.person.systemId = person.Id;
		}

		rel.Relationship_Type__c = crel.relationshipType;

		if (rel.Business__c != null) {
			rel.RecordTypeId = Schema.SObjectType.Relationship__c.getRecordTypeInfosByName().get('Corporation') != null
			? Schema.SObjectType.Relationship__c.getRecordTypeInfosByName().get('Corporation').getRecordTypeId() : null;
		}


		rel.Related_Opportunity__c = creditApp.systemId;
		return rel;
	}

}