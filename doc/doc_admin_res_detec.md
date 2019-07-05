![picto](/doc/img/Logo_web-GeoCompiegnois.png)

# Documentation d'administration de la base de données de détection des réseaux

## Classes d'objets


`geo_opedetec` : Emprise de l'opération de détection des réseaux

|Nom attribut | Définition | Type  | NULL |
|:---|:---|:---|:---|  
|idopedetec|Identifiant unique de l'opération de détection dans la base de données|integer|N|
|id|Identifiant unique du prestataire|integer| |
|ref|Référence de l'opération de détection|character varying(80)|N|
|dateope|Date de l'opération de détection|character varying(80)|N|
|presta|Nom du prestataire|character varying(80)|N|
|moa|Nom du maitre d'ouvrage de l'opération de détection de réseau|character varying(80)|N|
|geom|Géométrie de l'objet|Polygon,2154| |

Particularité(s) à noter : 

---


`geo_ptdetec` : Point de détection/géoréférencement 

|Nom attribut | Définition | Type  | NULL |
|:---|:---|:---|:---|  
|idptdetec|Identifiant unique du point de détection dans la base de données|integer|N|
|id|Identifiant unique du prestataire|integer| |
|num|Numéro du point|character varying(30)| |
|insee|Code INSEE|character varying(5)| |
|typelever|geodec/trancheouverte|character varying(2)|N|
|typeres|Type de réseau|character varying(dlqsidqsldjqsld)|N|
|xgn|Coordonnée X de la génératrice supérieure du réseau (Lambert 93)|dqsdqsdqsdqsd|N|
|ygn|Coordonnée Y de la génératrice supérieure du réseau (Lambert 93)|dqsdqsdqsdqsd|N|
|zgn|Altimétrie de la génératrice supérieure du réseau en mètre NGF|dsklqjdlkqsjdklqsjldjlqsjd numeric,3| |
|z|Altimétrie en mètre NGF|dsklqjdlkqsjdklqsjldjlqsjd numeric,3|O pas possible si fouille ouverte|
|p|Profondeur entre la côte et la cote de la génératrice supérieure en mètre|dsklqjdlkqsjdklqsjldjlqsjd numeric,3|O pas possible si fouille ouverte|
|presta|Nom du prestataire|character varying(80)|N|
|moa|Nom du maitre d'ouvrage de l'opération de détection de réseau|character varying(80)|N|
|couleur|Code couleur du type de réseau détection sous forme HEXE (#000000)|character varying(7)| | >> déduit typeres
|timestamp|Horodatage du point|Timestamp|N|
|geom|Géométrie de l'objet|Point,2154| |

Particularité(s) à noter : code couleur déduit de typeres

---
