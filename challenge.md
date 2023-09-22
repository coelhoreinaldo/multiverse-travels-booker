# Multiverse Travels Booker

Este texto documenta a especificação de uma API para planejamento de viagens no universo de Rick and Morty. A api contém apenas um recurso (/travel_plans), que representa um plano de viagem da forma

```json
{
  "id": 1,
  "travel_stops": [1, 2]
}
```

onde cada elemento do array `travel_stops` é o ID de uma localização na [Rick and Morty API](https://rickandmortyapi.com). Para a maior parte das operações, interagir com a API não é necessário, porém, alguns endpoints possuem *query parameters* que modificam suas respostas. Para implementar as funcionalidades atribuídas a esses parâmetros, é preciso utilizar as informações da Rick and Morty API.

É esperado do candidato a implementação da API especificada abaixo, bem como os testes unitários e de integração e a documentação dela. Além disso, **É FUNDAMENTAL QUE O CANDIDATO CRIE UM ARQUIVO docker-compose.yml QUE SUBA A API EM [http://localhost:3000](http://localhost:3000) NA RAIZ DO SEU PROJETO**, pois é a partir desse pressuposto que os testes automatizados são construídos.Se o candidato não fornecer um arquivo docker-compose.yml na raiz do repositório, os testes não executarão com sucesso e o candidato será eliminado.

## Especificação dos endpoints API

### 1. Criação de um novo plano de viagem

- **Endpoint:** POST /travel_plans

- **Exemplo de uso:** POST /travel_plans
  - **Corpo da requisição (Content-Type: application/json):**
    ```json
    {
      "travel_stops": [1, 2]
    }
    ```
  - **Resposta de sucesso (Status: 201, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [1, 2]
    }
    ```

### 2. Obtenção de todos os planos de viagem

- **Endpoint:** GET /travel_plans
- **Query Parameters (opcionais):**

  - optimize (boolean - falso por padrão): Quando verdadeiro, o array de travel_stops é ordenado de maneira a otimizar a viagem.
  - expand (boolean - falso por padrão): Quando verdadeiro, o campo de travel_stops é um array de entidades com informações detalhadas sobre cada parada.

- **Exemplo de uso:** GET /travel_plans
  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    [
      {
        "id": 1,
        "travel_stops": [1, 2]
      },
      {
        "id": 2,
        "travel_stops": [3, 7]
      }
    ]
    ```

- **Exemplo de uso:** GET /travel_plans?optimize=false&expand=true
  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    [
      {
        "id": 1,
        "travel_stops": [
          {
            "id": 1,
            "name": "Earth (C-137)",
            "type": "Planet",
            "dimension": "Dimension C-137"
          },
          {
            "id": 2,
            "name": "Abadango",
            "type": "Cluster",
            "dimension": "unknown"
          }
        ]
      },
      {
        "id": 2,
        "travel_stops": [
          {
            "id": 3,
            "name": "Citadel of Ricks",
            "type": "Space station",
            "dimension": "unknown"
          },
          {
            "id": 7,
            "name": "Immortality Field Resort",
            "type": "Resort",
            "dimension": "unknown"
          }
        ]
      }
    ]
    ```

### 3. Obtenção de um plano de viagem específico

- **Endpoint:** GET /travel_plans/{id}
- **Parâmetros:**

  - {id}: O identificador único do plano de viagem.

- **Query Parameters (opcionais):**

  - optimize (boolean - falso por padrão): Quando verdadeiro, o array de travel_stops é ordenado de maneira a otimizar a viagem.
  - expand (boolean - falso por padrão): Quando verdadeiro, o campo de travel_stops é um array de entidades com informações detalhadas sobre cada parada.

- **Exemplo de uso:** GET /travel_plans/1
  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [1, 2, 3]
    }
    ```

- **Exemplo de uso:** GET /travel_plans/1?optimize=false&expand=true
  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [
        {
          "id": 1,
          "name": "Earth (C-137)",
          "type": "Planet",
          "dimension": "Dimension C-137"
        },
        {
          "id": 2,
          "name": "Abadango",
          "type": "Cluster",
          "dimension": "unknown"
        }
      ]
    }
    ```

### 4. Atualização de um plano de viagem existente

- **Endpoint:** PUT /travel_plans/{id}

- **Parâmetros:**

  - {id}: O identificador único do plano de viagem.

- **Exemplo de uso:** PUT /travel_plans/1

  - **Corpo da requisição (Content-Type: application/json):**

    ```json
    {
      "travel_stops": [4, 5, 6]
    }
    ```

  - **Resposta de sucesso (Status: 200, Content-Type: application/json):**
    ```json
    {
      "id": 1,
      "travel_stops": [4, 5, 6]
    }
    ```

### 5. Exclusão de um plano de viagem existente

- **Endpoint:** DELETE /travel_plans/{id}

- **Parâmetros:**

  - {id}: O identificador único do plano de viagem.

- **Exemplo de uso:** DELETE /travel_plans/1
  - **Resposta de sucesso (Status: 204): Resposta sem corpo**

## Parâmetros Modificadores

Como dito anteriormente, os _query parameters_ `expand` e `optimize` podem ser utilizados para modificar as respostas da API. Ambos podem ser utilizados separadamente ou em conjunto. Esta sessão descreve em detalhes o comportamento de cada um.

### expand

Ao receber esse parâmetro, a API deve expandir as paradas de cada viagem de modo que o campo `travel_stops` deixe de ser um array de inteiros representando os IDs de cada localização e passe a ser um array de objetos da forma

```json
{
  "id": 1,
  "name": "Earth (C-137)",
  "type": "Planet",
  "dimension": "Dimension C-137"
}
```

populado com os dados da respectiva localização registrada na Rick and Morty API sob o dado ID.

### optimize

Ao receber esse parâmetro, a API deve retornar o array de `travel_stops` reordenado com o objetivo de minimizar o número de saltos interdimensionais e organizar as paradas de viagem passando das localizações menos populares para as mais populares. Para tanto, deve-se visitar todas as localizações de uma mesma dimensão antes de se pular para uma localização de outra dimensão.

Dentro de uma mesma dimensão, as localizações devem ser visitadas em ordem crescente de popularidade e, em caso de empate, em ordem alfabética do nome. A popularidade de uma localização é calculada somando a quantidade de episódios em que cada residente dessa localização apareceu.

Para definir a ordem de visita das dimensões, deve ser utilizada a popularidade média de suas localizações. Em caso de empate na popularidade média, ordenar as dimensões em ordem alfabética.

O campo `travel_stops` retornado deve continuar sendo um array de inteiros, ou — no caso do parâmetro `expand` ter sido utilizado conjuntamente — um array de localizações na forma expandida.

Ex: Para as seguintes paradas
```json
[
  {
    "id": "2",
    "name": "Abadango",
    "dimension": "unknown",
    "residents": [
      { "episode": [...1 item], ... }
    ]
  },
  {
    "id": "7",
    "name": "Immortality Field Resort",
    "dimension": "unknown",
    "residents": [
      { "episode": [...5 items], ... },
      { "episode": [...1 item], ... },
      { "episode": [...1 item], ... }
    ]
  },
  {
    "id": "9",
    "name": "Purge Planet",
    "dimension": "Replacement Dimension",
    "residents": [
      { "episode": [...1 item], ... },
      { "episode": [...1 item], ... },
      { "episode": [...1 item], ... },
      { "episode": [...1 item], ... }
    ]
  },
  {
    "id": "11",
    "name": "Bepis 9",
    "dimension": "unknown",
    "residents": [
      { "episode": [...4 items], ... }
    ]
  },
  {
    "id": "19",
    "name": "Gromflom Prime",
    "dimension": "Replacement Dimension",
    "residents": []
  }
]
```
A popularidade de cada localização é:
- Abadango (ID 2): 1
- Immortality Field Resort (ID 7): 7
- Purge Planet (ID 9): 4
- Bepis 9 (ID 11): 4
- Gromflom Prime (ID 19): 0

E a de cada dimensão é:
- unknown: 4.0
- Replacement Dimension: 2.0

Portanto o resultado esperado para uma query com `optimize` e sem `expand` é:
```json
{
  "id": id do travel plan,
  "travel_stops":[19,9,2,11,7]
}
```

**Dica**: as informações necessárias para otimizar e/ou expandir as localizações de um plano de viagens podem ser recuperadas com uma única query _graphql_.

### Funcionalidades adicionais

O candidato deve focar nos requisitos obrigatórios, pois o descumprimento de qualquer um deles acarreta na desclassificação do processo seletivo. Entretanto, se o candidato terminar todos os pontos e ainda dispor de tempo livre, ficam aqui algumas sugestões de funcionalidades adicionais que contam como bônus:

- Implementar um endpoint que retorne imagens de cada localização (Dica: as imagens podem ser obtidas realizando *webscrapping* na [wiki do show](https://rickandmorty.fandom.com/wiki/Rickipedia));
- Implementar um endpoint /travel_plans/{id}/append que adiciona novas paradas à lista já existente;
- Implementar um front-end simples para a aplicação.

---
