<?php
session_start();
if (!isset($_SESSION["username"])) {
    header("Location: index.php");
    exit();
}
$username = $_SESSION["username"];
?>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        body {
            background: #e3f2fd;
            font-family: Arial, sans-serif;
        }

        .dashboard-container {
            width: 400px;
            margin: 100px auto;
            padding: 30px;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
        }

        a.logout-button {
            display: inline-block;
            padding: 10px 20px;
            background: #d32f2f;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }

        a.logout-button:hover {
            background: #b71c1c;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <h2>Bienvenido, <?php echo htmlspecialchars($username); ?> 🎉</h2>
        <p>Has iniciado sesión correctamente.</p>
        <a href="logout.php" class="logout-button">Cerrar sesión</a>
    </div>
</body>
</html>

