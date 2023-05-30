# *NovaTalks Partitioning Tables Migration Guide*

## List of Tables accroding to NC2-517

  * messages
  * conversations
  * dialogs
  * reporting_events
  * team_dialogs
  * user_dialogs
  * inbox_interval
  * team_interval
  * user_csat_interval
  * user_interval
  * user_team_interval

### :white_check_mark: Step 1

Before all doings create a DB backup.

First that we need to know how to recretate Tables
Collect the global settings of working DB Schema. 

Varibale CUSTOMER is Client's Namespace

  ```shell
    CUSTOMER=dev-novait; POD=$(kubectl get pods -n $CUSTOMER  | grep postgres | awk '{print $1}'); \
    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- pg_dump -s -c --no-comments -U ntk-dev-novait-novatalks-svc -d ntk-dev-novait-novatalks \
    -t messages \
    -t conversations \
    -t dialogs \
    -t reporting_events \
    -t team_dialogs \
    -t user_dialogs \
    -t inbox_interval \
    -t team_interval \
    -t user_csat_interval \
    -t user_interval \
    -t user_team_interval \
    | sed -e '/^--/d' > ./$CUSTOMER-$(date +%Y-%m-%dT%H:%M:%S).sql
  ```

### :white_check_mark: Step 2

Read the resulting file and modify SQL queries like in provided examples or create new ones.
Upload script into a Postgres POD and Execute Queries sequentially, for example

  ```shell
    

    kubectl cp $(pwd) $(kubectl get pods -n $CUSTOMER  | grep postgres | awk '{print $1}'):/tmp/${PWD##*/} -n $CUSTOMER -c ntk-$CUSTOMER-postgres

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_messages.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_conversations.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_dialogs.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_reporting_events.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_team_dialogs.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_user_dialogs.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_inbox_interval.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_team_interval.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_user_csat_interval.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_user_interval.sql

    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/partitioned_user_team_interval.sql
  ```

### :white_check_mark: Step 3

Next step will be to create additional resources in DB and beat the table into partitions.
For that purpose we use 3rd party script from [Derkan](https://github.com/derkan/pg_party) with minor syntax modifing.

1. First run a the script below creates needed entities in the DB

  ```shell
    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- bash /tmp/${PWD##*/}/pg_party.sh
  ```
2. Next step to create settings in table settings for pg_party script. It can be done manual or folowing script

  ```shell
    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- psql -U ntk-$CUSTOMER-novatalks-svc -d ntk-$CUSTOMER-novatalks -f /tmp/${PWD##*/}/pg_party_config.sql
  ```

3. The last step is creating partitions according to config table. Just repeat p.1 in this step:

  ```shell
    kubectl exec $POD -n $CUSTOMER -c ntk-$CUSTOMER-postgres \
    -- bash /tmp/${PWD##*/}/pg_party.sh
  ```

### :white_check_mark: Step 4

After all modifications, we need to transfer data from the old table to the new partitioned.
It can be done by 
1. When data is don't much: use copy_data_and_drop_alltables.sql
2. When data is extensive *use only queries like in*: replace_bigdata_examples.sql