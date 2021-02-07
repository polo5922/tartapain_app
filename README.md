# tartapain

  

Une application de click and collect pour une boulangerie

  

## Getting Started

  

Ce projet est a la fois un projet professionnel ainsi que un projet d'école 

j'ai utilisé pour ce projet toute les information ci dessous

 - [Flutter website](https://flutter.dev) 
 -  [Flutter docs](https://flutter.dev/docs) 
 - [StackOverflow](https://stackoverflow.com/)


### Page de detail
J'ai tout d'abord commencé par crée l'interface de ma page de detail 
 ![enter image description here](https://i.ibb.co/QJWdMtq/Screenshot-20210207-214604.jpg)

Que j'ai ensuite connectée avec les differentes information de mon api pour pouvoir allez chercher dynamiquement sur ma dbb les infromations du produits relatif a mon id de produit 


    Future<Produits> fecthProduits(id, type, api) async {
    String url = 'http://tartapain.bzh/api/apps/produits.php?id=' +
    id.toString() +
    '&type=' +
    type +
    '&api=' +
    api;
    final response = await http.get(url);
    if (response.statusCode == 200) {
    return  Produits.fromJson(json.decode(response.body));
    } else {
    throw  Exception('Failed to load the post');
    }
J'arrive donc a personnaliser ma page de detail relativement par rapport a mon id de produit 

### page d'acceuil  

je travaille ensuite sur mon interface de page d'acceuil avec des card defilant 
je crée donc plusieur widget Custom pour arriver a mieux gerer la generation de ma view grace a des appel sur mon api ce qui donne un resultat comme celui ci
![enter image description here](https://i.ibb.co/0yfXXxh/ezgif-7-c86604f56ac1.gif)  

Comme on peut le voir juste ici tout les produits sont automatiquement récuperer sur mon api pour avoir une syncronisation avec ma BDD et tout est customisable comme vous pouvez le voir sur mon code 