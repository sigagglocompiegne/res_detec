![picto](/doc/img/Logo_web-GeoCompiegnois.png)

# Documentation des livrables produits pour les opérations de détection des réseaux

## Fichiers



## Structure des données

### Point levé

Désigne les points de géodetection/géoréférencement du réseau

|Attribut | Définition | Type informatique | dqsd | Exemple | 
|:---|:---|:---|:---|:---|    
|refptope|Référence du point levé dans l'opération de détection|Texte(30)| x | pt2.3 |
|refope|Référence de l'opération de détection|Texte(254)| x | refdecommande |
|insee|Code INSEE de la commmune|Texte(5)| x | 60159 |
|natres|Nature du réseau détecté|Liste Nature du réseau| x | ELECECL |
|x|Coordonnée X Lambert 93 (en mètres)| numeric | x | 687186,623 |
|y|Coordonnée Y Lambert 93 (en mètres)| numeric | x | 6924318,527 |
|z_gn|Altimétrie Z NGF de la génératrice (supérieure si enterrée, inférieure si aérienne) du réseau (en mètres)| numeric | x | 35,421 |
|z_tn|Altimétrie Z NGF du terrain naturel (en mètres)| numeric |  | 36,745 |
|c|Charge sur réseau (en mètres)| numeric |  | 1,324 |
|prec_xy|Précision absolue en planimètre (en mètres)| numeric | x | 0,152 |
|prec_z_gn|Précision absolue en altimétrie (en mètres)| numeric | x | 0,223 |
|clprecxy|Classe de précision planimétrique (XY)| Liste | x | A |
|clprecz|Classe de précision altimétrique (Z)| Liste | x | B |
|clprec|Classe de précision planimétrique (XY) et altimétrique (Z)| Liste | x | B |
|horodatage|Horodatage détection/géoréfécement du point| date | x | dsqdqs |





