-- TP 2_04
-- Nom:  Baba, Prenom: Ahmet


-- +------------------+--
-- * Question 1 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  La liste des objets vendus par ght1ordi au mois de février 2023


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +----------+----------------------+
-- | pseudout | nomob                |
-- +----------+----------------------+
-- | ght1ordi | Scie comme neuve     |
-- | ght1ordi | Chemise jamais servie|
-- | ght1ordi | Pantalon jaune       |
-- | ght1ordi | Chapeau rouge        |
-- +----------+----------------------+
-- = Reponse question 1.

select pseudoUt,nomOb from UTILISATEUR
NATURAL JOIN OBJET NATURAL JOIN VENTE 
join STATUT on VENTE.idSt=STATUT.idSt
where MONTH(finVe)=2 and YEAR(finVe)=2023 and pseudoUt="ght1ordi" and nomSt="Validée";






-- +------------------+--
-- * Question 2 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  La liste des utilisateurs qui ont enchérit sur un objet qu’ils ont eux même mis en vente


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +-----------+
-- | pseudout  |
-- +-----------+
-- | pykyven800|
-- | nuko      |
-- +-----------+
-- = Reponse question 2.

select pseudoUt from UTILISATEUR 
NATURAL JOIN OBJET NATURAL JOIN VENTE v
where idUt in (select idUt from ENCHERIR e WHERE e.idVe=v.idVe);




-- +------------------+--
-- * Question 3 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  La liste des utilisateurs qui ont mis en vente des objets mais uniquement des meubles


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +-------------+
-- | pseudout    |
-- +-------------+
-- | etc...
-- = Reponse question 3.


select distinct pseudoUt from UTILISATEUR
WHERE idUt not in (select idUt from OBJET NATURAL JOIN VENTE natural join CATEGORIE WHERE nomCat !="Meuble")
and idUt in (select idUt from OBJET NATURAL JOIN VENTE natural join CATEGORIE WHERE nomCat ="Meuble");




-- +------------------+--
-- * Question 4 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  La liste des objets qui ont généré plus de 15 enchères en 2022


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +------+----------------------+
-- | idob | nomob                |
-- +------+----------------------+
-- | etc...
-- = Reponse question 4.

select idOb,nomOb from OBJET NATURAL JOIN VENTE
where idVe in (select idVe from VENTE NATURAL JOIN ENCHERIR 
WHERE year(dateheure)=2022
group by idVe having count(idVe)>15) and year(finVe)=2022;



-- +------------------+--
-- * Question 5 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  Ici NE CREEZ PAS la vue PRIXVENTE mais indiquer simplement la requête qui lui est associée.
--  C'est à dire la requête permettant d'obtenir pour chaque vente validée, l'identifiant de la vente l'identiant de l'acheteur et le prix de la vente.


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +------+------------+----------+
-- | idve | idacheteur | montant  |
-- +------+------------+----------+
-- | etc...
-- = Reponse question 5.


-- create or replace view PRIXVENTE(idVe,idacheteur,montant) as

select idVe,idUT as idacheteur,max(montant) as montant from ENCHERIR v
natural join VENTE
join STATUT on VENTE.idSt=STATUT.idSt
where nomSt="Validée"
group by idVe,idUT
having montant >=(select max(montant) from ENCHERIR e where v.idVe=e.idVe);


-- +------------------+--
-- * Question 6 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  Le chiffre d’affaire par mois de la plateforme (en utilisant la vue PRIXVENTE)


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +------+-------+-----------+
-- | mois | annee | ca        |
-- +------+-------+-----------+
-- | etc...
-- = Reponse question 6.

-- le *0.05 correspond au benefice que tire l'application à chaque vente

create or replace view PRIXVENTE(idVe,idacheteur,montant) as
    select idVe,idUT as idacheteur,max(montant) as montant from ENCHERIR v
    natural join VENTE
    join STATUT on VENTE.idSt=STATUT.idSt
    where nomSt="Validée"
    group by idVe,idUT
    having montant >=(select max(montant) from ENCHERIR e where v.idVe=e.idVe);



select Month(finVe) mois,year(finVe) annee,sum(montant*0.05) as ca
from PRIXVENTE
natural join VENTE
group by mois,annee
order by annee,mois;








-- +------------------+--
-- * Question 7 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  Les informations du ou des utilisateurs qui ont mis le plus d’objets en vente


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +------+----------+------+
-- | idut | pseudout | nbob |
-- +------+----------+------+
-- | etc...
-- = Reponse question 7.
--
select idUT,pseudoUt,count(idOb) as nbOb from UTILISATEUR
NATURAL JOIN OBJET NATURAL JOIN VENTE
group by idUt having
count(idOb) >= all(select count(idOb) from OBJET NATURAL JOIN VENTE group by idUt);


-- +------------------+--
-- * Question 8 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  le camembert


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +-------+-------------------+-----------+
-- | idcat | nomcat            | nb_objets |
-- +-------+-------------------+-----------+
-- |     1 | Vêtement          |       110 |
-- |     2 | Ustensile Cuisine |        57 |
-- |     3 | Meuble            |       105 |
-- |     4 | Outil             |       110 |
-- +-------+-------------------+-----------+
-- 4 rows in set (0,01 sec)
-- = Reponse question 8.




select idCat as idcat,nomCat as nomcat,count(idVe) as nb_objets
from CATEGORIE natural join OBJET natural join VENTE
join STATUT on VENTE.idSt=STATUT.idSt
WHERE nomSt="Validée" and YEAR(finVe)=2022
group by idCat;






-- +------------------+--
-- * Question 9 :     --
-- +------------------+--
-- Ecrire une requête qui renvoie les informations suivantes:
--  Le top des vendeurs


-- Voici le début de ce que vous devez obtenir.
-- ATTENTION à l'ordre des colonnes et leur nom!
-- +------+-------------+--------+
-- | idut | pseudout    | total  |
-- +------+-------------+--------+
-- |  257 | sonfanju131 | 434.00 |
-- |  740 | galy03      | 401.00 |
-- |   42 | buny        | 397.00 |
-- |  941 | mendujon    | 395.00 |
-- |  524 | kouroigo226 | 382.00 |
-- |  572 | panan142    | 365.00 |
-- |  779 | nauluran    | 335.00 |
-- |  925 | foitauny10  | 327.00 |
-- |  220 | jivogy276   | 318.00 |
-- |  188 | jyrau186    | 295.00 |
-- +------+-------------+--------+
-- = Reponse question 9.

-- je n'enleve pas le 0.05 que prend la VAE


select idUt,pseudoUt, sum(montant) as total
from OBJET
natural join UTILISATEUR natural join VENTE natural join PRIXVENTE
join STATUT on STATUT.idSt=VENTE.idSt
where nomSt="Validée" and year(finVe)=2023 and month(finVe)=1
group by idUt
order by total desc
LIMIT 10;

