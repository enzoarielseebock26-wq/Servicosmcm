<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Reservas - M.C.M. Servicios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <!-- Barra de Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark shadow sticky-top" style="background-color: #0b1d3a; border-bottom: 4px solid #0099ff;">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.html">M.C.M. SERVICIOS - Admin</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="AdminCamionetasServlet">Gestionar Flota</a></li>
                    <li class="nav-item"><a class="nav-link active" href="ReservasAdminServlet">Gestionar Reservas</a></li>
                    <li class="nav-item"><a class="nav-link" href="cotizador.jsp">Cotizador PDF</a></li>
                    <li class="nav-item"><a class="nav-link btn btn-sm btn-outline-warning ms-2 px-3 text-white fw-bold" href="login.jsp">Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="fw-bold mb-4" style="color: #0b1d3a;">Listado de Reservas Registradas</h2>
        
        <div class="card shadow border-0 p-4 bg-white">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Camioneta / Modelo</th>
                            <th>Patente</th>
                            <th>Desde</th>
                            <th>Hasta</th>
                            <th>Observaciones</th>
                            <th>Estado</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${reservas}">
                            <tr>
                                <td>${r.idReserva}</td>
                                <td class="fw-bold">${r.modeloCamioneta != null ? r.modeloCamioneta : 'Vehículo ID: '.concat(r.idCamioneta)}</td>
                                <td><span class="badge bg-secondary">${r.patenteCamioneta != null ? r.patenteCamioneta : 'N/D'}</span></td>
                                <td>${r.fechaInicio}</td>
                                <td>${r.fechaFin}</td>
                                <td class="small text-muted">${r.observaciones}</td>
                                <td>
                                    <span class="badge ${r.estado == 'Confirmada' ? 'bg-success' : 'bg-warning text-dark'}">
                                        ${r.estado}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <%-- Si la reserva ya está confirmada, mostramos un botón gris deshabilitado --%>
                                        <c:when test="${r.estado == 'Confirmada'}">
                                            <button class="btn btn-sm btn-secondary me-1" disabled>Confirmada</button>
                                        </c:when>
                                        <%-- Si no está confirmada, mostramos el botón verde --%>
                                        <c:otherwise>
                                            <a href="ReservasAdminServlet?accion=confirmar&id=${r.idReserva}" class="btn btn-sm btn-success me-1">Confirmar</a>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <a href="ReservasAdminServlet?accion=eliminar&id=${r.idReserva}" class="btn btn-sm btn-danger" onclick="return confirm('¿Estás seguro de eliminar esta reserva?');">Eliminar</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>