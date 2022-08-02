<aura:application description="tc_InvoiceApp"  extends="force:slds" implements="force:hasRecordId">
    <aura:attribute name="oppId" type="String" />
    <c:tc_Invoice recordId="{!v.oppId}"/>
</aura:application>