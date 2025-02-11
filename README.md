# Orders SW

## Como Rodar o Projeto

Para rodar o projeto, siga os passos abaixo:

1. **Clone o repositório**:
   ```sh
   git clone https://github.com/gabrielscr/orders_sw.git
   cd orders_sw

2. Instale as dependências:
    ```sh
    flutter pub get

3. Configure um dispositivo ou emulador: Certifique-se de que você tem um dispositivo físico conectado ou um emulador configurado.

4. Execute o aplicativo:
    ```sh
    flutter run

5. Rodar testes: Para rodar os testes, utilize o comando:
    ```sh
    flutter test
    

Este é um projeto Flutter para o aplicativo Orders SW. O projeto utiliza várias bibliotecas e padrões de design MVVM para garantir uma arquitetura limpa e escalável.

## Estrutura do Projeto

A estrutura do projeto é organizada da seguinte forma:

lib/
├── src/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── constants.dart
│   │   ├── design_system/
│   │   │   ├── custom_text_form_field.dart
│   │   │   ├── loading_overlay.dart
│   │   ├── exception/
│   │   │   ├── status_code.dart
│   │   ├── external/
│   │   │   ├── network/
│   │   │   │   ├── token_interceptor.dart
│   │   ├── injection/
│   │   │   ├── default/
│   │   │   │   ├── usecases_injections.dart
│   │   │   ├── log/
│   │   │   │   ├── log.dart
│   │   │   │   ├── log_scope.dart
│   │   ├── route/
│   │   │   ├── global_keys.dart
│   │   │   ├── route_path.dart
│   │   ├── utils/
│   │   │   ├── utils.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user_token.dart
│   │   │   │   │   ├── user_token_request.dart
│   │   │   │   ├── services/
│   │   │   │   │   ├── token_service.dart
│   │   │   │   ├── usecases/
│   │   │   │   │   ├── generate_refresh_token_usecase.dart
│   │   │   │   │   ├── generate_token_usecase.dart
│   │   │   │   │   ├── get_user_usecase.dart
│   │   │   │   │   ├── restore_session_usecase.dart
│   │   │   │   │   ├── revoke_token_usecase.dart
│   │   │   ├── presentation/
│   │   │   │   ├── provider/
│   │   │   │   │   ├── auth_provider.dart
│   │   │   │   │   ├── auth_state.dart
│   │   │   │   ├── views/
│   │   │   │   │   ├── auth_view.dart
│   │   │   │   │   ├── splash_view.dart
│   │   ├── order/
│   │   │   ├── domain/
│   │   │   │   ├── usecases/
│   │   │   │   │   ├── create_order_usecase.dart
│   │   │   │   │   ├── finish_order_usecase.dart
│   │   │   │   │   ├── get_orders_usecase.dart

### Dependências

As dependências utilizadas no projeto são:

- **flutter**: SDK do Flutter.
- **dio**: Biblioteca para requisições HTTP.
- **get_it**: Biblioteca para injeção de dependências.
- **dartz**: Biblioteca para programação funcional.
- **equatable**: Biblioteca para comparação de objetos.
- **flutter_secure_storage**: Biblioteca para armazenamento seguro.
- **intl**: Biblioteca para internacionalização.
- **provider**: Biblioteca para gerenciamento de estado.
- **go_router**: Biblioteca para navegação.

### Lógica de Autenticação

A lógica de autenticação é implementada utilizando o padrão de design `Provider` para gerenciamento de estado e `Dio` para requisições HTTP. A autenticação inclui a geração de tokens de acesso e atualização, bem como a interceptação de requisições para garantir que o token de acesso seja válido.

### TokenInterceptor
O TokenInterceptor é responsável por interceptar requisições HTTP e garantir que o token de acesso seja válido. Se o token de acesso expirar, ele tenta atualizar o token.

### Logs de Debug
Os logs de debug são gerenciados pela classe Log e LogScope. Eles são utilizados para registrar informações importantes durante a execução do aplicativo, como requisições HTTP, respostas e erros.

### Camadas da Aplicação
A aplicação é organizada em várias camadas para garantir uma separação clara de responsabilidades e facilitar a manutenção e escalabilidade.

#### Camada de Apresentação
Responsável pela interface do usuário e interação com o usuário. Inclui widgets, telas e provedores de estado.

#### Camada de Domínio
Contém a lógica de negócios e regras de negócio. Inclui entidades, casos de uso e serviços.

#### Camada de Dados
Responsável pelo acesso a dados, seja de uma API, banco de dados local ou outras fontes de dados. Inclui repositórios e fontes de dados.

#### Camada de Core
Contém código compartilhado entre diferentes partes da aplicação, como utilitários, constantes, injeção de dependências e configuração de rede.