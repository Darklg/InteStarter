
/* ----------------------------------------------------------
  Shell : Deploy
---------------------------------------------------------- */

(function() {
    'use strict';
    module.exports = {
        intestarter_deploy: {
            command: '. ./actions/deploy.sh'
        },
        intestarter_deploy_zip: {
            command: '. ./actions/deploy_zip.sh'
        }
    };
}());
