/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-22.
 * Description: 
 */

public with sharing class TC_DocusignEnvelopeTemplate {

    public List<EnvelopeTemplate> envelopeTemplates;

    public class EnvelopeTemplate {
        public String templateId;
        public String name;
        public String selected;
        public String description;

        public EnvelopeTemplate(String name, String id) {
            this.name = name;
            this.templateId = id;
        }
    }

}