# Desafio Blue Service

## Instruções:

- As respostas escritas estão no arquivo `resposta-sql.md` e `resposta-php.md`

## Pré-requisitos:

- Docker
- PHP 8
- Composer

## Executando o código:

Subir o container MariaDB:

```bash
$ docker-compose up -d
```

Navegar até a pasta mvc:

```bash
$ cd mvc
```

Instalar as dependências:

```bash
$ composer install
```

Executar o servidor local:

```bash
$ php -S localhost:8080 -t public/
```

Abrindo o navegador, a listagem de clientes pode ser visualizada em:
[http://localhost:8080/](http://localhost:8080/)
