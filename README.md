# tartapain

  

  

Une application de click and collect pour une boulangerie

  

  

## Getting Started

  

  

Ce projet est à la fois un projet professionnel ainsi que un projet d'école

  

j'ai utilisé pour ce projet toute les informations ci dessous

  

- [Flutter website](https://flutter.dev)

- [Flutter docs](https://flutter.dev/docs)

- [StackOverflow](https://stackoverflow.com/)

  
  

### Page de détails

J'ai tout d'abord commencé par créer l'interface de ma page de détails

![enter image description here](https://i.ibb.co/QJWdMtq/Screenshot-20210207-214604.jpg)

  

que j'ai ensuite connectée avec les différentes informations de mon api pour pouvoir aller chercher dynamiquement sur ma BDD les informations du produit relatif à mon id du produit

  
  

    Future<Produits> fecthProduits(id, type, api) async {
    String url = 'http://tartapain.bzh/api/apps/produits.php?id=' +
    id.toString() +
    '&type=' +
    
    type +
    
    '&api=' +
    
    api;
    
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
    
    return Produits.fromJson(json.decode(response.body));
    
    } else {
    
    throw Exception('Failed to load the post');
    
    }

J'arrive donc à personnaliser ma page de détails en relation à mon id de produit

  

### page d’accueil

  

Je travaille ensuite sur mon interface de page d’accueil avec des cards défilants

Je crée donc plusieurs widget Custom pour arriver à mieux gérer la génération de ma view grâce à des appels sur mon api, ce qui donne un résultat comme celui ci

![Github ne me permet pas de mêtre cet gif de presentation je vous met le lient ici](https://i.ibb.co/0yfXXxh/ezgif-7-c86604f56ac1.gif)

https://i.ibb.co/0yfXXxh/ezgif-7-c86604f56ac1.gif

  

Comme on peut le voir juste ici tout les produits sont automatiquement récupérés sur mon api pour avoir une synchronisation avec ma BDD.
Tout est customisable comme vous pouvez le voir sur mon code
