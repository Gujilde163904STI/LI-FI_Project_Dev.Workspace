<!--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

|                                                  |Admin|Alpha|Gamma|SQL_LAB|
|--------------------------------------------------|---|---|---|---|
| Permission/role description                      |Admins have all possible rights, including granting or revoking rights from other users and altering other people’s slices and dashboards.|Alpha users have access to all data sources, but they cannot grant or revoke access from other users. They are also limited to altering the objects that they own. Alpha users can add and alter data sources.|Gamma users have limited access. They can only consume data coming from data sources they have been given access to through another complementary role. They only have access to view the slices and dashboards made from data sources that they have access to. Currently Gamma users are not able to alter or add data sources. We assume that they are mostly content consumers, though they can create slices and dashboards.|The sql_lab role grants access to SQL Lab. Note that while Admin users have access to all databases by default, both Alpha and Gamma users need to be given access on a per database basis.||
| can read on SavedQuery                           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can write on SavedQuery                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can read on CssTemplate                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on CssTemplate                         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on ReportSchedule                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on ReportSchedule                      |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on Chart                                |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on Chart                               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on Annotation                           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on Annotation                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on Dataset                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on Dataset                             |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can read on Log                                  |:heavy*check*mark:|O|O|O|
| can write on Log                                 |:heavy*check*mark:|O|O|O|
| can read on Dashboard                            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on Dashboard                           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on Database                             |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can write on Database                            |:heavy*check*mark:|O|O|O|
| can read on Query                                |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can this form get on ResetPasswordView           |:heavy*check*mark:|O|O|O|
| can this form post on ResetPasswordView          |:heavy*check*mark:|O|O|O|
| can this form get on ResetMyPasswordView         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can this form post on ResetMyPasswordView        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can this form get on UserInfoEditView            |:heavy*check*mark:|O|O|O|
| can this form post on UserInfoEditView           |:heavy*check*mark:|O|O|O|
| can show on UserDBModelView                      |:heavy*check*mark:|O|O|O|
| can edit on UserDBModelView                      |:heavy*check*mark:|O|O|O|
| can delete on UserDBModelView                    |:heavy*check*mark:|O|O|O|
| can add on UserDBModelView                       |:heavy*check*mark:|O|O|O|
| can list on UserDBModelView                      |:heavy*check*mark:|O|O|O|
| can userinfo on UserDBModelView                  |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| resetmypassword on UserDBModelView               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| resetpasswords on UserDBModelView                |:heavy*check*mark:|O|O|O|
| userinfoedit on UserDBModelView                  |:heavy*check*mark:|O|O|O|
| can show on RoleModelView                        |:heavy*check*mark:|O|O|O|
| can edit on RoleModelView                        |:heavy*check*mark:|O|O|O|
| can delete on RoleModelView                      |:heavy*check*mark:|O|O|O|
| can add on RoleModelView                         |:heavy*check*mark:|O|O|O|
| can list on RoleModelView                        |:heavy*check*mark:|O|O|O|
| copyrole on RoleModelView                        |:heavy*check*mark:|O|O|O|
| can get on OpenApi                               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can show on SwaggerView                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can get on MenuApi                               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can list on AsyncEventsRestApi                   |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can invalidate on CacheRestApi                   |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can csv upload on Database                       |:heavy*check*mark:|O|O|O|
| can excel upload on Database                     |:heavy*check*mark:|O|O|O|
| can query form data on Api                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can query on Api                                 |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can time range on Api                            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can external metadata on Datasource              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can save on Datasource                           |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can get on Datasource                            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can my queries on SqlLab                         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can log on Superset                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can import dashboards on Superset                |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can schemas on Superset                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can sqllab history on Superset                   |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can publish on Superset                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can csv on Superset                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can slice on Superset                            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can sync druid source on Superset                |:heavy*check*mark:|O|O|O|
| can explore on Superset                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can approve on Superset                          |:heavy*check*mark:|O|O|O|
| can explore json on Superset                     |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can fetch datasource metadata on Superset        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can csrf token on Superset                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can sqllab on Superset                           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can select star on Superset                      |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can warm up cache on Superset                    |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can sqllab table viz on Superset                 |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can available domains on Superset                |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can request access on Superset                   |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can dashboard on Superset                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can post on TableSchemaView                      |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can expanded on TableSchemaView                  |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can delete on TableSchemaView                    |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can get on TabStateView                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can post on TabStateView                         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can delete query on TabStateView                 |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can migrate query on TabStateView                |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can activate on TabStateView                     |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can delete on TabStateView                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can put on TabStateView                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can read on SecurityRestApi                      |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| menu access on Security                          |:heavy*check*mark:|O|O|O|
| menu access on List Users                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on List Roles                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Action Log                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Manage                            |:heavy*check*mark:|:heavy*check*mark:|O|O|
| menu access on Annotation Layers                 |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on CSS Templates                     |:heavy*check*mark:|:heavy*check*mark:|O|O|
| menu access on Import Dashboards                 |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Data                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Databases                         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Datasets                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Charts                            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Dashboards                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on SQL Lab                           |:heavy*check*mark:|O|O|:heavy*check*mark:|
| menu access on SQL Editor                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| menu access on Saved Queries                     |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| menu access on Query Search                      |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| all datasource access on all*datasource*access   |:heavy*check*mark:|:heavy*check*mark:|O|O|
| all database access on all*database*access       |:heavy*check*mark:|:heavy*check*mark:|O|O|
| all query access on all*query*access             |:heavy*check*mark:|O|O|O|
| can write on DynamicPlugin                       |:heavy*check*mark:|O|O|O|
| can edit on DynamicPlugin                        |:heavy*check*mark:|O|O|O|
| can list on DynamicPlugin                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can show on DynamicPlugin                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can download on DynamicPlugin                    |:heavy*check*mark:|O|O|O|
| can add on DynamicPlugin                         |:heavy*check*mark:|O|O|O|
| can delete on DynamicPlugin                      |:heavy*check*mark:|O|O|O|
| can external metadata by name on Datasource      |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can get value on KV                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can store on KV                                  |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can tagged objects on TagView                    |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can suggestions on TagView                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can get on TagView                               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can post on TagView                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can delete on TagView                            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can edit on DashboardEmailScheduleView           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can list on DashboardEmailScheduleView           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can show on DashboardEmailScheduleView           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can add on DashboardEmailScheduleView            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can delete on DashboardEmailScheduleView         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| muldelete on DashboardEmailScheduleView          |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can edit on SliceEmailScheduleView               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can list on SliceEmailScheduleView               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can show on SliceEmailScheduleView               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can add on SliceEmailScheduleView                |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can delete on SliceEmailScheduleView             |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| muldelete on SliceEmailScheduleView              |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can edit on AlertModelView                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can list on AlertModelView                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can show on AlertModelView                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can add on AlertModelView                        |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can delete on AlertModelView                     |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can list on AlertLogModelView                    |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can show on AlertLogModelView                    |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can list on AlertObservationModelView            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can show on AlertObservationModelView            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Row Level Security                |:heavy*check*mark:|O|O|O|
| menu access on Access requests                   |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Home                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Plugins                           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Dashboard Email Schedules         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Chart Emails                      |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Alerts                            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Alerts & Report                   |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| menu access on Scan New Datasources              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can share dashboard on Superset                  |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can share chart on Superset                      |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can this form get on ColumnarToDatabaseView      |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can this form post on ColumnarToDatabaseView     |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can export on Chart                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on DashboardFilterStateRestApi         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on DashboardFilterStateRestApi          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on DashboardPermalinkRestApi           |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on DashboardPermalinkRestApi            |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can delete embedded on Dashboard                 |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can set embedded on Dashboard                    |:heavy*check*mark:|O|O|O|
| can export on Dashboard                          |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can get embedded on Dashboard                    |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can export on Database                           |:heavy*check*mark:|O|O|O|
| can export on Dataset                            |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can write on ExploreFormDataRestApi              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on ExploreFormDataRestApi               |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can write on ExplorePermalinkRestApi             |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on ExplorePermalinkRestApi              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can export on ImportExportRestApi                |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can import on ImportExportRestApi                |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can export on SavedQuery                         |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|
| can dashboard permalink on Superset              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can grant guest token on SecurityRestApi         |:heavy*check*mark:|O|O|O|
| can read on AdvancedDataType                     |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can read on EmbeddedDashboard                    |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can duplicate on Dataset                         |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can read on Explore                              |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can samples on Datasource                        |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can read on AvailableDomains                     |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
| can get or create dataset on Dataset             |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can get column values on Datasource              |:heavy*check*mark:|:heavy*check*mark:|O|O|
| can export csv on SQLLab                         |:heavy*check*mark:|O|O|:heavy*check*mark:|
| can get results on SQLLab                        |:heavy*check*mark:|O|O|:heavy*check*mark:|
| can execute sql query on SQLLab                  |:heavy*check*mark:|O|O|:heavy*check*mark:|
| can recent activity on Log                       |:heavy*check*mark:|:heavy*check*mark:|:heavy*check*mark:|O|
