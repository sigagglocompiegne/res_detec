![picto](/doc/img/Logo_web-GeoCompiegnois.png)

# Documentation des livrables des opérations de détection des réseaux

## Fichiers

### Désignation

|Nom du fichier | Désignation | Géométrie |
|:---|:---|:---|
|geo_detec_operation|Opération de détection de réseaux|Surface 2D|
|geo_detec_point|Point de détection/géoréférencement d'un réseau|Point 2D|
|geo_detec_troncon|Tronçon (cable, canalisation) de détection/géoréférencement d'un réseau|Ligne 2D|
|geo_detec_noeud|Noeud de détection/géoréférencement d'un réseau|Point 2D|
|geo_detec_enveloppe|Enveloppe d'un affleurant de réseau|Surface 2D|
|geo_detec_exclusion|Secteur d'exclusion de détection de réseau|Surface 2D|
|geo_detec_annotation|Annotation|Point 2D|


### Topologie

* un point levé est contenu dans le périmètre de l'opération
* un ouvrage de réseaux (troncon ou noeud) est contenu dans le périmètre de l'opération
* un secteur d'exclusion est contenu dans le périmètre d'une opération
* un point levé est positionné sur un point de construction géométrique d'un ouvrage de réseau (troncon ou noeud)
* un point levé peut constituer un point sécant de la géométrie d'un troncon de réseau
* un noeud de réseau est lié à un tronçon de réseau
* une enveloppe d'un affleurant de réseau contient le noeud de réseau

## Structure des données

### Opération de détection de réseaux

Désigne un périmètre d'opération de géodetection/géoréférencement de réseau

|Attribut | Définition | Type informatique | Obligatoire | Exemple | 
|:---|:---|:---|:---|:---|    
|refope|Référence de l'opération de détection|Texte(80)| x |  |
|typeope|Type d'opération de détection|Texte(2) = Liste "Type d'opération de détection | x | IC |
|natres|Nature du réseau faisant l'objet de l'opération de détection|Texte(7) = Liste "Nature du réseau"| x | MULT |
|mouvrage|Maitre d'ouvrage de l'opération de détection|Texte(80)| x | Commune de ... |
|presta|Prestataire de l'opération de détection|Texte(80)| x | Cabinet ... |
|datedebope|Date du début de l'opération de détection|Date| x | 2019-07-18 |
|datefinope|Date de fin de l'opération de détection|Date| x | 2019-07-24 |
|nomplan|Nom du fichier du plan|Texte(80)| x | plan_1.dwg |
|observ|Observations|Texte(254)| x |  |
|geom|Géométrie de l'objet| Surface 2D | x |  |


### Secteur d'exclusion

Désigne un secteur d''exclusion de géodetection/géoréférencement de réseau

|Attribut | Définition | Type informatique | Obligatoire | Exemple | 
|:---|:---|:---|:---|:---|    
|refope|Référence de l'opération de détection|Texte(80)| x |  |
|refexcope|Référence du secteur d'exclusion dans l'opération de détection|Texte(80)| x |  |
|observ|Observations|Texte(254)| x |  |
|geom|Géométrie de l'objet| Surface 2D | x |  |


### Point levé

Désigne les points de géodetection/géoréférencement du réseau

|Attribut | Définition | Type informatique | Obligatoire | Exemple | 
|:---|:---|:---|:---|:---|    
|refope|Référence de l'opération de détection|Texte(80)| x |  |
|refptope|Référence du point levé dans l'opération de détection|Texte(30)| x | pt2.3 |
|typedetec|Type de géodétection/géoréférencement|Texte(2) = Liste "Type de détection | x | OUV |
|methode|Méthode employée pour la détection|Texte(254)| x | Acoustique |
|natres|Nature du réseau détecté|Texte(7) = Liste "Nature du réseau"| x | ELECECL |
|x|Coordonnée X Lambert 93 (en mètres)| numeric | x | 687186,623 |
|y|Coordonnée Y Lambert 93 (en mètres)| numeric | x | 6924318,527 |
|zgn|Altimétrie Z NGF de la génératrice (supérieure si enterrée, inférieure si aérienne) du réseau (en mètres)| numeric | x | 35,421 |
|ztn|Altimétrie Z NGF du terrain naturel (en mètres)| numeric |  | 36,745 |
|c|Charge sur réseau (en mètres)| numeric |  | 1,324 |
|precxy|Précision absolue en planimètre (en mètres)| numeric | x | 0,152 |
|preczgn|Précision absolue en altimétrie (en mètres)| numeric | x | 0,523 |
|clprecxy|Classe de précision planimétrique (XY)| Texte(1) = Liste "Classe de précision" | x | A |
|clprecz|Classe de précision altimétrique (Z)| Texte(1) = Liste "Classe de précision" | x | B |
|clprec|Classe de précision planimétrique (XY) et altimétrique (Z)| Texte(1) = Liste "Classe de précision" | x | B |
|horodatage|Horodatage détection/géoréfécement du point| Timestamp | x |  |
|geom|Géométrie 2D de l'objet| Point 2D | x |  |

## Liste de code

### Nature de réseau

|Code|Valeur|Code couleur|
|:---|:---|:---|
|00| Non défini | #FFFFFF |
|ELEC| Electricité | #FF0000 |
|ELECECL| Eclairage public | #FF0000 |
|ELECSLT| Signalisation lumineuse tricolore | #FF0000 |
|ELECTRD| Electricité transport/distribution | #FF0000 |
|GAZ| Gaz | #FFFF00 |
|CHIM|Produits chimiques|#F99707|
|AEP|Eau potable|#00B0F0|
|ASS|Assainissement et pluvial|#663300|
|ASSEP|Eaux pluviales|#663300|
|ASSEU|Eaux usées|#663300|
|ASSUN|Réseau unitaire|#663300|
|CHAU|Chauffage et climatisation|#7030A0|
|COM|Télécom|#00FF00|
|DECH|Déchets|#663300|
|INCE|Incendie|#00B0F0|
|PINS|Protection Inondation-Submersion|#663300|
|MULT|Multi réseaux|#FF00FF|

### Classe de précision

|Code|Valeur|Définition|
|:---|:---|:---|
|A| Classe A | Classe de précision inférieure 40 cm |
|B| Classe B | Classe de précision supérieure à 40 cm et inférieure à 1,50 m |
|C| Classe C | Classe de précision supérieure à 1,50 m ou inconnue |

### Type d'opération de détection

|Code|Valeur|Définition|
|:---|:---|:---|
|00| Non renseigné | Non renseigné |
|IC| Investigation complémentaire | Opération menée dans le cadre de travaux par le maitre d'ouvrage |
|OL| Opération de localisation | Opération menée dans le cadre de démarches d'amélioration continue par l'exploitant du réseau |
|99| Autre | Autre |
