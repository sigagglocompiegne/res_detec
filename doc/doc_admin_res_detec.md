![picto](/doc/img/Logo_web-GeoCompiegnois.png)

# Documentation d'administration de la base de données de détection des réseaux

## Classes d'objets

`geo_ptdetec` : Point de détection/géoréférencement 

|Nom attribut | Définition | Type  | NULL |
|:---|:---|:---|:---|  
|idptdetec|Identifiant unique du point de détection dans la base de données|integer|N|
|id|Identifiant unique du prestataire|integer| |
|num|Numéro du point|character varying(30)| |
|insee|Code INSEE|character varying(5)| |
|typelever|geodec/trancheouverte|character varying(2)|N|
|typeres|Type de réseau|character varying(dlqsidqsldjqsld)|N|
|x|Numéro du point|character varying(30)| |
|y|Numéro du point|character varying(30)| |
|zg|Altimétrie de la génératrice supérieure en mètre NGF|dsklqjdlkqsjdklqsjldjlqsjd numeric,3| |
|z|Altimétrie de la génératrice supérieure en mètre NGF|dsklqjdlkqsjdklqsjldjlqsjd numeric,3|O pas possible si fouille ouverte|
|p|Profondeur entre la côte et la cote de la génératrice supérieure en mètre|dsklqjdlkqsjdklqsjldjlqsjd numeric,3|O pas possible si fouille ouverte|
|prest|Nom du prestataire|character varying(80)|N|
|couleur|Code couleur du type de réseau détection sous forme HEXE (#000000)|character varying(7)| | >> déduit typeres
|timestamp|Horodatage du point|Timestamp|N|
|geom|Géométrie de l'objet ponctuel|Point,2154| |

Particularité(s) à noter : code couleur déduit de typeres

---
