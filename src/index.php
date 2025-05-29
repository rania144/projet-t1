<?php include 'includes/db.php'; ?>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>ARC Data Shield - Cybersécurité Industrielle</title>
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <header>
    <h1>ARC Data Shield</h1>
    <nav>
      <a href="#">Accueil</a> |
      <a href="#">À propos</a> |
      <a href="#">Contact</a>
    </nav>
  </header>

  <main>
    <section>
      <h2>Bienvenue chez ARC Data Shield</h2>
      <p>Votre partenaire en cybersécurité industrielle.</p>
    </section>

    <section>
      <h2>Nos services</h2>
      <ul>
        <?php
        // Exemple simple : récupérer des services depuis la base (table services)
        try {
          $stmt = $pdo->query('SELECT name, description FROM services');
          while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
              echo '<li><strong>' . htmlspecialchars($row['name']) . '</strong><br>' . htmlspecialchars($row['description']) . '</li>';
          }
        } catch (Exception $e) {
          echo "<li>Impossible de récupérer les services.</li>";
        }
        ?>
      </ul>
    </section>
  </main>

  <footer>
    &copy; 2025 ARC Data Shield — Tous droits réservés
  </footer>
</body>
</html>

