-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema atelier
-- -----------------------------------------------------



-- -----------------------------------------------------
-- Schema atelier
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `atelier` DEFAULT CHARACTER SET utf8 ;
USE `atelier` ;

-- -----------------------------------------------------
-- Table `atelier`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atelier`.`client` (
  `id_client` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) NOT NULL,
  `telephone` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_client`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atelier`.`appareil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atelier`.`appareil` (
  `id_appareil` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(100) NULL,
  `marque` VARCHAR(100) NULL,
  `modele` VARCHAR(100) NULL,
  `numero_serie` VARCHAR(100) NULL,
  `id_client` INT NOT NULL,
  PRIMARY KEY (`id_appareil`),
  INDEX `fk_appareil_client1_idx` (`id_client` ASC) VISIBLE,
  CONSTRAINT `fk_appareil_client1`
    FOREIGN KEY (`id_client`)
    REFERENCES `atelier`.`client` (`id_client`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atelier`.`technicien`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atelier`.`technicien` (
  `id_technicien` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) NOT NULL,
  `specialite` VARCHAR(100) NULL,
  PRIMARY KEY (`id_technicien`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atelier`.`reparation`

-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atelier`.`reparation` (
  `id_reparation` INT NOT NULL AUTO_INCREMENT,
  `panne` TEXT NOT NULL,
  `date_depot` DATE NOT NULL,
  `statut` VARCHAR(30) NOT NULL,
  `id_appareil` INT NOT NULL,
  `id_technicien` INT NOT NULL,
  PRIMARY KEY (`id_reparation`),
  INDEX `fk_reparation_appareil1_idx` (`id_appareil` ASC) VISIBLE,
  INDEX `fk_reparation_technicien1_idx` (`id_technicien` ASC) VISIBLE,
  CONSTRAINT `fk_reparation_appareil1`
    FOREIGN KEY (`id_appareil`)
    REFERENCES `atelier`.`appareil` (`id_appareil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reparation_technicien1`
    FOREIGN KEY (`id_technicien`)
    REFERENCES `atelier`.`technicien` (`id_technicien`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atelier`.`intervention`;
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atelier`.`intervention` (
  `id_intervention` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(225) NULL,
  `cout` DECIMAL(10,2) NULL,
  `date_intervention` datetime NOT NULL DEFAULT current_timestamp(), -- Ajouté pour les étapes du metier
  `id_reparation` INT NOT NULL,
  PRIMARY KEY (`id_intervention`),
  INDEX `fk_intervention_reparation1_idx` (`id_reparation` ASC) VISIBLE,
  CONSTRAINT `fk_intervention_reparation1`
    FOREIGN KEY (`id_reparation`)
    REFERENCES `atelier`.`reparation` (`id_reparation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- ----------------------------------------
-- Table historique_statut  
-- ----------------------------------------
CREATE TABLE  if not exists`historique_statut` (
  `id_historique` int(11) NOT NULL AUTO_INCREMENT,
  `id_reparation` int(11) NOT NULL,
  `statut` int(11) NOT NULL,
  `date_changement` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_historique`),
  KEY `id_reparation` (`id_reparation`),
  CONSTRAINT `historique_statut_ibfk_1` 
  FOREIGN KEY (`id_reparation`) 
  REFERENCES `reparation` (`id_reparation`)
  ON DELETE CASCADE
) ENGINE=InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;