<!--
 - Created by tamarack on 12/30/19.
 -->

<aura:application description="tc_proposalPDFApp"  extends="force:slds" implements="force:hasRecordId">
    <aura:attribute name="oppId" type="String" />
    <c:tc_proposalPDF recordId="{!v.oppId}"/>
</aura:application>