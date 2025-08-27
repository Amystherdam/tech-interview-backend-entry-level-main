# Shopping Cart 🛒

![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)![Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)![Postgres](https://img.shields.io/badge/postgresql-4169e1?style=for-the-badge&logo=postgresql&logoColor=white)

Olá! Obrigado por disponibilizar um pouco do seu tempo. Abaixo estão todas as informações que você precisa sobre o projeto, desde testar manualmente até a documentação geral. Se trata de uma API que

- Lista produtos de um carrinho de compras
- Adiciona novos produtos em um carrinho de compras
- Modifica a quantidade de unidades de um produto do carrinho
- Exclui produtos do carrinho de compras
- Monitora carrinhos de compra abandonados e destroy os mais velhos

Agora vamos falar um pouco sobre a estrutura do projeto. No fim das contas terminou com 3 models e também um serializador muito importante para a formatação de mensagens

- CartItem
- Cart
- Product
- CartSerializer

## Gestão do projeto

Houveram PR's para todas as modificações na aplicação e todo PR teve uma issue ligeiramente documentada com descrições de problemas e checklists de resolução.

## Versões

- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15
- Mais informações de versões no `Gemfile` e no `Gemfile.lock`

## Modelos e regra de negócio

Não acho que vale a pena se extender muito nessa parte, pois, a documentação original desse projeto já contém todas as informações necessárias e eu tentei seguir o máximo possível

### seeds.rb

O arquivo estava populado com produtos e ele é chamado em um script de bash chamado `setup_app.sh` ao executar o docker-compose

## API

A API conta com um arquivo chamado `store.postman_collection.json`, ele documenta todas as variáveis e os endpoints já montados para você conferir se utilizar o [Postman](https://www.postman.com/).

## Docker

A aplicação está rodando com docker. Existem dois arquivos `.yml`, o próprio `docker-compose.yml` e o `docker-compose.test.yml`

O último roda justamente os testes, decidi separar para não ter que lidar com alguns conflitos com secrets e variáveis
O compose principal tem todas as configurações pertinente como `redis`, `sidekiq`, banco de dados e etc

### Rodando o projeto

Para rodar a API web basta executar o docker-compose.yml

```
docker-compose up --build
```

Ou com flag `-d` para segundo plano

Para rodar a suite de testes, você pode executar

```
docker-compose -f docker-compose.test.yml up --build --exit-code-from rspec
```

Rode em primeiro plano para ver a CI executando

## Adicionais

Foi implementado um arquivo de CI para o github actions que roda linters, testes e verifica saúde da aplicação a cada PR enviado e também na branch `main`

## Agradecimento

Foi um prazer escrever essa doc pra você, obrigado por ler até aqui, estou a disposição para o que precisar! 💎🎉🙂
