/**
 * Created by szheng on 2019-07-17.
 */

public without sharing class TC_OnlineApplicationUtility {

    public class CDLQueueable implements Queueable {

        public List<ContentDocumentLink> cdlList;

        public CDLQueueable(List<ContentDocumentLink> cdlList) {
            this.cdlList = cdlList;
        }

        public void execute(QueueableContext context) {
            insert this.cdlList;
        }

    }

}