# Multiverse Travels Booker

Esta API, construída usando Crystal com o framework Kemal para solicitações HTTP e o ORM Jennifer, permite que os usuários criem, encontrem, atualizem e excluam planos de viagem com base em uma lista de paradas. Os usuários podem enviar uma lista de paradas para o serviço, que processa as informações e gera um plano de viagem.

Para acessar informações sobre cada viagem, são feitas solicitações à [API do Rick and Morty](https://rickandmortyapi.com/). A aplicação também inclui testes automatizados escritos usando a biblioteca de testes padrão do Crystal para garantir sua funcionalidade correta.

## Instalação

1. Execute o comando ```docker-compose up -d``` para iniciar o banco de dados e o servidor.

2. Use um framework de sua escolha para fazer solicitações ao servidor. Por exemplo: [Postman](https://www.postman.com/), [Insomnia](https://insomnia.rest/), Thunder Client (plugin do VSCode), etc.

### Requisitos

- Docker
- Ferramentas para fazer solicitações HTTP

## Uso

As solicitações abaixo podem ser feitas para a seguinte URL base: `http://localhost:3000`

### Endpoints

#### 1. Criando um novo plano de viagem

- Endpoint: `POST /travel_plans`

##### Requisição

```json
{
  "travel_stops": [2, 3, 7]
}
```

##### Resposta

```json
{
  "id": 1,
  "travel_stops": [2, 3, 7],
}
```

#### 2. Listando um plano de viagem

- Endpoint: `GET /travel_plans/:id`

##### Resposta

```json
{
  "id": 1,
  "travel_stops": [2, 3, 7],
}
```

#### 3. Listando todos os planos de viagem

- Endpoint: `GET /travel_plans`

##### Resposta

```json
[
  {
    "id": 1,
    "travel_stops": [2, 3, 7],
  },
  {
    "id": 2,
    "travel_stops": [2, 7, 9, 11, 19],
  }
]
```

#### 4. Atualizando um plano de viagem

- Endpoint: `PUT /travel_plans/:id`

##### Requisição

```json
{
  "travel_stops": [4, 6]
}
```

##### Resposta

```json
{
  "id": 1,
  "travel_stops": [4, 6]
}
```

#### 5. Excluindo um plano de viagem

- Endpoint: `DELETE /travel_plans/:id`

##### Resposta

Resposta de sucesso vazia.

#### 6. Adicionando uma parada a um plano de viagem

- Endpoint: `PATCH /travel_plans/:id/append`

##### Requisição

```json
{
  "travel_stop": 5
}
```

##### Resposta

```json
{
  "id": 1,
  "travel_stops": [2, 3, 7, 5]
}
```

### Parâmetros Query

#### expand

- Ao receber este parâmetro, a API expande as paradas para cada viagem, transformando o campo travel_stops de uma lista de inteiros representando os IDs de cada local em uma lista de objetos no seguinte formato, preenchidos com dados do local correspondente registrado na [API do Rick and Morty](https://rickandmortyapi.com/) sob o ID fornecido.

  ```json
  {
    "id": 1,
    "name": "Earth (C-137)",
    "type": "Planet",
    "dimension": "Dimension C-137"
  }
  ```

#### optimize

- Quando habilitado, este parâmetro otimiza a matriz travel_stops para minimizar saltos interdimensionais e organizar as paradas de viagem dos locais menos populares para os mais populares. Para conseguir isso:

- A API visita todos os locais dentro da mesma dimensão antes de saltar para outra dimensão.
- Dentro da mesma dimensão, os locais são classificados por popularidade em ordem crescente. Em caso de empate, eles são classificados alfabeticamente por nome.
- A popularidade é determinada contando o número de episódios em que cada residente desse local aparece.
- As dimensões são visitadas com base na popularidade média de seus locais. Em caso de empate na popularidade média, as dimensões são classificadas alfabeticamente.
- O resultado é retornado no campo travel_stops, que permanece uma lista de inteiros ou, quando usado com o parâmetro expand, uma lista de objetos de local expandidos.

  ```json
  {
    "id": 1,
    "name": "Earth (C-137)",
    "type": "Planet",
    "dimension": "Dimension C-137"
  }

- Endpoint: `GET /travel_plans/1`

```json
{
  "id": 1,
  "travel_stops": [2, 3, 7]
}
```

- Endpoint: `GET /travel_plans/1?optimize=true`

```json
{
  "id": 1,
  "travel_stops": [2, 7, 3]
}
```

- Endpoint: `GET /travel_plans/1?expand=true&optimize=true`

```json
{
  "id": 1,
  "travel_stops": [
    {
      "id": 2,
      "name": "Abadango",
      "dimension": "unknown",
      "type": "Cluster"
    },
    {
      "id": 7,
      "name": "Immortality Field Resort",
      "dimension": "unknown",
      "type": "Resort"
    },
    {
      "id": 3,
      "name": "Citadel of Ricks",
      "dimension": "unknown",
      "type": "Space station"
    }
  ]
}
```

## Development

1. Descomente as linhas no arquivo docker-compose.yml.

2. Execute o seguinte comando para iniciar o banco de dados e o servidor:

```bash
docker-compose up -d
```

3. Entre no contêiner do servidor com este comando:

```bash
docker exec -it app_server sh
```

4. Para criar o banco de dados e executar o servidor, use um dos seguintes comandos:

- Usando o Makefile:

```bash
make run start
```

- Ou manualmente:

```bash
make sam db:setup && crystal src/app.cr
```

## Rodando os testes

Tanto os testes de integração quanto os unitários estão localizados no diretório spec.

Para executar todos os testes do aplicativo, use o seguinte comando:

```bash
make run_tests
# Defina o ambiente de teste, defina a porta como 3001, configure o banco de dados de teste, execute os testes e exclua o banco de dados de teste.
# APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec && APP_ENV=test make sam db:drop
```

Para executar apenas os de integração:

```bash
make run_integration_tests
# Defina o ambiente de teste, defina a porta como 3001, configure o banco de dados de teste, execute os testes de integração e exclua o banco de dados de teste.
# APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec/integration/app_spec.cr && APP_ENV=test make sam db:drop

```

Para executar apenas os unitários:

```bash
make run_unit_tests
# Defina o ambiente de teste, defina a porta como 3001, configure o banco de dados de teste, execute os testes de unidade e exclua o banco de dados de teste.
#APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec/units/travel_plan_service_spec.cr && PORT=3001 KEMAL_ENV=test crystal spec/units/app_unit_spec.cr && APP_ENV=test make sam db:drop
```

## Autor

- [coelhoreinaldo](https://github.com/your-github-user) - criador e mantenedor
