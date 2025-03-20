-- Creation de la base de donnees
CREATE DATABASE bibliotheque CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Utilisation de la base de donnees
USE bibliotheque;

-- Creation de la table adherents
CREATE TABLE adherents (
    id_adherent INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse VARCHAR(255),
    date_inscription DATE NOT NULL,
    a_surveiller BOOLEAN DEFAULT FALSE
);

-- Creation de la table livres
CREATE TABLE livres (
    isbn VARCHAR(20) PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(100) NOT NULL,
    annee_publication INT,
    disponible BOOLEAN DEFAULT TRUE
);

-- Creation de la table emprunts avec les contraintes de cles etrangères
CREATE TABLE emprunts (
    id_adherent INT,
    isbn VARCHAR(20),
    date_emprunt DATE NOT NULL,
    date_retour DATE,
    PRIMARY KEY (id_adherent, isbn, date_emprunt),
    FOREIGN KEY (id_adherent) REFERENCES adherents(id_adherent) ON DELETE CASCADE,
    FOREIGN KEY (isbn) REFERENCES livres(isbn) ON DELETE CASCADE
);

-- Creation de l'utilisateur bibliothecaire avec les droits sur la base
CREATE USER 'bibliothecaire'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON bibliotheque.* TO 'bibliothecaire'@'localhost';
FLUSH PRIVILEGES;

-- Ajout des adherents
INSERT INTO adherents (nom, adresse, date_inscription, a_surveiller) VALUES
('Jane Austen', '123 Rue des ecrivains, Paris', '2023-01-15', FALSE),
('Charles Dickens', '456 Avenue des Romans, Lyon', '2023-02-20', FALSE),
('Jules Verne', '789 Boulevard des Voyages, Nantes', '2023-03-10', FALSE),
('Mary Shelley', '101 Chemin du Gothique, Bordeaux', '2023-04-05', FALSE);

-- Ajout des livres
INSERT INTO livres (isbn, titre, auteur, annee_publication, disponible) VALUES
('9782253088127', 'Orgueil et Prejuges', 'Jane Austen', 1813, TRUE),
('9782070409228', 'David Copperfield', 'Charles Dickens', 1850, TRUE),
('9782253010944', 'Vingt mille lieues sous les mers', 'Jules Verne', 1870, TRUE),
('9782253082811', 'Frankenstein', 'Mary Shelley', 1818, TRUE);

-- Ajout des emprunts (chaque adherent emprunte chaque livre)
-- Les dates sont arbitraires mais logiques
INSERT INTO emprunts (id_adherent, isbn, date_emprunt, date_retour) VALUES
-- Jane Austen emprunte tous les livres
(1, '9782253088127', '2024-01-10', '2024-02-05'),
(1, '9782070409228', '2024-02-10', '2024-03-05'),
(1, '9782253010944', '2024-03-10', NULL),
(1, '9782253082811', '2024-01-15', '2024-02-10'),

-- Charles Dickens emprunte tous les livres
(2, '9782253088127', '2024-01-20', '2024-02-15'),
(2, '9782070409228', '2024-02-20', '2024-03-15'),
(2, '9782253010944', '2024-03-20', NULL),
(2, '9782253082811', '2023-12-10', NULL),

-- Jules Verne emprunte tous les livres
(3, '9782253088127', '2024-02-01', '2024-02-28'),
(3, '9782070409228', '2024-03-01', NULL),
(3, '9782253010944', '2024-01-05', '2024-02-01'),
(3, '9782253082811', '2024-02-15', NULL),

-- Mary Shelley emprunte tous les livres
(4, '9782253088127', '2024-01-25', '2024-02-20'),
(4, '9782070409228', '2024-02-25', NULL),
(4, '9782253010944', '2024-03-01', '2024-03-15'),
(4, '9782253082811', '2024-01-05', '2024-01-30');

-- Mise à jour de l'adresse de Charles Dickens après demenagement
UPDATE adherents SET adresse = '789 Avenue Victor Hugo, Marseille' WHERE id_adherent = 2;

-- Creation d'une vue pour afficher les livres en retard (plus de 30 jours)
CREATE VIEW livres_en_retard AS
SELECT 
    a.id_adherent,
    a.nom AS nom_adherent,
    l.isbn,
    l.titre,
    e.date_emprunt,
    DATEDIFF(CURRENT_DATE, e.date_emprunt) AS jours_empruntes
FROM 
    emprunts e
JOIN 
    adherents a ON e.id_adherent = a.id_adherent
JOIN 
    livres l ON e.isbn = l.isbn
WHERE 
    e.date_retour IS NULL 
    AND DATEDIFF(CURRENT_DATE, e.date_emprunt) > 30;

-- Creation du trigger pour mettre à jour la disponibilite d'un livre lors de son retour
DELIMITER //
CREATE TRIGGER update_livre_disponibilite AFTER UPDATE ON emprunts
FOR EACH ROW
BEGIN
    IF NEW.date_retour IS NOT NULL AND OLD.date_retour IS NULL THEN
        UPDATE livres SET disponible = TRUE WHERE isbn = NEW.isbn;
    END IF;
END //
DELIMITER ;

-- Creation d'une procedure stockee pour surveiller les adherents avec retards importants
DELIMITER //
CREATE PROCEDURE marquer_adherents_a_surveiller()
BEGIN
    UPDATE adherents a
    SET a.a_surveiller = TRUE
    WHERE a.id_adherent IN (
        SELECT DISTINCT e.id_adherent
        FROM emprunts e
        WHERE e.date_retour IS NULL
        AND DATEDIFF(CURRENT_DATE, e.date_emprunt) > 30
    );
END //
DELIMITER ;

-- Suppression de l'adherent Mary Shelley
DELETE FROM adherents WHERE id_adherent = 4;

-- Les champs sur lesquels mettre des index pour optimiser les requêtes
-- Ajout des index pertinents
CREATE INDEX idx_emprunts_date ON emprunts(date_emprunt, date_retour);
CREATE INDEX idx_livres_titre ON livres(titre, auteur);
CREATE INDEX idx_adherents_nom ON adherents(nom);

-- Requête pour anonymiser la base de donnees (conformite RGPD)
UPDATE adherents SET 
    nom = CONCAT('Anonyme_', id_adherent),
    adresse = NULL;

-- Requête pour supprimer toute la base de donnees
DROP DATABASE bibliotheque;
