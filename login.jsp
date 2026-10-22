<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>M.C.M. Servicios - Acceso Administrativo</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .login-card { border-top: 5px solid #0099ff; border-radius: 10px; }
        .btn-mcm { background-color: #0b1d3a; color: white; font-weight: bold; }
        .btn-mcm:hover { background-color: #0099ff; color: white; }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center vh-100">

    <div class="container" style="max-width: 400px;">
        <div class="text-center mb-4">
            <img src="<%=request.getContextPath()%>/img/pans.jpeg" alt="M.C.M. Servicios" width="70" height="60" class="rounded bg-white p-1 shadow-sm object-fit-contain mb-2">
            <h3 class="fw-bold" style="color: #0b1d3a;">M.C.M. SERVICIOS</h3>
            <p class="text-muted small">Panel de Gestión y Cotizaciones Mineras</p>
        </div>

        <div class="card shadow-sm border-0 login-card p-4 bg-white">
            <h5 class="fw-bold mb-3 text-secondary text-center">Acceso Administrador</h5>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2 small text-center"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="LoginServlet" method="POST">
                <div class="mb-3">
                    <label class="form-label fw-bold small">Usuario:</label>
                    <input type="text" name="usuario" class="form-control" required placeholder="Ej. admin">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold small">Contraseña:</label>
                    <input type="password" name="password" class="form-control" required placeholder="********">
                </div>
                <button type="submit" class="btn btn-mcm w-100 py-2 mt-2 shadow-sm">Ingresar al Sistema</button>
            </form>
            
            <div class="text-center mt-3">
                <a href="index.html" class="text-decoration-none small text-muted">&larr; Volver al inicio / catálogo</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>