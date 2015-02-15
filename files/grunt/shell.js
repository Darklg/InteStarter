var mod = {};

/* ----------------------------------------------------------
  Shell : Deploy
---------------------------------------------------------- */

(function() {
    'use strict';
    mod = {
        intestarter_deploy: {
            command: '. ./actions/deploy.sh'
        },
        intestarter_deploy_zip: {
            command: '. ./actions/deploy_zip.sh'
        }
    };
}());

module.exports = mod;

