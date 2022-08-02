<aura:application description="tc_docRequestFormApp"  extends="force:slds" implements="force:hasRecordId">
    <aura:attribute name="oppId" type="String" />
    <c:tc_docRequestForm recordId="{!v.oppId}"/>
</aura:application>