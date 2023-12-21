// initialize_firestore_data.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> initializeApp() async {
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;

  // Dados de teste
  final List<Map<String, dynamic>> hqsData = [
    {
      'ID': 1,
      'nomeQuadrinho': "Wolverine Origins (2006) #31",
      'imagem': "https://m.media-amazon.com/images/I/51uTp8tHrJL._SY342_.jpg",
      'generoQuadrinho': "Superhero",
      'produtoraQuadrinho': "Marvel",
      'nomePersonagem': "Wolverine",
      'anolançamento': "24-12-2008",
      'preco': "1.61",
      'link':
          "https://www.amazon.com.br/Wolverine-Origins-English-Daniel-Way-ebook/dp/B00ZMR18YI",
      'avaliacao': "0.0",
      'resumo':
          "A EMPRESA FAMILIAR PARTE 1 Daken descobriu que quase toda a sua vida e sua concepção da realidade foram cuidadosamente elaboradas por uma figura sombria. Agora, ele e Wolverine se unem para rastrear o ser mais temível que Daken já conheceu."
    },
    {
      'ID': 2,
      'nomeQuadrinho': "X-Treme X-Men # 1",
      'imagem':
          "https://images.universohq.com/2014/02/xtreme_xmen01-195x300.jpg",
      'generoQuadrinho': "Superhero",
      'produtoraQuadrinho': "Marvel",
      'nomePersonagem': "X-Men",
      'anolançamento': "09-05-2001",
      'preco': "11.17",
      'link':
          "https://www.amazon.com.br/X-Treme-X-Men-Vol-Destiny-2001-2003-ebook/dp/B01BCP8JYA/ref=tmm_kin_swatch_0?_encoding=UTF8&qid=&sr=",
      'avaliacao': "0.00",
      'resumo':
          "Os X-Men estão em Valência, Espanha, onde todos são atacados pelas forças da guarda local. Rogue é atirado no mar, enquanto Storm, Bishop, Beast, Psylocke e Thunderbird são capturados; apenas Sage consegue escapar. A Vice-Ministra da Justiça chega à base de alta tecnologia da guarda onde é recebida pelo comandante. Ele conta a ela sobre os testes e diagnósticos que estão realizando na equipe dos X-Men. Enquanto isso, Vargas e seus capangas matam alguns policiais locais que esperam capturar Rogue quando ela chega à costa. O resto da equipe acorda em um labirinto e após uma curta batalha cai em um buraco no chão."
    },
    {
      'ID': 3,
      'nomeQuadrinho': "Venom (2011) #21",
      'imagem':
          "https://cdn.marvel.com/u/prod/marvel/i/mg/9/90/58de830f61aa8/detail.jpg",
      'generoQuadrinho': "Anti-hero",
      'produtoraQuadrinho': "Marvel",
      'nomePersonagem': "Venom",
      'anolançamento': "25-07-2012",
      'preco': "1.61",
      'link':
          "https://www.amazon.com.br/Venom-2011-2013-English-Cullen-Bunn-ebook/dp/B00ZMW9NYA",
      'avaliacao': "0.00",
      'resumo':
          "Toxina vs. Veneno! A última resistência de Flash Thompson! O Mestre do Crime Triunfante! - É do Savage Six Finale que o mundo dos quadrinhos vai falar! A IDENTIDADE DO MESTRE DO CRIME É REVELADA - e as vidas de Flash Thompson e Betty Brant nunca mais serão as mesmas!"
    },
    {
      'ID': 4,
      'nomeQuadrinho': "Spectacular Spider-Man (2003) #10",
      'imagem': "https://m.media-amazon.com/images/I/91FDgkomKrL._SY466_.jpg",
      'generoQuadrinho': "Superhero",
      'produtoraQuadrinho': "Marvel",
      'nomePersonagem': "Homem-aranha",
      'anolançamento': "25-02-2004",
      'preco': "2.25",
      'link':
          "https://www.amazon.com.br/Spectacular-Spider-Man-2003-2005-10-English-ebook/dp/B01M010I0N",
      'avaliacao': "0.00",
      'resumo':
          "Spidey e Doc Ock se enfrentam em um confronto titânico e cheio de ação! Mas será que o rastreador de paredes será forçado a revelar a sua verdadeira identidade para preservar a paz mundial?"
    },
    {
      'ID': 5,
      'nomeQuadrinho': "New Invaders (2004)",
      'imagem': "https://m.media-amazon.com/images/I/91oM0SgT6iL._SY466_.jpg",
      'generoQuadrinho': "Superhero",
      'produtoraQuadrinho': "Marvel",
      'nomePersonagem': "Invasores",
      'anolançamento': "18-08-2004",
      'preco': "2.25",
      'link':
          'https://www.amazon.com.br/New-Invaders-2004-2005-1-English-ebook/dp/B01MV1SVSF',
      'avaliacao': "0.00",
      'resumo':
          "Soldados, Super-Heróis, Sentinelas da Liberdade desde a Segunda Guerra Mundial – eles são os INVASORES e estão de volta! Jim Hammond, o Tocha Humana original, retorna para liderar os INVASORES em uma missão secreta para impedir que uma misteriosa célula terrorista ressuscite o monstruoso mal adormecido nas profundezas do Mar Arábico."
    }
  ];

  // Adicione os dados ao Firestore
  for (int i = 0; i < hqsData.length; i++) {
    await firestore.collection('HQs').add(hqsData[i]);
  }

  print("Dados adicionados ao Firestore com sucesso!");
}

Future<void> main() async {
  await initializeApp();
}
