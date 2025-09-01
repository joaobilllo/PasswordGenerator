
# PasswordGenerator

Este repositório contém um gerador de senhas seguro e personalizável, desenvolvido em Flutter. O código principal do projeto está localizado na pasta `lib`.

## Estrutura dos Arquivos Principais

- **lib/services/password_service.dart**
	- Serviço responsável por gerar senhas seguras a partir dos dados fornecidos pelo usuário (serviço, usuário, frase-base, opções de composição e algoritmo de hash).
	- Permite customizar o comprimento, uso de maiúsculas, números, símbolos e algoritmo (MD5, SHA-1, SHA-256).

- **lib/widgets/password_form.dart**
	- Widget de formulário principal da aplicação.
	- Coleta os dados do usuário, valida as entradas, permite escolher as opções de senha e exibe o resultado gerado.
	- Permite copiar a senha gerada para a área de transferência.

- **lib/utils/validators.dart**
	- (Opcional) Contém funções auxiliares para validação de campos do formulário.

## Principais Classes e Suas Funções

- **PasswordService** (`lib/services/password_service.dart`)
	- Classe responsável por toda a lógica de geração de senhas seguras. Possui método estático `generate` que recebe os parâmetros do usuário e retorna a senha gerada conforme as opções escolhidas.

- **PasswordForm** (`lib/widgets/password_form.dart`)
	- Widget de formulário (interface) que permite ao usuário inserir os dados necessários para gerar a senha. Gerencia o estado dos campos, validações e interação com o serviço de geração.

- **_PasswordFormState** (`lib/widgets/password_form.dart`)
	- Classe interna (privada) que implementa o estado e a lógica do formulário, incluindo validação, chamada ao serviço e exibição do resultado.

- **Funções auxiliares de validação** (`lib/utils/validators.dart`)
	- Funções utilitárias para validar campos do formulário, como checar se um campo está vazio, se a senha atende critérios mínimos, etc.

## Como usar

1. Instale as dependências do projeto:
	 ```sh
	 flutter pub get
	 ```
2. Execute o app em um emulador ou dispositivo físico:
	 ```sh
	 flutter run
	 ```

