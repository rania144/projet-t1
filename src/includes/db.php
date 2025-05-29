<?php
try {
    $pdo = new PDO("mysql:host=db;dbname=arcdata;charset=utf8", "root", "rootpass");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur de connexion à la base de données : " . $e->getMessage());
}
?>

