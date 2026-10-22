<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Seguridad: Verificar sesión de administrador
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
    <title>M.C.M. Servicios - Cotizador Minero Avanzado</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jsPDF para generar el PDF formal -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <style>
        :root {
            --azul-mcm: #0b1d3a;
            --celeste-mcm: #0099ff;
        }
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
                <img src="<%=request.getContextPath()%>/img/pans.jpeg" alt="M.C.M. Servicios" width="45" height="40" class="me-2 rounded bg-white p-1 object-fit-contain" onerror="this.style.display='none';">
                <div>
                    <h1 class="h5 mb-0 fw-bold text-white" style="letter-spacing: 0.5px;">M.C.M. SERVICIOS</h1>
                    <small class="text-info" style="font-size: 0.70rem; letter-spacing: 1.5px;">SOLUCIONES MINERAS</small>
                </div>
            </a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="catalogo">Catálogo</a></li>
                    <li class="nav-item"><a class="nav-link" href="reservas">Ver Reservas</a></li>
                    <li class="nav-item"><a class="nav-link btn btn-sm btn-outline-info ms-2 px-3 text-white fw-bold" href="AdminCamionetasServlet">Gestionar Flota</a></li>
                    <li class="nav-item"><a class="nav-link btn btn-sm btn-outline-warning ms-2 px-3 text-white fw-bold" href="LoginServlet">Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Contenido Principal -->
    <div class="container my-5">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-mcm">Generador de Cotizaciones Mineras Personalizadas</h2>
            <p class="text-muted">Seleccione los equipos, ajuste precios de manera manual y elija la moneda de comercialización[cite: 6].</p>
        </div>

        <div class="row g-4">
            <!-- Formulario de Configuración -->
            <div class="col-lg-7">
                <div class="card shadow-sm border-0 p-4 mb-4">
                    <h4 class="fw-bold mb-3 text-secondary">1. Datos Contractuales y Moneda</h4>
                    
                    <div class="row">
                        <div class="col-md-8 mb-3">
                            <label class="form-label fw-bold">Empresa / Proyecto Minero:</label>
                            <input type="text" id="cliente" class="form-control" placeholder="Ej. Minera Alumbrera - MARA S.A.[cite: 19, 20]">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Moneda:</label>
                            <select id="moneda" class="form-select fw-bold text-primary" onchange="calcularTotal()">
                                <option value="ARS">ARS ($)</option>
                                <option value="USD">USD (U$S)</option>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Faena / Destino:</label>
                            <input type="text" id="faena" class="form-control" placeholder="Ej. Campamento Alta Cordillera">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">N° de Cotización:</label>
                            <input type="text" id="nroCotizacion" class="form-control" value="COT-2026-102">
                        </div>
                    </div>
                </div>

                <!-- Selección de Vehículos / Módulos Base -->
                <div class="card shadow-sm border-0 p-4 mb-4">
                    <h4 class="fw-bold mb-3 text-secondary">2. Vehículos y Módulos Base</h4>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Seleccione Equipo Principal:</label>
                        <select id="equipo" class="form-select mb-2" onchange="actualizarPrecioBase()">
                            <option value="120000">Toyota Hilux 4x4 - Configuración Minera Off-Road[cite: 7]</option>
                            <option value="250000">Módulo Habitacional (Premium / Estándar / Plegable)[cite: 6, 8, 17]</option>
                            <option value="300000">Torre de Iluminación / Grupo Electrógeno Industrial</option>
                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Precio Unitario Diario (Manual):</label>
                            <input type="number" id="precioEquipo" class="form-control" value="120000" oninput="calcularTotal()">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Cantidad de Días:</label>
                            <input type="number" id="dias" class="form-control" value="10" min="1" oninput="calcularTotal()">
                        </div>
                    </div>
                </div>

                <!-- Ítems Adicionales del Folleto Oficial -->
                <div class="card shadow-sm border-0 p-4">
                    <h4 class="fw-bold mb-3 text-secondary">3. Equipamiento Adicional y Accesorios Mineros</h4>
                    <p class="text-muted small">Marque los ítems necesarios y edite sus precios unitarios de forma manual si lo requiere.</p>

                    <!-- Ítem 1 -->
                    <div class="row align-items-center mb-3 p-2 bg-light rounded">
                        <div class="col-md-7">
                            <div class="form-check">
                                <input class="form-check-input adicional" type="checkbox" id="chkChofer" checked onchange="calcularTotal()">
                                <label class="form-check-label fw-bold" for="chkChofer">Chofer Profesional Certificado Minería</label>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text">Precio/día</span>
                                <input type="number" id="precioChofer" class="form-control adicional-precio" value="18000" oninput="calcularTotal()">
                            </div>
                        </div>
                    </div>

                    <!-- Ítem 2 -->
                    <div class="row align-items-center mb-3 p-2 bg-light rounded">
                        <div class="col-md-7">
                            <div class="form-check">
                                <input class="form-check-input adicional" type="checkbox" id="chkJaula" checked onchange="calcularTotal()">
                                <label class="form-check-label fw-bold" for="chkJaula">Jaula Antivuelco Minera 4 Puntos + Baliza/Pértiga[cite: 9, 12]</label>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text">Precio/día</span>
                                <input type="number" id="precioJaula" class="form-control adicional-precio" value="12000" oninput="calcularTotal()">
                            </div>
                        </div>
                    </div>

                    <!-- Ítem 3 -->
                    <div class="row align-items-center mb-3 p-2 bg-light rounded">
                        <div class="col-md-7">
                            <div class="form-check">
                                <input class="form-check-input adicional" type="checkbox" id="chkSeguridad" checked onchange="calcularTotal()">
                                <label class="form-check-label fw-bold" for="chkSeguridad">Kit Seguridad Vehicular (Matafuego 5kg, Botiquín, Lingas)[cite: 9, 11]</label>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text">Precio/día</span>
                                <input type="number" id="precioSeguridad" class="form-control adicional-precio" value="8000" oninput="calcularTotal()">
                            </div>
                        </div>
                    </div>

                    <!-- Ítem 4 -->
                    <div class="row align-items-center mb-3 p-2 bg-light rounded">
                        <div class="col-md-7">
                            <div class="form-check">
                                <input class="form-check-input adicional" type="checkbox" id="chkGPS" checked onchange="calcularTotal()">
                                <label class="form-check-label fw-bold" for="chkGPS">Telemetría Avanzada, GPS & Antena Satelital (Pago Único)</label>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text">Precio Fijo</span>
                                <input type="number" id="precioGPS" class="form-control adicional-precio" value="35000" oninput="calcularTotal()">
                            </div>
                        </div>
                    </div>

                    <!-- Ítem 5 -->
                    <div class="row align-items-center mb-3 p-2 bg-light rounded">
                        <div class="col-md-7">
                            <div class="form-check">
                                <input class="form-check-input adicional" type="checkbox" id="chkAntiderrama" onchange="calcularTotal()">
                                <label class="form-check-label fw-bold" for="chkAntiderrama">Kit Antiderrama ME ZK2 (7 Artículos)[cite: 11]</label>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text">Precio/día</span>
                                <input type="number" id="precioAntiderrama" class="form-control adicional-precio" value="5000" oninput="calcularTotal()">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Resumen y Generación de PDF -->
            <div class="col-lg-5">
                <div class="card shadow border-0 p-4 bg-white sticky-top" style="top: 20px;">
                    <h4 class="fw-bold mb-3 text-mcm">Resumen Financiero</h4>
                    
                    <ul class="list-group list-group-flush mb-3">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            Subtotal Equipo Base:
                            <span id="lblBase" class="fw-bold">$0</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            Adicionales Seleccionados:
                            <span id="lblAdicionales" class="fw-bold">$0</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center fs-5 text-mcm fw-bold">
                            Total Estimado:
                            <span id="lblTotal">$0</span>
                        </li>
                    </ul>

                    <button onclick="generarPDFGerencial()" class="btn btn-mcm btn-lg w-100 py-3 shadow-sm mb-3">
                        📑 Generar Cotización PDF Ejecutiva
                    </button>
                    <small class="text-muted text-center">El PDF incluye logotipo oficial, desglose y datos de contacto de M.C.M. Servicios[cite: 4].</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Script de cálculo dinámico y exportación a PDF -->
    <script>
        function actualizarPrecioBase() {
            let selectEquipo = document.getElementById('equipo');
            document.getElementById('precioEquipo').value = selectEquipo.value;
            calcularTotal();
        }

        function calcularTotal() {
            let moneda = document.getElementById('moneda').value;
            let simbolo = moneda === 'ARS' ? '$' : 'USD ';
            
            let precioUnitario = parseFloat(document.getElementById('precioEquipo').value) || 0;
            let dias = parseInt(document.getElementById('dias').value) || 1;
            let base = precioUnitario * dias;
            
            let adicionales = 0;

            // Mapeo de adicionales
            let items = [
                { chk: 'chkChofer', val: 'precioChofer', esFijo: false },
                { chk: 'chkJaula', val: 'precioJaula', esFijo: false },
                { chk: 'chkSeguridad', val: 'precioSeguridad', esFijo: false },
                { chk: 'chkGPS', val: 'precioGPS', esFijo: true },
                { chk: 'chkAntiderrama', val: 'precioAntiderrama', esFijo: false }
            ];

            items.forEach(item => {
                let checkbox = document.getElementById(item.chk);
                let inputPrecio = document.getElementById(item.val);
                if (checkbox.checked) {
                    let valUnit = parseFloat(inputPrecio.value) || 0;
                    if (item.esFijo) {
                        adicionales += valUnit;
                    } else {
                        adicionales += valUnit * dias;
                    }
                }
            });

            let total = base + adicionales;

            document.getElementById('lblBase').innerText = simbolo + base.toLocaleString('es-CL');
            document.getElementById('lblAdicionales').innerText = simbolo + adicionales.toLocaleString('es-CL');
            document.getElementById('lblTotal').innerText = simbolo + total.toLocaleString('es-CL') + ' ' + moneda;
        }

        function generarPDFGerencial() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();

            let cliente = document.getElementById('cliente').value || 'Compañía Minera General S.A.';
            let faena = document.getElementById('faena').value || 'Faena Operativa Minera';
            let nroCot = document.getElementById('nroCotizacion').value || 'COT-2026-001';
            let moneda = document.getElementById('moneda').value;
            let simbolo = moneda === 'ARS' ? '$' : 'USD ';
            
            let selectEquipo = document.getElementById('equipo');
            let equipoTexto = selectEquipo.options[selectEquipo.selectedIndex].text.split(' - ')[0];
            let precioUnitario = parseFloat(document.getElementById('precioEquipo').value);
            let dias = document.getElementById('dias').value;
            let totalTexto = document.getElementById('lblTotal').innerText;

            // --- 1. MEMBRETE Y ENCABEZADO ---
            doc.setFillColor(11, 29, 58); // Azul institucional M.C.M.
            doc.rect(0, 0, 210, 42, 'F');

            try {
                let imgElement = document.querySelector('nav img');
                if (imgElement) {
                    let canvas = document.createElement('canvas');
                    canvas.width = imgElement.naturalWidth || 100;
                    canvas.height = imgElement.naturalHeight || 100;
                    let ctx = canvas.getContext('2d');
                    ctx.drawImage(imgElement, 0, 0);
                    let imgData = canvas.toDataURL('image/jpeg');
                    doc.addImage(imgData, 'JPEG', 15, 7, 26, 26);
                }
            } catch (e) {
                console.log("Logo cargado.");
            }

            doc.setTextColor(255, 255, 255);
            doc.setFontSize(16);
            doc.setFont(undefined, 'bold');
            doc.text("M.C.M. SERVICIOS", 48, 17);
            
            doc.setFontSize(8.5);
            doc.setFont(undefined, 'normal');
            doc.text("Soluciones Integrales para la Industria Minera e Industrial[cite: 6]", 48, 23);
            doc.text("Teléfono: 3835-522470 | Email: miguelcardozo@mcm-servicios.com[cite: 4]", 48, 29);
            doc.text("Aliados Estratégicos: MARA, Foraco, Ausenco, PyG[cite: 19, 20]", 48, 35);

            doc.setFontSize(10);
            doc.setFont(undefined, 'bold');
            doc.text("COTIZACIÓN OFICIAL", 195, 18, { align: 'right' });
            doc.setFontSize(9);
            doc.setFont(undefined, 'normal');
            doc.text("N° " + nroCot, 195, 24, { align: 'right' });
            doc.text("Moneda: " + moneda, 195, 30, { align: 'right' });

            // --- 2. DATOS DEL CLIENTE ---
            doc.setFillColor(245, 247, 250);
            doc.roundedRect(15, 48, 180, 22, 2, 2, 'F');

            doc.setTextColor(50, 50, 50);
            doc.setFontSize(9.5);
            doc.setFont(undefined, 'bold');
            doc.text("CLIENTE:", 20, 56);
            doc.setFont(undefined, 'normal');
            doc.text(cliente, 42, 56);

            doc.setFont(undefined, 'bold');
            doc.text("FAENA:", 120, 56);
            doc.setFont(undefined, 'normal');
            doc.text(faena, 138, 56);

            doc.setFont(undefined, 'bold');
            doc.text("VALIDEZ:", 20, 64);
            doc.setFont(undefined, 'normal');
            doc.text("15 días calendario", 42, 64);

            doc.setFont(undefined, 'bold');
            doc.text("SOPORTE:", 120, 64);
            doc.setFont(undefined, 'normal');
            doc.text("Asistencia técnica en terreno", 138, 64);

            // --- 3. TABLA DE DETALLE ---
            let startY = 78;
            doc.setFillColor(11, 29, 58);
            doc.rect(15, startY, 180, 7, 'F');
            
            doc.setTextColor(255, 255, 255);
            doc.setFontSize(8.5);
            doc.setFont(undefined, 'bold');
            doc.text("DESCRIPCIÓN DE EQUIPAMIENTO / ÍTEMS", 18, startY + 5);
            doc.text("CANT/PLAZO", 130, startY + 5);
            doc.text("SUBTOTAL", 168, startY + 5);

            // Fila Base
            startY += 7;
            doc.setFillColor(255, 255, 255);
            doc.setTextColor(40, 40, 40);
            doc.setFont(undefined, 'normal');
            doc.text("1. " + equipoTexto, 18, startY + 5);
            doc.text(dias + " días", 130, startY + 5);
            let subBase = precioUnitario * parseInt(dias);
            doc.text(simbolo + subBase.toLocaleString('es-CL'), 168, startY + 5);

            // Verificación de adicionales marcados
            let itemsCheck = [
                { chk: 'chkChofer', label: 'Chofer Profesional Certificado Minería', precioInput: 'precioChofer', esFijo: false },
                { chk: 'chkJaula', label: 'Jaula Antivuelco Minera 4 Puntos + Baliza/Pértiga[cite: 9, 12]', precioInput: 'precioJaula', esFijo: false },
                { chk: 'chkSeguridad', label: 'Kit Seguridad Vehicular (Matafuego 5kg, Lingas)[cite: 9, 11]', precioInput: 'precioSeguridad', esFijo: false },
                { chk: 'chkGPS', label: 'Telemetría Avanzada, GPS & Antena Satelital', precioInput: 'precioGPS', esFijo: true },
                { chk: 'chkAntiderrama', label: 'Kit Antiderrama ME ZK2 (7 Artículos)[cite: 11]', precioInput: 'precioAntiderrama', esFijo: false }
            ];

            let indexItem = 2;
            itemsCheck.forEach(item => {
                if (document.getElementById(item.chk).checked) {
                    startY += 7;
                    let valUnit = parseFloat(document.getElementById(item.precioInput).value) || 0;
                    let subItem = item.esFijo ? valUnit : (valUnit * parseInt(dias));
                    
                    doc.text(indexItem + ". " + item.label, 18, startY + 5);
                    doc.text(item.esFijo ? "Servicio" : (dias + " días"), 130, startY + 5);
                    doc.text(simbolo + subItem.toLocaleString('es-CL'), 168, startY + 5);
                    indexItem++;
                }
            });

            // --- 4. TOTALES ---
            startY += 12;
            doc.setLineWidth(0.3);
            doc.line(115, startY, 195, startY);

            startY += 7;
            doc.setFont(undefined, 'bold');
            doc.setFontSize(11);
            doc.setTextColor(11, 29, 58);
            doc.text("VALOR TOTAL:", 115, startY);
            doc.text(totalTexto, 195, startY, { align: 'right' });

            // --- 5. NOTAS Y FIRMA ---
            startY += 16;
            doc.setFontSize(8);
            doc.setTextColor(90, 90, 90);
            doc.setFont(undefined, 'bold');
            doc.text("ESTÁNDARES DE CALIDAD Y SEGURIDAD M.C.M.[cite: 6]:", 15, startY);
            doc.setFont(undefined, 'normal');
            let notas = [
                "- Equipamiento off-road y accesorios certificados para exigencia en alta cordillera.",
                "- Unidades provistas con elementos obligatorios de seguridad (matafuegos de 5kg, balizas, pértigas)[cite: 9, 11].",
                "- Precios expresados en la moneda seleccionada, sujetos a confirmación de stock por Orden de Compra."
            ];
            notas.forEach(nota => {
                startY += 4.5;
                doc.text(nota, 15, startY);
            });

            // Firma autorizada
            startY += 20;
            doc.setLineWidth(0.4);
            doc.line(130, startY, 195, startY);
            doc.setFont(undefined, 'bold');
            doc.setTextColor(50, 50, 50);
            doc.text("Miguel Cardozo", 162.5, startY + 4, { align: 'center' });
            doc.setFont(undefined, 'normal');
            doc.text("M.C.M. Servicios Mineros", 162.5, startY + 8.5, { align: 'center' });
            doc.text("Tel: 3835-522470[cite: 4]", 162.5, startY + 13, { align: 'center' });

            // Descargar archivo PDF
            doc.save("Cotizacion_MCM_" + nroCot + ".pdf");
        }

        // Ejecutar cálculo al iniciar
        calcularTotal();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>