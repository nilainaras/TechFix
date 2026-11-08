-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

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
  `client_id_client` INT NOT NULL,
  PRIMARY KEY (`id_appareil`),
  INDEX `fk_appareil_client1_idx` (`client_id_client` ASC) VISIBLE,
  CONSTRAINT `fk_appareil_client1`
    FOREIGN KEY (`client_id_client`)
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
  `appareil_id_appareil` INT NOT NULL,
  `technicien_id_technicien` INT NOT NULL,
  PRIMARY KEY (`id_reparation`),
  INDEX `fk_reparation_appareil1_idx` (`appareil_id_appareil` ASC) VISIBLE,
  INDEX `fk_reparation_technicien1_idx` (`technicien_id_technicien` ASC) VISIBLE,
  CONSTRAINT `fk_reparation_appareil1`
    FOREIGN KEY (`appareil_id_appareil`)
    REFERENCES `atelier`.`appareil` (`id_appareil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reparation_technicien1`
    FOREIGN KEY (`technicien_id_technicien`)
    REFERENCES `atelier`.`technicien` (`id_technicien`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atelier`.`intervention`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atelier`.`intervention` (
  `id_intervention` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(225) NULL,
  `cout` DECIMAL(10,2) NULL,
  `reparation_id_reparation` INT NOT NULL,
  `date_intervention` datetime NOT NULL DEFAULT current_timestamp(), -- Ajouté pour les étapes du metierintervention
  PRIMARY KEY (`id_intervention`),
  INDEX `fk_intervention_reparation1_idx` (`reparation_id_reparation` ASC) VISIBLE,
  CONSTRAINT `fk_intervention_reparation11`
    FOREIGN KEY (`reparation_id_reparation`)
    REFERENCES `atelier`.`reparation` (`id_reparation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;




-- -----------------------------------------------------
-- Table `atelier`.`historique_statut`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atelier`.`historique_statut` (
  `id_historique` INT NOT NULL AUTO_INCREMENT,
  `reparation_id_reparation` INT NOT NULL,
  `statut` VARCHAR(30) NOT NULL,
  `date_changement` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historique`),
  INDEX `fk_historique_reparation1_idx` (`reparation_id_reparation` ASC) VISIBLE,
  CONSTRAINT `fk_historique_reparation1`
    FOREIGN KEY (`reparation_id_reparation`)
    REFERENCES `atelier`.`reparation` (`id_reparation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;