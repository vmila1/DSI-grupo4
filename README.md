# Recomendaqs

Projeto de desenvolvimento do aplicativo RecomendaQs com a linguagem Dart e framework Flutter. Este é um projeto da disciplina de Projeto Interdisciplinar de Sistemas de Informação III e Desenvolvimento de Sistemas de Informação, ministrados pelos docentes:

- Professor Gabriel Junior
- Professora Maria da Conceição

Os discentes responsáveis pelo desenvolvimento do projeto são:

- Carlos Vinicios
- Leandro dos Santos
- Leon Lourenço
- Vithoria Camila

## Getting Started

O projeto consiste no desenvolvimento de um aplicativo de recomendação de HQs do gênero Comics. Inicialmente, o conjunto de dados é composto majoritariamente por obras da empresa Marvel Comics, e com o decorrer do projeto, outras obras de diferentes universos serão acrescentadas.

As recomendações das HQs são feitas com base na preferência do usuário de obras ou gêneros que ele/ela já conhece e prefere. De acordo com essas preferências, um algoritmo de Machine Learning faz a recomendação das obras.

Além das recomendações personalizadas, o aplicativo conta com as funcionalidades de marcar HQs como favoritas e lidas para facilitar o controle do usuário sobre as obras que ele leu. Além disso, cada HQ possui uma sessão de comentários sobre ela, instigando a interação entre a comunidade.

## Telas do aplicativo

- Na tela da Inicial existem 4 listas de obras:
  - HQs favoritas;
  - Recomendações;
  - Populares;
  - Lançamentos.
  
  Sendo cada uma responsável, respectivamente, por mostrar as HQs favoritas do usuário, mostrar as recomendações que o algoritmo produziu, mostrar as HQs mais vistas por outros usuários e as HQs mais recentes.

- Na tela da Busca (após concluir a implementação, indicar aqui as funcionalidades).
  
- A tela da Perfil contém várias informações do usuário, como seu nome, foto, email, HQs favoritas, HQs lidas e preferências. Dentro dessa tela é possível alterar essas informações e a senha de login, além de poder sair da conta.

- Na tela da HQ serão exibidos o gênero da HQ, produtora, escritor, capa da HQ que ao ser clicada irá redirecionar para o site de compra, preço da HQ em dólar, rating da HQ, sinopse e seção de comentários.

## Tutorial de Uso

### Pré-requisitos

Antes de começar, certifique-se de ter o Flutter e o Dart instalados em sua máquina. Você pode baixá-los em [flutter.dev](https://flutter.dev/docs/get-started/install).

### Download dos Arquivos

1. Faça o download ou clone este repositório para o seu computador.
   ```bash
   git clone https://github.com/seu-usuario/recomendaqs.git
   
### Abrindo no Visual Studio Code (VS Code)
1. Abra o Visual Studio Code (VS Code) e navegue até o diretório do projeto.

2. Certifique-se de que as extensões do Flutter e Dart estão instaladas no VS Code.

3. Abra o terminal no VS Code e execute o seguinte comando para instalar as dependências do projeto:
   ```bash
   flutter pub get

### Executando o Aplicativo
1. Agora, você pode executar o aplicativo usando o comando:
   ```bash
   flutter run
Isso iniciará o aplicativo no seu dispositivo ou emulador conectado.

### Observações
- Certifique-se de ter um emulador Android ou iOS configurado, ou um dispositivo físico conectado via USB.
- Caso não tenha um emulador e use o Windows, no canto direito inferior tem uma opção escrito "Windows(windows-x64), após clicar selecione a opção do Chrome e ajuste o tamanho da janela confome sua preferencia"
- Lembre-se de verificar e instalar as atualizações necessárias para as dependências do Flutter e Dart conforme necessário.

Pronto! Agora você está pronto para explorar e utilizar o aplicativo Recomendaqs em sua estação de trabalho.
