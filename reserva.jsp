<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reserva de Vehículo - MCM Servicios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h4 class="mb-0 text-center">Formulario de Reserva</h4>
                    </div>
                    <div class="card-body">
                        <% 
                            // Capturamos el ID de la camioneta que viene en la URL
                            String idCamioneta = request.getParameter("idCamioneta"); 
                        %>
                        
                        <!-- ESTE ES EL CARTEL QUE MOSTRARÁ EL ERROR SI LA CAMIONETA ESTÁ OCUPADA -->
                        <c:if test="${not empty errorFechas}">
                            <div class="alert alert-danger text-center fw-bold shadow-sm">
                                ${errorFechas}
                            </div>
                        </c:if>
                        
                        <!-- El formulario enviará los datos a un Servlet que crearemos después -->
                        <form action="ProcesarReservaServlet" method="POST">
                            
                            <!-- Guardamos el ID oculto para que Java sepa qué vehículo es -->
                            <input type="hidden" name="idCamioneta" value="<%= idCamioneta != null ? idCamioneta : "" %>">
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">ID del Vehículo seleccionado:</label>
                                <input type="text" class="form-control text-center bg-light" value="Vehículo #<%= idCamioneta != null ? idCamioneta : "No seleccionado" %>" disabled>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fechaInicio" class="form-label fw-bold">Fecha de Retiro:</label>
                                    <input type="date" class="form-control" id="fechaInicio" name="fechaInicio" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="fechaFin" class="form-label fw-bold">Fecha de Devolución:</label>
                                    <input type="date" class="form-control" id="fechaFin" name="fechaFin" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="observaciones" class="form-label fw-bold">Campamento / Proyecto:</label>
                                <input type="text" class="form-control" id="observaciones" name="observaciones" placeholder="Ej: Proyecto MARA - Andalgalá">
                            </div>

                            <button type="submit" class="btn btn-success w-100 mb-2">Confirmar Fechas y Reservar</button>
                            <a href="catalogo" class="btn btn-outline-secondary w-100">Cancelar y Volver</a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>