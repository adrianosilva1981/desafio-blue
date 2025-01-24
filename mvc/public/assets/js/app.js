var app = angular.module('app', []);

app.controller('clientController', function ($scope, $http) {
    $scope.moduleName = 'clients';

    $scope.getClients = () => {
        $http.get('clients').then(
            (response) => {
                console.log(response);
            },
            (error) => {
                console.log(error);
            }
        );
    }
});