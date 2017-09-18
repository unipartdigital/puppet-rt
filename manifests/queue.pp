#This manifest was incorporated from:
#
#https://github.com/deadpoint/puppet-rt
#
#Copyright and License
#
#Copyright (C) 2012 Darin Perusich darin@darins.net
#
#Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
#
#http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
#
#
# Definition: rt::queue
#
# Add a request-tracker queue
#
# Notes: queues cannot be removed, only disabled from the gui
#
#

define rt::queue (
  $ensure         = present,
  $description    = "",
  $reply_email    = "",
  $comment_email  = ""
  ) {
  include rt
  include rt::params

  validate_re($ensure, '^present$',
    "${ensure} is not valid. Allowed values are 'present' only.")

  exec { "rt_queue_add_${name}":
    command       => "rt create -t queue set name=\"${name}\" description=\"${description}\" CorrespondAddress=\"${reply_email}\" CommentAddress=\"${comment_email}\"",
    unless        => "rt show -t queue \"${name}\" | grep ^Name: > /dev/null",
    require       => Class["rt::tool"]
  }
}