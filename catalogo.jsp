<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mineriarental.modelo.Camioneta"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo de Flota - M.C.M. Servicios S.A.</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <!-- Barra de Navegación con la identidad visual de M.C.M. SERVICIOS -->
    <nav class="navbar navbar-expand-lg navbar-dark shadow" style="background-color: #0b1d3a; border-bottom: 4px solid #0099ff;">
        <div class="container">
         <!-- Cambiamos href="catalogo" por href="index.html" (o href="./") -->
<a class="navbar-brand d-flex align-items-center" href="index.html">
    <img src="<%=request.getContextPath()%>/img/pans.jpeg" alt="M.C.M. Servicios" width="45" height="40" class="me-2 rounded bg-white p-1 object-fit-contain" onerror="this.style.display='none';">
    <div>
        <h1 class="h5 mb-0 fw-bold text-white" style="letter-spacing: 0.5px;">M.C.M. SERVICIOS</h1>
        <small class="text-info" style="font-size: 0.70rem; letter-spacing: 1.5px;">FLOTA & RESERVAS</small>
    </div>
</a>
            <div class="ms-auto d-flex gap-2 align-items-center">
                <a href="catalogo" class="btn btn-outline-light btn-sm">Catálogo</a>
                <a href="reservas" class="btn btn-sm fw-bold text-dark" style="background-color: #0099ff; border: none; color: white !important;">Ver Reservas</a>
                <li class="nav-item"><a class="nav-link btn btn-sm btn-outline-warning ms-2 px-3 text-white fw-bold" href="login.jsp">Panel Admin</a></li>
            </div>
        </div>
    </nav>

    <!-- Contenido Principal -->
   <div class="container my-5">
        <h2 class="mb-4 fw-bold text-dark">Nuestra Flota Disponible</h2>

        <div class="row">
            <% 
                // Recibimos la lista de camionetas que mandó el CatalogoServlet bajo el atributo "camionetas"
                List<Camioneta> lista = (List<Camioneta>) request.getAttribute("camionetas");
                if (lista != null && !lista.isEmpty()) {
                    for (Camioneta c : lista) {
            %>
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="card shadow-sm border-0 h-100">
                                
                                <!-- Imagen de la camioneta optimizada con ruta absoluta -->
                                <img src="<%=request.getContextPath()%>/img/hilux.jpg" 
                                     class="card-img-top object-fit-cover" 
                                     alt="Camioneta Minería" 
                                     style="height: 200px;" 
                                     onerror="this.src='<%=request.getContextPath()%>/img/pans.jpeg';">
                                
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title fw-bold text-primary"><%= c.getModelo() %></h5>
                                    <p class="card-text mb-1"><strong>Tracción:</strong> <%= c.getTraccion() %></p>
                                    <p class="card-text mb-2"><strong>Patente:</strong> <code><%= c.getPatente() %></code></p>
                                    <p class="card-text mb-3"><strong>Estado:</strong>  
                                        <span class="badge bg-success"><%= c.getEstado() %></span>
                                    </p>
                                    <!-- Botón de reserva -->
                                    <div class="mt-auto">
                                        <a href="reserva.jsp?idCamioneta=<%= c.getIdCamioneta() %>" class="btn btn-primary w-100 fw-bold">Reservar</a>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
            <% 
                    }
                  } else { 
            %>
                <div class="col-12">
                    <div class="alert alert-warning text-center py-4 shadow-sm">
                        <strong>Aviso:</strong> No hay vehículos registrados o el Servlet no pudo cargar la lista desde la base de datos.
                    </div>
                </div>
            <% 
                } 
            %>
        </div>
    </div>
    <!-- Sección de Trayectoria e Institucional -->
    <div class="container my-5" id="trayectoria">
        <div class="row align-items-center bg-white p-4 rounded shadow-sm border">
            <div class="col-md-7">
                <h3 class="fw-bold text-dark mb-3">Más de 3 años en alquiler de camionetas y módulos</h3>
                <p class="text-muted">
                    En <strong>M.C.M. Servicios S.A.</strong> nos especializamos en el alquiler estratégico de camionetas 4x4, vehículos de alta seguridad y equipamiento pesado para operaciones en cordillera y proyectos de exploración avanzada.
                </p>
                <p class="text-muted mb-0">
                    Garantizamos máxima disponibilidad mecánica, cumplimiento de normativas de seguridad industrial minera y soporte técnico en terreno 24/7.
                </p>
            </div>
            <div class="col-md-5 text-center mt-3 mt-md-0">
                <div class="p-3 bg-light rounded border">
                    <h5 class="fw-bold text-primary mb-1">+ Unidades</h5>
                    <small class="text-muted d-block mb-2">En flota activa</small>
                    <h5 class="fw-bold text-success mb-1">100% Certificadas</h5>
                    <small class="text-muted">Normas de seguridad minera</small>
                </div>
            </div>
        </div>
    </div>

</body>
</html>