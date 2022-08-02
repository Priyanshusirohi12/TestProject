<!--
 - Created  on 2019-02-26.
 -->

<aura:application description="creditSummaryApp" extends="force:slds" implements="force:hasRecordId">
    <aura:attribute name="oppId" type="String" />
    <c:TC_CreditSummary recordId="{!v.oppId}" inPrintView="{!false}"/>
<!-- For use if referencing Lightning App from Visualforce page TC_CreditSummaryPage
<aura:application access="global" extends="ltng:outApp">
    <aura:dependency resource="c:TC_CreditSummary"/>
    -->
</aura:application>