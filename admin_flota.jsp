<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="com.mineriarental.modelo.Camioneta" %>
<%
    // Seguridad estricta: Solo administradores logueados
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuarioAdmin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>M.C.M. Servicios - Panel de Control de Flota</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root { --azul-mcm: #0b1d3a; --celeste-mcm: #0099ff; }
        .bg-mcm { background-color: var(--azul-mcm); }
        .text-mcm { color: var(--azul-mcm); }
        .btn-mcm { background-color: var(--celeste-mcm); color: white; font-weight: bold; }
        .btn-mcm:hover { background-color: #007acc; color: white; }
    </style>
</head>
<body class="bg-light">

    <!-- Barra de Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark shadow" style="background-color: #0b1d3a; border-bottom: 4px solid #0099ff;">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="index.html">
                <img src="<%=request.getContextPath()%>/img/pans.jpeg" alt="M.C.M. Servicios" width="45" height="40" class="me-2 rounded bg-white p-1 object-fit-contain">
                <div>
                    <h1 class="h5 mb-0 fw-bold text-white">M.C.M. SERVICIOS</h1>
                    <small class="text-info" style="font-size: 0.70rem;">PANEL ADMINISTRATIVO</small>
                </div>
            </a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="catalogo">Ver Catálogo</a></li>
                    <li class="nav-item"><a class="nav-link" href="cotizador.jsp">Cotizador PDF</a></li>
                    <li class="nav-item"><a class="nav-link btn btn-sm btn-outline-info ms-2 px-3 text-white fw-bold" href="AdminCamionetasServlet">Gestionar Flota</a></li>
                    <li class="nav-item"><a class="nav-link btn btn-sm btn-outline-warning ms-2 px-3 text-white fw-bold" href="LoginServlet">Cerrar Sesión</a></li>
                    
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row mb-4 align-items-center">
            <div class="col">
                <h2 class="fw-bold text-mcm">Gestión de Flota Vehicular</h2>
                <p class="text-muted">Agregue, modifique o elimine vehículos de la flota activa para faena.</p>
            </div>
        </div>

        <!-- Formulario para Agregar Nueva Camioneta -->
        <div class="card shadow-sm border-0 mb-5 p-4 bg-white">
            <h4 class="fw-bold mb-3 text-secondary">Registrar Nueva Camioneta</h4>
            <form action="AdminCamionetasServlet" method="POST">
                <input type="hidden" name="accion" value="insertar">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">Modelo / Versión:</label>
                        <input type="text" name="modelo" class="form-control" required placeholder="Ej. Toyota Hilux 2.8 TDI Minera">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold small">Tracción:</label>
                        <input type="text" name="traccion" class="form-control" required placeholder="Ej. 4x4 Off-Road">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold small">Patente / Dominio:</label>
                        <input type="text" name="patente" class="form-control" required placeholder="Ej. AF123CD">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold small">Estado:</label>
                        <select name="estado" class="form-select">
                            <option value="Disponible">Disponible</option>
                            <option value="En Faena">En Faena</option>
                            <option value="Mantenimiento">Mantenimiento</option>
                        </select>
                    </div>
                    <div class="col-12 mt-3">
                        <button type="submit" class="btn btn-mcm px-4">➕ Registrar Unidad en Flota</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Tabla de Unidades Registradas -->
        <div class="card shadow-sm border-0 p-4 bg-white">
            <h4 class="fw-bold mb-3 text-secondary">Listado Actual de Camionetas en Sistema</h4>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Modelo</th>
                            <th>Tracción</th>
                            <th>Patente</th>
                            <th>Estado</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Camioneta> lista = (List<Camioneta>) request.getAttribute("listaCamionetasAdmin");
                            if (lista != null && !lista.isEmpty()) {
                                for (Camioneta c : lista) {
                        %>
                                    <tr>
                                        <td><%= c.getIdCamioneta() %></td>
                                        <td class="fw-bold text-primary"><%= c.getModelo() %></td>
                                        <td><%= c.getTraccion() %></td>
                                        <td><code><%= c.getPatente() %></code></td>
                                        <td><span class="badge bg-success"><%= c.getEstado() %></span></td>
                                        <td class="text-center">
                                            <a href="AdminCamionetasServlet?accion=eliminar&id=<%= c.getIdCamioneta() %>" 
                                               class="btn btn-outline-danger btn-sm" 
                                               onclick="return confirm('¿Está seguro de dar de baja este vehículo de la flota?');">
                                                🗑️ Eliminar
                                            </a>
                                        </td>
                                    </tr>
                        <% 
                                }
                            } else { 
                        %>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">No hay camionetas registradas o cargadas actualmente.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>