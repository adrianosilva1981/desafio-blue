var app = angular.module('app', [])

app.controller('clientController', function ($scope, $http) {
    $scope.loading = true
    $scope.clientes = []

    $scope.getClients = () => {
        $http.get('clients').then(
            (response) => {
                const { data = [] } = response
                $scope.clientes = data
                $scope.loading = false
                M.toast({ html: 'Listagem de clientes atualizada!', classes: 'success' })
            },
            (error) => {
                M.toast({ html: 'Algo de errado ocorreu.<br>Por favor, tente mais tarde.', classes: 'danger' })
            }
        )
    }
});