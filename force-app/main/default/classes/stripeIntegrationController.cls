public class stripeIntegrationController {
    //create a customer from Salesforce to Stripe:
    public static void takeCustomer(){
    	String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
    	HTTP http = new HTTP();   
        HTTPRequest request = new HTTPRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/customers');
        request.setHeader('Content-type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer '+accessToken);
        String Name = 'Pradhyumn bansal';
        String address= 'Dargha bazar';
        String Email = 'PriyanshuSirohi12@gmail.com';
        String description = 'This is customer';
        String body = 'name='+Name+'&address[country]=india&address[state]=Rajasthan&address[city]=Ajmer&email='+Email+'&description='+description;
        //String body = ‘name=Customer&email=abc@gmail.com&description=customer’;
        request.setBody(body);
        HTTPResponse response = new HTTPResponse(); 
        response =  http.send(request);
        System.debug('the status code '+response.getStatusCode());
        System.debug('the body '+response.getBody());   
    }
    
    //Creating the payment method to get the Id
    public static void createPaymentId(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        String body = 'type=card&card[number]=4242424242424242&card[exp_month]=11&card[exp_year]=2024&card[cvc]=314';
        //'type=card';+'&card[number]=5252525252525252&card[exp_month]=12&card[exp_year]=2024&card[cvc]=123';
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setMethod('POST');
        request.setEndPoint('https://api.stripe.com/v1/payment_methods');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody(body);
        HttPResponse response = new HTTPResponse();
        response = http.send(request);  
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());    
    }
	//Now attach this payment method with the customer.
    public static void completePayment(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        String customer_Id ='cus_Ke9iW3Q9WsPOGB';
        String card_Id = 'pm_1JyrQaSJaGTFn6ORdy8AOIBt';
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/payment_methods/'+card_Id+'/attach');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer '+accessToken);
        request.setBody('customer='+customer_Id);   
        HTTPResponse response = new HTTPResponse();
        response = http.send(request);   
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody()); 
    }
    
    // Create the payment Methods of ACH type:
    //Creating card Account Token:
    public static void createAccountToken(){
    	String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
    	HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/tokens');
        request.setHeader('Content-type',  'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer '+accessToken);
        String card = 'card[number]=4242424242424242&card[exp_month]=11&card[exp_year]=2022&card[cvc]=314';
        //String bank = 'bank_account[country]=IN&bank_account[currency]=INR&bank_account[account_holder_name]=Pradhyumn bansal&bank_account[account_holder_type]=Individual&bank_account[routing_number]=11000000000&bank_account[account_number]=000123456789';
        request.setBody(card);
        HTTPResponse response = new HTTPResponse(); 	
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody()); 
    }
    //Now attach this card with the customer using the token id:
    public static void attachAccountWithCustomer(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        String Account_Token = 'tok_1JysYgSJaGTFn6ORsl8G2ugu';
        String customer_Id ='cus_Ke9iW3Q9WsPOGB';
        HTTP h = new HTTP();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/customers/'+customer_Id+'/sources');
        request.setHeader('Content-type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'bearer '+accessToken);
        request.setBody('source='+Account_Token);
        HTTPResponse response = new HTTPResponse();
        response = h.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody()); 
    }
    
    //Verifying the account with the amount
    /*public static void verifyAccount(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        String customer_Id ='cus_Kdo1v36ZzYBfVi';
        String bank_Id = 'ba_1JyWSQSJaGTFn6OR7MvhMO73';  	     
        HTTP http = new HTTP();
        HTTPRequest request = new HttPRequest();
        //request.setMethod('Post');
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/customers/'+customer_Id+'/sources/'+bank_Id+'/verify');
		request.setHeader('Content-type', 'application/x-www-form-urlencoded');
		request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody('amounts[]=32&amounts[]=45');
        HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody()); 
    }*/
    public static void createSource(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/sources');
        request.setHeader('Content-type', 'application/x-www-form-urlencoded');
		request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody('type=ach_credit_transfer&currency=USD&owner[email]=Priyanshusirohi12@gmail.com');
        HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());   
    }
    //attaching source with customer
    public static void attachSource(){
    	String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        String customerId = 'cus_Ke9iW3Q9WsPOGB';
        String sourceId = 'src_1JytSlSJaGTFn6OROeO3BLMj';
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/customers/'+customerId+'/sources');
       	request.setHeader('Content-type', 'application/x-www-form-urlencoded');
		request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody('source='+sourceId);
        HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());   
        
    }
    //create a product
    public static void getProductId(){
    	String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
       	HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/products');
        request.setHeader('content-type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody('name=Gold Special');
        HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());    
    }
    public static void setPrizeOfProduct(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        HTTP http = new HTTP();
        String productId = 'prod_KeBtLCaz9OtP0I';
        HTTPRequest request = new HTTPRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/prices');
        request.setHeader('content-type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer '+accessToken);
        String body = 'unit_amount=10000&currency=INR&recurring[interval]=year&product='+productId;
        //'recurring' => ['interval' => 'year'],
        //amounts[]=32&amounts[]=45
        request.setBody(body);
        HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());    
    }
     public static void setSubscription(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        String priceId = 'price_1JytXRSJaGTFn6ORtDly3mOM';
        String customerId = 'cus_Ke9iW3Q9WsPOGB';
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPrequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/subscriptions');
       	request.setHeader('Content-type', 'application/x-www-form-urlencoded');
		request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody('customer='+customerId+'&items[0][price]='+priceId);
   		HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());    
    }
    public static void setSource(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        String priceId = 'price_1JytXRSJaGTFn6ORtDly3mOM';
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPrequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/checkout/sessions');
       	request.setHeader('Content-type', 'application/x-www-form-urlencoded');
		request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody('success_url=https://example.com/success&cancel_url=https://example.com/cancel&line_items[0][price]='+priceId+'&line_items[0][quantity]=2&mode=payment');
   		HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());    
    }
   public static void createbalancetransaction(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        String customer_Id ='cus_Ke9iW3Q9WsPOGB';
        //String bank_Id = 'ba_1JxUpySJaGTFn6ORWEg5EskW'; 
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPrequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/customers/cus_Ke9iW3Q9WsPOGB/balance_transactions');
        request.setHeader('Content-type', 'application/x-www-form-urlencoded');
		request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody('amount=-500&currency=inr');
        HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());    
    }
    /*public static void createChargeId(){
        String accessToken = 'sk_test_51JRs4iSJaGTFn6ORdAgkmux5wj0G84HEsOrcdt7k3WovDYfhVu2oS8qON2DB8JdVX1udpVYFFVQW7gZ0GQtcvlI300T5AgzJNs';
        //String customer_Id ='cus_Ke9iW3Q9WsPOGB';
        //String bank_Id = 'ba_1JxUpySJaGTFn6ORWEg5EskW'; 
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPrequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/charges');
        request.setHeader('Content-type', 'application/x-www-form-urlencoded');
		request.setHeader('Authorization','Bearer '+accessToken);
        request.setBody('amount=2000&currency=usd&source=tok_visa&description=My First Test Charge');
        HTTPResponse response = new HTTPResponse();
        response = http.send(request);
        System.debug('status code '+response.getStatusCode());
        System.debug('get body '+response.getBody());    
    }*/
}