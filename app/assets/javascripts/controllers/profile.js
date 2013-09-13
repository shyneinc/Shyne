function ProfileCtrl($scope, Session) {"use strict";

    $scope.user = Session.requestCurrentUser();

    $scope.logout = function() {
        Session.logout();
    };
}

