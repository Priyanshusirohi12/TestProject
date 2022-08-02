<aura:application extends="force:slds" implements="force:hasRecordId">
    <aura:attribute name="recordId" type="String"/>
    <div class="slds-m-around_large">
   
    <c:greenDoorFilelist recordId="{!v.recordId}"/>
    </div>
</aura:application>