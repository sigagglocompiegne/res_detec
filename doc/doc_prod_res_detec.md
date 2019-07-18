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


