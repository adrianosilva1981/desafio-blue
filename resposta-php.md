# Respostas Desafio Blue

## 1 - Como você otimizaria a consulta SQL abaixo em um banco de dados MySQL?

```sql
    -- original:
    SELECT c.id, concat(f.filial, ' (ID', c.codigo), ')') as desc
    FROM contrato c, filial f
    WHERE c.situacao = 'ativo' AND f.id_f = c.id_f
    group by c.id;

    -- ========================================================================

    -- otimizada
    SELECT DISTINCT(c.id), concat(f.filial, ' (ID', c.codigo), ')') as desc
    FROM contrato c INNER JOIN filial f on c.id_f = f.id_f
    WHERE c.situacao = 'ativo';
```

## 2 - Em um caso de SQL injection como você o previne no caso abaixo:

```php
    // original
    $id = $_GET['id'];

    $data_encerramento = date('Y-m-d');
    $query = "UPDATE contatos SET
        encerramento = '$data_encerramento'
        WHERE id = '" . $id . "' AND encerramento IS NULL";

    (new db)->query($query);

    // ========================================================================

    // sugestão

    try {
        $id = $_GET['id'];
        $data_encerramento = date('Y-m-d');

        $pdo = new PDO("mysql:host=$host;dbname=$dababase", $user, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $query = "UPDATE contatos SET
                    encerramento = :data_encerramento
                  WHERE id = :id AND encerramento IS NULL";

        $stm = $db->prepare($query);
        $stm->bindParam(':data_encerramento', $data_encerramento, PDO::PARAM_STR);
        $stm->bindParam(':id', $id, PDO::PARAM_INT);
        $stm->execute();
    } catch (PDOException $e) {
        die('SQL Error' . $e->getMessage());
    }
```

## 3 - Aplique o conceito MVC para o trecho de código abaixo:

- Resposta na pasta 'mvc'. O arquivo README contém mais detalhes de como executar o código.

## 4 - Qual a sua abordagem para lidar com erros e exceções? Como você garante que os usuários finais recebam mensagens de erro claras e informativas?

- Usando o try-catch no controller que é o ponto de entrada e saída. Assim, se o código que irá lidar com regras de negócio gerar algum erro, está coberto pelo catch da entrada. No caso de APIs, por exemplo, pode-se implementar uma clase de erros customizadas para gerar as mensagens de erro juntamente com o statusCode de retorno. Exemplo:

```php
    // controller.php (ponto de entrada de uma requisição):
    require_once('./models/ContactModel.php');
    require_once('./exceptions/CustomException.php');

    $id = $_GET['id'];

    try {
        // pode-se validar o $id aqui também antes de alcançar o model

        $contatos = new ContactModel();
        $contatos->updateCloseContact($id);
    } catch (CustomException $e) {
        http_response_code($e->statusCode);
        echo json_encode([
            "error" => true,
            "message" => $e->getCustomMessage()
        ]);
    }

    // =======================================================

    // ContactModel.php
    require_once('../exceptions/CustomException.php');

    class ContactModel {

        // (...)

        function __construct() {}

        // (...)

        public function updateCloseContact($id) {
            try {
                $data_encerramento = date('Y-m-d');

                $pdo = new PDO("mysql:host=$host;dbname=$dababase", $user, $password);
                $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

                $query = "UPDATE contatos SET
                            encerramento = :data_encerramento
                        WHERE id = :id AND encerramento IS NULL";

                $stm = $db->prepare($query);
                $stm->bindParam(':data_encerramento', $data_encerramento, PDO::PARAM_STR);
                $stm->bindParam(':id', $id, PDO::PARAM_INT);
                $stm->execute();
            } catch (PDOException $e) {
                throw new CustomException($e->getMessage(), 400);
            }
        }
    }
```

## 5 - Quais aspectos você considera mais importantes ao realizar um code review? Como você fornece feedback construtivo para seus colegas?

- Primeiramente se não há o risco de que a modificação irá afetar outros pontos do código. Após isso é preciso verificar se a lógica usada não é verbosa, ou seja, torna o código de difícil compreensão para outros profissionais usando linhas desnecessárias e nomenclaturas que não deixam claro sua funcionalidade.
- Se por acaso há testes automatizados, o desenvolvedor que está modificando o código precisa deixar claro no pull request as instruções para o teste juntamente com uma descrição do que foi mudado e qual é o propósito da mudança.
- Além de testar o código e tentar diferentes entradas para prever potenciais erros, verificar se a mudança pode ser refatorada a fim de que seja mais otimizada evitando códigos duplicados ou talvez até conferindo se não é necessária a criação de função ou classes para o reuso.
